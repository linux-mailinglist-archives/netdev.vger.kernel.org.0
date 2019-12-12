Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA8A11D51C
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 19:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730169AbfLLSRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 13:17:24 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40739 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730369AbfLLSRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 13:17:18 -0500
Received: by mail-wr1-f67.google.com with SMTP id c14so3781692wrn.7
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 10:17:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=naRVUbhSGyky7OndStCT4n7HsntB7sAEyG2ivF6CpV8=;
        b=F9j1tc+9sfQ3pjrs2NRQaGP1zIbfz+skJxc7h8a/b5ok3g7Tnw74slX3hEisGCxuex
         cjm12VQa/CMCvAjMbHZiIBG0TZgR25o4UA4oEC3JZ1ntUR6qc49TAe6W+FFW8sZkHVgu
         hAoPvjWdcgZu7a9pqqf2V26tM+NJXx1WHimKlqotl7v1hdz7MzFu0N1Ds7DIHNsd6CCM
         JQzuypVkn30mSZ88IpA71DydLdTg7EUfA//nGHL8OCtwC/PyJyj6BkPkqjt+c8bgO4S3
         C1tf0ygvbhpm9W/2LVSF+dRDx05buabO24G5LHw5DwU94amYW70fxloXzP2OAOuBjgzX
         7oLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=naRVUbhSGyky7OndStCT4n7HsntB7sAEyG2ivF6CpV8=;
        b=jm+L+ZoEuFPrrkTRnBqhANX2PipSn5mHoww3xd8QLW0tWAZ9rpMkoJU3lIDVWhajnh
         P+mo9f2JzuBT3eD14WiMrQ4BKbn4vWyB/H5gE9AMV0PXPc0uf5mk12PwKcObBDoosKBA
         K7KgToQmZn58ek/tnSoHkbx45eYa2ox3wG6utwFECFQN8d4XQCL42P3I8qcwQINFTrrL
         CXOCSCCOamiIXabY0lohbxwTyOrQNm6z5AG8BxD9WmUhwj4N2wEFGl1oYAWFCZn+/qXA
         rdFuoE+XwPMeOKyDsfqKjnxzOPQMkQFTd78ZYiOuqA5Lciifk3D4vTwRfIgQYGjpdl7W
         AJkg==
X-Gm-Message-State: APjAAAU5l/dcvTmXdJ3+ldamUqjFvt+QVxyXkwjawS+XicpuYe8H6iGe
        wkJS1HtRjca6pdlqBCVtMHkcf4CSAywt+gSBGrXD6vmLH+gGgzC8M0sU/0+1pGleyHXwDycrnxZ
        cKscTTEsrKpqIJ4mycSv1Ix6zjmzqUj0qbfXvLMwldkFr4DYJrGn4glW4EFcAvbdDbPbG2FcxwQ
        ==
X-Google-Smtp-Source: APXvYqxNnqTZljioC64uAT6/iEUZMK8ULr6iCB9+oRB3btTgF02G0J0Dez/yz57RHnGNRDHUV7xWHA==
X-Received: by 2002:a5d:6551:: with SMTP id z17mr8242186wrv.269.1576174635927;
        Thu, 12 Dec 2019 10:17:15 -0800 (PST)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id j21sm7928736wmj.39.2019.12.12.10.17.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 12 Dec 2019 10:17:15 -0800 (PST)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 9/9] nfp: flower: update flow merge code to support IPv6 tunnels
Date:   Thu, 12 Dec 2019 18:16:56 +0000
Message-Id: <1576174616-9738-10-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576174616-9738-1-git-send-email-john.hurley@netronome.com>
References: <1576174616-9738-1-git-send-email-john.hurley@netronome.com>
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

