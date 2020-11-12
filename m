Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0C72AFD06
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 02:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbgKLBc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 20:32:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728070AbgKLAb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 19:31:56 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393B1C0617A6
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 16:31:56 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id w6so2893517pfu.1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 16:31:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B0ijZH9WOpOwBydvyI7ySw7yOS/FuDO5HArvaoRAty8=;
        b=F/SzlSU85MJJzVyrlpu4g+UMfRiwoNFEUh6AUgdFndSk9OnGcoYwvjlvTc90aaGfBb
         5ujeZqCkK1cF22KpLNBPRXjEDev0/1zJj//u2IgFTUot64xIqbfsAMmnOYBL6cxnlJR4
         PecAVGfakNiIK8AeQaS1xnCgJ3tmbvvkLJruxnM/5IKSruqNrYHqW583VA4EA0p5L+FS
         G2racKiwGOr+fV0dSs4Qx0uqKvOfjoJ67rb83/UD4dTkVPWml0WQztxW+hFb/OSIQ8DW
         RCmi+5HcAj5BRkt5U5f+lRCM9ikBa/D2ROODkhBwg6CNArM7NdjDu0AQPuJBGAJUT85y
         iCcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=B0ijZH9WOpOwBydvyI7ySw7yOS/FuDO5HArvaoRAty8=;
        b=EMyvCIOj1zJIO9ffyY7k+n2D57isu89SShqgGAhr5g+yNl3WHOZ2CRfsLVuJESfbjk
         NIa6CB+3NZk//SpHvWtnwy23T/2EGhgTW0MyWfU/L94zg69J2xBtV3NLXicYqOyNtBEI
         /8Ws8EH4SQEZrueBO3tUfsJUnTA9fMoWV+/KtwFskDeXOtR4Hory5eV3HzYp442D79GJ
         DL2jl2xxFG7UH+qYTn4xhRYesRq5Es4sreb9BM8812Y9qKr6+0bSdiFNU75GqE0G21tM
         +kz01C5APCkjUYR4cCxVhZLpxjGWraD8E9DMGMAxHNPtljbr9Dsd1omJgD7tW8ywdQKG
         HWmw==
X-Gm-Message-State: AOAM531LO43RgfG/UbJ18EINy4WWeYlB4YvxZMNsDW8W53TFjXUelKp3
        m+xh7usI12B0v77sI5dSnoA=
X-Google-Smtp-Source: ABdhPJwz8IpDLIqn2QKnEYNxiHDByfDb3GprIPiUgHG5gsU4qzx1RtwveVv8QHuQoSTvx5J7Lv9tuA==
X-Received: by 2002:a63:3c10:: with SMTP id j16mr3242669pga.140.1605141115680;
        Wed, 11 Nov 2020 16:31:55 -0800 (PST)
Received: from localhost.localdomain ([45.124.203.14])
        by smtp.gmail.com with ESMTPSA id y19sm3889067pfn.147.2020.11.11.16.31.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 16:31:53 -0800 (PST)
Sender: "joel.stan@gmail.com" <joel.stan@gmail.com>
From:   Joel Stanley <joel@jms.id.au>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Andrew Jeffery <andrew@aj.id.au>,
        Ivan Mikhaylov <i.mikhaylov@yadro.com>, netdev@vger.kernel.org
Subject: [PATCH] net: ftgmac100: Fix crash when removing driver
Date:   Thu, 12 Nov 2020 11:01:45 +1030
Message-Id: <20201112003145.831169-1-joel@jms.id.au>
X-Mailer: git-send-email 2.28.0
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
 drivers/net/ethernet/faraday/ftgmac100.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 983b6db2d80d..4edccba5e2a8 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1945,6 +1945,8 @@ static int ftgmac100_remove(struct platform_device *pdev)
 	netdev = platform_get_drvdata(pdev);
 	priv = netdev_priv(netdev);
 
+	if (priv->ndev)
+		ncsi_unregister_dev(priv->ndev);
 	unregister_netdev(netdev);
 
 	clk_disable_unprepare(priv->rclk);
-- 
2.28.0

