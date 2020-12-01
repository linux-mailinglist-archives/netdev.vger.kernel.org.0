Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE5F2CA4AA
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 15:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403806AbgLAN5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 08:57:53 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:54015 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403792AbgLAN5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 08:57:52 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R851e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0UHDFqZy_1606831019;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UHDFqZy_1606831019)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 01 Dec 2020 21:57:00 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     magnus.karlsson@intel.com, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        netdev@vger.kernel.org (open list:XDP SOCKETS (AF_XDP)),
        bpf@vger.kernel.org (open list:XDP SOCKETS (AF_XDP)),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH bpf V3 1/2] xsk: replace datagram_poll by sock_poll_wait
Date:   Tue,  1 Dec 2020 21:56:57 +0800
Message-Id: <e82f4697438cd63edbf271ebe1918db8261b7c09.1606555939.git.xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1606555939.git.xuanzhuo@linux.alibaba.com>
References: <MW3PR11MB46023BE924A19FB198604C0DF7F40@MW3PR11MB4602.namprd11.prod.outlook.com>
 <cover.1606555939.git.xuanzhuo@linux.alibaba.com>
In-Reply-To: <cover.1606555939.git.xuanzhuo@linux.alibaba.com>
References: <cover.1606555939.git.xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

datagram_poll will judge the current socket status (EPOLLIN, EPOLLOUT)
based on the traditional socket information (eg: sk_wmem_alloc), but
this does not apply to xsk. So this patch uses sock_poll_wait instead of
datagram_poll, and the mask is calculated by xsk_poll.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 net/xdp/xsk.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index b7b039b..9bbfd8a 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -471,11 +471,13 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
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

