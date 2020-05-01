Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF8E71C1287
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 15:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbgEANCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 09:02:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54798 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728712AbgEANCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 09:02:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588338137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nMNwUEwP7B5aTzQaTa7GTZ+aHZZGUhgfbGYRXFPEXt0=;
        b=d53+J5nzo7wxgsOWOtb3MzCwddaqMnhN2uDAXq5xxWL2P7R+njo63DUzqctp/OV9j/C7H7
        45tTTHaD1nkwj1hf3jK6iPxtyrfsOtzVnzLEcB0QWKcJdTpAZSwMONwbgC02XRg93ObJXd
        6qZ3LVBRy1VIcl4JEHIO/K9eFE9RTd0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-H_WmMvbONfmLdgIsJ1oJsQ-1; Fri, 01 May 2020 09:02:13 -0400
X-MC-Unique: H_WmMvbONfmLdgIsJ1oJsQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E0561462;
        Fri,  1 May 2020 13:02:10 +0000 (UTC)
Received: from carbon (unknown [10.40.208.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB5925D9CA;
        Fri,  1 May 2020 13:01:59 +0000 (UTC)
Date:   Fri, 1 May 2020 15:01:58 +0200
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
        Lorenzo Bianconi <lorenzo@kernel.org>,
        steffen.klassert@secunet.com, brouer@redhat.com
Subject: Re: [PATCH net-next v2 28/33] mlx5: rx queue setup time determine
 frame_sz for XDP
Message-ID: <20200501150158.05e647f7@carbon>
In-Reply-To: <a5be329e-39e3-fdfc-500d-383953546d40@mellanox.com>
References: <158824557985.2172139.4173570969543904434.stgit@firesoul>
        <158824576377.2172139.12065840702900641458.stgit@firesoul>
        <a5be329e-39e3-fdfc-500d-383953546d40@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Apr 2020 20:07:43 +0300
Tariq Toukan <tariqt@mellanox.com> wrote:

> On 4/30/2020 2:22 PM, Jesper Dangaard Brouer wrote:
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
> > in rq->wqe.info.arr[0].frag_stride, for the first fragment, which is
> > what the XDP case cares about.
> > 
> > To reduce effect on fast-path, this patch determine the frame_sz at
> > setup time, to avoid determining the memory model runtime. Variable
> > is named first_frame_sz to make it clear that this is only the frame
> > size of the first fragment.
> > 
> > This mlx5 driver does a DMA-sync on XDP_TX action, but grow is safe
> > as it have done a DMA-map on the entire PAGE_SIZE. The driver also
> > already does a XDP length check against sq->hw_mtu on the possible
> > XDP xmit paths mlx5e_xmit_xdp_frame() + mlx5e_xmit_xdp_frame_mpwqe().
> > 
> > V2: Fix that frag_size need to be recalc before creating SKB.
> > 
> > Cc: Tariq Toukan <tariqt@mellanox.com>
> > Cc: Saeed Mahameed <saeedm@mellanox.com>
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > ---
> >   drivers/net/ethernet/mellanox/mlx5/core/en.h      |    1 +
> >   drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c  |    1 +
> >   drivers/net/ethernet/mellanox/mlx5/core/en_main.c |    6 ++++++
> >   drivers/net/ethernet/mellanox/mlx5/core/en_rx.c   |    2 ++
> >   4 files changed, 10 insertions(+)
> > 
[... cut ...]
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> > index e2beb89c1832..04671ed977a5 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> > @@ -1084,6 +1084,7 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
> >   	if (consumed)
> >   		return NULL; /* page/packet was consumed by XDP */
> >   
> > +	frag_size = MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt);  
> 
> This is a re-calculation of frag_size, using the exact same command used 
> earlier in this function, but with a newer value of rx_headroom.
> This wasn't part of the previous patchset. I understand the need.

Yes, kernel will crash without this change.

> However, this code repetition looks weird and non-optimal to me. I think 
> we can come up with something better.
> 
> >   	skb = mlx5e_build_linear_skb(rq, va, frag_size, rx_headroom, cqe_bcnt);
> >   	if (unlikely(!skb))
> >   		return NULL;
> > @@ -1385,6 +1386,7 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
> >   		return NULL; /* page/packet was consumed by XDP */
> >   	}
> >   
> > +	frag_size = MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt32);  
> 
> Same here.
> 
> >   	skb = mlx5e_build_linear_skb(rq, va, frag_size, rx_headroom, cqe_bcnt32);
> >   	if (unlikely(!skb))
> >   		return NULL;
> > 
> >   
> 
> My suggetion is:
> Pass &frag_size to mlx5e_xdp_handle(), and update it within it, just 
> next to the update of rx_headroom.
> All the needed information is there: the new rx_headroom, and cqe_bcnt.

First of all, passing yet-another argument to mlx5e_xdp_handle(), also
looks weird, and is on the brink of becoming a performance issue, as on
x86_64 you can pass max 6 arguments in registers before they get pushed
on the stack. Adding this would be the 7th argument.

Second the MLX5_SKB_FRAG_SZ() calculation is also weird, because it
does not provide any tailroom in the packet, I guess it is for
supporting another memory mode, as in case XDP is activated there are
plenty of tailroom.
  I though about increasing the frag_size, but I choose not to, because
then this patch would change the driver behavior beyond adding frame_sz
for XDP.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer



bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
		      void *va, u16 *rx_headroom, u32 *len, bool xsk)
{
	[...]
}

