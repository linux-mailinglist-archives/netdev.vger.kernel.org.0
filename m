Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87C1E6D7465
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 08:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236999AbjDEGbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 02:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbjDEGbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 02:31:49 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8F430ED
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 23:31:47 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id h14so16952137ilj.0
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 23:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680676307;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BLvDTEE/530Yby/LivmClwoLh0lmaDCct+VjUBSu2Js=;
        b=NDX6bflE+O8K255gE7wg8xDh+Q7NOdZKkz4LcnTnL7cEvUgBHyd4tEJyarwSYK3ZT9
         jTX/0DokPg2mmCQ3VVxOh2efFjuDpnvo8tmVOButboe4gBHSclyELPKVG+eh2bRVQnUD
         ptwBdAEILpih8DbfOCtLAnj3hTHByuJb2tFyHr0sRgPuFCxkBWIPQFk+YYyUYez1r3UX
         vMOir5Fk2KBYymaphstaFYt73uAHY6jEUGsJIy1+rhe882Nw4FxrQsu2fru+wJfX5N4w
         l9RpESZ8SJHDnV/EITfatqdxzjrgoAHCFG0GiBp59667nSZ9IMqa9p+7P0RL0Gt4ajnK
         Vfig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680676307;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BLvDTEE/530Yby/LivmClwoLh0lmaDCct+VjUBSu2Js=;
        b=dQAFXhtdJXEhXt6B5XAYTORG2JZl5JzZp9IF9+ZGgF/7gQfZiRq6NOAFoJOqH1nCYX
         wgdNGeSZ8vVlfe+04rDpznkEiqLMskcPCIb0j105LcmZ2YjIk1fy4KSoa8kSHX8fvWmE
         7Z+jpzzhY8M2X2+vlqbd9sFCEuFm+l2hd54iVb6Q0lRlUR8Dnz0IzGqx9vk7yp7ikkrK
         ol7JwSC/wen6V2G6OIdu/f+4P5QIgZD93OraF5bfSGlxVcxtkR7Y9L2O7CFviiUzdLVp
         HY/I9+XjO2+cwT3cuTctV9oTPb+k6Gy/q4zAefUe9Hazs5QIP0EPCAZ/Q6FxJUcztvB+
         QmVQ==
X-Gm-Message-State: AAQBX9duZ2M0OsFARcEAyNXScyF/2j8EQcIbJki1Nl+QKlndiyHW10Iv
        qAxTeOqenZTiOk2OzOO5eZk=
X-Google-Smtp-Source: AKy350YPoUvzgF4suNHhPlPa5FlClqCHTbp+iMrp3LAv5ciC2ropMyHEfyK+4Q4y7lWq8YDnDP6K4w==
X-Received: by 2002:a92:da81:0:b0:326:3001:1f8b with SMTP id u1-20020a92da81000000b0032630011f8bmr3762084iln.19.1680676306840;
        Tue, 04 Apr 2023 23:31:46 -0700 (PDT)
Received: from fedora.. (c-73-78-138-46.hsd1.co.comcast.net. [73.78.138.46])
        by smtp.gmail.com with ESMTPSA id v14-20020a922e0e000000b00325c0d7a0bcsm3635480ile.72.2023.04.04.23.31.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 23:31:46 -0700 (PDT)
From:   Maxim Georgiev <glipus@gmail.com>
To:     kory.maincent@bootlin.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, glipus@gmail.com,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com
Subject: [RFC PATCH v3 1/5] Add NDOs for hardware timestamp get/set
Date:   Wed,  5 Apr 2023 00:31:44 -0600
Message-Id: <20230405063144.36231-1-glipus@gmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current NIC driver API demands drivers supporting hardware timestamping
to implement handling logic for SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTLs.
Handling these IOCTLs requires dirivers to implement request parameter
structure translation between user and kernel address spaces, handling
possible translation failures, etc. This translation code is pretty much
identical across most of the NIC drivers that support SIOCGHWTSTAMP/
SIOCSHWTSTAMP.
This patch extends NDO functiuon set with ndo_hwtstamp_get/set
functions, implements SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTL translation
to ndo_hwtstamp_get/set function calls including parameter structure
translation and translation error handling.

This patch is sent out as RFC.
It still pending on basic testing.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Maxim Georgiev <glipus@gmail.com>
---
Changes in v3:
- Moved individual driver conversions to separate patches

Changes in v2:
- Introduced kernel_hwtstamp_config structure
- Added netlink_ext_ack* and kernel_hwtstamp_config* as NDO hw timestamp
  function parameters
- Reodered function variable declarations in dev_hwtstamp()
- Refactored error handling logic in dev_hwtstamp()
- Split dev_hwtstamp() into GET and SET versions
- Changed net_hwtstamp_validate() to accept struct hwtstamp_config *
  as a parameter
