Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3101E6335
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 16:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390877AbgE1OE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 10:04:27 -0400
Received: from www62.your-server.de ([213.133.104.62]:57638 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390644AbgE1OEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 10:04:25 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jeJ8t-0004jX-H6; Thu, 28 May 2020 16:04:19 +0200
Date:   Thu, 28 May 2020 16:04:19 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        davem@davemloft.net, brouer@redhat.com,
        lorenzo.bianconi@redhat.com, dsahern@kernel.org,
        toshiaki.makita1@gmail.com
Subject: Re: [PATCH v2 bpf-next] xdp: introduce convert_to_xdp_buff utility
 routine
Message-ID: <20200528140419.GB24961@pc-9.home>
References: <80a0128d78f6c77210a8cccf7c5a78f53c45e7d3.1590571528.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80a0128d78f6c77210a8cccf7c5a78f53c45e7d3.1590571528.git.lorenzo@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25826/Thu May 28 14:33:30 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 11:28:03AM +0200, Lorenzo Bianconi wrote:
> Introduce convert_to_xdp_buff utility routine to initialize xdp_buff
> fields from xdp_frames ones. Rely on convert_to_xdp_buff in veth xdp
> code
> 
> Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
> Changes since v1:
> - rely on frame->data pointer to compute xdp->data_hard_start one
> ---
>  drivers/net/veth.c |  6 +-----
>  include/net/xdp.h  | 10 ++++++++++
>  2 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index b586d2fa5551..9f91e79b7823 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -575,11 +575,7 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
>  		struct xdp_buff xdp;
>  		u32 act;
>  
> -		xdp.data_hard_start = hard_start;
> -		xdp.data = frame->data;
> -		xdp.data_end = frame->data + frame->len;
> -		xdp.data_meta = frame->data - frame->metasize;
> -		xdp.frame_sz = frame->frame_sz;
> +		convert_to_xdp_buff(frame, &xdp);
>  		xdp.rxq = &rq->xdp_rxq;
>  
>  		act = bpf_prog_run_xdp(xdp_prog, &xdp);
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 90f11760bd12..df99d5d267b2 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -106,6 +106,16 @@ void xdp_warn(const char *msg, const char *func, const int line);
>  
>  struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct xdp_buff *xdp);
>  
> +static inline
> +void convert_to_xdp_buff(struct xdp_frame *frame, struct xdp_buff *xdp)
> +{
> +	xdp->data_hard_start = frame->data - frame->headroom - sizeof(*frame);
> +	xdp->data = frame->data;
> +	xdp->data_end = frame->data + frame->len;
> +	xdp->data_meta = frame->data - frame->metasize;
> +	xdp->frame_sz = frame->frame_sz;
> +}

From an API PoV, could we please prefix these with xdp_*(). Looks like there
is also convert_to_xdp_frame() as an outlier in there, but lets clean these
up once in the tree to avoid getting this more messy and harder to fix later
on. How about:

  - xdp_convert_frame_to_buff()
  - xdp_convert_buff_to_frame()

This will have both more self-documented and makes it obvious from where to
where we convert something.

Thanks,
Daniel
