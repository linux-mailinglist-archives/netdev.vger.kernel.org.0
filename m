Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB69E4A874A
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 16:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351656AbiBCPKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 10:10:41 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:53944 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237585AbiBCPKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 10:10:41 -0500
Date:   Thu, 3 Feb 2022 16:10:38 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643901040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fYXrDuFRXBBNMfCcnLUf/H7szb2aMihApRZq+hu5ZW8=;
        b=12d7UYzGB54nsjoxoS7Rd1yhW64kMf/42ZiLuyln5fE06xkzZmVoZq70Gh9wtRMhTtr6U1
        D9mHnAEfD55hGVKq3uQzXQ+ydUzzUnGF+gi+Fz6REmRrUUqSsfNkcScLx6PDWhbLrDPB7m
        bGD0LYaPPez//IWLuBN1aXhhkznGPDTxU26r1SdbeLVZ0fCGCwGDCr13+lhWFyWcE/7YK1
        pttGMTCIrzHQHocFofDvjdXj3zr3sxhhIO2bc6NN/4iBmx9qZ4k8LCocAcbIKEH3jgkAcc
        +eTCWbwvUIrHxF6ln0tb6tx6bMxfQ/ed0HsRzy87jl7FQZiGmI1x6zblSnT8sQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643901040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fYXrDuFRXBBNMfCcnLUf/H7szb2aMihApRZq+hu5ZW8=;
        b=4X4Qb2qADonekjerDY8t4eQOFB+rjfq7AyQJDpFKhJarnFbihoTU0UHgdHpzyUaM2LwccV
        7gx/4ZYFeSNdAkAA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Eric Dumazet <edumazet@google.com>
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next 3/4] net: dev: Makes sure netif_rx() can be
 invoked in any context.
Message-ID: <YfvwbsKm4XtTUlsx@linutronix.de>
References: <20220202122848.647635-1-bigeasy@linutronix.de>
 <20220202122848.647635-4-bigeasy@linutronix.de>
 <CANn89iLVPnhybrdjRh6ccv6UZHW-_W0ZHRO5c7dnWU44FUgd_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANn89iLVPnhybrdjRh6ccv6UZHW-_W0ZHRO5c7dnWU44FUgd_g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-02-02 09:43:14 [-0800], Eric Dumazet wrote:
> Maybe worth mentioning this commit will show a negative impact, for
> network traffic
> over loopback interface.
> 
> My measure of the cost of local_bh_disable()/local_bh_enable() is ~6
> nsec on one of my lab x86 hosts.

So you are worried that 
    dev_loopback_xmit() -> netif_rx_ni()

becomes
    dev_loopback_xmit() -> netif_rx()

and by that 6nsec slower because of that bh off/on? Can these 6nsec get
a little lower if we substract the overhead of preempt-off/on? 
But maybe I picked the wrong loopback here.

> Perhaps we could have a generic netif_rx(), and a __netif_rx() for the
> virtual drivers (lo and maybe tunnels).
> 
> void __netif_rx(struct sk_buff *skb);
> 
> static inline int netif_rx(struct sk_buff *skb)
> {
>    int res;
>     local_bh_disable();
>     res = __netif_rx(skb);
>   local_bh_enable();
>   return res;
> }

But what is __netif_rx() doing? netif_rx_ni() has this part:

|       preempt_disable();
|       err = netif_rx_internal(skb);
|       if (local_softirq_pending())
|               do_softirq();
|       preempt_enable();

to ensure that smp_processor_id() and friends are quiet plus any raised
softirqs are processed. With the current netif_rx() we end up with:

|       local_bh_disable();
|       ret = netif_rx_internal(skb);
|       local_bh_enable();

which provides the same. Assuming __netif_rx() as:

| int __netif_rx(skb)
| {
|         trace_netif_rx_entry(skb);
| 
|         ret = netif_rx_internal(skb);
|         trace_netif_rx_exit(ret);
| 
|         return ret;
| }

and the loopback interface is not invoking this in_interrupt() context.

Sebastian
