Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7AB2F1FC4
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 20:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404027AbhAKTsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 14:48:31 -0500
Received: from mga01.intel.com ([192.55.52.88]:44615 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389057AbhAKTsa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 14:48:30 -0500
IronPort-SDR: b7LtlNKvu1BW3J0n9seyNlZE9Q81b8eLSYQkZ3o61LBYOxUH83aVJX+i+1oNcXfDfhLHN1F/SD
 eS5gP5SGnjhg==
X-IronPort-AV: E=McAfee;i="6000,8403,9861"; a="196536404"
X-IronPort-AV: E=Sophos;i="5.79,339,1602572400"; 
   d="scan'208";a="196536404"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2021 11:47:46 -0800
IronPort-SDR: vSMvzdE1rybLWHt5j7ZLLDBShm+gQWVX9NjaOc12Dv6FOxAKmjminMevil6uL9PmjVfi1RB//a
 avVV7JpNQz8Q==
X-IronPort-AV: E=Sophos;i="5.79,339,1602572400"; 
   d="scan'208";a="381129269"
Received: from amburges-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.40.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2021 11:47:43 -0800
Subject: Re: [PATCH net] i40e: fix potential NULL pointer dereferencing
To:     Cristian Dumitrescu <cristian.dumitrescu@intel.com>,
        intel-wired-lan@lists.osuosl.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com
References: <20210111181138.49757-1-cristian.dumitrescu@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <ac36b7b2-bf0e-c58c-754b-d9ab4dbb9cae@intel.com>
Date:   Mon, 11 Jan 2021 20:47:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210111181138.49757-1-cristian.dumitrescu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-11 19:11, Cristian Dumitrescu wrote:
> Currently, the function i40e_construct_skb_zc only frees the input xdp
> buffer when the output skb is successfully built. On error, the
> function i40e_clean_rx_irq_zc does not commit anything for the current
> packet descriptor and simply exits the packet descriptor processing
> loop, with the plan to restart the processing of this descriptor on
> the next invocation. Therefore, on error the ring next-to-clean
> pointer should not advance, the xdp i.e. *bi buffer should not be
> freed and the current buffer info should not be invalidated by setting
> *bi to NULL. Therefore, the *bi should only be set to NULL when the
> function i40e_construct_skb_zc is successful, otherwise a NULL *bi
> will be dereferenced when the work for the current descriptor is
> eventually restarted.
> 
> Fixes: 3b4f0b66c2b3 ("i40e, xsk: Migrate to new MEM_TYPE_XSK_BUFF_POOL")
> Signed-off-by: Cristian Dumitrescu <cristian.dumitrescu@intel.com>

Thanks for finding and fixing this, Cristian!

Acked-by: Björn Töpel <bjorn.topel@intel.com>

> ---
>   drivers/net/ethernet/intel/i40e/i40e_xsk.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> index 47eb9c584a12..492ce213208d 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> @@ -348,12 +348,12 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
>   		 * SBP is *not* set in PRT_SBPVSI (default not set).
>   		 */
>   		skb = i40e_construct_skb_zc(rx_ring, *bi);
> -		*bi = NULL;
>   		if (!skb) {
>   			rx_ring->rx_stats.alloc_buff_failed++;
>   			break;
>   		}
>   
> +		*bi = NULL;
>   		cleaned_count++;
>   		i40e_inc_ntc(rx_ring);
>   
> 
