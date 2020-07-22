Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0660422A28F
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 00:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729565AbgGVWpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 18:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbgGVWpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 18:45:04 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DCF5C0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 15:45:04 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id d18so3019652edv.6
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 15:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3NgAR8ZC4EZlq0hNwLDSrYImwVCuOkHFnWxdi0KNK+c=;
        b=GFVPSWMVYF+6qiO9ahJN2eFJ/chWJ6HRyJVl0gAI42i9nprklsympml2Cjg+cdEmw2
         mxpY+NLVhNaZEZHEKMledId1Zg8Q3absmTiuAMKftIdWFr3XhjPBFAV9E5gj9iq5d+G2
         +aKVCYBd0bqhL6GG97CRWD5CQkrOCBQZPHxv4vdEXfyJOmZj16TsSszhgOIK4m7nZr0Y
         /IwZ+qXqnj4Y/09WRa+1i1K++Oyub05bIzxx3ja5A7KXvOf1sK3ep2kWgTpxYLLeMD3j
         xK0JzyZdUBqWU2lQUxx1idvHNVvBSp/aRJD6PmfGLFlnRfS9CpMR88yncKbaTOdySsm7
         5wPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3NgAR8ZC4EZlq0hNwLDSrYImwVCuOkHFnWxdi0KNK+c=;
        b=h4Vyv4kEjVm8ERmys/Xu8NJmKiyhKUvkNzlOHrET4waNy+n21aDYMuj7DazVYHf4Q4
         rUrOXY03cTzeB2JeNK4xP76rb7+qbuqfr2PmNwhRiCNO5joD1xGwjCaOvbiiHFiwnSsF
         upB+7JaumR6sDcrApxqe2ysYjXQZ/8ASxz9Xh1/qo6eUPfk3SsdI2ZelFG7plYneG564
         YjGGSyqCdGlczEJ+G5TdxaE+ctEFHMvdYWR6gOcZNvDTg38oG3WHGkJ6TCkncH89kq/b
         7srlRSMQc2q0IT+vG7bLSPMVLzRcaqjrGqd8iRDHTv6+TAei8Mqjplu1ct9jVpXlJDmL
         8zzw==
X-Gm-Message-State: AOAM531SdYWLxcLDbbR+wfUrIO8iuNYS/UdC3gjsxfxFNu1PT0pFQ9pH
        SJHBIynuBRE1pNg3YC6f7Qk=
X-Google-Smtp-Source: ABdhPJyoy9E0g0p8PcMUnfwJkFsAHoaPM9v3S+ZkkRZy39QeJwr/Cx1UxoVvQjFT7iUeSP+DEa2VNA==
X-Received: by 2002:a50:c044:: with SMTP id u4mr1645298edd.366.1595457902969;
        Wed, 22 Jul 2020 15:45:02 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id cz2sm738049edb.82.2020.07.22.15.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 15:45:02 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        jiri@mellanox.com, edumazet@google.com, ap420073@gmail.com,
        xiyou.wangcong@gmail.com, maximmi@mellanox.com, mkubecek@suse.cz,
        richardcochran@gmail.com
Subject: [PATCH net-next] net: dsa: stop overriding master's ndo_get_phys_port_name
Date:   Thu, 23 Jul 2020 01:43:12 +0300
Message-Id: <20200722224312.2719813-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of this override is to give the user an indication of what
the number of the CPU port is (in DSA, the CPU port is a hardware
implementation detail and not a network interface capable of traffic).

However, it has always failed (by design) at providing this information
to the user in a reliable fashion.

Prior to commit 3369afba1e46 ("net: Call into DSA netdevice_ops
wrappers"), the behavior was to only override this callback if it was
not provided by the DSA master.

That was its first failure: if the DSA master itself was a DSA port or a
switchdev, then the user would not see the number of the CPU port in
/sys/class/net/eth0/phys_port_name, but the number of the DSA master
port within its respective physical switch.

But that was actually ok in a way. The commit mentioned above changed
that behavior, and now overrides the master's ndo_get_phys_port_name
unconditionally. That comes with problems of its own, which are worse in
a way.

The idea is that it's typical for switchdev users to have udev rules for
consistent interface naming. These are based, among other things, on
the phys_port_name attribute. If we let the DSA switch at the bottom
to start randomly overriding ndo_get_phys_port_name with its own CPU
port, we basically lose any predictability in interface naming, or even
uniqueness, for that matter.

So, there are reasons to let DSA override the master's callback (to
provide a consistent interface, a number which has a clear meaning and
must not be interpreted according to context), and there are reasons to
not let DSA override it (it breaks udev matching for the DSA master).

