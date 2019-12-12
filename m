Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D18E11C1B0
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 01:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbfLLAyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 19:54:04 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:52829 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727235AbfLLAyE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 19:54:04 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47YFfg4PNdz9sPL;
        Thu, 12 Dec 2019 11:53:47 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1576112041;
        bh=xP4wAChxRtmz838D7Vove34rD2wPRk8iB6jI8lbLBng=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=k59qNnW2EuyQcr+fPSATZIvgOx8NavMUB6nPinviztt5O+TUF8w4DuoQ/U3nx3scs
         rg5FT0dYjnl9Kt34VRtUCe88ZU6Ik+cxA0kwsRVvJ26XTfrlcrpffFmK7aSrre4CPk
         XNZOId+FR4OqjHERyiJV9uAYjBjXlF9DwUh6ucFGje+22fQhygi/lCHOCR0CXYNFPH
         e/x3EZ14HOnX6IMTLRQixX9PcDS9lN9y0g23WSKDUHWWyAYZS4kW7/sK9wMAc7OssW
         VA/Em+7j/04lsGPc8gHxBzuiyWAIqFMrfRcXeuteEHBes3BqeuHyrH+KS4gliAKV4w
         9prgTXTjbiHDg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Justin Forbes <jmforbes@linuxtx.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list\:BPF \(Safe dynamic programs and tools\)" 
        <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        "open list\:BPF \(Safe dynamic programs and tools\)" 
        <bpf@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org,
        Martin KaFai Lau <kafai@fb.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        debian-kernel@lists.debian.org, Nick Clifton <nickc@redhat.com>
Subject: Re: [PATCH] libbpf: fix readelf output parsing on powerpc with recent binutils
In-Reply-To: <20191211160133.GB4580@calabresa>
References: <20191201195728.4161537-1-aurelien@aurel32.net> <87zhgbe0ix.fsf@mpe.ellerman.id.au> <20191202093752.GA1535@localhost.localdomain> <CAFxkdAqg6RaGbRrNN3e_nHfHFR-xxzZgjhi5AnppTxxwdg0VyQ@mail.gmail.com> <20191210222553.GA4580@calabresa> <CAFxkdAp6Up0qSyp0sH0O1yD+5W3LvY-+-iniBrorcz2pMV+y-g@mail.gmail.com> <20191211160133.GB4580@calabresa>
Date:   Thu, 12 Dec 2019 11:53:47 +1100
Message-ID: <87a77ypdno.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thadeu Lima de Souza Cascardo <cascardo@canonical.com> writes:
> On Wed, Dec 11, 2019 at 09:33:53AM -0600, Justin Forbes wrote:
>> On Tue, Dec 10, 2019 at 4:26 PM Thadeu Lima de Souza Cascardo
>> <cascardo@canonical.com> wrote:
>> >
>> > On Tue, Dec 10, 2019 at 12:58:33PM -0600, Justin Forbes wrote:
>> > > On Mon, Dec 2, 2019 at 3:37 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> > > >
>> > > > On Mon, Dec 02, 2019 at 04:53:26PM +1100, Michael Ellerman wrote:
>> > > > > Aurelien Jarno <aurelien@aurel32.net> writes:
>> > > > > > On powerpc with recent versions of binutils, readelf outputs an extra
>> > > > > > field when dumping the symbols of an object file. For example:
>> > > > > >
>> > > > > >     35: 0000000000000838    96 FUNC    LOCAL  DEFAULT [<localentry>: 8]     1 btf_is_struct
>> > > > > >
>> > > > > > The extra "[<localentry>: 8]" prevents the GLOBAL_SYM_COUNT variable to
>> > > > > > be computed correctly and causes the checkabi target to fail.
>> > > > > >
>> > > > > > Fix that by looking for the symbol name in the last field instead of the
>> > > > > > 8th one. This way it should also cope with future extra fields.
>> > > > > >
>> > > > > > Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
>> > > > > > ---
>> > > > > >  tools/lib/bpf/Makefile | 4 ++--
>> > > > > >  1 file changed, 2 insertions(+), 2 deletions(-)
>> > > > >
>> > > > > Thanks for fixing that, it's been on my very long list of test failures
>> > > > > for a while.
>> > > > >
>> > > > > Tested-by: Michael Ellerman <mpe@ellerman.id.au>
>> > > >
>> > > > Looks good & also continues to work on x86. Applied, thanks!
>> > >
>> > > This actually seems to break horribly on PPC64le with binutils 2.33.1
>> > > resulting in:
>> > > Warning: Num of global symbols in sharedobjs/libbpf-in.o (32) does NOT
>> > > match with num of versioned symbols in libbpf.so (184). Please make
>> > > sure all LIBBPF_API symbols are versioned in libbpf.map.
>> > >
>> > > This is the only arch that fails, with x86/arm/aarch64/s390 all
>> > > building fine.  Reverting this patch allows successful build across
>> > > all arches.
>> > >
>> > > Justin
>> >
>> > Well, I ended up debugging this same issue and had the same fix as Jarno's when
>> > I noticed his fix was already applied.
>> >
>> > I just installed a system with the latest binutils, 2.33.1, and it still breaks
>> > without such fix. Can you tell what is the output of the following command on
>> > your system?
>> >
>> > readelf -s --wide tools/lib/bpf/sharedobjs/libbpf-in.o | cut -d "@" -f1 | sed 's/_v[0-9]_[0-9]_[0-9].*//' | awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $0}'
>> >
>> 
>> readelf -s --wide tools/lib/bpf/sharedobjs/libbpf-in.o | cut -d "@"
>> -f1 | sed 's/_v[0-9]_[0-9]_[0-9].*//' | awk '/GLOBAL/ && /DEFAULT/ &&
>> !/UND/ {print $0}'
>>    373: 00000000000141bc  1376 FUNC    GLOBAL DEFAULT    1
>> libbpf_num_possible_cpus [<localentry>: 8]
>>    375: 000000000001869c   176 FUNC    GLOBAL DEFAULT    1 btf__free
>> [<localentry>: 8]
> [...]
>
> This is a patch on binutils carried by Fedora:
>
> https://src.fedoraproject.org/rpms/binutils/c/b8265c46f7ddae23a792ee8306fbaaeacba83bf8
>
> " b8265c Have readelf display extra symbol information at the end of the line. "
>
> It has the following comment:
>
> # FIXME:    The proper fix would be to update the scripts that are expecting
> #           a fixed output from readelf.  But it seems that some of them are
> #           no longer being maintained.
>
> This commit is from 2017, had it been on binutils upstream, maybe the situation
> right now would be different.

Bleeping bleep.

Looks like it was actually ruby that was the original problem:

  https://bugzilla.redhat.com/show_bug.cgi?id=1479302


Why it wasn't hacked around in the ruby package I don't know, doing it in
the distro binutils package is not ideal.

cheers
