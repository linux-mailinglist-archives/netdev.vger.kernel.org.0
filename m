Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD276D1679
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 06:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjCaE4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 00:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjCaE4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 00:56:24 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76A8A6
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 21:56:22 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id h14so9619581ilj.0
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 21:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680238582;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/XfdUEekMx9rN3mIRA6HFUpRweE86kV13XiI1Wz+gwg=;
        b=Vp1oGXCfwW6Sfd3E62dyoQdOtE54DWOF13NhO+WdctwbKlyFHIDD5l9iM+z6UHpfjY
         iHcliL8iO5FIclknvYxYkF/joWbU9tYHQORNcnFdetbetffDgSi0F6bkUDoP36L8ShrV
         4zjQA/V6JcKJTThYiO1CP5O9j6BtOZWU7XuZZ+UWfi8yvDcmdL/nMCsaOrPphAkObqJw
         mMqazsjBxZr5cFjb1+fsyUhbyv/4EaHxg+Uv89y9kYyEvDlIu/quH+dXV6qauUhANf9J
         83BqhbZNNOtKhB9hbjdQ/Ium2XvrjBGfKZjtShI++xWBXS3wEQjLn15FRLxsfLkLyFtL
         xX2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680238582;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/XfdUEekMx9rN3mIRA6HFUpRweE86kV13XiI1Wz+gwg=;
        b=DJzTE625bu/q27wTeXWItkAQyLZ3Kd/ZTUDVRuWal6GnpJiMGKhH0dH4QDkFF/R1Dy
         ZAlalDnTM8KvPAGIn4d9/c0NGiBNj8yigELuvPHkiKD30bKcJ1GG6LcHCTR4uNy+AKA4
         eFawcB4dtOLizAqK9ZJVGZdM53k9P3yzbu+wZHw65LFw+1xFXHIrHZSHNRAA1gU6MRdF
         XWw8hAOl81ytn5pHZuZv3wUWVR/nKj9XYbICBpK8dvjm/yF7cr7jdhodJBBSNti0mvZi
         jhrVrniHKGlLOetZGS/hTnVge+MtLQ9Kn9CPIGj9VTlxsdnAmZG4wkatmaZzUfkOilcD
         3fiw==
X-Gm-Message-State: AAQBX9eAksjjlA6X4S0hMYlEi5TE26HLyhrXNOhsxZpBt51+W8BAWXlH
        nFX0CE3a7SFbbgsCr0OEzjtDxTChEz8mcA==
X-Google-Smtp-Source: AKy350bou8maxOt3Nh2T9j83uw2qeKUsbfrx8hdCkTkEsN1Ua/5ffmRDB3LNz4uGQH+NcVZ1xiCMlw==
X-Received: by 2002:a92:d312:0:b0:316:f93f:6baa with SMTP id x18-20020a92d312000000b00316f93f6baamr18871604ila.31.1680238582005;
        Thu, 30 Mar 2023 21:56:22 -0700 (PDT)
Received: from fedora.. (c-73-78-138-46.hsd1.co.comcast.net. [73.78.138.46])
        by smtp.gmail.com with ESMTPSA id t16-20020a02b190000000b00401b9f59475sm392546jah.107.2023.03.30.21.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 21:56:21 -0700 (PDT)
From:   Maxim Georgiev <glipus@gmail.com>
To:     kory.maincent@bootlin.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, glipus@gmail.com,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com
Subject: [PATCH net-next RFC] Add NDOs for hardware timestamp get/set
Date:   Thu, 30 Mar 2023 22:56:19 -0600
Message-Id: <20230331045619.40256-1-glipus@gmail.com>
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
to support SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTLs. Handling these IOCTLs
requires dirivers to implement request parameter structure translation
between user and kernel address spaces, handling possible
translation failures, etc. This translation code is pretty much
identical across most of the NIC drivers that support SIOCGHWTSTAMP/
SIOCSHWTSTAMP.
This patch extends NDO functiuon set with ndo_hwtstamp_get/set
functions, implements SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTL translation
to ndo_hwtstamp_get/set function calls including parameter structure
translation and translation error handling.

