Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01E8CC94AD
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbfJBXPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:15:05 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46180 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727993AbfJBXPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 19:15:05 -0400
Received: by mail-wr1-f68.google.com with SMTP id o18so753359wrv.13
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 16:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KOk3S0EtkAcNYMb/vn1TJfFbgQqYuT2xPMVheCZK9u0=;
        b=1M5e6cg7CTzoYN3rG01R44n7hJp0gTjqcWGQV84mtSAgOgPy1K6IwaUi2QBjKYkIqQ
         y7GE+q9TuzrQSs6oQ6+iqy/NVzxfjQMbWJWsupV300n3Tr+jINlTWL2Tv7CMBYKsZYus
         YRmNyAG5dCfYmncj39zvKA3D7AfzJwmBt8+VldsR0oo2oRLPWBkF2hqRONwbOPwypseb
         DVvr/M6PnWUeD0U9she4ssjKqRC3clwl1RSXLuZAyJugeOY5RE9Xce8ps6EMg6zpmDs6
         Uiqmqp7o572VzIV7SFAbGEV2Q5a0Z7v7mApRmaNBwisYekyz1BlBvuoWlpYbY6vsYQd8
         vOcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KOk3S0EtkAcNYMb/vn1TJfFbgQqYuT2xPMVheCZK9u0=;
        b=bEnOAsLP/LMZ+f0BEQvmECAJAc/cGeSbN9qwkyC1N0XGaDt1/m6Ks92yFZ5Aetc+zL
         6faIkw0vduu5J8Svhj+7zT75n55kTF8hpwuvR+LNBVBlqVew/m6DobakKUUv0fDNUmJt
         tt8PMKzjeN28qWwHKiq8Tb+nLQQr/3NiBtfNeI5IGDzWymvTFDpIl8cLeoBuhxJotT/V
         kNTazlkiHDPBBRtg/wTaGxHhcxLv/Sepwd5x171qxXVOAd29uQtuPo/1HANjVGuXgIOQ
         XUyqMmrGZkhimhCxvZZqPYWGMKb6Wr4kJUPuTaRLp36YeUms5bL4x6oFVJqnAIgXRoPV
         19cg==
X-Gm-Message-State: APjAAAXMUA7JjnT9JqQoREgQsHoCPn68PpU0mQ9WrfeXfH+Z3ypWkfjr
        mGsHf90XUfDz8AkOGX4GwbchFA==
X-Google-Smtp-Source: APXvYqw3oZWPqp26Ul3zOvPf/dYDObQOnkbCX/5JJXZ4STcLtAx1laFDwR9c9FAOy9Kwo7bQFQrpXw==
X-Received: by 2002:adf:f60b:: with SMTP id t11mr4168256wrp.179.1570058103404;
        Wed, 02 Oct 2019 16:15:03 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id l11sm643895wmh.34.2019.10.02.16.15.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 02 Oct 2019 16:15:02 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     vladbu@mellanox.com
Cc:     jiri@mellanox.com, netdev@vger.kernel.org,
        simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [RFC net-next 2/2] net: sched: fix tp destroy race conditions in flower
Date:   Thu,  3 Oct 2019 00:14:32 +0100
Message-Id: <1570058072-12004-3-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1570058072-12004-1-git-send-email-john.hurley@netronome.com>
References: <1570058072-12004-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Flower has rule HW offload functions available that drivers can choose to
register for. For the deletion case, these are triggered after filters
have been removed from lookup tables both at the flower level, and the
higher cls_api level. With flower running without RTNL locking, this can
lead to races where HW offload messages get out of order.

Ensure HW offloads stay in line with the kernel tables by triggering
the sending of messages before the kernel processing is completed. For
destroyed tcf_protos, do this at the new pre_destroy hook. Similarly, if
a filter is being added, check that it is not concurrently being deleted
before offloading to hw, rather than the current approach of offloading,
then checking and reversing the offload if required.

