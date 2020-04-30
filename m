Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9841C051C
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 20:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgD3StR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 14:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgD3StR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 14:49:17 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B1FC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 11:49:17 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id n24so2588937plp.13
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 11:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=mlSl1EwGWnXI/c2X4z/mFFvl3Ll7jFSDLC+Kh4hCLsc=;
        b=U0g6gvg+gppOfMT38WnxYyC9n0CqaNhuhNwhDOeCGKSaRJFjNvOrJCpqBS6tYFPUB2
         hEi/vhOCa+E3IX9qD4nMGpI2So27LSq8yylUQxMQD30uHRKyGEgJMj+DzT3oyPIkdonj
         03FLP/lZcRkDnCFCtiq2QKEzht56Ns3dIB8itz5Gbg4xO0bBXBFuQN4QGGzm2npGLcyM
         m/fPhlvhX/8Aly412sb2rPnTFgpGVO16fGSp88Uyae8q7j4zXNKYG6X4tYvsczsOVRX/
         fHcJ+gsMXN+uSb0WhkA4eul4g/vN+8K7NazHsTrNdBMqc6mhUrfMbYZF/wAKYwbBRCDI
         2RZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mlSl1EwGWnXI/c2X4z/mFFvl3Ll7jFSDLC+Kh4hCLsc=;
        b=rfDsgRklZCN3u11BBk9iGsTD8f0EkLTsIXJ9Tcbq6R25wrTtygaJ1TrcBwRFEX9k3s
         DSlqXeB696RZmltW8my1Z0bCg7/PnjNTRQpnOHbRscAIAzW99PuSnP4bFLw0i/MDjrEY
         +OGG4TljjIt/4THN046buoBns5/v7TvslKg6lLOWOL0ECFP7t/keWhsF8VbRjCoot0kD
         j8rlKfH6f2xmEG2Vov6XsbB2ayw/F61K03j6lYAcXQ8a546QfQN3GWbsIgbJ3aeOS2nS
         GmCRz4KZcryyvZGWgecdNymUBVtD42HU3WD1XVvlziB+kn/DNZLfxP098mLfwLHqqCpq
         bn3A==
X-Gm-Message-State: AGi0PuYE41LBjDQ/fIYVWmpGuv+rGmrQofAfn85cKSbISjEGTCF0WN6l
        ltvCrgfswEtE+7eEbELFFX71LKtB
X-Google-Smtp-Source: APiQypLBDNGq9ScZtjKUlKigGT8BDrKR5+xtgDqX2xmDML2IaxmT4iyu70lGANZgIDXnT2rM7PHlbQ==
X-Received: by 2002:a17:90a:276a:: with SMTP id o97mr199325pje.194.1588272556050;
        Thu, 30 Apr 2020 11:49:16 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a23sm426886pfo.145.2020.04.30.11.49.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 11:49:15 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org
Subject: [PATCH net-next 0/4] net: dsa: b53: ARL improvements
Date:   Thu, 30 Apr 2020 11:49:07 -0700
Message-Id: <20200430184911.29660-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

This patch series improves the b53 driver ARL search code by
renaming the ARL entries to be reflective of what they are: bins, and
then introduce the number of buckets so we can properly bound check ARL
searches.

The final patch removes an unused argument.

Florian Fainelli (4):
  net: dsa: b53: Rename num_arl_entries to num_arl_bins
  net: dsa: b53: Provide number of ARL buckets
  net: dsa: b53: Bound check ARL searches
  net: dsa: b53: Remove is_static argument to b53_read_op()

 drivers/net/dsa/b53/b53_common.c | 81 ++++++++++++++++++++------------
 drivers/net/dsa/b53/b53_priv.h   |  8 +++-
 2 files changed, 58 insertions(+), 31 deletions(-)

-- 
2.17.1

