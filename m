Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3D7E29DAC3
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390454AbgJ1Xa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 19:30:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390451AbgJ1X3b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 19:29:31 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 395B920796;
        Wed, 28 Oct 2020 23:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603927770;
        bh=RBmiCg2iY5wMNrfq99VYOhjDoOf9TNQEmiBbIwOu0qg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qHgTVw1Y7hgAKBS4tUG9XlqaBQZzPUJxXzd+W0hg2RkOA8FjP6lVaIx4D5LBri0s2
         mG9iy6N78lRVg+0g41f2LCHtadE6MBxjOMAHtAsPA8p4nsZiibdOc8/uBc5509LYC7
         5z3Nq/PdK8IDSle6poFslYGM79bRha1y7HNVdyOg=
Date:   Wed, 28 Oct 2020 16:29:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Serge Belyshev <belyshev@depni.sinp.msu.ru>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net] r8169: fix operation under forced interrupt
 threading
Message-ID: <20201028162929.5f250d12@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <f0d713d2-6dc4-5246-daca-54811825e064@gmail.com>
References: <4d3ef84a-c812-5072-918a-22a6f6468310@gmail.com>
        <877drabmoq.fsf@depni.sinp.msu.ru>
        <f0d713d2-6dc4-5246-daca-54811825e064@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Oct 2020 13:17:58 +0100 Heiner Kallweit wrote:
> On 28.10.2020 12:43, Serge Belyshev wrote:
> >> For several network drivers it was reported that using
> >> __napi_schedule_irqoff() is unsafe with forced threading. One way to
> >> fix this is switching back to __napi_schedule, but then we lose the
> >> benefit of the irqoff version in general. As stated by Eric it doesn't
> >> make sense to make the minimal hard irq handlers in drivers using NAPI
> >> a thread. Therefore ensure that the hard irq handler is never
> >> thread-ified.
> >>
> >> Fixes: 9a899a35b0d6 ("r8169: switch to napi_schedule_irqoff")
> >> Link: https://lkml.org/lkml/2020/10/18/19
> >> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> >> ---
> >>  drivers/net/ethernet/realtek/r8169_main.c | 8 ++++----
> >>  1 file changed, 4 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> >> index 7d366b036..3b6ddc706 100644
> >> --- a/drivers/net/ethernet/realtek/r8169_main.c
> >> +++ b/drivers/net/ethernet/realtek/r8169_main.c  
> > ...
> > 
> > Hi!  This patch actually breaks r8169 with threadirqs on an old box
> > where it was working before:
> > 
> > [    0.000000] DMI: Gigabyte Technology Co., Ltd. GA-MA790FX-DQ6/GA-MA790FX-DQ6, BIOS F7g 07/19/2010
> > ...
> > [    1.072676] r8169 0000:02:00.0 eth0: RTL8168b/8111b, 00:1a:4d:5d:6b:c3, XID 380, IRQ 18
> > ...
> > [    8.850099] genirq: Flags mismatch irq 18. 00010080 (eth0) vs. 00002080 (ahci[0000:05:00.0])
> > 
> > (error is reported to userspace, interface failed to bring up).
> > Reverting the patch fixes the problem.
> >   
> Thanks for the report. On this old chip version MSI is unreliable,
> therefore r8169 falls back to a PCI legacy interrupt. On your system
> this PCI legacy interrupt seems to be shared between network and
> disk. Then the IRQ core tries to threadify the disk interrupt
> (setting IRQF_ONESHOT), whilst the network interrupt doesn't have
> this flag set. This results in the flag mismatch error.
> 
> Maybe, if one source of a shared interrupt doesn't allow forced
> threading, this should be applied to the other sources too.
> But this would require a change in the IRQ core, therefore
> +Thomas to get his opinion on the issue.

Other handles may take spin_locks, which will sleep on RT.

I guess we may need to switch away from the _irqoff() variant for
drivers with IRQF_SHARED after all :(
