Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 862F33C276
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 06:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391162AbfFKElI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 00:41:08 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38363 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391149AbfFKElH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 00:41:07 -0400
Received: by mail-qt1-f194.google.com with SMTP id n11so10886828qtl.5
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 21:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i2Es2bp1InNBsyyW+vpY1dcrkyzi/FbyyM6ZyJogAQ8=;
        b=XWOlkCRvvG2zDdnWaPTmyx/dSVqSyIVZMuS1fMMAm/O+j+IasFWCtLYnQBE88fhwaZ
         cOMkNC1pzErZpCCdU2Pk4Poeyfwtb4Ob/GMjTMHGzpkIQf9oLm5hzAjeVPxroIGhmvmh
         Umyawoszkp67j4pLLjGiawRDtVLkJl6yqoqW0TODDhjQkjOCwloR8p2s0nNu/CghuLTv
         kA++tEx4wsnAZ48wCysPmBaEyroar6UUDCvxfjSFjfPHgMLRQtxkQ86eidbCV93Qd+LR
         +FVJVeCZpq7aHDa75VyqbqojxeMb1fh7qFJsfAcGUmsafRJaY/hIGyAQJueQYxrMC37A
         yWJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i2Es2bp1InNBsyyW+vpY1dcrkyzi/FbyyM6ZyJogAQ8=;
        b=WSa75vTUV7vszEcOfCCVp39XuHjSJ5OW/U908PXQYB0EDKqoPHaVIcIFrfZwa8T3eg
         CtMWrDLH4GiTN0FW+BOl9TofzNXx/8fjc2nIEbpMiSr2l9pi9Z82FxdV3JqUV67RNuUv
         ulflSumUp6nphjK8uLt4t12kipTHRp8pjvGoA960vT03iPUDTdC1bihkrud88QSEzDC3
         U2KthN8Yc7dY+2bN43G+dKF7dCBuljxcDV61qJoAJOCGkihPY86NJzAEKA/B5B65+0QN
         BdZDNAhl02jyAQcu0IOglIToggrg2D4TFDe2nX430A0ImRAlNDoaFjMic7Q5cJGxuLgN
         SChQ==
X-Gm-Message-State: APjAAAXqbiQlew51Ysoa0qmdvpV1Qlj8s5qz+khiZW7CczmQoYtO/EC2
        QD4fLju4/utM4lJOKzY6yn/88A==
X-Google-Smtp-Source: APXvYqx0OCJtVMpJ5eAD0+DMBrz8WoLIQtIhFFp++BoEOYmF7yZGwnXnOAp5KRXpKfZ/M9WmnGtcmQ==
X-Received: by 2002:ac8:40cd:: with SMTP id f13mr49794457qtm.100.1560228066514;
        Mon, 10 Jun 2019 21:41:06 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y3sm2463375qtj.46.2019.06.10.21.41.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 21:41:05 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com, davejwatson@fb.com,
        borisp@mellanox.com, Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 11/12] net/tls: add kernel-driven resync mechanism for TX
Date:   Mon, 10 Jun 2019 21:40:09 -0700
Message-Id: <20190611044010.29161-12-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190611044010.29161-1-jakub.kicinski@netronome.com>
References: <20190611044010.29161-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TLS offload drivers keep track of TCP seq numbers to make sure
the packets are fed into the HW in order.

When packets get dropped on the way through the stack, the driver
will get out of sync and have to use fallback encryption, but unless
TCP seq number is resynced it will never match the packets correctly
(or even worse - use incorrect record sequence number after TCP seq
wraps).

Existing drivers (mlx5) feed the entire record on every out-of-order
event, allowing FW/HW to always be in sync.

This patch adds an alternative, more akin to the RX resync.  When
driver sees a frame which is past its expected sequence number the
stream must have gotten out of order (if the sequence number is
smaller than expected its likely a retransmission which doesn't
require resync).  Driver will ask the stack to perform TX sync
before it submits the next full record, and fall back to software
crypto until stack has performed the sync.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 Documentation/networking/tls-offload.rst | 35 +++++++++++++++++++++++-
 include/net/tls.h                        | 23 ++++++++++++++++
 net/tls/tls_device.c                     | 27 ++++++++++++++++++
 3 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/tls-offload.rst b/Documentation/networking/tls-offload.rst
index d134d63307e7..048e5ca44824 100644
--- a/Documentation/networking/tls-offload.rst
+++ b/Documentation/networking/tls-offload.rst
@@ -206,7 +206,11 @@ TX
 
 Segments transmitted from an offloaded socket can get out of sync
 in similar ways to the receive side-retransmissions - local drops
-are possible, though network reorders are not.
+are possible, though network reorders are not. There are currently
+two mechanisms for dealing with out of order segments.
+
+Crypto state rebuilding
+~~~~~~~~~~~~~~~~~~~~~~~
 
 Whenever an out of order segment is transmitted the driver provides
 the device with enough information to perform cryptographic operations.
