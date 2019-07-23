Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 090CA71A7A
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 16:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390471AbfGWOfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 10:35:08 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36497 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730148AbfGWOfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 10:35:06 -0400
Received: by mail-wm1-f65.google.com with SMTP id g67so34615770wme.1
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 07:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=E3jBQ4NlDdbnWjjTmtwjy5FPOIM/RN9NgYNytZIZbQg=;
        b=McePMHBQvT0MutwLTRqaI33TKbwZG6fjAWmMdsGTtuxRFPP4AzYHMI5OdVJPvYaMgm
         sjTBFIt/mqBTwMeDWtxHvmDocm72YuJETjG0aXVkA3f+yehaeMzaLc4WllKHwRv26uEM
         D0oMK2nHwBUQ+/qcYw+5/U3yLoe1hhmv8DN5q1NOK5iWKmfPd/3LjqTzj+qoPRQt9qX/
         PRVohLR0CRatpw2JmrnHV6Bvw2ql4Bgo7a+Ude/AhVaOQ316Rj8GR7BMZi1QAjctGYwi
         26oRaDANxcE/oBcJy2Xxuk+WTGzgVko4tNd3GY2VDRSSR9ZOvKXLGeZCjpvSVNE5g8zQ
         0BUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=E3jBQ4NlDdbnWjjTmtwjy5FPOIM/RN9NgYNytZIZbQg=;
        b=qmhfDokSB5D6hyj6QuZIAN0sVmb2Cc9krPh/LBoJ6LUCVxmc1w1bo+ZfEGbFZJiLAq
         IKoTXqiKIYjFZb0vU9/YHJpGbf1WQ8YP/9+/Kyeu42Am2nwprJ7cf6bJb46mqhy0WbIP
         qsxvRFutuMO4zMYjDSkq3LL4OkpEuqMAjAKNCVZIX3EkNhlcYy91Dj5EGq0iI83ygcR8
         ibTGURefhqHBorlzVwHvUqB8PpyWtlofNR3ccefT0/f76kyhuqXgbz5Uh5YNVG04uNFH
         BOeZAI/C90wt9jRCecXXY4Dv8KRkTZmi/xouP1ymuKZ4NwAGm6qBPDGY2gLMZq8hm5xP
         iCBg==
X-Gm-Message-State: APjAAAXVsa47zWyrCTlJL21nfyzfBVfaaibCV+ENulVb5LXiV6skYaLo
        2wAVCfuZSa/9crIr+8WIz+6aBuA0tKE=
X-Google-Smtp-Source: APXvYqxvdO6Tvgo0R7B07DPqWflz85DptSW8d50xJRnIa7P0xc7s7gNCQLbbObNtEDs8y/UIpWlr4w==
X-Received: by 2002:a1c:4184:: with SMTP id o126mr67657099wma.68.1563892502961;
        Tue, 23 Jul 2019 07:35:02 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id l9sm36710165wmh.36.2019.07.23.07.35.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 23 Jul 2019 07:35:02 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 2/4] nfp: flower: offload MPLS push action
Date:   Tue, 23 Jul 2019 15:34:00 +0100
Message-Id: <1563892442-4654-3-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1563892442-4654-1-git-send-email-john.hurley@netronome.com>
References: <1563892442-4654-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent additions to the kernel include a TC action module to manipulate
MPLS headers on packets. Such actions are available to offload via the
flow_offload intermediate representation API.

Modify the NFP driver to allow the offload of MPLS push actions to
firmware.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/flower/action.c | 50 ++++++++++++++++++++++
 drivers/net/ethernet/netronome/nfp/flower/cmsg.h   |  7 +++
 2 files changed, 57 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/action.c b/drivers/net/ethernet/netronome/nfp/flower/action.c
index 5a54fe8..9e18bec 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/action.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
@@ -2,10 +2,12 @@
 /* Copyright (C) 2017-2018 Netronome Systems, Inc. */
 
 #include <linux/bitfield.h>
+#include <linux/mpls.h>
 #include <net/pkt_cls.h>
 #include <net/tc_act/tc_csum.h>
 #include <net/tc_act/tc_gact.h>
 #include <net/tc_act/tc_mirred.h>
+#include <net/tc_act/tc_mpls.h>
 #include <net/tc_act/tc_pedit.h>
 #include <net/tc_act/tc_vlan.h>
 #include <net/tc_act/tc_tunnel_key.h>
