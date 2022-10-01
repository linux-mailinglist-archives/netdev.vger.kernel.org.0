Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 958A05F2073
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 00:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiJAWuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 18:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiJAWus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 18:50:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6923FEF7
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 15:50:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A106460D34
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 22:50:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC03C433C1;
        Sat,  1 Oct 2022 22:50:43 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="M1jqPN7B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1664664641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HgVFB2Ag9AG/aIXGZXBDxYV6vIlIMWst0YrpsfgESz0=;
        b=M1jqPN7BGopn+OinjTPeknkak/TfCCA2DdGepidsSMJr8JmWeiHTk2siQQ9J5LAOyU6sos
        5dowEU6pOzsqlWfLT0Ty3SCYVpRPoFMLI4+32anSWBeEp1ez4SMEEQ+28j+twtHi5XzhRb
        3VR+krpLQR4JmmirC11m0a3oaq/bDvM=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 00629296 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sat, 1 Oct 2022 22:50:41 +0000 (UTC)
Date:   Sun, 2 Oct 2022 00:50:38 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Willy Tarreau <w@1wt.eu>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: Re: [PATCH net-next] once: add DO_ONCE_SLOW() for sleepable contexts
Message-ID: <YzjEPq6owOKBACj3@zx2c4.com>
References: <20221001205102.2319658-1-eric.dumazet@gmail.com>
 <20221001211529.GC15441@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221001211529.GC15441@1wt.eu>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 01, 2022 at 11:15:29PM +0200, Willy Tarreau wrote:
> Hi Eric,
> 
> On Sat, Oct 01, 2022 at 01:51:02PM -0700, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> > 
> > Christophe Leroy reported a ~80ms latency spike
> > happening at first TCP connect() time.
> 
> Seeing Christophe's message also made me wonder if we didn't break
> something back then :-/
> 
> > This is because __inet_hash_connect() uses get_random_once()
> > to populate a perturbation table which became quite big
> > after commit 4c2c8f03a5ab ("tcp: increase source port perturb table to 2^16")
> > 
> > get_random_once() uses DO_ONCE(), which block hard irqs for the duration
> > of the operation.
> > 
> > This patch adds DO_ONCE_SLOW() which uses a mutex instead of a spinlock
> > for operations where we prefer to stay in process context.
> 
> That's a nice improvement I think. I was wondering if, for this special
> case, we *really* need an exclusive DO_ONCE(). I mean, we're getting
> random bytes, we really do not care if two CPUs change them in parallel
> provided that none uses them before the table is entirely filled. Thus
> that could probably end up as something like:
> 
>     if (!atomic_read(&done)) {
>         get_random_bytes(array);
>         atomic_set(&done, 1);
>     }

If you don't care about the tables being consistent between CPUs, then
yea, sure, that seems like a reasonable approach, and I like not
polluting once.{c,h} with some _SLOW() special cases. If you don't want
the atomic read in there you could also do the same pattern with a
static branch, like what DO_ONCE() does:

   if (static_branch_unlikely(&need_bytes)) {
      get_random_bytes(array);
      static_branch_disable(&need_bytes);
   }

Anyway, same thing as your suggestion more or less.

Jason
