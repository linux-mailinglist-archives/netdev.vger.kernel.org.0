Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 611EB65262B
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 19:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233946AbiLTS0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 13:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbiLTS03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 13:26:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662FC2DDF
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 10:25:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671560742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TDo/IWYI6rQHEi3h5eiM+f+7wXtUbPdkTw+DQAf+oHI=;
        b=GtUeelB4KdCEF3eLWlIvVSgCjCQiD3/1WGxJB7zs//lb+e43NPkf1PokqvvzqpoeC+U8Jj
        IxEBeESPtLKRQsG1DjJRaUehKVtRRyFlEv4+SXtrObFQQdkuz7y/fLx1F9WX7yE9iISUTv
        Nl4HQUNaKri71pN6Czq0b+n5+Wf4CjI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-503-rTGLRUdyNd2l6sqn9tSV8w-1; Tue, 20 Dec 2022 13:25:36 -0500
X-MC-Unique: rTGLRUdyNd2l6sqn9tSV8w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 36C93811E6E;
        Tue, 20 Dec 2022 18:25:36 +0000 (UTC)
Received: from dcaratti.users.ipa.redhat.com (unknown [10.32.181.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B41BA492C14;
        Tue, 20 Dec 2022 18:25:34 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, jiri@resnulli.us, marcelo.leitner@gmail.com,
        pabeni@redhat.com, wizhao@redhat.com, xiyou.wangcong@gmail.com,
        lucien.xin@gmail.com
Subject: [RFC net-next 1/2] net/sched: act_mirred: better wording on protection against excessive stack growth
Date:   Tue, 20 Dec 2022 19:25:22 +0100
Message-Id: <ae44a3c9e42476d3a0f6edd87873fbea70b520bf.1671560567.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

with commit e2ca070f89ec ("net: sched: protect against stack overflow in
TC act_mirred"), act_mirred protected itself against excessive stack growth
using per_cpu counter of nested calls to tcf_mirred_act(), and capping it
to MIRRED_RECURSION_LIMIT. However, such protection does not detect
recursion/loops in case the packet is enqueued to the backlog (for example,
when the mirred target device has RPS or skb timestamping enabled). Change
the wording from "recursion" to "nesting" to make it more clear to readers.

CC: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/sched/act_mirred.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 7284bcea7b0b..c8abb5136491 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -29,8 +29,8 @@
 static LIST_HEAD(mirred_list);
 static DEFINE_SPINLOCK(mirred_list_lock);
 
-#define MIRRED_RECURSION_LIMIT    4
-static DEFINE_PER_CPU(unsigned int, mirred_rec_level);
+#define MIRRED_NEST_LIMIT    4
+static DEFINE_PER_CPU(unsigned int, mirred_nest_level);
 
 static bool tcf_mirred_is_act_redirect(int action)
 {
@@ -226,7 +226,7 @@ TC_INDIRECT_SCOPE int tcf_mirred_act(struct sk_buff *skb,
 	struct sk_buff *skb2 = skb;
 	bool m_mac_header_xmit;
 	struct net_device *dev;
-	unsigned int rec_level;
+	unsigned int nest_level;
 	int retval, err = 0;
 	bool use_reinsert;
 	bool want_ingress;
@@ -237,11 +237,11 @@ TC_INDIRECT_SCOPE int tcf_mirred_act(struct sk_buff *skb,
 	int mac_len;
 	bool at_nh;
 
-	rec_level = __this_cpu_inc_return(mirred_rec_level);
-	if (unlikely(rec_level > MIRRED_RECURSION_LIMIT)) {
+	nest_level = __this_cpu_inc_return(mirred_nest_level);
+	if (unlikely(nest_level > MIRRED_NEST_LIMIT)) {
 		net_warn_ratelimited("Packet exceeded mirred recursion limit on dev %s\n",
 				     netdev_name(skb->dev));
-		__this_cpu_dec(mirred_rec_level);
+		__this_cpu_dec(mirred_nest_level);
 		return TC_ACT_SHOT;
 	}
 
@@ -310,7 +310,7 @@ TC_INDIRECT_SCOPE int tcf_mirred_act(struct sk_buff *skb,
 			err = tcf_mirred_forward(want_ingress, skb);
 			if (err)
 				tcf_action_inc_overlimit_qstats(&m->common);
-			__this_cpu_dec(mirred_rec_level);
+			__this_cpu_dec(mirred_nest_level);
 			return TC_ACT_CONSUMED;
 		}
 	}
@@ -322,7 +322,7 @@ TC_INDIRECT_SCOPE int tcf_mirred_act(struct sk_buff *skb,
 		if (tcf_mirred_is_act_redirect(m_eaction))
 			retval = TC_ACT_SHOT;
 	}
-	__this_cpu_dec(mirred_rec_level);
+	__this_cpu_dec(mirred_nest_level);
 
 	return retval;
 }
-- 
2.38.1

