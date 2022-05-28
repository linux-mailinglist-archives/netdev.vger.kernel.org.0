Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F26E536A14
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 04:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352215AbiE1CFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 22:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352020AbiE1CFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 22:05:45 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC8862A07;
        Fri, 27 May 2022 19:05:44 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4L94jN0gPzzgYQS;
        Sat, 28 May 2022 10:04:08 +0800 (CST)
Received: from container.huawei.com (10.175.104.82) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 28 May 2022 10:05:38 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
Subject: [PATCH net-next v3] ipv6: Fix signed integer overflow in __ip6_append_data
Date:   Sat, 28 May 2022 10:23:12 +0800
Message-ID: <20220528022312.2827597-1-wangyufen@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resurrect ubsan overflow checks and ubsan report this warning,
fix it by change the variable [length] type to size_t.

UBSAN: signed-integer-overflow in net/ipv6/ip6_output.c:1489:19
2147479552 + 8567 cannot be represented in type 'int'
CPU: 0 PID: 253 Comm: err Not tainted 5.16.0+ #1
Hardware name: linux,dummy-virt (DT)
Call trace:
  dump_backtrace+0x214/0x230
  show_stack+0x30/0x78
  dump_stack_lvl+0xf8/0x118
  dump_stack+0x18/0x30
  ubsan_epilogue+0x18/0x60
  handle_overflow+0xd0/0xf0
  __ubsan_handle_add_overflow+0x34/0x44
  __ip6_append_data.isra.48+0x1598/0x1688
  ip6_append_data+0x128/0x260
  udpv6_sendmsg+0x680/0xdd0
  inet6_sendmsg+0x54/0x90
  sock_sendmsg+0x70/0x88
  ____sys_sendmsg+0xe8/0x368
  ___sys_sendmsg+0x98/0xe0
  __sys_sendmmsg+0xf4/0x3b8
  __arm64_sys_sendmmsg+0x34/0x48
  invoke_syscall+0x64/0x160
  el0_svc_common.constprop.4+0x124/0x300
  do_el0_svc+0x44/0xc8
  el0_svc+0x3c/0x1e8
  el0t_64_sync_handler+0x88/0xb0
  el0t_64_sync+0x16c/0x170

Changes since v1:
-Change the variable [length] type to unsigned, as Eric Dumazet suggested.
Changes since v2:
-Don't change exthdrlen type in ip6_make_skb, as Paolo Abeni suggested.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
---
 include/net/ipv6.h    | 4 ++--
 net/ipv6/ip6_output.c | 6 +++---
 net/ipv6/udp.c        | 2 +-
 net/l2tp/l2tp_ip6.c   | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 5b38bf1a586b..de9dcc5652c4 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1063,7 +1063,7 @@ int ip6_find_1stfragopt(struct sk_buff *skb, u8 **nexthdr);
 int ip6_append_data(struct sock *sk,
 		    int getfrag(void *from, char *to, int offset, int len,
 				int odd, struct sk_buff *skb),
-		    void *from, int length, int transhdrlen,
+		    void *from, size_t length, int transhdrlen,
 		    struct ipcm6_cookie *ipc6, struct flowi6 *fl6,
 		    struct rt6_info *rt, unsigned int flags);
 
@@ -1079,7 +1079,7 @@ struct sk_buff *__ip6_make_skb(struct sock *sk, struct sk_buff_head *queue,
 struct sk_buff *ip6_make_skb(struct sock *sk,
 			     int getfrag(void *from, char *to, int offset,
 					 int len, int odd, struct sk_buff *skb),
-			     void *from, int length, int transhdrlen,
+			     void *from, size_t length, int transhdrlen,
 			     struct ipcm6_cookie *ipc6,
 			     struct rt6_info *rt, unsigned int flags,
 			     struct inet_cork_full *cork);
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 4081b12a01ff..77e3f5970ce4 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1450,7 +1450,7 @@ static int __ip6_append_data(struct sock *sk,
 			     struct page_frag *pfrag,
 			     int getfrag(void *from, char *to, int offset,
 					 int len, int odd, struct sk_buff *skb),
-			     void *from, int length, int transhdrlen,
+			     void *from, size_t length, int transhdrlen,
 			     unsigned int flags, struct ipcm6_cookie *ipc6)
 {
 	struct sk_buff *skb, *skb_prev = NULL;
@@ -1798,7 +1798,7 @@ static int __ip6_append_data(struct sock *sk,
 int ip6_append_data(struct sock *sk,
 		    int getfrag(void *from, char *to, int offset, int len,
 				int odd, struct sk_buff *skb),
-		    void *from, int length, int transhdrlen,
+		    void *from, size_t length, int transhdrlen,
 		    struct ipcm6_cookie *ipc6, struct flowi6 *fl6,
 		    struct rt6_info *rt, unsigned int flags)
 {
@@ -1995,7 +1995,7 @@ EXPORT_SYMBOL_GPL(ip6_flush_pending_frames);
 struct sk_buff *ip6_make_skb(struct sock *sk,
 			     int getfrag(void *from, char *to, int offset,
 					 int len, int odd, struct sk_buff *skb),
-			     void *from, int length, int transhdrlen,
+			     void *from, size_t length, int transhdrlen,
 			     struct ipcm6_cookie *ipc6, struct rt6_info *rt,
 			     unsigned int flags, struct inet_cork_full *cork)
 {
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 55afd7f39c04..91704bbc7715 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1308,7 +1308,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	struct ipcm6_cookie ipc6;
 	int addr_len = msg->msg_namelen;
 	bool connected = false;
-	int ulen = len;
+	size_t ulen = len;
 	int corkreq = READ_ONCE(up->corkflag) || msg->msg_flags&MSG_MORE;
 	int err;
 	int is_udplite = IS_UDPLITE(sk);
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index c6ff8bf9b55f..5981d6e25776 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -504,7 +504,7 @@ static int l2tp_ip6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	struct ipcm6_cookie ipc6;
 	int addr_len = msg->msg_namelen;
 	int transhdrlen = 4; /* zero session-id */
-	int ulen = len + transhdrlen;
+	size_t ulen = len + transhdrlen;
 	int err;
 
 	/* Rough check on arithmetic overflow,
-- 
2.25.1

