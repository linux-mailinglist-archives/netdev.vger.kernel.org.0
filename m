Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 701342B7EF8
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 15:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgKRODA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 09:03:00 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:6274 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726314AbgKROC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 09:02:59 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AIDtMt3001960;
        Wed, 18 Nov 2020 06:02:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=bx28MF67ydm6urk3+US1ozUYBRS48wFhe2AS/xUaCgg=;
 b=S7VNTYgRx5OTOiewdlCthlQU/c3s9ikrErqBjzd526KpOELhXTKS7OdPYLvtIQN7LlAZ
 /GHBXRO4qcYfiqCydzR/EjJ0mmZxsIiFqisxvwlzXPbJQZncdnT/T04sqtdPN1g8/LjN
 oY/vYbc2CaKLA9eqsJpMWO27QZKavopJGshpNvxOKS9JI8tcOizxGTBBUMTANxVpc6J1
 j0UfksWXiEvN1QSAhmCI6sHyDgF+8U6NouqS3WkrVaFrwosJzj1nfBO2V0sLcHTCPrNf
 E+X5UfrzOh8g4+7b7Qlw6QlnSkEt7ydSHG2V7XaCQkZM6oX92/NZ5q2QS8vmDXKGfuuA kA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 34tfmsnmfp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 06:02:54 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Nov
 2020 06:02:52 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Nov
 2020 06:02:52 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 18 Nov 2020 06:02:52 -0800
Received: from [10.193.39.169] (NN-LT0019.marvell.com [10.193.39.169])
        by maili.marvell.com (Postfix) with ESMTP id 4E6E93F703F;
        Wed, 18 Nov 2020 06:02:50 -0800 (PST)
Subject: Re: [EXT] [PATCH] aquantia: Reserve space when allocating an SKB
To:     "Ramsay, Lincoln" <Lincoln.Ramsay@digi.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
References: <CY4PR1001MB23118EE23F7F5196817B8B2EE8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <2b392026-c077-2871-3492-eb5ddd582422@marvell.com>
Date:   Wed, 18 Nov 2020 17:02:49 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:83.0) Gecko/20100101
 Thunderbird/83.0
MIME-Version: 1.0
In-Reply-To: <CY4PR1001MB23118EE23F7F5196817B8B2EE8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-18_04:2020-11-17,2020-11-18 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Ramsay,


> When performing IPv6 forwarding, there is an expectation that SKBs
> will have some headroom. When forwarding a packet from the aquantia
> driver, this does not always happen, triggering a kernel warning.
> 
> It was observed that napi_alloc_skb and other ethernet drivers
> reserve (NET_SKB_PAD + NET_IP_ALIGN) bytes in new SKBs. Do this
> when calling build_skb as well.

Thanks for the analysis, but I think the solution you propose is invalid.


> After much hunting and debugging, I think I have figured out the issue
> here.
> 
> aq_ring.c has this code (edited slightly for brevity):
> 
> if (buff->is_eop && buff->len <= AQ_CFG_RX_FRAME_MAX - AQ_SKB_ALIGN) {
>     skb = build_skb(aq_buf_vaddr(&buff->rxdata), AQ_CFG_RX_FRAME_MAX);
>     skb_put(skb, buff->len);
> } else {
>     skb = napi_alloc_skb(napi, AQ_CFG_RX_HDR_SIZE);
> 
> There is a significant difference between the SKB produced by these 2 code
> paths. When napi_alloc_skb creates an SKB, there is a certain amount of
> headroom reserved. The same pattern appears to be used in all of the other
> ethernet drivers I have looked at. However, this is not done in the
> build_skb codepath.

...

> -	rxpage->pg_off = 0;
> +	rxpage->pg_off = AQ_SKB_PAD;
> 
>  	return 0;
> 
> @@ -67,8 +69,8 @@ static int aq_get_rxpages(struct aq_ring_s *self, struct
> aq_ring_buff_s *rxbuf,
>  		/* One means ring is the only user and can reuse */
>  		if (page_ref_count(rxbuf->rxdata.page) > 1) {
>  			/* Try reuse buffer */
> -			rxbuf->rxdata.pg_off += AQ_CFG_RX_FRAME_MAX;
> -			if (rxbuf->rxdata.pg_off + AQ_CFG_RX_FRAME_MAX <=
> +			rxbuf->rxdata.pg_off += AQ_CFG_RX_FRAME_MAX +
> AQ_SKB_PAD;
> +			if (rxbuf->rxdata.pg_off + AQ_CFG_RX_FRAME_MAX +
> AQ_SKB_PAD <=
>  				(PAGE_SIZE << order)) {


Here I understand your intention. You are trying to "offset" the placement of
the packet data, and the restore it back when construction SKB.

The problem however is that hardware is being programmed with fixed descriptor
size for placement. And its equal to AQ_CFG_RX_FRAME_MAX (2K by default).

This means, HW will do writes of up to 2K packet data into a single
descriptor, and then (if not enough), will go for next descriptor data.

With your solution, packets of size (AQ_CFG_RX_FRAME_MAX - AQ_SKB_PAD) up to
size of AQ_CFG_RX_FRAME_MAX will overwrite the area of page they designated
to. Ultimately, HW will do a memory corruption of next page.

The limitation here is we can't tell HW on granularity less than 1K.

I think the only acceptable solution here would be removing that optimized
path of build_skb, and keep only napi_alloc_skb. Or, we can think of keeping
it under some configuration condition (which is also not good).

So far I can't imagine any other good solution.

HW supports also a header split - this could be used to follow the optimized
path, but thats not an easy thing to implement.

Regards,
  Igor
