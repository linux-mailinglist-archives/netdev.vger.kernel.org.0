Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCBB42988BC
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 09:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1772062AbgJZIqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 04:46:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:51474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1771245AbgJZIqJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 04:46:09 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63BC0223B0;
        Mon, 26 Oct 2020 08:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603701968;
        bh=qB8CzEhahOaemFq9YE9Yhqr27FC97Yq4A5dMZ2W97vA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YJNlyfwJQditZkvquRY4rdDE6DpqfnPaFff4rU1MwySaJIOxFdeqpc6y+R7kGWWZL
         I/tukEwESjrSwbzxCYBJzNLH5FBxALk/Q/v6jS9owoz33A9Ll/Wu8dLcq+BXWtPCea
         fS1uMobVWUkzGZyos56M/aN2N2Tq413y6210TygY=
Date:   Mon, 26 Oct 2020 08:46:02 +0000
From:   Will Deacon <will@kernel.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Vitaly Chikunov <vt@altlinux.org>, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Sandipan Das <sandipan@linux.ibm.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: tools/bpf: Compilation issue on powerpc: unknown type name
 '__vector128'
Message-ID: <20201026084602.GD23739@willie-the-truck>
References: <20201023230641.xomukhg3zrhtuxez@altlinux.org>
 <20201024082319.GA24131@altlinux.org>
 <20201024203040.4cjxnxrdy6qx557c@altlinux.org>
 <87y2jtwq64.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y2jtwq64.fsf@mpe.ellerman.id.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26, 2020 at 03:45:55PM +1100, Michael Ellerman wrote:
> Vitaly Chikunov <vt@altlinux.org> writes:
> > Adding netdev and PowerPC maintainers JFYI.
> 
> Thanks.
> 
> > On Sat, Oct 24, 2020 at 11:23:19AM +0300, Dmitry V. Levin wrote:
> >> Hi,
> >> 
> >> On Sat, Oct 24, 2020 at 02:06:41AM +0300, Vitaly Chikunov wrote:
> >> > Hi,
> >> > 
> >> > Commit f143c11bb7b9 ("tools: bpf: Use local copy of headers including
> >> > uapi/linux/filter.h") introduces compilation issue on powerpc:
> >> >  
> >> >   builder@powerpc64le:~/linux$ make -C tools/bpf V=1
> >> >   make: Entering directory '/usr/src/linux/tools/bpf'
> >> >   gcc -Wall -O2 -D__EXPORTED_HEADERS__ -I/usr/src/linux/tools/include/uapi -I/usr/src/linux/tools/include -DDISASM_FOUR_ARGS_SIGNATURE -c -o bpf_dbg.o /usr/src/linux/tools/bpf/bpf_dbg.c
> 
> Defining __EXPORTED_HEADERS__ is a hack to circumvent the checks in the
> uapi headers.
> 
> So first comment is to stop doing that, although it doesn't actually fix
> this issue.
> 
> >> >   In file included from /usr/include/asm/sigcontext.h:14,
> >> > 		   from /usr/include/bits/sigcontext.h:30,
> >> > 		   from /usr/include/signal.h:291,
> >> > 		   from /usr/src/linux/tools/bpf/bpf_dbg.c:51:
> >> >   /usr/include/asm/elf.h:160:9: error: unknown type name '__vector128'
> >> >     160 | typedef __vector128 elf_vrreg_t;
> >> > 	|         ^~~~~~~~~~~
> >> >   make: *** [Makefile:67: bpf_dbg.o] Error 1
> >> >   make: Leaving directory '/usr/src/linux/tools/bpf'
> >> 
> >> __vector128 is defined in arch/powerpc/include/uapi/asm/types.h;
> >> while include/uapi/linux/types.h does #include <asm/types.h>,
> >> tools/include/uapi/linux/types.h doesn't, resulting to this
> >> compilation error.
> >
> > This is too puzzling to fix portably.
> 
> I don't really understand how this is expected to work.
> 
> We have tools/include/uapi/linux/types.h which is some sort of hand
> hacked types.h, but doesn't match the real types.h from
> include/uapi/linux.
> 
> In particular the tools/include types.h doesn't include asm/types.h,
> which is why this breaks.
> 
> I can build bpf_dbg if I copy the properly exported header in:
> 
>   $ make INSTALL_HDR_PATH=$PWD/headers headers_install
>   $ cp headers/include/linux/types.h tools/include/uapi/linux/
>   $ make -C tools/bpf bpf_dbg
>   make: Entering directory '/home/michael/linux/tools/bpf'
>   
>   Auto-detecting system features:
>   ...                        libbfd: [ on  ]
>   ...        disassembler-four-args: [ on  ]
>   
>     CC       bpf_dbg.o
>     LINK     bpf_dbg
>   make: Leaving directory '/home/michael/linux/tools/bpf
> 
> 
> I'm not sure what the proper fix is.
> 
> Maybe sync the tools/include types.h with the real one?

Yeah, all f143c11bb7b9 did was sync the local copy with the result of
'headers_install', so if that's sufficient then I think that's the right
way to fix the immediate breakage.

> Or TBH I would have thought the best option is to not have
> tools/include/uapi at all, but instead just run headers_install before
> building and use the properly exported headers.

Agreed, although in some cases I suspect that kernel-internal parts are
being used.

Wiil
