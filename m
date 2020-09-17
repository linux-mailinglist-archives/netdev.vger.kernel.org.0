Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48F9426DFF9
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 17:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgIQPpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 11:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728061AbgIQPOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 11:14:52 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D92C06178A;
        Thu, 17 Sep 2020 08:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9VdUj82i1voMW0HzA3fhImIu/omKpBsKf5XkZHcle8M=; b=fN/clyJLi0gpSAQ9dY/gHSFtzi
        B9i3x4sG59TjoaZhhi1PxQfXznlkNpc0JifdCAofvS2cQPUKZjIeOCetK9upe3aGB2zNzF93xKS5N
        mjU2qL6fjktaSIZZZugRhBN6m5eidycNeMWPgEnPYFf3ey3V0Lg5X0KNkcJAz+oZEXZD/vq+N49/J
        HnPtKN/dcj/xafFGSMGXV3CLDfQiSyP/Uf0Hb7KdVn80iotliaV6r7uMXmD3m3iIxeBbwxWB9o9wW
        U6FnyMqd0fQDpsgLHi3FGXF21IaKMLMCnyFIXItEyF0eb4AF51asiik5+y1lzrjlAK2KisKxcGuVY
        vHmVsaUw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIvcG-00025n-K8; Thu, 17 Sep 2020 15:14:32 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 2BD833011C6;
        Thu, 17 Sep 2020 17:14:29 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id CE97E2BC7FEE6; Thu, 17 Sep 2020 17:14:29 +0200 (CEST)
Date:   Thu, 17 Sep 2020 17:14:29 +0200
From:   peterz@infradead.org
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, paulmck@kernel.org, joel@joelfernandes.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rcu@vger.kernel.org, josh@joshtriplett.org,
        christian.brauner@ubuntu.com, mingo@redhat.com, will@kernel.org
Subject: Re: [PATCH net-next 6/7] lockdep: provide dummy forward declaration
 of *_is_held() helpers
Message-ID: <20200917151429.GJ1362448@hirez.programming.kicks-ass.net>
References: <20200916184528.498184-1-kuba@kernel.org>
 <20200916184528.498184-7-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916184528.498184-7-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 11:45:27AM -0700, Jakub Kicinski wrote:
> When CONFIG_LOCKDEP is not set, lock_is_held() and lockdep_is_held()
> are not declared or defined. This forces all callers to use ifdefs
> around these checks.
> 
> Recent RCU changes added a lot of lockdep_is_held() calls inside
> rcu_dereference_protected(). rcu_dereference_protected() hides
> its argument on !LOCKDEP builds, but this may lead to unused variable
> warnings.
> 
> Provide forward declarations of lock_is_held() and lockdep_is_held()
> but never define them. This way callers can keep them visible to
> the compiler on !LOCKDEP builds and instead depend on dead code
> elimination to remove the references before the linker barfs.
> 
> We need lock_is_held() for RCU.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> --
> CC: peterz@infradead.org
> CC: mingo@redhat.com
> CC: will@kernel.org
> ---
>  include/linux/lockdep.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
> index 6a584b3e5c74..6b5bbc536bf6 100644
> --- a/include/linux/lockdep.h
> +++ b/include/linux/lockdep.h
> @@ -371,6 +371,12 @@ static inline void lockdep_unregister_key(struct lock_class_key *key)
>  
>  #define lockdep_depth(tsk)	(0)
>  
> +/*
> + * Dummy forward declarations, allow users to write less ifdef-y code
> + * and depend on dead code elimination.
> + */
> +int lock_is_held(const void *);

extern int lock_is_held(const struct lockdep_map *);

> +int lockdep_is_held(const void *);

extern

I suppose we can't pull the lockdep_is_held() definition out from under
CONFIG_LOCKDEP because it does the ->dep_map dereference and many types
will simply not have that member.

>  #define lockdep_is_held_type(l, r)		(1)
>  
>  #define lockdep_assert_held(l)			do { (void)(l); } while (0)
