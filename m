Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77140E75E5
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 17:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731998AbfJ1QNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 12:13:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59905 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729832AbfJ1QNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 12:13:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572279199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DFiblGAKSFgYEKWTph3vJ5WK7UUGnBjGo40Q9X49580=;
        b=gEG95R6iGrg/b2qi3dyPVVzAH1Zw/WxDEuXPeqEO+bdvKGZD46nYNKmFfmFA/78snYAqpg
        nH+RDgEFxBn4MCUBKqd0sx4nXOoT1e6J2eJTKQW3ynb+XkKQrCnbsXDJrmr+nrJanFxYbP
        UsYoGSfnbmwcTrAbas6KN1Gd7ejlSsY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-BCnI5LkbOV28b2LVSkNTTg-1; Mon, 28 Oct 2019 12:13:18 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 980F1107AD28;
        Mon, 28 Oct 2019 16:13:16 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0FD5B5DA5B;
        Mon, 28 Oct 2019 16:13:04 +0000 (UTC)
Date:   Mon, 28 Oct 2019 17:13:03 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        "David Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>, brouer@redhat.com,
        Anton Protopopov <aspsk2@gmail.com>
Subject: Re: [PATCH bpf-next v3 4/4] selftests: Add tests for automatic map
 pinning
Message-ID: <20191028171303.3e7e4601@carbon>
In-Reply-To: <483546c6-14b9-e1f1-b4c1-424d6b8d4ace@fb.com>
References: <157220959547.48922.6623938299823744715.stgit@toke.dk>
        <157220959980.48922.12100884213362040360.stgit@toke.dk>
        <20191028140624.584bcc1e@carbon>
        <87imo9roxf.fsf@toke.dk>
        <483546c6-14b9-e1f1-b4c1-424d6b8d4ace@fb.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: BCnI5LkbOV28b2LVSkNTTg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Oct 2019 15:32:26 +0000
Yonghong Song <yhs@fb.com> wrote:

> On 10/28/19 6:15 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > Jesper Dangaard Brouer <brouer@redhat.com> writes:
> >  =20
> >> On Sun, 27 Oct 2019 21:53:19 +0100
> >> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
> >> =20
> >>> diff --git a/tools/testing/selftests/bpf/progs/test_pinning.c b/tools=
/testing/selftests/bpf/progs/test_pinning.c
> >>> new file mode 100644
> >>> index 000000000000..ff2d7447777e
> >>> --- /dev/null
> >>> +++ b/tools/testing/selftests/bpf/progs/test_pinning.c
> >>> @@ -0,0 +1,29 @@
> >>> +// SPDX-License-Identifier: GPL-2.0
> >>> +
> >>> +#include <linux/bpf.h>
> >>> +#include "bpf_helpers.h"
> >>> +
> >>> +int _version SEC("version") =3D 1;
> >>> +
> >>> +struct {
> >>> +=09__uint(type, BPF_MAP_TYPE_ARRAY);
> >>> +=09__uint(max_entries, 1);
> >>> +=09__type(key, __u32);
> >>> +=09__type(value, __u64);
> >>> +=09__uint(pinning, LIBBPF_PIN_BY_NAME);
> >>> +} pinmap SEC(".maps"); =20
> >>
> >> So, this is the new BTF-defined maps syntax.
> >>
> >> Please remind me, what version of LLVM do we need to compile this? =20
> >=20
> > No idea what the minimum version is. I'm running LLVM 9.0 :) =20
>=20
> LLVM 9.0 starts to support .maps.
> There is no dependency on pahole.

LLVM 9.0.0 is still very new:
 - 19 September 2019: LLVM 9.0.0 is now available

For my XDP-tutorial[1], I cannot required people to have this new llvm
version.  But I would like to teach people about this new syntax (note,
I can upgrade libbpf version via git-submodule, and update bpf_helpers.h).

To Andrii, any recommendations on how I can do the transition?=20

I'm thinking, it should be possible to define both ELF-object sections
SEC "maps" and ".maps" at the same time. But how does libbpf handle that?
(Who takes precedence?)


(Alternatively, I can detect the LLVM version, in the Makefile, and have
a #ifdef define in the code)
--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

[1] https://github.com/xdp-project/xdp-tutorial

