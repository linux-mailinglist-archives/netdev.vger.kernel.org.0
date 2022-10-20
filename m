Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE3A4605BD0
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 12:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiJTKFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 06:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiJTKFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 06:05:00 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C04CAE57;
        Thu, 20 Oct 2022 03:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=5NSN++to8O5JXIx9MTVqq5SRGq9tFXAy7MH6RVkYjSU=; b=tL4DqW8SjwW4XAywJDFz3OVoV4
        sqYASbpDNWrK7AEOSlY1qSkFgIIguiTpZFziVi5mk699oF8n+lwFbXt/uKLkrfdwjfj49GeO8sp6c
        Y0p3FvImzjf92Lwkk/gq6ag9sMw7OuwpGedixLn/j/BZT4JBmwnUNoXYuCa2zagcJCr7mI6PkjJFB
        3wr3O4AIcFA31NJtyZzgncRAKYXEJEQPUt0guBU5krqzCf/4RJkR3PGQfe1Fr7TFXOLWBwYlwscLQ
        0irdQ6WsJf7AFnJGtwAGpGpcawSKFPay/ZBYm8lzoCRp2RhPtAnwYe1UVgLM9Qpe6CBKDr0L4jLC3
        OrnSxrdBxaiGz41p9TVVYLR5zZpL0jApu8Ce9/TlEINaZ3GEumbCsheFWzZyRwUqk30oGF9jim0ML
        xp8D95PSDYZd+eyBeAtvETS7na88Hqm6Kos3L6JLrJkujsiqHT4rKbXOeFIjtSm1Pb9+wy3dqj09R
        w/1usLSlNxZwe7g4Rxvd/aNi;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1olSQ3-004znD-HY; Thu, 20 Oct 2022 10:04:55 +0000
Message-ID: <acad81e4-c2ef-59cc-5f0c-33b99082d270@samba.org>
Date:   Thu, 20 Oct 2022 12:04:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US, de-DE
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Dylan Yudaken <dylany@fb.com>
References: <4385ba84-55dd-6b08-0ca7-6b4a43f9d9a2@samba.org>
 <6f0a9137-2d2b-7294-f59f-0fcf9cdfc72d@gmail.com>
 <4bbf6bc1-ee4b-8758-7860-a06f57f35d14@samba.org>
 <cd87b6d0-a6d6-8f24-1af4-4b8845aa669c@gmail.com>
 <df47dbd0-75e4-5f39-58ad-ec28e50d0b9c@samba.org>
 <fb6a7599-8a9b-15e5-9b64-6cd9d01c6ff4@gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: IORING_SEND_NOTIF_REPORT_USAGE (was Re: IORING_CQE_F_COPIED)
In-Reply-To: <fb6a7599-8a9b-15e5-9b64-6cd9d01c6ff4@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pavel,

> Yep, sth like that should do, but let's guard against
> spurious net_zcopy_put() just in case.
> 
> used = false;
> copied = false;
> 
> callback(skb, success, ubuf) {
>      if (skb)
>          used = true;
>      if (!success)
>          copied = true;
> }
> complete() {
>      if (!used || copied)
>          set_flag(IORING_CQE_F_COPIED);
> }
> 
>> And __io_notif_complete_tw still needs:
>>
>>          if (!nd->zero_copied)
>>                  notif->cqe.flags |= IORING_CQE_F_COPIED;
> 
> Which can be shoved in a custom callback
> 

Ok, got the idea.

> I'm more concerned about future changes around it, but there won't
> be extra ifs.
> 
> #define COMMON_FLAGS (RECVSEND_FIRST_POLL|...)
> #define ALL_FLAGS (COMMON_FLAGS|RECVSEND_PROBE)
> 
> if (flags & ~COMMON_FLAGS) {
>      if (flags & ~ALL_FLAGS)
>          return err;
>      if (flags & RECVSEND_PROBE)
>          set_callback(notif);
> }

So far I came up with a IORING_SEND_NOTIF_REPORT_USAGE opt-in flag
and the reporting is done in cqe.res with IORING_NOTIF_USAGE_ZC_USED (0x00000001)
and/or IORING_NOTIF_USAGE_ZC_COPIED (0x8000000). So the caller is also
able to notice that some parts were able to use zero copy, while other
fragments were copied.

I haven't tested it yet, but I want to post it early...

What do you think?

