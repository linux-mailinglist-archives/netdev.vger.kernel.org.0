Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE7C75B6682
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 06:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbiIMEWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 00:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbiIMEVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 00:21:25 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2362DFF;
        Mon, 12 Sep 2022 21:20:21 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MRVYq1PHTzHnjW;
        Tue, 13 Sep 2022 12:17:51 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 13 Sep
 2022 12:19:51 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <jhs@mojatatu.com>, <jiri@resnulli.us>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <shuah@kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net-next 2/9] net/sched: use tc_cls_stats_update() in filter
Date:   Tue, 13 Sep 2022 12:21:28 +0800
Message-ID: <20220913042135.58342-3-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220913042135.58342-1-shaozhengchao@huawei.com>
References: <20220913042135.58342-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use tc_cls_stats_update() in filter.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/sched/cls_basic.c   |  9 +--------
 net/sched/cls_bpf.c     |  8 +-------
 net/sched/cls_flow.c    |  8 +-------
 net/sched/cls_fw.c      |  9 +--------
 net/sched/cls_route.c   |  9 +--------
 net/sched/cls_rsvp.h    |  9 +--------
 net/sched/cls_tcindex.c | 18 ++++--------------
 net/sched/cls_u32.c     | 20 +++++---------------
 8 files changed, 15 insertions(+), 75 deletions(-)

diff --git a/net/sched/cls_basic.c b/net/sched/cls_basic.c
index 8158fc9ee1ab..dd8b2a54ff9e 100644
--- a/net/sched/cls_basic.c
+++ b/net/sched/cls_basic.c
@@ -251,15 +251,8 @@ static void basic_walk(struct tcf_proto *tp, struct tcf_walker *arg,
 	struct basic_filter *f;
 
 	list_for_each_entry(f, &head->flist, link) {
-		if (arg->count < arg->skip)
-			goto skip;
-
-		if (arg->fn(tp, f, arg) < 0) {
-			arg->stop = 1;
+		if (!tc_cls_stats_update(tp, arg, f))
 			break;
-		}
-skip:
-		arg->count++;
 	}
 }
 
diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
index c85b85a192bf..e096b6deaedb 100644
--- a/net/sched/cls_bpf.c
+++ b/net/sched/cls_bpf.c
@@ -650,14 +650,8 @@ static void cls_bpf_walk(struct tcf_proto *tp, struct tcf_walker *arg,
 	struct cls_bpf_prog *prog;
 
 	list_for_each_entry(prog, &head->plist, link) {
-		if (arg->count < arg->skip)
-			goto skip;
-		if (arg->fn(tp, prog, arg) < 0) {
-			arg->stop = 1;
+		if (!tc_cls_stats_update(tp, arg, prog))
 			break;
-		}
-skip:
-		arg->count++;
 	}
 }
 
diff --git a/net/sched/cls_flow.c b/net/sched/cls_flow.c
index 972303aa8edd..5114cf00b27e 100644
--- a/net/sched/cls_flow.c
+++ b/net/sched/cls_flow.c
@@ -683,14 +683,8 @@ static void flow_walk(struct tcf_proto *tp, struct tcf_walker *arg,
 	struct flow_filter *f;
 
 	list_for_each_entry(f, &head->filters, list) {
-		if (arg->count < arg->skip)
-			goto skip;
-		if (arg->fn(tp, f, arg) < 0) {
-			arg->stop = 1;
+		if (!tc_cls_stats_update(tp, arg, f))
 			break;
-		}
-skip:
-		arg->count++;
 	}
 }
 
diff --git a/net/sched/cls_fw.c b/net/sched/cls_fw.c
index 8654b0ce997c..b2c1d4c21172 100644
--- a/net/sched/cls_fw.c
+++ b/net/sched/cls_fw.c
@@ -358,15 +358,8 @@ static void fw_walk(struct tcf_proto *tp, struct tcf_walker *arg,
 
 		for (f = rtnl_dereference(head->ht[h]); f;
 		     f = rtnl_dereference(f->next)) {
-			if (arg->count < arg->skip) {
-				arg->count++;
-				continue;
-			}
-			if (arg->fn(tp, f, arg) < 0) {
-				arg->stop = 1;
+			if (!tc_cls_stats_update(tp, arg, f))
 				return;
-			}
-			arg->count++;
 		}
 	}
 }
