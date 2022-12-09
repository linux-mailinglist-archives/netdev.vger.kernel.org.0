Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B246A6484EC
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 16:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbiLIPWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 10:22:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbiLIPVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 10:21:46 -0500
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C8B88B57
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 07:21:45 -0800 (PST)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-3cbdd6c00adso55998167b3.11
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 07:21:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XeM/Au3FFJ8CEHCB/2f39QOmF/U0wWpHKCHbe4zZIIQ=;
        b=gxEruyky3m8NIEd9NgO0Oj0koCU/ZsEDxfJuvzgcqn5JgS+vKwf/DZtvujjuGh6EuP
         Pxy+2g+ppZhCRBg+MUZOwi58dK32eSessVlYuvKrD6mQgVXQUDcU067oH8qMP2ogo7k7
         VKOp+2vHa3i2XDgETN/055IWAOfkHEBsz9E7y1SFLFWzAOWeRWj8nBhqJYhdmdGTqsqL
         Y3nLAeMt+RH6BbEmiu22YFjH32K+dXbvEzX8PMP5ykeiVwTcqgAzt+ItMKSiuQfXCR5I
         HlP5HkDPrJ9SJfCSUu3okIQFU+FLZ4cEhY5vEDzr5LDU1FEkJ6sG9ArvOpEUWSDeBORo
         le7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XeM/Au3FFJ8CEHCB/2f39QOmF/U0wWpHKCHbe4zZIIQ=;
        b=wNYzkIwi73bgXLK715+XVATTW+U65MNVqC/akmdTow0aE3qnm4RsBXb0ctSuNA54nx
         qxNYibmxd0qlzvA33PXuUTsqePTB0fYCoo45SI0TE0JsJiG5hVlDJHiMtffq1XK/HgbR
         8+ISEA+Q6p7HZJ1ZoNEgJylfVw5nJi9ksaOTI8WbS/GL0N//LUnVHNZkb7zc++w86HjH
         8gEcjQklvVtoXPUZyAtxeXF3LPDwwRL7loNhSMW9dhb9kK/UFPT6M4mrpCYRQwRkH34d
         VABZ7f/cTohQ/IHmxeFzREiMUBxOiLQ3FzSOIn46p35tRrqgzq5IL6K8pEbcpsiiINKD
         78Xg==
X-Gm-Message-State: ANoB5pnaPjM2yzDIf7GTErgtYVDdLdodLWtSSLX+qq44WE2uO/hrd0d3
        tNVklBssHuuVEitKwYT2NhEJcOFIadiV6Q==
X-Google-Smtp-Source: AA0mqf7lTrV/+2tdpC7D4iGAVrk//29D09IKVGjcXAlKjDxh4H4zSZlpTQ3blM1Y7UKqrbUgcIObcg==
X-Received: by 2002:a05:7500:6812:b0:ea:bb47:96aa with SMTP id hd18-20020a057500681200b000eabb4796aamr437517gab.29.1670599303831;
        Fri, 09 Dec 2022 07:21:43 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id i26-20020a05620a0a1a00b006fbae4a5f59sm39699qka.41.2022.12.09.07.21.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 07:21:43 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        LiLiang <liali@redhat.com>
Subject: [PATCH net-next 1/3] net: add IFF_NO_ADDRCONF and use it in bonding to prevent ipv6 addrconf
Date:   Fri,  9 Dec 2022 10:21:38 -0500
Message-Id: <948924df0ed4f60e5bd0d7caaa53615ca6335f0c.1670599241.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1670599241.git.lucien.xin@gmail.com>
References: <cover.1670599241.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, in bonding it reused the IFF_SLAVE flag and checked it
in ipv6 addrconf to prevent ipv6 addrconf.

However, it is not a proper flag to use for no ipv6 addrconf, for
bonding it has to move IFF_SLAVE flag setting ahead of dev_open()
in bond_enslave(). Also, IFF_MASTER/SLAVE are historical flags
used in bonding and eql, as Jiri mentioned, the new devices like
Team, Failover do not use this flag.

