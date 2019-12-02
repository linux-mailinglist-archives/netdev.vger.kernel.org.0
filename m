Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9B810E6ED
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 09:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfLBIaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 03:30:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42946 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfLBIaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 03:30:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=mNAwy5HbY+uo4286pa1sGzTyvw+MXZwiioxbIWu2EDI=; b=YicuJCQDPgGBqcZjUTNxushfe
        bDXviQWiLfqJCExe6Jwn9hVfkHFuu+Hg7CumTzoqqFV6+VVQb5PBJEdWf+s3JMBGoMY701zKI23/e
        CmfLRplFr3lV9MDttiYr5HI+97ijVYb8R22ikb63ehwudfrwF+3oamGxNLJqO0b3+DV41xIUQmr+G
        AxqnBUFg7WqGkhz+qWfThRUEjyorEy6ePceVYGMnawQCndMDNVhWTedrwVpPW8N6ZLI7ryZuc/PtO
        HThv6L7MsReyxomPO/gPqQamu5svb+OTQy33HR4pCKSWaS1eZ+KaHJ7tr5yJFLOkk9PK1+qcG2iAs
        icKTyFD0A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ibh5r-0004wU-QD; Mon, 02 Dec 2019 08:30:07 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 50BD330018B;
        Mon,  2 Dec 2019 09:28:50 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 160ED20A6A67F; Mon,  2 Dec 2019 09:30:06 +0100 (CET)
Date:   Mon, 2 Dec 2019 09:30:06 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        alexei.starovoitov@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH bpf] bpf: avoid setting bpf insns pages read-only when
 prog is jited
Message-ID: <20191202083006.GJ2844@hirez.programming.kicks-ass.net>
References: <20191129222911.3710-1-daniel@iogearbox.net>
 <ec8264ad-8806-208a-1375-51e7cad1866e@gmail.com>
 <10d4c87c-3d53-2dbf-d8c0-8b36863fec60@iogearbox.net>
 <adc89dbf-361a-838f-a0a5-8ef7ea619848@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adc89dbf-361a-838f-a0a5-8ef7ea619848@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 01, 2019 at 06:49:32PM -0800, Eric Dumazet wrote:

> Thanks for the link !
> 
> Having RO protection as a debug feature would be useful.
> 
> I believe we have CONFIG_STRICT_MODULE_RWX (and CONFIG_STRICT_KERNEL_RWX) for that already.
> 
> Or are we saying we also want to get rid of them ?

No, in fact I'm working on making that stronger. We currently still have
a few cases that violate the W^X rule.

The thing is, when the BPF stuff is JIT'ed, the actual BPF instruction
page is not actually executed at all, so making it RO serves no purpose,
other than to fragment the direct map.

All actual code lives in the 2G range that x86_64 can directly branch
to, but this BPF instruction stuff lives in the general data heap and
can thus cause much more fragmentation of the direct map.
