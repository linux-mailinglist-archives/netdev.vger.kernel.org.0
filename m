Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86DDD35435
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 01:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbfFDXWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 19:22:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726836AbfFDXWg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 19:22:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26EE620866;
        Tue,  4 Jun 2019 23:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559690555;
        bh=nS8p33op+lPx3xjF6fPT+mUnp7ey+7F7f1nn/Cd8jNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CmLqG8GdSB2hpVYaVEI0GuTaK+geV4sXNJ7vupghUwtO9/EiovFS/mwomUzDJOrJn
         c8TNLmydAg3IEgKeJXeMsHAmNYd0tsRe1k7U6JSOoCZwUQEV+iR3khRLlfkTXfhv1N
         HFMxUjfenkTd4B1sm74IcrJ0E9kfK79vibDMycMc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 12/60] bpf: sockmap, only stop/flush strp if it was enabled at some point
Date:   Tue,  4 Jun 2019 19:21:22 -0400
Message-Id: <20190604232212.6753-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190604232212.6753-1-sashal@kernel.org>
References: <20190604232212.6753-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit 014894360ec95abe868e94416b3dd6569f6e2c0c ]

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

Finally, remove the strp_done its not needed and in the case where we
are using the stream parser has already been called.

Fixes: e8e3437762ad9 ("bpf: Stop the psock parser before canceling its work")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skmsg.c | 6 ++++--
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
 
-- 
2.20.1

