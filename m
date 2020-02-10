Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E887157F8B
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 17:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbgBJQSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 11:18:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38897 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727599AbgBJQSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 11:18:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581351483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kLXBw1zL/2+Ww2WBo1LdiP+jpRFTEQIfB+dk7t2Uz4I=;
        b=MT2G/mnbwQStvt2qfuHosndbvX71mGo16C/H/KM+rQJ4cta30du9kp35VFHqsUZS3mIrHD
        9Sw6AbeVxMZ+feY6zgl42gGOh345d9653J9mwpgtYpwKMfl2HzlPaVsnRjGh5CYGSAFFK9
        MJoQuXutBQCCEEakWbzaI9SNxm1Y3fs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-D2pOxu0hOzWyUo5xHzubLg-1; Mon, 10 Feb 2020 11:17:59 -0500
X-MC-Unique: D2pOxu0hOzWyUo5xHzubLg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0026800D55;
        Mon, 10 Feb 2020 16:17:56 +0000 (UTC)
Received: from krava (unknown [10.43.17.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D62F410013A7;
        Mon, 10 Feb 2020 16:17:53 +0000 (UTC)
Date:   Mon, 10 Feb 2020 17:17:51 +0100
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
Message-ID: <20200210161751.GC28110@krava>
References: <20200208154209.1797988-1-jolsa@kernel.org>
 <CAJ+HfNhBDU9c4-0D5RiHFZBq_LN7E=k8=rhL+VbmxJU7rdDBxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CAJ+HfNhBDU9c4-0D5RiHFZBq_LN7E=k8=rhL+VbmxJU7rdDBxQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

yea strange.. it should be picked up from /proc/kallsyms as
fallback if there's no other source, I'll check on that
(might be the problem with perf depending on address going
only higher in /proc/kallsyms, while bpf symbols are at the
end and start over from the lowest bpf address)

anyway, in perf we enumerate bpf_progs via the perf events
PERF_BPF_EVENT_PROG_LOAD,PERF_BPF_EVENT_PROG_UNLOAD interface
together with PERF_RECORD_KSYMBOL_TYPE_BPF events

we might need to add something like:
  PERF_RECORD_KSYMBOL_TYPE_BPF_TRAMPOLINE
  PERF_RECORD_KSYMBOL_TYPE_BPF_DISPATCHER

to notify about the area, I'll check on that

however the /proc/kallsyms fallback should work in any
case.. thanks for report ;-)

jirka

