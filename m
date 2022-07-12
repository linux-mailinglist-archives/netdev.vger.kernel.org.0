Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A01DA57281C
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 22:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234336AbiGLUzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 16:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234107AbiGLUyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 16:54:37 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF616387;
        Tue, 12 Jul 2022 13:53:34 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id b26so12831204wrc.2;
        Tue, 12 Jul 2022 13:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u1S2AivxVWXdd+4RPf9USNps4dL740oJjGqqaX0bN80=;
        b=AfNA+WmPd/ODqSuz0pd5DC7lj+/T4z/EeKuS84uKE9jZwUFV2vy/bvq29V+qjT+VSy
         UrlX0Chn/ehVo1QPRzLxUFKXsFnKZgwz0rxVxURd3WuQSiATfDYJM5knQVQ40MeN/+mF
         w2MShjYqFQp4Xn3dqjJZIOi+37r+gQ+u5Ehtjk57x4GGczaUUuZXRR4v0ifQ63d8Ke0q
         AFY/uXn12dRps575KClC664t0nwgVTUbAE5e3bH27BO0u3/TQLLn8davgOCSWrqKanfj
         YoWpS6iM4d1qT+yogHZNqMQcH76ALBGbgrl1L61ekH8JtMlJmUQaY+hupfiUSkIg5U7l
         KeZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u1S2AivxVWXdd+4RPf9USNps4dL740oJjGqqaX0bN80=;
        b=cuCnOPl9frvjoBz5jy49LySVDwo6jUITEPPSgiZlszL+wnnb1WnNAlm/d/r1dcIrV+
         ZCtDYaAH5iMcitj63H82nss3IqWoiinDgPrSmjie+iWLOGVGu0mun6MAo0cAXaQtFqCf
         HUQVGsy5iBeo3j1Td/bZ7CL6aOXfOabENecQco02K+h4pVLL7LN7Xmg4lWgSj5W/7kHx
         yhf3+69AVkPVqdmpmzLlJkuHk7/10OfIqilj4Jw4yEebjHjVVSjxoQNWqDdVSP3D0okH
         1gnMbg64YYkNo2EB9ToWloSe+GdVYjLC/r5ZwCr9mBEIJ9xCcybJzbVeblAs3s5GWoIr
         2TNg==
X-Gm-Message-State: AJIora/iimZQfKBgGjPuz8xklw9aQCtk9/xyqisjx4O3jCVe5l0cySoW
        e6FA7i6QCNB/Jcs+aowOpvRxESf50Rw=
X-Google-Smtp-Source: AGRyM1uE7Cqktcst31MQ9kgPT70aVpCSQOze3Uyp1WAJPWaljaRlxbLFnmVVs8pXxGoWrp3G0OSJng==
X-Received: by 2002:a5d:4c91:0:b0:21d:8293:66dc with SMTP id z17-20020a5d4c91000000b0021d829366dcmr25537183wrs.30.1657659211786;
        Tue, 12 Jul 2022 13:53:31 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id c14-20020a7bc00e000000b003a044fe7fe7sm89833wmb.9.2022.07.12.13.53.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 13:53:31 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v5 20/27] io_uring: account locked pages for non-fixed zc
Date:   Tue, 12 Jul 2022 21:52:44 +0100
Message-Id: <19b6e3975440f59f1f6199c7ee7acf977b4eecdc.1657643355.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1657643355.git.asml.silence@gmail.com>
References: <cover.1657643355.git.asml.silence@gmail.com>
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

Fixed buffers are RLIMIT_MEMLOCK accounted, however it doesn't cover iovec
based zerocopy sends. Do the accounting on the io_uring side.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c   | 1 +
 io_uring/notif.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/io_uring/net.c b/io_uring/net.c
index 399267e8f1ef..69273d4f4ef0 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -724,6 +724,7 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 	ret = import_single_range(WRITE, zc->buf, zc->len, &iov, &msg.msg_iter);
 	if (unlikely(ret))
 		return ret;
+	mm_account_pinned_pages(&notif->uarg.mmp, zc->len);
 
 	msg_flags = zc->msg_flags | MSG_ZEROCOPY;
 	if (issue_flags & IO_URING_F_NONBLOCK)
diff --git a/io_uring/notif.c b/io_uring/notif.c
index e6d98dc208c7..c5179e5c1cd6 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -14,7 +14,13 @@ static void __io_notif_complete_tw(struct callback_head *cb)
 	struct io_notif *notif = container_of(cb, struct io_notif, task_work);
 	struct io_rsrc_node *rsrc_node = notif->rsrc_node;
 	struct io_ring_ctx *ctx = notif->ctx;
+	struct mmpin *mmp = &notif->uarg.mmp;
 
+	if (mmp->user) {
+		atomic_long_sub(mmp->num_pg, &mmp->user->locked_vm);
+		free_uid(mmp->user);
+		mmp->user = NULL;
+	}
 	if (likely(notif->task)) {
 		io_put_task(notif->task, 1);
 		notif->task = NULL;
-- 
2.37.0

