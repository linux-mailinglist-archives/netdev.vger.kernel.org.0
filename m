Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC1B2C805E
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 09:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbgK3Izp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 03:55:45 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:8166 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbgK3Izo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 03:55:44 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc4b3630004>; Mon, 30 Nov 2020 00:54:59 -0800
Received: from [172.27.0.216] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 30 Nov
 2020 08:54:54 +0000
Subject: Re: [PATCH bpf] xdp: Handle MEM_TYPE_XSK_BUFF_POOL correctly in
 xdp_return_buff()
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>
CC:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        <jonathan.lemon@gmail.com>, <magnus.karlsson@intel.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
References: <20201127171726.123627-1-bjorn.topel@gmail.com>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
Message-ID: <0441d9e3-3880-5eb4-ca3d-0b714d41b48e@nvidia.com>
Date:   Mon, 30 Nov 2020 10:54:50 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201127171726.123627-1-bjorn.topel@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606726499; bh=pEYGOgNKiBr/dUktdAkMcNlQfo31TGStJowyg15f4Iw=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=XQhRx1twpgySE0QCEG+/9FWnxsWxCxEyhHo3ivENJEN4bNh4ulzCihGBpPGDQQpXq
         tWB+Sk7QqA/J+jP8lAlOE18UzB2ZJzxO5peiJ2HYZm//B7oza1UkwLK+58hKkGCFxU
         BHk/dAu2hc6uzYBeBNnHBSIoqaRzoC69ehcMUN37N3dpDp8W0SZOhChq2ha4UlUmHA
         bpGNgpP4vRiK7YtxlQXicnetbCgOlD4drUU42Y9iO7LmFIGD3mETdEE4q2PUft05bl
         ds4kQfGgM9CGrCWoG9sGoHP93lOVtYFl2FikScCooixYrnGfMyC+ujDVSkUI3sU6r8
         qqYZz09EwrVCw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-27 19:17, Bj=C3=B6rn T=C3=B6pel wrote:
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>=20
> It turns out that it does exist a path where xdp_return_buff() is
> being passed an XDP buffer of type MEM_TYPE_XSK_BUFF_POOL. This path
> is when AF_XDP zero-copy mode is enabled, and a buffer is redirected
> to a DEVMAP with an attached XDP program that drops the buffer.
>=20
> This change simply puts the handling of MEM_TYPE_XSK_BUFF_POOL back
> into xdp_return_buff().
>=20
> Reported-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Fixes: 82c41671ca4f ("xdp: Simplify xdp_return_{frame, frame_rx_napi, buf=
f}")
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

Thanks for addressing this!

Acked-by: Maxim Mikityanskiy <maximmi@nvidia.com>

> ---
>   net/core/xdp.c | 17 ++++++++++-------
>   1 file changed, 10 insertions(+), 7 deletions(-)
>=20
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 48aba933a5a8..491ad569a79c 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -335,11 +335,10 @@ EXPORT_SYMBOL_GPL(xdp_rxq_info_reg_mem_model);
>    * scenarios (e.g. queue full), it is possible to return the xdp_frame
>    * while still leveraging this protection.  The @napi_direct boolean
>    * is used for those calls sites.  Thus, allowing for faster recycling
> - * of xdp_frames/pages in those cases. This path is never used by the
> - * MEM_TYPE_XSK_BUFF_POOL memory type, so it's explicitly not part of
> - * the switch-statement.
> + * of xdp_frames/pages in those cases.
>    */
> -static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi=
_direct)
> +static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi=
_direct,
> +			 struct xdp_buff *xdp)
>   {
>   	struct xdp_mem_allocator *xa;
>   	struct page *page;
> @@ -361,6 +360,10 @@ static void __xdp_return(void *data, struct xdp_mem_=
info *mem, bool napi_direct)
>   		page =3D virt_to_page(data); /* Assumes order0 page*/
>   		put_page(page);
>   		break;
> +	case MEM_TYPE_XSK_BUFF_POOL:
> +		/* NB! Only valid from an xdp_buff! */
> +		xsk_buff_free(xdp);
> +		break;
>   	default:
>   		/* Not possible, checked in xdp_rxq_info_reg_mem_model() */
>   		WARN(1, "Incorrect XDP memory type (%d) usage", mem->type);
> @@ -370,19 +373,19 @@ static void __xdp_return(void *data, struct xdp_mem=
_info *mem, bool napi_direct)
>  =20
>   void xdp_return_frame(struct xdp_frame *xdpf)
>   {
> -	__xdp_return(xdpf->data, &xdpf->mem, false);
> +	__xdp_return(xdpf->data, &xdpf->mem, false, NULL);
>   }
>   EXPORT_SYMBOL_GPL(xdp_return_frame);
>  =20
>   void xdp_return_frame_rx_napi(struct xdp_frame *xdpf)
>   {
> -	__xdp_return(xdpf->data, &xdpf->mem, true);
> +	__xdp_return(xdpf->data, &xdpf->mem, true, NULL);
>   }
>   EXPORT_SYMBOL_GPL(xdp_return_frame_rx_napi);
>  =20
>   void xdp_return_buff(struct xdp_buff *xdp)
>   {
> -	__xdp_return(xdp->data, &xdp->rxq->mem, true);
> +	__xdp_return(xdp->data, &xdp->rxq->mem, true, xdp);
>   }
>  =20
>   /* Only called for MEM_TYPE_PAGE_POOL see xdp.h */
>=20
> base-commit: 9a44bc9449cfe7e39dbadf537ff669fb007a9e63
>=20

