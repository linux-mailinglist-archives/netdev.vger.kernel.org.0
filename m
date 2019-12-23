Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A68812960B
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 13:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbfLWMdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 07:33:47 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36087 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbfLWMdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 07:33:47 -0500
Received: by mail-wr1-f66.google.com with SMTP id z3so16465010wru.3
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 04:33:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metanetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eQs/KOtwqKE7vkWui2AVhnRY74kInmRv20LpgQRXNYU=;
        b=PWD0E9uPuNtEif+b027m5evDxRlHshEABhIlP4zzBj+RLGyOqkuX5ehGjabqyEFaF7
         VdiVlwBCR8jVLtgc75XaAHg22M3Eddy8SJcrShvQ3eOxoyt34ViMMURMs6NkfC/jMoH7
         /bjRaS+igd9JVRuQlwa7YVNtjrGgj/ZpCRAks=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eQs/KOtwqKE7vkWui2AVhnRY74kInmRv20LpgQRXNYU=;
        b=hTTJsux67PiRO9sMLtJmTHFiCAVu0t4Ts/iLoVEf9mGWINR1fFRt+rTY0J2lCHYj9n
         wswF/ZCqBsdhrREnJDAJUayAW8PwcWlS8o5SCBG72slNOYUGpq26baR5GXLTbsvhAePw
         BVIHry+wYixYCNXoOjPQm0B9HPcV1S0Ba0hqNz42jZ7578sJsUlsAszmwakzmSECgweq
         FtVof2QFEM7vKtvOW6mTGYFobyyAvbsYobru5D2qamYKFGA1d/cB0vFzCsOgSHOhGBHk
         OJzoRFZiY71X0HXSX8z08WEqEwm5/IAlzdvSUpb+9o0lEbUVLqoobhjMRkFHXC+VvNEF
         hoYw==
X-Gm-Message-State: APjAAAVRiZJstbyXa4XRemvLhxPWaBgagoCifBHuLM1fHyH1K+jnrvPE
        q/7gZiu5/fGviFbam4xqnjy/IMSLM98ORw==
X-Google-Smtp-Source: APXvYqwyTi4KezS5MgJUBv5Wcd/EWT369S8sTyrSWfq3MquwaV2rkDf38Og390F7y98HsmCUKicJHg==
X-Received: by 2002:adf:f20b:: with SMTP id p11mr28934997wro.195.1577104424710;
        Mon, 23 Dec 2019 04:33:44 -0800 (PST)
Received: from localhost.localdomain (bzq-82-81-225-244.cablep.bezeqint.net. [82.81.225.244])
        by smtp.gmail.com with ESMTPSA id b21sm12023194wmd.37.2019.12.23.04.33.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Dec 2019 04:33:44 -0800 (PST)
From:   shmulik@metanetworks.com
X-Google-Original-From: sladkani@proofpoint.com
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        shmulik.ladkani@gmail.com,
        Shmulik Ladkani <sladkani@proofpoint.com>
Subject: [PATCH net-next] net/sched: act_mirred: Ensure mac_len is pulled prior redirect to a non mac_header_xmit target device
Date:   Mon, 23 Dec 2019 14:33:36 +0200
Message-Id: <20191223123336.13066-1-sladkani@proofpoint.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shmulik Ladkani <sladkani@proofpoint.com>

There's no skb_pull performed when a mirred action is set at egress of a
mac device, with a target device/action that expects skb->data to point
at the network header.

As a result, either the target device is errornously given an skb with
data pointing to the mac (egress case), or the net stack receives the
skb with data pointing to the mac (ingress case).

E.g:
 # tc qdisc add dev eth9 root handle 1: prio
 # tc filter add dev eth9 parent 1: prio 9 protocol ip handle 9 basic \
   action mirred egress redirect dev tun0

 (tun0 is a tun device. result: tun0 errornously gets the eth header
  instead of the iph)

Revise the push/pull logic of tcf_mirred_act() to not rely on the
skb_at_tc_ingress() vs tcf_mirred_act_wants_ingress() comparison, as it
does not cover all "pull" cases.

Instead, calculate whether the required action on the target device
requires the data to point at the network header, and compare this to
whether skb->data points to network header - and make the push/pull
adjustments as necessary.

Signed-off-by: Shmulik Ladkani <sladkani@proofpoint.com>
---
 net/sched/act_mirred.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 1e3eb3a97532..1ad300e6dbc0 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -219,8 +219,10 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 	bool use_reinsert;
 	bool want_ingress;
 	bool is_redirect;
+	bool expects_nh;
 	int m_eaction;
 	int mac_len;
+	bool at_nh;
 
 	rec_level = __this_cpu_inc_return(mirred_rec_level);
 	if (unlikely(rec_level > MIRRED_RECURSION_LIMIT)) {
@@ -261,19 +263,19 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 			goto out;
 	}
 
-	/* If action's target direction differs than filter's direction,
-	 * and devices expect a mac header on xmit, then mac push/pull is
-	 * needed.
-	 */
 	want_ingress = tcf_mirred_act_wants_ingress(m_eaction);
-	if (skb_at_tc_ingress(skb) != want_ingress && m_mac_header_xmit) {
-		if (!skb_at_tc_ingress(skb)) {
-			/* caught at egress, act ingress: pull mac */
-			mac_len = skb_network_header(skb) - skb_mac_header(skb);
+
+	expects_nh = want_ingress || !m_mac_header_xmit;
+	at_nh = skb->data == skb_network_header(skb);
+	if (at_nh != expects_nh) {
+		mac_len = skb_at_tc_ingress(skb) ? skb->mac_len :
+			  skb_network_header(skb) - skb_mac_header(skb);
+		if (expects_nh) {
+			/* target device/action expect data at nh */
 			skb_pull_rcsum(skb2, mac_len);
 		} else {
-			/* caught at ingress, act egress: push mac */
-			skb_push_rcsum(skb2, skb->mac_len);
+			/* target device/action expect data at mac */
+			skb_push_rcsum(skb2, mac_len);
 		}
 	}
 
-- 
2.24.1

