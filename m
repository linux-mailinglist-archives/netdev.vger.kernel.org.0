Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADAB296B94
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 10:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S460925AbgJWI6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 04:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S460767AbgJWI6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 04:58:49 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42A1C0613D2;
        Fri, 23 Oct 2020 01:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=r01fJA7OgsGuj6qzJJYCZlHCDBRSDDX9mtEwK883Jsg=; b=T18SePZ/KnrnsQ8hzb0a3g6Xkt
        Vehej4wSMVXf5y+ldujA4vXtiHCOz5rZuc/CjU9b2bmIXiexcYDMKBNZMR6WJxaKZ3jKiiTmFc5Pv
        GfD458ysnnAAoGqLRFI/8Rc1AiqDFaI86AHsIfFlJTEsULAXd7Ur/l2yOj+0Fkmw6rL68Cle5JPN+
        p5S6vkP0g/42N0lf/mYzCog+x3TsXfEZwaiRI0j5Fj97tjjOqmw3SGXPQt8obGn5OtKowuGQc1NL3
        XW5dqOp8xrDXnJpjF+/RkxRK88spY0bT3XkG9J4WGC51fT9Siocgbz+Y0HCyWIdMW0rmqdoEv9GNF
        uWGzdZjQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kVsu5-0005Ug-Lr; Fri, 23 Oct 2020 08:58:29 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id AD926304D28;
        Fri, 23 Oct 2020 10:58:26 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 9D2D72BB222F7; Fri, 23 Oct 2020 10:58:26 +0200 (CEST)
Date:   Fri, 23 Oct 2020 10:58:26 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>, helgaas@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        frederic@kernel.org, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        jlelli@redhat.com, hch@infradead.org, bhelgaas@google.com,
        mike.marciniszyn@intel.com, dennis.dalessandro@intel.com,
        thomas.lendacky@amd.com, jiri@nvidia.com, mingo@redhat.com,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        lgoncalv@redhat.com
Subject: Re: [PATCH v4 4/4] PCI: Limit pci_alloc_irq_vectors() to
 housekeeping CPUs
Message-ID: <20201023085826.GP2611@hirez.programming.kicks-ass.net>
References: <20200928183529.471328-5-nitesh@redhat.com>
 <20201016122046.GP2611@hirez.programming.kicks-ass.net>
 <79f382a7-883d-ff42-394d-ec4ce81fed6a@redhat.com>
 <20201019111137.GL2628@hirez.programming.kicks-ass.net>
 <20201019140005.GB17287@fuller.cnet>
 <20201020073055.GY2611@hirez.programming.kicks-ass.net>
 <078e659e-d151-5bc2-a7dd-fe0070267cb3@redhat.com>
 <20201020134128.GT2628@hirez.programming.kicks-ass.net>
 <6736e643-d4ae-9919-9ae1-a73d5f31463e@redhat.com>
 <260f4191-5b9f-6dc1-9f11-085533ac4f55@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <260f4191-5b9f-6dc1-9f11-085533ac4f55@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 01:47:14PM -0400, Nitesh Narayan Lal wrote:

> Hi Peter,
>=20
> So based on the suggestions from you and Thomas, I think something like t=
he
> following should do the job within pci_alloc_irq_vectors_affinity():
>=20
> + =A0 =A0 =A0 if (!pci_is_managed(dev) && (hk_cpus < num_online_cpus()))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 max_vecs =3D clamp(hk_cpus, min_vecs, max_v=
ecs);
>=20
> I do know that you didn't like the usage of "hk_cpus < num_online_cpus()"
> and to an extent I agree that it does degrade the code clarity.

It's not just code clarity; I simply don't understand it. It feels like
a band-aid that breaks thing.

At the very least it needs a ginormous (and coherent) comment that
explains:

 - the interface
 - the usage
 - this hack

> However, since there is a certain inconsistency in the number of vectors
> that drivers request through this API IMHO we will need this, otherwise
> we could cause an impact on the drivers even in setups that doesn't
> have any isolated CPUs.

So shouldn't we then fix the drivers / interface first, to get rid of
this inconsistency?

> If you agree, I can send the next version of the patch-set.

Well, it's not just me you have to convince.
