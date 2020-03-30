Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8101986BB
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 23:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729404AbgC3VjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 17:39:22 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42693 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729129AbgC3VjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 17:39:20 -0400
Received: by mail-wr1-f65.google.com with SMTP id h15so23473948wrx.9
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 14:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Tnxi8udtjZOHkoTyT8NFuYHW6nmYNu3gQRUZG88+tNI=;
        b=OVbYbMmUYIHFklHhjA8GgDdouDawzA4+2MOEBI43O3WfIuSthL2xP58EE7VjuwSZz8
         Ly6VuzqqNCpf5C9PkDHA7zZ/g9cBDlErUoXl0jsVJCrhcDN8qyNmSPz+BVGll+Z8AGmB
         thzcQJHWIuINiOxmdpRjYES7CnkJRKp1ae9nmMGEoYWCHEFbKQexeyWmOQEpAv08Y7NT
         ZWTEhXvct0quzP72SdcBkwnPMRui3o0EO4yJQa0YsTPFMbB90C361WVdli2nmVZEWPN8
         Kxi0dPc7FiFlG/oKhnUmRVsuA/af7AN07dCdlMzgKDDqaUqZrc0MNRWbx4dbdbKevopq
         dLcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Tnxi8udtjZOHkoTyT8NFuYHW6nmYNu3gQRUZG88+tNI=;
        b=AC1h93r1Qd6BlBDsvNxSp+Svnt4nWAWph99tfLJr3EAfjdNDEUWxN1DmnNB1NLmePI
         G6pJ7xxLGdNMTnSk258XXtdVYXtISW6zECCCpVAV/iKghFpia/JikDA2l6+jhDtkgtId
         Wmx1bPUtRPfJrppSRahubtU5eimUbkzdwmqE9QPfJ+6orlqmvw0BoPH5x1fySqAOTFea
         ZB9c5hYu5wY1YNlKnnztc2LoBvMz50zyGr0WWWkt5fx/JM4AaZDjPzRbHHg/lyr4/tWE
         XGGlrS1qClz6UUUUC3gN1BWd8ZWfGIBUy0LO9nIZoTQoNmebkJW8ymQHHhr3JXsoVshw
         h4aw==
X-Gm-Message-State: ANhLgQ3pDFnoFqW4S3DzMMafMImxKLAXRJnL/P2kN192o3pv+cS1/XCg
        K1xuF2R/f1E2YVaagkZcC/eJWDND
X-Google-Smtp-Source: ADFU+vsMQiyYCe+51RhcglSexY+U0hu5wp71ICw8Pz5eRBeLRNztYHHmsiV48KLA2vE/2jzAkQW3aQ==
X-Received: by 2002:a05:6000:1205:: with SMTP id e5mr17977334wrx.73.1585604357797;
        Mon, 30 Mar 2020 14:39:17 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r17sm23600853wrx.46.2020.03.30.14.39.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 14:39:17 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        dan.carpenter@oracle.com
Subject: [PATCH net-next v2 8/9] net: dsa: bcm_sf2: Add support for matching VLAN TCI
Date:   Mon, 30 Mar 2020 14:38:53 -0700
Message-Id: <20200330213854.4856-9-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200330213854.4856-1-f.fainelli@gmail.com>
References: <20200330213854.4856-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update relevant code paths to support the programming and matching of
VLAN TCI, this is the only member of the ethtool_flow_ext that we can
match, the switch does not permit matching the VLAN Ethernet Type field.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2_cfp.c | 53 +++++++++++++++++++++++++----------
 1 file changed, 38 insertions(+), 15 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2_cfp.c b/drivers/net/dsa/bcm_sf2_cfp.c
index a6cc076f1a67..7b10a9f31538 100644
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
@@ -878,8 +902,7 @@ static int bcm_sf2_cfp_rule_set(struct dsa_switch *ds, int port,
 	int ret = -EINVAL;
 
 	/* Check for unsupported extensions */
-	if ((fs->flow_type & FLOW_EXT) ||
-	    (fs->flow_type & FLOW_MAC_EXT) ||
+	if ((fs->flow_type & FLOW_MAC_EXT) ||
 	    fs->m_ext.data[1])
 		return -EINVAL;
 
-- 
2.17.1

