Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83F1B31B78B
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 11:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbhBOKpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 05:45:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbhBOKo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 05:44:59 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89878C061574;
        Mon, 15 Feb 2021 02:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=V15Ko0jDRPYeN/67QW78zQNnD8VcExjAsz8XTcjzpH0=; b=FQLYNszvDOtdGWgZii+WiBb+r2
        fQYSdW1pQgcjxIeHKsYCBPXYDfjrGgSYz1rtEucTGaAG6dX+cej25NinPNM71gm5N9Q5aaSGizgA3
        tZLza6Lmq3tTUF9yhpPqntfDryVkavGkkudpzJv7eQRJ5GVNkLsP8QNWVA1rgmNXTKHE5+WFlxU2W
        d4YrJCxMgsSxe/KdxlBHdUrKWhtJ3D9hVvfNIWNvQ753sMvOF3O1oSf1RR6fV5a/dFeENJ7VLQved
        4/LCeINLWhTmnHk28Aljj0dDCd8Dn9MbqL8uP+TIJD0H6vKOHRzmDjx0rGOoDfD1SWB1nepAmrd6z
        HyHahSCg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1lBbMN-0006hm-9U; Mon, 15 Feb 2021 10:44:07 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 7CE01981573; Mon, 15 Feb 2021 11:44:02 +0100 (CET)
Date:   Mon, 15 Feb 2021 11:44:02 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     mingo@redhat.com, will@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] lockdep: add lockdep_assert_not_held()
Message-ID: <20210215104402.GC4507@worktop.programming.kicks-ass.net>
References: <cover.1613171185.git.skhan@linuxfoundation.org>
 <37a29c383bff2fb1605241ee6c7c9be3784fb3c6.1613171185.git.skhan@linuxfoundation.org>
 <YCljfeNr4m5mZa4N@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCljfeNr4m5mZa4N@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 14, 2021 at 06:53:01PM +0100, Peter Zijlstra wrote:
> On Fri, Feb 12, 2021 at 04:28:42PM -0700, Shuah Khan wrote:
> 
> > +#define lockdep_assert_not_held(l)	do {			\
> > +		WARN_ON(debug_locks && lockdep_is_held(l));	\
> > +	} while (0)
> > +
> 
> This thing isn't as straight forward as you might think, but it'll
> mostly work.
> 
> Notably this thing will misfire when lockdep_off() is employed. It
> certainyl needs a comment to explain the subtleties.

I think something like so will work, but please double check.

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index b9e9adec73e8..c8b0d292bf8e 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -294,11 +294,15 @@ extern void lock_unpin_lock(struct lockdep_map *lock, struct pin_cookie);
 
 #define lockdep_depth(tsk)	(debug_locks ? (tsk)->lockdep_depth : 0)
 
-#define lockdep_assert_held(l)	do {				\
-		WARN_ON(debug_locks && !lockdep_is_held(l));	\
+#define lockdep_assert_held(l)	do {					\
+		WARN_ON(debug_locks && lockdep_is_held(l) == 0));	\
 	} while (0)
 
-#define lockdep_assert_held_write(l)	do {			\
+#define lockdep_assert_not_held(l)	do {				\
+		WARN_ON(debug_locks && lockdep_is_held(l) == 1));	\
+	} while (0)
+
+#define lockdep_assert_held_write(l)	do {				\
 		WARN_ON(debug_locks && !lockdep_is_held_type(l, 0));	\
 	} while (0)
 
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index c1418b47f625..983ba206f7b2 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -5467,7 +5467,7 @@ noinstr int lock_is_held_type(const struct lockdep_map *lock, int read)
 	int ret = 0;
 
 	if (unlikely(!lockdep_enabled()))
-		return 1; /* avoid false negative lockdep_assert_held() */
+		return -1; /* avoid false negative lockdep_assert_held() */
 
 	raw_local_irq_save(flags);
 	check_flags(flags);
