Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 453ED51874B
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 16:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237454AbiECO5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 10:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbiECO5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 10:57:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 885F1393C5
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 07:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651589651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=x1svvlDop5tNfxKYFDNTIKhuFA7ZCFrwTeW4unuCZPA=;
        b=V06l6FywtLwPojJjzBf11LKkH4EAX3XDug9hMQoI74zdMqOqhyCTi5SFRCI5yoNx05tOpG
        p505aPCLqdDO1V1065O+FKqjGkYx7EvQE13TjMtTsiRYCQB3fywZYC6wvnP4d0M3sRRAAz
        4ybTOiznF2snGavKK90BiwVsoQpI/Sc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-331-Ph0CfEF6N7uKPcqVhX_G2A-1; Tue, 03 May 2022 10:53:13 -0400
X-MC-Unique: Ph0CfEF6N7uKPcqVhX_G2A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB4961D8C13B;
        Tue,  3 May 2022 14:05:55 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E2BF5432705;
        Tue,  3 May 2022 14:05:54 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH net] net/sched: act_pedit: really ensure the skb is writable
Date:   Tue,  3 May 2022 16:05:42 +0200
Message-Id: <6c1230ee0f348230a833f92063ff2f5fbae58b94.1651584976.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
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

Fixes: db2c24175d14 ("act_pedit: access skb->data safely")
Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Tested-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
Note: AFAICS the issue is present since 1da177e4c3f4
("Linux-2.6.12-rc2"), but before the "Fixes" commit this change
is irrelevant, because accessing any data out of the skb head
will cause an oops.
---
 include/net/tc_act/tc_pedit.h |  1 +
 net/sched/act_pedit.c         | 23 +++++++++++++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

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
index 31fcd279c177..a8ab6c3f1ea2 100644
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
@@ -228,6 +228,20 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 		p->tcfp_nkeys = parm->nkeys;
 	}
 	memcpy(p->tcfp_keys, parm->keys, ksize);
+	p->tcfp_off_max_hint = 0;
+	for (i = 0; i < p->tcfp_nkeys; ++i) {
+		u32 cur = p->tcfp_keys[i].off;
+
+		/* The AT option can read a single byte, we can bound the actual
+		 * value with uchar max. Each key touches 4 bytes starting from
+		 * the computed offset
+		 */
+		if (p->tcfp_keys[i].offmask) {
+			cur += 255 >> p->tcfp_keys[i].shift;
+			cur = max(p->tcfp_keys[i].at, cur);
+		}
+		p->tcfp_off_max_hint = max(p->tcfp_off_max_hint, cur + 4);
+	}
 
 	p->tcfp_flags = parm->flags;
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
@@ -308,9 +322,14 @@ static int tcf_pedit_act(struct sk_buff *skb, const struct tc_action *a,
 			 struct tcf_result *res)
 {
 	struct tcf_pedit *p = to_pedit(a);
+	u32 max_offset;
 	int i;
 
-	if (skb_unclone(skb, GFP_ATOMIC))
+	max_offset = (skb_transport_header_was_set(skb) ?
+		      skb_transport_offset(skb) :
+		      skb_network_offset(skb)) +
+		     p->tcfp_off_max_hint;
+	if (skb_ensure_writable(skb, min(skb->len, max_offset)))
 		return p->tcf_action;
 
 	spin_lock(&p->tcf_lock);
-- 
2.35.1

