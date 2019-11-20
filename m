Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD251045C9
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 22:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbfKTVaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 16:30:24 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58176 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725854AbfKTVaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 16:30:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574285422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rtwpA4pT/CgUxGCYsbiwstNxREBeZqu/WGJTSfvVrww=;
        b=VZpR92FKcCDNmLf+8nX0xJ4ixIrHosO1DVV6Pc76wpwEyJ6h+ODtpF7hQtZJVKvxQch3CI
        saLrWT4MhLYWkFA7VTyu4COASvdATSii2oxV06YLsb5YlAQLw/zu3GUEEe72vV2MqvwzeP
        MLr8ChhO8eVzL9jcCyiD+LFgiy7ErDE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-x1AVbhzYMWWY7W_5uvBRdQ-1; Wed, 20 Nov 2019 16:30:19 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7BF0818C35A2;
        Wed, 20 Nov 2019 21:30:17 +0000 (UTC)
Received: from krava (ovpn-204-103.brq.redhat.com [10.40.204.103])
        by smtp.corp.redhat.com (Postfix) with SMTP id 52FF351C85;
        Wed, 20 Nov 2019 21:30:12 +0000 (UTC)
Date:   Wed, 20 Nov 2019 22:30:11 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Steve Grubb <sgrubb@redhat.com>,
        David Miller <davem@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@redhat.com>, Jiri Benc <jbenc@redhat.com>
Subject: Re: [RFC] bpf: emit audit messages upon successful prog load and
 unload
Message-ID: <20191120213011.GA6829@krava>
References: <20191120143810.8852-1-jolsa@kernel.org>
 <20191120211438.x5dn2ns755bv3q63@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
In-Reply-To: <20191120211438.x5dn2ns755bv3q63@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: x1AVbhzYMWWY7W_5uvBRdQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 01:14:40PM -0800, Alexei Starovoitov wrote:
> On Wed, Nov 20, 2019 at 03:38:10PM +0100, Jiri Olsa wrote:
> >=20
> > The only info really needed from BPF side is the globally unique
> > prog ID where then audit user space tooling can query / dump all
> > info needed about the specific BPF program right upon load event
> > and enrich the record, thus these changes needed here can be kept
> > small and non-intrusive to the core.
>=20
> ...
>=20
> > +static void bpf_audit_prog(const struct bpf_prog *prog, enum bpf_event=
 event)
> > +{
> > +=09bool has_task_context =3D event =3D=3D BPF_EVENT_LOAD;
> > +=09struct audit_buffer *ab;
> > +
> > +=09if (audit_enabled =3D=3D AUDIT_OFF)
> > +=09=09return;
> > +=09ab =3D audit_log_start(audit_context(), GFP_ATOMIC, AUDIT_BPF);
> > +=09if (unlikely(!ab))
> > +=09=09return;
> > +=09if (has_task_context)
> > +=09=09audit_log_task(ab);
> > +=09audit_log_format(ab, "%sprog-id=3D%u event=3D%s",
> > +=09=09=09 has_task_context ? " " : "",
> > +=09=09=09 prog->aux->id, bpf_event_audit_str[event]);
> > +=09audit_log_end(ab);
>=20
> Single prog ID is enough for perf_event based framework to track everythi=
ng
> about the programs and should be enough for audit.
> Could you please resend as proper patch with explicit 'From:' ?
> Since I'm not sure what is the proper authorship of the patch.. Daniel's =
or yours.

it's Daniel's I'll resend

jirka