Fixes: 1d965c4def07 ("Refactor flower classifier to remove dependency on rtnl lock")
Fixes: 272ffaadeb3e ("net: sched: flower: handle concurrent tcf proto deletion")
Signed-off-by: John Hurley <john.hurley@netronome.com>
Reported-by: Louis Peens <louis.peens@netronome.com>
---
 net/sched/cls_flower.c | 55 +++++++++++++++++++++++++++-----------------------
 1 file changed, 30 insertions(+), 25 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 74221e3..3ac47b5 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -513,13 +513,16 @@ static struct cls_fl_filter *__fl_get(struct cls_fl_head *head, u32 handle)
 }
 
 static int __fl_delete(struct tcf_proto *tp, struct cls_fl_filter *f,
-		       bool *last, bool rtnl_held,
+		       bool *last, bool rtnl_held, bool do_hw,
 		       struct netlink_ext_ack *extack)
 {
 	struct cls_fl_head *head = fl_head_dereference(tp);
 
 	*last = false;
 
+	if (do_hw && !tc_skip_hw(f->flags))
+		fl_hw_destroy_filter(tp, f, rtnl_held, extack);
+
 	spin_lock(&tp->lock);
 	if (f->deleted) {
 		spin_unlock(&tp->lock);
@@ -534,8 +537,6 @@ static int __fl_delete(struct tcf_proto *tp, struct cls_fl_filter *f,
 	spin_unlock(&tp->lock);
 
 	*last = fl_mask_put(head, f->mask);
-	if (!tc_skip_hw(f->flags))
-		fl_hw_destroy_filter(tp, f, rtnl_held, extack);
 	tcf_unbind_filter(tp, &f->res);
 	__fl_put(f);
 
@@ -563,7 +564,7 @@ static void fl_destroy(struct tcf_proto *tp, bool rtnl_held,
 
 	list_for_each_entry_safe(mask, next_mask, &head->masks, list) {
 		list_for_each_entry_safe(f, next, &mask->filters, list) {
-			__fl_delete(tp, f, &last, rtnl_held, extack);
+			__fl_delete(tp, f, &last, rtnl_held, false, extack);
 			if (last)
 				break;
 		}
@@ -574,6 +575,19 @@ static void fl_destroy(struct tcf_proto *tp, bool rtnl_held,
 	tcf_queue_work(&head->rwork, fl_destroy_sleepable);
 }
 
+static void fl_pre_destroy(struct tcf_proto *tp, bool rtnl_held,
+			   struct netlink_ext_ack *extack)
+{
+	struct cls_fl_head *head = fl_head_dereference(tp);
+	struct fl_flow_mask *mask, *next_mask;
+	struct cls_fl_filter *f, *next;
+
+	list_for_each_entry_safe(mask, next_mask, &head->masks, list)
+		list_for_each_entry_safe(f, next, &mask->filters, list)
+			if (!tc_skip_hw(f->flags))
+				fl_hw_destroy_filter(tp, f, rtnl_held, extack);
+}
+
 static void fl_put(struct tcf_proto *tp, void *arg)
 {
 	struct cls_fl_filter *f = arg;
@@ -1588,6 +1602,13 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 	if (err)
 		goto errout_mask;
 
+	spin_lock(&tp->lock);
+	if (tp->deleting || (fold && fold->deleted)) {
+		err = -EAGAIN;
+		goto errout_lock;
+	}
+	spin_unlock(&tp->lock);
+
 	if (!tc_skip_hw(fnew->flags)) {
 		err = fl_hw_replace_filter(tp, fnew, rtnl_held, extack);
 		if (err)
@@ -1598,22 +1619,7 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 		fnew->flags |= TCA_CLS_FLAGS_NOT_IN_HW;
 
 	spin_lock(&tp->lock);
-
-	/* tp was deleted concurrently. -EAGAIN will cause caller to lookup
-	 * proto again or create new one, if necessary.
-	 */
-	if (tp->deleting) {
-		err = -EAGAIN;
-		goto errout_hw;
-	}
-
 	if (fold) {
-		/* Fold filter was deleted concurrently. Retry lookup. */
-		if (fold->deleted) {
-			err = -EAGAIN;
-			goto errout_hw;
-		}
-
 		fnew->handle = handle;
 
 		if (!in_ht) {
@@ -1624,7 +1630,7 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 						     &fnew->ht_node,
 						     params);
 			if (err)
-				goto errout_hw;
+				goto errout_lock;
 			in_ht = true;
 		}
 
@@ -1667,7 +1673,7 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 					    INT_MAX, GFP_ATOMIC);
 		}
 		if (err)
-			goto errout_hw;
+			goto errout_lock;
 
 		refcount_inc(&fnew->refcnt);
 		fnew->handle = handle;
@@ -1683,11 +1689,9 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 
 errout_ht:
 	spin_lock(&tp->lock);
-errout_hw:
+errout_lock:
 	fnew->deleted = true;
 	spin_unlock(&tp->lock);
-	if (!tc_skip_hw(fnew->flags))
-		fl_hw_destroy_filter(tp, fnew, rtnl_held, NULL);
 	if (in_ht)
 		rhashtable_remove_fast(&fnew->mask->ht, &fnew->ht_node,
 				       fnew->mask->filter_ht_params);
@@ -1713,7 +1717,7 @@ static int fl_delete(struct tcf_proto *tp, void *arg, bool *last,
 	bool last_on_mask;
 	int err = 0;
 
-	err = __fl_delete(tp, f, &last_on_mask, rtnl_held, extack);
+	err = __fl_delete(tp, f, &last_on_mask, rtnl_held, true, extack);
 	*last = list_empty(&head->masks);
 	__fl_put(f);
 
@@ -2509,6 +2513,7 @@ static struct tcf_proto_ops cls_fl_ops __read_mostly = {
 	.kind		= "flower",
 	.classify	= fl_classify,
 	.init		= fl_init,
+	.pre_destroy	= fl_pre_destroy,
 	.destroy	= fl_destroy,
 	.get		= fl_get,
 	.put		= fl_put,
-- 
2.7.4