@@ -225,6 +229,35 @@ was just a retransmission. The former is simpler, and does not require
 retransmission detection therefore it is the recommended method until
 such time it is proven inefficient.
 
+Next record sync
+~~~~~~~~~~~~~~~~
+
+Whenever an out of order segment is detected the driver requests
+that the ``ktls`` software fallback code encrypt it. If the segment's
+sequence number is lower than expected the driver assumes retransmission
+and doesn't change device state. If the segment is in the future, it
+may imply a local drop, the driver asks the stack to sync the device
+to the next record state and falls back to software.
+
+Resync request is indicated with:
+
+.. code-block:: c
+
+  void tls_offload_tx_resync_request(struct sock *sk, u32 got_seq, u32 exp_seq)
+
+Until resync is complete driver should not access its expected TCP
+sequence number (as it will be updated from a different context).
+Following helper should be used to test if resync is complete:
+
+.. code-block:: c
+
+  bool tls_offload_tx_resync_pending(struct sock *sk)
+
+Next time ``ktls`` pushes a record it will first send its TCP sequence number
+and TLS record number to the driver. Stack will also make sure that
+the new record will start on a segment boundary (like it does when
+the connection is initially added).
+
 RX
 --
 
diff --git a/include/net/tls.h b/include/net/tls.h
index 9b49baecc4a8..63e473420b00 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -212,6 +212,11 @@ struct tls_offload_context_tx {
 
 enum tls_context_flags {
 	TLS_RX_SYNC_RUNNING = 0,
+	/* Unlike RX where resync is driven entirely by the core in TX only
+	 * the driver knows when things went out of sync, so we need the flag
+	 * to be atomic.
+	 */
+	TLS_TX_SYNC_SCHED = 1,
 };
 
 struct cipher_context {
@@ -619,6 +624,24 @@ tls_offload_rx_resync_set_type(struct sock *sk, enum tls_offload_sync_type type)
 	tls_offload_ctx_rx(tls_ctx)->resync_type = type;
 }
 
+static inline void tls_offload_tx_resync_request(struct sock *sk)
+{
+	struct tls_context *tls_ctx = tls_get_ctx(sk);
+
+	WARN_ON(test_and_set_bit(TLS_TX_SYNC_SCHED, &tls_ctx->flags));
+}
+
+/* Driver's seq tracking has to be disabled until resync succeeded */
+static inline bool tls_offload_tx_resync_pending(struct sock *sk)
+{
+	struct tls_context *tls_ctx = tls_get_ctx(sk);
+	bool ret;
+
+	ret = test_bit(TLS_TX_SYNC_SCHED, &tls_ctx->flags);
+	smp_mb__after_atomic();
+	return ret;
+}
+
 int tls_proccess_cmsg(struct sock *sk, struct msghdr *msg,
 		      unsigned char *record_type);
 void tls_register_device(struct tls_device *device);
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index b35a3b902bfa..40076f423dcb 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -209,6 +209,29 @@ void tls_device_free_resources_tx(struct sock *sk)
 	tls_free_partial_record(sk, tls_ctx);
 }
 
+static void tls_device_resync_tx(struct sock *sk, struct tls_context *tls_ctx,
+				 u32 seq)
+{
+	struct net_device *netdev;
+	struct sk_buff *skb;
+	u8 *rcd_sn;
+
+	skb = tcp_write_queue_tail(sk);
+	if (skb)
+		TCP_SKB_CB(skb)->eor = 1;
+
+	rcd_sn = tls_ctx->tx.rec_seq;
+
+	down_read(&device_offload_lock);
+	netdev = tls_ctx->netdev;
+	if (netdev)
+		netdev->tlsdev_ops->tls_dev_resync(netdev, sk, seq, rcd_sn,
+						   TLS_OFFLOAD_CTX_DIR_TX);
+	up_read(&device_offload_lock);
+
+	clear_bit_unlock(TLS_TX_SYNC_SCHED, &tls_ctx->flags);
+}
+
 static void tls_append_frag(struct tls_record_info *record,
 			    struct page_frag *pfrag,
 			    int size)
@@ -264,6 +287,10 @@ static int tls_push_record(struct sock *sk,
 	list_add_tail(&record->list, &offload_ctx->records_list);
 	spin_unlock_irq(&offload_ctx->lock);
 	offload_ctx->open_record = NULL;
+
+	if (test_bit(TLS_TX_SYNC_SCHED, &ctx->flags))
+		tls_device_resync_tx(sk, ctx, tp->write_seq);
+
 	tls_advance_record_sn(sk, prot, &ctx->tx);
 
 	for (i = 0; i < record->num_frags; i++) {
-- 
2.21.0

