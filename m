Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F351CA517
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 09:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgEHHVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 03:21:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38413 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727878AbgEHHVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 03:21:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588922489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2Br08xsHGKfeLVOMiVN60m3nJFUGu/8fKIrpljGmQBQ=;
        b=SW5HzAPaTam2gXGJurbBJuGTGFTMzjmSeqljSpccqMAOFfwGU4zMkwNCfwYKEobEDU94I6
        Tf19xUX4OA/NOcKZXxt76cuAcpl4bQRRqhjMarZPjV36zO1EfF/QuDUPufx6T6D4h/CvOK
        LbKPw+x7rFb+VCdOI8SRzNr3EqoZzaA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-EoFpNJIaOdOdcO56R3SJ6A-1; Fri, 08 May 2020 03:21:25 -0400
X-MC-Unique: EoFpNJIaOdOdcO56R3SJ6A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 59D9C1902EA0;
        Fri,  8 May 2020 07:21:23 +0000 (UTC)
Received: from carbon (unknown [10.40.208.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 73476605CE;
        Fri,  8 May 2020 07:21:09 +0000 (UTC)
Date:   Fri, 8 May 2020 09:21:07 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, sameehj@amazon.com,
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
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        steffen.klassert@secunet.com, brouer@redhat.com
Subject: Re: [PATCH net-next v2 21/33] virtio_net: add XDP frame size in two
 code paths
Message-ID: <20200508092107.01b2066f@carbon>
In-Reply-To: <6e86e5de-8558-0f3b-53ce-ab0f611cc649@redhat.com>
References: <158824557985.2172139.4173570969543904434.stgit@firesoul>
        <158824572816.2172139.1358700000273697123.stgit@firesoul>
        <20200506163414-mutt-send-email-mst@kernel.org>
        <6e86e5de-8558-0f3b-53ce-ab0f611cc649@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 May 2020 10:05:46 +0800
Jason Wang <jasowang@redhat.com> wrote:

> On 2020/5/7 =E4=B8=8A=E5=8D=884:34, Michael S. Tsirkin wrote:
> > On Thu, Apr 30, 2020 at 01:22:08PM +0200, Jesper Dangaard Brouer wrote:=
 =20
> >> The virtio_net driver is running inside the guest-OS. There are two
> >> XDP receive code-paths in virtio_net, namely receive_small() and
> >> receive_mergeable(). The receive_big() function does not support XDP.
> >>
> >> In receive_small() the frame size is available in buflen. The buffer
> >> backing these frames are allocated in add_recvbuf_small() with same
> >> size, except for the headroom, but tailroom have reserved room for
> >> skb_shared_info. The headroom is encoded in ctx pointer as a value.
> >>
> >> In receive_mergeable() the frame size is more dynamic. There are two
> >> basic cases: (1) buffer size is based on a exponentially weighted
> >> moving average (see DECLARE_EWMA) of packet length. Or (2) in case
> >> virtnet_get_headroom() have any headroom then buffer size is
> >> PAGE_SIZE. The ctx pointer is this time used for encoding two values;
> >> the buffer len "truesize" and headroom. In case (1) if the rx buffer
> >> size is underestimated, the packet will have been split over more
> >> buffers (num_buf info in virtio_net_hdr_mrg_rxbuf placed in top of
> >> buffer area). If that happens the XDP path does a xdp_linearize_page
> >> operation.
> >>
> >> Cc: Jason Wang<jasowang@redhat.com>
> >> Signed-off-by: Jesper Dangaard Brouer<brouer@redhat.com> =20
> > Acked-by: Michael S. Tsirkin<mst@redhat.com> =20
>=20
>=20
> Note that we do:
>=20
>  =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 xdp.data_hard_start =3D data - VIR=
TIO_XDP_HEADROOM + vi->hdr_len;
>=20
> So using PAGE_SIZE here is probably not correct.

Yes, you are correct.  I will fix this up in V3.  We need to
adjust/reduce xdp.frame_sz with these offsets, as frame_sz is an offset
size from xdp.data_hard_start.

Thanks for pointing this out again, I will fix.
--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

