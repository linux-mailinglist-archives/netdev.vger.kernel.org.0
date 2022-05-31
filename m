Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFC4539908
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 23:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348210AbiEaVve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 17:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348184AbiEaVva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 17:51:30 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5DC994C0;
        Tue, 31 May 2022 14:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1654033889; x=1685569889;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ADSONrRrcYWIBItW/IDoJda+KltF0U2bPCMO56q/27Q=;
  b=axl+sUbBgmnRpbpXqj9aJDIgDauyAg1hPJY9dezI/Kn+ifUv8OJYfXB8
   8GRfqeViLsUUuf8K7wI+OP4hXJSSahTLChgEUEUSul5d9DLGoy+FwejVg
   4MGvd5hSXBoG8a7kGMfQ8ZLCEc8DL5iiYDa4thJE3KWvjjel50/bq6Xd9
   w=;
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 31 May 2022 14:51:29 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg02-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 14:51:28 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 31 May 2022 14:51:28 -0700
Received: from [10.110.67.112] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 31 May
 2022 14:51:26 -0700
Message-ID: <bbc9d5c1-6b05-4e8a-3141-ffdb23e586be@quicinc.com>
Date:   Tue, 31 May 2022 14:51:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v2] ath11k: mhi: fix potential memory leak in
 ath11k_mhi_register()
Content-Language: en-US
To:     Jianglei Nie <niejianglei2021@163.com>, <kvalo@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20220530080610.143925-1-niejianglei2021@163.com>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20220530080610.143925-1-niejianglei2021@163.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/30/2022 1:06 AM, Jianglei Nie wrote:
> mhi_alloc_controller() allocates a memory space for mhi_ctrl. When some
> errors occur, mhi_ctrl should be freed by mhi_free_controller() and set
> ab_pci->mhi_ctrl = NULL because ab_pci->mhi_ctrl has a dangling pointer
> to the freed memory. But when ath11k_mhi_read_addr_from_dt() fails, the
> function returns without calling mhi_free_controller(), which will lead
> to a memory leak.
> 
> We can fix it by calling mhi_free_controller() when
> ath11k_mhi_read_addr_from_dt() fails and set ab_pci->mhi_ctrl = NULL in
> all of the places where we call mhi_free_controller().
> 
> Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
> ---
>   drivers/net/wireless/ath/ath11k/mhi.c | 17 ++++++++++-------
>   1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/mhi.c b/drivers/net/wireless/ath/ath11k/mhi.c
> index fc3524e83e52..fc1bbf91c58e 100644
> --- a/drivers/net/wireless/ath/ath11k/mhi.c
> +++ b/drivers/net/wireless/ath/ath11k/mhi.c
> @@ -367,8 +367,7 @@ int ath11k_mhi_register(struct ath11k_pci *ab_pci)
>   	ret = ath11k_mhi_get_msi(ab_pci);
>   	if (ret) {
>   		ath11k_err(ab, "failed to get msi for mhi\n");
> -		mhi_free_controller(mhi_ctrl);
> -		return ret;
> +		goto free_controller;
>   	}
>   
>   	if (!test_bit(ATH11K_PCI_FLAG_MULTI_MSI_VECTORS, &ab_pci->flags))
> @@ -377,7 +376,7 @@ int ath11k_mhi_register(struct ath11k_pci *ab_pci)
>   	if (test_bit(ATH11K_FLAG_FIXED_MEM_RGN, &ab->dev_flags)) {
>   		ret = ath11k_mhi_read_addr_from_dt(mhi_ctrl);
>   		if (ret < 0)
> -			return ret;
> +			goto free_controller;
>   	} else {
>   		mhi_ctrl->iova_start = 0;
>   		mhi_ctrl->iova_stop = 0xFFFFFFFF;
> @@ -405,18 +404,22 @@ int ath11k_mhi_register(struct ath11k_pci *ab_pci)
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

LGTM, thanks

Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>

