Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 333275EACCC
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 18:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbiIZQl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 12:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiIZQlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 12:41:10 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E160D7C1FF;
        Mon, 26 Sep 2022 08:28:46 -0700 (PDT)
Date:   Mon, 26 Sep 2022 17:28:43 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1664206125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9nbCVQlF5qlRYS1gBGpsvqLakPTcaKItqwHxbBmwhEU=;
        b=l95NVTonaPZeEOkZ4+Q4TZ1DUvKec7KYHg9OvC+2mNm8V/+3fUl03BoBAuEofGOTSLlJc1
        OfkbknPRAo22h48R6SCkRodReH3PRKLd57V3qA7yb+cjo9/R0VAeKRaenrXttAFAXAK/Tf
        53LtHBoqE4sDR5TR43tKMI8EX8r95ZovjCsfGJnfFUtogbr4hmgR3/GmEOTsMdU5MfqkPZ
        R0GcayhYMi+9lWM/FJX4mGS3UK0cvENZ0BuhejPpHlS4y40qtfXH8/sPpF+6NU+YDSnOgp
        tRbVNZO8OC+Ul6apcXmAoAb1zrdp2gGlJMV2MNZ4eVGjVp1oFlBIKO6ZWfRCXw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1664206125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9nbCVQlF5qlRYS1gBGpsvqLakPTcaKItqwHxbBmwhEU=;
        b=olKpBUea9DZ42RA47FqvYpgoEm5m73lP7JG6MFSQ5veDZbxevd8Nlr14YrjeQMjjL8v3DX
        ondOGzqBh1a9lyCw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Uladzislau Rezki <urezki@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Martin Zaharinov <micron10@gmail.com>
Subject: Re: [PATCH mm] mm: fix BUG with kvzalloc+GFP_ATOMIC
Message-ID: <YzHFK01dNy5dKJDO@linutronix.de>
References: <20220923103858.26729-1-fw@strlen.de>
 <Yy20toVrIktiMSvH@dhcp22.suse.cz>
 <20220923133512.GE22541@breakpoint.cc>
 <Yy3GL12BOgp3wLjI@pc636>
 <20220923145409.GF22541@breakpoint.cc>
 <Yy3MS2uhSgjF47dy@pc636>
 <76d0cb2b-a963-b867-4399-3e3c4828ecc4@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <76d0cb2b-a963-b867-4399-3e3c4828ecc4@suse.cz>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-09-26 17:03:48 [+0200], Vlastimil Babka wrote:
> > Doing the "p = kmalloc(sizeof(*p), GFP_ATOMIC);" from an atomic context
> > is also a problem nowadays. Such code should be fixed across the kernel
> > because of PREEMPT_RT support.

You should make sure that the context in question is atomic on
PREEMPT_RT before fixing it. My guess here is that it is average the
softirq (NAPI) callback which is fine.

> But the "atomic context" here is different, no? Calling kmalloc() from IRQ
> handlers AFAIK is ok as IRQ handlers are threaded on PREEMPT_RT. Calling it
> inside an local_irq_disable() would be a problem on the other hand. But then
> under e.g. spin_lock_irqsave() could be ok as those don't really disable
> irqs on RT.

correct.

Sebastian
