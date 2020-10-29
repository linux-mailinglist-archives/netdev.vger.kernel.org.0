Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0578F29E792
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 10:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgJ2Jm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 05:42:27 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:60264 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbgJ2Jm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 05:42:27 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603964545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sNSYAEdWrJ1xkZ1r90fG2WzUbalLDSTU2+9QTihgyFI=;
        b=PGVx1r1jbStpvh5Yv8tpkkyWZtGyH454muOv0i7BA62QvIFOgpdk1CrFcxxzzOUGRgDgpf
        Q5Po/PjRWMFlbA4t9dhTvQ9zOZgoPZeWkPrbEtbtrNYBbfnQdlwHV7uah2rnRGBNJV+xLU
        iA5flm3Du5cd6VAWP5DHmPotHgTPYPbEp8AJ2uzVOBrxuKJhy9zejCPHeU2H6gssqQMyW3
        QAlum3LoQkXbwHi3NhyQ3/DZbzMzVHHIbTMwZCswSwo0+YdBhI+4qhZjmZjJBvJTG237ev
        fX564zO8z68lKL/OoFAbfY3LHT3xt/gLHWsInZvaJAhq9AE5qsXVN3oyi5mw4Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603964545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sNSYAEdWrJ1xkZ1r90fG2WzUbalLDSTU2+9QTihgyFI=;
        b=aBV/wJbdlLBSgfOObd6bPytrxcV8EdAUNDqBf+iEcbVQRpxVZVhN5aHoKQhVpOkoztHb8g
        000rQi4T1yIMJpBg==
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Serge Belyshev <belyshev@depni.sinp.msu.ru>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net] r8169: fix operation under forced interrupt threading
In-Reply-To: <a37b2cdf-97c4-8d13-2a49-d4f8c0b43f04@gmail.com>
References: <4d3ef84a-c812-5072-918a-22a6f6468310@gmail.com> <877drabmoq.fsf@depni.sinp.msu.ru> <f0d713d2-6dc4-5246-daca-54811825e064@gmail.com> <20201028162929.5f250d12@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <a37b2cdf-97c4-8d13-2a49-d4f8c0b43f04@gmail.com>
Date:   Thu, 29 Oct 2020 10:42:25 +0100
Message-ID: <87y2jpe5by.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29 2020 at 09:42, Heiner Kallweit wrote:
> On 29.10.2020 00:29, Jakub Kicinski wrote:
>> Other handles may take spin_locks, which will sleep on RT.
>> 
>> I guess we may need to switch away from the _irqoff() variant for
>> drivers with IRQF_SHARED after all :(
>> 
> Right. Unfortunately that's a large number of drivers,
> e.g. pci_request_irq() sets IRQF_SHARED in general.

IRQF_SHARED is not the problem. It only becomes a problem when the
interrupt is actually shared which is only the case with the legacy PCI
interrupt. MSI[X] is not affected at all.

> But at least for now there doesn't seem to be a better way to deal
> with the challenges imposed by forced threading and shared irqs.

We still can do the static key trick, though it's admittedly hacky.

Thanks,

        tglx


