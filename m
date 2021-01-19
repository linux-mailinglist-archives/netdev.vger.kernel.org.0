Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 252112FC4ED
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 00:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730510AbhASXj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 18:39:27 -0500
Received: from mga06.intel.com ([134.134.136.31]:61596 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395146AbhASOJ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 09:09:56 -0500
IronPort-SDR: PRrq64u5T/J+sEyVruVhrkb3gshANF/zIkm0Or6lWZN75dsEqgPA+K8dx+wtYhh9Iw5GsNj4BS
 f2BtNdReLHMA==
X-IronPort-AV: E=McAfee;i="6000,8403,9868"; a="240469094"
X-IronPort-AV: E=Sophos;i="5.79,359,1602572400"; 
   d="scan'208";a="240469094"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2021 06:08:43 -0800
IronPort-SDR: rDpRA46Rqj29+hf5uzt/WaB8xXHn37IaC2pTgWqLFw1osJe/smetDhIUa9gVMPNPNSnjWmWQfu
 NURWhViT4b+w==
X-IronPort-AV: E=Sophos;i="5.79,359,1602572400"; 
   d="scan'208";a="355623586"
Received: from lgomesba-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.43.79])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2021 06:08:40 -0800
Subject: Re: [PATCH bpf] xsk: Clear pool even for inactive queues
To:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20210118160333.333439-1-maximmi@mellanox.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <9236949b-df13-9505-8ada-69ad26e03a89@intel.com>
Date:   Tue, 19 Jan 2021 15:08:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210118160333.333439-1-maximmi@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-18 17:03, Maxim Mikityanskiy wrote:
> The number of queues can change by other means, rather than ethtool. For
> example, attaching an mqprio qdisc with num_tc > 1 leads to creating
> multiple sets of TX queues, which may be then destroyed when mqprio is
> deleted. If an AF_XDP socket is created while mqprio is active,
> dev->_tx[queue_id].pool will be filled, but then real_num_tx_queues may
> decrease with deletion of mqprio, which will mean that the pool won't be
> NULLed, and a further increase of the number of TX queues may expose a
> dangling pointer.
> 
> To avoid any potential misbehavior, this commit clears pool for RX and
> TX queues, regardless of real_num_*_queues, still taking into
> consideration num_*_queues to avoid overflows.
> 
> Fixes: 1c1efc2af158 ("xsk: Create and free buffer pool independently from umem")
> Fixes: a41b4f3c58dd ("xsk: simplify xdp_clear_umem_at_qid implementation")
> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>

Thanks, Maxim!

Acked-by: Björn Töpel <bjorn.topel@intel.com>

> ---
>   net/xdp/xsk.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 8037b04a9edd..4a83117507f5 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -108,9 +108,9 @@ EXPORT_SYMBOL(xsk_get_pool_from_qid);
>   
>   void xsk_clear_pool_at_qid(struct net_device *dev, u16 queue_id)
>   {
> -	if (queue_id < dev->real_num_rx_queues)
> +	if (queue_id < dev->num_rx_queues)
>   		dev->_rx[queue_id].pool = NULL;
> -	if (queue_id < dev->real_num_tx_queues)
> +	if (queue_id < dev->num_tx_queues)
>   		dev->_tx[queue_id].pool = NULL;
>   }
>   
> 
