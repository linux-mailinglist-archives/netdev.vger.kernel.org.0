Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5666D334B
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 20:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbjDAS7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 14:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbjDAS7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 14:59:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB089D51A
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 11:58:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1C3DB80D68
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 18:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F97C433D2;
        Sat,  1 Apr 2023 18:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680375535;
        bh=k6UTLDuS8IwvZNpIFBpXVElA5rc4eJQMzHGRP9sdWRw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q8e0urbJxPeu+a7fShdqlEHiVSQNPe/I2RTkHXY9YAvin3o+6v3ZC0DCkoIEA/4RU
         Z0eC7RFUZAyI6TFqoBKF1nnhwbipl2KaikbP/gfN78sMBSL/Ri54jcbsXOcRzPV/sl
         37cTg9s0+jBcti9XaMihSyJiG4GiYep7PgG/QrVrRJKwf6uCyS51BNhR1YU/ENkXB3
         RhQfPB5VloEgi5n641DYoSkaB1GYHT2ZRo2wXUIR6Uc4Hf3Pfdbheo207opaXkW+B1
         ZR4d5mhO1yRiM+Nvvg2b1BXSBMoxw4z4aIdx7CufHl2TKcOypxQDjZ0WOtxk/kbMnW
         L81F21z2h7Q/A==
Date:   Sat, 1 Apr 2023 11:58:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
Message-ID: <20230401115854.371a5b4c@kernel.org>
In-Reply-To: <c39312a2-4537-14b4-270c-9fe1fbb91e89@gmail.com>
References: <20230401051221.3160913-1-kuba@kernel.org>
        <20230401051221.3160913-2-kuba@kernel.org>
        <c39312a2-4537-14b4-270c-9fe1fbb91e89@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 1 Apr 2023 17:18:12 +0200 Heiner Kallweit wrote:
> > +#define __netif_tx_queue_maybe_wake(txq, get_desc, start_thrs, down_cond) \
> > +	({								\
> > +		int _res;						\
> > +									\
> > +		_res = -1;						\  
> 
> One more question: Don't we need a read memory barrier here to ensure
> get_desc is up-to-date?

CC: Alex, maybe I should not be posting after 10pm, with the missing v2
and sparse CC list.. :|

I was thinking about this too yesterday. AFAICT this implementation
could indeed result in waking even tho the queue is full on non-x86.
That's why the drivers have an extra check at the start of .xmit? :(

I *think* that the right ordering would be:

WRITE cons
mb()  # A
READ stopped
rmb() # C
READ prod, cons

And on the producer side (existing):

WRITE prod
READ prod, cons
mb()  # B
WRITE stopped
READ prod, cons

But I'm slightly afraid to change it, it's been working for over 
a decade :D

One neat thing that I noticed, which we could potentially exploit 
if we were to touch this code is that BQL already has a smp_mb() 
on the consumer side. So on any kernel config and driver which support
BQL we can use that instead of adding another barrier at #A.

It would actually be a neat optimization because right now, AFAICT,
completion will fire the # A -like barrier almost every time.

> > +		if (likely(get_desc > start_thrs))			\
> > +			_res = __netif_tx_queue_try_wake(txq, get_desc,	\
> > +							 start_thrs,	\
> > +							 down_cond);	\
> > +		_res;							\
> > +	})
