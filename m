Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30F4717C8A8
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 00:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgCFXEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 18:04:30 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54634 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgCFXEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 18:04:30 -0500
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jAM0Y-0005gY-Ev; Sat, 07 Mar 2020 00:03:54 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id C92FA104088; Sat,  7 Mar 2020 00:03:52 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Anchal Agarwal <anchalag@amazon.com>, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        linux-pm@vger.kernel.org, linux-mm@kvack.org, kamatam@amazon.com,
        sstabellini@kernel.org, konrad.wilk@oracle.com,
        roger.pau@citrix.com, axboe@kernel.dk, davem@davemloft.net,
        rjw@rjwysocki.net, len.brown@intel.com, pavel@ucw.cz,
        peterz@infradead.org, eduval@amazon.com, sblbir@amazon.com,
        anchalag@amazon.com, xen-devel@lists.xenproject.org,
        vkuznets@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dwmw@amazon.co.uk,
        fllinden@amaozn.com, benh@kernel.crashing.org
Subject: Re: [RFC PATCH v3 07/12] genirq: Shutdown irq chips in suspend/resume during hibernation
In-Reply-To: <e782c510916c8c05dc95ace151aba4eced207b31.1581721799.git.anchalag@amazon.com>
Date:   Sat, 07 Mar 2020 00:03:52 +0100
Message-ID: <87ftelaxwn.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Anchal Agarwal <anchalag@amazon.com> writes:

> There are no pm handlers for the legacy devices, so during tear down
> stale event channel <> IRQ mapping may still remain in the image and
> resume may fail. To avoid adding much code by implementing handlers for
> legacy devices, add a new irq_chip flag IRQCHIP_SHUTDOWN_ON_SUSPEND which
> when enabled on an irq-chip e.g xen-pirq, it will let core suspend/resume
> irq code to shutdown and restart the active irqs. PM suspend/hibernation
> code will rely on this.
> Without this, in PM hibernation, information about the event channel
> remains in hibernation image, but there is no guarantee that the same
> event channel numbers are assigned to the devices when restoring the
> system. This may cause conflict like the following and prevent some
> devices from being restored correctly.

The above is just an agglomeration of words and acronyms and some of
these sentences do not even make sense. Anyone who is not aware of event
channels and whatever XENisms you talk about will be entirely
confused. Changelogs really need to be understandable for mere mortals
and there is no space restriction so acronyms can be written out.

Something like this:

  Many legacy device drivers do not implement power management (PM)
  functions which means that interrupts requested by these drivers stay
  in active state when the kernel is hibernated.

  This does not matter on bare metal and on most hypervisors because the
  interrupt is restored on resume without any noticable side effects as
  it stays connected to the same physical or virtual interrupt line.

  The XEN interrupt mechanism is different as it maintains a mapping
  between the Linux interrupt number and a XEN event channel. If the
  interrupt stays active on hibernation this mapping is preserved but
  there is unfortunately no guarantee that on resume the same event
  channels are reassigned to these devices. This can result in event
  channel conflicts which prevent the affected devices from being
  restored correctly.

  One way to solve this would be to add the necessary power management
  functions to all affected legacy device drivers, but that's a
  questionable effort which does not provide any benefits on non-XEN
  environments.

  The least intrusive and most efficient solution is to provide a
  mechanism which allows the core interrupt code to tear down these
  interrupts on hibernation and bring them back up again on resume. This
  allows the XEN event channel mechanism to assign an arbitrary event
  channel on resume without affecting the functionality of these
  devices.
  
  Fortunately all these device interrupts are handled by a dedicated XEN
  interrupt chip so the chip can be marked that all interrupts connected
  to it are handled this way. This is pretty much in line with the other
  interrupt chip specific quirks, e.g. IRQCHIP_MASK_ON_SUSPEND.

  Add a new quirk flag IRQCHIP_SHUTDOWN_ON_SUSPEND and add support for
  it the core interrupt suspend/resume paths.

Hmm?

> Signed-off-by: Anchal Agarwal <anchalag@amazon.com>
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>

Not that I care much, but now that I've written both the patch and the
changelog you might change that attribution slightly. For completeness
sake:

 Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Thanks,

        tglx
