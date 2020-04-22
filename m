Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 187E21B4E54
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 22:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgDVU32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 16:29:28 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:47890 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgDVU30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 16:29:26 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 03MKSvE6071650;
        Wed, 22 Apr 2020 15:28:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1587587337;
        bh=Skbg8jv1KA4M4C98Xxf18DJCDL61t6UbC2De6JZE8JQ=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=Y0z+nBYr4LTXgGjXUsfx03Jcna7kYd3jZvS4tuoLAIvAaiLqKW/eXKG/Xg0pDiqXm
         5Z8Ph6LPJud1WgORrFO28Tv3KtCw+cJG/WkTJno+rJ1Qk2J0esdkwSxs1avRgBFH//
         A7EkUoIUaNj4yP1+thJ3jA/+uC3tVhKa2dmrxy+I=
Received: from DFLE104.ent.ti.com (dfle104.ent.ti.com [10.64.6.25])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 03MKSvO9107214;
        Wed, 22 Apr 2020 15:28:57 -0500
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 22
 Apr 2020 15:28:56 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 22 Apr 2020 15:28:56 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 03MKSl2P087383;
        Wed, 22 Apr 2020 15:28:48 -0500
Subject: Re: [PATCH net-next 14/33] net: ethernet: ti: add XDP frame size to
 driver cpsw
To:     Jesper Dangaard Brouer <brouer@redhat.com>, <sameehj@amazon.com>
CC:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <zorik@amazon.com>, <akiyano@amazon.com>, <gtzalik@amazon.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        <steffen.klassert@secunet.com>
References: <158757160439.1370371.13213378122947426220.stgit@firesoul>
 <158757171217.1370371.5128677508831971161.stgit@firesoul>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <340e0da5-8c0a-5719-45a5-94ce4a26a1fa@ti.com>
Date:   Wed, 22 Apr 2020 23:28:48 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <158757171217.1370371.5128677508831971161.stgit@firesoul>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22/04/2020 19:08, Jesper Dangaard Brouer wrote:
> The driver code cpsw.c and cpsw_new.c both use page_pool
> with default order-0 pages or their RX-pages.
> 
> Cc: Grygorii Strashko <grygorii.strashko@ti.com>
> Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>   drivers/net/ethernet/ti/cpsw.c     |    1 +
>   drivers/net/ethernet/ti/cpsw_new.c |    1 +
>   2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
> index c2c5bf87da01..58e346ea9898 100644
> --- a/drivers/net/ethernet/ti/cpsw.c
> +++ b/drivers/net/ethernet/ti/cpsw.c
> @@ -406,6 +406,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
>   
>   		xdp.data_hard_start = pa;
>   		xdp.rxq = &priv->xdp_rxq[ch];
> +		xdp.frame_sz = PAGE_SIZE;
>   
>   		port = priv->emac_port + cpsw->data.dual_emac;
>   		ret = cpsw_run_xdp(priv, ch, &xdp, page, port);
> diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
> index 9209e613257d..08e1c5b8f00e 100644
> --- a/drivers/net/ethernet/ti/cpsw_new.c
> +++ b/drivers/net/ethernet/ti/cpsw_new.c
> @@ -348,6 +348,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
>   
>   		xdp.data_hard_start = pa;
>   		xdp.rxq = &priv->xdp_rxq[ch];
> +		xdp.frame_sz = PAGE_SIZE;
>   
>   		ret = cpsw_run_xdp(priv, ch, &xdp, page, priv->emac_port);
>   		if (ret != CPSW_XDP_PASS)
> 
> 

Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>

-- 
Best regards,
grygorii
