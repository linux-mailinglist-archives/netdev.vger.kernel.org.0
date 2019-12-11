Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29D2611B669
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 17:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733271AbfLKQAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 11:00:47 -0500
Received: from hall.aurel32.net ([195.154.113.88]:41108 "EHLO hall.aurel32.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731491AbfLKQAp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 11:00:45 -0500
Received: from aurel32 by hall.aurel32.net with local (Exim 4.92)
        (envelope-from <aurelien@aurel32.net>)
        id 1if4Pk-0008An-F6; Wed, 11 Dec 2019 17:00:36 +0100
Date:   Wed, 11 Dec 2019 17:00:36 +0100
From:   Aurelien Jarno <aurelien@aurel32.net>
To:     Justin Forbes <jmforbes@linuxtx.org>
Cc:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org,
        Martin KaFai Lau <kafai@fb.com>,
        debian-kernel@lists.debian.org
Subject: Re: [PATCH] libbpf: fix readelf output parsing on powerpc with
 recent binutils
Message-ID: <20191211160036.GV2974@aurel32.net>
Mail-Followup-To: Justin Forbes <jmforbes@linuxtx.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" <netdev@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>,
        "open list:BPF (Safe dynamic programs and tools)" <bpf@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org, Martin KaFai Lau <kafai@fb.com>,
        debian-kernel@lists.debian.org
References: <20191201195728.4161537-1-aurelien@aurel32.net>
 <87zhgbe0ix.fsf@mpe.ellerman.id.au>
 <20191202093752.GA1535@localhost.localdomain>
 <CAFxkdAqg6RaGbRrNN3e_nHfHFR-xxzZgjhi5AnppTxxwdg0VyQ@mail.gmail.com>
 <20191210222553.GA4580@calabresa>
 <CAFxkdAp6Up0qSyp0sH0O1yD+5W3LvY-+-iniBrorcz2pMV+y-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFxkdAp6Up0qSyp0sH0O1yD+5W3LvY-+-iniBrorcz2pMV+y-g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-12-11 09:33, Justin Forbes wrote:
> On Tue, Dec 10, 2019 at 4:26 PM Thadeu Lima de Souza Cascardo
> <cascardo@canonical.com> wrote:
> >
> > On Tue, Dec 10, 2019 at 12:58:33PM -0600, Justin Forbes wrote:
> > > On Mon, Dec 2, 2019 at 3:37 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > >
> > > > On Mon, Dec 02, 2019 at 04:53:26PM +1100, Michael Ellerman wrote:
> > > > > Aurelien Jarno <aurelien@aurel32.net> writes:
> > > > > > On powerpc with recent versions of binutils, readelf outputs an extra
> > > > > > field when dumping the symbols of an object file. For example:
> > > > > >
> > > > > >     35: 0000000000000838    96 FUNC    LOCAL  DEFAULT [<localentry>: 8]     1 btf_is_struct
> > > > > >
> > > > > > The extra "[<localentry>: 8]" prevents the GLOBAL_SYM_COUNT variable to
> > > > > > be computed correctly and causes the checkabi target to fail.
> > > > > >
> > > > > > Fix that by looking for the symbol name in the last field instead of the
> > > > > > 8th one. This way it should also cope with future extra fields.
> > > > > >
> > > > > > Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
> > > > > > ---
> > > > > >  tools/lib/bpf/Makefile | 4 ++--
> > > > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > > >
> > > > > Thanks for fixing that, it's been on my very long list of test failures
> > > > > for a while.
> > > > >
> > > > > Tested-by: Michael Ellerman <mpe@ellerman.id.au>
> > > >
> > > > Looks good & also continues to work on x86. Applied, thanks!
> > >
> > > This actually seems to break horribly on PPC64le with binutils 2.33.1
> > > resulting in:
> > > Warning: Num of global symbols in sharedobjs/libbpf-in.o (32) does NOT
> > > match with num of versioned symbols in libbpf.so (184). Please make
> > > sure all LIBBPF_API symbols are versioned in libbpf.map.
> > >
> > > This is the only arch that fails, with x86/arm/aarch64/s390 all
> > > building fine.  Reverting this patch allows successful build across
> > > all arches.
> > >
> > > Justin
> >
> > Well, I ended up debugging this same issue and had the same fix as Jarno's when
> > I noticed his fix was already applied.
> >
> > I just installed a system with the latest binutils, 2.33.1, and it still breaks
> > without such fix. Can you tell what is the output of the following command on
> > your system?
> >
> > readelf -s --wide tools/lib/bpf/sharedobjs/libbpf-in.o | cut -d "@" -f1 | sed 's/_v[0-9]_[0-9]_[0-9].*//' | awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $0}'
> >
> 
> readelf -s --wide tools/lib/bpf/sharedobjs/libbpf-in.o | cut -d "@"
> -f1 | sed 's/_v[0-9]_[0-9]_[0-9].*//' | awk '/GLOBAL/ && /DEFAULT/ &&
> !/UND/ {print $0}'
>    373: 00000000000141bc  1376 FUNC    GLOBAL DEFAULT    1 libbpf_num_possible_cpus [<localentry>: 8]
>    375: 000000000001869c   176 FUNC    GLOBAL DEFAULT    1 btf__free [<localentry>: 8]

It seems that in your case the localentry part is added after the symbol
name. That doesn't match what is done in upstream binutils:

https://sourceware.org/git/gitweb.cgi?p=binutils-gdb.git;a=blob;f=binutils/readelf.c;hb=refs/heads/master#l11485

Which version of binutils are you using? It looks like your version has
been modified to workaround this exact issue.

-- 
Aurelien Jarno                          GPG: 4096R/1DDD8C9B
aurelien@aurel32.net                 http://www.aurel32.net
