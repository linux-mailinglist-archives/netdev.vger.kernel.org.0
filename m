Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9415529292C
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 16:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbgJSOVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 10:21:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:46652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728311AbgJSOVK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 10:21:10 -0400
Received: from localhost (unknown [176.167.103.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1573D221FC;
        Mon, 19 Oct 2020 14:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603117269;
        bh=RlnJso2zV6UGQMDwIYMaQRuuJ80aQ8q0A0LxXDG7tv4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XJywZspLTypkshdONfdoa1utoSHmWb4+d0n5Tec0P7iNGTsqWi8YJESXtd6sJfdZB
         DpXfNpZASEUegzLyEFFoZfInWZ4/pchUsrcPmKsqRnL+4+U8jej3NAuI1pRF7L4keW
         FeHfiG+dE2x1m44G8c7ed3iEtTmP2g7bJvecX/x0=
Date:   Mon, 19 Oct 2020 16:21:06 +0200
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        mtosatti@redhat.com, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        helgaas@kernel.org, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, jlelli@redhat.com, hch@infradead.org,
        bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jiri@nvidia.com, mingo@redhat.com, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, lgoncalv@redhat.com
Subject: Re: [PATCH v4 4/4] PCI: Limit pci_alloc_irq_vectors() to
 housekeeping CPUs
Message-ID: <20201019142106.GB34192@lothringen>
References: <20200928183529.471328-1-nitesh@redhat.com>
 <20200928183529.471328-5-nitesh@redhat.com>
 <20201016122046.GP2611@hirez.programming.kicks-ass.net>
 <79f382a7-883d-ff42-394d-ec4ce81fed6a@redhat.com>
 <20201019111137.GL2628@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201019111137.GL2628@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 01:11:37PM +0200, Peter Zijlstra wrote:
> > > And what are the (desired) semantics vs hotplug? Using a cpumask without
> > > excluding hotplug is racy.
> > 
> > The housekeeping_mask should still remain constant, isn't?
> > In any case, I can double check this.
> 
> The goal is very much to have that dynamically configurable.

Right but unfortunately we are not there before a little while. And the
existing code in these drivers allocating vectors doesn't even take into
account hotplug as you spotted. So I agreed to let Nitesh fix this issue
on top of the existing code until he can look into providing some infrastructure
for these kind of vectors allocation. The first step would be to consolidate
similar code from other drivers, then maybe handle hotplug and later
dynamic housekeeping.
