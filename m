Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEF682B3BD2
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 04:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgKPD12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 22:27:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgKPD12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 22:27:28 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EBD0C0613CF
        for <netdev@vger.kernel.org>; Sun, 15 Nov 2020 19:27:28 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id cp9so7714708plb.1
        for <netdev@vger.kernel.org>; Sun, 15 Nov 2020 19:27:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G5/TpjKSiRo+4flkqwySOhTPBGKe6xNgV7gAHL7oQNY=;
        b=I3SZRluVKkKNEcD3waFKsLvu6K3cmY/43t3IBcMPY6uE3B9hfJKTQtlpiIOBJEtvdL
         /8EzkLTL1RIUt8mSNVl8Afd7GJDpFS17YwMPwVTKzw9+KZIvCfM85+AIO04nKl8hnhgb
         afpqisEAdeIOW1YgY0jOlqC5i/YAl/lnRNWdVt5V211SZZCt5dyZ/tn/UIsJtYHczYBx
         2YSCQQZOkMkrg/WyftMbBypw1wvQK8RbbyF2tmbR5G7R6gJTBaKFuRVa/xlRDRtZ9UiK
         7QWSdACt8ymZ9DnwYBLhRiv95aox2VLFyc3fK4N4RtnjyNBVgOq0Yey7j35Jk2UK1kd+
         WSsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=G5/TpjKSiRo+4flkqwySOhTPBGKe6xNgV7gAHL7oQNY=;
        b=svcUbe5+Mn9oWdCRXInJH/Po4VPNY890kZV2BZQANDCikvE59c+5V4MBx5kr30rLlj
         Gj74OXP5eVXTefPAQ+l2ZQZiAzhZsbZnWaYs3FCzokeuARsNlDk44j428pcPZb0yzlfX
         7ThLQ0klLudaMT7pKGgQv3VsKmyVwXTWO9x4PipfBmzSDZxO7MjWzjbu0FMSOSEEy2YK
         8pzbzVvUSckMAfIt+2mYMn5j0g7Az0HKhzeS/XMjdbzYzPt/S58lUUCYfrb2OAeU4tKm
         Ta1qiO4WwfXNAa0lLye6ini8y/Qt/m0Nk5WgawbQ76xQ14/lCo3MK1b04wFZtjPKTIU3
         xvlA==
X-Gm-Message-State: AOAM532wXYHOIDDpwLNOHV4CqBlz462CFDP6ITTWIKzcdOe3gnQvyAIM
        BrvfLCSE+oOITIOoffddwlo=
X-Google-Smtp-Source: ABdhPJyVpRbHYEVg/qqLX3WlD+GSzq9npuzpEaeS7xStxNhFhkU6ZJjRyvGQXS5e/4L16Tl1fJonsg==
X-Received: by 2002:a17:902:8c90:b029:d6:d3b4:7da8 with SMTP id t16-20020a1709028c90b02900d6d3b47da8mr11759357plo.34.1605497247690;
        Sun, 15 Nov 2020 19:27:27 -0800 (PST)
Received: from localhost.localdomain ([45.124.203.19])
        by smtp.gmail.com with ESMTPSA id w15sm1612760pgi.20.2020.11.15.19.27.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 19:27:26 -0800 (PST)
Sender: "joel.stan@gmail.com" <joel.stan@gmail.com>
From:   Joel Stanley <joel@jms.id.au>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Jeffery <andrew@aj.id.au>,
        Ivan Mikhaylov <i.mikhaylov@yadro.com>, netdev@vger.kernel.org
Subject: [PATCH v2] net: ftgmac100: Fix crash when removing driver
Date:   Mon, 16 Nov 2020 13:57:15 +1030
Message-Id: <20201116032715.1011071-1-joel@jms.id.au>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When removing the driver we would hit BUG_ON(!list_empty(&dev->ptype_specific))
in net/core/dev.c due to still having the NC-SI packet handler
registered.

 # echo 1e660000.ethernet > /sys/bus/platform/drivers/ftgmac100/unbind
  ------------[ cut here ]------------
  kernel BUG at net/core/dev.c:10254!
  Internal error: Oops - BUG: 0 [#1] SMP ARM
  CPU: 0 PID: 115 Comm: sh Not tainted 5.10.0-rc3-next-20201111-00007-g02e0365710c4 #46
  Hardware name: Generic DT based system
  PC is at netdev_run_todo+0x314/0x394
  LR is at cpumask_next+0x20/0x24
  pc : [<806f5830>]    lr : [<80863cb0>]    psr: 80000153
  sp : 855bbd58  ip : 00000001  fp : 855bbdac
  r10: 80c03d00  r9 : 80c06228  r8 : 81158c54
  r7 : 00000000  r6 : 80c05dec  r5 : 80c05d18  r4 : 813b9280
  r3 : 813b9054  r2 : 8122c470  r1 : 00000002  r0 : 00000002
  Flags: Nzcv  IRQs on  FIQs off  Mode SVC_32  ISA ARM  Segment none
  Control: 00c5387d  Table: 85514008  DAC: 00000051
  Process sh (pid: 115, stack limit = 0x7cb5703d)
 ...
  Backtrace:
  [<806f551c>] (netdev_run_todo) from [<80707eec>] (rtnl_unlock+0x18/0x1c)
   r10:00000051 r9:854ed710 r8:81158c54 r7:80c76bb0 r6:81158c10 r5:8115b410
   r4:813b9000
  [<80707ed4>] (rtnl_unlock) from [<806f5db8>] (unregister_netdev+0x2c/0x30)
  [<806f5d8c>] (unregister_netdev) from [<805a8180>] (ftgmac100_remove+0x20/0xa8)
   r5:8115b410 r4:813b9000
  [<805a8160>] (ftgmac100_remove) from [<805355e4>] (platform_drv_remove+0x34/0x4c)

Fixes: bd466c3fb5a4 ("net/faraday: Support NCSI mode")
Signed-off-by: Joel Stanley <joel@jms.id.au>
---
v2: Also unregister in _probe

 drivers/net/ethernet/faraday/ftgmac100.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 983b6db2d80d..88bfe2107938 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1926,6 +1926,8 @@ static int ftgmac100_probe(struct platform_device *pdev)
 err_phy_connect:
 	ftgmac100_phy_disconnect(netdev);
 err_ncsi_dev:
+	if (priv->ndev)
+		ncsi_unregister_dev(priv->ndev);
 	ftgmac100_destroy_mdio(netdev);
 err_setup_mdio:
 	iounmap(priv->base);
@@ -1945,6 +1947,8 @@ static int ftgmac100_remove(struct platform_device *pdev)
 	netdev = platform_get_drvdata(pdev);
 	priv = netdev_priv(netdev);
 
+	if (priv->ndev)
+		ncsi_unregister_dev(priv->ndev);
 	unregister_netdev(netdev);
 
 	clk_disable_unprepare(priv->rclk);
-- 
2.29.2

