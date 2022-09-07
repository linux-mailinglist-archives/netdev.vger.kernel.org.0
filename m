Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 546935B0DCA
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 22:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiIGUKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 16:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiIGUKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 16:10:36 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD284B0CA;
        Wed,  7 Sep 2022 13:10:34 -0700 (PDT)
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 287JPikM020414;
        Wed, 7 Sep 2022 20:10:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=yedWkv7HGNs+6IaOUivXiRQDrH8fSJ4sZlLG8ADqlVM=;
 b=NyTLWGvdstJi2F5NcqgjD12+8dbbwAFVSiB+wppkAg/r6LJbGRVZTWA4KU1ectNmIYHA
 fPZM2RJ5NliLjZjsEZkIu+0PYJEQ3VyAqKFa8oeA0WurgWE5IBct/uAkq6/rC2E5VbY4
 5z0wtW4Af4HKBNQtJs6rprHo8rkCWls9hWaEEv0Z+X6RpGpiLKSBycb6EMnTaYtB58ml
 R3ZCyylGYnmfF3FQ1t5gRAcb440qfOBjpgH+iAT8+ultU2YOmSf6NkO+1OFcmGBL8nBf
 Hkntv0kacdXF6O0BYWaJ8P9AKMujQteJscTs9Bi301txG6QP1/hKku5BIFjuN591D4Dz Lw== 
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3jefntbrh4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Sep 2022 20:10:16 +0000
Received: from pps.filterd (NALASPPMTA03.qualcomm.com [127.0.0.1])
        by NALASPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 287KAFIC019061;
        Wed, 7 Sep 2022 20:10:15 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NALASPPMTA03.qualcomm.com (PPS) with ESMTPS id 3jc00ks9fu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Sep 2022 20:10:15 +0000
Received: from NALASPPMTA03.qualcomm.com (NALASPPMTA03.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 287KAFr6019055;
        Wed, 7 Sep 2022 20:10:15 GMT
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA03.qualcomm.com (PPS) with ESMTPS id 287KAFkM019054
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Sep 2022 20:10:15 +0000
Received: from [10.110.17.89] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 7 Sep 2022
 13:10:14 -0700
Message-ID: <48963728-67bd-ace8-68fd-f840a2e65873@quicinc.com>
Date:   Wed, 7 Sep 2022 13:10:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] ath11k: mhi: fix potential memory leak in
 ath11k_mhi_register()
Content-Language: en-US
To:     Jianglei Nie <niejianglei2021@163.com>, <kvalo@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20220907073704.58806-1-niejianglei2021@163.com>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20220907073704.58806-1-niejianglei2021@163.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: CnN1FS8Pc7O4IBn7CX-Lkx1G7Vopqu7V
X-Proofpoint-GUID: CnN1FS8Pc7O4IBn7CX-Lkx1G7Vopqu7V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-07_10,2022-09-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 adultscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=791
 lowpriorityscore=0 phishscore=0 mlxscore=0 bulkscore=0 clxscore=1011
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209070075
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/7/2022 12:37 AM, Jianglei Nie wrote:
> mhi_alloc_controller() allocates a memory space for mhi_ctrl. When gets
> some error, mhi_ctrl should be freed with mhi_free_controller(). But
> when ath11k_mhi_read_addr_from_dt() fails, the function returns without
> calling mhi_free_controller(), which will lead to a memory leak.
> 
> We can fix it by calling mhi_free_controller() when
> ath11k_mhi_read_addr_from_dt() fails.
> 
> Signed-off-by: Jianglei Nie <niejianglei2021@163.com>

I believe this should have been annotated as -v2 to the following:
<https://lore.kernel.org/ath11k/20220526100227.483609-1-niejianglei2021@163.com/>

Please properly annotate follow-up patches.

Also please add wifi: to the beginning of the subject prefix


> ---
>   drivers/net/wireless/ath/ath11k/mhi.c | 17 ++++++++++-------
>   1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/mhi.c b/drivers/net/wireless/ath/ath11k/mhi.c
> index c44df17719f6..86995e8dc913 100644
> --- a/drivers/net/wireless/ath/ath11k/mhi.c
> +++ b/drivers/net/wireless/ath/ath11k/mhi.c
> @@ -402,8 +402,7 @@ int ath11k_mhi_register(struct ath11k_pci *ab_pci)
>   	ret = ath11k_mhi_get_msi(ab_pci);
>   	if (ret) {
>   		ath11k_err(ab, "failed to get msi for mhi\n");
> -		mhi_free_controller(mhi_ctrl);
> -		return ret;
> +		goto free_controller;
>   	}
>   
>   	if (!test_bit(ATH11K_FLAG_MULTI_MSI_VECTORS, &ab->dev_flags))
> @@ -412,7 +411,7 @@ int ath11k_mhi_register(struct ath11k_pci *ab_pci)
>   	if (test_bit(ATH11K_FLAG_FIXED_MEM_RGN, &ab->dev_flags)) {
>   		ret = ath11k_mhi_read_addr_from_dt(mhi_ctrl);
>   		if (ret < 0)
> -			return ret;
> +			goto free_controller;
>   	} else {
>   		mhi_ctrl->iova_start = 0;
>   		mhi_ctrl->iova_stop = 0xFFFFFFFF;
> @@ -440,18 +439,22 @@ int ath11k_mhi_register(struct ath11k_pci *ab_pci)
>   	default:
>   		ath11k_err(ab, "failed assign mhi_config for unknown hw rev %d\n",
>   			   ab->hw_rev);
> -		mhi_free_controller(mhi_ctrl);
> -		return -EINVAL;
> +		ret = -EINVAL;
> +		goto free_controller;
>   	}
>   
>   	ret = mhi_register_controller(mhi_ctrl, ath11k_mhi_config);
>   	if (ret) {
>   		ath11k_err(ab, "failed to register to mhi bus, err = %d\n", ret);
> -		mhi_free_controller(mhi_ctrl);
> -		return ret;
> +		goto free_controller;
>   	}
>   
>   	return 0;
> +
> +free_controller:
> +	mhi_free_controller(mhi_ctrl);
> +	ab_pci->mhi_ctrl = NULL;
> +	return ret;
>   }
>   
>   void ath11k_mhi_unregister(struct ath11k_pci *ab_pci)

Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>

