Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690C53E1B94
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 20:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241583AbhHESoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 14:44:04 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:33964 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241568AbhHESoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 14:44:02 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 175IhhCt001060;
        Thu, 5 Aug 2021 13:43:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1628189023;
        bh=46JDL8MQEgeXUPygiDI9iRLIqECk9VxRHBRsZUVsTe0=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=bFzVWr8IUighh8u3JJL/AhOWz4wbdb5iju+RonuFifeBvPOIGI23vz1tur4qrRe1j
         A3khATTv+PEdRheUlpVj5wT9zzxitwVxlblKXE9tnNhNKF5KXV+jzw82CIjnNXVFzE
         1FG+MtcFDzUmJ9yjT78ImAdn/3bT1g9ocqbgLhbQ=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 175Ihhqe023395
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 5 Aug 2021 13:43:43 -0500
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 5 Aug
 2021 13:43:43 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Thu, 5 Aug 2021 13:43:43 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 175IhebH020200;
        Thu, 5 Aug 2021 13:43:41 -0500
Subject: Re: [PATCH net v2] net: ethernet: ti: cpsw: fix min eth packet size
 for non-switch use-cases
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Ben Hutchings <ben.hutchings@essensium.com>
CC:     <linux-kernel@vger.kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        <linux-omap@vger.kernel.org>, Lokesh Vutla <lokeshvutla@ti.com>,
        <stable@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20210805145511.12016-1-grygorii.strashko@ti.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <85769243-daa0-c5c4-f441-6270c4b21cd5@ti.com>
