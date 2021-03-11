Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92278338143
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 00:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbhCKXPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 18:15:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:51260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231149AbhCKXPH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 18:15:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA99664F9E;
        Thu, 11 Mar 2021 23:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615504505;
        bh=m04taSMXm3AhxmHGaULowvdvBF63RxAdAiKnSRtdTDs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jbtgHNzGNaiZdUQBaalvxucdkmw+SqDO1jqxNGTY9qaCWdIh6tQanT4X2U7DJqngx
         6E8T/8A9mwgJZqaQ+7sHz03cAivyecSw1zq9BWgQf/vHyrPcqz33aDNASQSxIckfx/
         jDhry73Td6Q1yfhW51Z7wDI47XprTM6qxr3cJUWUu4vMAjaRNmjzDiHzxW7qC1B06r
         JDelJDR2UTgIZpsklN0MPZ/qaJUjB6RkcF7624eBdSnadQ1rn5HH1fPyHU/7h2LtGz
         13eYELzLbqEBOfMZz0dd6IjGAe47nHciHOwuMkgbPCRwioiM3C4qt921ThELbNxZbX
         RlAZXx+0pvBnA==
Message-ID: <2d02f09799f90c2c948c9156e2d81b0e1adedc27.camel@kernel.org>
Subject: Re: [RFC Patch v1 1/3] net: ena: implement local page cache (LPC)
 system
From:   Saeed Mahameed <saeed@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Matteo Croce <mcroce@microsoft.com>
Cc:     Shay Agroskin <shayagr@amazon.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Jubran, Samih" <sameehj@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>
Date:   Thu, 11 Mar 2021 15:15:03 -0800
In-Reply-To: <YEgpL4xYSa7/r38v@lunn.ch>
References: <20210309171014.2200020-1-shayagr@amazon.com>
         <20210309171014.2200020-2-shayagr@amazon.com>
         <67d3cf28-b1fd-ce51-5011-96ddd783dc71@gmail.com> <YEgpL4xYSa7/r38v@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-03-10 at 03:04 +0100, Andrew Lunn wrote:
> On Tue, Mar 09, 2021 at 06:57:06PM +0100, Eric Dumazet wrote:
> > 
> > 
> > On 3/9/21 6:10 PM, Shay Agroskin wrote:
> > > The page cache holds pages we allocated in the past during napi
> > > cycle,
> > > and tracks their availability status using page ref count.
> > > 
> > > The cache can hold up to 2048 pages. Upon allocating a page, we

2048 per core ? IMHO this is too much ! ideally you want twice the napi
budget.

you are trying to mitigate against TCP/L4 delays/congestion but this is
very prone to DNS attacks, if your memory allocators are under stress,
you shouldn't be hogging own pages and worsen the situation. 

> > > check
> > > whether the next entry in the cache contains an unused page, and
> > > if so
> > > fetch it. If the next page is already used by another entity or
> > > if it
> > > belongs to a different NUMA core than the napi routine, we
> > > allocate a
> > > page in the regular way (page from a different NUMA core is
> > > replaced by
> > > the newly allocated page).
> > > 
> > > This system can help us reduce the contention between different
> > > cores
> > > when allocating page since every cache is unique to a queue.
> > 
> > For reference, many drivers already use a similar strategy.
> 
> Hi Eric
> 
> So rather than yet another implementation, should we push for a
> generic implementation which any driver can use?
> 

We already have it:
https://www.kernel.org/doc/html/latest/networking/page_pool.html

also please checkout this fresh page pool extension, SKB buffer
recycling RFC, might be useful for the use cases ena are interested in

https://patchwork.kernel.org/project/netdevbpf/patch/20210311194256.53706-4-mcroce@linux.microsoft.com/



