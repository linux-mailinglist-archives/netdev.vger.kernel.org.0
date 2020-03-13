Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93D55184C32
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 17:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgCMQSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 12:18:15 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46571 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbgCMQSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 12:18:14 -0400
Received: by mail-qt1-f194.google.com with SMTP id t13so7922745qtn.13
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 09:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1T1O8HLsuIxoSwcoU8OgLAr8bjqXdq26+gDnjPZNChE=;
        b=IQk0cfQG9fQ263IJTljRsFZ/f5xGqbTSQRKwrr1HLFTFNWp6mXfqZev60rzM7Hgabi
         AgF80a8R/4VO3VwJqjMCC7Nu5A4Slwf47qwD2TjLFJl7PqxmwVsmtmagVOzScSkaUXoG
         drXstxIx4xZMTcR2yZyDYOLP7tYLgnvUDLsywErOVNqm1c5vcKREvn4aXUmJ/jOfXXKt
         HOi/TBD3iW/pgusVdtZYuFUccqhW3hTr/fUYjD9ULvdIjmrV41wFCdq4LmjMA78Sln8v
         8resRzZ6spIBwOKzuZNn7zvD/g9Cgi3bbBenlOCq/Fi08szjOZGU7AU5F5JlEZX9f/a5
         vIsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1T1O8HLsuIxoSwcoU8OgLAr8bjqXdq26+gDnjPZNChE=;
        b=dEso4arJ7hUus9ezyBNJCVXus5njmuTm8utxBOncWdLA4ewUA9KGO1vjNL3AY+pk/7
         7E5uwdvvUC8C1pTTh+/9YpK1N24S4D9YMaIEMm/RQLUBr1+AG2cO7ESYycRlGsTZvPUp
         BoG0QARL//2BxGECl+Dhf1FJxvPdcqjdluPhXxqb3y4O3sGupoQ4UMjMGZyDtwVmqHDZ
         vUvd3WeB4MB0uLyVIhFh22g0SbssQGO+CHw//6BDBeUpqW9AbG/mDezVNjtYHrLH6yP7
         3Nt+V/31oYn6mRW4oOqMMugeAa7Gx1dC41zRdXfRRthRWuXwregyIKR0fOEXzYG34euq
         XMgw==
X-Gm-Message-State: ANhLgQ2wVyowp8+j6BCoVRnH8gYRQuuf9azxF/GpTyx32o+ROkczrDPy
        f4mTvIShCXcN6zAIVqNNKIq/aaPh
X-Google-Smtp-Source: ADFU+vt6CNIY2dfMtBhHFi6KiZTqz7jI4nZV8NTVqKi2396VpLKS79rq/RuoxSm5RaJMSblhRLBckQ==
X-Received: by 2002:ac8:775a:: with SMTP id g26mr13159182qtu.125.1584116292594;
        Fri, 13 Mar 2020 09:18:12 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:37b5:dd03:b905:30ea])
        by smtp.gmail.com with ESMTPSA id j11sm29146930qtc.91.2020.03.13.09.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 09:18:11 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jrosen@cisco.com,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net] net/packet: tpacket_rcv: avoid a producer race condition
Date:   Fri, 13 Mar 2020 12:18:09 -0400
Message-Id: <20200313161809.142676-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

PACKET_RX_RING can cause multiple writers to access the same slot if a
fast writer wraps the ring while a slow writer is still copying. This
is particularly likely with few, large, slots (e.g., GSO packets).

Synchronize kernel thread ownership of rx ring slots with a bitmap.

Writers acquire a slot race-free by testing tp_status TP_STATUS_KERNEL
while holding the sk receive queue lock. They release this lock before
copying and set tp_status to TP_STATUS_USER to release to userspace
when done. During copying, another writer may take the lock, also see
TP_STATUS_KERNEL, and start writing to the same slot.

Introduce a new rx_owner_map bitmap with a bit per slot. To acquire a
slot, test and set with the lock held. To release race-free, update
tp_status and owner bit as a transaction, so take the lock again.

This is the one of a variety of discussed options (see Link below):

* instead of a shadow ring, embed the data in the slot itself, such as
in tp_padding. But any test for this field may match a value left by
userspace, causing deadlock.

* avoid the lock on release. This leaves a small race if releasing the
shadow slot before setting TP_STATUS_USER. The below reproducer showed
that this race is not academic. If releasing the slot after tp_status,
the race is more subtle. See the first link for details.

* add a new tp_status TP_KERNEL_OWNED to avoid the transactional store
of two fields. But, legacy applications may interpret all non-zero
tp_status as owned by the user. As libpcap does. So this is possible
only opt-in by newer processes. It can be added as an optional mode.

* embed the struct at the tail of pg_vec to avoid extra allocation.
The implementation proved no less complex than a separate field.

