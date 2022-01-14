Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7016448EB5B
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 15:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237452AbiANONp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 09:13:45 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:34350 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbiANONk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 09:13:40 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 2BDE11F38F;
        Fri, 14 Jan 2022 14:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1642169619; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SQluvbm1CYl+8Xaq4R5soBgbpa26mnxBAhQLJ4lyJSY=;
        b=KgX3L02N/qNhBNHtKQYvAQLFITeVs4nus01bmDZTH3Ya6oNVMUsMDIOpUd0JRosQRSYUO5
        p4UqrO/Q4QQZObRqQSoYHULqQKKfZRVdOMQ9hN5iRz9t368OoPbKFCJa0pSPubMQIbqwmi
        CIQ53f/sYUd6PFmN3WcAQ7jFDFBrb7Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1642169619;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SQluvbm1CYl+8Xaq4R5soBgbpa26mnxBAhQLJ4lyJSY=;
        b=o20kYu8RX2He0384gMHGJ9VXY4L/4FgB7tHDjgFY670/Smo3LQpXiQjEkYV5BafoaQKz2O
        TfbVjdjtfp7LqKCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AEB0513B7F;
        Fri, 14 Jan 2022 14:13:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 0O+PJhKF4WFaKQAAMHmgww
        (envelope-from <dkirjanov@suse.de>); Fri, 14 Jan 2022 14:13:38 +0000
Message-ID: <5521e35f-3adf-2949-f360-12e2f7946480@suse.de>
Date:   Fri, 14 Jan 2022 17:13:06 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 2/2 net-next v2] igb: refactor XDP registration
Content-Language: ru
To:     Corinna Vinschen <vinschen@redhat.com>, intel-wired-lan@osuosl.org,
        netdev@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Lennert Buytenhek <buytenh@wantstofly.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
References: <20220114114354.1071776-1-vinschen@redhat.com>
 <20220114114354.1071776-3-vinschen@redhat.com>
From:   Denis Kirjanov <dkirjanov@suse.de>
In-Reply-To: <20220114114354.1071776-3-vinschen@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



1/14/22 14:43, Corinna Vinschen пишет:
> On changing the RX ring parameters igb uses a hack to avoid a warning
> when calling xdp_rxq_info_reg via igb_setup_rx_resources.  It just
> clears the struct xdp_rxq_info content.
> 
> Change this to unregister if we're already registered instead.  ALign
> code to the igc code.
> 
> Fixes: 9cbc948b5a20c ("igb: add XDP support")
> Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
> ---
>   drivers/net/ethernet/intel/igb/igb_ethtool.c |  4 ----
>   drivers/net/ethernet/intel/igb/igb_main.c    | 15 +++++++++++----
>   2 files changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> index 51a2dcaf553d..2a5782063f4c 100644
> --- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
> +++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> @@ -965,10 +965,6 @@ static int igb_set_ringparam(struct net_device *netdev,
>   			memcpy(&temp_ring[i], adapter->rx_ring[i],
>   			       sizeof(struct igb_ring));
>   
> -			/* Clear copied XDP RX-queue info */
> -			memset(&temp_ring[i].xdp_rxq, 0,
> -			       sizeof(temp_ring[i].xdp_rxq));
> -
>   			temp_ring[i].count = new_rx_count;
>   			err = igb_setup_rx_resources(&temp_ring[i]);
>   			if (err) {
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index 38ba92022cd4..9638cb9c6014 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -4352,7 +4352,7 @@ int igb_setup_rx_resources(struct igb_ring *rx_ring)
>   {
>   	struct igb_adapter *adapter = netdev_priv(rx_ring->netdev);
>   	struct device *dev = rx_ring->dev;
> -	int size;
> +	int size, res;
>   
>   	size = sizeof(struct igb_rx_buffer) * rx_ring->count;
>   
> @@ -4376,9 +4376,16 @@ int igb_setup_rx_resources(struct igb_ring *rx_ring)
>   	rx_ring->xdp_prog = adapter->xdp_prog;
>   
>   	/* XDP RX-queue info */
> -	if (xdp_rxq_info_reg(&rx_ring->xdp_rxq, rx_ring->netdev,
> -			     rx_ring->queue_index, 0) < 0)
> -		goto err;
> +	if (xdp_rxq_info_is_reg(&rx_ring->xdp_rxq))
> +		xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
> +	res = xdp_rxq_info_reg(&rx_ring->xdp_rxq, rx_ring->netdev,
> +			       rx_ring->queue_index, 0);
> +	if (res < 0) {
> +		netdev_err(rx_ring->netdev,
> +			   "Failed to register xdp_rxq index %u\n",
> +			   rx_ring->queue_index);
nit: would be nice to have the same printing functions like dev_err()
in the error case

> +		return res;
> +	}
>   
>   	return 0;
>   
