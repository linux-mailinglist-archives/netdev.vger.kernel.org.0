Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF7A24C65A
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 21:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgHTTn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 15:43:58 -0400
Received: from mga18.intel.com ([134.134.136.126]:6047 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726887AbgHTTn5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 15:43:57 -0400
IronPort-SDR: aBGCAlJBhlOuy5RL3yoMj+v5DCipkv/Ryk5/AFVFJhtDL2cPt0tBh1L3OO/KHxvWnc00Oalm3Z
 jfoYSSXqA4Bw==
X-IronPort-AV: E=McAfee;i="6000,8403,9718"; a="143028629"
X-IronPort-AV: E=Sophos;i="5.76,334,1592895600"; 
   d="scan'208";a="143028629"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2020 12:43:57 -0700
IronPort-SDR: vaSHAulyVGUhgZbbR9H3VHNWNcCnAlBmNCoF1EoiTknxQG0NWWwwkRafNVKpjMH0KITA69CEFW
 Fg0Re2GVZaRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,334,1592895600"; 
   d="scan'208";a="321003880"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga004.fm.intel.com with ESMTP; 20 Aug 2020 12:43:54 -0700
Date:   Thu, 20 Aug 2020 21:38:14 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com, kuba@kernel.org
Subject: Re: [PATCH net-next 3/6] net: mvneta: update mb bit before passing
 the xdp buffer to eBPF layer
Message-ID: <20200820193814.GB12291@ranger.igk.intel.com>
References: <cover.1597842004.git.lorenzo@kernel.org>
 <08f8656e906ff69bd30915a6a37a01d5f0422194.1597842004.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08f8656e906ff69bd30915a6a37a01d5f0422194.1597842004.git.lorenzo@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 19, 2020 at 03:13:48PM +0200, Lorenzo Bianconi wrote:
> Update multi-buffer bit (mb) in xdp_buff to notify XDP/eBPF layer and
> XDP remote drivers if this is a "non-linear" XDP buffer
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/marvell/mvneta.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index 832bbb8b05c8..36a3defa63fa 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -2170,11 +2170,14 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
>  	       struct bpf_prog *prog, struct xdp_buff *xdp,
>  	       u32 frame_sz, struct mvneta_stats *stats)
>  {
> +	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
>  	unsigned int len, data_len, sync;
>  	u32 ret, act;
>  
>  	len = xdp->data_end - xdp->data_hard_start - pp->rx_offset_correction;
>  	data_len = xdp->data_end - xdp->data;
> +
> +	xdp->mb = !!sinfo->nr_frags;

But this set is not utilizing it from BPF side in any way. Personally I
would like to see this as a part of work where BPF program would actually
be taught how to rely on xdp->mb. Especially after John's comment in other
patch.

>  	act = bpf_prog_run_xdp(prog, xdp);
>  
>  	/* Due xdp_adjust_tail: DMA sync for_device cover max len CPU touch */
> -- 
> 2.26.2
> 
