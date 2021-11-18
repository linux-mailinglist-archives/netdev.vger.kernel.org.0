Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F068455627
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 08:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244100AbhKRH6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 02:58:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244123AbhKRH6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 02:58:08 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C63C061570;
        Wed, 17 Nov 2021 23:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ftTiY5br5weKHpav7+51REIzh01modQlMVjKJ8JN940=; b=fM0duuQ6A2arafcxlvHtP+Lyfm
        k/lb57dzccJP5N2+0I3/CD0EJNlxILT0ABOWl5DmS1gux4O5mijDIvrMkLI7nD5AOV1Tcy86TkhLH
        hP1htF4dqU8B+114xk4ohfTAe2nEtJeVCxW8jstUDLdf1dUahnCptikIKgJw+Dk11NsWVLXtg85FZ
        5UcTpteG33fhiqc42JpneMCzGkozrLnpWIqw7t7+B0OhMvPvySYdjV6l2TUHqGASiPcJDmx4AHRVb
        L8vFMO8YxUwtBBrKGBH9dFXpx1oHzwbpus9PElddWRUlnUmsDpG66r3swdlXky01WE7uQ3lRC4M1I
        ys1MQdRA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mncFr-00GecD-CB; Thu, 18 Nov 2021 07:54:47 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 7EF079863CD; Thu, 18 Nov 2021 08:54:47 +0100 (CET)
Date:   Thu, 18 Nov 2021 08:54:47 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 2/7] set_memory: introduce
 set_memory_[ro|x]_noalias
Message-ID: <20211118075447.GG174703@worktop.programming.kicks-ass.net>
References: <20211116071347.520327-1-songliubraving@fb.com>
 <20211116071347.520327-3-songliubraving@fb.com>
 <20211116080051.GU174703@worktop.programming.kicks-ass.net>
 <768FB93A-E239-4B21-A0F1-C1206112E37E@fb.com>
 <20211117220132.GC174703@worktop.programming.kicks-ass.net>
 <73EBD706-4FEC-4976-9041-036EB3032478@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73EBD706-4FEC-4976-9041-036EB3032478@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 11:57:12PM +0000, Song Liu wrote:

> I would agree that __text_poke() is a safer option. But in this case, we 
> will need the temporary hole to be 2MB in size. Also, we will probably 
> hold the temporary mapping for longer time (the whole JITing process). 
> Does this sound reasonable?

No :-)

Jit to a buffer, then copy the buffer into the 2M page using 4k aliases.
IIRC each program is still smaller than a single page, right? So at no
point do you need more than 2 pages mapped anyway.
