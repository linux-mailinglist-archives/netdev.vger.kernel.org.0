Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 347C82935C2
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 09:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404974AbgJTHbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 03:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731247AbgJTHbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 03:31:14 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084D5C061755;
        Tue, 20 Oct 2020 00:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0jpAo9lbXaLZETK0hjbBwDIDeTjw7Zq4maw1xDTUWIc=; b=tQbpYEWMgnzikItrfiwfOOp1g+
        Hd3DMlLkRHGio/v1DuIL4w/ZAhR1TJaN9LYf5L9MLZ37bm77a22hC17TpTZQLpR8akbcFs+xqgZ5N
        9P7q1PoT3Yt9VbmxA6H9h4ifUl+hXWPZd2n1Rw4RIe/iX9qAGgrNo+n7k90EQWCbdOwmll3sd5oSh
        TGTLXFWSqvLTMB0Ta413MhP6c/DZP5f8UfC2VqJ4C86Rj85LEzIuyBrGUxES/j9yVcek8fmgiaQXj
        8kES1fOrNourzGZJ9CJhi4cPcQr0LgPKv6zmLw1n0E4SmQkhKRMS76Fyz2qeteH2DEblFpN8J3rfE
        2VGekPFA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kUm6j-0000je-1t; Tue, 20 Oct 2020 07:30:57 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 4DF333011FE;
        Tue, 20 Oct 2020 09:30:55 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3617E2B785033; Tue, 20 Oct 2020 09:30:55 +0200 (CEST)
Date:   Tue, 20 Oct 2020 09:30:55 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
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
Message-ID: <20201020073055.GY2611@hirez.programming.kicks-ass.net>
References: <20200928183529.471328-1-nitesh@redhat.com>
 <20200928183529.471328-5-nitesh@redhat.com>
 <20201016122046.GP2611@hirez.programming.kicks-ass.net>
 <79f382a7-883d-ff42-394d-ec4ce81fed6a@redhat.com>
 <20201019111137.GL2628@hirez.programming.kicks-ass.net>
 <20201019140005.GB17287@fuller.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201019140005.GB17287@fuller.cnet>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 11:00:05AM -0300, Marcelo Tosatti wrote:
> > So I think it is important to figure out what that driver really wants
> > in the nohz_full case. If it wants to retain N interrupts per CPU, and
> > only reduce the number of CPUs, the proposed interface is wrong.
> 
> It wants N interrupts per non-isolated (AKA housekeeping) CPU.

Then the patch is wrong and the interface needs changing from @min_vecs,
@max_vecs to something that expresses the N*nr_cpus relation.
