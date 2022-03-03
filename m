Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF48D4CC5D5
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 20:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235885AbiCCTPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 14:15:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235828AbiCCTP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 14:15:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E9A115B99F;
        Thu,  3 Mar 2022 11:14:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D348CB82693;
        Thu,  3 Mar 2022 19:14:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1002AC004E1;
        Thu,  3 Mar 2022 19:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646334880;
        bh=65NU4OmMIt5EFn/vNTZOvIr2kIZ0haZ0h8eEAdsZw8s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CrAUGcfsum5yXJwnDJdL4zllI0l2ylsQSR7U5pCNZe8w5kgnKsF08bzWOVxktO+AP
         96IZy37imHsp+qYWFVm6A2v+Hu7BfOCpM/xsSQ0rLGpCm1VvIlW8QAq8jbupsDCmRM
         qRX/AnILHatxBU9fx7kFIP43wqQ6Q/1KlngSluUam4I++GMKD6HISZ4UoXD8dHlGNC
         Fyqspnfc8YAOa+LecnLTm7owS+UIV5AfkNCBiIjlXJoaqEw8+Drnq3LV9JgYPco3s7
         uNEvfZXnLqux6soIBRzrSrX5VQ7SkTe8zeU2Wl1+OZ/pTCESk41cmMjy4Yt2yDiy3k
         Bvo2g/t8Z1dxg==
Date:   Thu, 3 Mar 2022 21:14:36 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     mst@redhat.com, jasowang@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] vhost: Provide a kernel warning if mutex is held
 whilst clean-up in progress
Message-ID: <YiETnIcfZCLb63oB@unreal>
References: <20220303151929.2505822-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303151929.2505822-1-lee.jones@linaro.org>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 03, 2022 at 03:19:29PM +0000, Lee Jones wrote:
> All workers/users should be halted before any clean-up should take place.
> 
> Suggested-by:  Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/vhost/vhost.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index bbaff6a5e21b8..d935d2506963f 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -693,6 +693,9 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
>  	int i;
>  
>  	for (i = 0; i < dev->nvqs; ++i) {
> +		/* Ideally all workers should be stopped prior to clean-up */
> +		WARN_ON(mutex_is_locked(&dev->vqs[i]->mutex));
> +
>  		mutex_lock(&dev->vqs[i]->mutex);

I know nothing about vhost, but this construction and patch looks
strange to me.

If all workers were stopped, you won't need mutex_lock(). The mutex_lock
here suggests to me that workers can still run here.

Thanks

>  		if (dev->vqs[i]->error_ctx)
>  			eventfd_ctx_put(dev->vqs[i]->error_ctx);
> -- 
> 2.35.1.574.g5d30c73bfb-goog
> 
