Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E19D198596
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 22:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729372AbgC3UlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 16:41:02 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45334 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729299AbgC3UlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 16:41:02 -0400
Received: by mail-wr1-f66.google.com with SMTP id t7so23307094wrw.12
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 13:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+tGIG6SQUzoIjfO4WQZB6NRMG2/a22HH7D+VatxbZMY=;
        b=VZIIAfkToEXAlJH29tZkatAj/G/ICOLghfx/cdhzlgC4yKQGpwGwav4cgQZhJFtd5H
         pNdpfIKHpyYRzSTkcxkoe/vBy0MeVYvIap6StxdDXVZyAvXptf0WNh35O4jTSDM/mD/g
         iC+3G3NRv2ofXwcaxaWtrnOZaTIqJmLTELfbTA4es9dux0+gtxH1GQ+sXvksKvdeJku+
         cniyFSNCKZ0PuorrtmdmO7wmK68xvhimFGuK3oj18h0fpI/PAnuez/FnJ9CJboqaAq/z
         DSCsRz9z4DLNTHxi30/F07ImXDIw24Pzcb93wR8Iy0k3YoScIKaG4Job/JEpoLpxdhVh
         vrGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+tGIG6SQUzoIjfO4WQZB6NRMG2/a22HH7D+VatxbZMY=;
        b=bAH40GPUaU5R+AJ+/+8WqXxM4z5MejyrkmJC+rUJosXjaJei/oAv3Qan7LfExQsH1M
         cm8U92n8Mpv1SQgvrfkK4kXr80Z3/kBysW+JdmE5Qmr40bPycvTlEY55Hy9JUOep7nd2
         GYmtlUsED+wx6um4lFNB6b2+l44MR0ljICcfqPDDgPEXs3u9iQaSEsIcr4bLEs0NftJU
         2aM44giIhoe7u1iYUiyfyXG77dbxXflfwwoZwqrwyr8WQWNLq8ZvWPDIAW9Zgsm9ID5R
         TB9aJjMI+KXsHteZmqFDTmQXegEIHXdU092nD2tk3QJYPN+wmH1pzwCxWR5wderwSSDE
         iFbA==
X-Gm-Message-State: ANhLgQ356Cnxe7LK5QBh+b9wd454RB2+8YmCV0nTRMqUOH18FIvi4aUz
        azFcQ9u21B5WxrgyRmyYiFJJ0KPL
X-Google-Smtp-Source: ADFU+vuIExxRnwnkFnsSVNz3JOxk9ORo1GM9EPqhN4mS7YMO8imXJNILZ+lbqC8z4JH2G7QEyruJiA==
X-Received: by 2002:a5d:5687:: with SMTP id f7mr15973672wrv.425.1585600858286;
        Mon, 30 Mar 2020 13:40:58 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o16sm23371109wrs.44.2020.03.30.13.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 13:40:57 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        dan.carpenter@oracle.com
Subject: [PATCH net-next 8/9] net: dsa: bcm_sf2: Add support for matching VLAN TCI
Date:   Mon, 30 Mar 2020 13:40:31 -0700
Message-Id: <20200330204032.26313-9-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200330204032.26313-1-f.fainelli@gmail.com>
References: <20200330204032.26313-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update relevant code paths to support the programming and matching of
VLAN TCI, this is the only member of the ethtool_flow_ext that we can
match, the switch does not permit matching the VLAN Ethernet Type field.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2_cfp.c | 52 +++++++++++++++++++++++++----------
 1 file changed, 38 insertions(+), 14 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2_cfp.c b/drivers/net/dsa/bcm_sf2_cfp.c
