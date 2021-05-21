Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F84138C9DB
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 17:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236875AbhEUPRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 11:17:24 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:54568 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbhEUPRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 11:17:18 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1621610153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7rDRNMv1/hXibroql/UgiqWQxCjjntQmsL2o4JvFzco=;
        b=CR2dKo3U/qEBXxRraK/8180LCq2JsVkgxoQhDex49QqNVsA8WjfbCTuVAvD4DqbhzqEg1p
        ZwJgdt4G35FTyS8UDSsCt1txkl1Bie1PciZkWfLORal7+xPmjMv41Jqz5tn3bG9iyWZ7gq
        /QMT/Yowkk4ZN1Ngvzy71tZEyQsFX7Mvkc3DtD8wskLXULMGAXIt5jNgrSIQIiAf7DU94i
        Sc4sTbCpSUws0yW4AJeK1viYb1VQzQyDUzMVuBmzHBg2zyPGBQppD6I1kBmKwrbBiW7QpR
        KWkhnjqCGGhNCPBgpqfnuZXZg2aoke1az2/RnVU3FxAZRCdbtqVdk6AXgIMe+w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1621610153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7rDRNMv1/hXibroql/UgiqWQxCjjntQmsL2o4JvFzco=;
        b=KUni+pfxwwfjisVYWwUO6XqqoJkOc9cJl+l6wjG0Pf13ZeZyiU+ahF3JQji/TLv5FM1TnR
        p5NROJTbK6SxNWBA==
To:     Nitesh Lal <nilal@redhat.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, jbrandeb@kernel.org,
        "frederic\@kernel.org" <frederic@kernel.org>,
        "juri.lelli\@redhat.com" <juri.lelli@redhat.com>,
        Alex Belits <abelits@marvell.com>,
        "linux-api\@vger.kernel.org" <linux-api@vger.kernel.org>,
        "bhelgaas\@google.com" <bhelgaas@google.com>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "rostedt\@goodmis.org" <rostedt@goodmis.org>,
        "peterz\@infradead.org" <peterz@infradead.org>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,
        "sfr\@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "stephen\@networkplumber.org" <stephen@networkplumber.org>,
        "rppt\@linux.vnet.ibm.com" <rppt@linux.vnet.ibm.com>,
        "jinyuqi\@huawei.com" <jinyuqi@huawei.com>,
        "zhangshaokun\@hisilicon.com" <zhangshaokun@hisilicon.com>,
        netdev@vger.kernel.org, chris.friesen@windriver.com,
        Marc Zyngier <maz@kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>, pjwaskiewicz@gmail.com
Subject: Re: [PATCH tip:irq/core v1] genirq: remove auto-set of the mask when setting the hint
In-Reply-To: <CAFki+LnKycMFYTGTswX9vpMepNiCW6BL5TFMTuKZSniab5=4SA@mail.gmail.com>
References: <20210504092340.00006c61@intel.com> <87pmxpdr32.ffs@nanos.tec.linutronix.de> <CAFki+Lkjn2VCBcLSAfQZ2PEkx-TR0Ts_jPnK9b-5ne3PUX37TQ@mail.gmail.com> <87im3gewlu.ffs@nanos.tec.linutronix.de> <CAFki+L=gp10W1ygv7zdsee=BUGpx9yPAckKr7pyo=tkFJPciEg@mail.gmail.com> <CAFki+L=eQoMq+mWhw_jVT-biyuDXpxbXY5nO+F6HvCtpbG9V2w@mail.gmail.com> <CAFki+LkB1sk3mOv4dd1D-SoPWHOs28ZwN-PqL_6xBk=Qkm40Lw@mail.gmail.com> <87zgwo9u79.ffs@nanos.tec.linutronix.de> <CAFki+LnKycMFYTGTswX9vpMepNiCW6BL5TFMTuKZSniab5=4SA@mail.gmail.com>
Date:   Fri, 21 May 2021 17:15:53 +0200
Message-ID: <87pmxk9kye.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 21 2021 at 09:46, Nitesh Lal wrote:
> On Fri, May 21, 2021 at 7:56 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>> >> - Driver use this API to force a certain affinity mask
>> >>   + In this case we have to replace the API with the irq_force_affinity()
>>
>> irq_set_affinity() or irq_set_affinity_and_hint()
>
> Ah yes! my bad. _force_ doesn't check the mask against the online CPUs.
> Hmm, I didn't realize that you also added irq_set_affinity_and_hint()
> in your last patchset.

I did not. It just exposed irq_set_affinity().

See https://lore.kernel.org/r/87wnrs9tvp.ffs@nanos.tec.linutronix.de
for the new hint interface I came up with.

Thanks,

        tglx
