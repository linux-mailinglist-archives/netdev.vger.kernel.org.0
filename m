Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8BE324E575
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 06:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgHVElV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 00:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbgHVElQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 00:41:16 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC5EC061573
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 21:41:16 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id d188so2075921pfd.2
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 21:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M/qL65ndDLrsHnRh+/TqHc+C7KhlsaYrPMWGe6FW5E8=;
        b=GS5Ua6KcxJ2pfNEbGUP9hyN529T1xnuOcSb9laO+qmemKUSQApU53CANpBKS+sR7b4
         Y5p5PbbMMFjn+41y2nBWuGsWIm7a4BTelc2SimJ6M8X/IsnbNa1VXy2a6frV3LD6OL7Q
         G1wk+xjX/pgQB8HxC9N5C6GfnHDJaEy5LG/jfRIOLOB8Ych9dpbZ2QNnDBYoSVAn6ZIE
         ZfYczgNi8rxbB1rRQ4UhKQ7COxvJF4FwHhDQphSYSKiA5cIAIKILikb+9Dn/RqrAqCRP
         crB1LhoOzB1jf+wS/Em9WClYCrth7S4DaEpTPmBROnLjKeQNR0jxsXJIL8WeTnGT4XGv
         ATXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M/qL65ndDLrsHnRh+/TqHc+C7KhlsaYrPMWGe6FW5E8=;
        b=L2cc7HNs2IWvDJ65enTxyp1PDr7tycZBNt113Z2T/gI+fnpXKdRGZrq6W8Txzwvmq+
         Bz7loycsF56dctOnpPcqStyQfLPTN78/qMqRXmZgybxHeVGhLl+sRLwOLatn3BAaSCMc
         PIUBvb9x0gPBH1QNJD+W/ocVb0PHP9dlD1/GLm8QEQAU+QSM6hH60w8hfDpBXtPR0zL7
         yYYLg+6bBwVKq/mva11MD3uit9ccfawdc9htjRYmGVgN0Sj44JKbl52Y0IYZXeEMSkjA
         gLs9xJkwx6iu4ihE7Jw6OPKYgUjSAplRBX322YzDH+lPfWagpBIw2r4/JnwrCrBoKrsr
         ZqTQ==
X-Gm-Message-State: AOAM5311axCRGyaKdCLAyJwN/ff4XepbVqvCoGAXDRuxqf4CWVrsrju7
        Hy8c+WLWjHdUZYM7lbdjs3Q=
X-Google-Smtp-Source: ABdhPJy+wsGE8dI52pLyPrRFkNApUHdQDvvYSAdXyX7sRO0wfLU/vw5dtL2K7Nb7+AM8anJFOs8/nw==
X-Received: by 2002:aa7:9301:: with SMTP id 1mr4973620pfj.305.1598071276126;
        Fri, 21 Aug 2020 21:41:16 -0700 (PDT)
Received: from lukehsiao.c.googlers.com.com (40.156.233.35.bc.googleusercontent.com. [35.233.156.40])
        by smtp.gmail.com with ESMTPSA id u29sm4338997pfl.180.2020.08.21.21.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 21:41:15 -0700 (PDT)
From:   Luke Hsiao <luke.w.hsiao@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Jakub Kicinski <kuba@kernel.org>,
        Luke Hsiao <lukehsiao@google.com>,
        Arjun Roy <arjunroy@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next v3 2/2] io_uring: ignore POLLIN for recvmsg on MSG_ERRQUEUE
Date:   Fri, 21 Aug 2020 21:41:05 -0700
Message-Id: <20200822044105.3097613-2-luke.w.hsiao@gmail.com>
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
In-Reply-To: <20200822044105.3097613-1-luke.w.hsiao@gmail.com>
References: <0bc6cc65-e764-6fe0-9b0a-431015835770@kernel.dk>
 <20200822044105.3097613-1-luke.w.hsiao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luke Hsiao <lukehsiao@google.com>

Currently, io_uring's recvmsg subscribes to both POLLERR and POLLIN. In
the context of TCP tx zero-copy, this is inefficient since we are only
reading the error queue and not using recvmsg to read POLLIN responses.

This patch was tested by using a simple sending program to call recvmsg
using io_uring with MSG_ERRQUEUE set and verifying with printks that the
POLLIN is correctly unset when the msg flags are MSG_ERRQUEUE.

Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Luke Hsiao <lukehsiao@google.com>
---
 fs/io_uring.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index dc506b75659c..1aa2191ea683 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4932,6 +4932,12 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 		mask |= POLLIN | POLLRDNORM;
 	if (def->pollout)
 		mask |= POLLOUT | POLLWRNORM;
+
+	/* If reading from MSG_ERRQUEUE using recvmsg, ignore POLLIN */
+	if ((req->opcode == IORING_OP_RECVMSG) &&
+	    (req->sr_msg.msg_flags & MSG_ERRQUEUE))
+		mask &= ~POLLIN;
+
 	mask |= POLLERR | POLLPRI;
 
 	ipt.pt._qproc = io_async_queue_proc;
-- 
2.28.0.297.g1956fa8f8d-goog

