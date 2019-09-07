Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6FAAAC738
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 17:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436513AbfIGPTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 11:19:06 -0400
Received: from shell.v3.sk ([90.176.6.54]:43523 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732540AbfIGPTG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Sep 2019 11:19:06 -0400
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id F2876D986A;
        Sat,  7 Sep 2019 17:19:01 +0200 (CEST)
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id ZCKQLd4J0DBe; Sat,  7 Sep 2019 17:18:58 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id F22C9D986F;
        Sat,  7 Sep 2019 17:18:57 +0200 (CEST)
X-Virus-Scanned: amavisd-new at zimbra.v3.sk
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id z3rDQpi2jIXx; Sat,  7 Sep 2019 17:18:57 +0200 (CEST)
Received: from belphegor.brq.redhat.com (nat-pool-brq-t.redhat.com [213.175.37.10])
        by zimbra.v3.sk (Postfix) with ESMTPSA id 0D5F9D986A;
        Sat,  7 Sep 2019 17:18:56 +0200 (CEST)
From:   Lubomir Rintel <lkundrak@v3.sk>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH] libertas: use mesh_wdev->ssid instead of priv->mesh_ssid
Date:   Sat,  7 Sep 2019 17:18:55 +0200
Message-Id: <20190907151855.2637984-1-lkundrak@v3.sk>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the commit e86dc1ca4676 ("Libertas: cfg80211 support") we've lost
the ability to actually set the Mesh SSID from userspace.
NL80211_CMD_SET_INTERFACE with NL80211_ATTR_MESH_ID sets the mesh point
interface's ssid field. Let's use that one for the Libertas Mesh
operation

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/net/wireless/marvell/libertas/dev.h  |  2 --
 drivers/net/wireless/marvell/libertas/mesh.c | 31 +++++++++++++-------
 drivers/net/wireless/marvell/libertas/mesh.h |  3 +-
 3 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/dev.h b/drivers/net/wi=
reless/marvell/libertas/dev.h
index 4691349300265..4b6e05a8e5d54 100644
--- a/drivers/net/wireless/marvell/libertas/dev.h
+++ b/drivers/net/wireless/marvell/libertas/dev.h
@@ -58,8 +58,6 @@ struct lbs_private {
 #ifdef CONFIG_LIBERTAS_MESH
 	struct lbs_mesh_stats mstats;
 	uint16_t mesh_tlv;
-	u8 mesh_ssid[IEEE80211_MAX_SSID_LEN + 1];
-	u8 mesh_ssid_len;
 	u8 mesh_channel;
 #endif
=20
diff --git a/drivers/net/wireless/marvell/libertas/mesh.c b/drivers/net/w=
ireless/marvell/libertas/mesh.c
index 2315fdff56c2f..2747c957d18c9 100644
--- a/drivers/net/wireless/marvell/libertas/mesh.c
+++ b/drivers/net/wireless/marvell/libertas/mesh.c
@@ -86,6 +86,7 @@ static int lbs_mesh_config_send(struct lbs_private *pri=
v,
 static int lbs_mesh_config(struct lbs_private *priv, uint16_t action,
 		uint16_t chan)
 {
+	struct wireless_dev *mesh_wdev;
 	struct cmd_ds_mesh_config cmd;
 	struct mrvl_meshie *ie;
=20
@@ -105,10 +106,17 @@ static int lbs_mesh_config(struct lbs_private *priv=
, uint16_t action,
 		ie->val.active_protocol_id =3D MARVELL_MESH_PROTO_ID_HWMP;
 		ie->val.active_metric_id =3D MARVELL_MESH_METRIC_ID;
 		ie->val.mesh_capability =3D MARVELL_MESH_CAPABILITY;
-		ie->val.mesh_id_len =3D priv->mesh_ssid_len;
-		memcpy(ie->val.mesh_id, priv->mesh_ssid, priv->mesh_ssid_len);
+
+		if (priv->mesh_dev) {
+			mesh_wdev =3D priv->mesh_dev->ieee80211_ptr;
+			ie->val.mesh_id_len =3D mesh_wdev->mesh_id_up_len;
+			memcpy(ie->val.mesh_id, mesh_wdev->ssid,
+						mesh_wdev->mesh_id_up_len);
+		}
+
 		ie->len =3D sizeof(struct mrvl_meshie_val) -
-			IEEE80211_MAX_SSID_LEN + priv->mesh_ssid_len;
+			IEEE80211_MAX_SSID_LEN + ie->val.mesh_id_len;
+
 		cmd.length =3D cpu_to_le16(sizeof(struct mrvl_meshie_val));
 		break;
 	case CMD_ACT_MESH_CONFIG_STOP:
@@ -117,8 +125,8 @@ static int lbs_mesh_config(struct lbs_private *priv, =
uint16_t action,
 		return -1;
 	}
 	lbs_deb_cmd("mesh config action %d type %x channel %d SSID %*pE\n",
-		    action, priv->mesh_tlv, chan, priv->mesh_ssid_len,
-		    priv->mesh_ssid);
+		    action, priv->mesh_tlv, chan, ie->val.mesh_id_len,
+		    ie->val.mesh_id);
=20
 	return __lbs_mesh_config_send(priv, &cmd, action, priv->mesh_tlv);
 }
@@ -863,12 +871,6 @@ int lbs_init_mesh(struct lbs_private *priv)
 	/* Stop meshing until interface is brought up */
 	lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_STOP, 1);
=20
-	if (priv->mesh_tlv) {
-		sprintf(priv->mesh_ssid, "mesh");
-		priv->mesh_ssid_len =3D 4;
-		ret =3D 1;
-	}
-
 	return ret;
 }
=20
@@ -997,6 +999,13 @@ static int lbs_add_mesh(struct lbs_private *priv)
=20
 	mesh_wdev->iftype =3D NL80211_IFTYPE_MESH_POINT;
 	mesh_wdev->wiphy =3D priv->wdev->wiphy;
+
+	if (priv->mesh_tlv) {
+		sprintf(mesh_wdev->ssid, "mesh");
+		mesh_wdev->mesh_id_up_len =3D 4;
+		ret =3D 1;
+	}
+
 	mesh_wdev->netdev =3D mesh_dev;
=20
 	mesh_dev->ml_priv =3D priv;
diff --git a/drivers/net/wireless/marvell/libertas/mesh.h b/drivers/net/w=
ireless/marvell/libertas/mesh.h
index dfe22c91aade0..1561018f226fd 100644
--- a/drivers/net/wireless/marvell/libertas/mesh.h
+++ b/drivers/net/wireless/marvell/libertas/mesh.h
@@ -24,8 +24,7 @@ void lbs_remove_mesh(struct lbs_private *priv);
=20
 static inline bool lbs_mesh_activated(struct lbs_private *priv)
 {
-	/* Mesh SSID is only programmed after successful init */
-	return priv->mesh_ssid_len !=3D 0;
+	return !!priv->mesh_tlv;
 }
=20
 int lbs_mesh_set_channel(struct lbs_private *priv, u8 channel);
--=20
2.21.0

