Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C78868FE10
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 04:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232614AbjBIDmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 22:42:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232469AbjBIDml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 22:42:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806F7658D;
        Wed,  8 Feb 2023 19:42:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B130B81FDE;
        Thu,  9 Feb 2023 03:42:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11CEC433EF;
        Thu,  9 Feb 2023 03:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675914157;
        bh=2Zm/cAW7yebiUKLStIpQfsUmcZXWkduQcljqqkFm440=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=atN1uv1SOwX6Hz5OlKN0N3J0eXfzSjNkM//1G3iGGQ9mmwsQ3/u/Iau9/Zo+e9MIO
         5BMWf64MT5gJGnHh43kqV3i9XmeBKKbHuQEiCJQT53oYBk3jjWFveH5sid1VUtled7
         i8DUDhvIVemtnZy/NMm73o8dOIVceOlnzy42wM67hO9pUaQ+AhfhvSexLljnqHgeTr
         E3+6y/DA1DOObbY+MtXchZGFhOfHX27bzRYWNfpfUf7SGd/xsXtvyvShM+I7JI8wn1
         +m6Ah7pD3RVzmEWvTBRUB2EqZzWTbRCM4SMmj2SHM0pZ+HFoH8NEEyEhqZzqTlpn7r
         oOJr3N7HOavcw==
Date:   Wed, 8 Feb 2023 19:42:36 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org
Subject: Re: pull-request: mlx5-next netdev notifier deadlock 2023-02-07
Message-ID: <Y+RrrJUZ9TTvFvLg@x130>
References: <20230208005626.72930-1-saeed@kernel.org>
 <20230208191250.45b23b6f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230208191250.45b23b6f@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08 Feb 19:12, Jakub Kicinski wrote:
>On Tue,  7 Feb 2023 16:56:26 -0800 Saeed Mahameed wrote:
>> @@ -674,6 +675,7 @@ struct mlx5e_resources {
>>  	} hw_objs;
>>  	struct devlink_port dl_port;
>>  	struct net_device *uplink_netdev;
>> +	struct mutex uplink_netdev_lock;
>
>Is this your preferred resolution?
>
>diff --cc include/linux/mlx5/driver.h
>index 91e8160ed087,cc48aa308269..000000000000
>--- a/include/linux/mlx5/driver.h
>+++ b/include/linux/mlx5/driver.h
>@@@ -670,11 -673,11 +671,12 @@@ struct mlx5e_resources
>                u32                        mkey;
>                struct mlx5_sq_bfreg       bfreg;
>        } hw_objs;
>        struct devlink_port dl_port;
>        struct net_device *uplink_netdev;
>+       struct mutex uplink_netdev_lock;
> +      struct mlx5_crypto_dek_priv *dek_priv;

Yes, Perfect, thanks.

