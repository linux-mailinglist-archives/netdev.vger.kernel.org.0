Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89FE6293D85
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 15:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407597AbgJTNl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 09:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407501AbgJTNl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 09:41:58 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF67C061755;
        Tue, 20 Oct 2020 06:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=4vW5VXilK7EsyfO4dPaDcP262lkk9u9nP43QqAXpv9o=; b=xkc15xWP2oUKBp63sflEvxBDBa
        Cpz/U6a/YNxBc/GNqwflCrTWWfEnyhrLvKzVxy+FNRknLqEYUNB6RhdwWPKMlvpQ4xg7JJ/XkBilo
        q7QUjhv/WsWPwJYdXhdtx4Lc9qd+kJFDDpNK43AiN9vO3W9DwLBNGGD8Utslryom4kWhPhxq9EPIL
        BnLhrFaS/HluTGI3ucPrvi3dw9glxbYSgWze+TZEVpJFl0jRmBuSUzCD+61w4HQG0vtlthLswWD2P
        DQGya+IzO4qKZq3IEzmvSILgNefksN9ddf4HKEg8Um06/WO2s6mSuXXZ5C9rOnnBV1n6U4WzsDQxO
        41v7xSXw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kUrtL-00034B-NM; Tue, 20 Oct 2020 13:41:31 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 964AC304D28;
        Tue, 20 Oct 2020 15:41:28 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 6C545203280A1; Tue, 20 Oct 2020 15:41:28 +0200 (CEST)
Date:   Tue, 20 Oct 2020 15:41:28 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        frederic@kernel.org, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        helgaas@kernel.org, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, jlelli@redhat.com, hch@infradead.org,
        bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jiri@nvidia.com, mingo@redhat.com, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, lgoncalv@redhat.com
Subject: Re: [PATCH v4 4/4] PCI: Limit pci_alloc_irq_vectors() to
 housekeeping CPUs
Message-ID: <20201020134128.GT2628@hirez.programming.kicks-ass.net>
References: <20200928183529.471328-1-nitesh@redhat.com>
 <20200928183529.471328-5-nitesh@redhat.com>
 <20201016122046.GP2611@hirez.programming.kicks-ass.net>
 <79f382a7-883d-ff42-394d-ec4ce81fed6a@redhat.com>
 <20201019111137.GL2628@hirez.programming.kicks-ass.net>
 <20201019140005.GB17287@fuller.cnet>
 <20201020073055.GY2611@hirez.programming.kicks-ass.net>
 <078e659e-d151-5bc2-a7dd-fe0070267cb3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <078e659e-d151-5bc2-a7dd-fe0070267cb3@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 09:00:01AM -0400, Nitesh Narayan Lal wrote:
>=20
> On 10/20/20 3:30 AM, Peter Zijlstra wrote:
> > On Mon, Oct 19, 2020 at 11:00:05AM -0300, Marcelo Tosatti wrote:
> >>> So I think it is important to figure out what that driver really wants
> >>> in the nohz_full case. If it wants to retain N interrupts per CPU, and
> >>> only reduce the number of CPUs, the proposed interface is wrong.
> >> It wants N interrupts per non-isolated (AKA housekeeping) CPU.
> > Then the patch is wrong and the interface needs changing from @min_vecs,
> > @max_vecs to something that expresses the N*nr_cpus relation.
>=20
> Reading Marcelo's comment again I think what is really expected is 1
> interrupt per non-isolated (housekeeping) CPU (not N interrupts).

Then what is the point of them asking for N*nr_cpus when there is no
isolation?

Either everybody wants 1 interrupts per CPU and we can do the clamp
unconditionally, in which case we should go fix this user, or they want
multiple per cpu and we should go fix the interface.

It cannot be both.
