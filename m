Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC7C15C824
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 17:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgBMQX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 11:23:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54225 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727772AbgBMQX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 11:23:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581611036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i18q2PNF44L0tvEOum/zQP+bXFTOtAUWikKBvD1Xl0I=;
        b=ckamZdNYv4Kbdn90aBkfEaFFg7G43p+NRsHZphYZPhJnF7CtHOmKJXvtHogHU4KwVSFMsT
        DYeiOkZv1N7j1I5Fn9eJDbdM7NeZqnI6DMDI82uYlJKu26t04ianZwxAXxL5U3VN06+T2r
        j8qG8uVYYUeCLP6kcMzzq2xW8U9mZZ8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-eTXqlYJSOLi-Ox_QbJVGwg-1; Thu, 13 Feb 2020 11:23:49 -0500
X-MC-Unique: eTXqlYJSOLi-Ox_QbJVGwg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E6C88018A7;
        Thu, 13 Feb 2020 16:23:47 +0000 (UTC)
Received: from krava (unknown [10.43.17.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A36E25C1BB;
        Thu, 13 Feb 2020 16:23:44 +0000 (UTC)
Date:   Thu, 13 Feb 2020 17:23:42 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Subject: Re: [PATCH 00/14] bpf: Add trampoline and dispatcher to
 /proc/kallsyms
Message-ID: <20200213162342.GB296320@krava>
References: <20200208154209.1797988-1-jolsa@kernel.org>
 <CAJ+HfNhBDU9c4-0D5RiHFZBq_LN7E=k8=rhL+VbmxJU7rdDBxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CAJ+HfNhBDU9c4-0D5RiHFZBq_LN7E=k8=rhL+VbmxJU7rdDBxQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 10, 2020 at 04:51:08PM +0100, Bj=F6rn T=F6pel wrote:
> On Sat, 8 Feb 2020 at 16:42, Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > hi,
> > this patchset adds trampoline and dispatcher objects
> > to be visible in /proc/kallsyms. The last patch also
> > adds sorting for all bpf objects in /proc/kallsyms.
> >
>=20
> Thanks for working on this!
>=20
> I'm probably missing something with my perf setup; I've applied your
> patches, and everything seem to work fine from an kallsyms
> perspective:
>=20
> # grep bpf_dispatcher_xdp /proc/kallsyms
> ...
> ffffffffc0511000 t bpf_dispatcher_xdp   [bpf]
>=20
> However, when I run
> # perf top
>=20
> I still see the undecorated one:
> 0.90%  [unknown]                  [k] 0xffffffffc0511037
>=20
> Any ideas?

heya,
the code is little rusty and needs some fixing :-\

with the patch below on top of Arnaldo's perf/urgent branch,
there's one workaround for now:

  # perf record --vmlinux /proc/kallsyms=20
  ^C[ perf record: Woken up 0 times to write data ]
  [ perf record: Captured and wrote 18.954 MB perf.data (348693 samples) =
]

  # perf report --kallsyms /proc/kallsyms | grep bpf_trampoline_13795
     0.01%  sched-messaging  kallsyms                                [k] =
bpf_trampoline_13795
     0.00%  perf             kallsyms                                [k] =
bpf_trampoline_13795
     0.00%  :47547           kallsyms                                [k] =
bpf_trampoline_13795
     0.00%  :47546           kallsyms                                [k] =
bpf_trampoline_13795
     0.00%  :47544           kallsyms                                [k] =
bpf_trampoline_13795

with recent kcore/vmlinux changes we neglected kallsyms fallback,
I'm preparing changes that will detect and use it automaticaly

jirka


---
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index fb5c2cd44d30..463ada5117f8 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -742,6 +742,7 @@ static int machine__process_ksymbol_register(struct m=
achine *machine,
 		map->start =3D event->ksymbol.addr;
 		map->end =3D map->start + event->ksymbol.len;
 		maps__insert(&machine->kmaps, map);
+		dso__set_loaded(dso);
 	}
=20
 	sym =3D symbol__new(map->map_ip(map, map->start),

