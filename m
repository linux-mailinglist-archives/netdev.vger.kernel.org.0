Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCA69184112
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 07:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgCMGuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 02:50:13 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34054 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbgCMGuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 02:50:12 -0400
Received: by mail-pf1-f193.google.com with SMTP id 23so4646844pfj.1
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 23:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=jXL1TVGe2yVn+xDLmh3Qlm2F5L7TwyaCEaaqwo9LDBc=;
        b=mkyXS+ewRSTTDCXqmC8trqWAWHzO3vEtTlg9QRYI8bRXbF2tJ3EWKiswxoGXvvOFkr
         lnRBgDiG3uxZudkaffNqQ3Nyj1bzkyAXZosnAyJmGfVHBgI8cHh7ZSCsFndeG7yl1DXi
         khgoPyC9DiTv9/xLvRXDyHozUibfgoXIafIcA7cWxZqdy4aDQwbHjIsTfn2AH32uUsnu
         HFFfKI6HAb9mG7y5SecGXcoAr4pUQwp/IbUdY2wkvXNbdStDfzGSJkTp2nwRxF/KFbPs
         5M77CoDLZeHUpWxD/ejvygSTE2yuVGpdHGQBx4W6vliiEWv0v7526UTXMss4CwNRFtmZ
         RQXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jXL1TVGe2yVn+xDLmh3Qlm2F5L7TwyaCEaaqwo9LDBc=;
        b=pYc9YWaU553hmjowf3JMECdnkk+vAxxbeHkiqL/IlquHBq3iucmq3Noib9d+iyY2qB
         7BrvoZwpIF/3zQz5ZVtbu/I8uj3lLXa16Nu41t50HhzImzE5qJV17AWRvMRttlxdp2KB
         iyq1fDiWoM04fxhDpd+JapnvbSsa0uZQ8nR7S1NF4YEdJv0xN9ZcS9dmVaoDJvUQI8W3
         PBKVPEExrDMC1DoR+JOo2KSCwZte3vBfozt1HWatJ6TcCwKQgp/dKzvFH4ENDZDzhBKn
         5AGxDzCM1tJE6bvlDauTXvLHcw9jqWHtXCSAmSIDHrWiljLWT1Zlo1SjeA0Qeu9m6+y5
         Zldw==
X-Gm-Message-State: ANhLgQ1DRmlXcJXNErSTyEjBGJa7S9/LXnNfenCEzWl8Qj4ggStjxptH
        Np1EUcPcrTp93tRNrraUr5E=
X-Google-Smtp-Source: ADFU+vsM8F8xgj+4owofWbwJxLDhjxfrmP8ZxuNRILuQUctZMcP9fkYxLlshhPWc3K1dFA2C0NOG4Q==
X-Received: by 2002:a63:4c0b:: with SMTP id z11mr11628630pga.385.1584082211566;
        Thu, 12 Mar 2020 23:50:11 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id e30sm56398917pga.6.2020.03.12.23.50.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 23:50:10 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 0/3] hsr: fix several bugs in generic netlink callback
Date:   Fri, 13 Mar 2020 06:49:52 +0000
Message-Id: <20200313064952.32075-1-ap420073@gmail.com>
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

Change log:
v1->v2:
 - Preserve reverse christmas tree variable ordering in the second patch.

Taehee Yoo (3):
  hsr: use rcu_read_lock() in hsr_get_node_{list/status}()
  hsr: add restart routine into hsr_get_node_list()
  hsr: set .netnsok flag

 net/hsr/hsr_framereg.c |  9 ++----
 net/hsr/hsr_netlink.c  | 70 +++++++++++++++++++++++++-----------------
 2 files changed, 44 insertions(+), 35 deletions(-)

-- 
2.17.1