metze

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index ab7458033ee3..751fc4eff8d1 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -296,10 +296,28 @@ enum io_uring_op {
   *
   * IORING_RECVSEND_FIXED_BUF	Use registered buffers, the index is stored in
   *				the buf_index field.
+ *
+ * IORING_SEND_NOTIF_REPORT_USAGE
+ *				If SEND[MSG]_ZC should report
+ *				the zerocopy usage in cqe.res
+ *				for the IORING_CQE_F_NOTIF cqe.
+ *				IORING_NOTIF_USAGE_ZC_USED if zero copy was used
+ *				(at least partially).
+ *				IORING_NOTIF_USAGE_ZC_COPIED if data was copied
+ *				(at least partially).
   */
  #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
  #define IORING_RECV_MULTISHOT		(1U << 1)
  #define IORING_RECVSEND_FIXED_BUF	(1U << 2)
+#define IORING_SEND_NOTIF_REPORT_USAGE	(1U << 3)
+
+/*
+ * cqe.res for IORING_CQE_F_NOTIF if
+ * IORING_SEND_NOTIF_REPORT_USAGE was requested
+ */
+#define IORING_NOTIF_USAGE_ZC_USED	(1U << 0)
+#define IORING_NOTIF_USAGE_ZC_COPIED	(1U << 31)
+

  /*
   * accept flags stored in sqe->ioprio
diff --git a/io_uring/net.c b/io_uring/net.c
index 735eec545115..a79d7d349e19 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -946,9 +946,11 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)

  	zc->flags = READ_ONCE(sqe->ioprio);
  	if (zc->flags & ~(IORING_RECVSEND_POLL_FIRST |
-			  IORING_RECVSEND_FIXED_BUF))
+			  IORING_RECVSEND_FIXED_BUF |
+			  IORING_SEND_NOTIF_REPORT_USAGE))
  		return -EINVAL;
-	notif = zc->notif = io_alloc_notif(ctx);
+	notif = zc->notif = io_alloc_notif(ctx,
+					   zc->flags & IORING_SEND_NOTIF_REPORT_USAGE);
  	if (!notif)
  		return -ENOMEM;
  	notif->cqe.user_data = req->cqe.user_data;
diff --git a/io_uring/notif.c b/io_uring/notif.c
index e37c6569d82e..3844e3c8ad7e 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -3,13 +3,14 @@
  #include <linux/file.h>
  #include <linux/slab.h>
  #include <linux/net.h>
+#include <linux/errqueue.h>
  #include <linux/io_uring.h>

  #include "io_uring.h"
  #include "notif.h"
  #include "rsrc.h"

-static void __io_notif_complete_tw(struct io_kiocb *notif, bool *locked)
+static inline void __io_notif_complete_tw(struct io_kiocb *notif, bool *locked)
  {
  	struct io_notif_data *nd = io_notif_to_data(notif);
  	struct io_ring_ctx *ctx = notif->ctx;
@@ -21,20 +22,46 @@ static void __io_notif_complete_tw(struct io_kiocb *notif, bool *locked)
  	io_req_task_complete(notif, locked);
  }

-static void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
-					  struct ubuf_info *uarg,
-					  bool success)
+static inline void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
+						 struct ubuf_info *uarg,
+						 bool success)
  {
  	struct io_notif_data *nd = container_of(uarg, struct io_notif_data, uarg);
  	struct io_kiocb *notif = cmd_to_io_kiocb(nd);

  	if (refcount_dec_and_test(&uarg->refcnt)) {
-		notif->io_task_work.func = __io_notif_complete_tw;
  		io_req_task_work_add(notif);
  	}
  }

-struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
+static void __io_notif_complete_tw_report_usage(struct io_kiocb *notif, bool *locked)
+{
+	struct io_notif_data *nd = io_notif_to_data(notif);
+
+	if (likely(nd->zc_used))
+		notif->cqe.res |= IORING_NOTIF_USAGE_ZC_USED;
+
+	if (unlikely(nd->zc_copied))
+		notif->cqe.res |= IORING_NOTIF_USAGE_ZC_COPIED;
+
+	__io_notif_complete_tw(notif, locked);
+}
+
+static void io_uring_tx_zerocopy_callback_report_usage(struct sk_buff *skb,
+							struct ubuf_info *uarg,
+							bool success)
+{
+	struct io_notif_data *nd = container_of(uarg, struct io_notif_data, uarg);
+
+	if (success && !nd->zc_used && skb)
+		nd->zc_used = true;
+	else if (unlikely(!success && !nd->zc_copied))
+		nd->zc_copied = true;
+
+	io_uring_tx_zerocopy_callback(skb, uarg, success);
+}
+
+struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx, bool report_usage)
  	__must_hold(&ctx->uring_lock)
  {
  	struct io_kiocb *notif;
@@ -54,7 +81,14 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
  	nd = io_notif_to_data(notif);
  	nd->account_pages = 0;
  	nd->uarg.flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
-	nd->uarg.callback = io_uring_tx_zerocopy_callback;
+	if (report_usage) {
+		nd->zc_used = nd->zc_copied = false;
+		nd->uarg.callback = io_uring_tx_zerocopy_callback_report_usage;
+		notif->io_task_work.func = __io_notif_complete_tw_report_usage;
+	} else {
+		nd->uarg.callback = io_uring_tx_zerocopy_callback;
+		notif->io_task_work.func = __io_notif_complete_tw;
+	}
  	refcount_set(&nd->uarg.refcnt, 1);
  	return notif;
  }
@@ -66,7 +100,6 @@ void io_notif_flush(struct io_kiocb *notif)

  	/* drop slot's master ref */
  	if (refcount_dec_and_test(&nd->uarg.refcnt)) {
-		notif->io_task_work.func = __io_notif_complete_tw;
  		io_req_task_work_add(notif);
  	}
  }
diff --git a/io_uring/notif.h b/io_uring/notif.h
index 5b4d710c8ca5..5ac7a2745e52 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -13,10 +13,12 @@ struct io_notif_data {
  	struct file		*file;
  	struct ubuf_info	uarg;
  	unsigned long		account_pages;
+	bool			zc_used;
+	bool			zc_copied;
  };

  void io_notif_flush(struct io_kiocb *notif);
-struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx);
+struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx, bool report_usage);

  static inline struct io_notif_data *io_notif_to_data(struct io_kiocb *notif)
  {

