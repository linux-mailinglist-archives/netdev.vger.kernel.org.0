Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBD7483F7C
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 10:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbiADJ5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 04:57:05 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:53773 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230308AbiADJ5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 04:57:04 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0V0vAOIp_1641290221;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V0vAOIp_1641290221)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 04 Jan 2022 17:57:02 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        bpf@vger.kernel.org
Subject: [PATCH net] Revert "xsk: Do not sleep in poll() when need_wakeup set"
Date:   Tue,  4 Jan 2022 17:57:01 +0800
Message-Id: <20220104095701.10661-1-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit bd0687c18e635b63233dc87f38058cd728802ab4.

When working with epoll, if the application encounters tx full, the
application will enter epoll_wait and wait for tx to be awakened when
there is room.

In the current situation, when tx is full pool->cached_need_wakeup may
not be 0 (regardless of whether the driver supports wakeup, or whether
the user uses XDP_USE_NEED_WAKEUP). The result is that if the user
enters epoll_wait, because soock_poll_wait is not called, causing the
user process to not be awakened.

Fixes: bd0687c18e63 ("xsk: Do not sleep in poll() when need_wakeup set")
Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 net/xdp/xsk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index e3d35850fdea..28ef3f4465ae 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -677,6 +677,8 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
 	struct xdp_sock *xs = xdp_sk(sk);
 	struct xsk_buff_pool *pool;
 
+	sock_poll_wait(file, sock, wait);
+
 	if (unlikely(!xsk_is_bound(xs)))
 		return mask;
 
@@ -688,8 +690,6 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
 		else
 			/* Poll needs to drive Tx also in copy mode */
 			__xsk_sendmsg(sk);
-	} else {
-		sock_poll_wait(file, sock, wait);
 	}
 
 	if (xs->rx && !xskq_prod_is_empty(xs->rx))
-- 
2.31.0

