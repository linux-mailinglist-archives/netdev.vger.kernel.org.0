Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD7E47C31B
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 16:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239669AbhLUPgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 10:36:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239650AbhLUPgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 10:36:25 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A56C06139E;
        Tue, 21 Dec 2021 07:36:14 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id t18so27641772wrg.11;
        Tue, 21 Dec 2021 07:36:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fhgh/5DOw/NQ7pp9nqN3Rvk8py54Nb1NJlpvArlpW/w=;
        b=UcqqCoyznqHt3YZhbr3UqcsisZ7PlccA6VQzfgZSbgElw5Yiyxx6Gi2DIWnYmtByN4
         rwB2dpUjFdZTEdKqYEL8klHHOjjCl7vM4SB8kaah2eCGyNzEHwMbtymkicYHf2kXkFSs
         RINfzcaU+s7tWz0wifXRAcGRttTSdGh1isgwYlIpEcqZjSgEmpzcJ8bEHyffjjB9FzRa
         SSboWcHoaV+yL3ai0Jx2aDjmitzP1S8pDQTURIjbrsd1YwvGFRYocP1i67sb87mMkV3q
         wY/HoqZsfAIbgwRMi32Y2Tk7bfTtPzirrUPeDGCBO4RGieMd2N1WRtdu9yHzP5Hto6R4
         SHcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fhgh/5DOw/NQ7pp9nqN3Rvk8py54Nb1NJlpvArlpW/w=;
        b=aeqonjmSOD7r323qr3PTX4jGep5VW4e1qJUV2D8iFzYRhHSVs4r2bC/298+yld0FuC
         TUfJGatfemXFUfTSukppAIoMwQqXsIDG/VteW6FY5sDUH6dzDXnaUnjvThpOXS1H3jL0
         FKwmFdRu7mI3rt4lPHUQ/Hw5lBQee1TVV/cSJ63mSoAmLeQ40HGgCx/a0PGbWYMflv9W
         CtUccPyiEv9tQRX6hrG2uzyCFdCMwrfj8OyAk+FKm5SSk1aB4M6p60wOO1yF41yEH5TX
         oOzQoRCCDaG9iDBR6VuvgMjLoq9WWqJtDzCgudwJNPcYt/OJaRNdfqn0EWYsdxgnPomO
         ZXBA==
X-Gm-Message-State: AOAM532u4I8aafGIBFUj8TbCeuVcO/Y47B/xSoP/R4TsSPsRit70LwHu
        Jz8QyqW/GvBRVCbjUevJQWWDpTT+jo0=
X-Google-Smtp-Source: ABdhPJz3jRU4NB59cEZ+kIeeUEHweT4RWY0EBPQ7ToM77nxk+ERLW2k3Wk7nZOsRhWZjuk9HvPpSzQ==
X-Received: by 2002:a05:6000:144a:: with SMTP id v10mr3049303wrx.357.1640100972768;
        Tue, 21 Dec 2021 07:36:12 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.24])
        by smtp.gmail.com with ESMTPSA id z11sm2946019wmf.9.2021.12.21.07.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 07:36:12 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC v2 17/19] io_uring: unclog ctx refs waiting with zc notifiers
Date:   Tue, 21 Dec 2021 15:35:39 +0000
Message-Id: <2c07d8e5cb5dfbd678d5a0bc6fb398aee82b67e4.1640029579.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1640029579.git.asml.silence@gmail.com>
References: <cover.1640029579.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently every instance of struct io_tx_notifier holds a ctx reference,
including ones sitting in caches. So, when we try to quiesce the ring
(e.g. for register) we'd be waiting for refs that nobody can release.
That's worked around in for cancellation.

Don't do ctx references but wait for all notifiers to return into
caches when needed. Even better solution would be to wait for all rsrc
refs. It's also nice to remove an extra pair of percpu_ref_get/put().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5f79178a3f38..8cfa8ea161e4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -453,6 +453,7 @@ struct io_ring_ctx {
 		struct io_mapped_ubuf		*dummy_ubuf;
 		struct io_rsrc_data		*file_data;
 		struct io_rsrc_data		*buf_data;
+		int				nr_tx_ctx;
 
 		struct delayed_work		rsrc_put_work;
 		struct llist_head		rsrc_put_llist;
@@ -1982,7 +1983,6 @@ static void io_zc_tx_work_callback(struct work_struct *work)
 	io_cqring_ev_posted(ctx);
 
 	percpu_ref_put(rsrc_refs);
-	percpu_ref_put(&ctx->refs);
 }
 
 static void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
@@ -2028,6 +2028,7 @@ static void io_notifier_free_cached(struct io_ring_ctx *ctx)
 					    struct io_tx_notifier, cache_node);
 		list_del(&notifier->cache_node);
 		kfree(notifier);
+		ctx->nr_tx_ctx--;
 	}
 }
 
@@ -2060,6 +2061,7 @@ static struct io_tx_notifier *io_alloc_tx_notifier(struct io_ring_ctx *ctx,
 		notifier = kmalloc(sizeof(*notifier), gfp_flags);
 		if (!notifier)
 			return NULL;
+		ctx->nr_tx_ctx++;
 		uarg = &notifier->uarg;
 		uarg->ctx = ctx;
 		uarg->flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
@@ -2072,7 +2074,6 @@ static struct io_tx_notifier *io_alloc_tx_notifier(struct io_ring_ctx *ctx,
 	io_set_rsrc_node(&notifier->fixed_rsrc_refs, ctx);
 
 	refcount_set(&notifier->uarg.refcnt, 1);
-	percpu_ref_get(&ctx->refs);
 	return notifier;
 }
 
@@ -9785,7 +9786,6 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 #endif
 	WARN_ON_ONCE(!list_empty(&ctx->ltimeout_list));
 
-	io_notifier_free_cached(ctx);
 	io_sqe_tx_ctx_unregister(ctx);
 	io_mem_free(ctx->rings);
 	io_mem_free(ctx->sq_sqes);
@@ -9946,6 +9946,19 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 	spin_lock(&ctx->completion_lock);
 	spin_unlock(&ctx->completion_lock);
 
+	while (1) {
+		int nr;
+
+		mutex_lock(&ctx->uring_lock);
+		io_notifier_free_cached(ctx);
+		nr = ctx->nr_tx_ctx;
+		mutex_unlock(&ctx->uring_lock);
+
+		if (!nr)
+			break;
+		schedule_timeout(interval);
+	}
+
 	io_ring_ctx_free(ctx);
 }
 
-- 
2.34.1

