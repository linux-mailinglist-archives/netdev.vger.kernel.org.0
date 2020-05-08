Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E14701CA88D
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 12:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgEHKuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 06:50:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32722 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726616AbgEHKuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 06:50:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588935001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uwD3JOSGpu4EnRIgdJWM5yHuQ7YvjS6n0OZCnItOBjk=;
        b=V/As0CjUHEsFodhWZ7bUzxTDMeVrECANyJWF5nCJcI/AY2TYjWDcffm9c+0JmV719oLBd+
        6loMkb71d3q1WP+4Xlf2euNaKLp0izN/Jp5sULKFiuG6SZ4CRDTe7rXXtcoCfVYm8pF/7m
        B2wqmNNtW8w2PY2ab4gdjMiZWBj+TO4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-1WDZOnt0N7ijWl6lquC4jg-1; Fri, 08 May 2020 06:49:59 -0400
X-MC-Unique: 1WDZOnt0N7ijWl6lquC4jg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73301107ACCA;
        Fri,  8 May 2020 10:49:56 +0000 (UTC)
Received: from carbon (unknown [10.40.208.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B41695C1B0;
        Fri,  8 May 2020 10:49:45 +0000 (UTC)
Date:   Fri, 8 May 2020 12:49:44 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     sameehj@amazon.com, Saeed Mahameed <saeedm@mellanox.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, zorik@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4?= =?UTF-8?B?cmdlbnNlbg==?= 
        <toke@redhat.com>, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>, brouer@redhat.com,
        Tariq Toukan <ttoukan.linux@gmail.com>
Subject: Re: [PATCH net-next v2 28/33] mlx5: rx queue setup time determine
 frame_sz for XDP
Message-ID: <20200508124944.2cb52580@carbon>
In-Reply-To: <20200501143232.157dadb9@carbon>
References: <158824557985.2172139.4173570969543904434.stgit@firesoul>
        <158824576377.2172139.12065840702900641458.stgit@firesoul>
        <a5be329e-39e3-fdfc-500d-383953546d40@mellanox.com>
        <7e391f37-0db7-c034-cb97-2e8bf60fd33f@mellanox.com>
        <20200501143232.157dadb9@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 1 May 2020 14:32:32 +0200
Jesper Dangaard Brouer <brouer@redhat.com> wrote:

> On Thu, 30 Apr 2020 20:12:11 +0300
> Tariq Toukan <tariqt@mellanox.com> wrote:
>=20
> > >> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h=20
> > >> b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> > >> index 23701c0e36ec..ba6a0ee297c6 100644
> > >> --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
> > >> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> > >> @@ -652,6 +652,7 @@ struct mlx5e_rq {
> > >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct {
> > >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u16=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 umem_headroom;
> > >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u16=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 headroom;
> > >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 first_frame_sz;   =20
> >=20
> > I also think that a better name would be: frame0_sz, or frag0_sz. =20
>=20
> You do realize that the name "first_frame_sz" was your suggestion last
> time... Now you give me two options, can please select one of them so I
> can update the patch for a V3 with that?

As I've not gotten any feedback from you, I'm going to choose your
first suggestion "frame0_sz" and update the patch with that...

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

