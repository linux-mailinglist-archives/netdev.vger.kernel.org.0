Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C39F6CB07A
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 23:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbjC0VQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 17:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjC0VQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 17:16:40 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668BD1707;
        Mon, 27 Mar 2023 14:16:39 -0700 (PDT)
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32RLGKch015997;
        Mon, 27 Mar 2023 21:16:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=date : from : to :
 cc : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=qcppdkim1; bh=8lYqf1wwT4U4CScuSUdJtIieuPVZBNV4dkYQrO8RUEo=;
 b=ECXwiz/O3lBr/Y2Y31F2wTs857wa0cANJqjaJHmcGin24w9q0GfaE+GwOChTSAxAq4mn
 tUjYzD60giPiwEbKtzPuxG4qd4yMdpP/9mgRl2smSLtD+mYQkiV8FDCCQh3Oz7XdM2oP
 T+bHeS+W9/e6jwlZv0tN2qdeMZLoIJ5bK3CVXegm6INdDak44ENNVjMaWF2TF8/hRtP3
 wNYcTUkuLhtsE1bzNPxY8SlHfkkSFXhOc0nGQ5dzR14KsXyw1eHGYkCqLncgSAeseDjb
 4TpLDWC3q2t+MRd0lTuvtOUAscknr2Bm8Ehy1poIdo2pobGQBiQaziYm77c9l3UogIVS 8A== 
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3pkby494ev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Mar 2023 21:16:30 +0000
Received: from nalasex01c.na.qualcomm.com (nalasex01c.na.qualcomm.com [10.47.97.35])
        by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 32RLGT2f025880
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Mar 2023 21:16:29 GMT
Received: from hu-bjorande-lv.qualcomm.com (10.49.16.6) by
 nalasex01c.na.qualcomm.com (10.47.97.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Mon, 27 Mar 2023 14:16:28 -0700
Date:   Mon, 27 Mar 2023 14:16:27 -0700
From:   Bjorn Andersson <quic_bjorande@quicinc.com>
To:     Alex Elder <elder@linaro.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <caleb.connolly@linaro.org>,
        <mka@chromium.org>, <evgreen@chromium.org>, <andersson@kernel.org>,
        <quic_cpratapa@quicinc.com>, <quic_avuyyuru@quicinc.com>,
        <quic_jponduru@quicinc.com>, <quic_subashab@quicinc.com>,
        <elder@kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: ipa: compute DMA pool size properly
Message-ID: <20230327211627.GA3248042@hu-bjorande-lv.qualcomm.com>
References: <20230326165223.2707557-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230326165223.2707557-1-elder@linaro.org>
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nalasex01c.na.qualcomm.com (10.47.97.35)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: _GmPASFlWHEOA8kH8S3SbEfFlCH0un73
X-Proofpoint-GUID: _GmPASFlWHEOA8kH8S3SbEfFlCH0un73
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-27_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 lowpriorityscore=0 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0
 impostorscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303270173
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 26, 2023 at 11:52:23AM -0500, Alex Elder wrote:
> In gsi_trans_pool_init_dma(), the total size of a pool of memory
> used for DMA transactions is calculated.  However the calculation is
> done incorrectly.
> 
> For 4KB pages, this total size is currently always more than one
> page, and as a result, the calculation produces a positive (though
> incorrect) total size.  The code still works in this case; we just
> end up with fewer DMA pool entries than we intended.
> 
> Bjorn Andersson tested booting a kernel with 16KB pages, and hit a
> null pointer derereference in sg_alloc_append_table_from_pages(),
> descending from gsi_trans_pool_init_dma().  The cause of this was
> that a 16KB total size was going to be allocated, and with 16KB
> pages the order of that allocation is 0.  The total_size calculation
> yielded 0, which eventually led to the crash.
> 
> Correcting the total_size calculation fixes the problem.
> 
> Reported-by: <quic_bjorande@quicinc.com>
> Tested-by: <quic_bjorande@quicinc.com>

It would be nice to add "Bjorn Andersson" to these two.

Regards,
Bjorn

> Fixes: 9dd441e4ed57 ("soc: qcom: ipa: GSI transactions")
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  drivers/net/ipa/gsi_trans.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
> index 0f52c068c46d6..ee6fb00b71eb6 100644
> --- a/drivers/net/ipa/gsi_trans.c
> +++ b/drivers/net/ipa/gsi_trans.c
> @@ -156,7 +156,7 @@ int gsi_trans_pool_init_dma(struct device *dev, struct gsi_trans_pool *pool,
>  	 * gsi_trans_pool_exit_dma() can assume the total allocated
>  	 * size is exactly (count * size).
>  	 */
> -	total_size = get_order(total_size) << PAGE_SHIFT;
> +	total_size = PAGE_SIZE << get_order(total_size);
>  
>  	virt = dma_alloc_coherent(dev, total_size, &addr, GFP_KERNEL);
>  	if (!virt)
> -- 
> 2.34.1
> 
