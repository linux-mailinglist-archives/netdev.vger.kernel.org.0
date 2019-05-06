Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9461757E
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 11:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfEHJ4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 05:56:46 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40953 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbfEHJ4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 05:56:46 -0400
Received: by mail-pf1-f195.google.com with SMTP id u17so10227212pfn.7
        for <netdev@vger.kernel.org>; Wed, 08 May 2019 02:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=qquBjBove3ER5uhNFBRlaephH9pjEijqbalNiddfVs4=;
        b=p3eb0lEjArwwqGFJo0Wt1nNePLPDX9mKVNYRVzB7CPbrMUv5e91iFWJ/g8+XEikG7D
         EEQ6B6DY2cTaNTKU9XeUpiBeQMdBsqXvtFXbFpksVE5fYvfZPBiMxJZTUoAI+1l/OcAF
         bRmuaANnrtFltEJQbCbsv/7ML51xJMRhiKyOGc/ZPvBE07jOTuh2FF+sC2WI1KdBJkYa
         SIt/StiYQeiurWi4cazrRM4Qxa9xbozy2mGDJ8BbOVLdF7PcvpdlQvh4ZQgq3ldrueIi
         d2+XGBGL6y8+fbEumQdIIKEBU3T7tKnDOM/Tfu55NPkPffaniofqCtcxBZC9LsGFG4xx
         bX1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qquBjBove3ER5uhNFBRlaephH9pjEijqbalNiddfVs4=;
        b=Gubz7zwm0+eAXAyGtqXPU2BVlzm5b2ZvMiTO4zfFHn04+a6obDQBRCeW7bBP1g91Y9
         kEUZthOvI5JDxNQjDSpCJf8oiMeFgSNyNuuPEUZ/D2hob4SgG1LLdxFrFegcXc7AQaQM
         bmMGwcnqPuIEuiUJROLX87Oa5xMAQ5bLQ6Xx67zEK523CS0qduD2ViK+Ts/CZzPn1bqF
         quwTsvFGR3nqBA5ojTX9S1r6ftA6drYXc+Jy52AMHbmXP6F4rP3W20o4eBjJ1P6dh0pL
         MgqfBaI8XuwgY97zsStKMHuYcUoHHl2zREZ/EkWj5aMhMP5Ci38Qx9X3mvJE/hVHiFep
         d6pA==
X-Gm-Message-State: APjAAAXa7MPWyBvxZT4+6hrIJbFFgz+4pGKtx4OuAknlso4wMvAY5Vk2
        tN4LP1Hst28EbApDeOyNoRY=
X-Google-Smtp-Source: APXvYqxV6VgsR6ImGRNT8fPwHOcBVZZu56+G4jZyMo/Wj06m+WAmFjcC6gc5NubBbgWJJIXaGsJDEQ==
X-Received: by 2002:a63:c601:: with SMTP id w1mr46501149pgg.190.1557309405796;
        Wed, 08 May 2019 02:56:45 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id e23sm19927974pfi.159.2019.05.08.02.56.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 02:56:45 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     roid@mellanox.com, saeedm@mellanox.com
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH] net/mlx5e: Allow matching only enc_key_id/enc_dst_port for decapsulation action
Date:   Mon,  6 May 2019 11:28:37 -0700
Message-Id: <1557167317-50202-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

In some case, we don't care the enc_src_ip and enc_dst_ip, and
if we don't match the field enc_src_ip and enc_dst_ip, we can use
fewer flows in hardware when revice the tunnel packets. For example,
the tunnel packets may be sent from different hosts, we must offload
one rule for each host.

	$ tc filter add dev vxlan0 protocol ip parent ffff: prio 1 \
		flower dst_mac 00:11:22:33:44:00 \
		enc_src_ip Host0_IP enc_dst_ip 2.2.2.100 \
		enc_dst_port 4789 enc_key_id 100 \
		action tunnel_key unset action mirred egress redirect dev eth0_1

	$ tc filter add dev vxlan0 protocol ip parent ffff: prio 1 \
		flower dst_mac 00:11:22:33:44:00 \
		enc_src_ip Host1_IP enc_dst_ip 2.2.2.100 \
		enc_dst_port 4789 enc_key_id 100 \
		action tunnel_key unset action mirred egress redirect dev eth0_1

If we support flows which only match the enc_key_id and enc_dst_port,
a flow can process the packets sent to VM which (mac 00:11:22:33:44:00).

	$ tc filter add dev vxlan0 protocol ip parent ffff: prio 1 \
		flower dst_mac 00:11:22:33:44:00 \
		enc_dst_port 4789 enc_key_id 100 \
		action tunnel_key unset action mirred egress redirect dev eth0_1

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 27 +++++++------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 122f457..91e4db1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1339,7 +1339,6 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
 	void *headers_v = MLX5_ADDR_OF(fte_match_param, spec->match_value,
 				       outer_headers);
 	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
-	struct flow_match_control enc_control;
 	int err;
 
 	err = mlx5e_tc_tun_parse(filter_dev, priv, spec, f,
@@ -1350,9 +1349,7 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
 		return err;
 	}
 
-	flow_rule_match_enc_control(rule, &enc_control);
-
-	if (enc_control.key->addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS)) {
 		struct flow_match_ipv4_addrs match;
 
 		flow_rule_match_enc_ipv4_addrs(rule, &match);
@@ -1372,7 +1369,7 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
 
 		MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c, ethertype);
 		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ethertype, ETH_P_IP);
-	} else if (enc_control.key->addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
+	} else if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS)) {
 		struct flow_match_ipv6_addrs match;
 
 		flow_rule_match_enc_ipv6_addrs(rule, &match);
@@ -1504,22 +1501,12 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
 	}
 
-	if ((flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS) ||
-	     flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID) ||
-	     flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_PORTS)) &&
-	    flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_CONTROL)) {
-		struct flow_match_control match;
-
-		flow_rule_match_enc_control(rule, &match);
-		switch (match.key->addr_type) {
-		case FLOW_DISSECTOR_KEY_IPV4_ADDRS:
-		case FLOW_DISSECTOR_KEY_IPV6_ADDRS:
-			if (parse_tunnel_attr(priv, spec, f, filter_dev, tunnel_match_level))
-				return -EOPNOTSUPP;
-			break;
-		default:
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS) ||
+	    flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS) ||
+	    flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID) ||
+	    flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_PORTS)) {
+		if (parse_tunnel_attr(priv, spec, f, filter_dev, tunnel_match_level))
 			return -EOPNOTSUPP;
-		}
 
 		/* In decap flow, header pointers should point to the inner
 		 * headers, outer header were already set by parse_tunnel_attr
-- 
1.8.3.1

