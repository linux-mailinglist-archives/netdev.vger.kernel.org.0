Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7E2529263F
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 13:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgJSLMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 07:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgJSLMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 07:12:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABD1C0613CE;
        Mon, 19 Oct 2020 04:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=bDcR7UZAo6x2NnmYgmfbzx+iKi+io+kT/yc3B05Vq8w=; b=dG1bd3uiGTmLS2XdOdubnm/OuZ
        P6KPYF4d6TlO9l9Mb+ClxI4oDFFQ5B3Mo+4QAgnDkmkjXwq6mWp0jrROT9EsszcmuTVtMbtDz2Lj1
        Jx8bT3ltK/RIwsr2+zpgb0FbRMhnXDkbKvTI5uqMtTFpR5HqJBzjT06hOsBY1I2avywzAOMx3VoMQ
        T7MLozeyRJQW8bRXfQVDsGB83DngFBbJM4Gqc29tTjiEcYALeqKs8SGwpr+CeeUyKtNFHEC/v4kj6
        s8L3OjnxD95DBO+JIrIqg9o96iWAiQ/fua+8+9/FdXLDzEQ1iQKxaGH3zwQX07soYf/JPPOU0UCBC
        GDQRBFGQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kUT4m-0001kH-Q4; Mon, 19 Oct 2020 11:11:41 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A54873011E6;
        Mon, 19 Oct 2020 13:11:37 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8859420419078; Mon, 19 Oct 2020 13:11:37 +0200 (CEST)
Date:   Mon, 19 Oct 2020 13:11:37 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        frederic@kernel.org, mtosatti@redhat.com, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        helgaas@kernel.org, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, jlelli@redhat.com, hch@infradead.org,
        bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jiri@nvidia.com, mingo@redhat.com, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, lgoncalv@redhat.com
Subject: Re: [PATCH v4 4/4] PCI: Limit pci_alloc_irq_vectors() to
 housekeeping CPUs
Message-ID: <20201019111137.GL2628@hirez.programming.kicks-ass.net>
References: <20200928183529.471328-1-nitesh@redhat.com>
 <20200928183529.471328-5-nitesh@redhat.com>
 <20201016122046.GP2611@hirez.programming.kicks-ass.net>
 <79f382a7-883d-ff42-394d-ec4ce81fed6a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <79f382a7-883d-ff42-394d-ec4ce81fed6a@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 18, 2020 at 02:14:46PM -0400, Nitesh Narayan Lal wrote:
> >> +	hk_cpus =3D housekeeping_num_online_cpus(HK_FLAG_MANAGED_IRQ);
> >> +
> >> +	/*
> >> +	 * If we have isolated CPUs for use by real-time tasks, to keep the
> >> +	 * latency overhead to a minimum, device-specific IRQ vectors are mo=
ved
> >> +	 * to the housekeeping CPUs from the userspace by changing their
> >> +	 * affinity mask. Limit the vector usage to keep housekeeping CPUs f=
rom
> >> +	 * running out of IRQ vectors.
> >> +	 */
> >> +	if (hk_cpus < num_online_cpus()) {
> >> +		if (hk_cpus < min_vecs)
> >> +			max_vecs =3D min_vecs;
> >> +		else if (hk_cpus < max_vecs)
> >> +			max_vecs =3D hk_cpus;
> > is that:
> >
> > 		max_vecs =3D clamp(hk_cpus, min_vecs, max_vecs);
>=20
> Yes, I think this will do.
>=20
> >
> > Also, do we really need to have that conditional on hk_cpus <
> > num_online_cpus()? That is, why can't we do this unconditionally?
>=20
> FWIU most of the drivers using this API already restricts the number of
> vectors based on the num_online_cpus, if we do it unconditionally we can
> unnecessary duplicate the restriction for cases where we don't have any
> isolated CPUs.

unnecessary isn't really a concern here, this is a slow path. What's
important is code clarity.

> Also, different driver seems to take different factors into consideration
> along with num_online_cpus while finding the max_vecs to request, for
> example in the case of mlx5:
> MLX5_CAP_GEN(dev, num_ports) * num_online_cpus() +
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 MLX5_EQ_VEC_COMP_BASE
>=20
> Having hk_cpus < num_online_cpus() helps us ensure that we are only
> changing the behavior when we have isolated CPUs.
>=20
> Does that make sense?

That seems to want to allocate N interrupts per cpu (plus some random
static amount, which seems weird, but whatever). This patch breaks that.

So I think it is important to figure out what that driver really wants
in the nohz_full case. If it wants to retain N interrupts per CPU, and
only reduce the number of CPUs, the proposed interface is wrong.

> > And what are the (desired) semantics vs hotplug? Using a cpumask without
> > excluding hotplug is racy.
>=20
> The housekeeping_mask should still remain constant, isn't?
> In any case, I can double check this.

The goal is very much to have that dynamically configurable.
