Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C47C371A7C
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 16:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390525AbfGWOfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 10:35:11 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33463 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732631AbfGWOfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 10:35:08 -0400
Received: by mail-wm1-f67.google.com with SMTP id h19so31267662wme.0
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 07:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aNEFEm5cpefDO7sZH5Svg2UubPCFTmU+ct79w97ss2I=;
        b=ArNAEbSFh1MhPP0oCPC3zIC6lYZ0GOs/HyfjMYRtyhI6bKyvCKnrqMR+2pEBKnROo+
         8g7CggeWHAIHT19xgI2UHeQlP5Ml7uzS+Lavrys2kQxWlgnIkCgPZJfcdghX905n4EA/
         /4QxtCwjYZ7dLuaWU///ocGpxx3VaBI9kInk8RL26yyyAHcPbgfzea6utQUMdl33c6hd
         l/bFZT/mKNVF33Ip+/eMHTiyLXWdMFkBYNadSrvL9mKEki7B0eAlEJ+fGSRhgWPBa/ND
         R/guuz5vd/CwUr1R8sgFuzCtC9TNw8Avmwy3RySP11Q6JO8WZpSIXpK6kzqK7BZCLrIJ
         fuLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=aNEFEm5cpefDO7sZH5Svg2UubPCFTmU+ct79w97ss2I=;
        b=AyJ3Vu2H9sdH3W+Hz6Twoi8BDs2N7hsl2Ywkc+B3TIKl42fhQg0AL1UeD9sOTd9Yvs
         EBparZOYCp8HpHbDiksQzoH9Hu4YKUe95/Fja5x/liDii0TXgf6yMle4lsENaQkmpbXN
         OHwT6S6ft5DiAF6UuXN+6hIphpIECuuZgxjf4rPdWx1EtBtcNIJ5cvuqEEY5F9JqurZ2
         F6xQ2qUE8wvAsa9MulHREvN6vWjYEj7QxkKcGzLm0eBSFxcqZUmOIbOoedYSoXy4LEZS
         yEzmUbCoKXJ2/Ub0/8Am01nD3yJoaPGkrjQD6vYMqPjF7mPOy09+wftHOKHu6i0/wqpP
         tqig==
X-Gm-Message-State: APjAAAWbA5IKONFoOvwOk7mzCp0uT/2zfvhvc9im5q5yFn3BHI1Yp5ZR
        vEXiEgcaLmif+eFYpoFObDNLsaPNajc=
X-Google-Smtp-Source: APXvYqw6ph2seCGXRLE6KIjAg0D6AJo91Gi86B2OPzGa8VXL3wJSoolCrUTLjb4cfgERvdfMnL2KlA==
X-Received: by 2002:a1c:a848:: with SMTP id r69mr67582829wme.12.1563892504972;
        Tue, 23 Jul 2019 07:35:04 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id l9sm36710165wmh.36.2019.07.23.07.35.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 23 Jul 2019 07:35:04 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 4/4] nfp: flower: offload MPLS set action
Date:   Tue, 23 Jul 2019 15:34:02 +0100
Message-Id: <1563892442-4654-5-git-send-email-john.hurley@netronome.com>
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

Modify the NFP driver to allow the offload of MPLS set actions to
firmware. Set actions update the outermost MPLS header. The offload
includes a mask to specify which fields should be set.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/flower/action.c | 45 ++++++++++++++++++++++
 drivers/net/ethernet/netronome/nfp/flower/cmsg.h   |  8 ++++
 2 files changed, 53 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/action.c b/drivers/net/ethernet/netronome/nfp/flower/action.c
index 7f288ae..ff2f419 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/action.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
@@ -70,6 +70,37 @@ nfp_fl_pop_mpls(struct nfp_fl_pop_mpls *pop_mpls,
 	pop_mpls->ethtype = act->mpls_pop.proto;
 }
 
