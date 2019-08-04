Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59F2980B62
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 17:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbfHDPKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 11:10:33 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33999 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbfHDPKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 11:10:31 -0400
Received: by mail-wr1-f65.google.com with SMTP id 31so81923995wrm.1
        for <netdev@vger.kernel.org>; Sun, 04 Aug 2019 08:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+Mp0iodaGf4Jj6dRLCOhmM3wMm+C01K11YTDgoRKUrA=;
        b=IoIw9StpferemXc9ifoVxmN158X3fKhnYdu3tA02cbuHYhcRtrg9pTjFxINY0ZKVeE
         kgK6v++cO4oIiOBEYRxQLaAPcOSt48aao5HdZNfUy70yRiyZMRoEhPrNPfm4NHXas3Yk
         ayFEfa7RdsM1K3NO/UGPOpTP/i/LTPgaMiNYjXTTmj9adLzdoQAd/b8DgBs2KwaUcY0Y
         jMkg3/N1NuIS6QyB966R1Kz7Ckc6nC6wiaIw1kXpiJChlh64RKIfN8HaAw+iK6YSZIn7
         P/Jw97MBpVsIaDhw+S9aEZbcbOtNpMgk4EwTwD463ZGQbD0StSqw/GhHBmRtK7HM23f/
         bxlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+Mp0iodaGf4Jj6dRLCOhmM3wMm+C01K11YTDgoRKUrA=;
        b=ZLK2dPHUsWb/FPpIilZsxMtcZzVTFQAJcFenUBnC5OlWEIEGgbcUJuCtLd2AkL8jfG
         y7IXa5g44tsNpOEA5ZFR02sv4FdHgGuehnv7x+tn2k0EYmtoNe6Pz0Vwh73yK93IBdIA
         DbbgS0Ai7cXjjPv/hTI0J/Ldf8eaSnenPWXAiRaA6i+PxXbvosHgosa7yEs/I+M7ErAH
         nD/bKPk5Y3WDr/tvJ5yZWnYf1JSCj/pkgeF6i1GPxxTmbfWhGlIMxUdNpGOlVhky9Os/
         RuRDL1GQyUwj8beIZKPDrSmAcRUKWHFv5unJV8DQAcySEtB6Ir1K4U0G5qS0n4WTnyo6
         S6Fw==
X-Gm-Message-State: APjAAAUyCpaF9aRf2brxC/ddKsNpycByJtqXKJ4HKbRDaKxzoFZFGYou
        9zonLG5Y/6J4J2E4Hinwk74cNIyRn/M=
X-Google-Smtp-Source: APXvYqzpv6wNjyOsaODTCXHx9+aHvaZL74oagDbv0f0KUsQ/TImsFlYBErzrE/DQObbepn3UU2tF4Q==
X-Received: by 2002:adf:f005:: with SMTP id j5mr107184793wro.251.1564931428780;
        Sun, 04 Aug 2019 08:10:28 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id l9sm63769441wmh.36.2019.08.04.08.10.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 04 Aug 2019 08:10:28 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 05/10] nfp: flower: push vlan after tunnel in merge
Date:   Sun,  4 Aug 2019 16:09:07 +0100
Message-Id: <1564931351-1036-6-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564931351-1036-1-git-send-email-john.hurley@netronome.com>
References: <1564931351-1036-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NFP allows the merging of 2 flows together into a single offloaded flow.
In the kernel datapath the packet must match 1 flow, impliment its
actions, recirculate, match the 2nd flow and also impliment its actions.
Merging creates a single flow with all actions from the 2 original flows.

Firmware impliments a tunnel header push as the packet is about to egress
the card. Therefore, if the first merge rule candiate pushes a tunnel,
then the second rule can only have an egress action for a valid merge to
occur (or else the action ordering will be incorrect). This prevents the
pushing of a tunnel header followed by the pushing of a vlan header.

In order to support this behaviour, firmware allows VLAN information to
be encoded in the tunnel push action. If this is non zero then the fw will
push a VLAN after the tunnel header push meaning that 2 such flows with
these actions can be merged (with action order being maintained).

Support tunnel in VLAN pushes by encoding VLAN information in the tunnel
push action of any merge flow requiring this.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/flower/cmsg.h   |  3 +-
 .../net/ethernet/netronome/nfp/flower/offload.c    | 60 ++++++++++++++++++++--
 2 files changed, 58 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