But, there is an alternative method for users to retrieve the number of
the CPU port of each DSA switch in the system:

  $ devlink port
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

So remove this duplicated, unreliable and troublesome method. From this
patch on, the phys_port_name attribute of the DSA master will only
contain information about itself (if at all). If the users need reliable
information about the CPU port they're probably using devlink anyway.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
This is the moral v2 of
https://patchwork.ozlabs.org/project/netdev/patch/20200722205348.2688142-1-olteanv@gmail.com/

 include/net/dsa.h | 23 -----------------------
 net/core/dev.c    |  5 -----
 net/dsa/master.c  | 12 ------------
 3 files changed, 40 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 8b4a0f6a017c..42592b250778 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -94,8 +94,6 @@ struct dsa_device_ops {
 struct dsa_netdevice_ops {
 	int (*ndo_do_ioctl)(struct net_device *dev, struct ifreq *ifr,
 			    int cmd);
-	int (*ndo_get_phys_port_name)(struct net_device *dev, char *name,
-				      size_t len);
 };
 
 #define DSA_TAG_DRIVER_ALIAS "dsa_tag-"
@@ -740,33 +738,12 @@ static inline int dsa_ndo_do_ioctl(struct net_device *dev, struct ifreq *ifr,
 
 	return ops->ndo_do_ioctl(dev, ifr, cmd);
 }
-
-static inline int dsa_ndo_get_phys_port_name(struct net_device *dev,
-					     char *name, size_t len)
-{
-	const struct dsa_netdevice_ops *ops;
-	int err;
-
-	err = __dsa_netdevice_ops_check(dev);
-	if (err)
-		return err;
-
-	ops = dev->dsa_ptr->netdev_ops;
-
-	return ops->ndo_get_phys_port_name(dev, name, len);
-}
 #else
 static inline int dsa_ndo_do_ioctl(struct net_device *dev, struct ifreq *ifr,
 				   int cmd)
 {
 	return -EOPNOTSUPP;
 }
-
-static inline int dsa_ndo_get_phys_port_name(struct net_device *dev,
-					     char *name, size_t len)
-{
-	return -EOPNOTSUPP;
-}
 #endif
 
 void dsa_unregister_switch(struct dsa_switch *ds);
diff --git a/net/core/dev.c b/net/core/dev.c
index 19f1abc26fcd..062a00fdca9b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -98,7 +98,6 @@
 #include <net/busy_poll.h>
 #include <linux/rtnetlink.h>
 #include <linux/stat.h>
-#include <net/dsa.h>
 #include <net/dst.h>
 #include <net/dst_metadata.h>
 #include <net/pkt_sched.h>
@@ -8603,10 +8602,6 @@ int dev_get_phys_port_name(struct net_device *dev,
 	const struct net_device_ops *ops = dev->netdev_ops;
 	int err;
 
-	err  = dsa_ndo_get_phys_port_name(dev, name, len);
-	if (err == 0 || err != -EOPNOTSUPP)
-		return err;
-
 	if (ops->ndo_get_phys_port_name) {
 		err = ops->ndo_get_phys_port_name(dev, name, len);
 		if (err != -EOPNOTSUPP)
diff --git a/net/dsa/master.c b/net/dsa/master.c
index 0c980b2c48c9..6189c4dca6bc 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -186,17 +186,6 @@ static void dsa_master_get_strings(struct net_device *dev, uint32_t stringset,
 	}
 }
 
-static int dsa_master_get_phys_port_name(struct net_device *dev,
-					 char *name, size_t len)
-{
-	struct dsa_port *cpu_dp = dev->dsa_ptr;
-
-	if (snprintf(name, len, "p%d", cpu_dp->index) >= len)
-		return -EINVAL;
-
-	return 0;
-}
-
 static int dsa_master_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
 	struct dsa_port *cpu_dp = dev->dsa_ptr;
@@ -228,7 +217,6 @@ static int dsa_master_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 
 static const struct dsa_netdevice_ops dsa_netdev_ops = {
 	.ndo_do_ioctl = dsa_master_ioctl,
-	.ndo_get_phys_port_name = dsa_master_get_phys_port_name,
 };
 
 static int dsa_master_ethtool_setup(struct net_device *dev)
-- 
2.25.1

