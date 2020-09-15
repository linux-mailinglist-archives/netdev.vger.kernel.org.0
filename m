Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7195B269ACF
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 03:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbgIOBCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 21:02:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:46184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbgIOBCr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 21:02:47 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F2AB20897;
        Tue, 15 Sep 2020 01:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600131766;
        bh=rcUTiEDscKq9WvyrbhZMnGd9sESz+6KVCA3cBx84RRM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1Nff53bF1ooiZft2vuwx9AyOPhB18fxB0omFu+iP+s1M2dbXGNTA0sttkQASTlIsL
         ZXk+1efvDrUrVXv8m7m8ahYvD08dIzAOFZGKuLlS3ycYc5u5cVlKqvIsqP4TDcjGAc
         XXVA3Fs31/Cu7c/5hgVo4fxLZuyvAfftommXZG90=
Date:   Mon, 14 Sep 2020 18:02:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Allen Pais <allen.lkml@gmail.com>
Cc:     davem@davemloft.net, m.grzeschik@pengutronix.de, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, petkan@nucleusys.com,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-ppp@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: Re: [RESEND net-next v2 01/12] net: mvpp2: Prepare to use the new
 tasklet API
Message-ID: <20200914180244.3581836c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200914073131.803374-2-allen.lkml@gmail.com>
References: <20200914073131.803374-1-allen.lkml@gmail.com>
        <20200914073131.803374-2-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Sep 2020 13:01:20 +0530 Allen Pais wrote:
> From: Allen Pais <apais@linux.microsoft.com>
> 
> The future tasklet API will no longer allow to pass an arbitrary
> "unsigned long" data parameter. The tasklet data structure will need to
> be embedded into a data structure that will be retrieved from the tasklet
> handler. Currently, there are no ways to retrieve the "struct mvpp2_port
> *" from a given "struct mvpp2_port_pcpu *". This commit adds a new field
> to get the address of the main port for each pcpu context.
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> Signed-off-by: Allen Pais <apais@linux.microsoft.com>
> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2.h      | 1 +
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> index 32753cc771bf..198860a4527d 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> @@ -861,6 +861,7 @@ struct mvpp2_port_pcpu {
>  	struct hrtimer tx_done_timer;
>  	struct net_device *dev;
>  	bool timer_scheduled;
> +	struct mvpp2_port *port;
>  };
>  
>  struct mvpp2_queue_vector {
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index 6e140d1b8967..e8e68e8acdb3 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -6025,6 +6025,7 @@ static int mvpp2_port_probe(struct platform_device *pdev,
>  		err = -ENOMEM;
>  		goto err_free_txq_pcpu;
>  	}
> +	port->pcpu->port = port;
>  
>  	if (!port->has_tx_irqs) {
>  		for (thread = 0; thread < priv->nthreads; thread++) {

Not 100% sure but I think this is yours:

drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:6442:13: warning: dereference of noderef expression

port->pcpu is __percpu, no?
