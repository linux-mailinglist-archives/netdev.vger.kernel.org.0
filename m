Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4841C1B8699
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 14:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgDYMvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 08:51:31 -0400
Received: from mail.fudan.edu.cn ([202.120.224.73]:37824 "EHLO fudan.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726062AbgDYMva (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Apr 2020 08:51:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id; bh=iPU8F8naBvun4kFZg++TDJSeJmoXcaco35nw4sV+KAo=; b=p
        UIWEDU/0Nk33kf/Nb5s9ecvwQ8tG8Cu+XWCq2MisaH+YUZ2Jjs2q5swZ2tgXm+cr
        wIJ5Dah9/3EwDAMWOcOIJ53FgbCu34l8OTkhANgBJiqpUHrojOfCn9O1Uwjz+pEZ
        tPH5Orh2sXERCySaHVnoXMggizDJeH5yP0vD0fGryE=
Received: from localhost.localdomain (unknown [120.229.255.80])
        by app2 (Coremail) with SMTP id XQUFCgDXh+A3MqReswCpAA--.15235S3;
        Sat, 25 Apr 2020 20:51:05 +0800 (CST)
From:   Xiyu Yang <xiyuyang19@fudan.edu.cn>
To:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     yuanxzhang@fudan.edu.cn, kjlu@umn.edu,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>
Subject: [PATCH] bpf: Fix sk_psock refcnt leak when receiving message
Date:   Sat, 25 Apr 2020 20:50:40 +0800
Message-Id: <1587819040-38793-1-git-send-email-xiyuyang19@fudan.edu.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: XQUFCgDXh+A3MqReswCpAA--.15235S3
X-Coremail-Antispam: 1UD129KBjvJXoW7uFyktF4rAF1fCw4xAF4Utwb_yoW8Ar1xpa
        y2kayFvF18tFyUZwnxJFW8Jr1fW39rWa409rWrAa1fXFn8uw1fJFsYgr1avF40yrs2kr4Y
        gr4DKF4FkFnxu3JanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9K14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26rxl
        6s0DM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8Jw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAG
        YxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkIecxEwVAFwVW5JwCF04k20xvY0x0EwIxGrw
        CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
        14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
        IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxK
        x2IYs7xG6Fyj6rWUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14
        v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYmiiDUUUU
X-CM-SenderInfo: irzsiiysuqikmy6i3vldqovvfxof0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tcp_bpf_recvmsg() invokes sk_psock_get(), which returns a reference of
the specified sk_psock object to "psock" with increased refcnt.

When tcp_bpf_recvmsg() returns, local variable "psock" becomes invalid,
so the refcount should be decreased to keep refcount balanced.

The reference counting issue happens in several exception handling paths
of tcp_bpf_recvmsg(). When those error scenarios occur such as "flags"
includes MSG_ERRQUEUE, the function forgets to decrease the refcnt
increased by sk_psock_get(), causing a refcnt leak.

Fix this issue by calling sk_psock_put() when those error scenarios
occur.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
---
 net/ipv4/tcp_bpf.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 5a05327f97c1..feb6b90672c1 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -265,11 +265,15 @@ static int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	psock = sk_psock_get(sk);
 	if (unlikely(!psock))
 		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
-	if (unlikely(flags & MSG_ERRQUEUE))
+	if (unlikely(flags & MSG_ERRQUEUE)) {
+		sk_psock_put(sk, psock);
 		return inet_recv_error(sk, msg, len, addr_len);
+	}
 	if (!skb_queue_empty(&sk->sk_receive_queue) &&
-	    sk_psock_queue_empty(psock))
+	    sk_psock_queue_empty(psock)) {
+		sk_psock_put(sk, psock);
 		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
+	}
 	lock_sock(sk);
 msg_bytes_ready:
 	copied = __tcp_bpf_recvmsg(sk, psock, msg, len, flags);
-- 
2.7.4

