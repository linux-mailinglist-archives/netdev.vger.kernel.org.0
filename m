Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A5C28A831
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 18:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388037AbgJKQGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 12:06:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:60502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387799AbgJKQGX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 12:06:23 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3813120678;
        Sun, 11 Oct 2020 16:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602432382;
        bh=0pTIrX9OOi88NEgA5/B1qpPHXrYAtUk/EQDmA++8rfg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=curs9miwdNGXwW227Ox77jhLxuxvZqJYBGf0THsTih8EyPRna/vlPjhUXv+ZptM4U
         pC4azNuqNh+QQJkV0hUxcibYF1f9ivO0lONG3GxRernnQzhbAa37XWmz8XDCn9Q7UW
         I4Yxe82xhjMJbf2oJKhUy+FL0j0SDX9My/eSQUvI=
Date:   Sun, 11 Oct 2020 09:06:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     John Keeping <john@metanate.com>, netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH] net: stmmac: Don't call _irqoff() with hardirqs enabled
Message-ID: <20201011090620.48afafd7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <c73866a9-2ee8-b549-f578-75d62b9263b4@gmail.com>
References: <20201008162749.860521-1-john@metanate.com>
        <8036d473-68bd-7ee7-e2e9-677ff4060bd3@gmail.com>
        <20201009085805.65f9877a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <725ba7ca-0818-074b-c380-15abaa5d037b@gmail.com>
        <070b2b87-f38c-088d-4aaf-12045dbd92f7@gmail.com>
        <20201010082248.22cc7656@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <c73866a9-2ee8-b549-f578-75d62b9263b4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 11 Oct 2020 11:24:41 +0200 Heiner Kallweit wrote:
> >> qeth_qdio_poll
> >> netvsc_channel_cb
> >> napi_watchdog  
> > 
> > This one runs from a hrtimer, which I believe will be a hard irq
> > context on anything but RT. I could be wrong.
> >   
> 
> A similar discussion can be found e.g. here:
> https://lore.kernel.org/netdev/20191126222013.1904785-1-bigeasy@linutronix.de/
> However I don't see any actual outcome.

Interesting, hopefully Eric will chime in. I think the hrtimer issue
was solved. But I'm not actually seeing a lockdep_assert_irqs_disabled()
in __raise_softirq_irqoff() in net, so IDK what that's for?

In any case if NAPI thinks it has irqs off while they're not, and
interacts with other parts of the kernel we may be in for a game of
whack-a-mole. 

Perhaps a way around touching force_irqthreads directly in net/ would 
be some form of a helper like "theaded_local_irq_save" or such that'd
disable IRQs only if force_irqthreads == 1? Is that cheating? :)