index 3324394..caf3029 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
@@ -220,7 +220,8 @@ struct nfp_fl_set_ipv4_tun {
 	__be16 tun_flags;
 	u8 ttl;
 	u8 tos;
-	__be32 extra;
+	__be16 outer_vlan_tpid;
+	__be16 outer_vlan_tci;
 	u8 tun_len;
 	u8 res2;
 	__be16 tun_proto;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index e209f15..607426c 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -732,28 +732,62 @@ nfp_flower_copy_pre_actions(char *act_dst, char *act_src, int len,
 	return act_off;
 }
 
-static int nfp_fl_verify_post_tun_acts(char *acts, int len)
+static int
+nfp_fl_verify_post_tun_acts(char *acts, int len, struct nfp_fl_push_vlan **vlan)
 {
 	struct nfp_fl_act_head *a;
 	unsigned int act_off = 0;
 
 	while (act_off < len) {
 		a = (struct nfp_fl_act_head *)&acts[act_off];
-		if (a->jump_id != NFP_FL_ACTION_OPCODE_OUTPUT)
+
+		if (a->jump_id == NFP_FL_ACTION_OPCODE_PUSH_VLAN && !act_off)
+			*vlan = (struct nfp_fl_push_vlan *)a;
+		else if (a->jump_id != NFP_FL_ACTION_OPCODE_OUTPUT)
 			return -EOPNOTSUPP;
 
 		act_off += a->len_lw << NFP_FL_LW_SIZ;
 	}
 
+	/* Ensure any VLAN push also has an egress action. */
+	if (*vlan && act_off <= sizeof(struct nfp_fl_push_vlan))
+		return -EOPNOTSUPP;
+
 	return 0;
 }
 
 static int
+nfp_fl_push_vlan_after_tun(char *acts, int len, struct nfp_fl_push_vlan *vlan)
+{
+	struct nfp_fl_set_ipv4_tun *tun;
+	struct nfp_fl_act_head *a;
+	unsigned int act_off = 0;
+
+	while (act_off < len) {
+		a = (struct nfp_fl_act_head *)&acts[act_off];
+
+		if (a->jump_id == NFP_FL_ACTION_OPCODE_SET_IPV4_TUNNEL) {
+			tun = (struct nfp_fl_set_ipv4_tun *)a;
+			tun->outer_vlan_tpid = vlan->vlan_tpid;
+			tun->outer_vlan_tci = vlan->vlan_tci;
+
+			return 0;
+		}
+
+		act_off += a->len_lw << NFP_FL_LW_SIZ;
+	}
+
+	/* Return error if no tunnel action is found. */
+	return -EOPNOTSUPP;
+}
+
+static int
 nfp_flower_merge_action(struct nfp_fl_payload *sub_flow1,
 			struct nfp_fl_payload *sub_flow2,
 			struct nfp_fl_payload *merge_flow)
 {
 	unsigned int sub1_act_len, sub2_act_len, pre_off1, pre_off2;
+	struct nfp_fl_push_vlan *post_tun_push_vlan = NULL;
 	bool tunnel_act = false;
 	char *merge_act;
 	int err;
@@ -790,18 +824,36 @@ nfp_flower_merge_action(struct nfp_fl_payload *sub_flow1,
 	sub2_act_len -= pre_off2;
 
 	/* FW does a tunnel push when egressing, therefore, if sub_flow 1 pushes
-	 * a tunnel, sub_flow 2 can only have output actions for a valid merge.
+	 * a tunnel, there are restrictions on what sub_flow 2 actions lead to a
+	 * valid merge.
 	 */
 	if (tunnel_act) {
 		char *post_tun_acts = &sub_flow2->action_data[pre_off2];
 
-		err = nfp_fl_verify_post_tun_acts(post_tun_acts, sub2_act_len);
+		err = nfp_fl_verify_post_tun_acts(post_tun_acts, sub2_act_len,
+						  &post_tun_push_vlan);
 		if (err)
 			return err;
+
+		if (post_tun_push_vlan) {
+			pre_off2 += sizeof(*post_tun_push_vlan);
+			sub2_act_len -= sizeof(*post_tun_push_vlan);
+		}
 	}
 
 	/* Copy remaining actions from sub_flows 1 and 2. */
 	memcpy(merge_act, sub_flow1->action_data + pre_off1, sub1_act_len);
+
+	if (post_tun_push_vlan) {
+		/* Update tunnel action in merge to include VLAN push. */
+		err = nfp_fl_push_vlan_after_tun(merge_act, sub1_act_len,
+						 post_tun_push_vlan);
+		if (err)
+			return err;
+
+		merge_flow->meta.act_len -= sizeof(*post_tun_push_vlan);
+	}
+
 	merge_act += sub1_act_len;
 	memcpy(merge_act, sub_flow2->action_data + pre_off2, sub2_act_len);
 
-- 
2.7.4

