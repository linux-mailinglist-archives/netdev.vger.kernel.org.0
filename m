Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8B18183EF0
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 03:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgCMCFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 22:05:18 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:40769 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgCMCFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 22:05:18 -0400
Received: by mail-pj1-f65.google.com with SMTP id bo3so2038564pjb.5
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 19:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=HpDOuMcCRcLTZFH/hpKp+fqeM40gOwAxs+7OCqXOwmY=;
        b=OTFv7Iw9oA8jt0WtV+uA17Ir6vd3r/nb/VO0U/vjyOd/lmY/DWjkw8h3qLTV7p6ciY
         gncWi2DrAeg75OlmorDtP0A0ALldvpoqqwrta27ggVUTyZZrU2bZ9XVdmyLlAVsnoc5K
         Pu5ar/UsN98M3hoLHXJUsxcLlBxAeng4DUujF76cxgnj1eSV/xmJr583tC2wG4grneDw
         CEX3i/k008V8qNaDPrNYZqGTy2xFwv/f2VmWpoCpofCYfv1fuy7LE3B372m/JHXMChdB
         2uRjFjHJLuLjeAjnpfphPkuKtb5M/N7mTAWjCCnkiE5pGe+UgISyO9KfNEPmh60r5rDQ
         +3Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HpDOuMcCRcLTZFH/hpKp+fqeM40gOwAxs+7OCqXOwmY=;
        b=mulr0jf9UxuihszFry5QupeVrUia7yIGhrrQZ7CRNWE84p5EQNBkjAtOTSWRLpu/vS
         wKo/ePiYpF3FWb9hNfS2GybkoBLYA34N9OPx9DJhCJq/k/d5k6tj7UaANTGqHL4nwiGx
         TivEsjV9lDj0Y7TGrUyDBNGKmYzuNWm/AqPYts3ftc0bGYE5F+X0FzRwAMPcJGBksFqv
         VEIBuDGxldAcKi0wPxBkHsZNwsFfZ/miX9Ke/+B2UhHOPd3cTQVrHQCCwE/ZfK4pqvbE
         a/YQ6JHfMGYkwOmIlFuTD/xzSyYBoG040kzJoCCzlTyE4EzVZo1ooxol+A28HmCWbB2o
         v10A==
X-Gm-Message-State: ANhLgQ3uWOngCDUnQe8AB2+/oHihiJ9wt8CVfRgNfdGox//sORk1YVxf
        WhCgEn5veIQR4iSMAO4sSF8=
X-Google-Smtp-Source: ADFU+vu4ocPOLBSeP9DHWkOSCisbVXL2pVW1tE91FU5fxb0cfmyvwHU4A9xYCrHCPqo0uXUnMX/hAg==
X-Received: by 2002:a17:90a:ab86:: with SMTP id n6mr5373255pjq.164.1584065117531;
        Thu, 12 Mar 2020 19:05:17 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id r14sm35816842pfh.119.2020.03.12.19.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 19:05:16 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 0/3] hsr: fix several bugs in generic netlink callback
Date:   Fri, 13 Mar 2020 02:05:02 +0000
Message-Id: <20200313020502.31341-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is to fix several bugs they are related in
generic netlink callback in hsr module.

1. The first patch is to add missing rcu_read_lock() in
hsr_get_node_{list/status}().
The hsr_get_node_{list/status}() are not protected by RTNL because
they are callback functions of generic netlink.
But it calls __dev_get_by_index() without acquiring RTNL.
So, it would use unsafe data.

2. The second patch is to avoid failure of hsr_get_node_list().
hsr_get_node_list() is a callback of generic netlink and
it is used to get node information in userspace.
But, if there are so many nodes, it fails because of buffer size.
So, in this patch, restart routine is added.

3. The third patch is to set .netnsok flag to true.
If .netnsok flag is false, non-init_net namespace is not allowed to
operate generic netlink operations.
So, currently, non-init_net namespace has no way to get node information
because .netnsok is false in the current hsr code.

Taehee Yoo (3):
  hsr: use rcu_read_lock() in hsr_get_node_{list/status}()
  hsr: add restart routine into hsr_get_node_list()
  hsr: set .netnsok flag

 net/hsr/hsr_framereg.c |  9 ++-----
 net/hsr/hsr_netlink.c  | 61 +++++++++++++++++++++++++++---------------
 2 files changed, 41 insertions(+), 29 deletions(-)

-- 
2.17.1

