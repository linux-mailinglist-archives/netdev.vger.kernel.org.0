Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71C6151FB5C
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 13:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233099AbiEILhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 07:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233037AbiEILhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 07:37:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B83241F92A5
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 04:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652096025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0zAxrsAdCK0uO6AyvDlrnCyq5UipGmFRAGYSLTQAK7U=;
        b=bP+tb6/IF93ywqrNsF0TTNgV2jSwtbLCYKvU72eMRQJTxPlFBUEXoWwdGgTQKx157IE5+C
        mP+EMKLzTP3hOMpan6mfvEIBAVFgPLNjaqThYDeozsh1QIY6pU2Qe0CcGzTq+OLDfvY5Fk
        mh3EwUUxq6AP5cD8G9syny8twHyv6xQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-sf4cDH2IMmOtRv9v9gepCg-1; Mon, 09 May 2022 07:33:44 -0400
X-MC-Unique: sf4cDH2IMmOtRv9v9gepCg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 04F1A85A5BE;
        Mon,  9 May 2022 11:33:44 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.196.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C787B2166B2F;
        Mon,  9 May 2022 11:33:42 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH v2 net] net/sched: act_pedit: really ensure the skb is writable
Date:   Mon,  9 May 2022 13:33:34 +0200
Message-Id: <004a9eddf22a44b415a6573bdc67040b995c14dc.1652095998.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently pedit tries to ensure that the accessed skb offset
is writeble via skb_unclone(). The action potentially allows
touching any skb bytes, so it may end-up modifying shared data.

The above causes some sporadic MPTCP self-test failures.

Address the issue keeping track of a rough over-estimate highest skb
offset accessed by the action and ensure such offset is really
writable.

Note that this may cause performance regressions in some scenario,
but hopefully pedit is not critical path.

v1 -> v2:
 - cleanup hint update (Jakub)
 - avoid raices while accessing the hint (Jakub)
 - re-organize the comments for clarity

Fixes: db2c24175d14 ("act_pedit: access skb->data safely")
Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Tested-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/tc_act/tc_pedit.h |  1 +
 net/sched/act_pedit.c         | 26 ++++++++++++++++++++++----
 2 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/include/net/tc_act/tc_pedit.h b/include/net/tc_act/tc_pedit.h
index 748cf87a4d7e..3e02709a1df6 100644
--- a/include/net/tc_act/tc_pedit.h
+++ b/include/net/tc_act/tc_pedit.h
@@ -14,6 +14,7 @@ struct tcf_pedit {
 	struct tc_action	common;
 	unsigned char		tcfp_nkeys;
 	unsigned char		tcfp_flags;
+	u32			tcfp_off_max_hint;
 	struct tc_pedit_key	*tcfp_keys;
 	struct tcf_pedit_key_ex	*tcfp_keys_ex;
 };
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 31fcd279c177..0eaaf1f45de1 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -149,7 +149,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 	struct nlattr *pattr;
 	struct tcf_pedit *p;
 	int ret = 0, err;
-	int ksize;
+	int i, ksize;
 	u32 index;
 
 	if (!nla) {
@@ -228,6 +228,18 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 		p->tcfp_nkeys = parm->nkeys;
 	}
 	memcpy(p->tcfp_keys, parm->keys, ksize);
+	p->tcfp_off_max_hint = 0;
+	for (i = 0; i < p->tcfp_nkeys; ++i) {
+		u32 cur = p->tcfp_keys[i].off;
+
+		/* The AT option can read a single byte, we can bound the actual
+		 * value with uchar max.
+		 */
+		cur += (0xff & p->tcfp_keys[i].offmask) >> p->tcfp_keys[i].shift;
+
+		/* Each key touches 4 bytes starting from the computed offset */
+		p->tcfp_off_max_hint = max(p->tcfp_off_max_hint, cur + 4);
+	}
 
 	p->tcfp_flags = parm->flags;
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
@@ -308,13 +320,18 @@ static int tcf_pedit_act(struct sk_buff *skb, const struct tc_action *a,
 			 struct tcf_result *res)
 {
 	struct tcf_pedit *p = to_pedit(a);
+	u32 max_offset;
 	int i;
 
-	if (skb_unclone(skb, GFP_ATOMIC))
-		return p->tcf_action;
-
 	spin_lock(&p->tcf_lock);
 
+	max_offset = (skb_transport_header_was_set(skb) ?
+		      skb_transport_offset(skb) :
+		      skb_network_offset(skb)) +
+		     p->tcfp_off_max_hint;
+	if (skb_ensure_writable(skb, min(skb->len, max_offset)))
+		goto unlock;
+
 	tcf_lastuse_update(&p->tcf_tm);
 
 	if (p->tcfp_nkeys > 0) {
@@ -403,6 +420,7 @@ static int tcf_pedit_act(struct sk_buff *skb, const struct tc_action *a,
 	p->tcf_qstats.overlimits++;
 done:
 	bstats_update(&p->tcf_bstats, skb);
+unlock:
 	spin_unlock(&p->tcf_lock);
 	return p->tcf_action;
 }
-- 
2.35.1

