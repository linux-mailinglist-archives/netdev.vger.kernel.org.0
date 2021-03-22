Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEAED344E2F
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 19:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbhCVSOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 14:14:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20443 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230490AbhCVSO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 14:14:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616436865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ho1+qRJxXyPlKM4V7jacfzz2y/uKamUMslqkaJRMjbY=;
        b=Zzsb3Uhaj9yG8OXlnc6ZqeZSf4Suuf3wExYYCbSFNZK1kxvQjP1ArCUBICOzvqoDYEdXQ4
        yXzvw2OZaUPFEb6SuIj24adIllpwxqB0FISd/PrIvSSFIre68C6J5KaCs9opL0kj32mApW
        NXI2XjPel6V3wlM97lElZW7o72q5BJU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-7fEpapVrPzS8ZvagsiNPRg-1; Mon, 22 Mar 2021 14:14:22 -0400
X-MC-Unique: 7fEpapVrPzS8ZvagsiNPRg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2604D1922022;
        Mon, 22 Mar 2021 18:14:20 +0000 (UTC)
Received: from horizon.localdomain (ovpn-115-149.rdu2.redhat.com [10.10.115.149])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D6F4D5945E;
        Mon, 22 Mar 2021 18:14:19 +0000 (UTC)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 28249C007F; Mon, 22 Mar 2021 15:14:18 -0300 (-03)
From:   Marcelo Ricardo Leitner <mleitner@redhat.com>
To:     netdev@vger.kernel.org
Cc:     wenxu <wenxu@ucloud.cn>, Paul Blakey <paulb@nvidia.com>,
        Yossi Kuperman <yossiku@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>,
        Davide Caratti <dcaratti@redhat.com>
Subject: [PATCH net] net/sched: act_ct: clear post_ct if doing ct_clear
Date:   Mon, 22 Mar 2021 15:13:22 -0300
Message-Id: <dd268092346925b34d5963debfd6df4410545828.1616436250.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Invalid detection works with two distinct moments: act_ct tries to find
a conntrack entry and set post_ct true, indicating that that was
attempted. Then, when flow dissector tries to dissect CT info and no
entry is there, it knows that it was tried and no entry was found, and
synthesizes/sets
                  key->ct_state = TCA_FLOWER_KEY_CT_FLAGS_TRACKED |
                                  TCA_FLOWER_KEY_CT_FLAGS_INVALID;
mimicing what OVS does.

OVS has this a bit more streamlined, as it recomputes the key after
trying to find a conntrack entry for it.

Issue here is, when we have 'tc action ct clear', it didn't clear
post_ct, causing a subsequent match on 'ct_state -trk' to fail, due to
the above. The fix, thus, is to clear it.

Reproducer rules:
tc filter add dev enp130s0f0np0_0 ingress prio 1 chain 0 \
	protocol ip flower ip_proto tcp ct_state -trk \
	action ct zone 1 pipe \
	action goto chain 2
tc filter add dev enp130s0f0np0_0 ingress prio 1 chain 2 \
	protocol ip flower \
	action ct clear pipe \
	action goto chain 4
tc filter add dev enp130s0f0np0_0 ingress prio 1 chain 4 \
	protocol ip flower ct_state -trk \
	action mirred egress redirect dev enp130s0f1np1_0

With the fix, the 3rd rule matches, like it does with OVS kernel
datapath.

Fixes: 7baf2429a1a9 ("net/sched: cls_flower add CT_FLAGS_INVALID flag support")
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sched/act_ct.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index f0a0aa125b00ad9e34725daf0ce4457d2d2ec32c..16e888a9601dd18c7b38c6ae72494d1aa975a37e 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -945,13 +945,14 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	tcf_lastuse_update(&c->tcf_tm);
 
 	if (clear) {
+		qdisc_skb_cb(skb)->post_ct = false;
 		ct = nf_ct_get(skb, &ctinfo);
 		if (ct) {
 			nf_conntrack_put(&ct->ct_general);
 			nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
 		}
 
-		goto out;
+		goto out_clear;
 	}
 
 	family = tcf_ct_skb_nf_family(skb);
@@ -1030,8 +1031,9 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	skb_push_rcsum(skb, nh_ofs);
 
 out:
-	tcf_action_update_bstats(&c->common, skb);
 	qdisc_skb_cb(skb)->post_ct = true;
+out_clear:
+	tcf_action_update_bstats(&c->common, skb);
 	if (defrag)
 		qdisc_skb_cb(skb)->pkt_len = skb->len;
 	return retval;
-- 
2.30.2

