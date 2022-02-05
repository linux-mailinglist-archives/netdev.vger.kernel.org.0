Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB864AAC84
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 21:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381298AbiBEUgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 15:36:08 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:39548 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232428AbiBEUgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 15:36:08 -0500
Date:   Sat, 5 Feb 2022 21:36:05 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1644093366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=560cbxN7mKYo1ZjnfDECl4wv6yBbemNlcEq8eApjrmg=;
        b=sUipOuadgP+bmhmZbl3Tev+Kh6wONkj0ICpPs3vPEAxFvq3btg2jdeSe1BBznz0L2f5HLP
        rYfUM7/1cSfHsK+easkj0K7tWlyFSvW3G3eSlDW+G7GwPfO7Z6gpDkQNe7vrh47GYwZOd1
        I2qIfy42TmoAE39SMwP1moDPrwPhHGlnnb1h6av5IVZkWOEX+hm9ibgh86hjW98i42noEv
        8AqZX829cMzShAEoH7+V5FtzT54ND0SXJLkuyelCcFFODZtj9xBbZQdyfXkAXGnW6EEfKa
        zNisPPVP/T0E7a1lkpM8DbTLKJKqixDqvX9++mtf25V2f2u0+o2FHXBZyKjTDQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1644093366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=560cbxN7mKYo1ZjnfDECl4wv6yBbemNlcEq8eApjrmg=;
        b=sAtyET1A0Wt76uXkqVcl/txZ46Gsxx5lQS4hHRqHjxITVo68Nykmw5xSfhBeEAhTgs93zi
        2uK2ijbiv13ZerAg==
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
Message-ID: <Yf7ftf+6j52opu5w@linutronix.de>
References: <20220204201259.1095226-1-bigeasy@linutronix.de>
 <20220204201259.1095226-3-bigeasy@linutronix.de>
 <20220204201715.44f48f4f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220204201715.44f48f4f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-02-04 20:17:15 [-0800], Jakub Kicinski wrote:
> On Fri,  4 Feb 2022 21:12:58 +0100 Sebastian Andrzej Siewior wrote:
> > +int __netif_rx(struct sk_buff *skb)
> > +{
> > +	int ret;
> > +
> > +	trace_netif_rx_entry(skb);
> > +	ret = netif_rx_internal(skb);
> > +	trace_netif_rx_exit(ret);
> > +	return ret;
> > +}
> 
> Any reason this is not exported? I don't think there's anything wrong
> with drivers calling this function, especially SW drivers which already
> know to be in BH. I'd vote for roughly all of $(ls drivers/net/*.c) to
> get the same treatment as loopback.

Don't we end up in the same situation as netif_rx() vs netix_rx_ni()?

Sebastian
