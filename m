Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9B5F436D
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 10:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731340AbfKHJgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 04:36:13 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:35920 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731278AbfKHJgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 04:36:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Q9a6tsf4e5tRgi5gmLwBv+7tmHnUPZ10nV6Lvv6OfeU=; b=hnxk+rGka0JaSx93lXdK13EmU
        GFtdB79u8WgqfsdK1edi7N/q6waDWtwFD9AINs1x/HUdXgj980K/juLFLLGmEG8lGwnfkTE2dZlgk
        O2VxBQSsZYHEz+6O1L4v3QMme3aMZivE3xl6HOfdXwJPRvCF8BLJyvHieLQEZnnNsRCixBuMJn3hW
        lTIt8p5V9M2wxt6YJKiH76zEfCImrX+XN9AY23eYi/tpgQzD3UYbYCyVi8+8+3UlgEfcP0acvFMwq
        c0D9T3/m6WISX5Yn1JKWvOMAU8FnzpuMJaN2U9ozzshIz06sJFZh87GGm7M6TZTMz0KqxHN34Ic0N
        gnvnmEYUA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iT0gb-0003Fq-0n; Fri, 08 Nov 2019 09:36:09 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 80746305FC2;
        Fri,  8 Nov 2019 10:35:02 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 29A832022B9E1; Fri,  8 Nov 2019 10:36:07 +0100 (CET)
Date:   Fri, 8 Nov 2019 10:36:07 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     davem@davemloft.net, daniel@iogearbox.net, x86@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next 02/18] bpf: Add bpf_arch_text_poke() helper
Message-ID: <20191108093607.GO5671@hirez.programming.kicks-ass.net>
References: <20191108064039.2041889-1-ast@kernel.org>
 <20191108064039.2041889-3-ast@kernel.org>
 <20191108091156.GG4114@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108091156.GG4114@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 08, 2019 at 10:11:56AM +0100, Peter Zijlstra wrote:
> On Thu, Nov 07, 2019 at 10:40:23PM -0800, Alexei Starovoitov wrote:
> > Add bpf_arch_text_poke() helper that is used by BPF trampoline logic to patch
> > nops/calls in kernel text into calls into BPF trampoline and to patch
> > calls/nops inside BPF programs too.
> 
> This thing assumes the text is unused, right? That isn't spelled out
> anywhere. The implementation is very much unsafe vs concurrent execution
> of the text.

Also, what NOP/CALL instructions will you be hijacking? If you're
planning on using the fentry nops, then what ensures this and ftrace
don't trample on one another? Similar for kprobes.

In general, what ensures every instruction only has a single modifier?

I'm very uncomfortable letting random bpf proglets poke around in the
kernel text.
