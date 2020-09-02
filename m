Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0DD025AE82
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 17:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgIBPNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 11:13:21 -0400
Received: from mga12.intel.com ([192.55.52.136]:48194 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727894AbgIBPNB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 11:13:01 -0400
IronPort-SDR: 4RFcDI+54DGBArQgUMgTRIZL+ZVSgJkpzJ3Co5jQm5jMMuF6p/GsXSp7Z0GlQdQtJHsi0/A8vW
 iq/R0lbhroaw==
X-IronPort-AV: E=McAfee;i="6000,8403,9732"; a="136919855"
X-IronPort-AV: E=Sophos;i="5.76,383,1592895600"; 
   d="scan'208";a="136919855"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2020 08:12:55 -0700
IronPort-SDR: yvtPt9TafLz36hZCHsDyQ9gNZ/wB7BqUwZ5VfNnECYGBUpRk1QpdS01s0uI0t/9xuIOHMMgBpd
 1HanuGyF3DKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,383,1592895600"; 
   d="scan'208";a="297703764"
Received: from ishaula-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.39.98])
  by orsmga003.jf.intel.com with ESMTP; 02 Sep 2020 08:12:51 -0700
Subject: Re: [PATCH][next] xsk: Fix null check on error return path
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200902150750.GA7257@embeddedor>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <7b3d5e02-852e-189b-7c0e-9f9827fca730@intel.com>
Date:   Wed, 2 Sep 2020 17:12:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200902150750.GA7257@embeddedor>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-09-02 17:07, Gustavo A. R. Silva wrote:
> Currently, dma_map is being checked, when the right object identifier
> to be null-checked is dma_map->dma_pages, instead.
> 
> Fix this by null-checking dma_map->dma_pages.
> 
> Addresses-Coverity-ID: 1496811 ("Logically dead code")
> Fixes: 921b68692abb ("xsk: Enable sharing of dma mappings")
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Nice catch!

Acked-by: Björn Töpel <bjorn.topel@intel.com>

> ---
>   net/xdp/xsk_buff_pool.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> index 795d7c81c0ca..5b00bc5707f2 100644
> --- a/net/xdp/xsk_buff_pool.c
> +++ b/net/xdp/xsk_buff_pool.c
> @@ -287,7 +287,7 @@ static struct xsk_dma_map *xp_create_dma_map(struct device *dev, struct net_devi
>   		return NULL;
>   
>   	dma_map->dma_pages = kvcalloc(nr_pages, sizeof(*dma_map->dma_pages), GFP_KERNEL);
> -	if (!dma_map) {
> +	if (!dma_map->dma_pages) {
>   		kfree(dma_map);
>   		return NULL;
>   	}
> 
