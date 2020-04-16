Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0F41AC0AF
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 14:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634688AbgDPMFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 08:05:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53817 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2634882AbgDPMFB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 08:05:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587038699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eR0hKiHNidi2mVRnJ4wzzO8rdiEPgf4d515xNqsCpKI=;
        b=Q3IT/yw3hMObVTr7GQvHlOwr+bWgc3PgE1RhKGHh9XVaQUT+1WVCvZkYm6f5XKd1JjHQws
        jXFywM6qSAmXW+eCwm9UMmmPd8Oxy+W1Vos14XMl12aF4ET+O/Bi40uy71p+ndkubka/Vk
        dOFpLgJkx9IaNnG1zkjkqkK3F3Nf3yw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-8sMKc3OZMmmq92YHE30nMg-1; Thu, 16 Apr 2020 08:04:40 -0400
X-MC-Unique: 8sMKc3OZMmmq92YHE30nMg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9DAF9805735;
        Thu, 16 Apr 2020 12:04:37 +0000 (UTC)
Received: from carbon (unknown [10.40.208.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 21FA71036D03;
        Thu, 16 Apr 2020 12:04:31 +0000 (UTC)
Date:   Thu, 16 Apr 2020 14:04:30 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
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
        Lorenzo Bianconi <lorenzo@kernel.org>, brouer@redhat.com
Subject: Re: [PATCH RFC v2 17/33] mlx5: rx queue setup time determine
 frame_sz for XDP
Message-ID: <20200416140430.375e8bad@carbon>
In-Reply-To: <44441c56-c096-0dd3-9dc0-57f98065e44d@gmail.com>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
        <158634672069.707275.13343795980982759611.stgit@firesoul>
        <44441c56-c096-0dd3-9dc0-57f98065e44d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Apr 2020 15:52:26 +0300
Tariq Toukan <ttoukan.linux@gmail.com> wrote:

> Hi Jesper,
> 
> Thanks for your patch.
> Please see feedback below.
> 
> On 4/8/2020 2:52 PM, Jesper Dangaard Brouer wrote:
> > The mlx5 driver have multiple memory models, which are also changed
> > according to whether a XDP bpf_prog is attached.
> > 
> > The 'rx_striding_rq' setting is adjusted via ethtool priv-flags e.g.:
> >   # ethtool --set-priv-flags mlx5p2 rx_striding_rq off
> > 
> > On the general case with 4K page_size and regular MTU packet, then
> > the frame_sz is 2048 and 4096 when XDP is enabled, in both modes.
> > 
> > The info on the given frame size is stored differently depending on the
> > RQ-mode and encoded in a union in struct mlx5e_rq union wqe/mpwqe.
> > In rx striding mode rq->mpwqe.log_stride_sz is either 11 or 12, which
> > corresponds to 2048 or 4096 (MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ).
> > In non-striding mode (MLX5_WQ_TYPE_CYCLIC) the frag_stride is stored
> > in rq->wqe.info.arr[0].frag_stride.  
> 
> Just to clarify, the above description is true as long as we're in the 
> Linear SKB memory scheme, this holds when:
> 1) MTU + headroom + tailroom < PAGE_SIZE, and
> 2) HW LRO is OFF.
> 
> Otherwise, mpwqe.log_stride_sz can be smaller, and frag_stride of 
> wqe_info can vary from one index to another.
> 
> > 
> > To reduce effect on fast-path, this patch determine the frame_sz at
> > setup time, to avoid determining the memory model runtime.
> > 
> > Cc: Tariq Toukan <tariqt@mellanox.com>
> > Cc: Saeed Mahameed <saeedm@mellanox.com>
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > ---
> >   drivers/net/ethernet/mellanox/mlx5/core/en.h      |    1 +
> >   drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c  |    1 +
> >   drivers/net/ethernet/mellanox/mlx5/core/en_main.c |    4 ++++
> >   3 files changed, 6 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> > index 12a61bf82c14..1f280fc142ca 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> > @@ -651,6 +651,7 @@ struct mlx5e_rq {
> >   	struct {
> >   		u16            umem_headroom;
> >   		u16            headroom;
> > +		u32            frame_sz;
> >   		u8             map_dir;   /* dma map direction */
> >   	} buff;
> >   
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> > index f049e0ac308a..de4ad2c9f49a 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> > @@ -137,6 +137,7 @@ bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
> >   	if (xsk)
> >   		xdp.handle = di->xsk.handle;
> >   	xdp.rxq = &rq->xdp_rxq;
> > +	xdp.frame_sz = rq->buff.frame_sz;
> >   
> >   	act = bpf_prog_run_xdp(prog, &xdp);
> >   	if (xsk) {
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > index dd7f338425eb..b9595315c45b 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > @@ -462,6 +462,8 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
> >   		rq->mpwqe.num_strides =
> >   			BIT(mlx5e_mpwqe_get_log_num_strides(mdev, params, xsk));
> >   
> > +		rq->buff.frame_sz = (1 << rq->mpwqe.log_stride_sz);
> > +  
> 
> This is always correct.
> 
> >   		err = mlx5e_create_rq_umr_mkey(mdev, rq);
> >   		if (err)
> >   			goto err_rq_wq_destroy;
> > @@ -485,6 +487,8 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
> >   			num_xsk_frames = wq_sz << rq->wqe.info.log_num_frags;
> >   
> >   		rq->wqe.info = rqp->frags_info;
> > +		rq->buff.frame_sz = rq->wqe.info.arr[0].frag_stride;
> > +  
> 
> This is not always correct.
> Size of the last frag for a large MTU might be a full page.
> See:
> https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/mellanox/mlx5/core/en_main.c#L2097
> 
> However, you won't try to use this value at all in the non-linear SKB 
> flow, as it's not compatible with XDP.

Yes, exactly.

> Anyway, I prefer this value to be always true. No matter if it's really 
> used or not.
> Probably rename the field name to indicate this?
> Something like: single_frame_sz / first_frame_sz ?

Okay, I've renamed the field name to "first_frame_sz".  As this field
only describe the size of the first fragment.  This is fits with what
we are currently planning, to only give XDP/eBPF access to the first
fragment in case of multi-buffer XDP. (And then use Daniels idea of a
BPF-helper to pull in more data if explicitly requested).

Still trying to figure out if this is correct for AF_XDP.

And trying if I can get it more correct for non-linear case,
even-though it is not really used in that case.
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

