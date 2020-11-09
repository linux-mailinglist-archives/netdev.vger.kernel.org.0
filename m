Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F612AB6CC
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 12:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729134AbgKIL3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 06:29:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgKIL3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 06:29:17 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BFDC0613CF;
        Mon,  9 Nov 2020 03:29:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=f0ypT5y1jMSuCaEIbDm4WxPHMthhLLHRQeDIPiJut2w=; b=Qaf6Mmkh6tRnv6NGXL9afNwZla
        S0JoPMzuaW49S3RyC/byQhEXXaXqeuD5Jx4jwaMdgf3m+IbwqbKbhwfjZud9A38yDczRgYdH9iyTo
        gTUDwT8rvh+PyoU/e6KUu27JBo55c8dR/Vyh4Aoaa5tIEoqrxb95dar7XRNK6hCeNpv2zjP2zvky0
        HZ3FdCYTe1FnT2cVwYMPg0uzSoSrktO5qNflonvTzQezpxgvBnUBHDfpyarBjCGjcuKQmqJi+bXBt
        wzjtWqCDRyR5G/XebGFPC55k0tg+GaNVo5atMT0Ls2n/GLg0rTW56qcbUKP9PO9rSkxR6HQdC6rFV
        ScBXA7dg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kc5MD-0003aT-VD; Mon, 09 Nov 2020 11:29:10 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A6AAF304D58;
        Mon,  9 Nov 2020 12:29:08 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 928372B09ACF5; Mon,  9 Nov 2020 12:29:08 +0100 (CET)
Date:   Mon, 9 Nov 2020 12:29:08 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Kevin Sheldrake <Kevin.Sheldrake@microsoft.com>,
        Ingo Molnar <mingo@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        KP Singh <kpsingh@google.com>
Subject: Re: [PATCH bpf-next v2] Update perf ring buffer to prevent corruption
Message-ID: <20201109112908.GG2594@hirez.programming.kicks-ass.net>
References: <VI1PR8303MB00802FE5D289E0D7BA95B7DDFBEE0@VI1PR8303MB0080.EURPRD83.prod.outlook.com>
 <CAADnVQLNdDn1jfyEAeKO17vXQiN+VKAvq+VFkY2G_pvSbaPjFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQLNdDn1jfyEAeKO17vXQiN+VKAvq+VFkY2G_pvSbaPjFA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 05, 2020 at 08:19:47PM -0800, Alexei Starovoitov wrote:
> On Thu, Nov 5, 2020 at 7:18 AM Kevin Sheldrake
> <Kevin.Sheldrake@microsoft.com> wrote:
> >
> > Resent due to some failure at my end.  Apologies if it arrives twice.
> >
> > From 63e34d4106b4dd767f9bfce951f8a35f14b52072 Mon Sep 17 00:00:00 2001
> > From: Kevin Sheldrake <kevin.sheldrake@microsoft.com>
> > Date: Thu, 5 Nov 2020 12:18:53 +0000
> > Subject: [PATCH] Update perf ring buffer to prevent corruption from
> >  bpf_perf_output_event()
> >
> > The bpf_perf_output_event() helper takes a sample size parameter of u64, but
> > the underlying perf ring buffer uses a u16 internally. This 64KB maximum size
> > has to also accommodate a variable sized header. Failure to observe this
> > restriction can result in corruption of the perf ring buffer as samples
> > overlap.
> >
> > Track the sample size and return -E2BIG if too big to fit into the u16
> > size parameter.
> >
> > Signed-off-by: Kevin Sheldrake <kevin.sheldrake@microsoft.com>
> 
> The fix makes sense to me.
> Peter, Ingo,
> should I take it through the bpf tree or you want to route via tip?

What are you doing to trigger this? The Changelog is devoid of much
useful information?
