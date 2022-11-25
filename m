Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB266384DE
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 09:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiKYIAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 03:00:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiKYIAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 03:00:06 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9028A303D5;
        Fri, 25 Nov 2022 00:00:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8TV2H+mw2roghON9dZi8tjqa2D9zCsxjBsOv5fUqu44=; b=eiEI5OIfZpN2baAb5xqupaNWdT
        JusrNhWE3n/ggnWuzCJ0ElAOkkeZys1s0HHQe8iya1t/nqFkX4Ggn9NKO7MNAAM24Ci2iVd7kr9VK
        zqlsaAr+HyUUG4z+h+HLLIGa2FgQAUj4iqzSOQ/op2e3jHvABBy5AkcPUuOrF4fqCpxt8wU0qKV/f
        DQYw+9pyIv1yPSc+RO0O/VsImNwJG8GQ/ZQFdqpYLgu02+26haD97bFJ1Vij2izaVZoFF3Dmpsobp
        R8ON4Jf/rimYfwsPEpOKVH7m1y/mUxx1wiX8Z+ESCvx56NRqdfHE8+RHMMZgHOW6GUy6enZ8XI2UH
        Yt+Ynigw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oyTcl-009Phg-38; Fri, 25 Nov 2022 07:59:51 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B703B300282;
        Fri, 25 Nov 2022 08:59:42 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 95BC62D52AC8A; Fri, 25 Nov 2022 08:59:42 +0100 (CET)
Date:   Fri, 25 Nov 2022 08:59:42 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Baron <jbaron@akamai.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org
Subject: Re: [PATCH v6 1/5] jump_label: Prevent key->enabled int overflow
Message-ID: <Y4B17nBArWS1Iywo@hirez.programming.kicks-ass.net>
References: <20221123173859.473629-1-dima@arista.com>
 <20221123173859.473629-2-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123173859.473629-2-dima@arista.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 05:38:55PM +0000, Dmitry Safonov wrote:
> 1. With CONFIG_JUMP_LABEL=n static_key_slow_inc() doesn't have any
>    protection against key->enabled refcounter overflow.
> 2. With CONFIG_JUMP_LABEL=y static_key_slow_inc_cpuslocked()
>    still may turn the refcounter negative as (v + 1) may overflow.
> 
> key->enabled is indeed a ref-counter as it's documented in multiple
> places: top comment in jump_label.h, Documentation/staging/static-keys.rst,
> etc.
> 
> As -1 is reserved for static key that's in process of being enabled,
> functions would break with negative key->enabled refcount:
> - for CONFIG_JUMP_LABEL=n negative return of static_key_count()
>   breaks static_key_false(), static_key_true()
> - the ref counter may become 0 from negative side by too many
>   static_key_slow_inc() calls and lead to use-after-free issues.
> 
> These flaws result in that some users have to introduce an additional
> mutex and prevent the reference counter from overflowing themselves,
> see bpf_enable_runtime_stats() checking the counter against INT_MAX / 2.
> 
> Prevent the reference counter overflow by checking if (v + 1) > 0.
> Change functions API to return whether the increment was successful.
> 
> Signed-off-by: Dmitry Safonov <dima@arista.com>
> Acked-by: Jakub Kicinski <kuba@kernel.org>

This looks good to me:

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

What is the plan for merging this? I'm assuming it would want to go
through the network tree, but as already noted earlier it depends on a
patch I have in tip/locking/core.

Now I checked, tip/locking/core is *just* that one patch, so it might be
possible to merge that branch and this series into the network tree and
note that during the pull request to Linus.
