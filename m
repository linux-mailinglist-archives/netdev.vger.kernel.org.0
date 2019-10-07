Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02CFACDAE1
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 06:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbfJGEKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 00:10:13 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46698 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727176AbfJGEKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 00:10:11 -0400
Received: by mail-qt1-f195.google.com with SMTP id u22so17299305qtq.13
        for <netdev@vger.kernel.org>; Sun, 06 Oct 2019 21:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O8sQSuaBqB1g2W6gxchTYMjPZCpW+EEdy7/D/Kgx4Nk=;
        b=JZQeXZEMDxMxfTPWCjXuzKJ4XeA/N51XqFjjbmY+Su1xXsh06Hx/8YufP+up/Fh1wa
         QlfW1tjxjp5pjPaejyuaXpD1U64ldKyBC+uN4CwBZiel0KpgMbF5bcdWQIdlhp0XoXRb
         UtbiMTwotClKj99or4nN+GPfMWBHbH6He2shIaGKdaQYsy0kRl47wgHO+6HuhpmtgD7h
         LOrB0mz4GwC5c6dUjHp6Ucey2pxQNKsSEhIlR6AzpWT1i55Z2Fh8MFc3eurh0LhBCdDw
         iW4H5gy3afEDnO4c0GD/75NxPI0CPogiLWmdq5DngJ+zJ7ObVGA4O8JpC9GIfs7N+Idv
         mxiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O8sQSuaBqB1g2W6gxchTYMjPZCpW+EEdy7/D/Kgx4Nk=;
        b=c+tsaJbagPKaI0ZObCHcsldzTQp/Jg/xxPxNciNWgm0PiDzqMQs/eWaFaYAbjnaDaU
         W0RNMDbZbHv5Rx3P1gRRXmAHEEloXHipBkGoWVH3G1RlY6KZnQZ3bLlndiFY3WHJSavi
         dU73PmImaDWiNZmwf6xvziRVUXXdWeBJNYHYG9+FOemHWwxdcp4BgcAyZkIJv4JajujD
         P+XF21+KcTTgEIpxcLqMglcd8gN3iZhHsTsShSnYnHXX1t+XUiT222ZRGKM3qsAbxY7e
         dsRxcPmuhDI0TCHBVn9wQ7WIndCpETczGqc39lHIv4TUrF0zBz8r0ei370xWJuODYqzg
         H9uQ==
X-Gm-Message-State: APjAAAXO/pz0xIF/tTi/eyxWA8v3frqq+pj0Mwb/J/5HQQheI5aKAJav
        zs3r5BStbxuDp+3zedQRb7tFeMpEVqQ=
X-Google-Smtp-Source: APXvYqxF7t7jhtKsPGghbR1E/SSMP5mvM0zdGx6SSYhZlhNYS1r3sfX7c07uokT3sc550p4wSSNc6A==
X-Received: by 2002:a0c:f9c3:: with SMTP id j3mr24376217qvo.193.1570421409779;
        Sun, 06 Oct 2019 21:10:09 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y22sm3796058qka.59.2019.10.06.21.10.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Oct 2019 21:10:09 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-next 6/6] net/tls: store decrypted on a single bit
Date:   Sun,  6 Oct 2019 21:09:32 -0700
Message-Id: <20191007040932.26395-7-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191007040932.26395-1-jakub.kicinski@netronome.com>
References: <20191007040932.26395-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use a single bit instead of boolean to remember if packet
was already decrypted.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 include/net/tls.h | 2 +-
 net/tls/tls_sw.c  | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 97eae7271a67..41265e542e71 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -153,7 +153,7 @@ struct tls_sw_context_rx {
 	struct sk_buff *recv_pkt;
 	u8 control;
 	u8 async_capable:1;
-	bool decrypted;
+	u8 decrypted:1;
 	atomic_t decrypt_pending;
 	bool async_notify;
 };
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index c006b587a7db..de7561d4cfa5 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1523,7 +1523,7 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 		rxm->offset += prot->prepend_size;
 		rxm->full_len -= prot->overhead_size;
 		tls_advance_record_sn(sk, prot, &tls_ctx->rx);
-		ctx->decrypted = true;
+		ctx->decrypted = 1;
 		ctx->saved_data_ready(sk);
 	} else {
 		*zc = false;
@@ -1933,7 +1933,7 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 			tls_err_abort(sk, EBADMSG);
 			goto splice_read_end;
 		}
-		ctx->decrypted = true;
+		ctx->decrypted = 1;
 	}
 	rxm = strp_msg(skb);
 
@@ -2034,7 +2034,7 @@ static void tls_queue(struct strparser *strp, struct sk_buff *skb)
 	struct tls_context *tls_ctx = tls_get_ctx(strp->sk);
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
 
-	ctx->decrypted = false;
+	ctx->decrypted = 0;
 
 	ctx->recv_pkt = skb;
 	strp_pause(strp);
-- 
2.21.0

