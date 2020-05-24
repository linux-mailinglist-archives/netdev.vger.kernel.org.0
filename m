Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155821E02F9
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 23:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387914AbgEXVXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 17:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387830AbgEXVXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 17:23:00 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91A2C061A0E
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 14:22:59 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id e10so13538777edq.0
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 14:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D3pq3R03dbYlTUEDx5HgZgfnsHyk0jaXY4nfm7XjFWg=;
        b=rZCep7v4Ux5VWSLEH2req3LrMMotB48ZIYadm1tCHl1s6XWRi6x561hCUiiB3c9FL0
         W/2vVTtO4F1z6zVgFdqaF2PDnHnTHv5o9nj0pVINg5uD1Svc00AN+HuUWSAdNRClSeKC
         fmoDhuBSAZnJPRiLiSgKER9crnwDz/RQUuSvqYkGW9XrrFTDEI3I6k6SWTXcRzax3NI0
         +g8jTNAhtj/wSzuhq5A1RbY8fgMe/ft7bMaMt0PDsT15rS8esvwoPofZfGJldR7oxsr2
         888gTpsRhw3RYYmwwy4zi8AlnnEEfHiAbpBQ92HOFRo2Azjrcx3M7xvHrRLgnyGiHwa6
         V8Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D3pq3R03dbYlTUEDx5HgZgfnsHyk0jaXY4nfm7XjFWg=;
        b=axe+h/dCZp//911AAQKvZQkgn8SRPpwAM6HKS1EdNfJpp9cuqJ95xGsdOPi2I+0UDa
         pyOTWgvG+XbARmM6TCWroQfxnroRF9JQkPImTV+JLq6T+Qz29acUBSUxnGQtHUm3s4mq
         JcJIvB9RBv9CwTZhwF6/8KE5M6C6U6UhGq8snGTtLUDk26cWa1pwmtu7m93ccGb6hxdK
         Z177J3PvvbZWw7xoiGf22XL0I55oGa7vwJ1Q4S4BNWbfGAPLb+hPLQQB2qd1XJN+lD1A
         k2cLAu/pC7MalfeAVYBF8DUVAuOMGW1k0lo0IE2KwlHQiSgT/GGCpaHSvL2TZxPjIeYm
         N1UQ==
X-Gm-Message-State: AOAM5318Fej1EN5uGgE9rCaGQsY/TtlzeDPDGY8yvkeFzcjNRQ/9Y5WL
        ok+RL6aNPaOjOWJSRzSYAT4=
X-Google-Smtp-Source: ABdhPJzj1iexyLvv8w1S3Us+fMfruNas+NPKF0k7Y4reVmMBtgxtoVW87PB+1SeJnOeaXqcH5yyXpg==
X-Received: by 2002:a05:6402:155:: with SMTP id s21mr12205834edu.144.1590355378279;
        Sun, 24 May 2020 14:22:58 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id z26sm13813618edr.85.2020.05.24.14.22.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2020 14:22:57 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        madalin.bucur@oss.nxp.com, netdev@vger.kernel.org
Subject: [PATCH] dpaa_eth: fix usage as DSA master, try 3
Date:   Mon, 25 May 2020 00:22:51 +0300
Message-Id: <20200524212251.3311546-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The dpaa-eth driver probes on compatible string for the MAC node, and
the fman/mac.c driver allocates a dpaa-ethernet platform device that
triggers the probing of the dpaa-eth net device driver.

All of this is fine, but the problem is that the struct device of the
dpaa_eth net_device is 2 parents away from the MAC which can be
referenced via of_node. So of_find_net_device_by_node can't find it, and
DSA switches won't be able to probe on top of FMan ports.

It would be a bit silly to modify a core function
(of_find_net_device_by_node) to look for dev->parent->parent->of_node
just for one driver. We're just 1 step away from implementing full
recursion.

Actually there have already been at least 2 previous attempts to make
this work:
- Commit a1a50c8e4c24 ("fsl/man: Inherit parent device and of_node")
- One or more of the patches in "[v3,0/6] adapt DPAA drivers for DSA":
  https://patchwork.ozlabs.org/project/netdev/cover/1508178970-28945-1-git-send-email-madalin.bucur@nxp.com/
  (I couldn't really figure out which one was supposed to solve the
  problem and how).

Point being, it looks like this is still pretty much a problem today.
On T1040, the /sys/class/net/eth0 symlink currently points to

../../devices/platform/ffe000000.soc/ffe400000.fman/ffe4e6000.ethernet/dpaa-ethernet.0/net/eth0

which pretty much illustrates the problem. The closest of_node we've got
is the "fsl,fman-memac" at /soc@ffe000000/fman@400000/ethernet@e6000,
which is what we'd like to be able to reference from DSA as host port.

For of_find_net_device_by_node to find the eth0 port, we would need the
parent of the eth0 net_device to not be the "dpaa-ethernet" platform
device, but to point 1 level higher, aka the "fsl,fman-memac" node
directly. The new sysfs path would look like this:

../../devices/platform/ffe000000.soc/ffe400000.fman/ffe4e6000.ethernet/net/eth0

And this is exactly what SET_NETDEV_DEV does. It sets the parent of the
net_device. The new parent has an of_node associated with it, and
of_dev_node_match already checks for the of_node of the device or of its
parent.

Fixes: a1a50c8e4c24 ("fsl/man: Inherit parent device and of_node")
Fixes: c6e26ea8c893 ("dpaa_eth: change device used")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 2cd1f8efdfa3..6bfa7575af94 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2914,7 +2914,7 @@ static int dpaa_eth_probe(struct platform_device *pdev)
 	}
 
 	/* Do this here, so we can be verbose early */
-	SET_NETDEV_DEV(net_dev, dev);
+	SET_NETDEV_DEV(net_dev, dev->parent);
 	dev_set_drvdata(dev, net_dev);
 
 	priv = netdev_priv(net_dev);
-- 
2.25.1

