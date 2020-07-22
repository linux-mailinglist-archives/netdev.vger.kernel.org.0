Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAB7622A0F7
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 22:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgGVUyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 16:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbgGVUyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 16:54:06 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181ACC0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 13:54:06 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id lx13so3778214ejb.4
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 13:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XPsTjTlVfEoFV1ZWOPRs0BZxOOtQmR2ulDOi0BNsFeo=;
        b=H7BOvNBeLG1Bmb1mfcbKc/04UkaX+X759xYLjqXQDPryxzJUSmyUNAf4oSRpd4qa7p
         DrNi9ZnQJIdywcR0uAA4HduWpqQztCrHvivxlEp+ONrQ+JygzhzUlFUsXAQT18XGvr2B
         hdYaegQLQduMRr6X3QHuH55m9jx9iQJPRMhCpb0HjElB/uuyxV2PnD/WuQunsbk/utl8
         OQ5gOLilHs6co2i6j/+Z+/PmCO790WABhVy98K1doeATzhdE47VUudk7XJvgOU9rXFI0
         Nq6PYgmcU7ySgPsqa0MQfq+iec++OSnVjisZxmBevSou0eaQsWHzFVnvEuo2+z6+IG8T
         sX4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XPsTjTlVfEoFV1ZWOPRs0BZxOOtQmR2ulDOi0BNsFeo=;
        b=PTySqTZpMQlM7cBxbKIgCbTEffyVwv5P8kZTs01RhL4Sx/2dMrkkZWhDXY8YRPRGhL
         fQua2inOMmBBLV6BOVzgYJgLD022D20c52F29nvTqxac20/6Qa+hog+wSR6oAM0lzeGM
         zXauBmXbcfK6KKYACJY5H48m0l2O85YMR56jbOmBhSiFkEy2kJm1rSFgNDYrlpX2hEkp
         4bcy0kKxIyVS+104dDHZsRiqF2B9lp3Kf3RLiVSyjYuu+o9pluxTNgnRna1x5rGuLu7K
         0JTOa8k5DatA3EWLpj7HaUwe+uRy9ns8SHcgFXdjbRSeKOwt1u3rVwS+dqOQRIw3FBNM
         mBcw==
X-Gm-Message-State: AOAM533n0FXo7IWeFW+PhRh3XyCkk4r7Azos8lHMe4K5PTDEQX21IP+1
        ECVbE1WrbMnQqOtOwY4JZkk=
X-Google-Smtp-Source: ABdhPJylwN/P7sRVuzzQARQ6W0Neeq0XCLgVcAeeF3T24iWHQQaaywYmmCVyk9jYQSv9D5UzxSMsZA==
X-Received: by 2002:a17:907:385:: with SMTP id ss5mr603214ejb.496.1595451244766;
        Wed, 22 Jul 2020 13:54:04 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id d19sm514871ejk.47.2020.07.22.13.54.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 13:54:04 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        jiri@mellanox.com, edumazet@google.com, ap420073@gmail.com,
        xiyou.wangcong@gmail.com, maximmi@mellanox.com, mkubecek@suse.cz,
        richardcochran@gmail.com
Subject: [PATCH net-next] net: restore DSA behavior of not overriding ndo_get_phys_port_name if present
Date:   Wed, 22 Jul 2020 23:53:48 +0300
Message-Id: <20200722205348.2688142-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prior to the commit below, dsa_master_ndo_setup() used to avoid
overriding .ndo_get_phys_port_name() unless the callback was empty.

https://elixir.bootlin.com/linux/v5.7.7/source/net/dsa/master.c#L269

Now, it overrides it unconditionally.

This matters for boards where DSA switches are hanging off of other DSA
switches, or switchdev interfaces.
Say a user has these udev rules for the top-level switch:

ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:00.5", DRIVERS=="mscc_felix", ATTR{phys_port_name}=="p0", NAME="swp0"
ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:00.5", DRIVERS=="mscc_felix", ATTR{phys_port_name}=="p1", NAME="swp1"
ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:00.5", DRIVERS=="mscc_felix", ATTR{phys_port_name}=="p2", NAME="swp2"
ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:00.5", DRIVERS=="mscc_felix", ATTR{phys_port_name}=="p3", NAME="swp3"
ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:00.5", DRIVERS=="mscc_felix", ATTR{phys_port_name}=="p4", NAME="swp4"
ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:00.5", DRIVERS=="mscc_felix", ATTR{phys_port_name}=="p5", NAME="swp5"

If the DSA switches below start randomly overriding
ndo_get_phys_port_name with their own CPU port, bad things can happen.
Not only may the CPU port number be not unique among different
downstream DSA switches, but one of the upstream switchdev interfaces
may also happen to have a port with the same number. So, we may even end
up in a situation where all interfaces of the top-level switch end up
having a phys_port_name attribute of "p0". Clearly not ok if the purpose
of the udev rules is to assign unique names.

Fix this by restoring the old behavior, which did not overlay this
operation on top of the DSA master logic, if there was one in place
already.

Fixes: 3369afba1e46 ("net: Call into DSA netdevice_ops wrappers")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
This is brain-dead, please consider killing this and retrieving the CPU
port number from "devlink port"...

pci/0000:00:00.5/0: type eth netdev swp0 flavour physical port 0
pci/0000:00:00.5/2: type eth netdev swp2 flavour physical port 2
pci/0000:00:00.5/4: type notset flavour cpu port 4
spi/spi2.0/0: type eth netdev sw0p0 flavour physical port 0
spi/spi2.0/1: type eth netdev sw0p1 flavour physical port 1
spi/spi2.0/2: type eth netdev sw0p2 flavour physical port 2
spi/spi2.0/4: type notset flavour cpu port 4
spi/spi2.1/0: type eth netdev sw1p0 flavour physical port 0
spi/spi2.1/1: type eth netdev sw1p1 flavour physical port 1
spi/spi2.1/2: type eth netdev sw1p2 flavour physical port 2
spi/spi2.1/3: type eth netdev sw1p3 flavour physical port 3
spi/spi2.1/4: type notset flavour cpu port 4

 net/core/dev.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 19f1abc26fcd..60778bd8c3b1 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8603,15 +8603,20 @@ int dev_get_phys_port_name(struct net_device *dev,
 	const struct net_device_ops *ops = dev->netdev_ops;
 	int err;
 
-	err  = dsa_ndo_get_phys_port_name(dev, name, len);
-	if (err == 0 || err != -EOPNOTSUPP)
-		return err;
-
 	if (ops->ndo_get_phys_port_name) {
 		err = ops->ndo_get_phys_port_name(dev, name, len);
 		if (err != -EOPNOTSUPP)
 			return err;
+	} else {
+		/* DSA may override this operation, but only if the master
+		 * isn't a switchdev or another DSA, in that case it breaks
+		 * their port numbering.
+		 */
+		err  = dsa_ndo_get_phys_port_name(dev, name, len);
+		if (err == 0 || err != -EOPNOTSUPP)
+			return err;
 	}
+
 	return devlink_compat_phys_port_name_get(dev, name, len);
 }
 EXPORT_SYMBOL(dev_get_phys_port_name);
-- 
2.25.1

