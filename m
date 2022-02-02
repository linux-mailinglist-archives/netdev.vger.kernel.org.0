Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAB34A6ABB
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 05:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243923AbiBBEF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 23:05:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbiBBEF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 23:05:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B185C061714;
        Tue,  1 Feb 2022 20:05:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95F7AB82F70;
        Wed,  2 Feb 2022 04:05:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFD3C004E1;
        Wed,  2 Feb 2022 04:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643774723;
        bh=oxbbL/7HMUwj9VfiRo09uO7jEK454MuKV84eIgFo8Go=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pt3rmvr4JeVdV1AltD2Linl+hj08cNgmKgROcjgR3N3UzirHCMEgizsCYI3/o+0t0
         /TKiQwNOqbiVw6qqCnttHnSDJMhP4CmZI67dlzC2+MTOiCoylTwtMx7Axiq+cbDdLC
         LNbTUKekXnV1KffwYEJlszzuYUQkIuHnsdb7nd3S7KKAouG8EPXuggs0oGfH/sBy7o
         z7Qb15N8xksHms6CxbCdm94DhIM5rwZBEm6SErsRJCu6W2DtvtR8+erYsuA6JDPJlF
         eEAXjyjtH6dtgxmzC2iTK/eV9eLddaM06JuWLYMt02nyNcU+Qb8A4f7ARrIJ4PysbS
         g43rhuwUA+5Ag==
Date:   Tue, 1 Feb 2022 20:05:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "Dan Carpenter" <dan.carpenter@oracle.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net] net: sparx5: do not refer to skb after passing it
 on
Message-ID: <20220201200521.179857d7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220201143057.3533830-1-steen.hegelund@microchip.com>
References: <20220201143057.3533830-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Feb 2022 15:30:57 +0100 Steen Hegelund wrote:
> Do not try to use any SKB fields after the packet has been passed up in the
> receive stack.
> 
> This error was reported as shown below:

No need to spell it out, the tags speak for themselves.

> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> 

Drop this...

> Fixes: f3cad2611a77 (net: sparx5: add hostmode with phylink support)
> 

and this empty line - all the tags should be together.

> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> ---
>  drivers/net/ethernet/microchip/sparx5/sparx5_packet.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
> index dc7e5ea6ec15..ebdce4b35686 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
> @@ -145,8 +145,8 @@ static void sparx5_xtr_grp(struct sparx5 *sparx5, u8 grp, bool byte_swap)
>  	skb_put(skb, byte_cnt - ETH_FCS_LEN);
>  	eth_skb_pad(skb);
>  	skb->protocol = eth_type_trans(skb, netdev);
> -	netif_rx(skb);
>  	netdev->stats.rx_bytes += skb->len;
> +	netif_rx(skb);
>  	netdev->stats.rx_packets++;

sorry to nit pick - wouldn't it be neater if both the stats were
updated together?  Looks a little strange that netif_rx() is in
between the two now.

>  }
> 
> --
> 2.35.1
> 

