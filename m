Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 823385904BA
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238391AbiHKQc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 12:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238402AbiHKQ3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 12:29:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F64EB3B27;
        Thu, 11 Aug 2022 09:09:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B39436144D;
        Thu, 11 Aug 2022 16:09:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC496C433C1;
        Thu, 11 Aug 2022 16:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660234158;
        bh=9QJf7r508q+G1K4G/3ycxN+9B0pUm4KIpqODls56zQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mooeiv8xnzwMAQ/rH+TyA0Hd1U+Qbc2hEaCAq5/XUaDICt5uzV/l0bh0WN9tcd8xZ
         T9Ie05xxsj525Dw09ujWTxJXIfUCFH3NuQiwCnjWiievuuC5LjstZNKf23+AoRDooE
         twBPkser7HywYKyWRr6erybV6ikOjyw2ff+DYHCFHAHLxVoGMYNvSjghOeGfS87L4L
         s43+T8xDoLKTJ8P9D+B23ju2PonWD8BL1MPw/hZI6WU3tH3aJJ/p9r2gR4LmlUo2Ig
         tNwCyKqMqEzUTmRE7V5RsjH/VocTfsJpEddjZ2sRmsaJpNkaBNKCNrDwCuG2tV23dP
         MKj+uduJQUjCQ==
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
Subject: [PATCH AUTOSEL 5.4 18/25] bpf: Don't redirect packets with invalid pkt_len
Date:   Thu, 11 Aug 2022 12:08:13 -0400
Message-Id: <20220811160826.1541971-18-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811160826.1541971-1-sashal@kernel.org>
References: <20220811160826.1541971-1-sashal@kernel.org>
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
index b04b5bd43f54..680f71ecdc08 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2201,6 +2201,14 @@ static inline void skb_set_tail_pointer(struct sk_buff *skb, const int offset)
 
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
index 1153bbcdff72..5e6428cbd758 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -200,6 +200,9 @@ static int convert___skb_to_skb(struct sk_buff *skb, struct __sk_buff *__skb)
 {
 	struct qdisc_skb_cb *cb = (struct qdisc_skb_cb *)skb->cb;
 
+	if (!skb->len)
+		return -EINVAL;
+
 	if (!__skb)
 		return 0;
 
diff --git a/net/core/dev.c b/net/core/dev.c
index a03036456221..60cea97132f2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3712,6 +3712,7 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 	bool again = false;
 
 	skb_reset_mac_header(skb);
+	skb_assert_len(skb);
 
 	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_SCHED_TSTAMP))
 		__skb_tstamp_tx(skb, NULL, skb->sk, SCM_TSTAMP_SCHED);
-- 
2.35.1

