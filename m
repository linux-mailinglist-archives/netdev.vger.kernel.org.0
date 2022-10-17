Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C86346017B0
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 21:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbiJQTb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 15:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbiJQTbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 15:31:07 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E3A79622
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 12:30:09 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id g16so3563577qtu.2
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 12:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vYCp3d34DHyk/MSd0SLsGCr9Tzl/7iMlVaqVp/bW8fs=;
        b=djFxkvuvp5zx0RGWsuqxXw0nz3FlEGPgSBWsPhibqDvqE7o5nQSs8GODBFtvse4vOV
         YVoFSFs3OCsjaJ6RAY2T/C/UT5OtAcMcoLYFxClFJOrI24jPDLKVmdrOvyo/I9u9wz3M
         SrO8opwP9089RgnQTQWOoroobN/yWV6JapGr5pdKg23Wgb4erO1xfMZ5Yuhmdxeff1LT
         1muLUyQwr4U8oN87yZAOoAcB4zEVxXLH2Bf+4NAI8xgGi6GXICsKXr+z33r/YaxaBSXf
         SxcA8sKYuHzwoB3NhfJbeDdrsKmRcaTJxSmv7XL7RMFs+AYIBxX9t250J1oX2B+ECR4Q
         Uq5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vYCp3d34DHyk/MSd0SLsGCr9Tzl/7iMlVaqVp/bW8fs=;
        b=IDj82e+hD/yhlJE1GINQ821fSXtIvWBJMrzrcOSWFPP+Q1TCaoYegI7n3C+N8BWC0R
         Wdx/nQhLP+gMUFJfDOAu2y7T8rWrrNyNS/r9KDnhzCn8mIMfCuZB5AfDDaiBKfD+azWn
         GSe1aZL/oyPQGRmiLgyMU+PRRtYuYtDBPwYgpBXZ3nom5VVcCqx5uvxioj9k9spp/tIj
         gyO6FNeKhDDbcoQTSlWKsXEwLs9+du5Edy8XJFrZf/ELygIpKFmghUPg4ukQNp31aHXW
         7ndsIpawszUY9QdS5vbwUqjy9qMAbJ7yIp53y0580BoVlo5SzRjTkRSl6wVu+veDUMAc
         fTTA==
X-Gm-Message-State: ACrzQf1HzAtrKpMsnHg18IXVXvwWGpi8psXbE7a85N2jVlHcfzJZuuTB
        DLzmRK/3p8gZGCe9PhK2wUyKFu2QloP1xA==
X-Google-Smtp-Source: AMsMyM54ELXdsM8YuTaQsEYjKvKnkvwsMdMgAcKEBC7usKjbo3bh7GfCWAHeFBwn2Dvv3XZhDmfQ2g==
X-Received: by 2002:a05:622a:5a99:b0:39c:de22:9a34 with SMTP id fz25-20020a05622a5a9900b0039cde229a34mr10261173qtb.158.1666034975207;
        Mon, 17 Oct 2022 12:29:35 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id x6-20020ac86b46000000b0035ba48c032asm423831qts.25.2022.10.17.12.29.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 12:29:34 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        ovs-dev@openvswitch.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Aaron Conole <aconole@redhat.com>
Subject: [PATCH net-next 3/4] net: sched: call tcf_ct_params_free to free params in tcf_ct_init
Date:   Mon, 17 Oct 2022 15:29:27 -0400
Message-Id: <6a79528f110d6268572e5b8c50abcf9effcb0411.1666034595.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1666034595.git.lucien.xin@gmail.com>
References: <cover.1666034595.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to make the err path simple by calling tcf_ct_params_free(),
so that it won't cause problems when more members are added into param and
need freeing on the err path.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sched/act_ct.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index b38d91d6b249..193a460a9d7f 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -345,11 +345,9 @@ static void tcf_ct_flow_table_cleanup_work(struct work_struct *work)
 	module_put(THIS_MODULE);
 }
 
-static void tcf_ct_flow_table_put(struct tcf_ct_params *params)
+static void tcf_ct_flow_table_put(struct tcf_ct_flow_table *ct_ft)
 {
-	struct tcf_ct_flow_table *ct_ft = params->ct_ft;
-
-	if (refcount_dec_and_test(&params->ct_ft->ref)) {
+	if (refcount_dec_and_test(&ct_ft->ref)) {
 		rhashtable_remove_fast(&zones_ht, &ct_ft->node, zones_params);
 		INIT_RCU_WORK(&ct_ft->rwork, tcf_ct_flow_table_cleanup_work);
 		queue_rcu_work(act_ct_wq, &ct_ft->rwork);
@@ -832,18 +830,23 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 	return err;
 }
 
-static void tcf_ct_params_free(struct rcu_head *head)
+static void tcf_ct_params_free(struct tcf_ct_params *params)
 {
-	struct tcf_ct_params *params = container_of(head,
-						    struct tcf_ct_params, rcu);
-
-	tcf_ct_flow_table_put(params);
-
+	if (params->ct_ft)
+		tcf_ct_flow_table_put(params->ct_ft);
 	if (params->tmpl)
 		nf_ct_put(params->tmpl);
 	kfree(params);
 }
 
+static void tcf_ct_params_free_rcu(struct rcu_head *head)
+{
+	struct tcf_ct_params *params;
+
+	params = container_of(head, struct tcf_ct_params, rcu);
+	tcf_ct_params_free(params);
+}
+
 #if IS_ENABLED(CONFIG_NF_NAT)
 /* Modelled after nf_nat_ipv[46]_fn().
  * range is only used for new, uninitialized NAT state.
@@ -1390,7 +1393,7 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 
 	err = tcf_ct_flow_table_get(net, params);
 	if (err)
-		goto cleanup_params;
+		goto cleanup;
 
 	spin_lock_bh(&c->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
@@ -1401,17 +1404,15 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
 	if (params)
-		call_rcu(&params->rcu, tcf_ct_params_free);
+		call_rcu(&params->rcu, tcf_ct_params_free_rcu);
 
 	return res;
 
-cleanup_params:
-	if (params->tmpl)
-		nf_ct_put(params->tmpl);
 cleanup:
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
-	kfree(params);
+	if (params)
+		tcf_ct_params_free(params);
 	tcf_idr_release(*a, bind);
 	return err;
 }
@@ -1423,7 +1424,7 @@ static void tcf_ct_cleanup(struct tc_action *a)
 
 	params = rcu_dereference_protected(c->params, 1);
 	if (params)
-		call_rcu(&params->rcu, tcf_ct_params_free);
+		call_rcu(&params->rcu, tcf_ct_params_free_rcu);
 }
 
 static int tcf_ct_dump_key_val(struct sk_buff *skb,
-- 
2.31.1

