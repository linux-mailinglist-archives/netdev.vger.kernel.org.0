Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C33B50595
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 11:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbfFXJYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 05:24:24 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44180 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbfFXJYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 05:24:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-Id:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rFd8r1wQO1GEPiOhTD6rTHNxkslgTiRvrEXbg6A1zF8=; b=MCAr/cudrqs43V08kOT0hnmnBv
        Hax38nB3bVDoJUFgwkvQJIu84B5aeDWzwGT3lHdQNtn7ePUM/CzJCN7E/P3tPcVgtQb/CqRsovdHn
        rOuKzXDpIrr+WO75c8f89XqwQzHWZPtzDiYXDKkYdZ+KbF/r4pywiq+EI3kfSt2THzy+6ZrPxj//O
        aEssWWgV6SXDk8XmxxANeHk5oZFgKKuPqfHSPCPwIz0pAtTJKlkk7qHqj+45gwqP2EArP6s1TOIho
        4wp9RyjoItGFGfm7oXeeNhvhvyQcHJfQmsgy6xUONBtp6GDIEjwCfiAsfa97iJi3zLCVxImTfiSjh
        n5Ox5GRA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hfLCm-0006mR-6O; Mon, 24 Jun 2019 09:24:04 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 5CF5720A0EF31; Mon, 24 Jun 2019 11:24:02 +0200 (CEST)
Message-Id: <20190624092109.863781858@infradead.org>
User-Agent: quilt/0.65
Date:   Mon, 24 Jun 2019 11:18:46 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jessica Yu <jeyu@kernel.org>, linux-kernel@vger.kernel.org,
        jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        pmladek@suse.com, ast@kernel.org, daniel@iogearbox.net,
        akpm@linux-foundation.org, peterz@infradead.org
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH 3/3] module: Properly propagate MODULE_STATE_COMING failure
References: <20190624091843.859714294@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that notifiers got unbroken; use the proper interface to handle
notifier errors and propagate them.

There were already MODULE_STATE_COMING notifiers that failed; notably:

 - jump_label_module_notifier()
 - tracepoint_module_notify()
 - bpf_event_notify()

By propagating this error, we fix those users.

Cc: Jessica Yu <jeyu@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: bpf@vger.kernel.org
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 kernel/module.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3643,9 +3643,10 @@ static int prepare_coming_module(struct
 	if (err)
 		return err;
 
-	blocking_notifier_call_chain(&module_notify_list,
-				     MODULE_STATE_COMING, mod);
-	return 0;
+	err = blocking_notifier_call_chain_error(&module_notify_list,
+			MODULE_STATE_COMING, MODULE_STATE_GOING, mod);
+
+	return notifier_to_errno(err);
 }
 
 static int unknown_module_param_cb(char *param, char *val, const char *modname,