The additional locking cost on release adds contention, no different
than scaling on multicore or multiqueue h/w. In practice, below
reproducer nor small packet tcpdump showed a noticeable change in
perf report in cycles spent in spinlock. Where contention is
problematic, packet sockets support mitigation through PACKET_FANOUT.
And we can consider adding opt-in state TP_KERNEL_OWNED.

Easy to reproduce by running multiple netperf or similar TCP_STREAM
flows concurrently with `tcpdump -B 129 -n greater 60000`.

Based on an earlier patchset by Jon Rosen. See links below.

I believe this issue goes back to the introduction of tpacket_rcv,
which predates git history.

Link: https://www.mail-archive.com/netdev@vger.kernel.org/msg237222.html
Suggested-by: Jon Rosen <jrosen@cisco.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>

---

We discussed this two years ago. After again spending a few days
trying all options, I found I again ended up with essentially your
last solution, Jon. Please feel free to add your Signed-off-by
or resubmit as first author.

I can move the alternatives to below the --- to reduce commit length.
---
 net/packet/af_packet.c | 21 +++++++++++++++++++++
 net/packet/internal.h  |  5 ++++-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index e5b0986215d2..29bd405adbbd 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2173,6 +2173,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 	struct timespec64 ts;
 	__u32 ts_status;
 	bool is_drop_n_account = false;
+	unsigned int slot_id = 0;
 	bool do_vnet = false;
 
 	/* struct tpacket{2,3}_hdr is aligned to a multiple of TPACKET_ALIGNMENT.
@@ -2275,6 +2276,13 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (!h.raw)
 		goto drop_n_account;
 
+	if (po->tp_version <= TPACKET_V2) {
+		slot_id = po->rx_ring.head;
+		if (test_bit(slot_id, po->rx_ring.rx_owner_map))
+			goto drop_n_account;
+		__set_bit(slot_id, po->rx_ring.rx_owner_map);
+	}
+
 	if (do_vnet &&
 	    virtio_net_hdr_from_skb(skb, h.raw + macoff -
 				    sizeof(struct virtio_net_hdr),
@@ -2380,7 +2388,10 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 #endif
 
 	if (po->tp_version <= TPACKET_V2) {
+		spin_lock(&sk->sk_receive_queue.lock);
 		__packet_set_status(po, h.raw, status);
+		__clear_bit(slot_id, po->rx_ring.rx_owner_map);
+		spin_unlock(&sk->sk_receive_queue.lock);
 		sk->sk_data_ready(sk);
 	} else {
 		prb_clear_blk_fill_status(&po->rx_ring);
@@ -4277,6 +4288,7 @@ static int packet_set_ring(struct sock *sk, union tpacket_req_u *req_u,
 {
 	struct pgv *pg_vec = NULL;
 	struct packet_sock *po = pkt_sk(sk);
+	unsigned long *rx_owner_map = NULL;
 	int was_running, order = 0;
 	struct packet_ring_buffer *rb;
 	struct sk_buff_head *rb_queue;
@@ -4362,6 +4374,12 @@ static int packet_set_ring(struct sock *sk, union tpacket_req_u *req_u,
 			}
 			break;
 		default:
+			if (!tx_ring) {
+				rx_owner_map = bitmap_alloc(req->tp_frame_nr,
+					GFP_KERNEL | __GFP_NOWARN | __GFP_ZERO);
+				if (!rx_owner_map)
+					goto out_free_pg_vec;
+			}
 			break;
 		}
 	}
@@ -4391,6 +4409,8 @@ static int packet_set_ring(struct sock *sk, union tpacket_req_u *req_u,
 		err = 0;
 		spin_lock_bh(&rb_queue->lock);
 		swap(rb->pg_vec, pg_vec);
+		if (po->tp_version <= TPACKET_V2)
+			swap(rb->rx_owner_map, rx_owner_map);
 		rb->frame_max = (req->tp_frame_nr - 1);
 		rb->head = 0;
 		rb->frame_size = req->tp_frame_size;
@@ -4422,6 +4442,7 @@ static int packet_set_ring(struct sock *sk, union tpacket_req_u *req_u,
 	}
 
 out_free_pg_vec:
+	bitmap_free(rx_owner_map);
 	if (pg_vec)
 		free_pg_vec(pg_vec, order, req->tp_block_nr);
 out:
diff --git a/net/packet/internal.h b/net/packet/internal.h
index 82fb2b10f790..907f4cd2a718 100644
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -70,7 +70,10 @@ struct packet_ring_buffer {
 
 	unsigned int __percpu	*pending_refcnt;
 
-	struct tpacket_kbdq_core	prb_bdqc;
+	union {
+		unsigned long			*rx_owner_map;
+		struct tpacket_kbdq_core	prb_bdqc;
+	};
 };
 
 extern struct mutex fanout_mutex;
-- 
2.25.1.481.gfbce0eb801-goog

