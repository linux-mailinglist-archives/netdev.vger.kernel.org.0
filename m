Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C0F3811E5
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 22:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbhENUjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 16:39:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229780AbhENUj2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 16:39:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4153E6141F;
        Fri, 14 May 2021 20:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621024696;
        bh=eoJF/jUIlWKwg7KFkvrGsblQ9xJBG6MVGUhGPXUEPQk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OBs5Mo5Gck5k73UDl+GGA+wKuOk/kHYfqR1/bmOmyiL4f0zxM4umpyxiMRv3O2rmM
         WEPae9O9hhjHtNxd3sNcSiOSnCpvbI/ZjLQRr1GAvLXM1BztWs1u6TuqI+iAb4MhCf
         Ll+nMq4W8Pyv2I3zb1OEU7jA6Du05+yDiiWzyMa+RaUdIDWJ3Z5M54loHebBvvw/2N
         Lshni5YjbsPnfRCEo+o5TxzPhiQrjYveWXo71qdviwGici4BGg6Ls8EFeD8Y3UsFkz
         shzJ085XbIBzkIHLeYqwFUKE93Ygd3kJufghDcsZNXyEo0W5t8+7yzWg3V2a4dRu3I
         U9ADMS5y+6U7A==
Date:   Fri, 14 May 2021 13:38:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, sassmann@redhat.com,
        "David S. Miller" <davem@davemloft.net>, stable-rt@vger.kernel.org
Subject: Re: [PATCH net-next] net: Treat __napi_schedule_irqoff() as
 __napi_schedule() on PREEMPT_RT
Message-ID: <20210514133815.6a698aeb@kicinski-fedora-PC1C0HJN>
In-Reply-To: <87v97l2hrp.ffs@nanos.tec.linutronix.de>
References: <YJofplWBz8dT7xiw@localhost.localdomain>
        <20210512214324.hiaiw3e2tzmsygcz@linutronix.de>
        <87k0o360zx.ffs@nanos.tec.linutronix.de>
        <20210514115649.6c84fdc3@kicinski-fedora-PC1C0HJN>
        <87v97l2hrp.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 May 2021 22:16:10 +0200 Thomas Gleixner wrote:
> On Fri, May 14 2021 at 11:56, Jakub Kicinski wrote:
> > On Thu, 13 May 2021 00:28:02 +0200 Thomas Gleixner wrote:  
> >> Blame me for that decision.
> >> 
> >> No matter which variant we end up with, this needs to go into all stable
> >> RT kernels ASAP.  
> >
> > Mumble mumble. I thought we concluded that drivers used on RT can be
> > fixed, we've already done it for a couple drivers (by which I mean two).
> > If all the IRQ handler is doing is scheduling NAPI (which it is for
> > modern NICs) - IRQF_NO_THREAD seems like the right option.  
> 
> Yes. That works, but there are a bunch which do more than that IIRC.
> 
> > Is there any driver you care about that we can convert to using
> > IRQF_NO_THREAD so we can have new drivers to "do the right thing"
> > while the old ones depend on this workaround for now?  
> 
> The start of this thread was about i40e_msix_clean_rings() which
> probably falls under the IRQF_NO_THREAD category, but I'm sure that
> there are others. So I chose the safe way for RT for now.

Sounds reasonable. I'll send a patch with a new helper and convert 
an example driver I'm sure falls into the "napi_schedule(); return;"
category. I just want to make sure "the right thing to do" is
accessible for people writing new drivers.