index 8529f55a4d1f..7b10a9f31538 100644
--- a/drivers/net/dsa/bcm_sf2_cfp.c
+++ b/drivers/net/dsa/bcm_sf2_cfp.c
@@ -261,6 +261,7 @@ static int bcm_sf2_cfp_act_pol_set(struct bcm_sf2_priv *priv,
 static void bcm_sf2_cfp_slice_ipv4(struct bcm_sf2_priv *priv,
 				   struct flow_dissector_key_ipv4_addrs *addrs,
 				   struct flow_dissector_key_ports *ports,
+				   const __be16 vlan_tci,
 				   unsigned int slice_num, u8 num_udf,
 				   bool mask)
 {
@@ -270,16 +271,17 @@ static void bcm_sf2_cfp_slice_ipv4(struct bcm_sf2_priv *priv,
 	 * S-Tag		[23:8]
 	 * C-Tag		[7:0]
 	 */
+	reg = udf_lower_bits(num_udf) << 24 | be16_to_cpu(vlan_tci) >> 8;
 	if (mask)
-		core_writel(priv, udf_lower_bits(num_udf) << 24, CORE_CFP_MASK_PORT(5));
+		core_writel(priv, reg, CORE_CFP_MASK_PORT(5));
 	else
-		core_writel(priv, udf_lower_bits(num_udf) << 24, CORE_CFP_DATA_PORT(5));
+		core_writel(priv, reg, CORE_CFP_DATA_PORT(5));
 
 	/* C-Tag		[31:24]
 	 * UDF_n_A8		[23:8]
 	 * UDF_n_A7		[7:0]
 	 */
-	reg = 0;
+	reg = (u32)(be16_to_cpu(vlan_tci) & 0xff) << 24;
 	if (mask)
 		offset = CORE_CFP_MASK_PORT(4);
 	else
@@ -345,6 +347,7 @@ static int bcm_sf2_cfp_ipv4_rule_set(struct bcm_sf2_priv *priv, int port,
 				     struct ethtool_rx_flow_spec *fs)
 {
 	struct ethtool_rx_flow_spec_input input = {};
+	__be16 vlan_tci = 0 , vlan_m_tci = 0xffff;
 	const struct cfp_udf_layout *layout;
 	unsigned int slice_num, rule_index;
 	struct ethtool_rx_flow_rule *flow;
@@ -369,6 +372,12 @@ static int bcm_sf2_cfp_ipv4_rule_set(struct bcm_sf2_priv *priv, int port,
 
 	ip_frag = !!(be32_to_cpu(fs->h_ext.data[0]) & 1);
 
+	/* Extract VLAN TCI */
+	if (fs->flow_type & FLOW_EXT) {
+		vlan_tci = fs->h_ext.vlan_tci;
+		vlan_m_tci = fs->m_ext.vlan_tci;
+	}
+
 	/* Locate the first rule available */
 	if (fs->location == RX_CLS_LOC_ANY)
 		rule_index = find_first_zero_bit(priv->cfp.used,
@@ -431,10 +440,10 @@ static int bcm_sf2_cfp_ipv4_rule_set(struct bcm_sf2_priv *priv, int port,
 		    udf_upper_bits(num_udf), CORE_CFP_MASK_PORT(6));
 
 	/* Program the match and the mask */
-	bcm_sf2_cfp_slice_ipv4(priv, ipv4.key, ports.key, slice_num,
-			       num_udf, false);
-	bcm_sf2_cfp_slice_ipv4(priv, ipv4.mask, ports.mask, SLICE_NUM_MASK,
-			       num_udf, true);
+	bcm_sf2_cfp_slice_ipv4(priv, ipv4.key, ports.key, vlan_tci,
+			       slice_num, num_udf, false);
+	bcm_sf2_cfp_slice_ipv4(priv, ipv4.mask, ports.mask, vlan_m_tci,
+			       SLICE_NUM_MASK, num_udf, true);
 
 	/* Insert into TCAM now */
 	bcm_sf2_cfp_rule_addr_set(priv, rule_index);
@@ -470,6 +479,7 @@ static int bcm_sf2_cfp_ipv4_rule_set(struct bcm_sf2_priv *priv, int port,
 
 static void bcm_sf2_cfp_slice_ipv6(struct bcm_sf2_priv *priv,
 				   const __be32 *ip6_addr, const __be16 port,
+				   const __be16 vlan_tci,
 				   unsigned int slice_num, u32 udf_bits,
 				   bool mask)
 {
@@ -479,10 +489,11 @@ static void bcm_sf2_cfp_slice_ipv6(struct bcm_sf2_priv *priv,
 	 * S-Tag		[23:8]
 	 * C-Tag		[7:0]
 	 */
+	reg = udf_bits << 24 | be16_to_cpu(vlan_tci) >> 8;
 	if (mask)
-		core_writel(priv, udf_bits << 24, CORE_CFP_MASK_PORT(5));
+		core_writel(priv, reg, CORE_CFP_MASK_PORT(5));
 	else
-		core_writel(priv, udf_bits << 24, CORE_CFP_DATA_PORT(5));
+		core_writel(priv, reg, CORE_CFP_DATA_PORT(5));
 
 	/* C-Tag		[31:24]
 	 * UDF_n_B8		[23:8]	(port)
@@ -490,6 +501,7 @@ static void bcm_sf2_cfp_slice_ipv6(struct bcm_sf2_priv *priv,
 	 */
 	reg = be32_to_cpu(ip6_addr[3]);
 	val = (u32)be16_to_cpu(port) << 8 | ((reg >> 8) & 0xff);
+	val |= (u32)(be16_to_cpu(vlan_tci) & 0xff) << 24;
 	if (mask)
 		offset = CORE_CFP_MASK_PORT(4);
 	else
@@ -598,6 +610,11 @@ static int bcm_sf2_cfp_rule_cmp(struct bcm_sf2_priv *priv, int port,
 
 		ret = memcmp(&rule->fs.h_u, &fs->h_u, fs_size);
 		ret |= memcmp(&rule->fs.m_u, &fs->m_u, fs_size);
+		/* Compare VLAN TCI values as well */
+		if (rule->fs.flow_type & FLOW_EXT) {
+			ret |= rule->fs.h_ext.vlan_tci != fs->h_ext.vlan_tci;
+			ret |= rule->fs.m_ext.vlan_tci != fs->m_ext.vlan_tci;
+		}
 		if (ret == 0)
 			break;
 	}
@@ -611,6 +628,7 @@ static int bcm_sf2_cfp_ipv6_rule_set(struct bcm_sf2_priv *priv, int port,
 				     struct ethtool_rx_flow_spec *fs)
 {
 	struct ethtool_rx_flow_spec_input input = {};
+	__be16 vlan_tci = 0, vlan_m_tci = 0xffff;
 	unsigned int slice_num, rule_index[2];
 	const struct cfp_udf_layout *layout;
 	struct ethtool_rx_flow_rule *flow;
@@ -634,6 +652,12 @@ static int bcm_sf2_cfp_ipv6_rule_set(struct bcm_sf2_priv *priv, int port,
 
 	ip_frag = !!(be32_to_cpu(fs->h_ext.data[0]) & 1);
 
+	/* Extract VLAN TCI */
+	if (fs->flow_type & FLOW_EXT) {
+		vlan_tci = fs->h_ext.vlan_tci;
+		vlan_m_tci = fs->m_ext.vlan_tci;
+	}
+
 	layout = &udf_tcpip6_layout;
 	slice_num = bcm_sf2_get_slice_number(layout, 0);
 	if (slice_num == UDF_NUM_SLICES)
@@ -717,10 +741,10 @@ static int bcm_sf2_cfp_ipv6_rule_set(struct bcm_sf2_priv *priv, int port,
 
 	/* Slice the IPv6 source address and port */
 	bcm_sf2_cfp_slice_ipv6(priv, ipv6.key->src.in6_u.u6_addr32,
-			       ports.key->src, slice_num,
+			       ports.key->src, vlan_tci, slice_num,
 			       udf_lower_bits(num_udf), false);
 	bcm_sf2_cfp_slice_ipv6(priv, ipv6.mask->src.in6_u.u6_addr32,
-			       ports.mask->src, SLICE_NUM_MASK,
+			       ports.mask->src, vlan_m_tci, SLICE_NUM_MASK,
 			       udf_lower_bits(num_udf), true);
 
 	/* Insert into TCAM now because we need to insert a second rule */
@@ -773,10 +797,10 @@ static int bcm_sf2_cfp_ipv6_rule_set(struct bcm_sf2_priv *priv, int port,
 	core_writel(priv, reg, CORE_CFP_MASK_PORT(6));
 
 	bcm_sf2_cfp_slice_ipv6(priv, ipv6.key->dst.in6_u.u6_addr32,
-			       ports.key->dst, slice_num,
+			       ports.key->dst, 0, slice_num,
 			       0, false);
 	bcm_sf2_cfp_slice_ipv6(priv, ipv6.mask->dst.in6_u.u6_addr32,
-			       ports.key->dst, SLICE_NUM_MASK,
+			       ports.key->dst, 0, SLICE_NUM_MASK,
 			       0, true);
 
 	/* Insert into TCAM now */
@@ -878,7 +902,7 @@ static int bcm_sf2_cfp_rule_set(struct dsa_switch *ds, int port,
 	int ret = -EINVAL;
 
 	/* Check for unsupported extensions */
-	if ((fs->flow_type & (FLOW_EXT || FLOW_MAC_EXT)) ||
+	if ((fs->flow_type & FLOW_MAC_EXT) ||
 	    fs->m_ext.data[1])
 		return -EINVAL;
 
-- 
2.17.1

