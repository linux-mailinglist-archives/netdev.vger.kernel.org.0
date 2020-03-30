Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDB51986BA
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 23:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729390AbgC3VjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 17:39:21 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34551 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729373AbgC3VjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 17:39:19 -0400
Received: by mail-wr1-f66.google.com with SMTP id 65so23534982wrl.1
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 14:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XYmBphqrTY7r+OJWuQCYlMHXS/NTMbVuboYc8JF6NAY=;
        b=vNa1K8/qBfXWUfpbeLzadUHxldzxuxsB0lHHVbS+YyqDIvm+U3D84crGCx2ZuVZpKA
         1bjMkfEzHA1kj1BUPVJGTwGXIQQCGIaLfWe+H7lpIajhoU6Y7dfVgZEEdvV8/lBwQnYG
         nP3Ga3x1PHwUlB4fyXFGzUj2QX2qjaTcZWW4lnE+unV64V3jnbXmeeClU5U6fidUAyaY
         mwHdAouXD4USViwGnhRL7CuguOq09toVq3vogzJ5LkkRzss1nKNFsSxAGbiX2tye9ycm
         1Qiwj3zV0yvHl7gGeOSR6fsp5guH0cYp3XN/AkC5KLtGsY49Eg8dSsMCJEChYGvrjNRL
         MECg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XYmBphqrTY7r+OJWuQCYlMHXS/NTMbVuboYc8JF6NAY=;
        b=osD9hCyq2DUQfq4sigmU0J+h8YZT9BSOPyS9LVXcH9SC0UZ0J8JHi8cCFXQWValADh
         9rFMS4EaH1YwCP84v0hExGxpPCo5s5/2rqlvFB2hyW1huFBcpk+Lyx62Wm7NjIBH+WFO
         0RX8hIvykYoso3aoftpyDlMiZ9+D9bAXRzoqBdJWCMHz2l++9xO4ogs3G2CyoL/xRBbg
         2mHLY9mla3Gog6c7uligylkLTmDkjc2dd2iZfWmPQmhc7x3lGCT3lLSuqEWOynMCBqdq
         qksbDM5+Ecj9xP/Z/NrLTsLWGG9DlKfIv8X68+YLpGdil0ANywhBOaaeab4ZuSCeoS1u
         B0Vg==
X-Gm-Message-State: ANhLgQ0x6R5SVEARKtX6t2hRhhOp4kzzNUlaWc9GLhKkrnDxBJWBBZRL
        giG0Nrf47H8IKAsd/JoxokiaDF+Y
X-Google-Smtp-Source: ADFU+vve37dh3zuVS5IsCr1VNa2+XU6Zuoc3GIQBMWDvoEAHxqjvLFNjwd716gf/YQPn1yIhuPXbRA==
X-Received: by 2002:a5d:468c:: with SMTP id u12mr18015500wrq.394.1585604355643;
        Mon, 30 Mar 2020 14:39:15 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r17sm23600853wrx.46.2020.03.30.14.39.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 14:39:15 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        dan.carpenter@oracle.com