This patch is sent out as RFC.
It still pending on basic testing. Implementing ndo_hwtstamp_get/set
in netdevsim driver should allow manual testing of the request
translation logic. Also is there a way to automate this testing?

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Maxim Georgiev <glipus@gmail.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 33 ++++++++---------
 drivers/net/netdevsim/netdev.c             | 20 +++++++++++
 drivers/net/netdevsim/netdevsim.h          |  1 +
 include/linux/netdevice.h                  | 12 +++++++
 net/core/dev_ioctl.c                       | 42 +++++++++++++++++++---
 5 files changed, 85 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 6f5c16aebcbf..887be333349b 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6161,7 +6161,7 @@ static int e1000_mii_ioctl(struct net_device *netdev, struct ifreq *ifr,
 /**
  * e1000e_hwtstamp_set - control hardware time stamping
  * @netdev: network interface device structure
- * @ifr: interface request
+ * @config: hwtstamp_config structure containing request parameters
  *
  * Outgoing time stamping can be enabled and disabled. Play nice and
  * disable it when requested, although it shouldn't cause any overhead
@@ -6174,20 +6174,17 @@ static int e1000_mii_ioctl(struct net_device *netdev, struct ifreq *ifr,
  * specified. Matching the kind of event packet is not supported, with the
  * exception of "all V2 events regardless of level 2 or 4".
  **/
-static int e1000e_hwtstamp_set(struct net_device *netdev, struct ifreq *ifr)
+static int e1000e_hwtstamp_set(struct net_device *netdev,
+			       struct hwtstamp_config *config)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
-	struct hwtstamp_config config;
 	int ret_val;
 
-	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
-		return -EFAULT;
-
-	ret_val = e1000e_config_hwtstamp(adapter, &config);
+	ret_val = e1000e_config_hwtstamp(adapter, config);
 	if (ret_val)
 		return ret_val;
 
-	switch (config.rx_filter) {
+	switch (config->rx_filter) {
 	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
 	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
 	case HWTSTAMP_FILTER_PTP_V2_SYNC:
@@ -6199,22 +6196,22 @@ static int e1000e_hwtstamp_set(struct net_device *netdev, struct ifreq *ifr)
 		 * by hardware so notify the caller the requested packets plus
 		 * some others are time stamped.
 		 */
-		config.rx_filter = HWTSTAMP_FILTER_SOME;
+		config->rx_filter = HWTSTAMP_FILTER_SOME;
 		break;
 	default:
 		break;
 	}
-
-	return copy_to_user(ifr->ifr_data, &config,
-			    sizeof(config)) ? -EFAULT : 0;
+	return ret_val;
 }
 
-static int e1000e_hwtstamp_get(struct net_device *netdev, struct ifreq *ifr)
+static int e1000e_hwtstamp_get(struct net_device *netdev,
+			       struct hwtstamp_config *config)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 
-	return copy_to_user(ifr->ifr_data, &adapter->hwtstamp_config,
-			    sizeof(adapter->hwtstamp_config)) ? -EFAULT : 0;
+	memcpy(config, &adapter->hwtstamp_config,
+	       sizeof(adapter->hwtstamp_config));
+	return 0;
 }
 
 static int e1000_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
@@ -6224,10 +6221,6 @@ static int e1000_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 	case SIOCGMIIREG:
 	case SIOCSMIIREG:
 		return e1000_mii_ioctl(netdev, ifr, cmd);
