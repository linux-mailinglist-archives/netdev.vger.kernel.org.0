Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCAE14D2541
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 02:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbiCIBGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 20:06:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiCIBGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 20:06:08 -0500
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A30FE145E18;
        Tue,  8 Mar 2022 16:45:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1646786722; x=1678322722;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=keyAJb6A5NPJJZZCWIJLthBI4AdiJa40DZ7S3GIHMrU=;
  b=LZkhgbglOnIIedL+zx7HWB8iGr38V54updzBUpfDUDWk0tL2ryH8YhJo
   VjZi1Eq3n9vhxdzXIufTmAEA5mbaRIqimlpBYrjNgpbLxNw6Aw2znMYcF
   Msty4iozTX/XVi+sc7dXfIgdStfsbn+6pctjv3/QPhVW1Ds+VaXf2DhMT
   o=;
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 08 Mar 2022 16:05:12 -0800
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg05-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2022 16:05:11 -0800
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Tue, 8 Mar 2022 16:05:11 -0800
Received: from [10.111.182.121] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15; Tue, 8 Mar 2022
 16:05:10 -0800
Message-ID: <b69308a5-0d29-6b48-833c-f3eacfe03b08@quicinc.com>
Date:   Tue, 8 Mar 2022 16:05:09 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH] ath10k: Fix error handling in ath10k_setup_msa_resources
Content-Language: en-US
To:     Miaoqian Lin <linmq006@gmail.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Rakesh Pillai" <pillair@codeaurora.org>,
        <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20220308070238.19295-1-linmq006@gmail.com>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20220308070238.19295-1-linmq006@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01c.na.qualcomm.com (10.47.97.35) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/7/2022 11:02 PM, Miaoqian Lin wrote:
> The device_node pointer is returned by of_parse_phandle()  with refcount

Kalle, can you fix this nit when you apply?  remove extra space after ()

> incremented. We should use of_node_put() on it when done.
> 
> This function only calls of_node_put() in the regular path.
> And it will cause refcount leak in error path.
> 
> Fixes: 727fec790ead ("ath10k: Setup the msa resources before qmi init")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> ---
>   drivers/net/wireless/ath/ath10k/snoc.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
> index 9513ab696fff..f79dd9a71690 100644
> --- a/drivers/net/wireless/ath/ath10k/snoc.c
> +++ b/drivers/net/wireless/ath/ath10k/snoc.c
> @@ -1556,11 +1556,11 @@ static int ath10k_setup_msa_resources(struct ath10k *ar, u32 msa_size)
>   	node = of_parse_phandle(dev->of_node, "memory-region", 0);
>   	if (node) {
>   		ret = of_address_to_resource(node, 0, &r);
> +		of_node_put(node);
>   		if (ret) {
>   			dev_err(dev, "failed to resolve msa fixed region\n");
>   			return ret;
>   		}
> -		of_node_put(node);
>   
>   		ar->msa.paddr = r.start;
>   		ar->msa.mem_size = resource_size(&r);

Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
