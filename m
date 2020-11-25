Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9468C2C394F
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 07:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgKYGtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 01:49:02 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:43647 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726314AbgKYGtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 01:49:02 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R821e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0UGUMiM2_1606286938;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UGUMiM2_1606286938)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 25 Nov 2020 14:48:59 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     magnus.karlsson@gmail.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        KP Singh <kpsingh@chromium.org>,
        netdev@vger.kernel.org (open list:XDP SOCKETS (AF_XDP)),
        bpf@vger.kernel.org (open list:XDP SOCKETS (AF_XDP)),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH bpf v2 1/2] xsk: replace datagram_poll by sock_poll_wait
Date:   Wed, 25 Nov 2020 14:48:56 +0800
Message-Id: <01f59423cad1b634fe704fe238a0038fd74df3ba.1606285978.git.xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1606285978.git.xuanzhuo@linux.alibaba.com>
References: <cover.1605686678.git.xuanzhuo@linux.alibaba.com>
 <cover.1606285978.git.xuanzhuo@linux.alibaba.com>
In-Reply-To: <cover.1606285978.git.xuanzhuo@linux.alibaba.com>
References: <cover.1606285978.git.xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

datagram_poll will judge the current socket status (EPOLLIN, EPOLLOUT)
based on the traditional socket information (eg: sk_wmem_alloc), but
this does not apply to xsk. So this patch uses sock_poll_wait instead of
datagram_poll, and the mask is calculated by xsk_poll.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 net/xdp/xsk.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index b014197..0df8651 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -534,11 +534,13 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 static __poll_t xsk_poll(struct file *file, struct socket *sock,
 			     struct poll_table_struct *wait)
 {
-	__poll_t mask = datagram_poll(file, sock, wait);
+	__poll_t mask = 0;
 	struct sock *sk = sock->sk;
 	struct xdp_sock *xs = xdp_sk(sk);
 	struct xsk_buff_pool *pool;
 
+	sock_poll_wait(file, sock, wait);
+
 	if (unlikely(!xsk_is_bound(xs)))
 		return mask;
 
-- 
1.8.3.1

