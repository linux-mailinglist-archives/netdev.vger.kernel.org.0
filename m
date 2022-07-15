Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 444195759E3
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 05:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241267AbiGODSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 23:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiGODSI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 23:18:08 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1AC76E85;
        Thu, 14 Jul 2022 20:18:07 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Lkc1X0yKrz1L943;
        Fri, 15 Jul 2022 11:15:28 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 15 Jul
 2022 11:18:03 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <hawk@kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <bigeasy@linutronix.de>, <imagedong@tencent.com>,
        <petrm@nvidia.com>, <arnd@arndb.de>, <dsahern@kernel.org>,
        <talalahmad@google.com>, <keescook@chromium.org>,
        <haoluo@google.com>, <jolsa@kernel.org>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH v3,bpf-next] bpf: Don't redirect packets with invalid pkt_len
Date:   Fri, 15 Jul 2022 11:22:33 +0800
Message-ID: <20220715032233.230507-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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

Syzbot found an issue [1]: fq_codel_drop() try to drop a flow whitout any
skbs, that is, the flow->head is null.
The root cause, as the [2] says, is because that bpf_prog_test_run_skb()
run a bpf prog which redirects empty skbs.
So we should determine whether the length of the packet modified by bpf
prog or others like bpf_prog_test is valid before forwarding it directly.

LINK: [1] https://syzkaller.appspot.com/bug?id=0b84da80c2917757915afa89f7738a9d16ec96c5
LINK: [2] https://www.spinics.net/lists/netdev/msg777503.html

Reported-by: syzbot+7a12909485b94426aceb@syzkaller.appspotmail.com
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
v2: need move checking to convert___skb_to_skb and add debug info
v1: should not check len in fast path

 include/linux/skbuff.h | 11 +++++++++++
 net/bpf/test_run.c     |  3 +++
 net/core/dev.c         |  1 +
 3 files changed, 15 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index f6a27ab19202..8ea41ad0786b 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2459,6 +2459,17 @@ static inline void skb_set_tail_pointer(struct sk_buff *skb, const int offset)
 
 #endif /* NET_SKBUFF_DATA_USES_OFFSET */
 
+static inline void skb_assert_len(struct sk_buff *skb)
+{
+#ifdef CONFIG_DEBUG_NET
+	if (unlikely(!skb->len)) {
+		pr_err("%s\n", __func__);
+		skb_dump(KERN_ERR, skb, false);
+		WARN_ON_ONCE(1);
+	}
+#endif /* CONFIG_DEBUG_NET */
+}
+
 /*
  *	Add data to an sk_buff
  */
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 2ca96acbc50a..dc9dc0bedca0 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -955,6 +955,9 @@ static int convert___skb_to_skb(struct sk_buff *skb, struct __sk_buff *__skb)
 {
 	struct qdisc_skb_cb *cb = (struct qdisc_skb_cb *)skb->cb;
 
+	if (!skb->len)
+		return -EINVAL;
+
 	if (!__skb)
 		return 0;
 
diff --git a/net/core/dev.c b/net/core/dev.c
index d588fd0a54ce..716df64fcfa5 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4168,6 +4168,7 @@ int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 	bool again = false;
 
 	skb_reset_mac_header(skb);
+	skb_assert_len(skb);
 
 	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_SCHED_TSTAMP))
 		__skb_tstamp_tx(skb, NULL, NULL, skb->sk, SCM_TSTAMP_SCHED);
-- 
2.17.1

