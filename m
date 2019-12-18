Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83AE112478B
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 14:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbfLRNDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 08:03:34 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44789 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726856AbfLRNDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 08:03:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576674213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3RacthdXboAKv2/QuHjpz9RucGraBd82xnlexkmWR6k=;
        b=BlIqgj17ifz5ZBMESxItxKkz66BLzTz/3knfrV7Agqm0pNhltjlzF+Eri7hSlRExActFm7
        9/0bFpP6famwRyMwg15d7twzVpEb8QKrpR5qLQ7h+ECZy5kYEITu/yoWz1pi45jfnwsLs8
        xm+o6mCE1mW3yAW5aNXVk2BhMP/z/r8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-lU7IlugtM_S-waRzWXFCmQ-1; Wed, 18 Dec 2019 08:03:28 -0500
X-MC-Unique: lU7IlugtM_S-waRzWXFCmQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52E0280059D;
        Wed, 18 Dec 2019 13:03:26 +0000 (UTC)
Received: from carbon (ovpn-200-37.brq.redhat.com [10.40.200.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 342E21891F;
        Wed, 18 Dec 2019 13:03:21 +0000 (UTC)
Date:   Wed, 18 Dec 2019 14:03:18 +0100
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
Subject: Re: [PATCH bpf-next 7/8] xdp: remove map_to_flush and map swap
 detection
Message-ID: <20191218140318.2c1d7140@carbon>
In-Reply-To: <20191218105400.2895-8-bjorn.topel@gmail.com>
References: <20191218105400.2895-1-bjorn.topel@gmail.com>
        <20191218105400.2895-8-bjorn.topel@gmail.com>
Organization: Red Hat Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Dec 2019 11:53:59 +0100
Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> wrote:

> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>=20
> Now that all XDP maps that can be used with bpf_redirect_map() tracks
> entries to be flushed in a global fashion, there is not need to track
> that the map has changed and flush from xdp_do_generic_map()
> anymore. All entries will be flushed in xdp_do_flush_map().
>=20
> This means that the map_to_flush can be removed, and the corresponding
> checks. Moving the flush logic to one place, xdp_do_flush_map(), give
> a bulking behavior and performance boost.
>=20
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---
>  include/linux/filter.h |  1 -
>  net/core/filter.c      | 27 +++------------------------
>  2 files changed, 3 insertions(+), 25 deletions(-)
>=20
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 37ac7025031d..69d6706fc889 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -592,7 +592,6 @@ struct bpf_redirect_info {
>  	u32 tgt_index;
>  	void *tgt_value;
>  	struct bpf_map *map;
> -	struct bpf_map *map_to_flush;
>  	u32 kern_flags;
>  };
> =20
> diff --git a/net/core/filter.c b/net/core/filter.c
> index c706325b3e66..d9caa3e57ea1 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3547,26 +3547,9 @@ static int __bpf_tx_xdp_map(struct net_device *dev=
_rx, void *fwd,
> =20
>  void xdp_do_flush_map(void)
>  {
> -	struct bpf_redirect_info *ri =3D this_cpu_ptr(&bpf_redirect_info);
> -	struct bpf_map *map =3D ri->map_to_flush;
> -
> -	ri->map_to_flush =3D NULL;
> -	if (map) {
> -		switch (map->map_type) {
> -		case BPF_MAP_TYPE_DEVMAP:
> -		case BPF_MAP_TYPE_DEVMAP_HASH:
> -			__dev_map_flush();
> -			break;
> -		case BPF_MAP_TYPE_CPUMAP:
> -			__cpu_map_flush();
> -			break;
> -		case BPF_MAP_TYPE_XSKMAP:
> -			__xsk_map_flush();
> -			break;
> -		default:
> -			break;
> -		}
> -	}
> +	__dev_map_flush();
> +	__cpu_map_flush();
> +	__xsk_map_flush();
>  }
>  EXPORT_SYMBOL_GPL(xdp_do_flush_map);
> =20
> @@ -3615,14 +3598,10 @@ static int xdp_do_redirect_map(struct net_device =
*dev, struct xdp_buff *xdp,
>  	ri->tgt_value =3D NULL;
>  	WRITE_ONCE(ri->map, NULL);
> =20
> -	if (ri->map_to_flush && unlikely(ri->map_to_flush !=3D map))
> -		xdp_do_flush_map();
> -

I guess, I need to read the other patches to understand why this is valid.

The idea here is to detect if the BPF-prog are using several different
redirect maps, and do the flush if the program uses another map.  I
assume you handle this?


>  	err =3D __bpf_tx_xdp_map(dev, fwd, map, xdp);
>  	if (unlikely(err))
>  		goto err;
> =20
> -	ri->map_to_flush =3D map;
>  	_trace_xdp_redirect_map(dev, xdp_prog, fwd, map, index);
>  	return 0;
>  err:



--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

