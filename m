Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177B429D583
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729936AbgJ1WEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:04:36 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:57432 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729925AbgJ1WE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:04:27 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603891466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eOuQuQdhsm+Y0qxN6wedgBFzwEY5p3W5bJ8c9ZupmOQ=;
        b=e8L47Fj9+8+VRb+cPKNJL06Tm2F/pM2xsnfuOXouWdxWrcdXSUeE/uyuUFO6dm288upWVp
        bH5WwbFlIWR1i3MRCXXgAEZuyi6otBjjUy/ioiYptWXQKAhSK0dewld8fYI8g3Btib0Ek4
        3MtmVGaEmUGjeXba8clzasFq/VEKUolPVAiN9jMoMZvHZ04EG0nsFjJzmEqpBqKiUYIHzs
        dGLH36kyvQog2PYvRZPcNWc42gqtO1sRyoHjFbfRrsRlpmuH6Qfx9J3Dh894ZBmX36RxFl
        ihHc7uph6RialeOipIiP8gTn7rnhFKjJTA3IJ1Q/SQU+9uepnpRuCWz1TqPC6w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603891466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eOuQuQdhsm+Y0qxN6wedgBFzwEY5p3W5bJ8c9ZupmOQ=;
        b=VADqFajD8odskZEaAgVk/RylunmkPGT7/MVp65KX+PI+fXkn4s58tHsmJSUACMGx1mIy8A
        n0FTiX55p4cdfgAA==
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Serge Belyshev <belyshev@depni.sinp.msu.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH net] r8169: fix operation under forced interrupt threading
In-Reply-To: <f0d713d2-6dc4-5246-daca-54811825e064@gmail.com>
References: <4d3ef84a-c812-5072-918a-22a6f6468310@gmail.com> <877drabmoq.fsf@depni.sinp.msu.ru> <f0d713d2-6dc4-5246-daca-54811825e064@gmail.com>
Date:   Wed, 28 Oct 2020 14:24:26 +0100
Message-ID: <87mu06fppx.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28 2020 at 13:17, Heiner Kallweit wrote:
> On 28.10.2020 12:43, Serge Belyshev wrote:
>>> For several network drivers it was reported that using
>>> __napi_schedule_irqoff() is unsafe with forced threading. One way to
>>> fix this is switching back to __napi_schedule, but then we lose the
>>> benefit of the irqoff version in general. As stated by Eric it doesn't
>>> make sense to make the minimal hard irq handlers in drivers using NAPI
>>> a thread. Therefore ensure that the hard irq handler is never
>>> thread-ified.
>> Hi!  This patch actually breaks r8169 with threadirqs on an old box
>> where it was working before:
>> 
>> [    0.000000] DMI: Gigabyte Technology Co., Ltd. GA-MA790FX-DQ6/GA-MA790FX-DQ6, BIOS F7g 07/19/2010
>> ...
>> [    1.072676] r8169 0000:02:00.0 eth0: RTL8168b/8111b, 00:1a:4d:5d:6b:c3, XID 380, IRQ 18
>> ...
>> [    8.850099] genirq: Flags mismatch irq 18. 00010080 (eth0) vs. 00002080 (ahci[0000:05:00.0])
>> 
>> (error is reported to userspace, interface failed to bring up).
>> Reverting the patch fixes the problem.
>> 
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

It's pretty simple. There is no way to fix that at the core
level. Shared interrupts suck and to make them work halfways correct the
sharing devices must have matching and non-competing flags.

Especially for threaded vs. non threaded case. Shared interrupts are
level triggered. So you have a conflict of interests:

The threaded handler requires that the interrupt line is masked until
the thread has completed otherwise the system will suffer an interrupt
storm. The non-threaded want's it to be unmasked after it finished.

Thanks,

        tglx

   
