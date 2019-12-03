Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D557010FA1E
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 09:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbfLCIqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 03:46:40 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:35923 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726008AbfLCIqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 03:46:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575362798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6S/cp50CX4iCq+Gvl9oMm5iLtDZ8r5C5Y48vBVIfKoc=;
        b=L328nOM4fFmsIziZ+iVlO5lF238xG9QBtLoaz7UHdSYRSDDC6Inu3dhuXsN/oXUF/jF9fN
        bYTyJ0ElQ6N+y/ztkau0oJTM0XvS2xl5Rs4WQ4DhVu4KoAZrMKUrLIjhtPlGO0a8Uc0SQM
        NZbq3VyjaFHFmlgC8qna+QKunqsCY4A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-OI-lXgHtO6yoe-yoPLTHhw-1; Tue, 03 Dec 2019 03:46:34 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5175F800D4E;
        Tue,  3 Dec 2019 08:46:33 +0000 (UTC)
Received: from krava (unknown [10.43.17.48])
        by smtp.corp.redhat.com (Postfix) with SMTP id D89B667E58;
        Tue,  3 Dec 2019 08:46:27 +0000 (UTC)
Date:   Tue, 3 Dec 2019 09:46:26 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Steve Grubb <sgrubb@redhat.com>
Cc:     Paul Moore <paul@paul-moore.com>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-audit@redhat.com,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>,
        Eric Paris <eparis@redhat.com>, Jiri Benc <jbenc@redhat.com>
Subject: Re: [RFC] bpf: Emit audit messages upon successful prog load and
 unload
Message-ID: <20191203084626.GB17468@krava>
References: <20191128091633.29275-1-jolsa@kernel.org>
 <CAHC9VhQ7zkXdz1V5hQ8PN68-NnCn56TjKA0wCL6ZjHy9Up8fuQ@mail.gmail.com>
 <1915471.OmxkCOUsnW@x2>
MIME-Version: 1.0
In-Reply-To: <1915471.OmxkCOUsnW@x2>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: OI-lXgHtO6yoe-yoPLTHhw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 02, 2019 at 11:57:22PM -0500, Steve Grubb wrote:
> On Monday, December 2, 2019 6:00:14 PM EST Paul Moore wrote:
> > On Thu, Nov 28, 2019 at 4:16 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > > From: Daniel Borkmann <daniel@iogearbox.net>
> > >=20
> > > Allow for audit messages to be emitted upon BPF program load and
> > > unload for having a timeline of events. The load itself is in
> > > syscall context, so additional info about the process initiating
> > > the BPF prog creation can be logged and later directly correlated
> > > to the unload event.
> > >=20
> > > The only info really needed from BPF side is the globally unique
> > > prog ID where then audit user space tooling can query / dump all
> > > info needed about the specific BPF program right upon load event
> > > and enrich the record, thus these changes needed here can be kept
> > > small and non-intrusive to the core.

SNIP

> > I think you would probably also want to check the results of
> > audit_dummy_context() here as well, see all the various audit_XXX()
> > functions in include/linux/audit.h as an example.  You'll see a
> > pattern similar to the following:
> >=20
> > static inline void audit_foo(...)
> > {
> >   if (unlikely(!audit_dummy_context()))
> >     __audit_foo(...)
> > }
> >=20
> > > +       ab =3D audit_log_start(audit_context(), GFP_ATOMIC, AUDIT_BPF=
);
> > > +       if (unlikely(!ab))
> > > +               return;
> > > +       audit_log_format(ab, "prog-id=3D%u op=3D%s",
> > > +                        prog->aux->id, bpf_audit_str[op]);
> >=20
> > Is it worth putting some checks in here to make sure that you don't
> > blow past the end of the bpf_audit_str array?
>=20
> I am wondering if prog-id was really the only information that was needed=
? Is=20
> it meaningful to other tools? Does that correlate to anything in /proc? I=
n=20
> earlier discussion, it sounded like more information was needed to be sur=
e=20
> what was happening.

yep, as David mentions in the changelog the global ID is enough,
because you can get all the other bpf program info based on that

jirka

