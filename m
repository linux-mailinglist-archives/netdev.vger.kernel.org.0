Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 800B1621CDB
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 20:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiKHTSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 14:18:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbiKHTSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 14:18:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18CE3109B;
        Tue,  8 Nov 2022 11:18:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82BB1B81C1E;
        Tue,  8 Nov 2022 19:18:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13EEC433C1;
        Tue,  8 Nov 2022 19:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667935100;
        bh=Zranr7iyznyU/9gl8EjHHvex4h6tuR5Swpjv1QcEnso=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AzqbKw2F0vRoDcS7+ji4s5t8hP7E541dC286tReM6+RH73T8/4nnIHUBha0G0YxVN
         q71Fd7FK+LFZPdokyRLPY0nZ7pv9CSbyiF0Z6LskZET2FBE2ABO4yfrNsCuBDtGpTk
         bDrO45rWtxkjEWfUP9eRjz1ujdAd8GBf/+SyYFbiiwLV5jo5QGEbqigvqvToJVJRdS
         Ru5xDKEhH9CrjKwWNAQHeZj+g7DoCWus4AeIK0PSbmxzVBjp6JruEBi1u1aGP2xDnz
         5Z2UOD8k4PQyh6i6sMfJ4FiF+S8Z+xwgsJQN3SUjDVC3bFr81bcq2FIq1YPsC6ZhNc
         NPrzMkbuF725g==
Date:   Tue, 8 Nov 2022 21:18:15 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     longli@microsoft.com
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, edumazet@google.com,
        shiraz.saleem@intel.com, Ajay Sharma <sharmaajay@microsoft.com>,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [Patch v10 01/12] net: mana: Add support for auxiliary device
Message-ID: <Y2qrd/BbrZUokitA@unreal>
References: <1667502990-2559-1-git-send-email-longli@linuxonhyperv.com>
 <1667502990-2559-2-git-send-email-longli@linuxonhyperv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1667502990-2559-2-git-send-email-longli@linuxonhyperv.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 03, 2022 at 12:16:19PM -0700, longli@linuxonhyperv.com wrote:
> From: Long Li <longli@microsoft.com>
> 
> In preparation for supporting MANA RDMA driver, add support for auxiliary
> device in the Ethernet driver. The RDMA device is modeled as an auxiliary
> device to the Ethernet device.
> 
> Reviewed-by: Dexuan Cui <decui@microsoft.com>
> Signed-off-by: Long Li <longli@microsoft.com>
> Acked-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
> Change log:
> v3: define mana_adev_idx_alloc and mana_adev_idx_free as static
> v7: fix a bug that may assign a negative value to adev->id

<...>

>  int mana_probe(struct gdma_dev *gd, bool resuming)
>  {
>  	struct gdma_context *gc = gd->gdma_context;
> @@ -2173,6 +2249,8 @@ int mana_probe(struct gdma_dev *gd, bool resuming)
>  				break;
>  		}
>  	}
> +
> +	err = add_adev(gd);
>  out:
>  	if (err)
>  		mana_remove(gd, false);
> @@ -2189,6 +2267,10 @@ void mana_remove(struct gdma_dev *gd, bool suspending)
>  	int err;
>  	int i;
>  
> +	/* adev currently doesn't support suspending, always remove it */
> +	if (gd->adev)

This condition is always true, isn't it?

> +		remove_adev(gd);
> +

Thanks
