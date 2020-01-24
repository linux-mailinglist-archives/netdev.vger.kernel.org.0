Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0D47148CE5
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 18:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389083AbgAXR0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 12:26:02 -0500
Received: from mga18.intel.com ([134.134.136.126]:44285 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388028AbgAXR0C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 12:26:02 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jan 2020 09:22:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,358,1574150400"; 
   d="scan'208";a="276373468"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Jan 2020 09:22:31 -0800
Date:   Fri, 24 Jan 2020 11:14:16 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kubakici@wp.pl,
        mkubecek@suse.cz, Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH v4 06/17] octeontx2-pf: Receive packet handling support
Message-ID: <20200124101416.GA33242@ranger.igk.intel.com>
References: <1579612911-24497-1-git-send-email-sunil.kovvuri@gmail.com>
 <1579612911-24497-7-git-send-email-sunil.kovvuri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1579612911-24497-7-git-send-email-sunil.kovvuri@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 06:51:40PM +0530, sunil.kovvuri@gmail.com wrote:
> From: Sunil Goutham <sgoutham@marvell.com>
> 
> Added receive packet handling (NAPI) support, error stats, RX_ALL
> capability config option to passon error pkts to stack upon user request.
> 
> In subsequent patches these error stats will be added to ethttool.
> 
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> ---
>  .../ethernet/marvell/octeontx2/nic/otx2_common.c   |   2 +
>  .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  44 +++++
>  .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  16 +-
>  .../ethernet/marvell/octeontx2/nic/otx2_struct.h   | 195 +++++++++++++++++++++
>  .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c | 185 ++++++++++++++++++-
>  .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |   2 +
>  6 files changed, 441 insertions(+), 3 deletions(-)
> 
<snip>

> +static void otx2_skb_add_frag(struct otx2_nic *pfvf, struct sk_buff *skb,
> +			      u64 iova, int len, struct nix_rx_parse_s *parse)

Nit: 'parse' is unused in this function.

> +{
> +	struct page *page;
> +	void *va;
> +
> +	va = phys_to_virt(otx2_iova_to_phys(pfvf->iommu_domain, iova));
> +	page = virt_to_page(va);
> +	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, page,
> +			va - page_address(page), len, pfvf->rbsize);
> +
> +	otx2_dma_unmap_page(pfvf, iova - OTX2_HEAD_ROOM,
> +			    pfvf->rbsize, DMA_FROM_DEVICE);
> +}

<snip>