---
 include/linux/net_tstamp.h |  8 ++++++++
 include/linux/netdevice.h  | 16 ++++++++++++++++
 net/core/dev_ioctl.c       | 36 ++++++++++++++++++++++++++++++++++--
 3 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/include/linux/net_tstamp.h b/include/linux/net_tstamp.h
index fd67f3cc0c4b..063260475e77 100644
--- a/include/linux/net_tstamp.h
+++ b/include/linux/net_tstamp.h
@@ -30,4 +30,12 @@ static inline void hwtstamp_config_to_kernel(struct kernel_hwtstamp_config *kern
 	kernel_cfg->rx_filter = cfg->rx_filter;
 }
 
+static inline void hwtstamp_kernel_to_config(struct hwtstamp_config *cfg,
+					     const struct kernel_hwtstamp_config *kernel_cfg)
+{
+	cfg->flags = kernel_cfg->flags;
+	cfg->tx_type = kernel_cfg->tx_type;
+	cfg->rx_filter = kernel_cfg->rx_filter;
+}
+
 #endif /* _LINUX_NET_TIMESTAMPING_H_ */
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a740be3bb911..8356002d0ac0 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -57,6 +57,7 @@
 struct netpoll_info;
 struct device;
 struct ethtool_ops;
+struct kernel_hwtstamp_config;
 struct phy_device;
 struct dsa_port;
 struct ip_tunnel_parm;
@@ -1412,6 +1413,15 @@ struct netdev_net_notifier {
  *	Get hardware timestamp based on normal/adjustable time or free running
  *	cycle counter. This function is required if physical clock supports a
  *	free running cycle counter.
+ *	int (*ndo_hwtstamp_get)(struct net_device *dev,
+ *				struct kernel_hwtstamp_config *kernel_config,
+ *				struct netlink_ext_ack *extack);
+ *	Get hardware timestamping parameters currently configured for NIC
+ *	device.
+ *	int (*ndo_hwtstamp_set)(struct net_device *dev,
+ *				struct kernel_hwtstamp_config *kernel_config,
+ *				struct netlink_ext_ack *extack);
+ *	Set hardware timestamping parameters for NIC device.
  */
 struct net_device_ops {
 	int			(*ndo_init)(struct net_device *dev);
@@ -1646,6 +1656,12 @@ struct net_device_ops {
 	ktime_t			(*ndo_get_tstamp)(struct net_device *dev,
 						  const struct skb_shared_hwtstamps *hwtstamps,
 						  bool cycles);
+	int			(*ndo_hwtstamp_get)(struct net_device *dev,
+						    struct kernel_hwtstamp_config *kernel_config,
+						    struct netlink_ext_ack *extack);
+	int			(*ndo_hwtstamp_set)(struct net_device *dev,
+						    struct kernel_hwtstamp_config *kernel_config,
+						    struct netlink_ext_ack *extack);
 };
 
 struct xdp_metadata_ops {
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 6d772837eb3f..736f310a0661 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -254,11 +254,30 @@ static int dev_eth_ioctl(struct net_device *dev,
 
 static int dev_get_hwtstamp(struct net_device *dev, struct ifreq *ifr)
 {
-	return dev_eth_ioctl(dev, ifr, SIOCGHWTSTAMP);
+	const struct net_device_ops *ops = dev->netdev_ops;
+	struct kernel_hwtstamp_config kernel_cfg;
+	struct hwtstamp_config config;
+	int err;
+
+	if (!ops->ndo_hwtstamp_get)
+		return dev_eth_ioctl(dev, ifr, SIOCGHWTSTAMP);
+
+	if (!netif_device_present(dev))
+		return -ENODEV;
+
+	err = ops->ndo_hwtstamp_get(dev, &kernel_cfg, NULL);
+	if (err)
+		return err;
+
+	hwtstamp_kernel_to_config(&config, &kernel_cfg);
+	if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
+		return -EFAULT;
+	return 0;
 }
 
 static int dev_set_hwtstamp(struct net_device *dev, struct ifreq *ifr)
 {
+	const struct net_device_ops *ops = dev->netdev_ops;
 	struct netdev_notifier_hwtstamp_info info = {
 		.info.dev = dev,
 	};
@@ -288,7 +307,20 @@ static int dev_set_hwtstamp(struct net_device *dev, struct ifreq *ifr)
 		return err;
 	}
 
-	return dev_eth_ioctl(dev, ifr, SIOCSHWTSTAMP);
+	if (!ops->ndo_hwtstamp_set)
+		return dev_eth_ioctl(dev, ifr, SIOCSHWTSTAMP);
+
+	if (!netif_device_present(dev))
+		return -ENODEV;
+
+	err = ops->ndo_hwtstamp_set(dev, &kernel_cfg, NULL);
+	if (err)
+		return err;
+
+	hwtstamp_kernel_to_config(&cfg, &kernel_cfg);
+	if (copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)))
+		return -EFAULT;
+	return 0;
 }
 
 static int dev_siocbond(struct net_device *dev,
-- 
2.39.2

