Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16A63103D4
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 04:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbfEACHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 22:07:12 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:46116 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbfEACHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 22:07:11 -0400
Received: by mail-yw1-f67.google.com with SMTP id v15so7414746ywe.13;
        Tue, 30 Apr 2019 19:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=wtoRhHiznELdjroOY8oXrivbtQDn8tLQ5eVLJAIsb9Q=;
        b=JyWt5s8+8x/5jv0/eY2R8fO6DHaXQnVbBYq90l1ySXf7ksVuwobZxv7k8okoSBgSww
         UOWnZMB5Q3OGTJRQLMviirexRFjxf6ft90NrSJ478WQzlQGeU5842v6LXQVX9ez8gx+Z
         RAv7EOPOjqG/fgoooSyvg28dVIHVfS/ISps/JUPfq1TpPTDuB9nXNufFaraqTpLlwiY+
         TpEgCgBZxVOmjT2LGfq2n5CGxnoNUcJQQ2i6SmP1y0ZmPcjiJkxMETXsmruxqYJfgCGc
         iIG+YRvN4sr2CIMizvrMENNGBBhKRTC9uYQY6xvIHtcmOxMsXGMiGmEJu0mVgqac2We9
         ptAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=wtoRhHiznELdjroOY8oXrivbtQDn8tLQ5eVLJAIsb9Q=;
        b=LOJBqouRKijsBwhm/EkubQA5EltYlP/GoK07Gdt7DurMz0rLPo+f3nh3ByR79Lm5GB
         L1tWEkQKpNtmiIO0Os+t+qg8x0hRosQ528f1FG98ednOKmo8iluwe7OEcbmlNpDKrRyC
         lp9IJHVxhU8ZXTUF17gK0hR0efBBd7+qAPLFXyhETso+U/keikOJ4bD8gSVzDnP2Oc/m
         qGOhov1k6LutbtSNwm2NSvKKXIcYujrrXZQ/qKA/myFITrgt/fGnztRWUTfEpM2WHajb
         1jlSC1rd1OIizX4XDD/36y7tJxs00L6nDeOTabBw/RHbCbkaNkhzm+81paj6SFcs3I3k
         9OXw==
X-Gm-Message-State: APjAAAXvRSGLcMntf4IsoezD/YciXdHg+MmjkKKjcCeaDwt9h9fIWyk1
        J4vXPz8z3l6FyLG2jQ8YIrY=
X-Google-Smtp-Source: APXvYqxFY1ZoAtvd7wYGTf5KRjqi+p6v37oQZuAFfqNGIsry9tia0NQdd8fEx5ipp2SEMbx0AuKOIA==
X-Received: by 2002:a81:730b:: with SMTP id o11mr58941667ywc.365.1556676430584;
        Tue, 30 Apr 2019 19:07:10 -0700 (PDT)
Received: from [127.0.1.1] (adsl-173-228-226-134.prtc.net. [173.228.226.134])
        by smtp.gmail.com with ESMTPSA id j84sm1027918ywa.104.2019.04.30.19.07.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 19:07:09 -0700 (PDT)
Subject: [bpf-next PATCH v3 4/4] bpf: sockmap,
 only stop/flush strp if it was enabled at some point
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub.kicinski@netronome.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Tue, 30 Apr 2019 19:07:09 -0700
Message-ID: <155667642909.4128.5577550149379609590.stgit@john-XPS-13-9360>
In-Reply-To: <155667629056.4128.14102391877350907561.stgit@john-XPS-13-9360>
References: <155667629056.4128.14102391877350907561.stgit@john-XPS-13-9360>
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
index 782ae9eb4dce..93bffaad2135 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -555,8 +555,10 @@ static void sk_psock_destroy_deferred(struct work_struct *gc)
 	struct sk_psock *psock = container_of(gc, struct sk_psock, gc);
 
 	/* No sk_callback_lock since already detached. */
-	strp_stop(&psock->parser.strp);
-	strp_done(&psock->parser.strp);
+
+	/* Parser has been stopped */
+	if (psock->progs.skb_parser)
+		strp_done(&psock->parser.strp);
 
 	cancel_work_sync(&psock->work);
 

