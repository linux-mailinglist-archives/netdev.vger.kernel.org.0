Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63B4D590387
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238309AbiHKQ1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 12:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238447AbiHKQ0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 12:26:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A811511441;
        Thu, 11 Aug 2022 09:07:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EF69B821AE;
        Thu, 11 Aug 2022 16:07:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1D0C433D6;
        Thu, 11 Aug 2022 16:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660234061;
        bh=VNOvAUTm9ITNEsg5utj03668RaFbEKTXdPs/gQI3s24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cevH+2OfJyydPwjNv7y/emHmB8xdwdvD170frz/0kVfp6ice/nRCUWhTj8yvrYSFd
         9UzW+tPi1qQv1Tj1B6dUqrW85stBcVwKwHsb4SHvTY3KOFWtbwYNRBwyzLvzp/mg15
         mlsA4mjwEgg+kXfUNDXUj706d9pVVTFsNgqAKjkH8c8DJf9i3B1GHnzDF87xkSH++X
         Jy76mYZp1U/a0ddptGbnMw8DfxLn3gFjm/bkbBVCadPM9qItNrKX4TRQLJ7atbo+KG
         ULlecRe5MQzG1gLMlYghj86l7TLj7LlNPC3cmNoLD0D+ZzYddei6QY0YJGc3keACBy
         nvTt/CPlYWIbA==
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
Subject: [PATCH AUTOSEL 5.10 35/46] bpf: Don't redirect packets with invalid pkt_len
Date:   Thu, 11 Aug 2022 12:03:59 -0400
Message-Id: <20220811160421.1539956-35-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811160421.1539956-1-sashal@kernel.org>
References: <20220811160421.1539956-1-sashal@kernel.org>
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
index acbf1875ad50..61fc053a4a4e 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2222,6 +2222,14 @@ static inline void skb_set_tail_pointer(struct sk_buff *skb, const int offset)
 
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
index eb684f31fd69..da13adac0fdc 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -398,6 +398,9 @@ static int convert___skb_to_skb(struct sk_buff *skb, struct __sk_buff *__skb)
 {
 	struct qdisc_skb_cb *cb = (struct qdisc_skb_cb *)skb->cb;
 
+	if (!skb->len)
+		return -EINVAL;
+
 	if (!__skb)
 		return 0;
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 637bc576fbd2..dd0070b0d1e2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4097,6 +4097,7 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 	bool again = false;
 
 	skb_reset_mac_header(skb);
+	skb_assert_len(skb);
 
 	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_SCHED_TSTAMP))
 		__skb_tstamp_tx(skb, NULL, skb->sk, SCM_TSTAMP_SCHED);
-- 
2.35.1

