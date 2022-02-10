Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5496A4B1695
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 20:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237925AbiBJTwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 14:52:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234231AbiBJTwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 14:52:41 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3947192;
        Thu, 10 Feb 2022 11:52:41 -0800 (PST)
Date:   Thu, 10 Feb 2022 20:52:37 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1644522759;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Oe/W6A7IFgXds0DPkhvExNJ6cgL10GHuQenrKvbMYeA=;
        b=4XBv8hAjdjZXffVMmR3WTiL3jmIsjmCpbZcKrTVB6r18AoICePYbD5xR1CdZ9iDWeuoSeg
        NdVT0pppezWQKu8e0gMeHZfjNwKW3DoZmRkrq2akLTLQXp/6ZgjcWmCalEGNrRnb4xfbYT
        hFqplTC4riWNMZwmfS0yMSCJ3O4lnyLspOkgiZiRyYcmOrFlilrK5VgmqT6BEaAH4wCfgJ
        RICa+2i61Hv/E17OaG64tXaGMXYdOo57XXRkwGgi+St8SuiwfxEClJaB4XFzNnXMNdwGv7
        byA2VKfcAydtsbu9QqdP4pm0vwUMjsNM0kIdT8grF9jrP46fm6XvRy7FgMovOQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1644522759;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Oe/W6A7IFgXds0DPkhvExNJ6cgL10GHuQenrKvbMYeA=;
        b=kxTBBGbHDqEtxppR4zqmF0aOFlB3ggETYwWCB19N4vK5nrx5onI0ntsKTUCagVsxGEHXt+
        2IAGmgRs2+eKrHBg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: Re: [PATCH net-next v2 2/3] net: dev: Makes sure netif_rx() can be
 invoked in any context.
Message-ID: <YgVtBQdHZdvrzQp7@linutronix.de>
References: <20220204201259.1095226-1-bigeasy@linutronix.de>
 <20220204201259.1095226-3-bigeasy@linutronix.de>
 <20220204201715.44f48f4f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <Yf7ftf+6j52opu5w@linutronix.de>
 <20220207084717.5b7126e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YgUDiE4FTsdwdVSH@linutronix.de>
 <20220210101330.47165ae0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220210101330.47165ae0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-02-10 10:13:30 [-0800], Jakub Kicinski wrote:
> > So we do netif_rx_backlog() with the bh disable+enable and
> > __netif_rx_backlog() without it and export both tree wide?
> 
> At a risk of confusing people about the API we could also name the
> "non-super-optimized" version netif_rx(), like you had in your patch.
> Grepping thru the drivers there's ~250 uses so maybe we don't wanna
> touch all that code. No strong preference, I just didn't expect to 
> see __netif_rx_backlog(), but either way works.

So let me keep the naming as-is, export __netif_rx() and update the
kernel doc with the bits about backlog.
After that if we are up to rename the function in ~250 drivers then I
should be simpler.

> > It would make it more obvious indeed. Could we add
> > 	WARN_ON_ONCE(!(hardirq_count() | softirq_count()))
> > to the shortcut to catch the "you did it wrong folks"? This costs me
> > about 2ns.
> 
> Modulo lockdep_..(), so we don't have to run this check on prod kernels?

I was worried a little about the corner cases but then lockdep is your
friend and you should test your code. Okay.

Sebastian
