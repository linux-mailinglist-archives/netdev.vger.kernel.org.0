Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E411B10E7B
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 23:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbfEAVSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 17:18:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40300 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfEAVSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 17:18:46 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3513F133E97C0;
        Wed,  1 May 2019 14:18:45 -0700 (PDT)
Date:   Wed, 01 May 2019 17:18:44 -0400 (EDT)
Message-Id: <20190501.171844.1878018144020092178.davem@davemloft.net>
To:     kafai@fb.com
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, bsd@fb.com,
        kernel-team@fb.com, weiwan@google.com
Subject: Re: [PATCH net] ipv6: A few fixes on dereferencing rt->from
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190430174512.3898413-1-kafai@fb.com>
References: <20190430174512.3898413-1-kafai@fb.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 May 2019 14:18:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin KaFai Lau <kafai@fb.com>
Date: Tue, 30 Apr 2019 10:45:12 -0700

> It is a followup after the fix in
> commit 9c69a1320515 ("route: Avoid crash from dereferencing NULL rt->from")
> 
> rt6_do_redirect():
> 1. NULL checking is needed on rt->from because a parallel
>    fib6_info delete could happen that sets rt->from to NULL.
>    (e.g. rt6_remove_exception() and fib6_drop_pcpu_from()).
> 
> 2. fib6_info_hold() is not enough.  Same reason as (1).
>    Meaning, holding dst->__refcnt cannot ensure
>    rt->from is not NULL or rt->from->fib6_ref is not 0.
> 
>    Instead of using fib6_info_hold_safe() which ip6_rt_cache_alloc()
>    is already doing, this patch chooses to extend the rcu section
>    to keep "from" dereference-able after checking for NULL.
> 
> inet6_rtm_getroute():
> 1. NULL checking is also needed on rt->from for a similar reason.
>    Note that inet6_rtm_getroute() is using RTNL_FLAG_DOIT_UNLOCKED.
> 
> Fixes: a68886a69180 ("net/ipv6: Make from in rt6_info rcu protected")
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

Applied and queued up for -stable, thanks.
