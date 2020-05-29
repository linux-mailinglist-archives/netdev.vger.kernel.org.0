Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F771E88B4
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 22:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgE2UOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 16:14:36 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:54705 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbgE2UOf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 16:14:35 -0400
Received: from threadripper.lan ([149.172.98.151]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MfpjF-1j3Ei81kC1-00gKp9; Fri, 29 May 2020 22:14:17 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Guillaume Nault <gnault@redhat.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Vlad Buslov <vladbu@mellanox.com>,
        Xin Long <lucien.xin@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] flow_dissector: work around stack frame size warning
Date:   Fri, 29 May 2020 22:13:58 +0200
Message-Id: <20200529201413.397679-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:fGBRSFc62pbGaKvFVZs4AVLojvSZQNlGc8I5lGZQRmsePAgcFc9
 7x+/VNVskyailO/6h/qwZ3W4rL06Z2LcT+YlGDz+xe1++pxK7vFVbRKElSFHtBGxA28mGQm
 6lm3dkvChwSsHSjw1eGMgVWTKjdVClTWk+Hk8+0iyDux2yX1TmsFq5LB2RbF0j+8SVvAThs
 B59D5FY5hb0aq8nnrGivg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:EqM824uKsLc=:oYFD6qhd1oF/0lJdhdLWbM
 nDF8D5MD6g3AtDmHJKefxqyZ+M3NhPDVCfL1FmJc7Rrj8L4HDuVbHjTRj1bh7JdWBpaDuINQ6
 qm1cihm58iCfivLR5cmo5B/JhvSBNxhummWCZbVH86EJI+a3PhctCbjt0B6iv9fVcxErE8xp1
 xRkjwwRGaRBok5Ckd04bw6OLYqaPiWy/xelDn21K3dOVvi7NKocRf0Z9eTWjUNOx7Jp6lDzEE
 aGgrOfWEbHVe7frqk8qZyLqr5Gk23mScEX6FryArUs6pVtsY6lzTj5tjJPbynQuN+vrChCRi5
 7MIRFAWGQWq2GPf03N5XLfcxPYJhRJC4r0asjE6oKXfLanZkZ9J2n/BXyIz9bXez3IzjFCTFp
 ZAKmuc1CZN4yXRdU++eSO0IGw/0M5yZDP8CtPvVZdJhzsch3ZKBts/tmFCkSsfV89jWZhD8zc
 rXcPhAsEuBBZ2gZhTuFntm237LZBebC3bYxAmuoA7YBmfjb3s0XTp8oOP1CnHfz9WnJtLfBBi
 0pBjIXDkVkrgXuQPgYapoP7vyhamBWwZPls9hDzi3/6apIyivl4+8h7jaJ/FutCwP78XEhsT0
 +7ARfdoEEQPBpGY/sdbhhOVNABPlXTEmoE8Oe9s8Tiy1t0SviQeoLnlw1O8Jo06TOnpTDVyEj
 EM8DigCN0RIIbfrglhVVaPy7fxkmryvnI8A2LU5jN0811DGopzgcM2QOQLJGdvEmFrKcKfxvW
 1XGqNdA7p9wyEliv737GZ+32v9AvKb2RInaQ9qzv4lYd+f4XD0nOMc6Kikd+JuQfebA2yAI2a
 AVJ4CFK9DRPt91NdKmOjhFc26pvVnki1y9W19wWGM4SQJweZ8Y=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The fl_flow_key structure is around 500 bytes, so having two of them
on the stack in one function now exceeds the warning limit after an
otherwise correct change:

net/sched/cls_flower.c:298:12: error: stack frame size of 1056 bytes in function 'fl_classify' [-Werror,-Wframe-larger-than=]

I suspect the fl_classify function could be reworked to only have one
of them on the stack and modify it in place, but I could not work out
how to do that.

As a somewhat hacky workaround, move one of them into an out-of-line
function to reduce its scope. This does not necessarily reduce the stack
usage of the outer function, but at least the second copy is removed
from the stack during most of it and does not add up to whatever is
called from there.

I now see 552 bytes of stack usage for fl_classify(), plus 528 bytes
for fl_mask_lookup().

Fixes: 58cff782cc55 ("flow_dissector: Parse multiple MPLS Label Stack Entries")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/sched/cls_flower.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 96f5999281e0..030896eadd11 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -272,14 +272,16 @@ static struct cls_fl_filter *fl_lookup_range(struct fl_flow_mask *mask,
 	return NULL;
 }
 
-static struct cls_fl_filter *fl_lookup(struct fl_flow_mask *mask,
-				       struct fl_flow_key *mkey,
-				       struct fl_flow_key *key)
+static noinline_for_stack
+struct cls_fl_filter *fl_mask_lookup(struct fl_flow_mask *mask, struct fl_flow_key *key)
 {
+	struct fl_flow_key mkey;
+
+	fl_set_masked_key(&mkey, key, mask);
 	if ((mask->flags & TCA_FLOWER_MASK_FLAGS_RANGE))
-		return fl_lookup_range(mask, mkey, key);
+		return fl_lookup_range(mask, &mkey, key);
 
-	return __fl_lookup(mask, mkey);
+	return __fl_lookup(mask, &mkey);
 }
 
 static u16 fl_ct_info_to_flower_map[] = {
@@ -299,7 +301,6 @@ static int fl_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 		       struct tcf_result *res)
 {
 	struct cls_fl_head *head = rcu_dereference_bh(tp->root);
-	struct fl_flow_key skb_mkey;
 	struct fl_flow_key skb_key;
 	struct fl_flow_mask *mask;
 	struct cls_fl_filter *f;
@@ -319,9 +320,7 @@ static int fl_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 				    ARRAY_SIZE(fl_ct_info_to_flower_map));
 		skb_flow_dissect(skb, &mask->dissector, &skb_key, 0);
 
-		fl_set_masked_key(&skb_mkey, &skb_key, mask);
-
-		f = fl_lookup(mask, &skb_mkey, &skb_key);
+		f = fl_mask_lookup(mask, &skb_key);
 		if (f && !tc_skip_sw(f->flags)) {
 			*res = f->res;
 			return tcf_exts_exec(skb, &f->exts, res);
-- 
2.26.2

