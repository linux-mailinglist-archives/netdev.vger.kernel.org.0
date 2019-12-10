Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62B75119C4E
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 23:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfLJW0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 17:26:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45695 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbfLJW0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 17:26:08 -0500
Received: from 1.general.cascardo.us.vpn ([10.172.70.58] helo=calabresa)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <cascardo@canonical.com>)
        id 1ienx8-0002Vk-Vd; Tue, 10 Dec 2019 22:25:59 +0000
Date:   Tue, 10 Dec 2019 19:25:53 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     Justin Forbes <jmforbes@linuxtx.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org,
        Martin KaFai Lau <kafai@fb.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        debian-kernel@lists.debian.org
Subject: Re: [PATCH] libbpf: fix readelf output parsing on powerpc with
 recent binutils
Message-ID: <20191210222553.GA4580@calabresa>
References: <20191201195728.4161537-1-aurelien@aurel32.net>
 <87zhgbe0ix.fsf@mpe.ellerman.id.au>
 <20191202093752.GA1535@localhost.localdomain>
 <CAFxkdAqg6RaGbRrNN3e_nHfHFR-xxzZgjhi5AnppTxxwdg0VyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFxkdAqg6RaGbRrNN3e_nHfHFR-xxzZgjhi5AnppTxxwdg0VyQ@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 12:58:33PM -0600, Justin Forbes wrote:
> On Mon, Dec 2, 2019 at 3:37 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > On Mon, Dec 02, 2019 at 04:53:26PM +1100, Michael Ellerman wrote:
> > > Aurelien Jarno <aurelien@aurel32.net> writes:
> > > > On powerpc with recent versions of binutils, readelf outputs an extra
> > > > field when dumping the symbols of an object file. For example:
> > > >
> > > >     35: 0000000000000838    96 FUNC    LOCAL  DEFAULT [<localentry>: 8]     1 btf_is_struct
> > > >
> > > > The extra "[<localentry>: 8]" prevents the GLOBAL_SYM_COUNT variable to
> > > > be computed correctly and causes the checkabi target to fail.
> > > >
> > > > Fix that by looking for the symbol name in the last field instead of the
> > > > 8th one. This way it should also cope with future extra fields.
> > > >
> > > > Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
> > > > ---
> > > >  tools/lib/bpf/Makefile | 4 ++--
> > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > Thanks for fixing that, it's been on my very long list of test failures
> > > for a while.
> > >
> > > Tested-by: Michael Ellerman <mpe@ellerman.id.au>
> >
> > Looks good & also continues to work on x86. Applied, thanks!
> 
> This actually seems to break horribly on PPC64le with binutils 2.33.1
> resulting in:
> Warning: Num of global symbols in sharedobjs/libbpf-in.o (32) does NOT
> match with num of versioned symbols in libbpf.so (184). Please make
> sure all LIBBPF_API symbols are versioned in libbpf.map.
> 
> This is the only arch that fails, with x86/arm/aarch64/s390 all
> building fine.  Reverting this patch allows successful build across
> all arches.
> 
> Justin

Well, I ended up debugging this same issue and had the same fix as Jarno's when
I noticed his fix was already applied.

I just installed a system with the latest binutils, 2.33.1, and it still breaks
without such fix. Can you tell what is the output of the following command on
your system?

readelf -s --wide tools/lib/bpf/sharedobjs/libbpf-in.o | cut -d "@" -f1 | sed 's/_v[0-9]_[0-9]_[0-9].*//' | awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $0}' 

Cascardo.
