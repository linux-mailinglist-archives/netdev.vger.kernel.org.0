Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D02037B0DD
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 23:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbhEKVkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 17:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbhEKVks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 17:40:48 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1123CC061574;
        Tue, 11 May 2021 14:39:41 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id l2so21545406wrm.9;
        Tue, 11 May 2021 14:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ucKCFBrT+zwgV1X0IRF8k4RTbTtEyDP2tjZWdZFokhw=;
        b=MFeKLxSEgLGXBNo8T0St5NX1SB5q1PH6BEtNy3e6fDAGKYmCxJ5XDfOG3ntzxIxCQm
         zPSOAFtle2ADhk009fW3lQSzqKyWpfQKx6X38Y2OcRbkBmcwCGC+Exg8g9zHXaL/SKbn
         alMzHLPJ87szGHbHT+3/OWPKtDEJj2MZkld1yYzO+AIvMCMLceibvKeVlPI7NRWFbouU
         IchZAdWJ5yZOcquWkMYRWt9jChjhE+reWpT9PaIBpEKNuKwhVkpUBCCSyvyP7OAaZlg8
         pZGhunAEmqFvZB/8MziXdZp2xPzWaarIV6CewXtRYINI4acchi2mN07hN7TaWR6oo1eh
         7Ukg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ucKCFBrT+zwgV1X0IRF8k4RTbTtEyDP2tjZWdZFokhw=;
        b=a/7OxvWUFBRn3DfP1aMBTFNXcYjoJ18zpQFnG8+tMY1DH/TdiAT9iApIjMUbNHY+fH
         utiqCHyfLR7WbNBoTPoGixdfof8zLo6zmWCT1MbCXQ5brmZBbYMgpJ+IvIDsETrYLDF9
         WeHsi+GXJ50VmBmfgfowONRzXB+ZxTefEMKbO99kjf4WPgd0XZrgBzmZlAhqsoM8cHd7
         dP7WPyySSDcv1XLOrPZsR4zGAp57raRGw+fnFJtewrGkM6QRvfuvRAkdSCiBeuXVCPQR
         wCDrSk5IATf0Qpo/nr2EUx2E1oI2zF7fsKeoxdCV0EmFeFGgUAP6o9+3lhVj4+dJwRO5
         jV3A==
X-Gm-Message-State: AOAM532p2AaEd0MTk9ayOCzGfTuDaBbAv+T86OSPegQlwNfMrSaLsgAZ
        MNqMdzbEnZguo6f5tfdaOK8j1mLW25g=
X-Google-Smtp-Source: ABdhPJyhvVminRShmo+ZuoM0CDiH9IA8TMIqNeHVvLfb+/WADJ94cNTqI5lIxsrc8pp/IiSBXMoXxA==
X-Received: by 2002:adf:9cc1:: with SMTP id h1mr39311157wre.135.1620769179562;
        Tue, 11 May 2021 14:39:39 -0700 (PDT)
Received: from [10.0.0.2] ([37.171.144.77])
        by smtp.gmail.com with ESMTPSA id j10sm28795388wrt.32.2021.05.11.14.39.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 May 2021 14:39:38 -0700 (PDT)
Subject: Re: [PATCH net-next 2/4] atl1c: improve performance by avoiding
 unnecessary pcie writes on xmit
To:     Gatis Peisenieks <gatis@mikrotik.com>, chris.snook@gmail.com,
        davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        jesse.brandeburg@intel.com, dchickles@marvell.com,
        tully@mikrotik.com, eric.dumazet@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210511190518.8901-1-gatis@mikrotik.com>
 <20210511190518.8901-3-gatis@mikrotik.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <217ba8c9-ab09-46be-3e49-149f810e72fd@gmail.com>
Date:   Tue, 11 May 2021 23:39:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210511190518.8901-3-gatis@mikrotik.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/21 9:05 PM, Gatis Peisenieks wrote:
> The kernel has xmit_more facility that hints the networking driver xmit
> path about whether more packets are coming soon. This information can be
> used to avoid unnecessary expensive PCIe transaction per tx packet at a
> slight increase in latency.
> 
> Max TX pps on Mikrotik 10/25G NIC in a Threadripper 3960X system
> improved from 1150Kpps to 1700Kpps.
> 
> Signed-off-by: Gatis Peisenieks <gatis@mikrotik.com>
> ---
>  drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> index 28c30d5288e4..2a8ab51b0ed9 100644
> --- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> +++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> @@ -2211,8 +2211,8 @@ static int atl1c_tx_map(struct atl1c_adapter *adapter,
>  	return -1;
>  }
>  
> -static void atl1c_tx_queue(struct atl1c_adapter *adapter, struct sk_buff *skb,
> -			   struct atl1c_tpd_desc *tpd, enum atl1c_trans_queue type)
> +static void atl1c_tx_queue(struct atl1c_adapter *adapter,
> +			   enum atl1c_trans_queue type)
>  {
>  	struct atl1c_tpd_ring *tpd_ring = &adapter->tpd_ring[type];
>  	u16 reg;
> @@ -2238,6 +2238,7 @@ static netdev_tx_t atl1c_xmit_frame(struct sk_buff *skb,
>  
>  	if (atl1c_tpd_avail(adapter, type) < tpd_req) {
>  		/* no enough descriptor, just stop queue */
> +		atl1c_tx_queue(adapter, type);
>  		netif_stop_queue(netdev);
>  		return NETDEV_TX_BUSY;
>  	}
> @@ -2246,6 +2247,7 @@ static netdev_tx_t atl1c_xmit_frame(struct sk_buff *skb,
>  
>  	/* do TSO and check sum */
>  	if (atl1c_tso_csum(adapter, skb, &tpd, type) != 0) {
> +		atl1c_tx_queue(adapter, type);
>  		dev_kfree_skb_any(skb);
>  		return NETDEV_TX_OK;
>  	}
> @@ -2270,8 +2272,11 @@ static netdev_tx_t atl1c_xmit_frame(struct sk_buff *skb,
>  		atl1c_tx_rollback(adapter, tpd, type);
>  		dev_kfree_skb_any(skb);
>  	} else {
> -		netdev_sent_queue(adapter->netdev, skb->len);
> -		atl1c_tx_queue(adapter, skb, tpd, type);
> +		bool more = netdev_xmit_more();
> +
> +		__netdev_sent_queue(adapter->netdev, skb->len, more);


This is probably buggy.

You must check and use the return code of this function,
as in :

	bool door_bell = __netdev_sent_queue(adapter->netdev, skb->len, netdev_xmit_more());

	if (door_bell)
		atl1c_tx_queue(adapter, type);


> +		if (!more)
> +			atl1c_tx_queue(adapter, type);
>  	}
>  
>  	return NETDEV_TX_OK;
> 
