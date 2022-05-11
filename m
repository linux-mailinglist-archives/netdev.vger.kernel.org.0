Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7A9523E35
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 22:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347474AbiEKUAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 16:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344378AbiEKUAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 16:00:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145FA231090
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 13:00:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51001B825F9
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 20:00:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F46C34100;
        Wed, 11 May 2022 20:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652299230;
        bh=lXuxKUiNsjON0aqA43Zt4w6gtSRwxVK+Ug63dLVb6WE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L07nFvZyKIe4UBhYb9WGO4+U2zXCV+ciVB0EX4dYUYO5quVuXtpY2Li7DmGtOB5L7
         GHfVWDK8jqYiK/Qbj5TUJV/rAS8j9+SlBTqg90qi2ZdH+dMwgnk3YmmXIUi09KGUek
         axEiT4wPNu7WxBhjlDGMUYKWXYB2W+dydgfluIjQkNagzFsRxGIgnbaGdo87OtUaL+
         FTMlraSAGu0WUlX9BmcARrl9JIwCa5kWvNKCPxD0Ux64tdFhYNfmOVY5wNLkXE81kv
         X/cOKqlmOrSLIInrvwnolLsEeP6n83NtZNtIaSyha3E0UvityxzvByqrLsJdXMu21Y
         kYNkRvGdHPQDA==
Date:   Wed, 11 May 2022 13:00:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     netdev@vger.kernel.org, radhey.shyam.pandey@xilinx.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        michal.simek@xilinx.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next v6 1/2] net: axienet: Be more careful about
 updating tx_bd_tail
Message-ID: <20220511130028.3e2edb35@kernel.org>
In-Reply-To: <20220511184432.1131256-2-robert.hancock@calian.com>
References: <20220511184432.1131256-1-robert.hancock@calian.com>
        <20220511184432.1131256-2-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 May 2022 12:44:31 -0600 Robert Hancock wrote:
> The axienet_start_xmit function was updating the tx_bd_tail variable
> multiple times, with potential rollbacks on error or invalid
> intermediate positions, even though this variable is also used in the
> TX completion path. Use READ_ONCE and WRITE_ONCE to make this update
> more atomic, and move the write before the MMIO write to start the
> transfer, so it is protected by that implicit write barrier.
> 
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>
> ---
>  .../net/ethernet/xilinx/xilinx_axienet_main.c | 23 +++++++++++--------
>  1 file changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index d6fc3f7acdf0..2f39eb4de249 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -807,12 +807,15 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
>  	u32 csum_index_off;
>  	skb_frag_t *frag;
>  	dma_addr_t tail_p, phys;
> +	u32 orig_tail_ptr, new_tail_ptr;
>  	struct axienet_local *lp = netdev_priv(ndev);
>  	struct axidma_bd *cur_p;
> -	u32 orig_tail_ptr = lp->tx_bd_tail;
> +
> +	orig_tail_ptr = READ_ONCE(lp->tx_bd_tail);

This one does not need READ_ONCE().

We only need to protect reads and writes which may race with each other.
This read can't race with any write. We need WRITE_ONCE() in
axienet_start_xmit() and READ_ONCE() in xienet_check_tx_bd_space().

BTW I'm slightly murky on what the rmb() in xienet_check_tx_bd_space()
does. Memory barrier is a fence, not a flush, I don't see what two
accesses that rmb() is separating.

> +	new_tail_ptr = orig_tail_ptr;
>  
>  	num_frag = skb_shinfo(skb)->nr_frags;
> -	cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
> +	cur_p = &lp->tx_bd_v[orig_tail_ptr];
>  
>  	if (axienet_check_tx_bd_space(lp, num_frag + 1)) {
>  		/* Should not happen as last start_xmit call should have

