Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09F4A4AA657
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 04:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378907AbiBEDwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 22:52:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiBEDwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 22:52:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D07BC061346
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 19:52:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F2B461117
        for <netdev@vger.kernel.org>; Sat,  5 Feb 2022 03:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452F6C340E8;
        Sat,  5 Feb 2022 03:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644033150;
        bh=CGI3Z0D6RAtURo4pH0w1jengsn1P3MAPobytuifhIcQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VmWKLGN2MP4nt4MuiMtWTnagccQYeSaX7L8nVEibYQZDTborZPiZiU59vPN1G87/W
         5LsPnnOfna7SFQrx2svXO51A18b/cyKOL2rs+rsRdltn5CHQJ0qWG29McNV+Ftg7gv
         ClUr+iqBTh17+SCA23f/x2vgIak7i5PM2v/1lUI6SU2ynCSXddfa3PvUO3te1LLAfa
         ZMOWkCxFim27zjwgjcN5fmixFVasoxBjml5/tQll3wnewKxHA6Vuo+L3ijBFPqdwIB
         bM+ItUVpYgxSUBOYF2ek3LkMN6Jb9G8nfpshI6oGBMvG1o9BdwD94j+g0jPPsp/mdG
         4ajlDt72+qaWg==
Date:   Fri, 4 Feb 2022 19:52:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 1/2] net: typhoon: implement ndo_features_check
 method
Message-ID: <20220204195229.2e210fde@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220203180227.3751784-2-eric.dumazet@gmail.com>
References: <20220203180227.3751784-1-eric.dumazet@gmail.com>
        <20220203180227.3751784-2-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Feb 2022 10:02:26 -0800 Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Instead of disabling TSO if MAX_SKB_FRAGS > 32, implement
> ndo_features_check() method for this driver.
> 
> If skb has more than 32 frags, use the following heuristic:
> 
> 1) force GSO for gso packets.
> 2) Otherwise force linearization.
> 
> Most locally generated packets will use a small number
> of fragments anyway.
> 
> For forwarding workloads, we can limit gro_max_size at ingress,
> we might also implement gro_max_segs if needed.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  drivers/net/ethernet/3com/typhoon.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/3com/typhoon.c b/drivers/net/ethernet/3com/typhoon.c
> index 8aec5d9fbfef2803c181387537300502a937caf0..67b1a1f439d841ed0ed0f620e9477607ac6e2fae 100644
> --- a/drivers/net/ethernet/3com/typhoon.c
> +++ b/drivers/net/ethernet/3com/typhoon.c
> @@ -138,11 +138,6 @@ MODULE_PARM_DESC(use_mmio, "Use MMIO (1) or PIO(0) to access the NIC. "
>  module_param(rx_copybreak, int, 0);
>  module_param(use_mmio, int, 0);
>  
> -#if defined(NETIF_F_TSO) && MAX_SKB_FRAGS > 32
> -#warning Typhoon only supports 32 entries in its SG list for TSO, disabling TSO
> -#undef NETIF_F_TSO
> -#endif
> -
>  #if TXLO_ENTRIES <= (2 * MAX_SKB_FRAGS)
>  #error TX ring too small!
>  #endif
> @@ -2261,9 +2256,27 @@ typhoon_test_mmio(struct pci_dev *pdev)
>  	return mode;
>  }
>  
> +#if MAX_SKB_FRAGS > 32
> +static netdev_features_t typhoon_features_check(struct sk_buff *skb,
> +						struct net_device *dev,
> +						netdev_features_t features)
> +{
> +	if (skb_shinfo(skb)->nr_frags > 32) {
> +		if (skb_is_gso(skb))
> +			features &= ~NETIF_F_GSO_MASK;
> +		else
> +			features &= ~NETIF_F_SG;

Should we always clear SG? If we want to make the assumption that
non-gso skbs are never this long (like the driver did before) then
we should never clear SG. If we do we risk one of the gso-generated
segs will also be longer than 32 frags.

Thought I should ask.

> +	}
> +	return features;

return vlan_features_check(skb, features) ?

> +}
> +#endif
> +
>  static const struct net_device_ops typhoon_netdev_ops = {
>  	.ndo_open		= typhoon_open,
>  	.ndo_stop		= typhoon_close,
> +#if MAX_SKB_FRAGS > 32
> +	.ndo_features_check	= typhoon_features_check,
> +#endif
>  	.ndo_start_xmit		= typhoon_start_tx,
>  	.ndo_set_rx_mode	= typhoon_set_rx_mode,
>  	.ndo_tx_timeout		= typhoon_tx_timeout,

