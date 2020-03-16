Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4794187406
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 21:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732568AbgCPU0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 16:26:19 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:33174 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732505AbgCPU0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 16:26:18 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02GKQCw1033262;
        Mon, 16 Mar 2020 15:26:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584390372;
        bh=Uw8BopqoK/P4/GuaaDrgufGwy0khVyS7j8INRMwyKuc=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=s+gUBOhwOybvr83novBYWjeOKVbaLjlhF3Nlm5/SxmxfdpHP+rbhAzrNaMK51Hncn
         tdvWVoYlZqZgvRAi18KZbEC9jv0bapmHEm37KVTPRy8x6DPbI05mrN0lo6GTFlMxxW
         7khU+M4AvtWzWc0ig8k1/lAOI3AARYPFLltA9Jzo=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02GKQCjd010801
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 16 Mar 2020 15:26:12 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Mon, 16
 Mar 2020 15:26:12 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Mon, 16 Mar 2020 15:26:12 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02GKQATs100565;
        Mon, 16 Mar 2020 15:26:10 -0500
Subject: Re: [RFC/RFT net-next] net: ethernet: ti: fix netdevice stats for XDP
To:     Lorenzo Bianconi <lorenzo@kernel.org>, <netdev@vger.kernel.org>
CC:     <ilias.apalodimas@linaro.org>, <davem@davemloft.net>,
        <brouer@redhat.com>, <lorenzo.bianconi@redhat.com>
References: <82f23afa31395a8ba2a324fcec2e90e45563f9c7.1582304311.git.lorenzo@kernel.org>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <562239c7-547c-fed6-e3f3-87752f6c7402@ti.com>
Date:   Mon, 16 Mar 2020 22:26:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <82f23afa31395a8ba2a324fcec2e90e45563f9c7.1582304311.git.lorenzo@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21/02/2020 19:05, Lorenzo Bianconi wrote:
> Align netdevice statistics when the device is running in XDP mode
> to other upstream drivers. In particular reports to user-space rx
> packets even if they are not forwarded to the networking stack
> (XDP_PASS) but they are redirected (XDP_REDIRECT), dropped (XDP_DROP)
> or sent back using the same interface (XDP_TX). This patch allows the
> system administrator to very the device is receiving data correctly.

I've tested it with xdp-tutorial:
  drop: ip link set dev eth0 xdp obj ./packet01-parsing/xdp_prog_kern.o sec xdp_packet_parser
  tx: ip link set dev eth0 xdp obj ./packet-solutions/xdp_prog_kern_03.o sec xdp_icmp_echo

And see statistic incremented.

In my opinion, it looks a little bit inconsistent if RX/TX packet/bytes is updated,
but ndev->stats.rx_dropped is not.

> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
> - this patch is compile-only tested
> ---
>   drivers/net/ethernet/ti/cpsw.c      |  4 +---
>   drivers/net/ethernet/ti/cpsw_new.c  |  5 ++---
>   drivers/net/ethernet/ti/cpsw_priv.c | 13 +++++++++++--
>   drivers/net/ethernet/ti/cpsw_priv.h |  2 +-
>   4 files changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
> index 6ae4a72e6f43..fe3fd33f56f7 100644
> --- a/drivers/net/ethernet/ti/cpsw.c
> +++ b/drivers/net/ethernet/ti/cpsw.c
> @@ -408,12 +408,10 @@ static void cpsw_rx_handler(void *token, int len, int status)
>   		xdp.rxq = &priv->xdp_rxq[ch];
>   
>   		port = priv->emac_port + cpsw->data.dual_emac;
> -		ret = cpsw_run_xdp(priv, ch, &xdp, page, port);
> +		ret = cpsw_run_xdp(priv, ch, &xdp, page, port, &len);
>   		if (ret != CPSW_XDP_PASS)
>   			goto requeue;
>   
> -		/* XDP prog might have changed packet data and boundaries */
> -		len = xdp.data_end - xdp.data;
>   		headroom = xdp.data - xdp.data_hard_start;
>   
>   		/* XDP prog can modify vlan tag, so can't use encap header */
> diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
> index 71215db7934b..050496e814c3 100644
> --- a/drivers/net/ethernet/ti/cpsw_new.c
> +++ b/drivers/net/ethernet/ti/cpsw_new.c
> @@ -349,12 +349,11 @@ static void cpsw_rx_handler(void *token, int len, int status)
>   		xdp.data_hard_start = pa;
>   		xdp.rxq = &priv->xdp_rxq[ch];
>   
> -		ret = cpsw_run_xdp(priv, ch, &xdp, page, priv->emac_port);
> +		ret = cpsw_run_xdp(priv, ch, &xdp, page,
> +				   priv->emac_port, &len);
>   		if (ret != CPSW_XDP_PASS)
>   			goto requeue;
>   
> -		/* XDP prog might have changed packet data and boundaries */
> -		len = xdp.data_end - xdp.data;
>   		headroom = xdp.data - xdp.data_hard_start;
>   
>   		/* XDP prog can modify vlan tag, so can't use encap header */
> diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
> index 97a058ca60ac..a41da48db40b 100644
> --- a/drivers/net/ethernet/ti/cpsw_priv.c
> +++ b/drivers/net/ethernet/ti/cpsw_priv.c
> @@ -1317,7 +1317,7 @@ int cpsw_xdp_tx_frame(struct cpsw_priv *priv, struct xdp_frame *xdpf,
>   }
>   
>   int cpsw_run_xdp(struct cpsw_priv *priv, int ch, struct xdp_buff *xdp,
> -		 struct page *page, int port)
> +		 struct page *page, int port, int *len)
>   {
>   	struct cpsw_common *cpsw = priv->cpsw;
>   	struct net_device *ndev = priv->ndev;
> @@ -1335,10 +1335,13 @@ int cpsw_run_xdp(struct cpsw_priv *priv, int ch, struct xdp_buff *xdp,
>   	}
>   
>   	act = bpf_prog_run_xdp(prog, xdp);
> +	/* XDP prog might have changed packet data and boundaries */
> +	*len = xdp.data_end - xdp.data;

it should be

+       *len = xdp->data_end - xdp->data;


> +
>   	switch (act) {
>   	case XDP_PASS:
>   		ret = CPSW_XDP_PASS;
> -		break;
> +		goto out;
>   	case XDP_TX:
>   		xdpf = convert_to_xdp_frame(xdp);
>   		if (unlikely(!xdpf))
> @@ -1364,8 +1367,14 @@ int cpsw_run_xdp(struct cpsw_priv *priv, int ch, struct xdp_buff *xdp,
>   		trace_xdp_exception(ndev, prog, act);
>   		/* fall through -- handle aborts by dropping packet */
>   	case XDP_DROP:
> +		ndev->stats.rx_bytes += *len;
> +		ndev->stats.rx_packets++;
>   		goto drop;
>   	}
> +
> +	ndev->stats.rx_bytes += *len;
> +	ndev->stats.rx_packets++;
> +
>   out:
>   	rcu_read_unlock();
>   	return ret;
> diff --git a/drivers/net/ethernet/ti/cpsw_priv.h b/drivers/net/ethernet/ti/cpsw_priv.h
> index b8d7b924ee3d..54efd773e033 100644
> --- a/drivers/net/ethernet/ti/cpsw_priv.h
> +++ b/drivers/net/ethernet/ti/cpsw_priv.h
> @@ -439,7 +439,7 @@ int cpsw_ndo_bpf(struct net_device *ndev, struct netdev_bpf *bpf);
>   int cpsw_xdp_tx_frame(struct cpsw_priv *priv, struct xdp_frame *xdpf,
>   		      struct page *page, int port);
>   int cpsw_run_xdp(struct cpsw_priv *priv, int ch, struct xdp_buff *xdp,
> -		 struct page *page, int port);
> +		 struct page *page, int port, int *len);
>   irqreturn_t cpsw_tx_interrupt(int irq, void *dev_id);
>   irqreturn_t cpsw_rx_interrupt(int irq, void *dev_id);
>   int cpsw_tx_mq_poll(struct napi_struct *napi_tx, int budget);
> 

-- 
Best regards,
grygorii
