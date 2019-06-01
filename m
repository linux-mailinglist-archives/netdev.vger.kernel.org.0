Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D982D31B82
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 12:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfFAK4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 06:56:21 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:37092 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfFAK4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 06:56:20 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id x51AtujZ094143;
        Sat, 1 Jun 2019 05:55:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1559386557;
        bh=bxg2k/hWhokU2wf2qE2aElJbPfm88t3enDqzTSr1Xoc=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=SAshwVJTfnPjGK6MJe8SUU3jMcAx2x/QqV/dDpYoCMzn2oehLxIWCAQLw/h+yInbI
         ZGiLk4JlQvN3W85Cgx1eLSVSv6B+8MH18lCOvX+rhxRPXR32SN/P1aCIPo7WbhfQRN
         CsCoXDwMq9a7DxTJKHiAXMQLZC0VYsEvHAr76xCw=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x51AtuDu033889
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 1 Jun 2019 05:55:56 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Sat, 1 Jun
 2019 05:55:56 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Sat, 1 Jun 2019 05:55:56 -0500
Received: from [10.250.96.121] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id x51AtrJY124492;
        Sat, 1 Jun 2019 05:55:53 -0500
Subject: Re: [PATCH v2 net-next 4/7] net: ethernet: ti: cpsw_ethtool: simplify
 slave loops
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>, <hawk@kernel.org>,
        <davem@davemloft.net>
CC:     <ast@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <xdp-newbies@vger.kernel.org>,
        <ilias.apalodimas@linaro.org>, <netdev@vger.kernel.org>,
        <daniel@iogearbox.net>, <jakub.kicinski@netronome.com>,
        <john.fastabend@gmail.com>
References: <20190530182039.4945-1-ivan.khoronzhuk@linaro.org>
 <20190530182039.4945-5-ivan.khoronzhuk@linaro.org>
From:   grygorii <grygorii.strashko@ti.com>
Message-ID: <d9e38ccf-004e-b2bd-fed4-af71157d02b4@ti.com>
Date:   Sat, 1 Jun 2019 13:55:51 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190530182039.4945-5-ivan.khoronzhuk@linaro.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 30/05/2019 21:20, Ivan Khoronzhuk wrote:
> Only for consistency reasons, do it like in main cpsw.c module
> and use ndev reference but not by means of slave.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---
>   drivers/net/ethernet/ti/cpsw_ethtool.c | 40 ++++++++++++++------------
>   1 file changed, 21 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ti/cpsw_ethtool.c b/drivers/net/ethernet/ti/cpsw_ethtool.c
> index a4a7ec0d2531..c260bb32aacf 100644
> --- a/drivers/net/ethernet/ti/cpsw_ethtool.c
> +++ b/drivers/net/ethernet/ti/cpsw_ethtool.c
> @@ -458,7 +458,6 @@ int cpsw_nway_reset(struct net_device *ndev)
>   static void cpsw_suspend_data_pass(struct net_device *ndev)
>   {

[...]

>   
>   	return 0;
>   }
> @@ -587,7 +590,6 @@ int cpsw_set_channels_common(struct net_device *ndev,
>   {
>   	struct cpsw_priv *priv = netdev_priv(ndev);
>   	struct cpsw_common *cpsw = priv->cpsw;
> -	struct cpsw_slave *slave;
>   	int i, ret;
>   
>   	ret = cpsw_check_ch_settings(cpsw, chs);
> @@ -604,20 +606,20 @@ int cpsw_set_channels_common(struct net_device *ndev,
>   	if (ret)
>   		goto err;
>   
> -	for (i = cpsw->data.slaves, slave = cpsw->slaves; i; i--, slave++) {
> -		if (!(slave->ndev && netif_running(slave->ndev)))
> +	for (i = 0; i < cpsw->data.slaves; i++) {
> +		struct net_device *ndev = cpsw->slaves[i].ndev;

Sry, but could you rename this local var "ndev" and make it differ from func argument name.

> +
> +		if (!(ndev && netif_running(ndev)))
>   			continue;
>   
>   		/* Inform stack about new count of queues */
> -		ret = netif_set_real_num_tx_queues(slave->ndev,
> -						   cpsw->tx_ch_num);
> +		ret = netif_set_real_num_tx_queues(ndev, cpsw->tx_ch_num);
>   		if (ret) {
>   			dev_err(priv->dev, "cannot set real number of tx queues\n");
>   			goto err;
>   		}
>   
> -		ret = netif_set_real_num_rx_queues(slave->ndev,
> -						   cpsw->rx_ch_num);
> +		ret = netif_set_real_num_rx_queues(ndev, cpsw->rx_ch_num);
>   		if (ret) {
>   			dev_err(priv->dev, "cannot set real number of rx queues\n");
>   			goto err;
> 

-- 
Best regards,
grygorii
