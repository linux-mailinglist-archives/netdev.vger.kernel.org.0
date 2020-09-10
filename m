Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70216264BD7
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 19:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725864AbgIJRup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 13:50:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45494 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727025AbgIJRue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 13:50:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599760232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Oc9SSvuXxYHkBDg1JbnZA739FJDROj6mx8oujVN34Go=;
        b=fhe9OrsdynpVL8p+oytAa6dlUyv/V1tBBtJX26qyIrrRV+1xuVWNJKSniOc0mYxTAB2xsO
        NOMkwXyoyQIsWZFN8OkD0R+cyaNI8bgJove5R1UD+29j8FWgKwbZkY+RwY33sq5fPzFxMk
        dKK/egkrcwtGHw20WKNsfM9/re2xi/A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-qlFLwe6bPgaMKD8d8SVWJw-1; Thu, 10 Sep 2020 13:50:30 -0400
X-MC-Unique: qlFLwe6bPgaMKD8d8SVWJw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 923341007479;
        Thu, 10 Sep 2020 17:50:28 +0000 (UTC)
Received: from carbon (unknown [10.40.208.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1BA27E8EB;
        Thu, 10 Sep 2020 17:50:15 +0000 (UTC)
Date:   Thu, 10 Sep 2020 19:50:14 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>, brouer@redhat.com
Subject: Re: [PATCHv11 bpf-next 2/5] xdp: add a new helper for dev map
 multicast support
Message-ID: <20200910195014.13ff24e4@carbon>
In-Reply-To: <87o8mearu5.fsf@toke.dk>
References: <20200903102701.3913258-1-liuhangbin@gmail.com>
        <20200907082724.1721685-1-liuhangbin@gmail.com>
        <20200907082724.1721685-3-liuhangbin@gmail.com>
        <20200909215206.bg62lvbvkmdc5phf@ast-mbp.dhcp.thefacebook.com>
        <20200910023506.GT2531@dhcp-12-153.nay.redhat.com>
        <a1bcd5e8-89dd-0eca-f779-ac345b24661e@gmail.com>
        <CAADnVQ+CooPL7Zu4Y-AJZajb47QwNZJU_rH7A3GSbV8JgA4AcQ@mail.gmail.com>
        <87o8mearu5.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Sep 2020 11:44:50 +0200
Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:

> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>=20
> > On Wed, Sep 9, 2020 at 8:30 PM David Ahern <dsahern@gmail.com> wrote: =
=20
> >> >
> >> > I think the packets modification (edit dst mac, add vlan tag, etc) s=
hould be
> >> > done on egress, which rely on David's XDP egress support. =20
> >>
> >> agreed. The DEVMAP used for redirect can have programs attached that
> >> update the packet headers - assuming you want to update them. =20
> >
> > Then you folks have to submit them as one set.
> > As-is the programmer cannot achieve correct behavior. =20
>=20
> The ability to attach a program to devmaps is already there. See:
>=20
> fbee97feed9b ("bpf: Add support to attach bpf program to a devmap entry")
>=20
> But now that you mention it, it does appear that this series is skipping
> the hook that will actually run such a program. Didn't realise that was
> in the caller of bq_enqueue() and not inside bq_enqueue() itself...

In the first revisions of Ahern's patchset (before fully integrated in
devmap), this was the case, but it changed in some of the last
revisions. (This also lost the sort-n-bulk effect in the process, that
optimize I-cache).  In these earlier revisions it operated on
xdp_frame's.  It would have been a lot easier for Hangbin's patch if
the devmap-prog operated on these xdp_frame's.

Maybe we should change the devmap-prog approach, and run this on the
xdp_frame's (in bq_xmit_all() to be precise) .  Hangbin's patchset
clearly shows that we need this "layer" between running the xdp_prog and
the devmap-prog.=20

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

