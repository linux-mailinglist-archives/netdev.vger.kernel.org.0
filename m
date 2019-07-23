Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF8171A7B
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 16:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390490AbfGWOfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 10:35:09 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33461 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388162AbfGWOfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 10:35:06 -0400
Received: by mail-wm1-f65.google.com with SMTP id h19so31267615wme.0
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 07:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LXHhPPIjP7sfMTSBJF6HAGk2blGA2hiq+lqeIVYPAVE=;
        b=LPjq/wndhUpuFfSTF6NGPf7cGwhZsx/Cn3Boxc6xd1iAsNC9hw+697iO6jXXJk6yUw
         ZBOXEWx/rWdmj9Ev9Hyp7cc+ORHxGzXN1i3/m1OWQqcn/CsWuFKaQQQiTY2jSLxhpauk
         63mg3328UWNj2yvr4hSYHjMSkoLNBGvXW58h9nqFMVz5Vvowhg8YHwX7YnC22JjBwGa7
         mmzOl+e+7NTl93slVhC5aQF+HAVd/0ihyp/wNIU+lYZsyeprLHHIqArCXUm30wz3Ndvq
         Q9VWgOYT6iTQO54SDkNQ68zdIcV9rdnNExyI9qu4c5m9NLssjeQF2ORC2voQt1kZy/0d
         TP+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LXHhPPIjP7sfMTSBJF6HAGk2blGA2hiq+lqeIVYPAVE=;
        b=iE+uH9NuDILB6rbTdbYYX5kgWJNIsC94R62PtzaZ5+o4AjfaFajtruDv00wOdVV5wt
         bJx90bzDA5W0q2qxk18WhsgNNHqcKCpy+VMyGdg054bGxglci/u7bJnqGF0t53tfoFmE
         6jDHdyy60ARtCi8+i44pvWHUqkr4OjD5ZDvPhbFXQ5aK12vZYD+nTnXFswjiPIhXx10P
         Smy5tKs40uxrAqYc0HrS3nk+0hDdbQjy4zwdIsz6YzrEF3QIbGo2WzxAfyQDXdNs1ABQ
         Z/Nsy/kgDwawgV3oF7aUnwnbCKDjFEsBznlF8Kb8XvP/BT4c9mZ/gK+cwDhm5D97pLEG
         zlUw==
X-Gm-Message-State: APjAAAXzC8VA5LMyaO7TnZ7jlwOGIsBRzMz/nw+vUumLp+81g3MsWHGu
        lwW74k9A14gW97acUOvlGNiLV2pCoq0=
X-Google-Smtp-Source: APXvYqwBXH0qpQrpMoXVfSP8ICFiAUFYIrIyzqlR7JvI/+tDxzLudL0byip5K0EktLsSooPb0ydK7w==
X-Received: by 2002:a1c:2c41:: with SMTP id s62mr69484658wms.8.1563892503927;
        Tue, 23 Jul 2019 07:35:03 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id l9sm36710165wmh.36.2019.07.23.07.35.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 23 Jul 2019 07:35:03 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 3/4] nfp: flower: offload MPLS pop action
Date:   Tue, 23 Jul 2019 15:34:01 +0100
Message-Id: <1563892442-4654-4-git-send-email-john.hurley@netronome.com>
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

Modify the NFP driver to allow the offload of MPLS pop actions to
firmware. The act_mpls TC module enforces that the next protocol is
supplied along with the pop action. Passing this to firmware allows it
to properly rebuild the underlying packet after the pop.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/flower/action.c | 25 ++++++++++++++++++++++
 drivers/net/ethernet/netronome/nfp/flower/cmsg.h   |  6 ++++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/action.c b/drivers/net/ethernet/netronome/nfp/flower/action.c
index 9e18bec..7f288ae 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/action.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
@@ -59,6 +59,17 @@ nfp_fl_push_mpls(struct nfp_fl_push_mpls *push_mpls,
 	return 0;
 }
 
+static void
+nfp_fl_pop_mpls(struct nfp_fl_pop_mpls *pop_mpls,
+		const struct flow_action_entry *act)
+{
+	size_t act_size = sizeof(struct nfp_fl_pop_mpls);
+
+	pop_mpls->head.jump_id = NFP_FL_ACTION_OPCODE_POP_MPLS;
+	pop_mpls->head.len_lw = act_size >> NFP_FL_LW_SIZ;
+	pop_mpls->ethtype = act->mpls_pop.proto;
+}
+
 static void nfp_fl_pop_vlan(struct nfp_fl_pop_vlan *pop_vlan)
 {
 	size_t act_size = sizeof(struct nfp_fl_pop_vlan);
@@ -905,6 +916,7 @@ nfp_flower_loop_action(struct nfp_app *app, const struct flow_action_entry *act,
 	struct nfp_fl_push_vlan *psh_v;
 	struct nfp_fl_push_mpls *psh_m;
 	struct nfp_fl_pop_vlan *pop_v;
+	struct nfp_fl_pop_mpls *pop_m;
 	int err;
 
 	switch (act->id) {
@@ -1025,6 +1037,19 @@ nfp_flower_loop_action(struct nfp_app *app, const struct flow_action_entry *act,
 			return err;
 		*a_len += sizeof(struct nfp_fl_push_mpls);
 		break;
+	case FLOW_ACTION_MPLS_POP:
+		if (*a_len +
+		    sizeof(struct nfp_fl_pop_mpls) > NFP_FL_MAX_A_SIZ) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: maximum allowed action list size exceeded at pop MPLS");
+			return -EOPNOTSUPP;
+		}
+
+		pop_m = (struct nfp_fl_pop_mpls *)&nfp_fl->action_data[*a_len];
+		nfp_fl->meta.shortcut = cpu_to_be32(NFP_FL_SC_ACT_NULL);
+
+		nfp_fl_pop_mpls(pop_m, act);
+		*a_len += sizeof(struct nfp_fl_pop_mpls);
+		break;
 	default:
 		/* Currently we do not handle any other actions. */
 		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: unsupported action in action list");
diff --git a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
index 91af0fa..3198ad4 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
@@ -69,6 +69,7 @@
 #define NFP_FL_ACTION_OPCODE_PUSH_VLAN		1
 #define NFP_FL_ACTION_OPCODE_POP_VLAN		2
 #define NFP_FL_ACTION_OPCODE_PUSH_MPLS		3
+#define NFP_FL_ACTION_OPCODE_POP_MPLS		4
 #define NFP_FL_ACTION_OPCODE_SET_IPV4_TUNNEL	6
 #define NFP_FL_ACTION_OPCODE_SET_ETHERNET	7
 #define NFP_FL_ACTION_OPCODE_SET_IPV4_ADDRS	9
@@ -239,6 +240,11 @@ struct nfp_fl_push_mpls {
 	__be32 lse;
 };
 
+struct nfp_fl_pop_mpls {
+	struct nfp_fl_act_head head;
+	__be16 ethtype;
+};
+
 /* Metadata with L2 (1W/4B)
  * ----------------------------------------------------------------
  *    3                   2                   1
-- 
2.7.4

