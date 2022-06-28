Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4A5055ED6C
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235203AbiF1TBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233575AbiF1TAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:00:36 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA2723BD9;
        Tue, 28 Jun 2022 12:00:25 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id ay16so27701169ejb.6;
        Tue, 28 Jun 2022 12:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rYlp82dDDlUB3NIHr9+8KFuE4D4YHforTbjmj6Zkq4M=;
        b=DinE7A7aMO8rULcksnlePYaSwy3tyz13Yr9HSDwiyHc2ghZKBgOmYamaR75K9g2kbk
         YS3n58g+VLyGWWdI3xAmR8HUoQZh9eX48ExLBvAiOOlWqkzcTGyZ70lF5AV2ZwJXQ+Oa
         d1LTsmZ+DsIoiAXfVpOCUK+wBs5FmOeFbUy2b3Pck8cNV+Xe9QZ1hSsdP//84K73kKqh
         vEoYDR8jj2wUzjgne6ZUG69Pzc4JiIbGeODPyOXn8+VykGgaDfQQXUsZsUqZi5zxoTjy
         TUW+Wpm7XKNxcATFkTrHgeKXuSGoCGN+0Ht6H8Ho017Ho3yxVOL+yNh0dpODi7Xugw9i
         m43Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rYlp82dDDlUB3NIHr9+8KFuE4D4YHforTbjmj6Zkq4M=;
        b=BoRp+mijVm4phJcM1YG6jAyWqorCER+tfpl3Gb5xRvF/5Uh9JDB+I6PJwLPQtTxPvw
         VGpGwPLexrpzqqw7tJ34xQ0KGllF2sIcQyTUEZ1sGC+yjy/TSBVekzUUqnwaNkn0TRhY
         A/+3vItvlx21nEd1RIPh0eojy1z8Rx56CFi8QikJ82DT9x4BTEuVKCCn91ynTYSwT3I1
         gC6DDd13ymIa4vtf/bu1aNjRdjAd9+2VORjRPToidWkT1Zgfumbb9F+91DIQi++bUl3A
         AZhO0ogKaggNQlWbJdzPfGVXFJwVSou5RDlvk01rikV2MEzXk21E4cyfG1dKNYewCUuN
         vMqA==
X-Gm-Message-State: AJIora/fkGp2lhLbvXPdFJawkU++7AVxhhbCTyT/Xcoa8cTQxRgdemGH
        iuM6k5e36KJ60fSeA9Lldh9xZC121f4vlA==
X-Google-Smtp-Source: AGRyM1v82aE4czkPFmsuPHNjhn2RXCbSE0+RsfeTGfN5SBS2a9urNY+wUkA/ITbOS9Tu9sb7giNJKQ==
X-Received: by 2002:a17:907:7288:b0:712:174:8745 with SMTP id dt8-20020a170907728800b0071201748745mr19855681ejc.268.1656442824834;
        Tue, 28 Jun 2022 12:00:24 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t21-20020a05640203d500b0043573c59ea0sm9758451edw.90.2022.06.28.12.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 12:00:24 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next v3 27/29] io_uring: allow to override zc tag on flush
Date:   Tue, 28 Jun 2022 19:56:49 +0100
Message-Id: <011c5487e38ceb5700351ef60d49eedb431f22e0.1653992701.git.asml.silence@gmail.com>
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

Add a new sendzc flag, IORING_SENDZC_COPY_TAG. When set and the request
flushing a notification, it'll set the notification tag to
sqe->user_data. This adds a bit more flexibility allowing to specify
notification tags on per-request basis.

One use cases is combining the new flag with IOSQE_CQE_SKIP_SUCCESS,
so either the request fails and we expect an CQE with a failure and no
notification, or it succedees, then there will be no request completion
but only a zc notification with an overriden tag. In other words, in the
described scheme it posts only one CQE with user_data set to the current
requests sqe->user_data.

note 1: the flat has no effect if nothing is flushed, e.g. there was
no IORING_SENDZC_FLUSH or the request failed.

note 2: copying sqe->user_data may be not ideal, but we don't have
extra space in SQE to keep a second tag/user_data.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 9 +++++++--
 include/uapi/linux/io_uring.h | 1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f5fe2ab5622a..08c98a4d9bd2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6581,7 +6581,8 @@ static int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
-#define IO_SENDZC_VALID_FLAGS (IORING_SENDZC_FIXED_BUF|IORING_SENDZC_FLUSH)
+#define IO_SENDZC_VALID_FLAGS (IORING_SENDZC_FIXED_BUF | IORING_SENDZC_FLUSH | \
+			       IORING_SENDZC_OVERRIDE_TAG)
 
 static int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
@@ -6686,7 +6687,11 @@ static int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 	ret = sock_sendmsg(sock, &msg);
 
 	if (likely(ret >= min_ret)) {
-		if (req->msgzc.zc_flags & IORING_SENDZC_FLUSH)
+		unsigned zc_flags = req->msgzc.zc_flags;
+
+		if (zc_flags & IORING_SENDZC_OVERRIDE_TAG)
+			notif->tag = req->cqe.user_data;
+		if (zc_flags & IORING_SENDZC_FLUSH)
 			io_notif_slot_flush_submit(notif_slot, 0);
 	} else {
 		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 7d77d90a5f8a..7533387f25d3 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -280,6 +280,7 @@ enum {
 enum {
 	IORING_SENDZC_FIXED_BUF		= (1U << 0),
 	IORING_SENDZC_FLUSH		= (1U << 1),
+	IORING_SENDZC_OVERRIDE_TAG	= (1U << 2),
 };
 
 /*
-- 
2.36.1

