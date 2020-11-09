Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22E742AC2E7
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 18:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729777AbgKIRzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 12:55:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgKIRzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 12:55:23 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DAEEC0613CF;
        Mon,  9 Nov 2020 09:55:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=sUQkj5s2Np+1u65pNXEAvmKW7v0K/ZQANqdjUYGdZrA=; b=cRFiuf5W/6laUljn5iVnAiidox
        7+rGG9B0ObrnDgxIjlQqGpLlL0tOfOZ79e7XypdkdIFNm0sHcms7H6dMwaRUoz/8Qnv/JCp2XCarC
        UcpP+s0GxJGaFSwiPXfJPP346EFano2sWaK7oozeQbLMqn3NYVZY+EcUyGvBbDLUBxpBVg9sjan7p
        AXqBuOr16gEk9kmTKsAAybhG5Knc0N+4/SDiitQzSw/Y59NJh3GXyfjydK+7O16h63lZ2alDUHl5Z
        Modrcn1NKA0eeSAAY5uTUG1UcT5j2oOlnMOya0jh6lMzf2VqOnn76edepCWtBqW93zTXR1Oc1H5vC
        Wh/rKvlQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kcBNp-0006c6-1H; Mon, 09 Nov 2020 17:55:13 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 52AF3301324;
        Mon,  9 Nov 2020 18:55:12 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3CE882B81AABB; Mon,  9 Nov 2020 18:55:12 +0100 (CET)
Date:   Mon, 9 Nov 2020 18:55:12 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Kevin Sheldrake <Kevin.Sheldrake@microsoft.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        KP Singh <kpsingh@google.com>
Subject: Re: [EXTERNAL] Re: [PATCH bpf-next v2] Update perf ring buffer to
 prevent corruption
Message-ID: <20201109175512.GQ2594@hirez.programming.kicks-ass.net>
References: <VI1PR8303MB00802FE5D289E0D7BA95B7DDFBEE0@VI1PR8303MB0080.EURPRD83.prod.outlook.com>
 <CAADnVQLNdDn1jfyEAeKO17vXQiN+VKAvq+VFkY2G_pvSbaPjFA@mail.gmail.com>
 <20201109112908.GG2594@hirez.programming.kicks-ass.net>
 <VI1PR8303MB0080D892288E0137AA585778FBEA0@VI1PR8303MB0080.EURPRD83.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR8303MB0080D892288E0137AA585778FBEA0@VI1PR8303MB0080.EURPRD83.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 09, 2020 at 02:22:28PM +0000, Kevin Sheldrake wrote:

> I triggered the corruption by sending samples larger than 64KB-24 bytes
> to a perf ring buffer from eBPF using bpf_perf_event_output().  The u16
> that holds the size in the struct perf_event_header is overflowed and
> the distance between adjacent samples in the perf ring buffer is set
> by this overflowed value; hence if samples of 64KB are sent, adjacent
> samples are placed 24 bytes apart in the ring buffer, with the later ones
> overwriting parts of the earlier ones.  If samples aren't read as quickly
> as they are received, then they are corrupted by the time they are read.
> 
> Attempts to fix this in the eBPF verifier failed as the actual sample is
> constructed from a variable sized header in addition to the raw data
> supplied from eBPF.  The sample is constructed in perf_prepare_sample(),
> outside of the eBPF engine.
> 
> My proposed fix is to check that the constructed size is <U16_MAX before
> committing it to the struct perf_event_header::size variable.
> 
> A reproduction of the bug can be found at:
> https://github.com/microsoft/OMS-Auditd-Plugin/tree/MSTIC-Research/ebpf_perf_output_poc

OK, so I can't actually operate any of this fancy BPF nonsense. But if
I'm not mistaken this calls into:
kernel/trace/bpf_trace.c:BPF_CALL_5(bpf_perf_event_output) with a giant
@data.

Let me try and figure out what that code does.
