Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6489C197DA
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 06:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbfEJE6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 00:58:20 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:32777 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbfEJE6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 00:58:20 -0400
Received: by mail-it1-f196.google.com with SMTP id u16so6699937itc.0;
        Thu, 09 May 2019 21:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=5ar/GHBOf+NmAxnd5M+Y72KZr2xiJVin2jhQ9wQRufY=;
        b=c+ghLIuUHe60TUSjV7w5iw7blr0pV7taeiwTeAqCS0dlGstDwCLAVYT7BOaaZcU0v2
         ZI50bnBpTb+mXMWfuBqS5amOBFkmC/AjPxtnkH9gXG17h9QkgxbpdVbNmaYh+drbyIzQ
         InJWN/iQ80Pbo1JtZjC9r1EN9AL3MQKPC3DohFAeiz9pjmGYqCDOkoKwkjixZ3AZuY19
         vWUarOlgKwz7XPs1B2L2V2FtXUw0QJLbscas5pjqYyKef+uUnUVa68p4clf2mb5+r1AR
         oaRFTDq9a+xh3oludMjpUJG57H39ClJEf9JuNE6lBiFxvsWs47nwPZDyKuHRqyOjJiDg
         p1PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=5ar/GHBOf+NmAxnd5M+Y72KZr2xiJVin2jhQ9wQRufY=;
        b=S2tR6wBucXTIvMKtERnX5Z7wHq+8QRbOa92epzhzAJU3U+2/djMiJouQ7tKGNYLMpT
         4NDJhSrzElxO7+i22BpgsEKzK/ur2ElOvWS7kTApU6bEV3fboBQxmDJU3OPJRRDXoozr
         3gsOYZjUZ/OJ2FCn3RkFEFmR9XFe1A7Fi5dtcQhuQzbNbHyhR47vOH6adFa5gFooAWJQ
         vNkBJ4Wq1nz7G7ShkA8qRkraQ+9EGJudGOOQoIrnB8OT4nj5V5mV534gbKu0ji9p/kRD
         WeNlRMaphIS9h0HzfMYD2nCCA/tlApYneUhtI5jqkbXV1eoR86hxOq/iJre6Riy8MGmS
         DcSA==
X-Gm-Message-State: APjAAAUo6mj0pc09hAjC5bcIXJMcUA9MQlQgKkmHGzu+e3Gm/7UzvrvU
        QIIbaJJ1D3Alw0S2PbnFETWVLA6hOJs=
X-Google-Smtp-Source: APXvYqylPYGSzKHGZtFW+bdJeUsoUTBfX8F8DUkCh5FxMT5b1tzQMr5srWNyhiwFNwga3htP3UkE4Q==
X-Received: by 2002:a24:794c:: with SMTP id z73mr6575609itc.68.1557464299650;
        Thu, 09 May 2019 21:58:19 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 140sm2107270itv.44.2019.05.09.21.58.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 21:58:19 -0700 (PDT)
Subject: [bpf PATCH v4 2/4] bpf: sockmap,
 only stop/flush strp if it was enabled at some point
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub.kicinski@netronome.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Thu, 09 May 2019 21:58:08 -0700
Message-ID: <155746428809.20677.1018962454305769603.stgit@john-XPS-13-9360>
In-Reply-To: <155746412544.20677.8888193135689886027.stgit@john-XPS-13-9360>
References: <155746412544.20677.8888193135689886027.stgit@john-XPS-13-9360>
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
 

