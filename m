Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D254611C19
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 23:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiJ1VE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 17:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiJ1VEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 17:04:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1B683F308;
        Fri, 28 Oct 2022 14:04:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21F9E62A74;
        Fri, 28 Oct 2022 21:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36DE0C433D6;
        Fri, 28 Oct 2022 21:04:49 +0000 (UTC)
Date:   Fri, 28 Oct 2022 17:05:05 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-nfs@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Subject: [PATCH] SUNRPC/xprt: Use del_timer_sync() instead of
 del_singleshot_timer_sync()
Message-ID: <20221028170505.44d779c3@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Back on June 22, 2005, it was decided to use del_singleshot_timer_sync()
because it wouldn't loop like del_timer_sync(), and since the timer that
was being removed was not about to be rearmed, it was considered an
efficiency to use del_singleshot_timer_sync() over del_timer_sync().

But on June 23, 2005, commit 55c888d6d09a0 ("timers fixes/improvements")
happened, which converted del_singleshot_timer_sync() into:

 #define del_singleshot_timer_sync(t) del_timer_sync(t)

Making the two equivalent.

Now work is being done to add a "shutdown" state to timers where a timer
must be in that state in order to be freed to prevent use-after-free bugs
caused by timers being re-armed just before being freed, the
del_singleshot_timer_sync() is now being converted into something that
will set the timer to the shutdown state. This means that once
del_singleshot_timer_sync() is called, the timer can no longer be
re-armed.

As the timer here will be re-armed, it can not use del_singleshot_timer_sync().
But as the reason it was used in the first place no longer exists, just
use del_timer_sync().

Link: https://lore.kernel.org/lkml/20221028145005.28bc324d@gandalf.local.home/

Fixes: 0f9dc2b16884b ("RPC: Clean up socket autodisconnect")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 net/sunrpc/xprt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 656cec208371..ab453ede54f0 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1164,7 +1164,7 @@ xprt_request_enqueue_receive(struct rpc_task *task)
 	spin_unlock(&xprt->queue_lock);
 
 	/* Turn off autodisconnect */
-	del_singleshot_timer_sync(&xprt->timer);
+	del_timer_sync(&xprt->timer);
 	return 0;
 }
 
-- 
2.35.1

