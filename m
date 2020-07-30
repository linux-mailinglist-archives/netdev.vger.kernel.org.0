Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0872232F67
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 11:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbgG3JUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 05:20:12 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:60566 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbgG3JUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 05:20:12 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06U9JWfX096146;
        Thu, 30 Jul 2020 04:19:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1596100772;
        bh=uKkUsmG2TWjx3CupcPmRcRE27qblPy15NR/q//m5jTo=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=vkgowGj1yTz/V87cPcUYccl8he6DnrEcFbOOS3DXsK0UO2fl+5fElIQL4sa+FNsOL
         lEtfZffzX9pdfiym2ArHc9uOAr3wdL9nUyBMyUUmVpbvrv0m5pz8lyQFHEDUnDBUxL
         5HnJuzc+gBKyAiHirLW8jCN1bbJ1o4oDxova9e/k=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 06U9JWnN022060
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 30 Jul 2020 04:19:32 -0500
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 30
 Jul 2020 04:19:31 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 30 Jul 2020 04:19:31 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06U9JR0V108790;
        Thu, 30 Jul 2020 04:19:28 -0500
Subject: Re: [PATCH v3 5/9] ethernet: ti: am65-cpts: Use generic helper
 function
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, <netdev@vger.kernel.org>,
        Petr Machata <petrm@mellanox.com>
References: <20200730080048.32553-1-kurt@linutronix.de>
 <20200730080048.32553-6-kurt@linutronix.de>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <9e18a305-fbb9-f4da-cf73-65a16bdceb12@ti.com>
Date:   Thu, 30 Jul 2020 12:19:19 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200730080048.32553-6-kurt@linutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 30/07/2020 11:00, Kurt Kanzenbach wrote:
> In order to reduce code duplication between ptp drivers, generic helper
> functions were introduced. Use them.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
>   drivers/net/ethernet/ti/am65-cpts.c | 37 +++++++----------------------
>   1 file changed, 9 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ti/am65-cpts.c b/drivers/net/ethernet/ti/am65-cpts.c
> index c59a289e428c..2548324afa42 100644
> --- a/drivers/net/ethernet/ti/am65-cpts.c
> +++ b/drivers/net/ethernet/ti/am65-cpts.c
> @@ -748,42 +748,23 @@ EXPORT_SYMBOL_GPL(am65_cpts_rx_enable);
>   static int am65_skb_get_mtype_seqid(struct sk_buff *skb, u32 *mtype_seqid)
>   {
>   	unsigned int ptp_class = ptp_classify_raw(skb);
> -	u8 *msgtype, *data = skb->data;
> -	unsigned int offset = 0;
> -	__be16 *seqid;
> +	struct ptp_header *hdr;
> +	u8 msgtype;
> +	u16 seqid;
>   
>   	if (ptp_class == PTP_CLASS_NONE)
>   		return 0;
>   
> -	if (ptp_class & PTP_CLASS_VLAN)
> -		offset += VLAN_HLEN;
> -
> -	switch (ptp_class & PTP_CLASS_PMASK) {
> -	case PTP_CLASS_IPV4:
> -		offset += ETH_HLEN + IPV4_HLEN(data + offset) + UDP_HLEN;
> -		break;
> -	case PTP_CLASS_IPV6:
> -		offset += ETH_HLEN + IP6_HLEN + UDP_HLEN;
> -		break;
> -	case PTP_CLASS_L2:
> -		offset += ETH_HLEN;
> -		break;
> -	default:
> -		return 0;
> -	}
> -
> -	if (skb->len + ETH_HLEN < offset + OFF_PTP_SEQUENCE_ID + sizeof(*seqid))
> +	hdr = ptp_parse_header(skb, ptp_class);
> +	if (!hdr)
>   		return 0;
>   
> -	if (unlikely(ptp_class & PTP_CLASS_V1))
> -		msgtype = data + offset + OFF_PTP_CONTROL;
> -	else
> -		msgtype = data + offset;
> +	msgtype = ptp_get_msgtype(hdr, ptp_class);
> +	seqid	= be16_to_cpu(hdr->sequence_id);

Is there any reason to not use "ntohs()"?

>   
> -	seqid = (__be16 *)(data + offset + OFF_PTP_SEQUENCE_ID);
> -	*mtype_seqid = (*msgtype << AM65_CPTS_EVENT_1_MESSAGE_TYPE_SHIFT) &
> +	*mtype_seqid  = (msgtype << AM65_CPTS_EVENT_1_MESSAGE_TYPE_SHIFT) &
>   			AM65_CPTS_EVENT_1_MESSAGE_TYPE_MASK;
> -	*mtype_seqid |= (ntohs(*seqid) & AM65_CPTS_EVENT_1_SEQUENCE_ID_MASK);
> +	*mtype_seqid |= (seqid & AM65_CPTS_EVENT_1_SEQUENCE_ID_MASK);
>   
>   	return 1;
>   }
> 

I'll try to test it today.
Thank you.

-- 
Best regards,
grygorii
