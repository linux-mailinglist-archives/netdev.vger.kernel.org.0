Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9053D112E4B
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 16:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbfLDP1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 10:27:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49233 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728256AbfLDP1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 10:27:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575473223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2lwIXgMuS4fQPvhpFYE841g9Z0lJi8SuqMdlRhxoWcs=;
        b=Kw8wYTx6/XJlW/3KfAbXjHi9ONbStjIYT5TfyO2EQCl4YNRU7nvETmZgUpW3lDAScdKO7i
        WXdYUZGSYvo4Ndlts6LMqN4wzdnzr4+y8nH/A7SPgoCS9D9kEUBrENLY1gjvnMc6QjkkDt
        KB7Xd17acSdIT6w+RK/iJ+qIEMJS4Vo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-NDKHiQmrMOiWI_VHJOLqbg-1; Wed, 04 Dec 2019 10:27:00 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 960F6802566;
        Wed,  4 Dec 2019 15:26:58 +0000 (UTC)
Received: from krava (ovpn-204-212.brq.redhat.com [10.40.204.212])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E54610246E3;
        Wed,  4 Dec 2019 15:26:51 +0000 (UTC)
Date:   Wed, 4 Dec 2019 16:26:49 +0100
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
Subject: Re: [RFC] bpf: Emit audit messages upon successful prog load and
 unload
Message-ID: <20191204152649.GB15573@krava>
References: <20191128091633.29275-1-jolsa@kernel.org>
 <CAHC9VhQ7zkXdz1V5hQ8PN68-NnCn56TjKA0wCL6ZjHy9Up8fuQ@mail.gmail.com>
 <20191203093837.GC17468@krava>
 <CAHC9VhRhMhsRPj1D2TY3O=Nc6Rx9=o1-Z5ZMjrCepfFY6VtdbQ@mail.gmail.com>
 <20191204140827.GB12431@krava>
 <CAHC9VhTrUQYp8Ubhu_B_fv-HSdwmgYRy+r1p9uKz7WcRfDQBKA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHC9VhTrUQYp8Ubhu_B_fv-HSdwmgYRy+r1p9uKz7WcRfDQBKA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: NDKHiQmrMOiWI_VHJOLqbg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 04, 2019 at 09:38:10AM -0500, Paul Moore wrote:

SNIP

> > +
> > +static const char * const bpf_audit_str[] =3D {
> > +       [BPF_AUDIT_LOAD]   =3D "LOAD",
> > +       [BPF_AUDIT_UNLOAD] =3D "UNLOAD",
> > +};
> > +
> > +static void bpf_audit_prog(const struct bpf_prog *prog, enum bpf_audit=
 op)
> > +{
> > +       struct audit_context *ctx =3D NULL;
> > +       struct audit_buffer *ab;
> > +
> > +       if (audit_enabled =3D=3D AUDIT_OFF)
> > +               return;
> > +       if (op =3D=3D BPF_AUDIT_LOAD)
> > +               ctx =3D audit_context();
> > +       ab =3D audit_log_start(ctx, GFP_ATOMIC, AUDIT_BPF);
> > +       if (unlikely(!ab))
> > +               return;
> > +       audit_log_format(ab, "prog-id=3D%u op=3D%s",
> > +                        prog->aux->id, bpf_audit_str[op]);
> > +       audit_log_end(ab);
> > +}
>=20
> As mentioned previously, I still think it might be a good idea to
> ensure "op" is within the bounds of bpf_audit_str, but the audit bits
> look reasonable to me.

ok, I'll add that, I'll send out full patch

thanks for the review,
jirka

