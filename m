Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3064838D010
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 23:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhEUVuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 17:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhEUVuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 17:50:11 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E727C061574;
        Fri, 21 May 2021 14:48:47 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1621633723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/+S8LTQNiG8i9DExgcVWsWx6U3U7vi+PRUnPuD/CDDg=;
        b=MpR7WhOyoJvBu9w7C3xfGoz0uwROzPNODcrPkb6Eu+Tyo5nrZ7nd0Xs3F7kllLesJ2CtCx
        rkuTb3JESWsKOFBUx4dFUdG4FCZG4SoziwDTEM52Y9DU7FTnJQslfOHkWKJSpnMJDGIzUU
        OG8f7A6FSbfF23uysmfoIeyU/DTcECF6Hxl9ur3UFtrX+m6wvQT53T7mnqupOV58JWjynY
        1UiyBovgzBUTzkZZAhqZJKgksdxRXJPYQ3HEeF+wMTTPmUyjR9i3kMhLDtlgQHzMw+o8Js
        SHWhabAKFfs0w3j4lCJmtYNkKMxOIFZoUQIwx+puNK1XHU9mf1GX866A6b718A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1621633723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/+S8LTQNiG8i9DExgcVWsWx6U3U7vi+PRUnPuD/CDDg=;
        b=Ug5aL3BaELpvg/OrbwBRE30R+5KHf653uC6Z2QkOC3VWj6yCx/fkMy8YHUjo7RwS3H5JK3
        QN+PDqVGRgtzb2BQ==
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
Subject: Re: [PATCH] genirq: Provide new interfaces for affinity hints
In-Reply-To: <CAFki+LkqBHnVYB5VBx_8Ch0u8RfXrJsRzxyuDfHhbR-dCeN3Lg@mail.gmail.com>
References: <20210504092340.00006c61@intel.com> <87pmxpdr32.ffs@nanos.tec.linutronix.de> <CAFki+Lkjn2VCBcLSAfQZ2PEkx-TR0Ts_jPnK9b-5ne3PUX37TQ@mail.gmail.com> <87im3gewlu.ffs@nanos.tec.linutronix.de> <CAFki+L=gp10W1ygv7zdsee=BUGpx9yPAckKr7pyo=tkFJPciEg@mail.gmail.com> <CAFki+L=eQoMq+mWhw_jVT-biyuDXpxbXY5nO+F6HvCtpbG9V2w@mail.gmail.com> <CAFki+LkB1sk3mOv4dd1D-SoPWHOs28ZwN-PqL_6xBk=Qkm40Lw@mail.gmail.com> <87zgwo9u79.ffs@nanos.tec.linutronix.de> <87wnrs9tvp.ffs@nanos.tec.linutronix.de> <CAFki+LkqBHnVYB5VBx_8Ch0u8RfXrJsRzxyuDfHhbR-dCeN3Lg@mail.gmail.com>
Date:   Fri, 21 May 2021 23:48:43 +0200
Message-ID: <87bl93ahc4.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 21 2021 at 12:13, Nitesh Lal wrote:
> On Fri, May 21, 2021 at 8:03 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>> Provide new interfaces:
>>
>>   irq_update_affinity_hint() - Only sets the affinity hint pointer
>>   irq_apply_affinity_hint()  - Set the pointer and apply the affinity to
>>                                the interrupt
>>
>
> Any reason why you ruled out the usage of irq_set_affinity_and_hint()?
> IMHO the latter makes it very clear what the function is meant to do.

You're right. I was trying to phase the existing hint setter out, but
that's probably pointless overengineering for no real value. Let me redo
that.

Thanks,

        tglx
