Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B379268CC7
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 16:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgINOEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 10:04:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:55854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726399AbgINOBk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 10:01:40 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6067F208E4;
        Mon, 14 Sep 2020 14:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600092082;
        bh=uGQUvm/OYFR2K5MLndS6fIko6WhVxVx+Wnfq37H7WNc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zJsZJ6zERMaYi/aOqwTDzLwuLhhOZnp5WvoE2wKtKMJQgLJMF7HJi+fkdeVbEpyMq
         H2dogMKvpig6YxNQG5PjAwCStQoOiroxn6sObHK2aLPYfaVnzBACDPH08T2RMvs65R
         MsK8VkAriperAXNqG0t3OjqACEuTzDnVNHOLF0s4=
Date:   Mon, 14 Sep 2020 15:01:15 +0100
From:   Will Deacon <will@kernel.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     bpf@vger.kernel.org, ardb@kernel.org, naresh.kamboju@linaro.org,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Yauheni Kaliuta <yauheni.kaliuta@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64: bpf: Fix branch offset in JIT
Message-ID: <20200914140114.GG24441@willie-the-truck>
References: <20200914083622.116554-1-ilias.apalodimas@linaro.org>
 <20200914122042.GA24441@willie-the-truck>
 <20200914123504.GA124316@apalos.home>
 <20200914132350.GA126552@apalos.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914132350.GA126552@apalos.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ilias,

On Mon, Sep 14, 2020 at 04:23:50PM +0300, Ilias Apalodimas wrote:
> On Mon, Sep 14, 2020 at 03:35:04PM +0300, Ilias Apalodimas wrote:
> > On Mon, Sep 14, 2020 at 01:20:43PM +0100, Will Deacon wrote:
> > > On Mon, Sep 14, 2020 at 11:36:21AM +0300, Ilias Apalodimas wrote:
> > > > Running the eBPF test_verifier leads to random errors looking like this:

[...]

> > > > The reason seems to be the offset[] creation and usage ctx->offset[]
> > > 
> > > "seems to be"? Are you unsure?
> > 
> > Reading the history and other ports of the JIT implementation, I couldn't 
> > tell if the decision on skipping the 1st entry was deliberate or not on 
> > Aarch64. Reading through the mailist list didn't help either [1].
> > Skipping the 1st entry seems indeed to cause the problem.
> > I did run the patch though the BPF tests and showed no regressions + fixing 
> > the error.
> 
> I'll correct myself here.
> Looking into 7c2e988f400e ("bpf: fix x64 JIT code generation for jmp to 1st insn")
> explains things a bit better.
> Jumping back to the 1st insn wasn't allowed until eBPF bounded loops were 
> introduced. That's what the 1st instruction was not saved in the original code.
> 
> > > 
> > > No Fixes: tag?
> > 
> > I'll re-spin and apply one 
> > 
> Any suggestion on any Fixes I should apply? The original code was 'correct' and
> broke only when bounded loops and their self-tests were introduced.

Ouch, that's pretty bad as it means nobody is regression testing BPF on
arm64 with mainline. Damn.

The Fixes: tag should identify the commit beyond which we don't need to
backport the fix, so it sounds like introduction of bounded loops, according
to your analysis.

Will
