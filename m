Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB8E5A7F83
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 16:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbiHaOEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 10:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbiHaODr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 10:03:47 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22E1D740A
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 07:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=cw3EIDpRaDRX4DCTpWwZ/VTAQ+QKb4NXAKBrPfe2yLs=; b=Vo
        a7RTDQ2duqWdD7DVh9LVooTdMZgp8eaW9gMjHlqUkjl80aQmXprdrU96U3S9wjUA6+3tnGqbM8lLf
        mrAonIswqArtlHn+uHtmd8GpJgJu6Hfzok2kQblDRheo/HpjC6yqfd0mwJMjszEEyzONaV8pN4BD/
        /NRdw075ZIljLfA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oTOJf-00FCyO-3U; Wed, 31 Aug 2022 16:03:39 +0200
Date:   Wed, 31 Aug 2022 16:03:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>
Cc:     netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Re: [PATCH] Use a spinlock to guard `fep->ptp_clk_on`
Message-ID: <Yw9qO+3WqqTUAsIG@lunn.ch>
References: <20220831125631.173171-1-csokas.bence@prolan.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220831125631.173171-1-csokas.bence@prolan.hu>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 31, 2022 at 02:56:31PM +0200, Csókás Bence wrote:
> Mutexes cannot be taken in a non-preemptible context,
> causing a panic in `fec_ptp_save_state()`. Replacing
> `ptp_clk_mutex` by `ptp_clk_lock` fixes this.
> 
> Fixes: 91c0d987a9788dcc5fe26baafd73bf9242b68900
> Fixes: 6a4d7234ae9a3bb31181f348ade9bbdb55aeb5c5
> Fixes: f79959220fa5fbda939592bf91c7a9ea90419040
> 
> Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> Signed-off-by: Csókás Bence <csokas.bence@prolan.hu>
> ---
>  drivers/net/ethernet/freescale/fec.h      |  2 +-
>  drivers/net/ethernet/freescale/fec_main.c | 17 ++++++------
>  drivers/net/ethernet/freescale/fec_ptp.c  | 32 +++++++++++------------
>  3 files changed, 26 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
> index 0cebe4b63adb..9aac74d14f26 100644
> --- a/drivers/net/ethernet/freescale/fec.h
> +++ b/drivers/net/ethernet/freescale/fec.h
> @@ -557,7 +557,7 @@ struct fec_enet_private {
>  	struct clk *clk_2x_txclk;
>  
>  	bool ptp_clk_on;
> -	struct mutex ptp_clk_mutex;
> +	spinlock_t ptp_clk_lock;
>  	unsigned int num_tx_queues;
>  	unsigned int num_rx_queues;
>  
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index b0d60f898249..98d8f8d6034e 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -2029,6 +2029,7 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
>  {
>  	struct fec_enet_private *fep = netdev_priv(ndev);
>  	int ret;
> +	unsigned long flags;

Please keep to reverse christmas tree
  
>  	if (enable) {
>  		ret = clk_prepare_enable(fep->clk_enet_out);
> @@ -2036,15 +2037,15 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
>  			return ret;
>  
>  		if (fep->clk_ptp) {
> -			mutex_lock(&fep->ptp_clk_mutex);
> +			spin_lock_irqsave(&fep->ptp_clk_lock, flags);

Is the ptp hardware accessed in interrupt context? If not, you can use
a plain spinlock, not _irqsave..

Looking at fec_enet_interrupt() and fec_enet_collect_events() i do not
see anything.

    Andrew
