Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70CB250A634
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 18:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242681AbiDUQy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 12:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240918AbiDUQyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 12:54:25 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0D348E70
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 09:51:34 -0700 (PDT)
Date:   Thu, 21 Apr 2022 18:51:31 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1650559893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GiQbwXboccH1cIVt6PdCaQeGPxjA2N3J9QaPqp3Pof0=;
        b=OFQjWltgrEjwxICRSGMaODCjXGlCN81VZ40TMW1VaKOa8CHfIw4a1l0ZPMOD2Ey6/rjJS9
        hlDuaWuJ88RcjLyBbNy9+FZtbiMRZatoD0YbyNc2Ob3iJw5cGap9aner/S7FDHM9ELz9pX
        wEhMHNSFOHVzr2P0xaxc2ZigGibFjKhZLHQ3n19bOcuxfpj0yqYdoH0NSt1abTRtz5xjoY
        9a3s8qiA4Oc09buB4G2IuGpXeuaHPZ0SLbTIRwoqq9izvEvZzmAlBIGP7zr5uVtdghsh/6
        ev4lL/DrLoNTUOaK9XfmUIeQomn0arwVsPR6pSQZHv9i8QdU4jPhm4owwfh/oA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1650559893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GiQbwXboccH1cIVt6PdCaQeGPxjA2N3J9QaPqp3Pof0=;
        b=DVcTnpv0aYcaJVhpskG/ow4gMLUcAZdz+GVSM15aQbdGN/8gSIMRhlBWKiT85iLqbbvjhM
        fF4Bjdv18g5PH7Aw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH net] net: Use this_cpu_inc() to increment net->core_stats
Message-ID: <YmGLkz+dIBb5JjFF@linutronix.de>
References: <YmFjdOp+R5gVGZ7p@linutronix.de>
 <CANn89iKjSmnTSzzHdnP-HEYMajrz+MOrjFooaMFop4Vo43kLdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANn89iKjSmnTSzzHdnP-HEYMajrz+MOrjFooaMFop4Vo43kLdg@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-21 09:06:05 [-0700], Eric Dumazet wrote:
> On Thu, Apr 21, 2022 at 7:00 AM Sebastian Andrzej Siewior
> <bigeasy@linutronix.de> wrote:
> >
> 
> >                 for_each_possible_cpu(i) {
> >                         core_stats = per_cpu_ptr(p, i);
> > -                       storage->rx_dropped += local_read(&core_stats->rx_dropped);
> > -                       storage->tx_dropped += local_read(&core_stats->tx_dropped);
> > -                       storage->rx_nohandler += local_read(&core_stats->rx_nohandler);
> > +                       storage->rx_dropped += core_stats->rx_dropped;
> > +                       storage->tx_dropped += core_stats->tx_dropped;
> > +                       storage->rx_nohandler += core_stats->rx_nohandler;
> 
> I think that one of the reasons for me to use  local_read() was that
> it provided what was needed to avoid future syzbot reports.

syzbot report due a plain read of a per-CPU variable which might be
modified?

> Perhaps use READ_ONCE() here ?
> 
> Yes, we have many similar folding loops that are  simply assuming
> compiler won't do stupid things.

I wasn't sure about that and added PeterZ to do some yelling here just
in case. And yes, we have other sites doing exactly that. In
   Documentation/core-api/this_cpu_ops.rst
there is nothing about remote-READ-access (only that there should be no
writes (due to parallel this_cpu_inc() on the local CPU)). I know that a
32bit write can be optimized in two 16bit writes in certain cases but a
read is a read.
PeterZ? :)

Sebastian
