Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEB42699499
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 13:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjBPMnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 07:43:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbjBPMmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 07:42:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62027128
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 04:42:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21DD0B82730
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 12:42:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E548C433D2;
        Thu, 16 Feb 2023 12:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676551365;
        bh=3aOT8nW/iiMdM2z43BPnXQhuASlbLEnUe9hq+x3sfcg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p6HC60XT2tXjfMQutwnybW/iXalRsWS13EFkSzj6KawHvaVrAsYxODdfsUkaXKcet
         VumyNs6lofy69RdLlFKBItICSDUllDLBIy9BiZ/NtcZFJITSv/J+YvxB1mduZq1uCZ
         tyWIkFqAb5AwD7x2hi95Y3XwzzPaqMrbfL5rRAcXa56+12syIGvG437Ul2LLC44ufs
         x1Rr9yjdorE+ZJ67lx7tVHlWZTpSkv7tfRQj911GU2y6LqYS3WyN9r7I8h97xxmZ3r
         sF0lRbAkyNLBl/nCJ6TVSOO6gYjl2WfIaevfKTa8bUpRXp7O1thJITZjojj5ZcxvKF
         TrnILQKM+zc0g==
Date:   Thu, 16 Feb 2023 14:42:41 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     "Temerkhanov, Sergey" <sergey.temerkhanov@intel.com>
Cc:     netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH net-next] auxiliary: Implement refcounting
Message-ID: <Y+4kwf3SRq5NBzBz@unreal>
References: <20230216121621.37063-1-sergey.temerkhanov@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230216121621.37063-1-sergey.temerkhanov@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ Greg KH

On Thu, Feb 16, 2023 at 01:16:21PM +0100, Temerkhanov, Sergey wrote:
> From: Sergey Temerkhanov <sergey.temerkhanov@intel.com>
> 
> Implement reference counting to make it possible to synchronize
> deinitialization and removal of interfaces published via aux bus
> with the client modules.
> Reference counting can be used in both sleeping and non-sleeping
> contexts so this approach is intended to replace device_lock()
> (mutex acquisition) with an additional lock on top of it
> which is not always possible to take in client code.

I want to see this patch as part of your client code series.
It is unclear why same aux device is used from different drivers.

Otherwise, this whole refcnt is useless and just hides bugs in driver
which accesses released devices.

> 
> Signed-off-by: Sergey Temerkhanov <sergey.temerkhanov@intel.com>
> ---
>  drivers/base/auxiliary.c      | 18 ++++++++++++++++++
>  include/linux/auxiliary_bus.h | 34 +++++++++++++++++++++++++---------
>  2 files changed, 43 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/base/auxiliary.c b/drivers/base/auxiliary.c
> index 8c5e65930617..082b3ebd143d 100644
> --- a/drivers/base/auxiliary.c
> +++ b/drivers/base/auxiliary.c
> @@ -287,10 +287,28 @@ int auxiliary_device_init(struct auxiliary_device *auxdev)
>  
>  	dev->bus = &auxiliary_bus_type;
>  	device_initialize(&auxdev->dev);
> +	init_waitqueue_head(&auxdev->wq_head);
> +	refcount_set(&auxdev->refcnt, 1);
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(auxiliary_device_init);
>  
> +void auxiliary_device_uninit(struct auxiliary_device *auxdev)
> +{
> +	wait_event_interruptible(auxdev->wq_head,
> +				 refcount_dec_if_one(&auxdev->refcnt));
> +}
> +EXPORT_SYMBOL_GPL(auxiliary_device_uninit);
> +
> +void auxiliary_device_delete(struct auxiliary_device *auxdev)
> +{
> +	WARN_ON(refcount_read(&auxdev->refcnt));
> +
> +	device_del(&auxdev->dev);
> +}
> +EXPORT_SYMBOL_GPL(auxiliary_device_delete);
> +
>  /**
>   * __auxiliary_device_add - add an auxiliary bus device
>   * @auxdev: auxiliary bus device to add to the bus
> diff --git a/include/linux/auxiliary_bus.h b/include/linux/auxiliary_bus.h
> index de21d9d24a95..0610ccee320e 100644
> --- a/include/linux/auxiliary_bus.h
> +++ b/include/linux/auxiliary_bus.h
> @@ -10,6 +10,8 @@
>  
>  #include <linux/device.h>
>  #include <linux/mod_devicetable.h>
> +#include <linux/wait.h>
> +#include <linux/refcount.h>
>  
>  /**
>   * DOC: DEVICE_LIFESPAN
> @@ -137,7 +139,9 @@
>   */
>  struct auxiliary_device {
>  	struct device dev;
> +	refcount_t refcnt;
>  	const char *name;
> +	struct wait_queue_head wq_head;
>  	u32 id;
>  };
>  
> @@ -198,6 +202,25 @@ static inline void auxiliary_set_drvdata(struct auxiliary_device *auxdev, void *
>  	dev_set_drvdata(&auxdev->dev, data);
>  }
>  
> +static inline bool __must_check
> +auxiliary_device_get(struct auxiliary_device *adev)
> +{
> +	if (!adev)
> +		return false;

Please don't check for validity of adev, it is caller's job.

> +
> +	return refcount_inc_not_zero(&adev->refcnt);
> +}
> +
> +static inline void auxiliary_device_put(struct auxiliary_device *adev)
> +{
> +	if (!adev)
> +		return;

Same.

Thanks
