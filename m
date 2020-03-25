Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 590CC192C2D
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 16:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgCYPW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 11:22:26 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54605 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727751AbgCYPWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 11:22:23 -0400
Received: by mail-wm1-f67.google.com with SMTP id c81so2902956wmd.4
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 08:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JLymD2YDtsJoQzONTyDrYjpbzC4xrXQOzwSHXU9sgYo=;
        b=QzYFQ1JiCPGx65MPOxjyKdK15bCyfa/8RzlmoSSwKZPluaU+DmP+okdL5U0F+8oD5L
         Ywnl0FihWlCSYZbiJWRlj+A5U9biUDCaL4xsQQfPFW4PilFwkpp5Nio+oOCd3Fd3v4LJ
         2qyACPopWGFWklqEvyiAazAjB8+VbCfLU3RRtD9G8IBAQGu0uf9ZfcuuiWUI1a7EdYjO
         IdfKKDhl9/YArKbJIZMaB72no9SAGhft4+OYF7BnGY3kwsIpS68FKxZXmdk3y6y3+4Or
         3OuzoclKoiI7Kg02fOMPl2Z7lSVgdIcUODrWDQwcZaZ3N5KFu4cmRcLHdb4nBtT1Vgoq
         ixTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JLymD2YDtsJoQzONTyDrYjpbzC4xrXQOzwSHXU9sgYo=;
        b=Hv9FrM3l2fcaPqs2D+muD0lczpM56DMCJU+VteRlBbC512w6zcm8Oa827hoPK05HMS
         o6Ms+sIIDgDny6zG30DEnfSFP4yrT5GIBSueDUmJZa8ddhCnk0WOuqmSKZ0slUE2xdGJ
         PAIrnR/b0R/7rS+nENdyXuH/bZNEPrxiNUf5viSkulyV/Xu+0TPe7ANndCdvH+6ItqKB
         /kBBXE3VE7yth+8B1V2VEKBfVP72denqb6SThD6q0kp/zkU93J8F9WhKFa7VHZ2yfO9x
         /EKM4YdTnweH2PNE/SpIbopplZapRXImv1Ut2sClTn+y5Tsx62gjQyiZMjiC6OQ4wYSI
         HEAA==
X-Gm-Message-State: ANhLgQ0L7pQ7ijEE3hOXOWqTYgnKRDuEmClp1B5778xzuGUKGh1vDmyz
        hYQ6IJNSALwsX2C0nfEfO68=
X-Google-Smtp-Source: ADFU+vss+/mILGFjQGrpVv6MJld6HiJzWFLvrXhCUXKmT+3JZZiaQ0NJABc5yzF7C5cvR54nMxkKQw==
X-Received: by 2002:a1c:63c4:: with SMTP id x187mr3938501wmb.124.1585149740000;
        Wed, 25 Mar 2020 08:22:20 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id n9sm6309165wru.50.2020.03.25.08.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 08:22:19 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     murali.policharla@broadcom.com, stephen@networkplumber.org,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        nikolay@cumulusnetworks.com, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 04/10] bgmac: Add MTU configuration support to the driver
Date:   Wed, 25 Mar 2020 17:22:03 +0200
Message-Id: <20200325152209.3428-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200325152209.3428-1-olteanv@gmail.com>
References: <20200325152209.3428-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Murali Krishna Policharla <murali.policharla@broadcom.com>

Add bgmac_change_mtu API to configure new mtu settings in bgmac driver.

Signed-off-by: Murali Krishna Policharla <murali.policharla@broadcom.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/broadcom/bgmac.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index 1bb07a5d82c9..c530dff0353b 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -1248,6 +1248,14 @@ static int bgmac_set_mac_address(struct net_device *net_dev, void *addr)
 	return 0;
 }
 
+static int bgmac_change_mtu(struct net_device *net_dev, int mtu)
+{
+	struct bgmac *bgmac = netdev_priv(net_dev);
+
+	bgmac_write(bgmac, BGMAC_RXMAX_LENGTH, 32 + mtu);
+	return 0;
+}
+
 static const struct net_device_ops bgmac_netdev_ops = {
 	.ndo_open		= bgmac_open,
 	.ndo_stop		= bgmac_stop,
@@ -1256,6 +1264,7 @@ static const struct net_device_ops bgmac_netdev_ops = {
 	.ndo_set_mac_address	= bgmac_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_do_ioctl           = phy_do_ioctl_running,
+	.ndo_change_mtu		= bgmac_change_mtu,
 };
 
 /**************************************************
@@ -1529,6 +1538,7 @@ int bgmac_enet_probe(struct bgmac *bgmac)
 	net_dev->features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
 	net_dev->hw_features = net_dev->features;
 	net_dev->vlan_features = net_dev->features;
+	net_dev->max_mtu = BGMAC_RX_MAX_FRAME_SIZE;
 
 	err = register_netdev(bgmac->net_dev);
 	if (err) {
-- 
2.17.1

