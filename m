Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A84055F1FB3
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 23:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiJAVP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 17:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiJAVP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 17:15:57 -0400
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 71A372D1FE
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 14:15:54 -0700 (PDT)
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 291LFTri015900;
        Sat, 1 Oct 2022 23:15:29 +0200
Date:   Sat, 1 Oct 2022 23:15:29 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: Re: [PATCH net-next] once: add DO_ONCE_SLOW() for sleepable contexts
Message-ID: <20221001211529.GC15441@1wt.eu>
References: <20221001205102.2319658-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221001205102.2319658-1-eric.dumazet@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On Sat, Oct 01, 2022 at 01:51:02PM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Christophe Leroy reported a ~80ms latency spike
> happening at first TCP connect() time.

Seeing Christophe's message also made me wonder if we didn't break
something back then :-/

> This is because __inet_hash_connect() uses get_random_once()
> to populate a perturbation table which became quite big
> after commit 4c2c8f03a5ab ("tcp: increase source port perturb table to 2^16")
> 
> get_random_once() uses DO_ONCE(), which block hard irqs for the duration
> of the operation.
> 
> This patch adds DO_ONCE_SLOW() which uses a mutex instead of a spinlock
> for operations where we prefer to stay in process context.

That's a nice improvement I think. I was wondering if, for this special
case, we *really* need an exclusive DO_ONCE(). I mean, we're getting
random bytes, we really do not care if two CPUs change them in parallel
provided that none uses them before the table is entirely filled. Thus
that could probably end up as something like:

    if (!atomic_read(&done)) {
        get_random_bytes(array);
        atomic_set(&done, 1);
    }

In any case, your solution remains cleaner and more robust, though.

Thanks,
Willy
