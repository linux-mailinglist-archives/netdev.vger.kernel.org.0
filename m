Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7A547C31A
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 16:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239786AbhLUPgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 10:36:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239671AbhLUPgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 10:36:25 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F8D1C061353;
        Tue, 21 Dec 2021 07:36:16 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id d198-20020a1c1dcf000000b0034569cdd2a2so2338538wmd.5;
        Tue, 21 Dec 2021 07:36:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ndxoRy4rGGaCkWxXQFnZHmFgZYqK7OXKTJYFtStJ0X4=;
        b=KYRRTZQRKO3Y3JBA4O0LbLv5vgp/h1JWUgTfXKTwSG5t+df/tUxIo2Hl5cs00Vd6Kq
         3vkjTR/O5tnAKXLzlzHvz5ZurykhzZma1H/5pr0ad5v0L3gkOWiLgdjNEkySeF9DBg6F
         Kvnf7zFg+SoJRhCORm9b3gaqbmn0hTU/h0n8/GHm5VXT2wO+6/cM5+3rROQXaIVAyWRl
         XlYb0x4uu696zld0qfsyGO7LyYZI1scYapoZi/e7D5S0H5oe7ustsEv/r3JWek9l9xJ+
         auHFApXJ9A1OVk/8u6OI9O59NmoVYtuEjyTYn7RHgjPTWFUMB1ualFu06G0PhosXFZnT
         2NzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ndxoRy4rGGaCkWxXQFnZHmFgZYqK7OXKTJYFtStJ0X4=;
        b=M3FvgIQLdrUfi3znnq+r7ezsyhFNscUXxUVd2erfCEi46L7aUiMx0xX23B0auXyuA3
         N9XummMi6ckVBL7qYo5vJL30dkHFt25tRUusnmcHX2vOtuo2+LYPdZ/4dR72g0oXWcuz
         dXA4K2BH7tRAT0lx5mbbgKUVSTQxhP/4hnRML6xQwfhiMMkDzj3rwCASoQH3ABY2H/LT
         rBKym4K93khli69FXkcEfmBMoueYHcHprZ5HFIE6dweUW+dBzq09hzWAmC32sBslBlIt
         AEldSw3rKnYDys4Ux87gMlts9ze5mh033/OmtL14A33hDnHdMTBTcRWxz5oOyvvYXCQ7
         Vhtg==
X-Gm-Message-State: AOAM530X8qMJcSChg3V8ta/U3MU5SzsWIzLra5HWOiXaSLIf/mZiFrDc
        oeyWBCpzhfceIyKRa3M0dlki70l+UkA=
X-Google-Smtp-Source: ABdhPJykTPG64SPTcjahxd/ZwDRSocqmGfaSsEB6maQNdzhCIsTNh8cSQMkgjYwG1D/Z1SdA/EaBdA==
X-Received: by 2002:a7b:ce83:: with SMTP id q3mr3217705wmj.37.1640100975038;
        Tue, 21 Dec 2021 07:36:15 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.24])
        by smtp.gmail.com with ESMTPSA id z11sm2946019wmf.9.2021.12.21.07.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 07:36:14 -0800 (PST)
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
Subject: [RFC v2 19/19] io_uring: optimise task referencing by notifiers
Date:   Tue, 21 Dec 2021 15:35:41 +0000
Message-Id: <465e422a249a5eaad413a6488568a03a2160c066.1640029579.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1640029579.git.asml.silence@gmail.com>
References: <cover.1640029579.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use io_put_task()/etc. infra holding task references for notifiers, so
we can get rid of atomics there.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ee496b463462..0eadf4ee5402 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2008,7 +2008,7 @@ static void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
 	if (unlikely(!notifier->task))
 		goto fallback;
 
-	put_task_struct(notifier->task);
+	io_put_task(notifier->task, 1);
 	notifier->task = NULL;
 
 	if (!in_interrupt()) {
@@ -2034,7 +2034,8 @@ static inline void __io_tx_kill_notification(struct io_tx_ctx *tx_ctx)
 
 static inline void io_tx_kill_notification(struct io_tx_ctx *tx_ctx)
 {
-	tx_ctx->notifier->task = get_task_struct(current);
+	tx_ctx->notifier->task = current;
+	io_get_task_refs(1);
 	__io_tx_kill_notification(tx_ctx);
 }
 
-- 
2.34.1