Subject: [PATCH net-next v2 7/9] net: dsa: bcm_sf2: Move writing of CFP_DATA(5) into slicing functions
Date:   Mon, 30 Mar 2020 14:38:52 -0700
Message-Id: <20200330213854.4856-8-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200330213854.4856-1-f.fainelli@gmail.com>
References: <20200330213854.4856-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for matching VLANs, move the writing of CFP_DATA(5) into
the IPv4 and IPv6 slicing logic since they are part of the per-flow
configuration.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2_cfp.c | 64 +++++++++++++++++------------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2_cfp.c b/drivers/net/dsa/bcm_sf2_cfp.c
index 40ea88c304de..a6cc076f1a67 100644
--- a/drivers/net/dsa/bcm_sf2_cfp.c
+++ b/drivers/net/dsa/bcm_sf2_cfp.c
@@ -261,11 +261,20 @@ static int bcm_sf2_cfp_act_pol_set(struct bcm_sf2_priv *priv,
 static void bcm_sf2_cfp_slice_ipv4(struct bcm_sf2_priv *priv,
 				   struct flow_dissector_key_ipv4_addrs *addrs,
 				   struct flow_dissector_key_ports *ports,
-				   unsigned int slice_num,
+				   unsigned int slice_num, u8 num_udf,
 				   bool mask)
 {
 	u32 reg, offset;
 
+	/* UDF_Valid[7:0]	[31:24]
+	 * S-Tag		[23:8]
+	 * C-Tag		[7:0]
+	 */
+	if (mask)
+		core_writel(priv, udf_lower_bits(num_udf) << 24, CORE_CFP_MASK_PORT(5));
+	else
+		core_writel(priv, udf_lower_bits(num_udf) << 24, CORE_CFP_DATA_PORT(5));
+
 	/* C-Tag		[31:24]
 	 * UDF_n_A8		[23:8]
 	 * UDF_n_A7		[7:0]
@@ -421,18 +430,11 @@ static int bcm_sf2_cfp_ipv4_rule_set(struct bcm_sf2_priv *priv, int port,
 	core_writel(priv, layout->udfs[slice_num].mask_value |
 		    udf_upper_bits(num_udf), CORE_CFP_MASK_PORT(6));
 
-	/* UDF_Valid[7:0]	[31:24]
-	 * S-Tag		[23:8]
-	 * C-Tag		[7:0]
-	 */
-	core_writel(priv, udf_lower_bits(num_udf) << 24, CORE_CFP_DATA_PORT(5));
-
-	/* Mask all but valid UDFs */
-	core_writel(priv, udf_lower_bits(num_udf) << 24, CORE_CFP_MASK_PORT(5));
-
 	/* Program the match and the mask */
-	bcm_sf2_cfp_slice_ipv4(priv, ipv4.key, ports.key, slice_num, false);
-	bcm_sf2_cfp_slice_ipv4(priv, ipv4.mask, ports.mask, SLICE_NUM_MASK, true);
+	bcm_sf2_cfp_slice_ipv4(priv, ipv4.key, ports.key, slice_num,
+			       num_udf, false);
+	bcm_sf2_cfp_slice_ipv4(priv, ipv4.mask, ports.mask, SLICE_NUM_MASK,
+			       num_udf, true);
 
 	/* Insert into TCAM now */
 	bcm_sf2_cfp_rule_addr_set(priv, rule_index);
@@ -468,11 +470,20 @@ static int bcm_sf2_cfp_ipv4_rule_set(struct bcm_sf2_priv *priv, int port,
 
 static void bcm_sf2_cfp_slice_ipv6(struct bcm_sf2_priv *priv,
 				   const __be32 *ip6_addr, const __be16 port,
-				   unsigned int slice_num,
+				   unsigned int slice_num, u32 udf_bits,
 				   bool mask)
 {
 	u32 reg, tmp, val, offset;
 
+	/* UDF_Valid[7:0]	[31:24]
+	 * S-Tag		[23:8]
+	 * C-Tag		[7:0]
+	 */
+	if (mask)
+		core_writel(priv, udf_bits << 24, CORE_CFP_MASK_PORT(5));
+	else
+		core_writel(priv, udf_bits << 24, CORE_CFP_DATA_PORT(5));
+
 	/* C-Tag		[31:24]
 	 * UDF_n_B8		[23:8]	(port)
 	 * UDF_n_B7 (upper)	[7:0]	(addr[15:8])
@@ -704,20 +715,13 @@ static int bcm_sf2_cfp_ipv6_rule_set(struct bcm_sf2_priv *priv, int port,
 	reg = layout->udfs[slice_num].mask_value | udf_upper_bits(num_udf);
 	core_writel(priv, reg, CORE_CFP_MASK_PORT(6));
 
-	/* UDF_Valid[7:0]	[31:24]
-	 * S-Tag		[23:8]
-	 * C-Tag		[7:0]
-	 */
-	core_writel(priv, udf_lower_bits(num_udf) << 24, CORE_CFP_DATA_PORT(5));
-
-	/* Mask all but valid UDFs */
-	core_writel(priv, udf_lower_bits(num_udf) << 24, CORE_CFP_MASK_PORT(5));
-
 	/* Slice the IPv6 source address and port */
 	bcm_sf2_cfp_slice_ipv6(priv, ipv6.key->src.in6_u.u6_addr32,
-			       ports.key->src, slice_num, false);
+			       ports.key->src, slice_num,
+			       udf_lower_bits(num_udf), false);
 	bcm_sf2_cfp_slice_ipv6(priv, ipv6.mask->src.in6_u.u6_addr32,
-			       ports.mask->src, SLICE_NUM_MASK, true);
+			       ports.mask->src, SLICE_NUM_MASK,
+			       udf_lower_bits(num_udf), true);
 
 	/* Insert into TCAM now because we need to insert a second rule */
 	bcm_sf2_cfp_rule_addr_set(priv, rule_index[0]);
@@ -768,16 +772,12 @@ static int bcm_sf2_cfp_ipv6_rule_set(struct bcm_sf2_priv *priv, int port,
 		udf_lower_bits(num_udf) << 8;
 	core_writel(priv, reg, CORE_CFP_MASK_PORT(6));
 
-	/* Don't care */
-	core_writel(priv, 0, CORE_CFP_DATA_PORT(5));
-
-	/* Mask all */
-	core_writel(priv, 0, CORE_CFP_MASK_PORT(5));
-
 	bcm_sf2_cfp_slice_ipv6(priv, ipv6.key->dst.in6_u.u6_addr32,
-			       ports.key->dst, slice_num, false);
+			       ports.key->dst, slice_num,
+			       0, false);
 	bcm_sf2_cfp_slice_ipv6(priv, ipv6.mask->dst.in6_u.u6_addr32,
-			       ports.key->dst, SLICE_NUM_MASK, true);
+			       ports.key->dst, SLICE_NUM_MASK,
+			       0, true);
 
 	/* Insert into TCAM now */
 	bcm_sf2_cfp_rule_addr_set(priv, rule_index[1]);
-- 
2.17.1

