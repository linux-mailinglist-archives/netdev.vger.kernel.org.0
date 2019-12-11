Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8173711B695
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 17:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732868AbfLKQBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 11:01:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45809 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731411AbfLKQBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 11:01:49 -0500
Received: from 1.general.cascardo.us.vpn ([10.172.70.58] helo=calabresa)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <cascardo@canonical.com>)
        id 1if4Ql-00025a-M4; Wed, 11 Dec 2019 16:01:40 +0000
Date:   Wed, 11 Dec 2019 13:01:33 -0300
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
Message-ID: <20191211160133.GB4580@calabresa>
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
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 09:33:53AM -0600, Justin Forbes wrote:
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
>    373: 00000000000141bc  1376 FUNC    GLOBAL DEFAULT    1
> libbpf_num_possible_cpus [<localentry>: 8]
>    375: 000000000001869c   176 FUNC    GLOBAL DEFAULT    1 btf__free
> [<localentry>: 8]
[...]

This is a patch on binutils carried by Fedora:

https://src.fedoraproject.org/rpms/binutils/c/b8265c46f7ddae23a792ee8306fbaaeacba83bf8

" b8265c Have readelf display extra symbol information at the end of the line. "

It has the following comment:

# FIXME:    The proper fix would be to update the scripts that are expecting
#           a fixed output from readelf.  But it seems that some of them are
#           no longer being maintained.

This commit is from 2017, had it been on binutils upstream, maybe the situation
right now would be different.

Honestly, it seems the best way out is to filter the other information in the
libbpf Makefile.

Does the following patch work for you?


diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index 56ce6292071b..e6f99484d7d5 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -145,6 +145,7 @@ PC_FILE		:= $(addprefix $(OUTPUT),$(PC_FILE))
 
 GLOBAL_SYM_COUNT = $(shell readelf -s --wide $(BPF_IN_SHARED) | \
 			   cut -d "@" -f1 | sed 's/_v[0-9]_[0-9]_[0-9].*//' | \
+			   sed 's/\[.*\]//' | \
 			   awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$8}' | \
 			   sort -u | wc -l)
 VERSIONED_SYM_COUNT = $(shell readelf -s --wide $(OUTPUT)libbpf.so | \
@@ -217,6 +218,7 @@ check_abi: $(OUTPUT)libbpf.so
 		     "versioned in $(VERSION_SCRIPT)." >&2;		 \
 		readelf -s --wide $(OUTPUT)libbpf-in.o |		 \
 		    cut -d "@" -f1 | sed 's/_v[0-9]_[0-9]_[0-9].*//' |	 \
+		    sed 's/\[.*\]//' |					 \
 		    awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$8}'|   \
 		    sort -u > $(OUTPUT)libbpf_global_syms.tmp;		 \
 		readelf -s --wide $(OUTPUT)libbpf.so |			 \
