Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFAB343E675
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 18:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbhJ1QrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 12:47:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230248AbhJ1QrM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 12:47:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E63D610CF;
        Thu, 28 Oct 2021 16:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635439484;
        bh=2D513u3iMnBxIdPsGPCHooAjqpmHDe+3f0GBU3JGh3A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oYsQujquaZ7SSzH30NiEEYdeNyJO4DDq1x8gTTr3ENbRIFYsRDucetesNWYTM7AO+
         A25L39UTJEbJdzU+QufCl5Qd/34YzGm9oV3PQGA/Wx2JKHFlcw6xOklEo9y5oaLHUg
         cZH4qZPli1T01qvOM4aAcpq6otiGKbrOHK5QpV2s=
Date:   Thu, 28 Oct 2021 18:44:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        antonio.gomez.iglesias@intel.com, tony.luck@intel.com,
        dave.hansen@linux.intel.com
Subject: Re: [PATCH ebpf v2 2/2] bpf: Make unprivileged bpf depend on
 CONFIG_CPU_SPECTRE
Message-ID: <YXrTev6WMXry9pFI@kroah.com>
References: <cover.1635383031.git.pawan.kumar.gupta@linux.intel.com>
 <882f5c31f48bac75ebaede2a0ec321ec67128229.1635383031.git.pawan.kumar.gupta@linux.intel.com>
 <20211028135751.GA41384@lakrids.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211028135751.GA41384@lakrids.cambridge.arm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 02:57:51PM +0100, Mark Rutland wrote:
> On Wed, Oct 27, 2021 at 06:35:44PM -0700, Pawan Gupta wrote:
> > Disabling unprivileged BPF would help prevent unprivileged users from
> > creating the conditions required for potential speculative execution
> > side-channel attacks on affected hardware. A deep dive on such attacks
> > and mitigation is available here [1].
> > 
> > If an architecture selects CONFIG_CPU_SPECTRE, disable unprivileged BPF
> > by default. An admin can enable this at runtime, if necessary.
> > 
> > Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> > 
> > [1] https://ebpf.io/summit-2021-slides/eBPF_Summit_2021-Keynote-Daniel_Borkmann-BPF_and_Spectre.pdf
> > ---
> >  kernel/bpf/Kconfig | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
> > index a82d6de86522..510a5a73f9a2 100644
> > --- a/kernel/bpf/Kconfig
> > +++ b/kernel/bpf/Kconfig
> > @@ -64,6 +64,7 @@ config BPF_JIT_DEFAULT_ON
> >  
> >  config BPF_UNPRIV_DEFAULT_OFF
> >  	bool "Disable unprivileged BPF by default"
> > +	default y if CPU_SPECTRE
> 
> Why can't this just be "default y"?

Because not all arches are broken.

> This series makes that the case on x86, and if SW is going to have to
> deal with that we may as well do that everywhere, and say that on all
> architectures we leave it to the sysadmin or kernel builder to optin to
> permitting unprivileged BPF.
> 
> If we can change the default for x86 I see no reason we can't change
> this globally, and we avoid tying this to CPU_SPECTRE specifically.

No, this is a spectre-like issue only, if you have hardware that does
not have these types of issues, why wouldn't this be ok to be disabled?

thanks,

greg k-h
