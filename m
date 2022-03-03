Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A45FA4CBDCB
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 13:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbiCCM1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 07:27:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233320AbiCCM1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 07:27:46 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F158217AEF9;
        Thu,  3 Mar 2022 04:26:50 -0800 (PST)
Date:   Thu, 3 Mar 2022 13:26:47 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646310408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=/2IrixGajLDVd5J8HzrF+LuMsZqItBwpaII0wZuPf8g=;
        b=CjB1y8PCdfXh5XLxDXAE2ildunQp6SghTDP8O9tYIHFCOkYoJ2Y5kXADTiEdTRd2amMzva
        4674c866t36n76+1yskgcVWflIEeIh51Jky7f9MMyJm2RrOU8RXD+g5fTDJWJs4B+8clTO
        wJX1b6VYSuoPAvvZ4cUaKfm+PpMWaoXmsvZeT/kpxtTF1DWnasOvT8lvxdfNO8JrnwKPeu
        ojDoS8IYnp6kOuXZDm9KxOYQovZmaosYZB5H8K4zSNAm3rHV3fTp+wsFHPusJVe0C9bnLu
        KESwxv3NjydfkqH9dgkEBjWXcy8VZsMkJdBgHWY4zs18AFAxJ12B6Spa5bbfKA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646310408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=/2IrixGajLDVd5J8HzrF+LuMsZqItBwpaII0wZuPf8g=;
        b=uCw+2UiyriU1hW8trcV7w3cEA6PHbBnwy19dFZPHZB0QqED0l9HEMEmiJslxPYfeRUNOAE
        CEdZ/qIxkYyGRFBQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH net] xdp: xdp_mem_allocator can be NULL in
 trace_mem_connect().
Message-ID: <YiC0BwndXiwxGDNz@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the commit mentioned below __xdp_reg_mem_model() can return a NULL
pointer. This pointer is dereferenced in trace_mem_connect() which leads
to segfault. It can be reproduced with enabled trace events during ifup.

Only assign the arguments in the trace-event macro if `xa' is set.
Otherwise set the parameters to 0.

Fixes: 4a48ef70b93b8 ("xdp: Allow registering memory model without rxq reference")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/trace/events/xdp.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
index c40fc97f94171..9196dcd08e6c7 100644
--- a/include/trace/events/xdp.h
+++ b/include/trace/events/xdp.h
@@ -362,9 +362,9 @@ TRACE_EVENT(mem_connect,
 
 	TP_fast_assign(
 		__entry->xa		= xa;
-		__entry->mem_id		= xa->mem.id;
-		__entry->mem_type	= xa->mem.type;
-		__entry->allocator	= xa->allocator;
+		__entry->mem_id		= xa ? xa->mem.id : 0;
+		__entry->mem_type	= xa ? xa->mem.type : 0;
+		__entry->allocator	= xa ? xa->allocator : NULL;
 		__entry->rxq		= rxq;
 		__entry->ifindex	= rxq->dev->ifindex;
 	),
-- 
2.35.1