+static void
+nfp_fl_set_mpls(struct nfp_fl_set_mpls *set_mpls,
+		const struct flow_action_entry *act)
+{
+	size_t act_size = sizeof(struct nfp_fl_set_mpls);
+	u32 mpls_lse = 0, mpls_mask = 0;
+
+	set_mpls->head.jump_id = NFP_FL_ACTION_OPCODE_SET_MPLS;
+	set_mpls->head.len_lw = act_size >> NFP_FL_LW_SIZ;
+
+	if (act->mpls_mangle.label != ACT_MPLS_LABEL_NOT_SET) {
+		mpls_lse |= act->mpls_mangle.label << MPLS_LS_LABEL_SHIFT;
+		mpls_mask |= MPLS_LS_LABEL_MASK;
+	}
+	if (act->mpls_mangle.tc != ACT_MPLS_TC_NOT_SET) {
+		mpls_lse |= act->mpls_mangle.tc << MPLS_LS_TC_SHIFT;
+		mpls_mask |= MPLS_LS_TC_MASK;
+	}
+	if (act->mpls_mangle.bos != ACT_MPLS_BOS_NOT_SET) {
+		mpls_lse |= act->mpls_mangle.bos << MPLS_LS_S_SHIFT;
+		mpls_mask |= MPLS_LS_S_MASK;
+	}
+	if (act->mpls_mangle.ttl) {
+		mpls_lse |= act->mpls_mangle.ttl << MPLS_LS_TTL_SHIFT;
+		mpls_mask |= MPLS_LS_TTL_MASK;
+	}
+
+	set_mpls->lse = cpu_to_be32(mpls_lse);
+	set_mpls->lse_mask = cpu_to_be32(mpls_mask);
+}
+
 static void nfp_fl_pop_vlan(struct nfp_fl_pop_vlan *pop_vlan)
 {
 	size_t act_size = sizeof(struct nfp_fl_pop_vlan);
@@ -917,6 +948,7 @@ nfp_flower_loop_action(struct nfp_app *app, const struct flow_action_entry *act,
 	struct nfp_fl_push_mpls *psh_m;
 	struct nfp_fl_pop_vlan *pop_v;
 	struct nfp_fl_pop_mpls *pop_m;
+	struct nfp_fl_set_mpls *set_m;
 	int err;
 
 	switch (act->id) {
@@ -1050,6 +1082,19 @@ nfp_flower_loop_action(struct nfp_app *app, const struct flow_action_entry *act,
 		nfp_fl_pop_mpls(pop_m, act);
 		*a_len += sizeof(struct nfp_fl_pop_mpls);
 		break;
+	case FLOW_ACTION_MPLS_MANGLE:
+		if (*a_len +
+		    sizeof(struct nfp_fl_set_mpls) > NFP_FL_MAX_A_SIZ) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: maximum allowed action list size exceeded at set MPLS");
+			return -EOPNOTSUPP;
+		}
+
+		set_m = (struct nfp_fl_set_mpls *)&nfp_fl->action_data[*a_len];
+		nfp_fl->meta.shortcut = cpu_to_be32(NFP_FL_SC_ACT_NULL);
+
+		nfp_fl_set_mpls(set_m, act);
+		*a_len += sizeof(struct nfp_fl_set_mpls);
+		break;
 	default:
 		/* Currently we do not handle any other actions. */
 		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: unsupported action in action list");
diff --git a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
index 3198ad4..3324394 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
@@ -72,6 +72,7 @@
 #define NFP_FL_ACTION_OPCODE_POP_MPLS		4
 #define NFP_FL_ACTION_OPCODE_SET_IPV4_TUNNEL	6
 #define NFP_FL_ACTION_OPCODE_SET_ETHERNET	7
+#define NFP_FL_ACTION_OPCODE_SET_MPLS		8
 #define NFP_FL_ACTION_OPCODE_SET_IPV4_ADDRS	9
 #define NFP_FL_ACTION_OPCODE_SET_IPV4_TTL_TOS	10
 #define NFP_FL_ACTION_OPCODE_SET_IPV6_SRC	11
@@ -245,6 +246,13 @@ struct nfp_fl_pop_mpls {
 	__be16 ethtype;
 };
 
+struct nfp_fl_set_mpls {
+	struct nfp_fl_act_head head;
+	__be16 reserved;
+	__be32 lse_mask;
+	__be32 lse;
+};
+
 /* Metadata with L2 (1W/4B)
  * ----------------------------------------------------------------
  *    3                   2                   1
-- 
2.7.4

