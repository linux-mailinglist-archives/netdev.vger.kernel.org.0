Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAABCCC66A
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 01:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731444AbfJDXTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 19:19:47 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:34414 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731387AbfJDXTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 19:19:46 -0400
Received: by mail-qk1-f196.google.com with SMTP id q203so7417399qke.1
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 16:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/tJ+bTHMQ8uBV04LGOQPS5HsZFDvp9O+pW0Og490cHY=;
        b=1fK04LJB1WGzJEmFifSsTk/sKdbTSdwo4e0bfygsaGkD3d3xT/qrXU9t4jSA5HlIPl
         0b+m0MuiQGpA9hcvVhJ7CNniAqyW5AkX7wQMPQC0lzbXhEeQp8tmT6XpFGlyix+V/Bxf
         rYyvebkP084UYnR68RHNCfNU5kePmPZPMn4fAIS8HprU4F0vqrAMrToWsGBwbqQx63pW
         9vlPKtRMDsyplguBxU4dFB7TVmfp9nr1K0oNrmVVYew7xNnBvpV5Q1fGHZYoVeN04Vhk
         fa17lE1V2Tca9mpbI0UKlHxZCuGvPPxIDBInHzA6TR/mjLrokYW+phFK7fZdlfhq3P1/
         GqNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/tJ+bTHMQ8uBV04LGOQPS5HsZFDvp9O+pW0Og490cHY=;
        b=fuchy13YsZQP0syxpzwyTBLxEckF16jlucfca/dTwWMShMp9kxRRf4mVedclBMcoTR
         1jiwZnFJwurAwn/7nL3vuMunyvr5HZ2l9a3Um55o8jwVyY6uIdmaPNu17ZP81iWAwF46
         g8KlSCxwS0oYgDn//Beq/Uupq/tiVIzDO+6uLOk7elVf4f3xPCklaZ1VlSRB5k/pNxt+
         zrPJAkUcZ8Rd0El9ZasDG1m5vBkrTDh0YcMPC9pjM8vSCfuXIxcoWtTtCJJLrdb8gIxL
         cO5KTQ+EFNS0c4GZ7to5F0USAa7F6iyLBZRAJ/iSjZ1qp6LIRN/CurkUoOLsqBfu4por
         x86w==
X-Gm-Message-State: APjAAAUnMLpe6rOW0IZ+J+j6zO4DegbgPSbnz92J7MHJppDxONWxkWmM
        zkX4eeM1RQPwpi7EUltj0ljUbw==
X-Google-Smtp-Source: APXvYqwPSsgjx7qoCmaC1Z0uzxcanMAZbuMIywa8n9KmYXBgiicHw1+yXuwjaMmBZTP/vzis9GFKyg==
X-Received: by 2002:a37:66cc:: with SMTP id a195mr11975587qkc.66.1570231185846;
        Fri, 04 Oct 2019 16:19:45 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z46sm4653398qth.62.2019.10.04.16.19.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Oct 2019 16:19:45 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, davejwatson@fb.com, borisp@mellanox.com,
        aviadye@mellanox.com, john.fastabend@gmail.com,
        daniel@iogearbox.net, Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 2/6] net/tls: add device decrypted trace point
Date:   Fri,  4 Oct 2019 16:19:23 -0700
Message-Id: <20191004231927.21134-3-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191004231927.21134-1-jakub.kicinski@netronome.com>
References: <20191004231927.21134-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a tracepoint to the TLS offload's fast path. This tracepoint
can be used to track the decrypted and encrypted status of received
records. Records decrypted by the device should have decrypted set
to 1, records which have neither decrypted nor decrypted set are
partially decrypted, require re-encryption and therefore are most
expensive to deal with.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 net/tls/tls_device.c |  5 +++++
 net/tls/trace.h      | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 9f423caf48e3..5a9a86bf0ee1 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -850,6 +850,7 @@ int tls_device_decrypted(struct sock *sk, struct sk_buff *skb)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_offload_context_rx *ctx = tls_offload_ctx_rx(tls_ctx);
+	struct strp_msg *rxm = strp_msg(skb);
 	int is_decrypted = skb->decrypted;
 	int is_encrypted = !is_decrypted;
 	struct sk_buff *skb_iter;
@@ -860,6 +861,10 @@ int tls_device_decrypted(struct sock *sk, struct sk_buff *skb)
 		is_encrypted &= !skb_iter->decrypted;
 	}
 
+	trace_tls_device_decrypted(sk, tcp_sk(sk)->copied_seq - rxm->full_len,
+				   tls_ctx->rx.rec_seq, rxm->full_len,
+				   is_encrypted, is_decrypted);
+
 	ctx->sw.decrypted |= is_decrypted;
 
 	/* Return immediately if the record is either entirely plaintext or
diff --git a/net/tls/trace.h b/net/tls/trace.h
index 95b6ded2f9b2..9ba5f600ea43 100644
--- a/net/tls/trace.h
+++ b/net/tls/trace.h
@@ -41,6 +41,39 @@ TRACE_EVENT(tls_device_offload_set,
 	)
 );
 
+TRACE_EVENT(tls_device_decrypted,
+
+	TP_PROTO(struct sock *sk, u32 tcp_seq, u8 *rec_no, u32 rec_len,
+		 bool encrypted, bool decrypted),
+
+	TP_ARGS(sk, tcp_seq, rec_no, rec_len, encrypted, decrypted),
+
+	TP_STRUCT__entry(
+		__field(	struct sock *,	sk		)
+		__field(	u64,		rec_no		)
+		__field(	u32,		tcp_seq		)
+		__field(	u32,		rec_len		)
+		__field(	bool,		encrypted	)
+		__field(	bool,		decrypted	)
+	),
+
+	TP_fast_assign(
+		__entry->sk = sk;
+		__entry->rec_no = get_unaligned_be64(rec_no);
+		__entry->tcp_seq = tcp_seq;
+		__entry->rec_len = rec_len;
+		__entry->encrypted = encrypted;
+		__entry->decrypted = decrypted;
+	),
+
+	TP_printk(
+		"sk=%p tcp_seq=%u rec_no=%llu len=%u encrypted=%d decrypted=%d",
+		__entry->sk, __entry->tcp_seq,
+		__entry->rec_no, __entry->rec_len,
+		__entry->encrypted, __entry->decrypted
+	)
+);
+
 TRACE_EVENT(tls_device_rx_resync_send,
 
 	TP_PROTO(struct sock *sk, u32 tcp_seq, u8 *rec_no, int sync_type),
-- 
2.21.0

