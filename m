Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95DAFAC922
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 22:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436714AbfIGUBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 16:01:23 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:36827 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406151AbfIGUBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 16:01:21 -0400
Received: by mail-qk1-f193.google.com with SMTP id s18so9098255qkj.3
        for <netdev@vger.kernel.org>; Sat, 07 Sep 2019 13:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1YgcD9PwYZNL/2nxblWLmUV1H5RKZO+r5RlmHPiYBBU=;
        b=nDRIDshhJ0pQpI9zi4yT26sa9MmiQM/0Z0H4JgUaG6s6V5/5VimXHfZtDsxGHVUPe4
         QvTzPc+sb0Q32UWG73uVvmI9FM3aMqPt8AOu8ALKNTGRHAxpmWx17JSntUcu/ixkYYFI
         mYdxGbCy3g0vaPLjVp0gv2IlKmiQtlTVvbk6WHrIX7t48wqXu22T48Bt6mcn58Qs05gs
         vFQAbsa9S+h2/voSgHORuuvPbLbl7GMSj1qMwJtLz/lnO+U580rK/w+ZykHS76jGeDqh
         vya2QUfRu/NlDiCTwfBxSQ4Mo/l2VhvwAw/9+5xGxU6cnyS4iQuwWVfnTsCDGPfXtpO0
         K9MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1YgcD9PwYZNL/2nxblWLmUV1H5RKZO+r5RlmHPiYBBU=;
        b=Kd3PaqAJH/+x0/EuOYQcbn1VSPGKtStyzsZrw3MclpLE/ZxeyGa60/TSLHBphrHrza
         PZyml6DOZ1+6TU5/Ioc0zd6/pIwMDW61eKFzSLAO8n8L667sr4BDvPpySjisltLqB80I
         DS1R+xTDcPtnr1gi4CLF8CIk3X2GhZSd3NGr84G5/7sLOvPv6R0HsDfkz7TRVNX91zjk
         KJG/ElS6YktGNA+3Kjt0E0dPt51LBYysT7WqwwVezE2TfvXizf0K/oU0mSWj2c3GnzrM
         //67eQOl70LxwizvELG6grXNkM1zkBUNtRwOZGC5H8+5Q+QylH3mo/PoiGy+8m7juBu1
         yZ7g==
X-Gm-Message-State: APjAAAVKm4o1IgbDpIJ0bWv7rU3pnJJPmc2lDscSLpmBKZ0XXArTTkDh
        idH65VlaCaqnyJGAoBH+b2pO7X6h
X-Google-Smtp-Source: APXvYqwKD5AMWhkJMymhimVhZvijQ4RWCpV/am8KNiC/xl37qmY8uDoHmoNeB0wnAsR5ZGen5ENxxQ==
X-Received: by 2002:a05:620a:15c4:: with SMTP id o4mr15611208qkm.62.1567886479119;
        Sat, 07 Sep 2019 13:01:19 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id h68sm4321832qkf.2.2019.09.07.13.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Sep 2019 13:01:18 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, f.fainelli@gmail.com, andrew@lunn.ch,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 2/3] net: dsa: mv88e6xxx: introduce .port_set_policy
Date:   Sat,  7 Sep 2019 16:00:48 -0400
Message-Id: <20190907200049.25273-3-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190907200049.25273-1-vivien.didelot@gmail.com>
References: <20190907200049.25273-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new .port_set_policy operation to configure a port's
Policy Control List, based on mapping such as DA, SA, Etype and so on.

