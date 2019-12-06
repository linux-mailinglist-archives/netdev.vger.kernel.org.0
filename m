Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6A5311589F
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 22:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbfLFV2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 16:28:03 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44939 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726374AbfLFV2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 16:28:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575667681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2wJ/YH9KiJsVMxrYHZBuzEJYI4gfnVwP4GhZP67AX9Y=;
        b=eEiY8ZlneIAuaRKIOkJYQ+yzXInofs2SF0VkKmpbXDbZgzSQwj00M/31cnfNqc0wR5ya1J
        w2mw3QXp6KcUUOAZNIYSzoMpkG2pXALXugfkIz6qexlaeilkBfpuT66t5ZVEjZXKWcK+ZJ
        2S17Py6F+wgUlgv2Ep02LulGdKP5jqA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-77-BvbVW_NrPRCS_qf3f47GHQ-1; Fri, 06 Dec 2019 16:27:57 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42285DBCF;
        Fri,  6 Dec 2019 21:27:55 +0000 (UTC)
Received: from krava (ovpn-204-89.brq.redhat.com [10.40.204.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 50E405C1D4;
        Fri,  6 Dec 2019 21:27:49 +0000 (UTC)
Date:   Fri, 6 Dec 2019 22:27:46 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-audit@redhat.com,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Steve Grubb <sgrubb@redhat.com>,
        David Miller <davem@redhat.com>,
        Eric Paris <eparis@redhat.com>, Jiri Benc <jbenc@redhat.com>
Subject: Re: [PATCHv2] bpf: Emit audit messages upon successful prog load and
 unload
Message-ID: <20191206212746.GA30691@krava>
References: <20191205102552.19407-1-jolsa@kernel.org>
 <CAHC9VhTWnNvfMAPz-WhD9Wqv6UZZDBdMxF9VuS3UeTLHLtfhHw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHC9VhTWnNvfMAPz-WhD9Wqv6UZZDBdMxF9VuS3UeTLHLtfhHw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: BvbVW_NrPRCS_qf3f47GHQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 06, 2019 at 04:11:13PM -0500, Paul Moore wrote:

SNIP

> >
> >  #define IS_FD_ARRAY(map) ((map)->map_type =3D=3D BPF_MAP_TYPE_PERF_EVE=
NT_ARRAY || \
> > @@ -1306,6 +1307,36 @@ static int find_prog_type(enum bpf_prog_type typ=
e, struct bpf_prog *prog)
> >         return 0;
> >  }
> >
> > +enum bpf_audit {
> > +       BPF_AUDIT_LOAD,
> > +       BPF_AUDIT_UNLOAD,
> > +       BPF_AUDIT_MAX,
> > +};
> > +
> > +static const char * const bpf_audit_str[BPF_AUDIT_MAX] =3D {
> > +       [BPF_AUDIT_LOAD]   =3D "LOAD",
> > +       [BPF_AUDIT_UNLOAD] =3D "UNLOAD",
> > +};
> > +
> > +static void bpf_audit_prog(const struct bpf_prog *prog, unsigned int o=
p)
> > +{
> > +       struct audit_context *ctx =3D NULL;
> > +       struct audit_buffer *ab;
> > +
> > +       if (audit_enabled =3D=3D AUDIT_OFF)
> > +               return;
> > +       if (WARN_ON_ONCE(op >=3D BPF_AUDIT_MAX))
> > +               return;
>=20
> I feel bad saying this given the number of revisions we are at with
> this patch, but since we aren't even at -rc1 yet (although it will be
> here soon), I'm going to mention it anyway ;)
>=20
> ... if we move the "op >=3D BPF_AUDIT_MAX" above the audit_enabled check
> we will catch problems sooner in development, which is a very good
> thing as far as I'm concerned.

sure, np will post v3

>=20
> Other than that, this looks good to me, and I see Steve has already
> given the userspace portion a thumbs-up.  Have you started on the
> audit-testsuite test for this yet?

yep, it's ready.. waiting for kernel change ;-)
https://github.com/olsajiri/audit-testsuite/commit/16888ea7f14fa0269feef623=
d2a96f15f9ea71c9

jirka

