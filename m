Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4012129EBCD
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 13:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgJ2MZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 08:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbgJ2MZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 08:25:17 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DAFBC0613CF
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 05:25:17 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603974315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D6lVUXgumZTGyTocJvgeV8Nt0tZaaH527aV4amDbKcA=;
        b=RjAQs3YcSZkJwJL2WOkAGZUyp0lU3LKmcdchxi+ruOkb0ZiwIrpfhgBOZYHQ320TTAhTwg
        YpFD4WmMFMWMr9py3AvSAGx4QoY5u0szG6RaBHk64VK4ogJ+lBtTOakHIBAtLntnmHVFl0
        +o7WdbG7DQmSrZqgZN8udZe3Ga+WkDFxjpGRlzITj6lGmQLgHT6w1CZeerrGIRbleZ0WbU
        L2YL/N/WucChoKsYbrjiH/KXTOXTtYcF0BWH+naCy5Lr55y4tvFZ5ZF/NrgxYwXAm9X00G
        FAWQcNlVjv4E8HCLjgRehkUy+2VH4FhutiwwPdYNmQxZFUts5Q+2be1PDXR85w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603974315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D6lVUXgumZTGyTocJvgeV8Nt0tZaaH527aV4amDbKcA=;
        b=Yi93H+WDbOourYqPT/AkP2jWcn58pYb9htNn2MxNcLAcm9UCg5X1vi1BrCOTNnl0wj3zmX
        1R2mX+JIScARWDCQ==
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Serge Belyshev <belyshev@depni.sinp.msu.ru>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net] r8169: fix operation under forced interrupt threading
In-Reply-To: <b976846d-f40e-961f-6a3e-920fd5bf1add@gmail.com>
References: <4d3ef84a-c812-5072-918a-22a6f6468310@gmail.com> <877drabmoq.fsf@depni.sinp.msu.ru> <f0d713d2-6dc4-5246-daca-54811825e064@gmail.com> <20201028162929.5f250d12@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <a37b2cdf-97c4-8d13-2a49-d4f8c0b43f04@gmail.com> <87y2jpe5by.fsf@nanos.tec.linutronix.de> <b976846d-f40e-961f-6a3e-920fd5bf1add@gmail.com>
Date:   Thu, 29 Oct 2020 13:25:15 +0100
Message-ID: <87v9etdxsk.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29 2020 at 11:19, Heiner Kallweit wrote:
> On 29.10.2020 10:42, Thomas Gleixner wrote:
> Correct, just that the legacy PCI interrupt scenario doesn't affect old
> systems/devices only. Users may run the system with nomsi for
> whatever reason and we need to be prepared.
>
> We could add handling for (pcidev->msi_enabled || pcidev->msix_enabled),
> but this would look somewhat hacky to me.

Well, there are quite some drivers which differentiate between MSI and
legacy interrupts, most of them because MSI allows them to split
handlers. So it's not completely insane.

Thanks,

        tglx
