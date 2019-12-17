Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEC2B1238F5
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 22:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbfLQV5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 16:57:44 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35546 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbfLQV5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 16:57:44 -0500
Received: by mail-wm1-f67.google.com with SMTP id p17so34019wmb.0
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 13:57:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=naRVUbhSGyky7OndStCT4n7HsntB7sAEyG2ivF6CpV8=;
        b=JFJ2KHtX3FXaauBN6e59le8TNLFetX2mSRrK3YS8W1H/4M8OiKelhlWgbGvCue9jeC
         8O6G67cU8c5WXDmCNYF59XbXa3dwk/kg+egfut0EyKZ+0vVEZecTqKhPfWuUIbYPeZwN
         OVEIx0huljI7ElmYnrUs6SrUqKw75AkqBprR8MDrRHIOo/W+NIaldkSw9KnZY5cwqtpz
         A/RUbO7eRgHvbxxTC2WB57HZjb6qB1JV2s6/J0V4XUI+mrFucqx5xOlV9tE5BAiGTf4P
         ITdsoxI1js2beGdqGpuIU0Baz3L0kc243YThFynfWl0BAWVqKzeEiRpxbY6MmXwtBDkU
         e0gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=naRVUbhSGyky7OndStCT4n7HsntB7sAEyG2ivF6CpV8=;
        b=me4DQfDqaf7Xg3EPU3ct7IePBOJMzbw6gYYV7aJf0Ot2Lhp7x0A/w0kfhfwjy/Vqyn
         UX+T2qrf79X5ErScCDVavNc45u/5lERNCnTyhgX5Noxuvpcpa8bZa88uwIpVF9R01AXj
         F/oRwAgsacuYChoDCHpA/fHniQTj+C5QWALQxYnUrJfQ5BrWIixY18W4jm4AMf5lii1Y
         4MjEkqn2gqqbNpOpHHkZE9S3YKgKsncPimmCZ5pjz+P+bhGgc4LITgy7YOrJgXWH9TKU
         m9Zhi5uCb6ctlq+zzBznCjxT7lYITv2C5jG4DptEw+RkgQ3pzzLPvJt1Dl6HARWGWa1e
         XLCA==
X-Gm-Message-State: APjAAAVakq7BOWj6KeKzqihg8qNrn8aeoTCMlvMw19rkrBf4UWZ5L2xx
        LLX0nGFrJqZwSgbGbSvSNp//F4hcHLDIVNcfzSlIsXU6RcgVU3tqZF3yfCM/KPP5axt7bT5SCg8
        KohWACZZwIc1dJWpLFkTC76MGvTyIBMKXOukag5sxFAfqZtlFye/SGz+Mxff9SQmpiPA2lsOXzg
        ==
X-Google-Smtp-Source: APXvYqxIUdS4YsVczge4uxnAMsHHSQadmcsxFw7qzkORBOnZVda5yhUWDz+K7pUulbXS5U+CRVYAuw==
X-Received: by 2002:a1c:5419:: with SMTP id i25mr8105305wmb.150.1576619861668;
        Tue, 17 Dec 2019 13:57:41 -0800 (PST)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id u22sm157109wru.30.2019.12.17.13.57.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 17 Dec 2019 13:57:41 -0800 (PST)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next v2 9/9] nfp: flower: update flow merge code to support IPv6 tunnels
Date:   Tue, 17 Dec 2019 21:57:24 +0000
Message-Id: <1576619844-25413-10-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576619844-25413-1-git-send-email-john.hurley@netronome.com>
References: <1576619844-25413-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both pre-tunnel match rules and flow merge functions parse compiled
match/action fields for validation.

