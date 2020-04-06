Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D214019F646
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 15:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbgDFNAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 09:00:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50877 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728144AbgDFNAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 09:00:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586178040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NYol29NYhDl9/p2i+3iMB21EckDmpEIsAkQKwZjRPUs=;
        b=FQlzBLaZyqXqsbKVm0iZ4X7rZZf79BJxhOHAegl6Ux0/3CHaSSo0rhzmWyZb67b3EQzLb4
        oZ+88XoTJs/vz+/JfBLKIiz7tDMA9/qDBI3YFIO55ymz/XGU1f5dZLZeJKwFIL6NDosdMZ
        o6csNu45LLSvjzRcQ0EoriYOeJp6WFw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-ZZG-eqcBMmufViv3LVUzJg-1; Mon, 06 Apr 2020 09:00:30 -0400
X-MC-Unique: ZZG-eqcBMmufViv3LVUzJg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03C0C1922967;
        Mon,  6 Apr 2020 13:00:28 +0000 (UTC)
Received: from krava (unknown [10.40.192.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 248056EF97;
        Mon,  6 Apr 2020 13:00:23 +0000 (UTC)
Date:   Mon, 6 Apr 2020 15:00:21 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Song Liu <song@kernel.org>
Subject: Re: [PATCH 13/15] perf tools: Synthesize bpf_trampoline/dispatcher
 ksymbol event
Message-ID: <20200406130021.GB3035739@krava>
References: <20200312195610.346362-1-jolsa@kernel.org>
 <20200312195610.346362-14-jolsa@kernel.org>
 <20200406125412.GA29826@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200406125412.GA29826@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 06, 2020 at 09:54:12AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Mar 12, 2020 at 08:56:08PM +0100, Jiri Olsa escreveu:
> > +static int
> > +process_bpf_image(char *name, u64 addr, struct kallsyms_parse *data)
> > +{
> > +	struct machine *machine =3D data->machine;
> > +	union perf_event *event =3D data->event;
> > +	struct perf_record_ksymbol *ksymbol;
> > +
> > +	ksymbol =3D &event->ksymbol;
> > +
> > +	*ksymbol =3D (struct perf_record_ksymbol) {
> > +		.header =3D {
> > +			.type =3D PERF_RECORD_KSYMBOL,
> > +			.size =3D offsetof(struct perf_record_ksymbol, name),
> > +		},
> > +		.addr      =3D addr,
> > +		.len       =3D page_size,
> > +		.ksym_type =3D PERF_RECORD_KSYMBOL_TYPE_BPF,
> > +		.flags     =3D 0,
> > +	};
> > +
> > +	strncpy(ksymbol->name, name, KSYM_NAME_LEN);
> > +	ksymbol->header.size +=3D PERF_ALIGN(strlen(name) + 1, sizeof(u64))=
;
> > +	memset((void *) event + event->header.size, 0, machine->id_hdr_size=
);
> > +	event->header.size +=3D machine->id_hdr_size;
> > +
> > +	return perf_tool__process_synth_event(data->tool, event, machine,
> > +					      data->process);
>=20
> This explodes in fedora 32 and rawhide and in openmandriva:cooker:
>=20
>   GEN      /tmp/build/perf/python/perf.so
>   CC       /tmp/build/perf/util/bpf-event.o
> In file included from /usr/include/string.h:495,
>                  from /git/perf/tools/lib/bpf/libbpf_common.h:12,
>                  from /git/perf/tools/lib/bpf/bpf.h:31,
>                  from util/bpf-event.c:4:
> In function =E2=80=98strncpy=E2=80=99,
>     inlined from =E2=80=98process_bpf_image=E2=80=99 at util/bpf-event.=
c:323:2,
>     inlined from =E2=80=98kallsyms_process_symbol=E2=80=99 at util/bpf-=
event.c:358:9:
> /usr/include/bits/string_fortified.h:106:10: error: =E2=80=98__builtin_=
strncpy=E2=80=99 specified bound 256 equals destination size [-Werror=3Ds=
tringop-truncation]
>   106 |   return __builtin___strncpy_chk (__dest, __src, __len, __bos (=
__dest));
>       |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~
> cc1: all warnings being treated as errors
> mv: cannot stat '/tmp/build/perf/util/.bpf-event.o.tmp': No such file o=
r directory
> make[4]: *** [/git/perf/tools/build/Makefile.build:97: /tmp/build/perf/=
util/bpf-event.o] Error 1
> make[3]: *** [/git/perf/tools/build/Makefile.build:139: util] Error 2
> make[2]: *** [Makefile.perf:617: /tmp/build/perf/perf-in.o] Error 2
> make[1]: *** [Makefile.perf:225: sub-make] Error 2
> make: *** [Makefile:70: all] Error 2
> make: Leaving directory '/git/perf/tools/perf'
> [perfbuilder@fc58e82bfba4 ~]$
>=20
> So I patched it a bit, please ack:

perfect, thanks

Acked-by: Jiri Olsa <jolsa@redhat.com>

jirka

>=20
>=20
> diff --git a/tools/perf/util/bpf-event.c b/tools/perf/util/bpf-event.c
> index 3728db98981e..0cd41a862952 100644
> --- a/tools/perf/util/bpf-event.c
> +++ b/tools/perf/util/bpf-event.c
> @@ -306,6 +306,7 @@ process_bpf_image(char *name, u64 addr, struct kall=
syms_parse *data)
>  	struct machine *machine =3D data->machine;
>  	union perf_event *event =3D data->event;
>  	struct perf_record_ksymbol *ksymbol;
> +	int len;
> =20
>  	ksymbol =3D &event->ksymbol;
> =20
> @@ -320,8 +321,8 @@ process_bpf_image(char *name, u64 addr, struct kall=
syms_parse *data)
>  		.flags     =3D 0,
>  	};
> =20
> -	strncpy(ksymbol->name, name, KSYM_NAME_LEN);
> -	ksymbol->header.size +=3D PERF_ALIGN(strlen(name) + 1, sizeof(u64));
> +	len =3D scnprintf(ksymbol->name, KSYM_NAME_LEN, "%s", name);
> +	ksymbol->header.size +=3D PERF_ALIGN(len + 1, sizeof(u64));
>  	memset((void *) event + event->header.size, 0, machine->id_hdr_size);
>  	event->header.size +=3D machine->id_hdr_size;
> =20
>=20

