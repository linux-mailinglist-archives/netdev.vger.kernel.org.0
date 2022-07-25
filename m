Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 772F5580724
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 00:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236328AbiGYWLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 18:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236627AbiGYWLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 18:11:11 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738BF24957;
        Mon, 25 Jul 2022 15:11:09 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id by10-20020a056830608a00b0061c1ac80e1dso9640930otb.13;
        Mon, 25 Jul 2022 15:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z8fKr9PnvMB9QJctTkgs9BZwOr5ZFfF3I35YtLUv1no=;
        b=BxBDaI9yXCotEEJsjQ8q7xjsXv4g+1N4K4GjaP3DB4deYt+5E+mnr07RiV8yKn3+6D
         gYKHgH+87ZqbTnq4rOFoOvIPsJl07+knZYe6gBqRVbIpokfHIEuOcq0JVPqPb5yC+aNH
         DqO5nSzorrLR9ced7qd12gzRL5cUW6IJwE1nZ4rr9w75QK8eIjqQd9nMCHVIt7EHD/+w
         9pUHyKxx/X0OeIz+gjxKbsNOguN5BWtvfruZejV4WG1I9dtBG/4sRHMeWbgnq2IDvoqm
         yXbZ8bbb7GidGBX051jhqAi9oB0X/Zmnshvkq4ltM2WVoy4zNcZIKKhGX/+OB4LTqqgo
         GixQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z8fKr9PnvMB9QJctTkgs9BZwOr5ZFfF3I35YtLUv1no=;
        b=6Tne2SfMOv7Mv5MTvq8CM3wNzkosasv6NkzbuxhcBO79g8mpFoweQAaXn7CtixS/1w
         j09zaR5Dt8hHE+7+JMnrF9eMjclChUjEoOjksjnxdU8qkMi3vGoZ0RKS1CRhIXJ7fbHx
         ftn1RnbV1C+ztINe9XQEqRQ7BhjIFpBKaPwCjlpEYRD6SbYgWzWWoz9JqLOmXuXN+ORf
         PxCA7gY2EQBwwacxeLS7T1KJFmoyuWEIWr/v2qAcbPs6YaDpliJteM/vbmokeFbXBRuu
         +tR4AqCbw2j4F2+EQClGvicvxAfNkpcf3Hkzb8lSwAf/PDftl/uAyGXFkyxNwGcKoLNQ
         WkdQ==
X-Gm-Message-State: AJIora8ajPR0BppFKvJXbb0UdyZDfAajJYVbdBp23mCVLih8OLOn1OOj
        FeB7cRCk7ASFAcBcav1BQE1SPxuWQi6awg==
X-Google-Smtp-Source: AGRyM1tOKGHPbBf7n6qwcXEwrxgf6kY9Se0ZT+1byFAaiKXc2Je3OkKS7eg0cFF0DOl+lIjVrxWOGQ==
X-Received: by 2002:a05:6830:d13:b0:618:b519:5407 with SMTP id bu19-20020a0568300d1300b00618b5195407mr5391515otb.219.1658787068448;
        Mon, 25 Jul 2022 15:11:08 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id q17-20020a9d7c91000000b00616dfd2c859sm5445865otn.59.2022.07.25.15.11.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 15:11:07 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net] sctp: leave the err path free in sctp_stream_init to sctp_stream_free
Date:   Mon, 25 Jul 2022 18:11:06 -0400
Message-Id: <831a3dc100c4908ff76e5bcc363be97f2778bc0b.1658787066.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A NULL pointer dereference was reported by Wei Chen:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  RIP: 0010:__list_del_entry_valid+0x26/0x80
  Call Trace:
   <TASK>
   sctp_sched_dequeue_common+0x1c/0x90
   sctp_sched_prio_dequeue+0x67/0x80
   __sctp_outq_teardown+0x299/0x380
   sctp_outq_free+0x15/0x20
   sctp_association_free+0xc3/0x440
   sctp_do_sm+0x1ca7/0x2210
   sctp_assoc_bh_rcv+0x1f6/0x340

This happens when calling sctp_sendmsg without connecting to server first.
In this case, a data chunk already queues up in send queue of client side
when processing the INIT_ACK from server in sctp_process_init() where it
calls sctp_stream_init() to alloc stream_in. If it fails to alloc stream_in
all stream_out will be freed in sctp_stream_init's err path. Then in the
asoc freeing it will crash when dequeuing this data chunk as stream_out
is missing.

As we can't free stream out before dequeuing all data from send queue, and
this patch is to fix it by moving the err path stream_out/in freeing in
sctp_stream_init() to sctp_stream_free() which is eventually called when
freeing the asoc in sctp_association_free(). This fix also makes the code
in sctp_process_init() more clear.

Note that in sctp_association_init() when it fails in sctp_stream_init(),
sctp_association_free() will not be called, and in that case it should
go to 'stream_free' err path to free stream instead of 'fail_init'.

Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
Reported-by: Wei Chen <harperchen1110@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/associola.c |  5 ++---
 net/sctp/stream.c    | 19 +++----------------
 2 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index be29da09cc7a..3460abceba44 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -229,9 +229,8 @@ static struct sctp_association *sctp_association_init(
 	if (!sctp_ulpq_init(&asoc->ulpq, asoc))
 		goto fail_init;
 
-	if (sctp_stream_init(&asoc->stream, asoc->c.sinit_num_ostreams,
-			     0, gfp))
-		goto fail_init;
+	if (sctp_stream_init(&asoc->stream, asoc->c.sinit_num_ostreams, 0, gfp))
+		goto stream_free;
 
 	/* Initialize default path MTU. */
 	asoc->pathmtu = sp->pathmtu;
diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index 6dc95dcc0ff4..ef9fceadef8d 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -137,7 +137,7 @@ int sctp_stream_init(struct sctp_stream *stream, __u16 outcnt, __u16 incnt,
 
 	ret = sctp_stream_alloc_out(stream, outcnt, gfp);
 	if (ret)
-		goto out_err;
+		return ret;
 
 	for (i = 0; i < stream->outcnt; i++)
 		SCTP_SO(stream, i)->state = SCTP_STREAM_OPEN;
@@ -145,22 +145,9 @@ int sctp_stream_init(struct sctp_stream *stream, __u16 outcnt, __u16 incnt,
 handle_in:
 	sctp_stream_interleave_init(stream);
 	if (!incnt)
-		goto out;
-
-	ret = sctp_stream_alloc_in(stream, incnt, gfp);
-	if (ret)
-		goto in_err;
-
-	goto out;
+		return 0;
 
-in_err:
-	sched->free(stream);
-	genradix_free(&stream->in);
-out_err:
-	genradix_free(&stream->out);
-	stream->outcnt = 0;
-out:
-	return ret;
+	return sctp_stream_alloc_in(stream, incnt, gfp);
 }
 
 int sctp_stream_init_ext(struct sctp_stream *stream, __u16 sid)
-- 
2.31.1

