Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34AB21DC640
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 06:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbgEUEaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 00:30:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47421 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726282AbgEUEaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 00:30:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590035404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WXgoiIQBmQkuRGuRereQHuQkbFC/POS9aYRCiQc+tnw=;
        b=baqv66aBEZI32AgDLlTA5Awb06sXQBJFs+QJTEep1A2l6JaYCla7dQL2X/7sUNmC3Ea7zG
        huktSlj1pdKR7ag1yo1/V8DqLYKfPooyBQtBo6bsi2/Hq/GiuPs/SdUsSEfUSdSRo95vyu
        14SENRI/YO/R2GrqEj34m3guJo106GU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-Oqx0dhwlMbCe71NM53_ElA-1; Thu, 21 May 2020 00:29:58 -0400
X-MC-Unique: Oqx0dhwlMbCe71NM53_ElA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 530C8474;
        Thu, 21 May 2020 04:29:56 +0000 (UTC)
Received: from carbon (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E14D06EA2B;
        Thu, 21 May 2020 04:29:48 +0000 (UTC)
Date:   Thu, 21 May 2020 06:29:47 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com, maximmi@mellanox.com,
        maciej.fijalkowski@intel.com, brouer@redhat.com
Subject: Re: [PATCH bpf-next v4 01/15] xsk: fix xsk_umem_xdp_frame_sz()
Message-ID: <20200521062947.71d9cddd@carbon>
In-Reply-To: <17701885-c91d-5bfc-b96d-29263a0d08ab@intel.com>
References: <20200520094742.337678-1-bjorn.topel@gmail.com>
        <20200520094742.337678-2-bjorn.topel@gmail.com>
        <20200520151819.1d2254b7@carbon>
        <17701885-c91d-5bfc-b96d-29263a0d08ab@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 May 2020 16:34:05 +0200
Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com> wrote:

> On 2020-05-20 15:18, Jesper Dangaard Brouer wrote:
> > On Wed, 20 May 2020 11:47:28 +0200
> > Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> wrote:
> >  =20
> >> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >>
> >> Calculating the "data_hard_end" for an XDP buffer coming from AF_XDP
> >> zero-copy mode, the return value of xsk_umem_xdp_frame_sz() is added
> >> to "data_hard_start".
> >>
> >> Currently, the chunk size of the UMEM is returned by
> >> xsk_umem_xdp_frame_sz(). This is not correct, if the fixed UMEM
> >> headroom is non-zero. Fix this by returning the chunk_size without the
> >> UMEM headroom.
> >>
> >> Fixes: 2a637c5b1aaf ("xdp: For Intel AF_XDP drivers add XDP frame_sz")
> >> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >> ---
> >>   include/net/xdp_sock.h | 2 +-
> >>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> >> index abd72de25fa4..6b1137ce1692 100644
> >> --- a/include/net/xdp_sock.h
> >> +++ b/include/net/xdp_sock.h
> >> @@ -239,7 +239,7 @@ static inline u64 xsk_umem_adjust_offset(struct xd=
p_umem *umem, u64 address,
> >>  =20
> >>   static inline u32 xsk_umem_xdp_frame_sz(struct xdp_umem *umem)
> >>   {
> >> -	return umem->chunk_size_nohr + umem->headroom;
> >> +	return umem->chunk_size_nohr; =20
> >=20
> > Hmm, is this correct?
> >=20
> > As you write "xdp_data_hard_end" is calculated as an offset from
> > xdp->data_hard_start pointer based on the frame_sz.  Will your
> > xdp->data_hard_start + frame_sz point to packet end?
> > =20
>=20
> Yes, I believe this is correct.
>=20
> Say that a user uses a chunk size of 2k, and a umem headroom of, say,
> 64. This means that the kernel should (at least) leave 64B which the
> kernel shouldn't touch.
>=20
> umem->headroom | XDP_PACKET_HEADROOM | packet |          |
>                 ^                     ^        ^      ^   ^
>                 a                     b        c      d   e
>=20
> a: data_hard_start
> b: data
> c: data_end
> d: data_hard_end, (e - 320)
> e: hardlimit of chunk, a + umem->chunk_size_nohr
>=20
> Prior this fix the umem->headroom was *included* in frame_sz.

Thanks for the nice ascii art description. I can now see that you are
right.   We should add this kind of documentation, perhaps as a comment
in the code?


> > #define xdp_data_hard_end(xdp)                          \
> >          ((xdp)->data_hard_start + (xdp)->frame_sz -     \
> >           SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
> >=20
> > Note the macro reserves the last 320 bytes (for skb_shared_info), but
> > for AF_XDP zero-copy mode, it will never create an SKB that use this
> > area.   Thus, in principle we can allow XDP-progs to extend/grow tail
> > into this area, but I don't think there is any use-case for this, as
> > it's much easier to access packet-data in userspace application.
> > (Thus, it might not be worth the complexity to give AF_XDP
> > bpf_xdp_adjust_tail access to this area, by e.g. "lying" via adding 320
> > bytes to frame_sz).
> >  =20
>=20
> I agree, and in the picture (well...) above that would be "d". IOW
> data_hard_end is 320 "off" the real end.

Yes, we agree.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

