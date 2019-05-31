Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E013E31477
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 20:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfEaSOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 14:14:35 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:60512 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfEaSOf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 14:14:35 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1hWm2x-0005jr-Ko; Fri, 31 May 2019 20:14:31 +0200
Date:   Fri, 31 May 2019 20:14:31 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, tglx@linutronix.de,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 1/7] net: Don't disable interrupts in
 napi_alloc_frag()
Message-ID: <20190531181430.t4katzn66ajhfpgc@linutronix.de>
References: <20190529221523.22399-1-bigeasy@linutronix.de>
 <20190529221523.22399-2-bigeasy@linutronix.de>
 <6a2940ff-ade4-64b5-2014-4e0701c14b87@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6a2940ff-ade4-64b5-2014-4e0701c14b87@gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-05-29 15:48:51 [-0700], Eric Dumazet wrote:
> > +
> > +	fragsz = SKB_DATA_ALIGN(fragsz);
> > +	if (irqs_disabled()) {
> 
> 
> What is the difference between this prior test, and the following ?
> 
> if (in_irq() || irqs_disabled())
> 
> I am asking because I see the latter being used in __dev_kfree_skb_any()

in_irq() is always true in hardirq context which is true for non-NAPI
drivers. If in_irq() is true, irqs_disabled() will also be true.
So I *think* I could replace the irqs_disabled() check with in_irq()
which should be cheaper because it just checks the preempt counter.

Sebastian