Models similar to 88E6352 and 88E6390 are supported at the moment.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c |  9 ++++
 drivers/net/dsa/mv88e6xxx/chip.h | 22 ++++++++++
 drivers/net/dsa/mv88e6xxx/port.c | 74 ++++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/port.h | 17 +++++++-
 4 files changed, 121 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 0d54a69f3622..6f4d5303a1f3 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3132,6 +3132,7 @@ static const struct mv88e6xxx_ops mv88e6172_ops = {
 	.port_set_rgmii_delay = mv88e6352_port_set_rgmii_delay,
 	.port_set_speed = mv88e6352_port_set_speed,
 	.port_tag_remap = mv88e6095_port_tag_remap,
+	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
@@ -3218,6 +3219,7 @@ static const struct mv88e6xxx_ops mv88e6176_ops = {
 	.port_set_rgmii_delay = mv88e6352_port_set_rgmii_delay,
 	.port_set_speed = mv88e6352_port_set_speed,
 	.port_tag_remap = mv88e6095_port_tag_remap,
+	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
@@ -3303,6 +3305,7 @@ static const struct mv88e6xxx_ops mv88e6190_ops = {
 	.port_set_speed = mv88e6390_port_set_speed,
 	.port_max_speed_mode = mv88e6390_port_max_speed_mode,
 	.port_tag_remap = mv88e6390_port_tag_remap,
+	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
@@ -3351,6 +3354,7 @@ static const struct mv88e6xxx_ops mv88e6190x_ops = {
 	.port_set_speed = mv88e6390x_port_set_speed,
 	.port_max_speed_mode = mv88e6390x_port_max_speed_mode,
 	.port_tag_remap = mv88e6390_port_tag_remap,
+	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
@@ -3448,6 +3452,7 @@ static const struct mv88e6xxx_ops mv88e6240_ops = {
 	.port_set_rgmii_delay = mv88e6352_port_set_rgmii_delay,
 	.port_set_speed = mv88e6352_port_set_speed,
 	.port_tag_remap = mv88e6095_port_tag_remap,
+	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
@@ -3539,6 +3544,7 @@ static const struct mv88e6xxx_ops mv88e6290_ops = {
 	.port_set_speed = mv88e6390_port_set_speed,
 	.port_max_speed_mode = mv88e6390_port_max_speed_mode,
 	.port_tag_remap = mv88e6390_port_tag_remap,
+	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
@@ -3809,6 +3815,7 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
 	.port_set_rgmii_delay = mv88e6352_port_set_rgmii_delay,
 	.port_set_speed = mv88e6352_port_set_speed,
 	.port_tag_remap = mv88e6095_port_tag_remap,
+	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
@@ -3863,6 +3870,7 @@ static const struct mv88e6xxx_ops mv88e6390_ops = {
 	.port_set_speed = mv88e6390_port_set_speed,
 	.port_max_speed_mode = mv88e6390_port_max_speed_mode,
 	.port_tag_remap = mv88e6390_port_tag_remap,
+	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
@@ -3915,6 +3923,7 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 	.port_set_speed = mv88e6390x_port_set_speed,
 	.port_max_speed_mode = mv88e6390x_port_max_speed_mode,
 	.port_tag_remap = mv88e6390_port_tag_remap,
+	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 6bc0a4e4fe7b..04a329a98158 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -189,6 +189,24 @@ struct mv88e6xxx_port_hwtstamp {
 	struct hwtstamp_config tstamp_config;
 };
 
+enum mv88e6xxx_policy_mapping {
+	MV88E6XXX_POLICY_MAPPING_DA,
+	MV88E6XXX_POLICY_MAPPING_SA,
+	MV88E6XXX_POLICY_MAPPING_VTU,
+	MV88E6XXX_POLICY_MAPPING_ETYPE,
+	MV88E6XXX_POLICY_MAPPING_PPPOE,
+	MV88E6XXX_POLICY_MAPPING_VBAS,
+	MV88E6XXX_POLICY_MAPPING_OPT82,
+	MV88E6XXX_POLICY_MAPPING_UDP,
+};
+
+enum mv88e6xxx_policy_action {
+	MV88E6XXX_POLICY_ACTION_NORMAL,
+	MV88E6XXX_POLICY_ACTION_MIRROR,
+	MV88E6XXX_POLICY_ACTION_TRAP,
+	MV88E6XXX_POLICY_ACTION_DISCARD,
+};
+
 struct mv88e6xxx_port {
 	struct mv88e6xxx_chip *chip;
 	int port;
@@ -381,6 +399,10 @@ struct mv88e6xxx_ops {
 
 	int (*port_tag_remap)(struct mv88e6xxx_chip *chip, int port);
 
+	int (*port_set_policy)(struct mv88e6xxx_chip *chip, int port,
+			       enum mv88e6xxx_policy_mapping mapping,
+			       enum mv88e6xxx_policy_action action);
+
 	int (*port_set_frame_mode)(struct mv88e6xxx_chip *chip, int port,
 				   enum mv88e6xxx_frame_mode mode);
 	int (*port_set_egress_floods)(struct mv88e6xxx_chip *chip, int port,
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 04006344adb2..15ef81654b67 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -1341,3 +1341,77 @@ int mv88e6390_port_tag_remap(struct mv88e6xxx_chip *chip, int port)
 
 	return 0;
 }
+
+/* Offset 0x0E: Policy Control Register */
+
+int mv88e6352_port_set_policy(struct mv88e6xxx_chip *chip, int port,
+			      enum mv88e6xxx_policy_mapping mapping,
+			      enum mv88e6xxx_policy_action action)
+{
+	u16 reg, mask, val;
+	int shift;
+	int err;
+
+	switch (mapping) {
+	case MV88E6XXX_POLICY_MAPPING_DA:
+		shift = __bf_shf(MV88E6XXX_PORT_POLICY_CTL_DA_MASK);
+		mask = MV88E6XXX_PORT_POLICY_CTL_DA_MASK;
+		break;
+	case MV88E6XXX_POLICY_MAPPING_SA:
+		shift = __bf_shf(MV88E6XXX_PORT_POLICY_CTL_SA_MASK);
+		mask = MV88E6XXX_PORT_POLICY_CTL_SA_MASK;
+		break;
+	case MV88E6XXX_POLICY_MAPPING_VTU:
+		shift = __bf_shf(MV88E6XXX_PORT_POLICY_CTL_VTU_MASK);
+		mask = MV88E6XXX_PORT_POLICY_CTL_VTU_MASK;
+		break;
+	case MV88E6XXX_POLICY_MAPPING_ETYPE:
+		shift = __bf_shf(MV88E6XXX_PORT_POLICY_CTL_ETYPE_MASK);
+		mask = MV88E6XXX_PORT_POLICY_CTL_ETYPE_MASK;
+		break;
+	case MV88E6XXX_POLICY_MAPPING_PPPOE:
+		shift = __bf_shf(MV88E6XXX_PORT_POLICY_CTL_PPPOE_MASK);
+		mask = MV88E6XXX_PORT_POLICY_CTL_PPPOE_MASK;
+		break;
+	case MV88E6XXX_POLICY_MAPPING_VBAS:
+		shift = __bf_shf(MV88E6XXX_PORT_POLICY_CTL_VBAS_MASK);
+		mask = MV88E6XXX_PORT_POLICY_CTL_VBAS_MASK;
+		break;
+	case MV88E6XXX_POLICY_MAPPING_OPT82:
+		shift = __bf_shf(MV88E6XXX_PORT_POLICY_CTL_OPT82_MASK);
+		mask = MV88E6XXX_PORT_POLICY_CTL_OPT82_MASK;
+		break;
+	case MV88E6XXX_POLICY_MAPPING_UDP:
+		shift = __bf_shf(MV88E6XXX_PORT_POLICY_CTL_UDP_MASK);
+		mask = MV88E6XXX_PORT_POLICY_CTL_UDP_MASK;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	switch (action) {
+	case MV88E6XXX_POLICY_ACTION_NORMAL:
+		val = MV88E6XXX_PORT_POLICY_CTL_NORMAL;
+		break;
+	case MV88E6XXX_POLICY_ACTION_MIRROR:
+		val = MV88E6XXX_PORT_POLICY_CTL_MIRROR;
+		break;
+	case MV88E6XXX_POLICY_ACTION_TRAP:
+		val = MV88E6XXX_PORT_POLICY_CTL_TRAP;
+		break;
+	case MV88E6XXX_POLICY_ACTION_DISCARD:
+		val = MV88E6XXX_PORT_POLICY_CTL_DISCARD;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_POLICY_CTL, &reg);
+	if (err)
+		return err;
+
+	reg &= ~mask;
+	reg |= (val << shift) & mask;
+
+	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_POLICY_CTL, reg);
+}
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index d4e9bea6e82f..03a480cd71b9 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -222,7 +222,19 @@
 #define MV88E6XXX_PORT_PRI_OVERRIDE	0x0d
 
 /* Offset 0x0E: Policy Control Register */
-#define MV88E6XXX_PORT_POLICY_CTL	0x0e
+#define MV88E6XXX_PORT_POLICY_CTL		0x0e
+#define MV88E6XXX_PORT_POLICY_CTL_DA_MASK	0xc000
+#define MV88E6XXX_PORT_POLICY_CTL_SA_MASK	0x3000
+#define MV88E6XXX_PORT_POLICY_CTL_VTU_MASK	0x0c00
+#define MV88E6XXX_PORT_POLICY_CTL_ETYPE_MASK	0x0300
+#define MV88E6XXX_PORT_POLICY_CTL_PPPOE_MASK	0x00c0
+#define MV88E6XXX_PORT_POLICY_CTL_VBAS_MASK	0x0030
+#define MV88E6XXX_PORT_POLICY_CTL_OPT82_MASK	0x000c
+#define MV88E6XXX_PORT_POLICY_CTL_UDP_MASK	0x0003
+#define MV88E6XXX_PORT_POLICY_CTL_NORMAL	0x0000
+#define MV88E6XXX_PORT_POLICY_CTL_MIRROR	0x0001
+#define MV88E6XXX_PORT_POLICY_CTL_TRAP		0x0002
+#define MV88E6XXX_PORT_POLICY_CTL_DISCARD	0x0003
 
 /* Offset 0x0F: Port Special Ether Type */
 #define MV88E6XXX_PORT_ETH_TYPE		0x0f
@@ -324,6 +336,9 @@ int mv88e6185_port_set_egress_floods(struct mv88e6xxx_chip *chip, int port,
 				     bool unicast, bool multicast);
 int mv88e6352_port_set_egress_floods(struct mv88e6xxx_chip *chip, int port,
 				     bool unicast, bool multicast);
+int mv88e6352_port_set_policy(struct mv88e6xxx_chip *chip, int port,
+			      enum mv88e6xxx_policy_mapping mapping,
+			      enum mv88e6xxx_policy_action action);
 int mv88e6351_port_set_ether_type(struct mv88e6xxx_chip *chip, int port,
 				  u16 etype);
 int mv88e6xxx_port_set_message_port(struct mv88e6xxx_chip *chip, int port,
-- 
2.23.0

