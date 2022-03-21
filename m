Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50404E2412
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 11:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346222AbiCUKQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 06:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346124AbiCUKQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 06:16:16 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B6017A97
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 03:14:51 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id r22so19109120ljd.4
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 03:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=YHGKjU83F4eAdszFq5z81FKn0UfX6FcBTWb0VAmYVoE=;
        b=oDO6Frt5UKTDV4aefFyCvdj+jveCK6xxf2rnTeohlgh+xWsqcyXk9q0xMg7rrduBVu
         7sHUvD8LvHjYxK8xu01SecdINeXZwOl/fBFzLJHcS9EKwlsfSR/bQhgZ/rLTjYTRWup9
         JU8W56Pro5+rDStlhlwkoKg95yS7EDPj1NVg6chYsd6gIe2Dzc8nev3Exeio5h5WTy1/
         8to2ARdNfJAfETmO7/HkwZauloovbh7URHQ7t1IwhvuiGa+5Mqj4P991NrDStPeNtsER
         CFZ4cK0EhdfQ3ejjjBwmDyD0JfDG4PYWgeSi9NVAbDc5ARi9jbD0ucYCEylgNh9bmIn0
         Va3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=YHGKjU83F4eAdszFq5z81FKn0UfX6FcBTWb0VAmYVoE=;
        b=IrGq2L2Sl+JQDvr0vUm4Mrp3AWoDPZzJJQ3fyZg9OUMUHVcVCmJs612tZa0iZYz6Hd
         /RezfFGNtKnWu4BctIj2sFrbklurBKU3xQy5Gg/eq5RQcwwaNFMcqqGBhSoey8TBAZCb
         EBnSx8Ysbh0km2GMgWsdWCdEsZ5yHMdkS9jhZDP2O4+ZiTsqP1zYKOpd7wi8L2QsN/mG
         PkZrQHeC++lOK8s3cor0jI9luNLzTVQgVlDQYtmnIkqxZQ1U+RniLLXRXPmSAXU2EYey
         yVeSmFgdTVwVLuiFKWQ03TCV5ABgK0tcrkZGFheWwfdxzIx73CpU5O2tQqJ6qdlsu1/V
         Q0MQ==
X-Gm-Message-State: AOAM533+aul5s0jH9oGKjnKwUsh7VC9p3f28A6GrsHYNxXQiyNfbPV6f
        NQaCir5pCc3kJjqkiLAHBnE=
X-Google-Smtp-Source: ABdhPJzCb10g65yPLdaE2IursYLjv7UFT4NjoJI17QCOeE02Qz9AIdZl763Ts4XOikt+a/5mgdnyoA==
X-Received: by 2002:a2e:9847:0:b0:244:bbdf:8f72 with SMTP id e7-20020a2e9847000000b00244bbdf8f72mr15053326ljj.69.1647857689741;
        Mon, 21 Mar 2022 03:14:49 -0700 (PDT)
Received: from wse-c0155.labs.westermo.se (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id f11-20020a0565123b0b00b0044a2809c621sm361598lfv.29.2022.03.21.03.14.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 03:14:49 -0700 (PDT)
From:   Casper Andersson <casper.casan@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 2/2] net: sparx5: Add mdb handlers
Date:   Mon, 21 Mar 2022 11:14:46 +0100
Message-Id: <20220321101446.2372093-3-casper.casan@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321101446.2372093-1-casper.casan@gmail.com>
References: <20220321101446.2372093-1-casper.casan@gmail.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds mdb handlers. Uses the PGID arbiter to
find a free entry in the PGID table for the
multicast group port mask.

Signed-off-by: Casper Andersson <casper.casan@gmail.com>
---
 .../microchip/sparx5/sparx5_mactable.c        |  33 ++++--
 .../ethernet/microchip/sparx5/sparx5_main.h   |   2 +
 .../microchip/sparx5/sparx5_switchdev.c       | 111 ++++++++++++++++++
 3 files changed, 136 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
