Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB741FB4AB
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 16:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729474AbgFPOll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 10:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729337AbgFPOl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 10:41:29 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2718C061755;
        Tue, 16 Jun 2020 07:41:27 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id k11so21769401ejr.9;
        Tue, 16 Jun 2020 07:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t9VYpoFL9w8l3JM8D5Zcf8Ffo0yBSVNMWP1q8cMCzJA=;
        b=NqhQVfYqJPN5RJlZ0wjep6gjAzfZa9XL7ArMRoHeSS79eqmSg/OyEJU/35eT5EFwx2
         +DhP7rmZaD7BqG7H94kkFYld10FtWaUOd2hAw2KjGWyr/Bs7DkwQPc+PWm0xo8bFfJYA
         mKzXxSKXt1hYJVj6FS9rKT276fSm+vsbqN1MdKh3p4Ifw8dAib1DQ9IqPd8lf2csR0ae
         RN/ZPcqEwUR03DYrJpqINMhDc19gS4hCZCKWvLhW+8D49tPW1tzHJonv9HW974yEebQg
         dRlyCSoM0NRn2yHPk3TK1ES3fMxFswKBqNC2w45beDIN6Fvbvh/MaoPWtqNQKbWgNjaa
         aTeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t9VYpoFL9w8l3JM8D5Zcf8Ffo0yBSVNMWP1q8cMCzJA=;
        b=OLPuoBQk6VkP5DbZv6Dt9DCnquUwuF7lgFYgtwjCRgELMRBd2fqaiEzqZvw6H6ikO5
         DVypBjQZ7GSDZhuR/je9TcYXx6tguwr0mnNgsSJcq/U/PiXK0QfOI4is0oCoyC5m3BLU
         ip2ILuh9CcWpTO7h7R1spzl/McIQESBzdFHX10mwr4QO09UEi4izciJpgPfEetiXuTe4
         J90h1jDfak8ak3gtucKyM5cZstNCHwqgikoksAQQWrS1QEaRGCxRsFzBuRy85vwNH2Hp
         gwXF5fjvpEw3ReZpY2rBFsgMhHSpcjEzo0r5jgzOsGIlBPD0jUMmaOw0Z8N8pebO24yn
         wPiw==
X-Gm-Message-State: AOAM533Q2/+ZZQnAk9XjHNjaOBpvr7zscH2PILA9DWm+9MYlIGFMuCqF
        xtaxEIWBk4ZOA2/ZPHjumws=
X-Google-Smtp-Source: ABdhPJz3Z31JxPmZxR1T5GzJbWFj9vmA5JDpuiTPiN7c7MNeCKdEZoyaby8TTrav6F4+oVE/zvM+6w==
X-Received: by 2002:a17:907:b03:: with SMTP id h3mr3304855ejl.367.1592318486368;
        Tue, 16 Jun 2020 07:41:26 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id c17sm11264964eja.42.2020.06.16.07.41.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 07:41:25 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, joakim.tjernlund@infinera.com,
        madalin.bucur@oss.nxp.com, fido_max@inbox.ru,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 2/2] dpaa_eth: fix usage as DSA master, try 4
Date:   Tue, 16 Jun 2020 17:41:18 +0300
Message-Id: <20200616144118.3902244-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200616144118.3902244-1-olteanv@gmail.com>
References: <20200616144118.3902244-1-olteanv@gmail.com>
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

On T1040, the /sys/class/net/eth0 symlink currently points to:

../../devices/platform/ffe000000.soc/ffe400000.fman/ffe4e6000.ethernet/net/eth0

which pretty much illustrates the problem. The closest of_node we've got
is the "fsl,fman-memac" at /soc@ffe000000/fman@400000/ethernet@e6000,
which is what we'd like to be able to reference from DSA as host port.

For of_find_net_device_by_node to find the eth0 port, we would need the
parent of the eth0 net_device to not be the "dpaa-ethernet" platform
device, but to point 1 level higher, aka the "fsl,fman-memac" node
directly. The new sysfs path would look like this:

../../devices/platform/ffe000000.soc/ffe400000.fman/ffe4e6000.ethernet/dpaa-ethernet.0/net/eth0

Actually this has worked before, through the SET_NETDEV_DEV mechanism,
which sets the parent of the net_device as the parent of the platform
device. But the device which was set as sysfs parent was inadvertently
changed through commit 060ad66f9795 ("dpaa_eth: change DMA device"),
which did not take into consideration the effect it would have upon
of_find_net_device_by_node. So restore the old sysfs parent to make that
work correctly.

Fixes: 060ad66f9795 ("dpaa_eth: change DMA device")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index c4416a5f8816..2972244e6eb0 100644
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