-	case SIOCSHWTSTAMP:
-		return e1000e_hwtstamp_set(netdev, ifr);
-	case SIOCGHWTSTAMP:
-		return e1000e_hwtstamp_get(netdev, ifr);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -7365,6 +7358,8 @@ static const struct net_device_ops e1000e_netdev_ops = {
 	.ndo_set_features = e1000_set_features,
 	.ndo_fix_features = e1000_fix_features,
 	.ndo_features_check	= passthru_features_check,
+	.ndo_hwtstamp_get	= e1000e_hwtstamp_get,
+	.ndo_hwtstamp_set	= e1000e_hwtstamp_set,
 };
 
 /**
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 35fa1ca98671..c5c1835e3904 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -238,6 +238,24 @@ nsim_set_features(struct net_device *dev, netdev_features_t features)
 	return 0;
 }
 
+static int
+nsim_hwtstamp_get(struct net_device *dev, struct hwtstamp_config *config)
+{
+	struct netdevsim *ns = netdev_priv(dev);
+
+	memcpy(config, &ns->hw_tstamp_config, sizeof(ns->hw_tstamp_config));
+	return 0;
+}
+
+static int
+nsim_hwtstamp_ges(struct net_device *dev, struct hwtstamp_config *config)
+{
+	struct netdevsim *ns = netdev_priv(dev);
+
+	memcpy(&ns->hw_tstamp_config, config, sizeof(ns->hw_tstamp_config));
+	return 0;
+}
+
 static const struct net_device_ops nsim_netdev_ops = {
 	.ndo_start_xmit		= nsim_start_xmit,
 	.ndo_set_rx_mode	= nsim_set_rx_mode,
@@ -256,6 +274,8 @@ static const struct net_device_ops nsim_netdev_ops = {
 	.ndo_setup_tc		= nsim_setup_tc,
 	.ndo_set_features	= nsim_set_features,
 	.ndo_bpf		= nsim_bpf,
+	.ndo_hwtstamp_get	= nsim_hwtstamp_get,
+	.ndo_hwtstamp_set	= nsim_hwtstamp_get,
 };
 
 static const struct net_device_ops nsim_vf_netdev_ops = {
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 7d8ed8d8df5c..c6efd2383552 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -102,6 +102,7 @@ struct netdevsim {
 	} udp_ports;
 
 	struct nsim_ethtool ethtool;
+	struct hwtstamp_config hw_tstamp_config;
 };
 
 struct netdevsim *
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 7621c512765f..aeab126baa22 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -57,6 +57,7 @@
 struct netpoll_info;
 struct device;
 struct ethtool_ops;
+struct hwtstamp_config;
 struct phy_device;
 struct dsa_port;
 struct ip_tunnel_parm;
@@ -1408,6 +1409,13 @@ struct netdev_net_notifier {
  *	Get hardware timestamp based on normal/adjustable time or free running
  *	cycle counter. This function is required if physical clock supports a
  *	free running cycle counter.
+ *	int  (*ndo_hwtstamp_get)(struct net_device *dev,
+ *				 struct hwtstamp_config *config);
+ *	Get hardware timestamping parameters currently configured  for NIC
+ *	device.
+ *	int (*ndo_hwtstamp_set)(struct net_device *dev,
+ *				struct hwtstamp_config *config);
+ *	Set hardware timestamping parameters for NIC device.
  */
 struct net_device_ops {
 	int			(*ndo_init)(struct net_device *dev);
@@ -1642,6 +1650,10 @@ struct net_device_ops {
 	ktime_t			(*ndo_get_tstamp)(struct net_device *dev,
 						  const struct skb_shared_hwtstamps *hwtstamps,
 						  bool cycles);
+	int			(*ndo_hwtstamp_get)(struct net_device *dev,
+						    struct hwtstamp_config *config);
+	int			(*ndo_hwtstamp_set)(struct net_device *dev,
+						    struct hwtstamp_config *config);
 };
 
 struct xdp_metadata_ops {
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 5cdbfbf9a7dc..c90fac9a9b2e 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -277,6 +277,39 @@ static int dev_siocbond(struct net_device *dev,
 	return -EOPNOTSUPP;
 }
 
+static int dev_hwtstamp(struct net_device *dev, struct ifreq *ifr,
+			unsigned int cmd)
+{
+	const struct net_device_ops *ops = dev->netdev_ops;
+	int err;
+	struct hwtstamp_config config;
+
+	if ((cmd == SIOCGHWTSTAMP && !ops->ndo_hwtstamp_get) ||
+	    (cmd == SIOCSHWTSTAMP && !ops->ndo_hwtstamp_set))
+		return dev_eth_ioctl(dev, ifr, cmd);
+
+	err = dsa_ndo_eth_ioctl(dev, ifr, cmd);
+	if (err == 0 || err != -EOPNOTSUPP)
+		return err;
+
+	if (!netif_device_present(dev))
+		return -ENODEV;
+
+	if (cmd == SIOCSHWTSTAMP) {
+		if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
+			err = -EFAULT;
+		else
+			err = ops->ndo_hwtstamp_set(dev, &config);
+	} else if (cmd == SIOCGHWTSTAMP) {
+		err = ops->ndo_hwtstamp_get(dev, &config);
+	}
+
+	if (err == 0)
+		err = copy_to_user(ifr->ifr_data, &config,
+				   sizeof(config)) ? -EFAULT : 0;
+	return err;
+}
+
 static int dev_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
 			      void __user *data, unsigned int cmd)
 {
@@ -391,11 +424,14 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
 		rtnl_lock();
 		return err;
 
+	case SIOCGHWTSTAMP:
+		return dev_hwtstamp(dev, ifr, cmd);
+
 	case SIOCSHWTSTAMP:
 		err = net_hwtstamp_validate(ifr);
 		if (err)
 			return err;
-		fallthrough;
+		return dev_hwtstamp(dev, ifr, cmd);
 
 	/*
 	 *	Unknown or private ioctl
@@ -407,9 +443,7 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
 
 		if (cmd == SIOCGMIIPHY ||
 		    cmd == SIOCGMIIREG ||
-		    cmd == SIOCSMIIREG ||
-		    cmd == SIOCSHWTSTAMP ||
-		    cmd == SIOCGHWTSTAMP) {
+		    cmd == SIOCSMIIREG) {
 			err = dev_eth_ioctl(dev, ifr, cmd);
 		} else if (cmd == SIOCBONDENSLAVE ||
 		    cmd == SIOCBONDRELEASE ||
-- 
2.39.2

