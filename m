Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9046E5900DA
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 17:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236611AbiHKPrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 11:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236664AbiHKPqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 11:46:03 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED3224950;
        Thu, 11 Aug 2022 08:40:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 14DD1CE223A;
        Thu, 11 Aug 2022 15:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4334C433D7;
        Thu, 11 Aug 2022 15:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232419;
        bh=VSXzN9FQUeQ+9olGNZCgpdskhfdRDBYRp89MGdAkkww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KJgcbSmzpAh9RyXBp5Z2mPWsSS481N1xvDDb0fgm6epka4YNA1cOkj2L9hjEmjR8r
         CGgqIrolBIoUdqNlQlN1A/JWD/dOfAGQ4roXMM7ZUhl62z56Cqk881YneRADmCAZyK
         34rMoa1gCXd9yOSeU/BV1l2nCj1MgJ0maeODckIXg46X/1W7W0Hdjr3XB8obqmE6YC
         irq80duFLp0TFvt6Cs4sgo01kMXAJOpsS43rryEVceMRpdufpfqtxT8lKvXnUWhgSu
         oZyrJrBDjqtQWyp9dP1/u4d8HHjRPy5Yt6RZ9nK/XiSCabpTKHCYgs9ZUBSlxgJPB2
         KEe1sMdbgQ0eg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhengchao Shao <shaozhengchao@huawei.com>,
        syzbot+7a12909485b94426aceb@syzkaller.appspotmail.com,
        Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, imagedong@tencent.com,
        dsahern@kernel.org, kafai@fb.com, talalahmad@google.com,
        keescook@chromium.org, asml.silence@gmail.com,
        bigeasy@linutronix.de, petrm@nvidia.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 077/105] bpf: Don't redirect packets with invalid pkt_len
Date:   Thu, 11 Aug 2022 11:28:01 -0400
Message-Id: <20220811152851.1520029-77-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit fd1894224407c484f652ad456e1ce423e89bb3eb ]

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
Reviewed-by: Stanislav Fomichev <sdf@google.com>
Link: https://lore.kernel.org/r/20220715115559.139691-1-shaozhengchao@huawei.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h | 8 ++++++++
 net/bpf/test_run.c     | 3 +++
 net/core/dev.c         | 1 +
 3 files changed, 12 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index d3d10556f0fa..2f41364a6791 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2624,6 +2624,14 @@ static inline void skb_set_tail_pointer(struct sk_buff *skb, const int offset)
 
 #endif /* NET_SKBUFF_DATA_USES_OFFSET */
 
+static inline void skb_assert_len(struct sk_buff *skb)
+{
+#ifdef CONFIG_DEBUG_NET
+	if (WARN_ONCE(!skb->len, "%s\n", __func__))
+		DO_ONCE_LITE(skb_dump, KERN_ERR, skb, false);
+#endif /* CONFIG_DEBUG_NET */
+}
+
 /*
  *	Add data to an sk_buff
  */
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 56f059b3c242..42f8de4ebbd7 100644
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
index 30a1603a7225..fe487dc6798e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4168,6 +4168,7 @@ int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 	bool again = false;
 
 	skb_reset_mac_header(skb);
+	skb_assert_len(skb);
 
 	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_SCHED_TSTAMP))
 		__skb_tstamp_tx(skb, NULL, NULL, skb->sk, SCM_TSTAMP_SCHED);
-- 
2.35.1

