Return-Path: <netdev+bounces-621-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D5916F8976
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 21:23:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4A4E28108B
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 19:23:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6A02C8F1;
	Fri,  5 May 2023 19:23:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0360DC12D;
	Fri,  5 May 2023 19:23:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D229C433D2;
	Fri,  5 May 2023 19:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683314633;
	bh=bdU+nJ5tDBKsZGVPg25sg3cFr7mKjHTgsdrS7vgkuIU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=c2l6vIFtlSLOcbNMXMnmtAKAU3xlPDfAudVxE+dykAKpN0Fcy6y+26q4cgowlp4Yz
	 6n6vSokr04c+agovMiKs50ry0aonHiWUrDIiIsRWYcxCgigtZW21amzQdHvRRHHl0F
	 OJmS+YukgHX8cgYpoVV6Ro59T3FEjb9Gtir6fwtPqvyxQmDmCDROr4etYgrMD+pSWh
	 kNominJyJLQPoFCerDPWxJvZeddteAoe1HjrPE+ZUfMxO6MlEpofv6ia73WkfPh0Yz
	 m9shFM6LQNsU7X69JUTRoZI8o8YFRSXo2QEXmx1jacefXQaa5CsDxGyKxwKIELVwlY
	 waI5lfvc5tPNw==
Date: Fri, 5 May 2023 12:23:52 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Shenwei Wang <shenwei.wang@nxp.com>
Cc: Wei Fang <wei.fang@nxp.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Clark
 Wang <xiaoning.wang@nxp.com>, NXP Linux Team <linux-imx@nxp.com>, Alexei
 Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend
 <john.fastabend@gmail.com>, Alexander Lobakin <alexandr.lobakin@intel.com>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, imx@lists.linux.dev,
 Gagandeep Singh <g.singh@nxp.com>
Subject: Re: [PATCH v3 net 1/1] net: fec: correct the counting of XDP sent
 frames
Message-ID: <20230505122352.0296f888@kernel.org>
In-Reply-To: <20230504153517.816636-1-shenwei.wang@nxp.com>
References: <20230504153517.816636-1-shenwei.wang@nxp.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  4 May 2023 10:35:17 -0500 Shenwei Wang wrote:
> In the current xdp_xmit implementation, if any single frame fails to
> transmit due to insufficient buffer descriptors, the function nevertheless
> reports success in sending all frames. This results in erroneously
> indicating that frames were transmitted when in fact they were dropped.
> 
> This patch fixes the issue by ensureing the return value properly
> indicates the actual number of frames successfully transmitted, rather than
> potentially reporting success for all frames when some could not transmit.
> 
> Fixes: 6d6b39f180b8 ("net: fec: add initial XDP support")
> Signed-off-by: Gagandeep Singh <g.singh@nxp.com>
> Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
> ---
>  v3:
>   - resend the v2 fix for "net" as the standalone patch.
> 
>  v2:
>   - only keep the bug fix part of codes according to Horatiu's comments.
>   - restructure the functions to avoid the forward declaration.
> 
>  drivers/net/ethernet/freescale/fec_main.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index 160c1b3525f5..42ec6ca3bf03 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -3798,7 +3798,8 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
>  	entries_free = fec_enet_get_free_txdesc_num(txq);
>  	if (entries_free < MAX_SKB_FRAGS + 1) {
>  		netdev_err(fep->netdev, "NOT enough BD for SG!\n");

This should really be rate limited :(

> -		return NETDEV_TX_OK;
> +		xdp_return_frame(frame);

Why return this frame? Since error is reported @sent_frames will not be
incremented, and therefore bq_xmit_all() will take care of returning it,
right?

Otherwise the other error return path (see below) needs to be changed
as well.

> +		return NETDEV_TX_BUSY;

On DMA mapping error this function returns FEC_ENET_XDP_CONSUMED,
would be good if the functions return values where from the same
"enum". Are you going to clean that part up in net-next?

>  	}
> 
>  	/* Fill in a Tx ring entry */
> @@ -3856,6 +3857,7 @@ static int fec_enet_xdp_xmit(struct net_device *dev,
>  	struct fec_enet_private *fep = netdev_priv(dev);
>  	struct fec_enet_priv_tx_q *txq;
>  	int cpu = smp_processor_id();
> +	unsigned int sent_frames = 0;
>  	struct netdev_queue *nq;
>  	unsigned int queue;
>  	int i;
> @@ -3866,8 +3868,11 @@ static int fec_enet_xdp_xmit(struct net_device *dev,
> 
>  	__netif_tx_lock(nq, cpu);
> 
> -	for (i = 0; i < num_frames; i++)
> -		fec_enet_txq_xmit_frame(fep, txq, frames[i]);
> +	for (i = 0; i < num_frames; i++) {
> +		if (fec_enet_txq_xmit_frame(fep, txq, frames[i]) != 0)

nit: you can skip the "!= 0", but up to you

> +			break;
> +		sent_frames++;
> +	}

-- 
pw-bot: cr

