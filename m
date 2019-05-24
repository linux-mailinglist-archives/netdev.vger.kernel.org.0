Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A40B291B1
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 09:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389131AbfEXH1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 03:27:53 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:34234 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388910AbfEXH1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 03:27:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=jfU/pBiYlCGOOaoH7p13zhcAF3lexkfxk9MxpHVVZyE=; b=qJiyBB98Yfd32wx1vnufAXNWM
        KFwEGbxwXbqvJ4/GIFLYcI+svmXTa2/DmNWQGDQ7xEQRUCUSyBOz+NBYhsWg7XT9ctzwrzWdHexM5
        OkQ+R9cdXaYjgpmaowyUJSnVlK+r7QrFZuOrHsaX0nlddAfIvQVArdUu2J5mzJT0swjbtH+1MAtm7
        7b8nhuEFMFEpB+BKY+NWVjdLLnFpkO3rqDyTQrOki3KraXl5y/lzQESCIVANUNReOwTEENeoEhkNP
        XcLdXJ/Rq+LVYi3NWoqP7mWIer2psH9MYtA22900cGlAiBA5KunxB3/sBRZXnABlEr8Biid3vWNTn
        gNu36J8+g==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hU4bx-0006pu-0P; Fri, 24 May 2019 07:27:29 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id B02FF201D3687; Fri, 24 May 2019 09:27:26 +0200 (CEST)
Date:   Fri, 24 May 2019 09:27:26 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Kris Van Hees <kris.van.hees@oracle.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        dtrace-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Message-ID: <20190524072726.GD2589@hirez.programming.kicks-ass.net>
References: <201905202347.x4KNl0cs030532@aserv0121.oracle.com>
 <20190521175617.ipry6ue7o24a2e6n@ast-mbp.dhcp.thefacebook.com>
 <20190522142531.GE16275@worktop.programming.kicks-ass.net>
 <20190522182215.GO2422@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522182215.GO2422@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 02:22:15PM -0400, Kris Van Hees wrote:

> > Let me further NAK it for adding all sorts of garbage to the code --
> > we're not going to do gaps and stay_in_page nonsense.
> 
> Could you give some guidance in terms of an alternative?  The ring buffer code
> provides both non-contiguous page allocation support and a vmalloc-based
> allocation, and the vmalloc version certainly would avoid the entire gap and
> page boundary stuff.  But since the allocator is chosen at build time based on
> the arch capabilities, there is no way to select a specific memory allocator.
> I'd be happy to use an alternative approach that allows direct writing into
> the ring buffer.

So why can't you do what the regular perf does? Use an output iterator
that knows about the page breaks? See perf_output_put() for example.

Anyway, I agree with Alexei and DaveM, get it working without/minimal
kernel changes first, and then we can talk about possible optimizations.
