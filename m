Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48DC9300354
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 13:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbhAVMhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 07:37:46 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:45083 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727401AbhAVMhi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 07:37:38 -0500
Received: from [192.168.0.6] (ip5f5aed2b.dynamic.kabel-deutschland.de [95.90.237.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id DACBA20647925;
        Fri, 22 Jan 2021 13:36:50 +0100 (CET)
Subject: Re: [Intel-wired-lan] [PATCH net] ixgbe: add NULL pointer check
 before calling xdp_rxq_info_reg
To:     Yunjian Wang <wangyunjian@huawei.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        jerry.lilijun@huawei.com, xudingke@huawei.com,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <1611314635-25592-1-git-send-email-wangyunjian@huawei.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <3d93455e-cfe5-4f03-0b25-bc1c61fb693d@molgen.mpg.de>
Date:   Fri, 22 Jan 2021 13:36:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <1611314635-25592-1-git-send-email-wangyunjian@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Yunjian,


Thank you for looking at these issue.

Am 22.01.21 um 12:23 schrieb wangyunjian:
> From: Yunjian Wang <wangyunjian@huawei.com>
> 
> The rx_ring->q_vector could be NULL, so it need to be checked before
> calling xdp_rxq_info_reg.

A small nit: need*s*

> Fixes: b02e5a0ebb172 ("xsk: Propagate napi_id to XDP socket Rx path")
> Addresses-Coverity: ("Dereference after null check")
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> ---
>   drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> index 6cbbe09ce8a0..7b76b3f448f7 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -6586,8 +6586,9 @@ int ixgbe_setup_rx_resources(struct ixgbe_adapter *adapter,
>   	rx_ring->next_to_use = 0;
>   
>   	/* XDP RX-queue info */
> -	if (xdp_rxq_info_reg(&rx_ring->xdp_rxq, adapter->netdev,
> -			     rx_ring->queue_index, rx_ring->q_vector->napi.napi_id) < 0)
> +	if (rx_ring->q_vector && xdp_rxq_info_reg(&rx_ring->xdp_rxq, adapter->netdev,
> +						  rx_ring->queue_index,
> +						  rx_ring->q_vector->napi.napi_id) < 0)

Unrelated, but I always wonder, if there shouldn’t be more logging for 
the error cases.

>   		goto err;
>   
>   	rx_ring->xdp_prog = adapter->xdp_prog;

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul
