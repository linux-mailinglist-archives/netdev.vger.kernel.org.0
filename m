Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54BC855ED57
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233890AbiF1TBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233559AbiF1TAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:00:34 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8691D1CB07;
        Tue, 28 Jun 2022 12:00:20 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id sb34so27624996ejc.11;
        Tue, 28 Jun 2022 12:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HYd55O2NdGLO2Euqz1Nyab6aWjt/DTgixsVymNAk6zI=;
        b=GSK4pU182c9jv4Pa9k0QjVW35qbkMOQ/h9jCjetCYwu/R3LP0mTfoPowza+903LW5G
         e8fXxUrGqr0gbmnnKjC9xJQCiLrnmGXSLaVcwptfbd/APhuwGXzFVv8CSQ1MlFUpXC0r
         MNfFw64H1qREZflEXEhkKEN3UR1sVd3my9ZZEUWt8K/eNRBRYCkmFQ+9AU7OdtmargIz
         c/wAP+qmwpnj/Fh1Gy3Dy+BX4RZJP2iTfq0evYLdPa6tZyYAkXjkh+5t2zz8+i/XgAdN
         /igFpNVAHcbgwhsP2+QubjUIdYnQyYPVlawovbSZX9xMf8sUrJSRJ6yua3ewfWZwKBRR
         c4Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HYd55O2NdGLO2Euqz1Nyab6aWjt/DTgixsVymNAk6zI=;
        b=ht5Btv4eO9SijPMIEa1+vROHrEQVPHpmMgdDu9+Mvu+uonbR7IQgQckXl5iUfCuH1b
         x6NA02y/yur216u04HwfvLtIobqjVZwYXN5e4GXP9j5SD4a02FxR7qu7H+MKPiORrdkz
         C5YR9KZkGFdXns1deCQoSfJUHV2hcCD2VIoeHCvDKqUqKr7gQVNjk42EB1GyR9YZL4+n
         j05T8uonCcD+ITG7UwfpXhDkOLoW3wh86LONK8g5SNOK53paLzeIgt8QmWhGGV2TQkYF
         VVuY/Kb/keO+1lSRtOW60gIfwBkYXjr09R2h0kAM/Ht72q2lUUMQpuxp7vNwUejdpvWM
         8RxQ==
X-Gm-Message-State: AJIora/0jcaVT5/7y34sRpalafBdv12ZMTgSSRiWJINc5YR8H0Zl+fOU
        pUE7crhxllgOAHILuBT7ZM60C+uydugugg==
X-Google-Smtp-Source: AGRyM1sXQrywrdrTVmgueASf2Qn31JLvNysMxcPp/uHviEe8RykMLE3ipLNyiqZhXRPxIUSKZJiTlg==
X-Received: by 2002:a17:907:94d2:b0:722:e4fa:89f7 with SMTP id dn18-20020a17090794d200b00722e4fa89f7mr18101861ejc.603.1656442818800;
        Tue, 28 Jun 2022 12:00:18 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t21-20020a05640203d500b0043573c59ea0sm9758451edw.90.2022.06.28.12.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 12:00:18 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next v3 22/29] io_uring: account locked pages for non-fixed zc
Date:   Tue, 28 Jun 2022 19:56:44 +0100
Message-Id: <7b68f8a5291bc512a225b5a876384ebd4dcda1dd.1653992701.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1653992701.git.asml.silence@gmail.com>
References: <cover.1653992701.git.asml.silence@gmail.com>
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
 fs/io_uring.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4a1a1d43e9b3..838030477456 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2825,7 +2825,13 @@ static void __io_notif_complete_tw(struct callback_head *cb)
 {
 	struct io_notif *notif = container_of(cb, struct io_notif, task_work);
 	struct io_ring_ctx *ctx = notif->ctx;
+	struct mmpin *mmp = &notif->uarg.mmp;
 
+	if (unlikely(mmp->user)) {
+		atomic_long_sub(mmp->num_pg, &mmp->user->locked_vm);
+		free_uid(mmp->user);
+		mmp->user = NULL;
+	}
 	if (likely(notif->task)) {
 		io_put_task(notif->task, 1);
 		notif->task = NULL;
@@ -6616,6 +6622,7 @@ static int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 	ret = import_single_range(WRITE, zc->buf, zc->len, &iov, &msg.msg_iter);
 	if (unlikely(ret))
 		return ret;
+	mm_account_pinned_pages(&notif->uarg.mmp, zc->len);
 
 	msg_flags = zc->msg_flags | MSG_ZEROCOPY;
 	if (issue_flags & IO_URING_F_NONBLOCK)
-- 
2.36.1

