Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A18480489
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 21:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbhL0UeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 15:34:24 -0500
Received: from mga05.intel.com ([192.55.52.43]:32592 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229843AbhL0UeX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Dec 2021 15:34:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640637263; x=1672173263;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iG1ggZ11L9JNjcVM2LtagDTWszVONzK5iQFTRN1NBe4=;
  b=Cf5UncOdawXp9ha85Ukg1xQKVxOHJNJO4CUUKUYH4u+mRipybY5m4UTs
   yU9EsLFPTltzonRXnKMplHluMy/V6+ZluyEooH7EcJZdSLpCM04TksCNd
   UgqzryOzWE1KG7qXrdVHdFHvcDUyNyh8S0P/B4nlQfglonDY6p3c1wxla
   rxWfcieLfItHqcM9g7nN+HxApGHiDXfFaY9B9BkPa1VwR/2kpMvXcs4Ia
   0h/Cp7nIEft0aEShUlZsEg1oJT54Nka3y19R5FqJQv9PBZGaXbscnr7qc
   lg+qb4cpi56v+Bh2Lvot47BYDYuULjqxa9VkEn+9V+Td/cUVV05Lj9iFm
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10210"; a="327592401"
X-IronPort-AV: E=Sophos;i="5.88,240,1635231600"; 
   d="scan'208";a="327592401"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2021 12:34:23 -0800
X-IronPort-AV: E=Sophos;i="5.88,240,1635231600"; 
   d="scan'208";a="523405879"
Received: from krausnex-mobl.ger.corp.intel.com (HELO [10.255.195.237]) ([10.255.195.237])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2021 12:34:18 -0800
Message-ID: <e7145513-1808-fb59-35cc-37169ecec047@linux.intel.com>
Date:   Mon, 27 Dec 2021 22:34:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [Intel-wired-lan] [PATCH v4 net-next 6/9] igc: don't reserve
 excessive XDP_PACKET_HEADROOM on XSK Rx to skb
Content-Language: en-US
To:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        intel-wired-lan@lists.osuosl.org
Cc:     Song Liu <songliubraving@fb.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        KP Singh <kpsingh@kernel.org>, bpf@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
References: <20211208140702.642741-1-alexandr.lobakin@intel.com>
 <20211208140702.642741-7-alexandr.lobakin@intel.com>
From:   "Kraus, NechamaX" <nechamax.kraus@linux.intel.com>
In-Reply-To: <20211208140702.642741-7-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/8/2021 16:06, Alexander Lobakin wrote:
> {__,}napi_alloc_skb() allocates and reserves additional NET_SKB_PAD
> + NET_IP_ALIGN for any skb.
> OTOH, igc_construct_skb_zc() currently allocates and reserves
> additional `xdp->data_meta - xdp->data_hard_start`, which is about
> XDP_PACKET_HEADROOM for XSK frames.
> There's no need for that at all as the frame is post-XDP and will
> go only to the networking stack core.
> Pass the size of the actual data only (+ meta) to
> __napi_alloc_skb() and don't reserve anything. This will give
> enough headroom for stack processing.
> Also, net_prefetch() xdp->data_meta and align the copy size to
> speed-up memcpy() a little and better match igc_costruct_skb().
> 
> Fixes: fc9df2a0b520 ("igc: Enable RX via AF_XDP zero-copy")
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> ---
>   drivers/net/ethernet/intel/igc/igc_main.c | 13 +++++++------
>   1 file changed, 7 insertions(+), 6 deletions(-)
>
Tested-by: Nechama Kraus <nechamax.kraus@linux.intel.com>

