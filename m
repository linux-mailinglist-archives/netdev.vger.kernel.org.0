Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7497A1FABD2
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 11:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgFPJEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 05:04:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28241 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725710AbgFPJEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 05:04:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592298260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ka0//B8iqVe7XF0DH1uWb/HCvgCVFTO+HcSeWwz6I0c=;
        b=Wzrtg78swOHNV50zNFrjIhVOfOFqn5wY3L0BGQVkCEsZbvq/q2cE0NleSg+pjPGmdaIGBI
        RETkeb44LOtvSBMQm53Q7PU1qpGNHytiPd/EhlUeivr3pGlA0+1OWLsg6a7OLg2RfPS00j
        +liivgc0XGkAkCwEEdrRStfRBpAe73U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-eTzddpHJOjmIAzN8h4b-kw-1; Tue, 16 Jun 2020 05:04:18 -0400
X-MC-Unique: eTzddpHJOjmIAzN8h4b-kw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 29C1E100961D;
        Tue, 16 Jun 2020 09:04:17 +0000 (UTC)
Received: from carbon (unknown [10.40.208.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 995B319D71;
        Tue, 16 Jun 2020 09:04:05 +0000 (UTC)
Date:   Tue, 16 Jun 2020 11:04:04 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        brouer@redhat.com
Subject: Re: [PATCHv4 bpf-next 1/2] xdp: add a new helper for dev map
 multicast support
Message-ID: <20200616110404.27149171@carbon>
In-Reply-To: <87d0678b8w.fsf@toke.dk>
References: <20200415085437.23028-1-liuhangbin@gmail.com>
        <20200526140539.4103528-1-liuhangbin@gmail.com>
        <20200526140539.4103528-2-liuhangbin@gmail.com>
        <20200610122153.76d30e37@carbon>
        <87d0678b8w.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed, 10 Jun 2020 12:29:35 +0200
Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:

> Jesper Dangaard Brouer <brouer@redhat.com> writes:
>=20
> > On Tue, 26 May 2020 22:05:38 +0800
> > Hangbin Liu <liuhangbin@gmail.com> wrote:
> > =20
> >> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> >> index a51d9fb7a359..ecc5c44a5bab 100644
> >> --- a/kernel/bpf/devmap.c
> >> +++ b/kernel/bpf/devmap.c =20
> > [...]
> > =20
> >> +int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *de=
v_rx,
> >> +			  struct bpf_map *map, struct bpf_map *ex_map,
> >> +			  bool exclude_ingress)
> >> +{
[...]
> >> +		if (!first) {
> >> +			nxdpf =3D xdpf_clone(xdpf);
> >> +			if (unlikely(!nxdpf))
> >> +				return -ENOMEM;
> >> +
> >> +			bq_enqueue(dev, nxdpf, dev_rx);
> >> +		} else {
> >> +			bq_enqueue(dev, xdpf, dev_rx); =20
> >
> > This looks racy.  You enqueue the original frame, and then later
> > xdpf_clone it.  The original frame might have been freed at that
> > point. =20
>=20
> This was actually my suggestion; on the assumption that bq_enqueue()
> just puts the frame on a list that won't be flushed until we exit the
> NAPI loop.
>=20
> But I guess now that you mention it that bq_enqueue() may flush the
> queue, so you're right that this won't work. Sorry about that, Hangbin :/
>=20
> Jesper, the reason I suggested this was to avoid an "extra" copy (i.e.,
> if we have two destinations, ideally we should only clone once instead
> of twice). Got any clever ideas for a safe way to achieve this? :)

Maybe you/we could avoid the clone on the last destination?

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

