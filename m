Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE667589E25
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 17:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236180AbiHDPE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 11:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234233AbiHDPE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 11:04:57 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC35A52FF0;
        Thu,  4 Aug 2022 08:04:56 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id bv3so11684864wrb.5;
        Thu, 04 Aug 2022 08:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OZAZOQcdiy06Yu4+hpKMxOPIygFLJTFjIVoiVQXoqPg=;
        b=WTh0kQtEjcHi8EkyWYns+g/En+cpMJ96AAgg/8oZnNNvn6vKr8vbE7BQUG4BMHqn8s
         P0KE9+af+/hQyP9cobiSU4F099+NOt1pDVQN1Gd0/f0ZKiY+AJSKZvnyJNFpYlS+RySN
         ev/KJaYyhhgSCTZPb2mnVTfj5nCe/E1/viKsaBLy+afXVLAzitj+l0IpohNLdvfzQnci
         B8MxzgloY3Mmk22njhjN9Y7ZG7qPJ70Dih7Y00Wb1PiKg6u3eq0r4TqC76lgx1S/gGE2
         ZAYVh4bKPOzu2TgsW7zcRvRlRRbjMhiaoTHsnvsY2NDB6S2CqCoDHD6tfijhv+gg/KR4
         04Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OZAZOQcdiy06Yu4+hpKMxOPIygFLJTFjIVoiVQXoqPg=;
        b=otHlajnWlDqqcWjeBvR8hGu3Tw2pl4tjEgYRJl1nCwVCqMArCrsUS9ujMHoK4vyrOM
         aHnacTQ1lUXm4WlmLfpmVTS5m/wzxU/HXrDp2GhE+LZgxPMUOqXY0xEC6pTA/wETMo4a
         u0cIz3LFN/iVOlQaCSjluwXX5+5o1lE0eN0Lo9kO8gjsSS5Blkh9b0Je/6NVLZq1JuQF
         Qr/5HFeyRH0V9YhXoEeBfltM5hXk90b5xSN9H6oswYHsb94q7uFW/wACKygywVCj+JTY
         gxOmeyP0OQCPPm96bmZTWhmkG7Hrkyyz2v9PfwAxbApZd9LHN8jxco7yZP32ne7uMB8R
         DHFQ==
X-Gm-Message-State: ACgBeo2NCTrQ2aMgmBmD7l5WK7i/RWhYO8npfSs3W/5frJGrOMOjiNjb
        121E4MDjVSMDg7RFMy016/8=
X-Google-Smtp-Source: AA6agR6AaMAMV9vkpJOZDZRNryZnnCoaw9cLMQ0voxVvZUZDOCqzSljA35sUZ1JXqmLdSo7cksOsqA==
X-Received: by 2002:a05:6000:1863:b0:220:6d5f:deb5 with SMTP id d3-20020a056000186300b002206d5fdeb5mr1656018wri.470.1659625495139;
        Thu, 04 Aug 2022 08:04:55 -0700 (PDT)
Received: from [192.168.0.104] ([77.126.166.31])
        by smtp.gmail.com with ESMTPSA id b6-20020a5d6346000000b0022063e5228bsm1385790wrw.93.2022.08.04.08.04.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Aug 2022 08:04:54 -0700 (PDT)
Message-ID: <2e33b89a-5387-e68c-a0fb-dec2c54f87e2@gmail.com>
Date:   Thu, 4 Aug 2022 18:04:52 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net] net/mlx5e: Fix use after free in mlx5e_fs_init()
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Lama Kayal <lkayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
References: <YuvbCRstoxopHi4n@kili>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <YuvbCRstoxopHi4n@kili>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/4/2022 5:43 PM, Dan Carpenter wrote:
> Call mlx5e_fs_vlan_free(fs) before kvfree(fs).
> 
> Fixes: af8bbf730068 ("net/mlx5e: Convert mlx5e_flow_steering member of mlx5e_priv to pointer")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> This applies to net but I never really understand how mellanox patches
> work...
> 

Hi Dan,
This patch belongs to next kernel (6.0).
It seems that net-next (or parts of it) is already merged into net as 
we're in the merge window.


>   drivers/net/ethernet/mellanox/mlx5/core/en_fs.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
> index e2a9b9be5c1f..e0ce5a233d0b 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
> @@ -1395,10 +1395,11 @@ struct mlx5e_flow_steering *mlx5e_fs_init(const struct mlx5e_profile *profile,
>   	}
>   
>   	return fs;
> -err_free_fs:
> -	kvfree(fs);
> +
>   err_free_vlan:
>   	mlx5e_fs_vlan_free(fs);
> +err_free_fs:
> +	kvfree(fs);
>   err:
>   	return NULL;
>   }

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks for your patch!
