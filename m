Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFEA45351A0
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 17:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346291AbiEZPpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 11:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232621AbiEZPpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 11:45:33 -0400
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64AA6C6E77;
        Thu, 26 May 2022 08:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1653579932; x=1685115932;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CkiHfK8/LMfUY/TQgcX12rRTrkAq3XCsa8+R5XT6JNY=;
  b=AJKzQs/UA0hiqydUfEBRu16IRiw+gKKOyKicS1tFUKvMbqhQ3uJRHxOZ
   NCmd2sEpQx8ePqxpRr1ZkbYxLCTbo5VA9MXiHYtuJR+J98hmid/1zaxYh
   PTCHiUzR6ethF7SFyknaZkSBtgXUHaEHCWxCiyUsOHVtPA6zVFF+71ja3
   o=;
Received: from ironmsg-lv-alpha.qualcomm.com ([10.47.202.13])
  by alexa-out.qualcomm.com with ESMTP; 26 May 2022 08:45:32 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg-lv-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2022 08:45:31 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Thu, 26 May 2022 08:45:31 -0700
Received: from [10.110.93.98] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 26 May
 2022 08:45:30 -0700
Message-ID: <25540c69-c58c-0dc5-29b3-4914a656a06f@quicinc.com>
Date:   Thu, 26 May 2022 08:45:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] ath11k: mhi: fix potential memory leak in
 ath11k_mhi_register()
Content-Language: en-US
To:     Jianglei Nie <niejianglei2021@163.com>, <kvalo@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20220526100227.483609-1-niejianglei2021@163.com>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20220526100227.483609-1-niejianglei2021@163.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/26/2022 3:02 AM, Jianglei Nie wrote:
> mhi_alloc_controller() allocates a memory space for mhi_ctrl. When some
> errors occur, mhi_ctrl should be freed by mhi_free_controller(). But
> when ath11k_mhi_read_addr_from_dt() fails, the function returns without
> calling mhi_free_controller(), which will lead to a memory leak.
> 
> We can fix it by calling mhi_free_controller() when
> ath11k_mhi_read_addr_from_dt() fails.
> 
> Signed-off-by: Jianglei Nie <niejianglei2021@163.com>

Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>

> ---
>   drivers/net/wireless/ath/ath11k/mhi.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/mhi.c b/drivers/net/wireless/ath/ath11k/mhi.c
> index fc3524e83e52..3318c7c2b32b 100644
> --- a/drivers/net/wireless/ath/ath11k/mhi.c
> +++ b/drivers/net/wireless/ath/ath11k/mhi.c
> @@ -376,8 +376,10 @@ int ath11k_mhi_register(struct ath11k_pci *ab_pci)
>   
>   	if (test_bit(ATH11K_FLAG_FIXED_MEM_RGN, &ab->dev_flags)) {
>   		ret = ath11k_mhi_read_addr_from_dt(mhi_ctrl);
> -		if (ret < 0)
> +		if (ret < 0) {
> +			mhi_free_controller(mhi_ctrl);
>   			return ret;
> +		}
>   	} else {
>   		mhi_ctrl->iova_start = 0;
>   		mhi_ctrl->iova_stop = 0xFFFFFFFF;

This patch looks good to me. However there is an additional issue that 
IMO should be addressed in this function with a separate patch.

Just after mhi_ctrl is allocated the pointer is saved:
	ab_pci->mhi_ctrl = mhi_ctrl;

When there is an error, mhi_ctrl is freed, but ab_pci->mhi_ctrl still 
has a dangling pointer to the freed memory. This has the potential to 
result in a subsequent use-after-free or double-free error.

So IMO we should do one of two things (I haven't looked at the code in 
detail to determine which is better):

1) don't set ab_pci->mhi_ctrl = mhi_ctrl until the end of the function 
after success from mhi_register_controller(). This requires that none of 
the functions called between the current assignment point and the 
proposed assignment point dereference ab_pci->mhi_ctrl

2) set ab_pci->mhi_ctrl = NULL in all of the places where we call 
mhi_free_controller()

2a) have a central error exit label and have all of the error conditions 
goto that label where there is a central code:
	mhi_free_controller(mhi_ctrl);
	ab_pci->mhi_ctrl = NULL;
	return ret;

	
