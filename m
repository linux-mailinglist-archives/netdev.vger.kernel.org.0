Return-Path: <netdev+bounces-1680-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FEEE6FECB7
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 09:25:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC594281420
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 07:25:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6FF481F;
	Thu, 11 May 2023 07:25:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90251B8E8
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 07:25:08 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382566A52;
	Thu, 11 May 2023 00:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1683789895; x=1715325895;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=K1mgrZfFCls8u5NmU8XyZVTtBs5ziCVIjjKenDOXFvU=;
  b=s9023dD7z+df7yxHAX7mk9XQCrSfVifSO3ecYBEmWgvVDEhugD0RErsw
   kLTfypimc738n3tNYpH8uvlTR50n0KqjlH5k1VYBS9V5HOvdvqMiU60bN
   fhmHJ0adCbA6BZc2B7K1vDMRpiwShIuBWhCTZUqBEyHrAOWpY4iwm07uz
   MdQNEo/0LosQrfPdkLS6XCwR+d6xYNASDRagFy25f+MMcyZs8ToHjH/ny
   4NPPrsEcgpc03k+7GQCztEKdoCe3/eiahg93+SlClgZuXazv7sWUuIMDy
   peg87tztdjhIx8cBAelxmG89l37k0SM3ZQEOIlBOlHMQlyOIZOFHi/dit
   A==;
X-IronPort-AV: E=Sophos;i="5.99,266,1677567600"; 
   d="scan'208";a="213383976"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 May 2023 00:24:54 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 11 May 2023 00:24:53 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Thu, 11 May 2023 00:24:52 -0700
Date: Thu, 11 May 2023 09:24:52 +0200
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: Shenwei Wang <shenwei.wang@nxp.com>
CC: Wei Fang <wei.fang@nxp.com>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Clark Wang <xiaoning.wang@nxp.com>, NXP Linux Team
	<linux-imx@nxp.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann
	<daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>, John
 Fastabend <john.fastabend@gmail.com>, Alexander Lobakin
	<alexandr.lobakin@intel.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <imx@lists.linux.dev>
Subject: Re: [PATCH v2 net 1/1] net: fec: using the standard return codes
 when xdp xmit errors
Message-ID: <20230511072452.umskoyoscsxgmcoo@soft-dev3-1>
References: <20230510200523.1352951-1-shenwei.wang@nxp.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20230510200523.1352951-1-shenwei.wang@nxp.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The 05/10/2023 15:05, Shenwei Wang wrote:
> 
> This patch standardizes the inconsistent return values for unsuccessful
> XDP transmits by using standardized error codes (-EBUSY or -ENOMEM).

Shouldn't this patch target net-next instead of net? As Simon suggested
here [1], or maybe is just me who misunderstood that part.
Also it is nice to CC people who comment at your previous patches in all
the next versions.

Just a small thing, if there is only 1 patch in the series, you don't
need to add 1/1 in the subject.

[1] https://lore.kernel.org/netdev/20230509193845.1090040-1-shenwei.wang@nxp.com/T/#m4b6b21c75512391496294fc78db2fbdf687f1381

> 
> Fixes: 26312c685ae0 ("net: fec: correct the counting of XDP sent frames")
> Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
> ---
>  v2:
>   - focusing on code clean up per Simon's feedback.
> 
>  drivers/net/ethernet/freescale/fec_main.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index 42ec6ca3bf03..6a021fe24dfe 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -3798,8 +3798,7 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
>         entries_free = fec_enet_get_free_txdesc_num(txq);
>         if (entries_free < MAX_SKB_FRAGS + 1) {
>                 netdev_err(fep->netdev, "NOT enough BD for SG!\n");
> -               xdp_return_frame(frame);
> -               return NETDEV_TX_BUSY;
> +               return -EBUSY;
>         }
> 
>         /* Fill in a Tx ring entry */
> @@ -3813,7 +3812,7 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
>         dma_addr = dma_map_single(&fep->pdev->dev, frame->data,
>                                   frame->len, DMA_TO_DEVICE);
>         if (dma_mapping_error(&fep->pdev->dev, dma_addr))
> -               return FEC_ENET_XDP_CONSUMED;
> +               return -ENOMEM;
> 
>         status |= (BD_ENET_TX_INTR | BD_ENET_TX_LAST);
>         if (fep->bufdesc_ex)
> @@ -3869,7 +3868,7 @@ static int fec_enet_xdp_xmit(struct net_device *dev,
>         __netif_tx_lock(nq, cpu);
> 
>         for (i = 0; i < num_frames; i++) {
> -               if (fec_enet_txq_xmit_frame(fep, txq, frames[i]) != 0)
> +               if (fec_enet_txq_xmit_frame(fep, txq, frames[i]) < 0)
>                         break;
>                 sent_frames++;
>         }
> --
> 2.34.1
> 
> 

-- 
/Horatiu

