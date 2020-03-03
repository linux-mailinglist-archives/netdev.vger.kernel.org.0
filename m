Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6948F177674
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 13:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729013AbgCCMy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 07:54:56 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:50466 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727738AbgCCMy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 07:54:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583240094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A0B7on4le/NFx5xViwWLfbthPnLFia00P/lYC9i1PXo=;
        b=NAJUmr0fJ7ZkL9TSJdmLYIAl5ILsaxzIhKeIhzf0YUTXHQSU0Ykv7LNVxlAIHoU20ZgTU7
        VyNrizu6Akp60v2RnvHU3Ov8bU/ejNJo7ytMw2eQ0P2JJXnfyt4RtLSnWhsmZ5C2qESDMh
        7Yhu4hINQMbOqGb8yuoKNJLIyD0oAw4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-Y176D40_NzKvvBMqF96r9Q-1; Tue, 03 Mar 2020 07:54:51 -0500
X-MC-Unique: Y176D40_NzKvvBMqF96r9Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8895F1005513;
        Tue,  3 Mar 2020 12:54:49 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A468D8D563;
        Tue,  3 Mar 2020 12:54:40 +0000 (UTC)
Date:   Tue, 3 Mar 2020 13:54:39 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, gamemann@gflclan.com, lrizzo@google.com,
        netdev@vger.kernel.org,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        brouer@redhat.com
Subject: Re: [bpf-next PATCH] xdp: accept that XDP headroom isn't always
 equal XDP_PACKET_HEADROOM
Message-ID: <20200303135439.76605e59@carbon>
In-Reply-To: <874kv563ja.fsf@toke.dk>
References: <158323601793.2048441.8715862429080864020.stgit@firesoul>
        <874kv563ja.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 03 Mar 2020 13:12:09 +0100
Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:

> Jesper Dangaard Brouer <brouer@redhat.com> writes:
>=20
> > The Intel based drivers (ixgbe + i40e) have implemented XDP with
> > headroom 192 bytes and not the recommended 256 bytes defined by
> > XDP_PACKET_HEADROOM.  For generic-XDP, accept that this headroom
> > is also a valid size.
> >
> > Still for generic-XDP if headroom is less, still expand headroom to
> > XDP_PACKET_HEADROOM as this is the default in most XDP drivers.
> >
> > Tested on ixgbe with xdp_rxq_info --skb-mode and --action XDP_DROP:
> > - Before: 4,816,430 pps
> > - After : 7,749,678 pps
> > (Note that ixgbe in native mode XDP_DROP 14,704,539 pps)
> >
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > ---
> >  include/uapi/linux/bpf.h |    1 +
> >  net/core/dev.c           |    4 ++--
> >  2 files changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 906e9f2752db..14dc4f9fb3c8 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -3312,6 +3312,7 @@ struct bpf_xdp_sock {
> >  };
> > =20
> >  #define XDP_PACKET_HEADROOM 256
> > +#define XDP_PACKET_HEADROOM_MIN 192 =20
>=20
> Do we need a comment here explaining why there are two values?

Good point, but I want to take it even further, lets discuss what these
defines should be used for (which is what the comment should say ;-)).

Maybe we should name it to reflect that this is used by generic XDP?
Or do we also want to change ixgbe and i40e to use this value?
(Looking at ixgbe code this is semi-dynamic xgbe_rx_offset(rx_ring) ->
IXGBE_SKB_PAD -> ixgbe_skb_pad())


An orthogonal question is why does XDP-generic have this limit?
(Luigi Rizzo's patch in this area is not adhering to this...)

XDP-native use headroom area for xdp_frame and metadata. The xdp_frame
is not relevant/used in XDP-generic.  The metadata is still relevant
for XDP-generic, as it's a communication channel to TC-BPF, but its
only 32 bytes.  IHMO it should be safe to reduce to 128 bytes.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

