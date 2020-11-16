Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D322B3E57
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 09:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbgKPILD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 03:11:03 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:40962 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727789AbgKPILD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 03:11:03 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R581e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0UFVOgpP_1605514257;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UFVOgpP_1605514257)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 16 Nov 2020 16:10:58 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] xsk: add cq event
Date:   Mon, 16 Nov 2020 16:10:55 +0800
Message-Id: <b18c1f2cfb0c9c0b409c25f4a73248e869c8ac97.1605513087.git.xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we write all cq items to tx, we have to wait for a new event based
on poll to indicate that it is writable. But the current writability is
triggered based on whether tx is full or not, and In fact, when tx is
dissatisfied, the user of cq's item may not necessarily get it, because it
may still be occupied by the network card. In this case, we need to know
when cq is available, so this patch adds a socket option, When the user
configures this option using setsockopt, when cq is available, a
readable event is generated for all xsk bound to this umem.

I can't find a better description of this event,
I think it can also be 'readable', although it is indeed different from
the 'readable' of the new data. But the overhead of xsk checking whether
cq or rx is readable is small.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 include/net/xdp_sock.h      |  1 +
 include/uapi/linux/if_xdp.h |  1 +
 net/xdp/xsk.c               | 28 ++++++++++++++++++++++++++++
 3 files changed, 30 insertions(+)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 1a9559c..faf5b1a 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -49,6 +49,7 @@ struct xdp_sock {
 	struct xsk_buff_pool *pool;
 	u16 queue_id;
 	bool zc;
+	bool cq_event;
 	enum {
 		XSK_READY = 0,
 		XSK_BOUND,
diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp.h
index a78a809..2dba3cb 100644
--- a/include/uapi/linux/if_xdp.h
+++ b/include/uapi/linux/if_xdp.h
@@ -63,6 +63,7 @@ struct xdp_mmap_offsets {
 #define XDP_UMEM_COMPLETION_RING	6
 #define XDP_STATISTICS			7
 #define XDP_OPTIONS			8
+#define XDP_CQ_EVENT			9
 
 struct xdp_umem_reg {
 	__u64 addr; /* Start of packet data area */
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index cfbec39..0c53403 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -285,7 +285,16 @@ void __xsk_map_flush(void)
 
 void xsk_tx_completed(struct xsk_buff_pool *pool, u32 nb_entries)
 {
+	struct xdp_sock *xs;
+
 	xskq_prod_submit_n(pool->cq, nb_entries);
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(xs, &pool->xsk_tx_list, tx_list) {
+		if (xs->cq_event)
+			sock_def_readable(&xs->sk);
+	}
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL(xsk_tx_completed);
 
@@ -495,6 +504,9 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
 			__xsk_sendmsg(sk);
 	}
 
+	if (xs->cq_event && pool->cq && !xskq_prod_is_empty(pool->cq))
+		mask |= EPOLLIN | EPOLLRDNORM;
+
 	if (xs->rx && !xskq_prod_is_empty(xs->rx))
 		mask |= EPOLLIN | EPOLLRDNORM;
 	if (xs->tx && !xskq_cons_is_full(xs->tx))
@@ -882,6 +894,22 @@ static int xsk_setsockopt(struct socket *sock, int level, int optname,
 		mutex_unlock(&xs->mutex);
 		return err;
 	}
+	case XDP_CQ_EVENT:
+	{
+		int cq_event;
+
+		if (optlen < sizeof(cq_event))
+			return -EINVAL;
+		if (copy_from_sockptr(&cq_event, optval, sizeof(cq_event)))
+			return -EFAULT;
+
+		if (cq_event)
+			xs->cq_event = true;
+		else
+			xs->cq_event = false;
+
+		return 0;
+	}
 	default:
 		break;
 	}
-- 
1.8.3.1

