Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD0B44EB78
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 17:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235485AbhKLQgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 11:36:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235510AbhKLQgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 11:36:09 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 876D1C0613F5
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 08:33:18 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id w29so16452100wra.12
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 08:33:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WwNTgymEr7BExZdia9U0NZDL1DzGUUK6veHZLVX8eIM=;
        b=pY0hEf0eQ/TZfi0Z1n88gfq2wnFrBEUPWjz3HzFSeVYGyhslGzCowPr0uO+TnA8D28
         r0BbJZ5xYTeb4CtZ8PlQ43nsK7Vz5lmV7tnA7qIx9yisq9xsyYTLOtMhNeZGA4ZbHGN9
         ME0iypAvaG3Bd0Dhs4wxL1De5s9E0sEWxsNkjjmKC3IswoMaZFekQkuQlScCwZW6U0kF
         vy7Ez6uWxtrnP1DFa5tzplr9w84cq9IJ4KNnExzkn+Ov+QvgsJ7xUSxLy504ArR/HoWs
         jMzbwi42KZ8Q5HcnvV2hv9KHlgIK89xJneMs5pvKOdG+HbGTlR+01a32qVq4U+ax62lD
         XaLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WwNTgymEr7BExZdia9U0NZDL1DzGUUK6veHZLVX8eIM=;
        b=in/X15C+gg0uF5lL/Nn/FsXW07RwE0MYZmp7fuCvdR0SnP3nX/2xnV2Atghp09f2ck
         MZ1HM1VXQCtOPcMmrbX5n61qYhhRoXOfOtrfThU2DzwdGcxaxxp4HrVDYTMyJlJcJqa2
         ytxhrMsZP7nbXqRfDhFE3Ljc5umCMb2vJTwNzV6wPRmt45xUytC6fZZPqC22bSCO0kYi
         b/n6Q/y4BOdpLX8bDGvwee/u3dtjUTzjkSBJIn9ZKnNmb0P7uu8aMhqp/ycijvw9VX+7
         dqyWLQnrBRcyfSETMmGZkFJjk92UeGyWd2CZXdMY8rEuuHEbkDeFffYsY2xnGxjL8F33
         kS5g==
X-Gm-Message-State: AOAM531go5/YPRc3BfbEzEkBRuQk12A3yf5wBFy3S8X0KXcQVoJfbgnR
        0zvt0RhnnXRWQTrQ3UthmCimkk+L2GD5AQ==
X-Google-Smtp-Source: ABdhPJzVnDqXZVnKrVeMMa5nbhdMd4ZeVHZ7RgF3JrFbp+98BqFxdjyxwQqDkqg/c6q48Pg7KKU1Xg==
X-Received: by 2002:a5d:64cc:: with SMTP id f12mr19693160wri.322.1636734797024;
        Fri, 12 Nov 2021 08:33:17 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id c11sm8631595wmq.27.2021.11.12.08.33.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 08:33:16 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net 1/2] net: sched: act_mirred: drop dst for the direction from egress to ingress
Date:   Fri, 12 Nov 2021 11:33:11 -0500
Message-Id: <e6c13028614a219ddf2854a160125aa85bac7bf9.1636734751.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1636734751.git.lucien.xin@gmail.com>
References: <cover.1636734751.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Without dropping dst, the packets sent from local mirred/redirected
to ingress will may still use the old dst. ip_rcv() will drop it as
the old dst is for output and its .input is dst_discard.

This patch is to fix by also dropping dst for those packets that are
mirred or redirected from egress to ingress in act_mirred.

Note that we don't drop it for the direction change from ingress to
egress, as on which there might be a user case attaching a metadata
dst by act_tunnel_key that would be used later.

Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sched/act_mirred.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index d64b0eeccbe4..efc963ab995a 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -19,6 +19,7 @@
 #include <linux/if_arp.h>
 #include <net/net_namespace.h>
 #include <net/netlink.h>
+#include <net/dst.h>
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
 #include <linux/tc_act/tc_mirred.h>
@@ -228,6 +229,7 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 	bool want_ingress;
 	bool is_redirect;
 	bool expects_nh;
+	bool at_ingress;
 	int m_eaction;
 	int mac_len;
 	bool at_nh;
@@ -263,7 +265,8 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 	 * ingress - that covers the TC S/W datapath.
 	 */
 	is_redirect = tcf_mirred_is_act_redirect(m_eaction);
-	use_reinsert = skb_at_tc_ingress(skb) && is_redirect &&
+	at_ingress = skb_at_tc_ingress(skb);
+	use_reinsert = at_ingress && is_redirect &&
 		       tcf_mirred_can_reinsert(retval);
 	if (!use_reinsert) {
 		skb2 = skb_clone(skb, GFP_ATOMIC);
@@ -271,10 +274,12 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 			goto out;
 	}
 
+	want_ingress = tcf_mirred_act_wants_ingress(m_eaction);
+
 	/* All mirred/redirected skbs should clear previous ct info */
 	nf_reset_ct(skb2);
-
-	want_ingress = tcf_mirred_act_wants_ingress(m_eaction);
+	if (want_ingress && !at_ingress) /* drop dst for egress -> ingress */
+		skb_dst_drop(skb2);
 
 	expects_nh = want_ingress || !m_mac_header_xmit;
 	at_nh = skb->data == skb_network_header(skb);
-- 
2.27.0