index 82b1b3c9a065..35abb3d0ce19 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
@@ -186,11 +186,11 @@ bool sparx5_mact_getnext(struct sparx5 *sparx5,
 	return ret == 0;
 }
 
-static int sparx5_mact_lookup(struct sparx5 *sparx5,
-			      const unsigned char mac[ETH_ALEN],
-			      u16 vid)
+bool sparx5_mact_find(struct sparx5 *sparx5,
+		      const unsigned char mac[ETH_ALEN], u16 vid, u32 *pcfg2)
 {
 	int ret;
+	u32 cfg2;
 
 	mutex_lock(&sparx5->lock);
 
@@ -202,16 +202,29 @@ static int sparx5_mact_lookup(struct sparx5 *sparx5,
 		sparx5, LRN_COMMON_ACCESS_CTRL);
 
 	ret = sparx5_mact_wait_for_completion(sparx5);
-	if (ret)
-		goto out;
-
-	ret = LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_VLD_GET
-		(spx5_rd(sparx5, LRN_MAC_ACCESS_CFG_2));
+	if (ret == 0) {
+		cfg2 = spx5_rd(sparx5, LRN_MAC_ACCESS_CFG_2);
+		if (LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_VLD_GET(cfg2))
+			*pcfg2 = cfg2;
+		else
+			ret = -ENOENT;
+	}
 
-out:
 	mutex_unlock(&sparx5->lock);
 
-	return ret;
+	return ret == 0;
+}
+
+static int sparx5_mact_lookup(struct sparx5 *sparx5,
+			      const unsigned char mac[ETH_ALEN],
+			      u16 vid)
+{
+	u32 pcfg2;
+
+	if (sparx5_mact_find(sparx5, mac, vid, &pcfg2))
+		return 1;
+
+	return 0;
 }
 
 int sparx5_mact_forget(struct sparx5 *sparx5,
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index e97fa091c740..7a04b8f2a546 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -310,6 +310,8 @@ int sparx5_mact_learn(struct sparx5 *sparx5, int port,
 		      const unsigned char mac[ETH_ALEN], u16 vid);
 bool sparx5_mact_getnext(struct sparx5 *sparx5,
 			 unsigned char mac[ETH_ALEN], u16 *vid, u32 *pcfg2);
+bool sparx5_mact_find(struct sparx5 *sparx5,
+		      const unsigned char mac[ETH_ALEN], u16 vid, u32 *pcfg2);
 int sparx5_mact_forget(struct sparx5 *sparx5,
 		       const unsigned char mac[ETH_ALEN], u16 vid);
 int sparx5_add_mact_entry(struct sparx5 *sparx5,
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
index 2d5de1c06fab..9e1ea35d0c40 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
@@ -366,6 +366,109 @@ static int sparx5_handle_port_vlan_add(struct net_device *dev,
 				  v->flags & BRIDGE_VLAN_INFO_UNTAGGED);
 }
 
+static int sparx5_handle_port_mdb_add(struct net_device *dev,
+				      struct notifier_block *nb,
+				      const struct switchdev_obj_port_mdb *v)
+{
+	struct sparx5_port *port = netdev_priv(dev);
+	struct sparx5 *spx5 = port->sparx5;
+	u16 pgid_idx, vid;
+	u32 mact_entry;
+	int res, err;
+
+	/* When VLAN unaware the vlan value is not parsed and we receive vid 0.
+	 * Fall back to bridge vid 1.
+	 */
+	if (!br_vlan_enabled(spx5->hw_bridge_dev))
+		vid = 1;
+	else
+		vid = v->vid;
+
+	res = sparx5_mact_find(spx5, v->addr, vid, &mact_entry);
+
+	if (res) {
+		pgid_idx = LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_GET(mact_entry);
+
+		/* MC_IDX has an offset of 65 in the PGID table. */
+		pgid_idx += PGID_MCAST_START;
+		sparx5_pgid_update_mask(port, pgid_idx, true);
+	} else {
+		err = sparx5_pgid_alloc_mcast(spx5, &pgid_idx);
+		if (err) {
+			netdev_warn(dev, "multicast pgid table full\n");
+			return err;
+		}
+		sparx5_pgid_update_mask(port, pgid_idx, true);
+		err = sparx5_mact_learn(spx5, pgid_idx, v->addr, vid);
+		if (err) {
+			netdev_warn(dev, "could not learn mac address %pM\n", v->addr);
+			sparx5_pgid_update_mask(port, pgid_idx, false);
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+static int sparx5_mdb_del_entry(struct net_device *dev,
+				struct sparx5 *spx5,
+				const unsigned char mac[ETH_ALEN],
+				const u16 vid,
+				u16 pgid_idx)
+{
+	int err;
+
+	err = sparx5_mact_forget(spx5, mac, vid);
+	if (err) {
+		netdev_warn(dev, "could not forget mac address %pM", mac);
+		return err;
+	}
+	err = sparx5_pgid_free(spx5, pgid_idx);
+	if (err) {
+		netdev_err(dev, "attempted to free already freed pgid\n");
+		return err;
+	}
+	return 0;
+}
+
+static int sparx5_handle_port_mdb_del(struct net_device *dev,
+				      struct notifier_block *nb,
+				      const struct switchdev_obj_port_mdb *v)
+{
+	struct sparx5_port *port = netdev_priv(dev);
+	struct sparx5 *spx5 = port->sparx5;
+	u16 pgid_idx, vid;
+	u32 mact_entry, res, pgid_entry[3];
+	int err;
+
+	if (!br_vlan_enabled(spx5->hw_bridge_dev))
+		vid = 1;
+	else
+		vid = v->vid;
+
+	res = sparx5_mact_find(spx5, v->addr, vid, &mact_entry);
+
+	if (res) {
+		pgid_idx = LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_GET(mact_entry);
+
+		/* MC_IDX has an offset of 65 in the PGID table. */
+		pgid_idx += PGID_MCAST_START;
+		sparx5_pgid_update_mask(port, pgid_idx, false);
+
+		pgid_entry[0] = spx5_rd(spx5, ANA_AC_PGID_CFG(pgid_idx));
+		pgid_entry[1] = spx5_rd(spx5, ANA_AC_PGID_CFG1(pgid_idx));
+		pgid_entry[2] = spx5_rd(spx5, ANA_AC_PGID_CFG2(pgid_idx));
+		if (pgid_entry[0] == 0 && pgid_entry[1] == 0 && pgid_entry[2] == 0) {
+			/* No ports are in MC group. Remove entry */
+			err = sparx5_mdb_del_entry(dev, spx5, v->addr, vid, pgid_idx);
+			if (err)
+				return err;
+		}
+	}
+
+	return 0;
+}
+
 static int sparx5_handle_port_obj_add(struct net_device *dev,
 				      struct notifier_block *nb,
 				      struct switchdev_notifier_port_obj_info *info)
@@ -378,6 +481,10 @@ static int sparx5_handle_port_obj_add(struct net_device *dev,
 		err = sparx5_handle_port_vlan_add(dev, nb,
 						  SWITCHDEV_OBJ_PORT_VLAN(obj));
 		break;
+	case SWITCHDEV_OBJ_ID_PORT_MDB:
+		err = sparx5_handle_port_mdb_add(dev, nb,
+						 SWITCHDEV_OBJ_PORT_MDB(obj));
+		break;
 	default:
 		err = -EOPNOTSUPP;
 		break;
@@ -426,6 +533,10 @@ static int sparx5_handle_port_obj_del(struct net_device *dev,
 		err = sparx5_handle_port_vlan_del(dev, nb,
 						  SWITCHDEV_OBJ_PORT_VLAN(obj)->vid);
 		break;
+	case SWITCHDEV_OBJ_ID_PORT_MDB:
+		err = sparx5_handle_port_mdb_del(dev, nb,
+						 SWITCHDEV_OBJ_PORT_MDB(obj));
+		break;
 	default:
 		err = -EOPNOTSUPP;
 		break;
-- 
2.30.2

