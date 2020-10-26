Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBD029863F
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 05:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1421586AbgJZEqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 00:46:00 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:44107 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1421573AbgJZEp7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 00:45:59 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4CKMjJ6PTPz9sT6;
        Mon, 26 Oct 2020 15:45:56 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1603687557;
        bh=AIzG1Bgj4Dpz5ClsRcl/SqGZTTqDaKHn7m3Fp6anYOw=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=KovvuKieWoUcYBZcyNUA0Y99eBdGXSESoKPKLFq2XlnfbdpBI5r8UjVBJDRS4iI0n
         dmV3k+uPREp/cBFV6TFujJ9DV+BN3jMVb97rjRtTg1RqpI+iAp2syRE2bkg5oQr3HX
         0ExyduMwkzURYEDoHi05s4hKOeWCzu/VKCIU21Zm523xkhB+k70R5XfwWdSFzgPquC
         S+rBfIOG8iKHkmGoqXN4VnUMfdkSyB/Sk+6a2XNBV2SlLqd1OIzU6phrJUMnuUysCe
         lnicy3i1w6dTg73n6XZWqr2oYKOdBnU67y7zuR+YPUkZ12JZ2epylCMmlplpbgAxr5
         0SNaFyRRuN9lg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Vitaly Chikunov <vt@altlinux.org>, bpf@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Sandipan Das <sandipan@linux.ibm.com>
Cc:     "Dmitry V. Levin" <ldv@altlinux.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: tools/bpf: Compilation issue on powerpc: unknown type name '__vector128'
In-Reply-To: <20201024203040.4cjxnxrdy6qx557c@altlinux.org>
References: <20201023230641.xomukhg3zrhtuxez@altlinux.org> <20201024082319.GA24131@altlinux.org> <20201024203040.4cjxnxrdy6qx557c@altlinux.org>
Date:   Mon, 26 Oct 2020 15:45:55 +1100
Message-ID: <87y2jtwq64.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vitaly Chikunov <vt@altlinux.org> writes:
> Adding netdev and PowerPC maintainers JFYI.

Thanks.

> On Sat, Oct 24, 2020 at 11:23:19AM +0300, Dmitry V. Levin wrote:
>> Hi,
>> 
>> On Sat, Oct 24, 2020 at 02:06:41AM +0300, Vitaly Chikunov wrote:
>> > Hi,
>> > 
>> > Commit f143c11bb7b9 ("tools: bpf: Use local copy of headers including
>> > uapi/linux/filter.h") introduces compilation issue on powerpc:
>> >  
>> >   builder@powerpc64le:~/linux$ make -C tools/bpf V=1
>> >   make: Entering directory '/usr/src/linux/tools/bpf'
>> >   gcc -Wall -O2 -D__EXPORTED_HEADERS__ -I/usr/src/linux/tools/include/uapi -I/usr/src/linux/tools/include -DDISASM_FOUR_ARGS_SIGNATURE -c -o bpf_dbg.o /usr/src/linux/tools/bpf/bpf_dbg.c

Defining __EXPORTED_HEADERS__ is a hack to circumvent the checks in the
uapi headers.

So first comment is to stop doing that, although it doesn't actually fix
this issue.

>> >   In file included from /usr/include/asm/sigcontext.h:14,
>> > 		   from /usr/include/bits/sigcontext.h:30,
>> > 		   from /usr/include/signal.h:291,
>> > 		   from /usr/src/linux/tools/bpf/bpf_dbg.c:51:
>> >   /usr/include/asm/elf.h:160:9: error: unknown type name '__vector128'
>> >     160 | typedef __vector128 elf_vrreg_t;
>> > 	|         ^~~~~~~~~~~
>> >   make: *** [Makefile:67: bpf_dbg.o] Error 1
>> >   make: Leaving directory '/usr/src/linux/tools/bpf'
>> 
>> __vector128 is defined in arch/powerpc/include/uapi/asm/types.h;
>> while include/uapi/linux/types.h does #include <asm/types.h>,
>> tools/include/uapi/linux/types.h doesn't, resulting to this
>> compilation error.
>
> This is too puzzling to fix portably.

I don't really understand how this is expected to work.

We have tools/include/uapi/linux/types.h which is some sort of hand
hacked types.h, but doesn't match the real types.h from
include/uapi/linux.

In particular the tools/include types.h doesn't include asm/types.h,
which is why this breaks.

I can build bpf_dbg if I copy the properly exported header in:

  $ make INSTALL_HDR_PATH=$PWD/headers headers_install
  $ cp headers/include/linux/types.h tools/include/uapi/linux/
  $ make -C tools/bpf bpf_dbg
  make: Entering directory '/home/michael/linux/tools/bpf'
  
  Auto-detecting system features:
  ...                        libbfd: [ on  ]
  ...        disassembler-four-args: [ on  ]
  
    CC       bpf_dbg.o
    LINK     bpf_dbg
  make: Leaving directory '/home/michael/linux/tools/bpf


I'm not sure what the proper fix is.

Maybe sync the tools/include types.h with the real one?

Or TBH I would have thought the best option is to not have
tools/include/uapi at all, but instead just run headers_install before
building and use the properly exported headers.

cheers

