Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B9727D4D0
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 19:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729699AbgI2RrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 13:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728386AbgI2RrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 13:47:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE38C061755;
        Tue, 29 Sep 2020 10:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=oCfvHV+eKDJ81YLxCB6N47LJuI+3zUrT7MS+gF7gNr4=; b=NjIGhaXrWwlKfAho6RX83T5VBG
        9kU191xaHfQf9xMkmFbUhsM8unnI6/Cu/ZcxCQa07jLGVfllxEv6zJQNU/QSetYE/OyO4R5J1nfJe
        tyQEzzf82Vu/tTa++E0RflrJePy3HLzmjShO5JUtUXPNOhAuwTkJScF1wDER73o3ROFT/gajTsenI
        4XtDhwfOso7PtCEtkDtRszmeTq4W+xoyXI5+uhPwIQnUNCGNTfxG+kWAAPHV54h4cJDDstUqGHuct
        noGbPWU/Gu1kVxKq4X2UWJffCQAqVupBC4HQRqYLChEr/xqJzsRedUoGgfK4sRbhoX9/Ln5Cpce+T
        Ww2Yp2mA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kNJiI-0000Hg-5T; Tue, 29 Sep 2020 17:46:54 +0000
Date:   Tue, 29 Sep 2020 18:46:54 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>, hch@infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        frederic@kernel.org, mtosatti@redhat.com, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        jlelli@redhat.com, bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jiri@nvidia.com, mingo@redhat.com, peterz@infradead.org,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        lgoncalv@redhat.com
Subject: Re: [PATCH v4 4/4] PCI: Limit pci_alloc_irq_vectors() to
 housekeeping CPUs
Message-ID: <20200929174654.GA773@infradead.org>
References: <20200928183529.471328-5-nitesh@redhat.com>
 <20200928215931.GA2499944@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928215931.GA2499944@bjorn-Precision-5520>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 04:59:31PM -0500, Bjorn Helgaas wrote:
> [to: Christoph in case he has comments, since I think he wrote this code]

I think I actually suggested this a few iterations back.

> > +	hk_cpus = housekeeping_num_online_cpus(HK_FLAG_MANAGED_IRQ);
> > +
> > +	/*
> > +	 * If we have isolated CPUs for use by real-time tasks, to keep the
> > +	 * latency overhead to a minimum, device-specific IRQ vectors are moved
> > +	 * to the housekeeping CPUs from the userspace by changing their
> > +	 * affinity mask. Limit the vector usage to keep housekeeping CPUs from
> > +	 * running out of IRQ vectors.
> > +	 */
> > +	if (hk_cpus < num_online_cpus()) {

I woukd have moved the assignment to hk_cpus below the comment and
just above the if, but that is really just a minor style preference.

Otherwise this looks good:

Acked-by: Christoph Hellwig <hch@lst.de>
