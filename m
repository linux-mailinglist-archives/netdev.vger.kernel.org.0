Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A7F1D9421
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 12:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgESKP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 06:15:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56124 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726121AbgESKP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 06:15:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589883326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9XkotiFivHGrDelWOnkBgpbcLyjrmRMaD4hU8nQXtF4=;
        b=cfR3zLaugrp486AjYfDbMvj9a1nVACZ6JBlS2cKMwPZEizV4MCx09hy5pQemoiKbN7azA3
        qrFSvahsl92oTzqhxmuCAesUxuMI0GtML+1Aoy1bdbUGeSd8DbHvLkovTwNa5dLY/0ZTIH
        i33SaHA3sqcexe4XAZy3VpS1ol/QOcI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-ofssJA5sPMObjH1aa6pDog-1; Tue, 19 May 2020 06:15:24 -0400
X-MC-Unique: ofssJA5sPMObjH1aa6pDog-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2BEF1800D42;
        Tue, 19 May 2020 10:15:23 +0000 (UTC)
Received: from carbon (unknown [10.40.208.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6461A79594;
        Tue, 19 May 2020 10:15:14 +0000 (UTC)
Date:   Tue, 19 May 2020 12:15:12 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        brouer@redhat.com
Subject: Re: [RFC PATCHv2 bpf-next 1/2] xdp: add a new helper for dev map
 multicast support
Message-ID: <20200519121512.0b345424@carbon>
In-Reply-To: <20200518084527.GF102436@dhcp-12-153.nay.redhat.com>
References: <20200415085437.23028-1-liuhangbin@gmail.com>
        <20200424085610.10047-1-liuhangbin@gmail.com>
        <20200424085610.10047-2-liuhangbin@gmail.com>
        <87r1wd2bqu.fsf@toke.dk>
        <20200518084527.GF102436@dhcp-12-153.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 May 2020 16:45:27 +0800
Hangbin Liu <liuhangbin@gmail.com> wrote:

> Hi Toke,
>=20
> On Fri, Apr 24, 2020 at 04:34:49PM +0200, Toke H=C3=83=C2=B8iland-J=C3=83=
=C2=B8rgensen wrote:
> >=20
> > Yeah, the new helper is much cleaner!
> >  =20
> > > To achive this I add a new ex_map for struct bpf_redirect_info.
> > > in the helper I set tgt_value to NULL to make a difference with
> > > bpf_xdp_redirect_map()
> > >
> > > We also add a flag *BPF_F_EXCLUDE_INGRESS* incase you don't want to
> > > create a exclude map for each interface and just want to exclude the
> > > ingress interface.
> > >
> > > The general data path is kept in net/core/filter.c. The native data
> > > path is in kernel/bpf/devmap.c so we can use direct calls to
> > > get better performace. =20
> >=20
> > Got any performance numbers? :) =20
>=20
> Recently I tried with pktgen to get the performance number. It works
> with native mode, although the number looks not high.
>=20
> I tested it on VM with 1 cpu core.=20

Performance testing on a VM doesn't really make much sense.

> By forwarding to 7 ports, With pktgen
> config like:
> echo "count 10000000" > /proc/net/pktgen/veth0
> echo "clone_skb 0" > /proc/net/pktgen/veth0
> echo "pkt_size 64" > /proc/net/pktgen/veth0
> echo "dst 224.1.1.10" > /proc/net/pktgen/veth0
>=20
> I got forwarding number like:
> Forwarding     159958 pkt/s
> Forwarding     160213 pkt/s
> Forwarding     160448 pkt/s
>=20
> But when testing generic mode, I got system crashed directly. The code
> path is:
> do_xdp_generic()
>   - netif_receive_generic_xdp()
>     - pskb_expand_head()    <- skb_is_nonlinear(skb)
>       - BUG_ON(skb_shared(skb))
>=20
> So I want to ask do you have the same issue with pktgen? Any workaround?

Pktgen is not meant to be used on virtual devices.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