Date:   Thu, 5 Aug 2021 21:43:39 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210805145511.12016-1-grygorii.strashko@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 05/08/2021 17:55, Grygorii Strashko wrote:
> The CPSW switchdev driver inherited fix from commit 9421c9015047 ("net:
> ethernet: ti: cpsw: fix min eth packet size") which changes min TX packet
> size to 64bytes (VLAN_ETH_ZLEN, excluding ETH_FCS). It was done to fix HW
> packed drop issue when packets are sent from Host to the port with PVID and
> un-tagging enabled. Unfortunately this breaks some other non-switch
> specific use-cases, like:
> - [1] CPSW port as DSA CPU port with DSA-tag applied at the end of the
> packet
> - [2] Some industrial protocols, which expects min TX packet size 60Bytes
> (excluding FCS).
> 
> Fix it by configuring min TX packet size depending on driver mode
>   - 60Bytes (ETH_ZLEN) for multi mac (dual-mac) mode
>   - 64Bytes (VLAN_ETH_ZLEN) for switch mode
> and update it during driver mode change and annotate with
> READ_ONCE()/WRITE_ONCE() as it can be read by napi while writing.
> 
> [1] https://lore.kernel.org/netdev/20210531124051.GA15218@cephalopod/
> [2] https://e2e.ti.com/support/arm/sitara_arm/f/791/t/701669
> 
> 
> Cc: stable@vger.kernel.org
> Fixes: ed3525eda4c4 ("net: ethernet: ti: introduce cpsw switchdev based driver part 1 - dual-emac")
> Reported-by: Ben Hutchings <ben.hutchings@essensium.com>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
> 
> Changes in v2:
> - use skb_put_padto
> - update description
> - annotate tx_packet_min with READ_ONCE()/WRITE_ONCE()
> 
> I'm not going to add additional changes in cpdma configuration interface and,
> instead, will send patches to convert all cpdma users to use skb_put_padto() and
> drop frames padding from cpdma.
> 
> v1: https://patchwork.kernel.org/project/netdevbpf/patch/20210611132732.10690-1-grygorii.strashko@ti.com/
> 
>   drivers/net/ethernet/ti/cpsw_new.c  | 7 +++++--
>   drivers/net/ethernet/ti/cpsw_priv.h | 4 +++-
>   2 files changed, 8 insertions(+), 3 deletions(-)
> 

Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>

> diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
> index ae167223e87f..d904f4ca4b37 100644
> --- a/drivers/net/ethernet/ti/cpsw_new.c
> +++ b/drivers/net/ethernet/ti/cpsw_new.c
> @@ -921,7 +921,7 @@ static netdev_tx_t cpsw_ndo_start_xmit(struct sk_buff *skb,
>   	struct cpdma_chan *txch;
>   	int ret, q_idx;
>   
> -	if (skb_padto(skb, CPSW_MIN_PACKET_SIZE)) {
> +	if (skb_put_padto(skb, READ_ONCE(priv->tx_packet_min))) {
>   		cpsw_err(priv, tx_err, "packet pad failed\n");
>   		ndev->stats.tx_dropped++;
>   		return NET_XMIT_DROP;
> @@ -1101,7 +1101,7 @@ static int cpsw_ndo_xdp_xmit(struct net_device *ndev, int n,
>   
>   	for (i = 0; i < n; i++) {
>   		xdpf = frames[i];
> -		if (xdpf->len < CPSW_MIN_PACKET_SIZE)
> +		if (xdpf->len < READ_ONCE(priv->tx_packet_min))
>   			break;
>   
>   		if (cpsw_xdp_tx_frame(priv, xdpf, NULL, priv->emac_port))
> @@ -1390,6 +1390,7 @@ static int cpsw_create_ports(struct cpsw_common *cpsw)
>   		priv->dev  = dev;
>   		priv->msg_enable = netif_msg_init(debug_level, CPSW_DEBUG);
>   		priv->emac_port = i + 1;
> +		priv->tx_packet_min = CPSW_MIN_PACKET_SIZE;
>   
>   		if (is_valid_ether_addr(slave_data->mac_addr)) {
>   			ether_addr_copy(priv->mac_addr, slave_data->mac_addr);
> @@ -1698,6 +1699,7 @@ static int cpsw_dl_switch_mode_set(struct devlink *dl, u32 id,
>   
>   			priv = netdev_priv(sl_ndev);
>   			slave->port_vlan = vlan;
> +			WRITE_ONCE(priv->tx_packet_min, CPSW_MIN_PACKET_SIZE_VLAN);
>   			if (netif_running(sl_ndev))
>   				cpsw_port_add_switch_def_ale_entries(priv,
>   								     slave);
> @@ -1726,6 +1728,7 @@ static int cpsw_dl_switch_mode_set(struct devlink *dl, u32 id,
>   
>   			priv = netdev_priv(slave->ndev);
>   			slave->port_vlan = slave->data->dual_emac_res_vlan;
> +			WRITE_ONCE(priv->tx_packet_min, CPSW_MIN_PACKET_SIZE);
>   			cpsw_port_add_dual_emac_def_ale_entries(priv, slave);
>   		}
>   
> diff --git a/drivers/net/ethernet/ti/cpsw_priv.h b/drivers/net/ethernet/ti/cpsw_priv.h
> index a323bea54faa..2951fb7b9dae 100644
> --- a/drivers/net/ethernet/ti/cpsw_priv.h
> +++ b/drivers/net/ethernet/ti/cpsw_priv.h
> @@ -89,7 +89,8 @@ do {								\
>   
>   #define CPSW_POLL_WEIGHT	64
>   #define CPSW_RX_VLAN_ENCAP_HDR_SIZE		4
> -#define CPSW_MIN_PACKET_SIZE	(VLAN_ETH_ZLEN)
> +#define CPSW_MIN_PACKET_SIZE_VLAN	(VLAN_ETH_ZLEN)
> +#define CPSW_MIN_PACKET_SIZE	(ETH_ZLEN)
>   #define CPSW_MAX_PACKET_SIZE	(VLAN_ETH_FRAME_LEN +\
>   				 ETH_FCS_LEN +\
>   				 CPSW_RX_VLAN_ENCAP_HDR_SIZE)
> @@ -380,6 +381,7 @@ struct cpsw_priv {
>   	u32 emac_port;
>   	struct cpsw_common *cpsw;
>   	int offload_fwd_mark;
> +	u32 tx_packet_min;
>   };
>   
>   #define ndev_to_cpsw(ndev) (((struct cpsw_priv *)netdev_priv(ndev))->cpsw)
> 

-- 
Best regards,
grygorii
