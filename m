Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44A8291898
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 19:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgJRRTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 13:19:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbgJRRTu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 13:19:50 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DF1A2223F;
        Sun, 18 Oct 2020 17:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603041589;
        bh=3Q5FHZplMB5Vfvn4zxpHhyQoeHMO5TrTcAto1Ahhweo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0PFgeBKpDbmQRxHwLbzW4/LDVC8WzgEIT+QXQIiLbN+g0Nm0puFPIB0gxxjIpxT9l
         61EkJ03t09AmdhR0wZzA064BbYcIXV+U4dppmgC9VVTy/AUCdxJd5qTKm2J6knD9Ev
         SvGDPzX4DY0yVvOc2BUoNl21/k/Rqp06PF5JZtDA=
Date:   Sun, 18 Oct 2020 10:19:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Remove __napi_schedule_irqoff?
Message-ID: <20201018101947.419802df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <668a1291-e7f0-ef71-c921-e173d4767a14@gmail.com>
References: <01af7f4f-bd05-b93e-57ad-c2e9b8726e90@gmail.com>
        <20201017162949.0a6dd37a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89i+q=q_LNDzE23y74Codh5EY0HHi_tROsEL2yJAdRjh-vQ@mail.gmail.com>
        <668a1291-e7f0-ef71-c921-e173d4767a14@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 18 Oct 2020 10:20:41 +0200 Heiner Kallweit wrote:
> >> Otherwise a non-solution could be to make IRQ_FORCED_THREADING
> >> configurable.  
> > 
> > I have to say I do not understand why we want to defer to a thread the
> > hard IRQ that we use in NAPI model.
> >   
> Seems like the current forced threading comes with the big hammer and
> thread-ifies all hard irq's. To avoid this all NAPI network drivers
> would have to request the interrupt with IRQF_NO_THREAD.

Right, it'd work for some drivers. Other drivers try to take spin locks
in their IRQ handlers.

What gave me a pause was that we have a busy loop in napi_schedule_prep:

bool napi_schedule_prep(struct napi_struct *n)
{
	unsigned long val, new;

	do {
		val = READ_ONCE(n->state);
		if (unlikely(val & NAPIF_STATE_DISABLE))
			return false;
		new = val | NAPIF_STATE_SCHED;

		/* Sets STATE_MISSED bit if STATE_SCHED was already set
		 * This was suggested by Alexander Duyck, as compiler
		 * emits better code than :
		 * if (val & NAPIF_STATE_SCHED)
		 *     new |= NAPIF_STATE_MISSED;
		 */
		new |= (val & NAPIF_STATE_SCHED) / NAPIF_STATE_SCHED *
						   NAPIF_STATE_MISSED;
	} while (cmpxchg(&n->state, val, new) != val);

	return !(val & NAPIF_STATE_SCHED);
}


Dunno how acceptable this is to run in an IRQ handler on RT..
