Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3305415A6DF
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 11:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgBLKrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 05:47:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34034 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727347AbgBLKq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 05:46:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581504418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vOJN708VgW9Z5byuJ0EoT8tB8XT5uOhixHyoS0jdxRg=;
        b=HpVWKLZ45NK4ZyngNqmVSUkEUdKpdUtmO1+x9wsHwfh/gD+I5Qu5UQP3je9DIN/yI3NrFo
        PeqMdmHKdDMhAhKnDlv5xv/jWTxT86HZR8A9hsNyUQt9Z+SRd+CmXi9BjcK+FqJLMx284h
        PdDjuQoukPi8AdWIhctl+tL77U2QxGo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-T-oQ12IyP12czaPgmJnI2w-1; Wed, 12 Feb 2020 05:46:54 -0500
X-MC-Unique: T-oQ12IyP12czaPgmJnI2w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA4121137847;
        Wed, 12 Feb 2020 10:46:52 +0000 (UTC)
Received: from krava (ovpn-204-247.brq.redhat.com [10.40.204.247])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A574990073;
        Wed, 12 Feb 2020 10:46:49 +0000 (UTC)
Date:   Wed, 12 Feb 2020 11:46:47 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Subject: Re: [PATCH 00/14] bpf: Add trampoline and dispatcher to
 /proc/kallsyms
Message-ID: <20200212104647.GB183981@krava>
References: <20200208154209.1797988-1-jolsa@kernel.org>
 <20200211191347.GH3416@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20200211191347.GH3416@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 11, 2020 at 04:13:47PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Sat, Feb 08, 2020 at 04:41:55PM +0100, Jiri Olsa escreveu:
> > hi,
> > this patchset adds trampoline and dispatcher objects
> > to be visible in /proc/kallsyms. The last patch also
> > adds sorting for all bpf objects in /proc/kallsyms.
>=20
> This will allow those to appear in profiles, right? That would be

yea, one would think so.. but as you saw in the other email
there are still some issues ;-)

> interesting to explicitely state, i.e. the _why_ of this patch, not jus=
t
> the _what_.

I guess another reason would be accountability of the kernel space,
so that everything with the symbol would appear in /proc/kallsyms

jirka

>=20
> Thanks,
>=20
> - Arnaldo
> =20
> >   $ sudo cat /proc/kallsyms | tail -20
> >   ...
> >   ffffffffa050f000 t bpf_prog_5a2b06eab81b8f51    [bpf]
> >   ffffffffa0511000 t bpf_prog_6deef7357e7b4530    [bpf]
> >   ffffffffa0542000 t bpf_trampoline_13832 [bpf]
> >   ffffffffa0548000 t bpf_prog_96f1b5bf4e4cc6dc_mutex_lock [bpf]
> >   ffffffffa0572000 t bpf_prog_d1c63e29ad82c4ab_bpf_prog1  [bpf]
> >   ffffffffa0585000 t bpf_prog_e314084d332a5338__dissect   [bpf]
> >   ffffffffa0587000 t bpf_prog_59785a79eac7e5d2_mutex_unlock       [bp=
f]
> >   ffffffffa0589000 t bpf_prog_d0db6e0cac050163_mutex_lock [bpf]
> >   ffffffffa058d000 t bpf_prog_d8f047721e4d8321_bpf_prog2  [bpf]
> >   ffffffffa05df000 t bpf_trampoline_25637 [bpf]
> >   ffffffffa05e3000 t bpf_prog_d8f047721e4d8321_bpf_prog2  [bpf]
> >   ffffffffa05e5000 t bpf_prog_3b185187f1855c4c    [bpf]
> >   ffffffffa05e7000 t bpf_prog_d8f047721e4d8321_bpf_prog2  [bpf]
> >   ffffffffa05eb000 t bpf_prog_93cebb259dd5c4b2_do_sys_open        [bp=
f]
> >   ffffffffa0677000 t bpf_dispatcher_xdp   [bpf]
> >=20
> > thanks,
> > jirka
> >=20
> >=20
> > ---
> > Bj=F6rn T=F6pel (1):
> >       bpf: Add bpf_trampoline_ name prefix for DECLARE_BPF_DISPATCHER
> >=20
> > Jiri Olsa (13):
> >       x86/mm: Rename is_kernel_text to __is_kernel_text
> >       bpf: Add struct bpf_ksym
> >       bpf: Add name to struct bpf_ksym
> >       bpf: Add lnode list node to struct bpf_ksym
> >       bpf: Add bpf_kallsyms_tree tree
> >       bpf: Move bpf_tree add/del from bpf_prog_ksym_node_add/del
> >       bpf: Separate kallsyms add/del functions
> >       bpf: Add bpf_ksym_add/del functions
> >       bpf: Re-initialize lnode in bpf_ksym_del
> >       bpf: Rename bpf_tree to bpf_progs_tree
> >       bpf: Add trampolines to kallsyms
> >       bpf: Add dispatchers to kallsyms
> >       bpf: Sort bpf kallsyms symbols
> >=20
> >  arch/x86/mm/init_32.c   |  14 ++++++----
> >  include/linux/bpf.h     |  54 ++++++++++++++++++++++++++------------
> >  include/linux/filter.h  |  13 +++-------
> >  kernel/bpf/core.c       | 182 ++++++++++++++++++++++++++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------=
----------------
> >  kernel/bpf/dispatcher.c |   6 +++++
> >  kernel/bpf/trampoline.c |  23 ++++++++++++++++
> >  kernel/events/core.c    |   4 +--
> >  net/core/filter.c       |   5 ++--
> >  8 files changed, 219 insertions(+), 82 deletions(-)
> >=20
>=20
> --=20
>=20
> - Arnaldo
>=20