Update these validation functions to include IPv6 match and action fields.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 .../net/ethernet/netronome/nfp/flower/offload.c    | 28 ++++++++++++++++++----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index d512105..7ca5c1b 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -68,7 +68,8 @@
 #define NFP_FLOWER_PRE_TUN_RULE_FIELDS \
 	(NFP_FLOWER_LAYER_PORT | \
 	 NFP_FLOWER_LAYER_MAC | \
-	 NFP_FLOWER_LAYER_IPV4)
+	 NFP_FLOWER_LAYER_IPV4 | \
+	 NFP_FLOWER_LAYER_IPV6)
 
 struct nfp_flower_merge_check {
 	union {
@@ -566,10 +567,12 @@ nfp_flower_update_merge_with_actions(struct nfp_fl_payload *flow,
 	struct nfp_fl_set_ip4_addrs *ipv4_add;
 	struct nfp_fl_set_ipv6_addr *ipv6_add;
 	struct nfp_fl_push_vlan *push_vlan;
+	struct nfp_fl_pre_tunnel *pre_tun;
 	struct nfp_fl_set_tport *tport;
 	struct nfp_fl_set_eth *eth;
 	struct nfp_fl_act_head *a;
 	unsigned int act_off = 0;
+	bool ipv6_tun = false;
 	u8 act_id = 0;
 	u8 *ports;
 	int i;
@@ -597,8 +600,12 @@ nfp_flower_update_merge_with_actions(struct nfp_fl_payload *flow,
 			eth_broadcast_addr(&merge->l2.mac_src[0]);
 			memset(&merge->l4, 0xff,
 			       sizeof(struct nfp_flower_tp_ports));
-			memset(&merge->ipv4, 0xff,
-			       sizeof(struct nfp_flower_ipv4));
+			if (ipv6_tun)
+				memset(&merge->ipv6, 0xff,
+				       sizeof(struct nfp_flower_ipv6));
+			else
+				memset(&merge->ipv4, 0xff,
+				       sizeof(struct nfp_flower_ipv4));
 			break;
 		case NFP_FL_ACTION_OPCODE_SET_ETHERNET:
 			eth = (struct nfp_fl_set_eth *)a;
@@ -646,6 +653,10 @@ nfp_flower_update_merge_with_actions(struct nfp_fl_payload *flow,
 				ports[i] |= tport->tp_port_mask[i];
 			break;
 		case NFP_FL_ACTION_OPCODE_PRE_TUNNEL:
+			pre_tun = (struct nfp_fl_pre_tunnel *)a;
+			ipv6_tun = be16_to_cpu(pre_tun->flags) &
+					NFP_FL_PRE_TUN_IPV6;
+			break;
 		case NFP_FL_ACTION_OPCODE_PRE_LAG:
 		case NFP_FL_ACTION_OPCODE_PUSH_GENEVE:
 			break;
@@ -1107,15 +1118,22 @@ nfp_flower_validate_pre_tun_rule(struct nfp_app *app,
 		return -EOPNOTSUPP;
 	}
 
-	if (key_layer & NFP_FLOWER_LAYER_IPV4) {
+	if (key_layer & NFP_FLOWER_LAYER_IPV4 ||
+	    key_layer & NFP_FLOWER_LAYER_IPV6) {
+		/* Flags and proto fields have same offset in IPv4 and IPv6. */
 		int ip_flags = offsetof(struct nfp_flower_ipv4, ip_ext.flags);
 		int ip_proto = offsetof(struct nfp_flower_ipv4, ip_ext.proto);
+		int size;
 		int i;
 
+		size = key_layer & NFP_FLOWER_LAYER_IPV4 ?
+			sizeof(struct nfp_flower_ipv4) :
+			sizeof(struct nfp_flower_ipv6);
+
 		mask += sizeof(struct nfp_flower_mac_mpls);
 
 		/* Ensure proto and flags are the only IP layer fields. */
-		for (i = 0; i < sizeof(struct nfp_flower_ipv4); i++)
+		for (i = 0; i < size; i++)
 			if (mask[i] && i != ip_flags && i != ip_proto) {
 				NL_SET_ERR_MSG_MOD(extack, "unsupported pre-tunnel rule: only flags and proto can be matched in ip header");
 				return -EOPNOTSUPP;
-- 
2.7.4

