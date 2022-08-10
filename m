Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2A558EFC9
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 17:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbiHJPx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 11:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232726AbiHJPwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 11:52:10 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59ED360686;
        Wed, 10 Aug 2022 08:51:51 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id s11-20020a1cf20b000000b003a52a0945e8so1194722wmc.1;
        Wed, 10 Aug 2022 08:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=P8aAKAj6QbUGM3qiLbxj6rCIuSDWisCzVUCts73nG7k=;
        b=iw4zMeJIq6Iduj5Ai23kLZLWv6lH2honhKvhFD/8RjX03J6CC6OT3GFZdBOkedBUdt
         n+4sEAA+jY/L/94w0veZ6+BigRGb/z+iiaiJDK2kbDqMnLkYpIKAVeEpBGeRkUhR8ZY4
         3C2zmmMBUj+haew1vR4ZvQFcsNz2n5JD1clVwf0uHdPmnBF3QMz0ffFPSnpU76csdYvx
         WghdcQ+nasGK3chHwCDoPTmwBdCerSaeh8eCSRiiRqlv5NxV5e1DoaVA1cZ7GwqNoWTR
         Iu2g0zXQ4q7bhvEbKDfbxuVUgmKMV7FWlYgxIhokbOIyG0ObnwT0cf/lwdYDKKmbRxeE
         YrCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=P8aAKAj6QbUGM3qiLbxj6rCIuSDWisCzVUCts73nG7k=;
        b=QvOBTC59h5AidkNvLgHwm0uXicB5kDWjDfifkrQuGZHvcHAlxYa2pVqEozHcvcWVK0
         5RKQFESxiGqP+5q7eJiwG/7szw9K0/Jn2ILHpUr20OLHFzPRZkrP75HkwGcUS8FWyscU
         NlE2SMxG+sfdtxoX7PDYKIqWw8hQUOMHn6V74tUxrUNpOQ5wLnvbrBiQavxHvd+lUzpn
         OKmfMkjNE8HytOwBtssE/8E7vUmxEoWUgLJ8kmAnxcbhvL0P8HD2JLdLlloLh6hieDQx
         qv2QyY/IUH7+vCvPbPBLATdEvLJIatDKo1oW0xbvWOyjVypt8hYouWtqG/F0u2TOEN7m
         g9jA==
X-Gm-Message-State: ACgBeo2P6UPpAZNYtaZCVFybX8ftDCLXHDDVig6uA3pgtQhA08nDNhiG
        xs6e9o9BeG6NjqNLyxc3TeynOjLSSGM=
X-Google-Smtp-Source: AA6agR51LI/17gzAJrVldihDliUyILNuNHqftq15rGqHxVJN5cbfccCeChTUV2Xc8UnWpC6KUoJk0Q==
X-Received: by 2002:a1c:f209:0:b0:3a4:f42c:9ffb with SMTP id s9-20020a1cf209000000b003a4f42c9ffbmr2964735wmc.62.1660146709173;
        Wed, 10 Aug 2022 08:51:49 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id ay1-20020a05600c1e0100b003a342933727sm3004519wmb.3.2022.08.10.08.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 08:51:48 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next io_uring 09/11] io_uring/notif: add helper for flushing refs
Date:   Wed, 10 Aug 2022 16:49:17 +0100
Message-Id: <a68ff48da5a52be8f64b058c30d7076fbec41beb.1660124059.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1660124059.git.asml.silence@gmail.com>
References: <cover.1660124059.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper for dropping notification references during flush. It's a
preparation patch, currently it's only one master ref, but we're going
to add ref caching.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/notif.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/io_uring/notif.c b/io_uring/notif.c
index a2ba1e35a59f..5661681b3b44 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -73,6 +73,13 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx,
 	return notif;
 }
 
+static inline bool io_notif_drop_refs(struct io_notif_data *nd)
+{
+	int refs = 1;
+
+	return refcount_sub_and_test(refs, &nd->uarg.refcnt);
+}
+
 void io_notif_slot_flush(struct io_notif_slot *slot)
 	__must_hold(&ctx->uring_lock)
 {
@@ -81,8 +88,7 @@ void io_notif_slot_flush(struct io_notif_slot *slot)
 
 	slot->notif = NULL;
 
-	/* drop slot's master ref */
-	if (refcount_dec_and_test(&nd->uarg.refcnt))
+	if (io_notif_drop_refs(nd))
 		io_notif_complete(notif);
 }
 
@@ -97,13 +103,11 @@ __cold int io_notif_unregister(struct io_ring_ctx *ctx)
 	for (i = 0; i < ctx->nr_notif_slots; i++) {
 		struct io_notif_slot *slot = &ctx->notif_slots[i];
 		struct io_kiocb *notif = slot->notif;
-		struct io_notif_data *nd;
 
 		if (!notif)
 			continue;
-		nd = io_kiocb_to_cmd(notif);
 		slot->notif = NULL;
-		if (!refcount_dec_and_test(&nd->uarg.refcnt))
+		if (!io_notif_drop_refs(io_kiocb_to_cmd(notif)))
 			continue;
 		notif->io_task_work.func = __io_notif_complete_tw;
 		io_req_task_work_add(notif);
-- 
2.37.0

