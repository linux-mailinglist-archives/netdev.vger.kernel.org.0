Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 725E64B0D79
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 13:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237982AbiBJMWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 07:22:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232743AbiBJMWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 07:22:35 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FBBE2631;
        Thu, 10 Feb 2022 04:22:36 -0800 (PST)
Date:   Thu, 10 Feb 2022 13:22:32 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1644495753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ly3/GBnNpjMpdrZvKsc6VwS5WfDdrVLH6rBEH5yz1a0=;
        b=hSrHZpkbnBJs2x5RcUX3I3PQYCu0NUtBVBv+Mu68/coqZePr1W1j3pAEcVBiGKkvfA07a9
        tEdyNeMhEUuQfml2IR7hpmq3HjHTinwjBkJYL4n6X0+4fxTpywMRDCEdaZhxDZjWF/7TmJ
        FZjhP74grDvNYTx2nB4VuhpQlgjaz6+vbBOAPwN9IEe1Q+cJhiZtMP6NmhQzNPFtUH4nzd
        c91H3gyLt/3qa0FERikrX04HyqlgePAtenD5t0Hj5p5q0PBF3ell249rv6lY59QUcTDEei
        F/TALcJR78kkSColUZXbzCHcDllZqtjP1uvuThKG0HKo8acZFdQwKzrNueWs/Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1644495753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ly3/GBnNpjMpdrZvKsc6VwS5WfDdrVLH6rBEH5yz1a0=;
        b=bm4uCox679/q89dXUm7N2j9jgBQvQxF1GpjfI6GXy+OdvtJyxuSVtdPKTmvYkZ+smANo86
        g+AekpepcyaRAxCw==
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
Message-ID: <YgUDiE4FTsdwdVSH@linutronix.de>
References: <20220204201259.1095226-1-bigeasy@linutronix.de>
 <20220204201259.1095226-3-bigeasy@linutronix.de>
 <20220204201715.44f48f4f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <Yf7ftf+6j52opu5w@linutronix.de>
 <20220207084717.5b7126e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220207084717.5b7126e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-02-07 08:47:17 [-0800], Jakub Kicinski wrote:
> On Sat, 5 Feb 2022 21:36:05 +0100 Sebastian Andrzej Siewior wrote:
> > On 2022-02-04 20:17:15 [-0800], Jakub Kicinski wrote:
> > > On Fri,  4 Feb 2022 21:12:58 +0100 Sebastian Andrzej Siewior wrote:  
> > > > +int __netif_rx(struct sk_buff *skb)
> > > > +{
> > > > +	int ret;
> > > > +
> > > > +	trace_netif_rx_entry(skb);
> > > > +	ret = netif_rx_internal(skb);
> > > > +	trace_netif_rx_exit(ret);
> > > > +	return ret;
> > > > +}  
> > > 
> > > Any reason this is not exported? I don't think there's anything wrong
> > > with drivers calling this function, especially SW drivers which already
> > > know to be in BH. I'd vote for roughly all of $(ls drivers/net/*.c) to
> > > get the same treatment as loopback.  
> > 
> > Don't we end up in the same situation as netif_rx() vs netix_rx_ni()?
> 
> Sort of. TBH my understanding of the motivation is a bit vague.
> IIUC you want to reduce the API duplication so drivers know what to
> do[1]. I believe the quote from Eric you put in the commit message
> pertains to HW devices, where using netif_rx() is quite anachronistic. 
> But software devices like loopback, veth or tunnels may want to go via
> backlog for good reasons. Would it make it better if we called
> netif_rx() netif_rx_backlog() instead? Or am I missing the point?

So we do netif_rx_backlog() with the bh disable+enable and
__netif_rx_backlog() without it and export both tree wide? It would make
it more obvious indeed. Could we add
	WARN_ON_ONCE(!(hardirq_count() | softirq_count()))
to the shortcut to catch the "you did it wrong folks"? This costs me
about 2ns.

TL;DR

The netix_rx_ni() is problematic on RT and I tried to do something about
it. I remembered from the in_atomic() cleanup that a few drivers got it
wrong (one way or another). We added also netif_rx_any_context() which
is used by some of the drivers (which is yet another entry point) while
the few other got fixed.
Then I stumbled over the thread where the entry (netif_rx() vs
netif_rx_ni()) was wrong and Dave suggested to have one entry point for
them all. This sounded like a good idea since it would eliminate the
several API entry points where things can go wrong and my RT trouble
would vanish in one go.
The part with deprecated looked promising but I didn't take into account
that the overhead for legitimate users (like the backlog or the software
tunnels you mention) is not acceptable.

Sebastian