So as Jiri suggested, this patch adds IFF_NO_ADDRCONF in priv_flags
of the device to indicate no ipv6 addconf, and uses it in bonding
and moves IFF_SLAVE flag setting back to its original place.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 drivers/net/bonding/bond_main.c | 18 +++++++++++++-----
 include/linux/netdevice.h       |  3 ++-
 net/ipv6/addrconf.c             |  4 ++--
 3 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index e01bb0412f1c..c1cc44223786 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1632,13 +1632,19 @@ static int bond_master_upper_dev_link(struct bonding *bond, struct slave *slave,
 {
 	struct netdev_lag_upper_info lag_upper_info;
 	enum netdev_lag_tx_type type;
+	int err;
 
 	type = bond_lag_tx_type(bond);
 	lag_upper_info.tx_type = type;
 	lag_upper_info.hash_type = bond_lag_hash_type(bond, type);
 
-	return netdev_master_upper_dev_link(slave->dev, bond->dev, slave,
-					    &lag_upper_info, extack);
+	err = netdev_master_upper_dev_link(slave->dev, bond->dev, slave,
+					   &lag_upper_info, extack);
+	if (err)
+		return err;
+
+	slave->dev->flags |= IFF_SLAVE;
+	return 0;
 }
 
 static void bond_upper_dev_unlink(struct bonding *bond, struct slave *slave)
@@ -1950,8 +1956,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 		}
 	}
 
-	/* set slave flag before open to prevent IPv6 addrconf */
-	slave_dev->flags |= IFF_SLAVE;
+	/* set no_addrconf flag before open to prevent IPv6 addrconf */
+	slave_dev->priv_flags |= IFF_NO_ADDRCONF;
 
 	/* open the slave since the application closed it */
 	res = dev_open(slave_dev, extack);
@@ -2254,7 +2260,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	dev_close(slave_dev);
 
 err_restore_mac:
-	slave_dev->flags &= ~IFF_SLAVE;
+	slave_dev->priv_flags &= ~IFF_NO_ADDRCONF;
 	if (!bond->params.fail_over_mac ||
 	    BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP) {
 		/* XXX TODO - fom follow mode needs to change master's
@@ -2446,6 +2452,8 @@ static int __bond_release_one(struct net_device *bond_dev,
 	/* close slave before restoring its mac address */
 	dev_close(slave_dev);
 
+	slave_dev->priv_flags &= ~IFF_NO_ADDRCONF;
+
 	if (bond->params.fail_over_mac != BOND_FOM_ACTIVE ||
 	    BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP) {
 		/* restore original ("permanent") mac address */
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index f78db610ada5..34f9752a715b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1658,6 +1658,7 @@ struct net_device_ops {
  * @IFF_FAILOVER: device is a failover master device
  * @IFF_FAILOVER_SLAVE: device is lower dev of a failover master device
  * @IFF_L3MDEV_RX_HANDLER: only invoke the rx handler of L3 master device
+ * @IFF_NO_ADDRCONF: prevent ipv6 addrconf
  * @IFF_TX_SKB_NO_LINEAR: device/driver is capable of xmitting frames with
  *	skb_headlen(skb) == 0 (data starts from frag0)
  * @IFF_CHANGE_PROTO_DOWN: device supports setting carrier via IFLA_PROTO_DOWN
@@ -1693,7 +1694,7 @@ enum netdev_priv_flags {
 	IFF_FAILOVER			= 1<<27,
 	IFF_FAILOVER_SLAVE		= 1<<28,
 	IFF_L3MDEV_RX_HANDLER		= 1<<29,
-	/* was IFF_LIVE_RENAME_OK */
+	IFF_NO_ADDRCONF			= BIT_ULL(30),
 	IFF_TX_SKB_NO_LINEAR		= BIT_ULL(31),
 	IFF_CHANGE_PROTO_DOWN		= BIT_ULL(32),
 };
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 9c3f5202a97b..c338dfb05d2c 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3320,7 +3320,7 @@ static void addrconf_addr_gen(struct inet6_dev *idev, bool prefix_route)
 		return;
 
 	/* no link local addresses on devices flagged as slaves */
-	if (idev->dev->flags & IFF_SLAVE)
+	if (idev->dev->priv_flags & IFF_NO_ADDRCONF)
 		return;
 
 	ipv6_addr_set(&addr, htonl(0xFE800000), 0, 0, 0);
@@ -3560,7 +3560,7 @@ static int addrconf_notify(struct notifier_block *this, unsigned long event,
 		if (idev && idev->cnf.disable_ipv6)
 			break;
 
-		if (dev->flags & IFF_SLAVE) {
+		if (dev->priv_flags & IFF_NO_ADDRCONF) {
 			if (event == NETDEV_UP && !IS_ERR_OR_NULL(idev) &&
 			    dev->flags & IFF_UP && dev->flags & IFF_MULTICAST)
 				ipv6_mc_up(idev);
-- 
2.31.1

