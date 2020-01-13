Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4C00139134
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 13:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbgAMMnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 07:43:49 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33168 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbgAMMnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 07:43:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Cl+a0Ksq5P2uxep+vtJZs+gr7i53uKQU6pt50ip33jo=; b=fcyw21hMSWLKxkn0vyj9yS8LY
        wTdB37m/bjABnGDJO3uV2yMcbzG0G9laSW8+lt2vO7890PInmOvbiEQOdxO9qLd5WROVTvEIH8bLg
        EANxWyZetCLm5G8Ikg53/8ubDWoDT1G2/VqkzbZJcE/TZjPcxXLers49AKrdse34lF5o4YG16a+0A
        C6dKSoxpr0MbLEWEW7aMfP90uKKBo1LNmKIJpJ1BeqRR6GdzFNSbxD4jJUn/mYqv6RkmQyX3XI/sB
        jZO1ErhSAKvhw+JvB/Paj64HFq+2BVsRVpS1ImhPasWC+CTBvY2Yf/ll0Ewpk4tuJWoeHvEJfTnoC
        OBKuZRRag==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iqz3S-0004AK-FT; Mon, 13 Jan 2020 12:42:50 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 56D1D304121;
        Mon, 13 Jan 2020 13:41:12 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id AD5752B6B2F94; Mon, 13 Jan 2020 13:42:47 +0100 (CET)
Date:   Mon, 13 Jan 2020 13:42:47 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Singh, Balbir" <sblbir@amazon.com>
Cc:     "Valentin, Eduardo" <eduval@amazon.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Agarwal, Anchal" <anchalag@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Woodhouse@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com" 
        <Woodhouse@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "jgross@suse.com" <jgross@suse.com>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "x86@kernel.org" <x86@kernel.org>,
        "roger.pau@citrix.com" <roger.pau@citrix.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Kamata, Munehisa" <kamatam@amazon.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "konrad.wilk@oracle.co" <konrad.wilk@oracle.co>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "fllinden@amaozn.com" <fllinden@amaozn.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Subject: Re: [RFC PATCH V2 11/11] x86: tsc: avoid system instability in
 hibernation
Message-ID: <20200113124247.GG2827@hirez.programming.kicks-ass.net>
References: <20200107234526.GA19034@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <20200108105011.GY2827@hirez.programming.kicks-ass.net>
 <20200110153520.GC8214@u40b0340c692b58f6553c.ant.amazon.com>
 <20200113101609.GT2844@hirez.programming.kicks-ass.net>
 <857b42b2e86b2ae09a23f488daada3b1b2836116.camel@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <857b42b2e86b2ae09a23f488daada3b1b2836116.camel@amazon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 13, 2020 at 11:43:18AM +0000, Singh, Balbir wrote:
> For your original comment, just wanted to clarify the following:
> 
> 1. After hibernation, the machine can be resumed on a different but compatible
> host (these are VM images hibernated)
> 2. This means the clock between host1 and host2 can/will be different
> 
> In your comments are you making the assumption that the host(s) is/are the
> same? Just checking the assumptions being made and being on the same page with
> them.

I would expect this to be the same problem we have as regular suspend,
after power off the TSC will have been reset, so resume will have to
somehow bridge that gap. I've no idea if/how it does that.

I remember some BIOSes had crazy TSC ideas for suspend2ram, and we grew
tsc_restore_sched_clock_state() for it.

Playing crazy games like what you're doing just isn't it though.
