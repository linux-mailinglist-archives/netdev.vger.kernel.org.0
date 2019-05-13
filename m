Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7431B7FC
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 16:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730159AbfEMOTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 10:19:32 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:35312 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728867AbfEMOTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 10:19:32 -0400
Received: by mail-it1-f196.google.com with SMTP id u186so20584420ith.0;
        Mon, 13 May 2019 07:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=5ar/GHBOf+NmAxnd5M+Y72KZr2xiJVin2jhQ9wQRufY=;
        b=MIn5gviIX98B2+dKu/+kvdsZE0fw0ri2MSNm1BNiqB60ImYsMj4Y97sk6JmWHkRFmu
         R1X3srjNhYoWL+WCcymbHO3AO02wPsZCKO9pcwELBxzlpmxHfJBlri1rcnP6ipuIkOsO
         fgGlvGIYQQ/7R4/HOPbvTG+lne8U9nG98cqRByq35hIkZ/rJ6RQMiJ36ZZJadte4cRb2
         g3hKnsN2EkgbdAIz9/t/JV9lXCmKZyQSB9ARW6X9Ry+zXXOR1jEYWyfhx94qv+UTpDos
         Cx5Tl05gURPiORBoF8Gtf+txqdTqXkBPgZzIuulezeX5vpja3Ovbqx9IPJazhBY4KI5i
         2u2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=5ar/GHBOf+NmAxnd5M+Y72KZr2xiJVin2jhQ9wQRufY=;
        b=RZsjdavlvNguciHOrhcBIiSBy/a+tCIC8hVGEr4ascnEndoE4S/MNb3rZki540+ZW/
         kawHgQgsDDl/pP986iGyqLiOO/T8NC52PZpXHwB2YP4fWdzt9hSKQewt2Th4/6wzBdit
         MBhXh0kkdjhbKGZQLFaOBEXozuhqWs6/2KE/eHAI6pi4At0Cm7/dQz73OxsZEDeaYlnV
         f6wB6jtEfX67Vt8fWb8NmhIRO5v1OlNlBq7+P4ekozmIskQ8LpFv+Hov+E8F8hjWoS19
         zFMDccAVv7EGMhmWfIWWt5cBNjUPC29e+uiLj3APRkPy5Bq/m+9epZjrB86IuzpIi7Fs
         4hpA==
X-Gm-Message-State: APjAAAUc/LIqhJeNSmqueyw1NXwQxXQBZOV/ntVQ5mSS3S2mL4IZDTkY
        WFqQ7lzZyezHBAmsiN+T9JA=
X-Google-Smtp-Source: APXvYqxPASelMTITDuArZo7INFkbT/o+sSHzn0JMcxStPCvM1oEJ8zjczT+Wa3gDH79nZQ0OOyRJlA==
X-Received: by 2002:a24:d486:: with SMTP id x128mr15651248itg.80.1557757171337;
        Mon, 13 May 2019 07:19:31 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id x23sm4546357iob.57.2019.05.13.07.19.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 May 2019 07:19:30 -0700 (PDT)
Subject: [bpf PATCH 1/3] bpf: sockmap,
 only stop/flush strp if it was enabled at some point
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub.kicinski@netronome.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Mon, 13 May 2019 07:19:19 -0700
Message-ID: <155775715979.22311.14369835450992570068.stgit@john-XPS-13-9360>
In-Reply-To: <155775710768.22311.15370233730402405518.stgit@john-XPS-13-9360>
References: <155775710768.22311.15370233730402405518.stgit@john-XPS-13-9360>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we try to call strp_done on a parser that has never been
initialized, because the sockmap user is only using TX side for
example we get the following error.


  [  883.422081] WARNING: CPU: 1 PID: 208 at kernel/workqueue.c:3030 __flush_work+0x1ca/0x1e0
  ...
  [  883.422095] Workqueue: events sk_psock_destroy_deferred
  [  883.422097] RIP: 0010:__flush_work+0x1ca/0x1e0


This had been wrapped in a 'if (psock->parser.enabled)' logic which
was broken because the strp_done() was never actually being called
because we do a strp_stop() earlier in the tear down logic will
set parser.enabled to false. This could result in a use after free
if work was still in the queue and was resolved by the patch here,
1d79895aef18f ("sk_msg: Always cancel strp work before freeing the
psock"). However, calling strp_stop(), done by the patch marked in
the fixes tag, only is useful if we never initialized a strp parser
program and never initialized the strp to start with. Because if
we had initialized a stream parser strp_stop() would have been called
by sk_psock_drop() earlier in the tear down process.  By forcing the
strp to stop we get past the WARNING in strp_done that checks
the stopped flag but calling cancel_work_sync on work that has never
been initialized is also wrong and generates the warning above.

To fix check if the parser program exists. If the program exists
then the strp work has been initialized and must be sync'd and
cancelled before free'ing any structures. If no program exists we
never initialized the stream parser in the first place so skip the
sync/cancel logic implemented by strp_done.

Finally, remove the strp_done its not needed and in the case where we are using the
stream parser has already been called.

Fixes: e8e3437762ad9 ("bpf: Stop the psock parser before canceling its work")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index cc94d921476c..49d1efa329d7 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -554,8 +554,10 @@ static void sk_psock_destroy_deferred(struct work_struct *gc)
 	struct sk_psock *psock = container_of(gc, struct sk_psock, gc);
 
 	/* No sk_callback_lock since already detached. */
-	strp_stop(&psock->parser.strp);
-	strp_done(&psock->parser.strp);
+
+	/* Parser has been stopped */
+	if (psock->progs.skb_parser)
+		strp_done(&psock->parser.strp);
 
 	cancel_work_sync(&psock->work);
 

