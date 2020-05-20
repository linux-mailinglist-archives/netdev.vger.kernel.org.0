Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42D9E1DB4CB
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 15:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgETNSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 09:18:37 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29894 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726560AbgETNSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 09:18:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589980714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OHGYUKfvJ5M3zCTUp9P9l18wl3V5wBTvg9xasGTVV6E=;
        b=FHxjzkVtEl2KswtBl9Xu8K4FSppmIdV9NID2Rk1XTBEKheEYrm0lr92iGcQOJ6jgetpKts
        PJ6tYKwRy6ulIrGIyOtakCKO6rgYQKTa/AvxNjrboy14m73f9G75N9ggX/s9wXmNlij9de
        tVq5AybpwsB7gyaCnjawcxbpbacGBqQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-w2Eb611aNJiVTHh8dLMl_A-1; Wed, 20 May 2020 09:18:29 -0400
X-MC-Unique: w2Eb611aNJiVTHh8dLMl_A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E003B1005510;
        Wed, 20 May 2020 13:18:26 +0000 (UTC)
Received: from carbon (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C3562E05A;
        Wed, 20 May 2020 13:18:21 +0000 (UTC)
Date:   Wed, 20 May 2020 15:18:19 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com,
        =?UTF-8?B?QmrDtnJu?= =?UTF-8?B?IFTDtnBlbA==?= 
        <bjorn.topel@intel.com>, maximmi@mellanox.com,
        maciej.fijalkowski@intel.com
Subject: Re: [PATCH bpf-next v4 01/15] xsk: fix xsk_umem_xdp_frame_sz()
Message-ID: <20200520151819.1d2254b7@carbon>
In-Reply-To: <20200520094742.337678-2-bjorn.topel@gmail.com>
References: <20200520094742.337678-1-bjorn.topel@gmail.com>
        <20200520094742.337678-2-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 May 2020 11:47:28 +0200
Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> wrote:

> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>=20
> Calculating the "data_hard_end" for an XDP buffer coming from AF_XDP
> zero-copy mode, the return value of xsk_umem_xdp_frame_sz() is added
> to "data_hard_start".
>=20
> Currently, the chunk size of the UMEM is returned by
> xsk_umem_xdp_frame_sz(). This is not correct, if the fixed UMEM
> headroom is non-zero. Fix this by returning the chunk_size without the
> UMEM headroom.
>=20
> Fixes: 2a637c5b1aaf ("xdp: For Intel AF_XDP drivers add XDP frame_sz")
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---
>  include/net/xdp_sock.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> index abd72de25fa4..6b1137ce1692 100644
> --- a/include/net/xdp_sock.h
> +++ b/include/net/xdp_sock.h
> @@ -239,7 +239,7 @@ static inline u64 xsk_umem_adjust_offset(struct xdp_u=
mem *umem, u64 address,
> =20
>  static inline u32 xsk_umem_xdp_frame_sz(struct xdp_umem *umem)
>  {
> -	return umem->chunk_size_nohr + umem->headroom;
> +	return umem->chunk_size_nohr;

Hmm, is this correct?

As you write "xdp_data_hard_end" is calculated as an offset from
xdp->data_hard_start pointer based on the frame_sz.  Will your
xdp->data_hard_start + frame_sz point to packet end?

#define xdp_data_hard_end(xdp)                          \
        ((xdp)->data_hard_start + (xdp)->frame_sz -     \
         SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))

Note the macro reserves the last 320 bytes (for skb_shared_info), but
for AF_XDP zero-copy mode, it will never create an SKB that use this
area.   Thus, in principle we can allow XDP-progs to extend/grow tail
into this area, but I don't think there is any use-case for this, as
it's much easier to access packet-data in userspace application.
(Thus, it might not be worth the complexity to give AF_XDP
bpf_xdp_adjust_tail access to this area, by e.g. "lying" via adding 320
bytes to frame_sz).

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