diff --git a/net/sched/cls_route.c b/net/sched/cls_route.c
index 29adac7812fe..dcf484f992e8 100644
--- a/net/sched/cls_route.c
+++ b/net/sched/cls_route.c
@@ -587,15 +587,8 @@ static void route4_walk(struct tcf_proto *tp, struct tcf_walker *arg,
 				for (f = rtnl_dereference(b->ht[h1]);
 				     f;
 				     f = rtnl_dereference(f->next)) {
-					if (arg->count < arg->skip) {
-						arg->count++;
-						continue;
-					}
-					if (arg->fn(tp, f, arg) < 0) {
-						arg->stop = 1;
+					if (!tc_cls_stats_update(tp, arg, f))
 						return;
-					}
-					arg->count++;
 				}
 			}
 		}
diff --git a/net/sched/cls_rsvp.h b/net/sched/cls_rsvp.h
index 5cd9d6b143c4..c1eb1eec2f4a 100644
--- a/net/sched/cls_rsvp.h
+++ b/net/sched/cls_rsvp.h
@@ -671,15 +671,8 @@ static void rsvp_walk(struct tcf_proto *tp, struct tcf_walker *arg,
 
 				for (f = rtnl_dereference(s->ht[h1]); f;
 				     f = rtnl_dereference(f->next)) {
-					if (arg->count < arg->skip) {
-						arg->count++;
-						continue;
-					}
-					if (arg->fn(tp, f, arg) < 0) {
-						arg->stop = 1;
+					if (!tc_cls_stats_update(tp, arg, f))
 						return;
-					}
-					arg->count++;
 				}
 			}
 		}
diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index 742c7d49a958..28d60436a1dc 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -566,13 +566,8 @@ static void tcindex_walk(struct tcf_proto *tp, struct tcf_walker *walker,
 		for (i = 0; i < p->hash; i++) {
 			if (!p->perfect[i].res.class)
 				continue;
-			if (walker->count >= walker->skip) {
-				if (walker->fn(tp, p->perfect + i, walker) < 0) {
-					walker->stop = 1;
-					return;
-				}
-			}
-			walker->count++;
+			if (!tc_cls_stats_update(tp, walker, p->perfect + i))
+				return;
 		}
 	}
 	if (!p->h)
@@ -580,13 +575,8 @@ static void tcindex_walk(struct tcf_proto *tp, struct tcf_walker *walker,
 	for (i = 0; i < p->hash; i++) {
 		for (f = rtnl_dereference(p->h[i]); f; f = next) {
 			next = rtnl_dereference(f->next);
-			if (walker->count >= walker->skip) {
-				if (walker->fn(tp, &f->result, walker) < 0) {
-					walker->stop = 1;
-					return;
-				}
-			}
-			walker->count++;
+			if (!tc_cls_stats_update(tp, walker, &f->result))
+				return;
 		}
 	}
 }
diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 4d27300c287c..a3e3df2c28d4 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -1125,26 +1125,16 @@ static void u32_walk(struct tcf_proto *tp, struct tcf_walker *arg,
 	     ht = rtnl_dereference(ht->next)) {
 		if (ht->prio != tp->prio)
 			continue;
-		if (arg->count >= arg->skip) {
-			if (arg->fn(tp, ht, arg) < 0) {
-				arg->stop = 1;
-				return;
-			}
-		}
-		arg->count++;
+
+		if (!tc_cls_stats_update(tp, arg, ht))
+			return;
+
 		for (h = 0; h <= ht->divisor; h++) {
 			for (n = rtnl_dereference(ht->ht[h]);
 			     n;
 			     n = rtnl_dereference(n->next)) {
-				if (arg->count < arg->skip) {
-					arg->count++;
-					continue;
-				}
-				if (arg->fn(tp, n, arg) < 0) {
-					arg->stop = 1;
+				if (!tc_cls_stats_update(tp, arg, n))
 					return;
-				}
-				arg->count++;
 			}
 		}
 	}
-- 
2.17.1