@@ -25,6 +27,38 @@
 						 NFP_FL_TUNNEL_KEY | \
 						 NFP_FL_TUNNEL_GENEVE_OPT)
 
+static int
+nfp_fl_push_mpls(struct nfp_fl_push_mpls *push_mpls,
+		 const struct flow_action_entry *act,
+		 struct netlink_ext_ack *extack)
+{
+	size_t act_size = sizeof(struct nfp_fl_push_mpls);
+	u32 mpls_lse = 0;
+
+	push_mpls->head.jump_id = NFP_FL_ACTION_OPCODE_PUSH_MPLS;
+	push_mpls->head.len_lw = act_size >> NFP_FL_LW_SIZ;
+
+	/* BOS is optional in the TC action but required for offload. */
+	if (act->mpls_push.bos != ACT_MPLS_BOS_NOT_SET) {
+		mpls_lse |= act->mpls_push.bos << MPLS_LS_S_SHIFT;
+	} else {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: BOS field must explicitly be set for MPLS push");
+		return -EOPNOTSUPP;
+	}
+
+	/* Leave MPLS TC as a default value of 0 if not explicitly set. */
+	if (act->mpls_push.tc != ACT_MPLS_TC_NOT_SET)
+		mpls_lse |= act->mpls_push.tc << MPLS_LS_TC_SHIFT;
+
+	/* Proto, label and TTL are enforced and verified for MPLS push. */
+	mpls_lse |= act->mpls_push.label << MPLS_LS_LABEL_SHIFT;
+	mpls_lse |= act->mpls_push.ttl << MPLS_LS_TTL_SHIFT;
+	push_mpls->ethtype = act->mpls_push.proto;
+	push_mpls->lse = cpu_to_be32(mpls_lse);
+
+	return 0;
+}
+
 static void nfp_fl_pop_vlan(struct nfp_fl_pop_vlan *pop_vlan)
 {
 	size_t act_size = sizeof(struct nfp_fl_pop_vlan);
@@ -869,6 +903,7 @@ nfp_flower_loop_action(struct nfp_app *app, const struct flow_action_entry *act,
 	struct nfp_fl_set_ipv4_tun *set_tun;
 	struct nfp_fl_pre_tunnel *pre_tun;
 	struct nfp_fl_push_vlan *psh_v;
+	struct nfp_fl_push_mpls *psh_m;
 	struct nfp_fl_pop_vlan *pop_v;
 	int err;
 
@@ -975,6 +1010,21 @@ nfp_flower_loop_action(struct nfp_app *app, const struct flow_action_entry *act,
 		 */
 		*csum_updated &= ~act->csum_flags;
 		break;
+	case FLOW_ACTION_MPLS_PUSH:
+		if (*a_len +
+		    sizeof(struct nfp_fl_push_mpls) > NFP_FL_MAX_A_SIZ) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: maximum allowed action list size exceeded at push MPLS");
+			return -EOPNOTSUPP;
+		}
+
+		psh_m = (struct nfp_fl_push_mpls *)&nfp_fl->action_data[*a_len];
+		nfp_fl->meta.shortcut = cpu_to_be32(NFP_FL_SC_ACT_NULL);
+
+		err = nfp_fl_push_mpls(psh_m, act, extack);
+		if (err)
+			return err;
+		*a_len += sizeof(struct nfp_fl_push_mpls);
+		break;
 	default:
 		/* Currently we do not handle any other actions. */
 		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: unsupported action in action list");
diff --git a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
index 0f1706a..91af0fa 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
@@ -68,6 +68,7 @@
 #define NFP_FL_ACTION_OPCODE_OUTPUT		0
 #define NFP_FL_ACTION_OPCODE_PUSH_VLAN		1
 #define NFP_FL_ACTION_OPCODE_POP_VLAN		2
+#define NFP_FL_ACTION_OPCODE_PUSH_MPLS		3
 #define NFP_FL_ACTION_OPCODE_SET_IPV4_TUNNEL	6
 #define NFP_FL_ACTION_OPCODE_SET_ETHERNET	7
 #define NFP_FL_ACTION_OPCODE_SET_IPV4_ADDRS	9
@@ -232,6 +233,12 @@ struct nfp_fl_push_geneve {
 	u8 opt_data[];
 };
 
+struct nfp_fl_push_mpls {
+	struct nfp_fl_act_head head;
+	__be16 ethtype;
+	__be32 lse;
+};
+
 /* Metadata with L2 (1W/4B)
  * ----------------------------------------------------------------
  *    3                   2                   1
-- 
2.7.4

