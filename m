Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D90714CA19D
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 11:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237028AbiCBKBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 05:01:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236562AbiCBKBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 05:01:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9F8A65DE48
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 02:00:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646215219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gd8QmYu+t8IWFQq3XAq6jOtogrY+DiY1h8TKTMSwibg=;
        b=Qgn+ac8wpzKPt9JIgp4Q/EFiJ4S2OjKDW3xRrMTav8/WzHcCwwEwUqVYnANRpFREdInZrT
        SJMWU20WZvDAs7Gkc/W9z0gbAYY51J3l39pb7UiPWVvjiZfHiHNIhq8bV2uEi2eokrAJV/
        Wifz2TS5JZ2Dh0p+IWcpmkcPjFt/w+w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-rVJ7WQV9NbKRUvzULE3SRg-1; Wed, 02 Mar 2022 05:00:16 -0500
X-MC-Unique: rVJ7WQV9NbKRUvzULE3SRg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3A1F81CD1F;
        Wed,  2 Mar 2022 10:00:13 +0000 (UTC)
Received: from localhost (unknown [10.39.194.94])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 39ADA6FB08;
        Wed,  2 Mar 2022 10:00:10 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        bhelgaas@google.com, jgg@nvidia.com, saeedm@nvidia.com
Cc:     linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, yishaih@nvidia.com,
        maorg@nvidia.com, ashok.raj@intel.com, kevin.tian@intel.com,
        shameerali.kolothum.thodi@huawei.com
Subject: Re: [PATCH V9 mlx5-next 08/15] vfio: Have the core code decode the
 VFIO_DEVICE_FEATURE ioctl
In-Reply-To: <20220224142024.147653-9-yishaih@nvidia.com>
Organization: Red Hat GmbH
References: <20220224142024.147653-1-yishaih@nvidia.com>
 <20220224142024.147653-9-yishaih@nvidia.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Wed, 02 Mar 2022 11:00:08 +0100
Message-ID: <87zgm8isif.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24 2022, Yishai Hadas <yishaih@nvidia.com> wrote:

> From: Jason Gunthorpe <jgg@nvidia.com>
>
> Invoke a new device op 'device_feature' to handle just the data array
> portion of the command. This lifts the ioctl validation to the core code
> and makes it simpler for either the core code, or layered drivers, to
> implement their own feature values.
>
> Provide vfio_check_feature() to consolidate checking the flags/etc against
> what the driver supports.
>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci.c      |  1 +
>  drivers/vfio/pci/vfio_pci_core.c | 94 +++++++++++++-------------------
>  drivers/vfio/vfio.c              | 46 ++++++++++++++--
>  include/linux/vfio.h             | 32 +++++++++++
>  include/linux/vfio_pci_core.h    |  2 +
>  5 files changed, 114 insertions(+), 61 deletions(-)

(...)

> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 76191d7abed1..ca69516f869d 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -55,6 +55,7 @@ struct vfio_device {
>   * @match: Optional device name match callback (return: 0 for no-match, >0 for
>   *         match, -errno for abort (ex. match with insufficient or incorrect
>   *         additional args)
> + * @device_feature: Fill in the VFIO_DEVICE_FEATURE ioctl
>   */
>  struct vfio_device_ops {
>  	char	*name;
> @@ -69,8 +70,39 @@ struct vfio_device_ops {
>  	int	(*mmap)(struct vfio_device *vdev, struct vm_area_struct *vma);
>  	void	(*request)(struct vfio_device *vdev, unsigned int count);
>  	int	(*match)(struct vfio_device *vdev, char *buf);
> +	int	(*device_feature)(struct vfio_device *device, u32 flags,
> +				  void __user *arg, size_t argsz);
>  };

Is the expectation that most drivers will eventually implement
->device_feature()? Well, they will have to if they want to support
migration; mostly asking because e.g. ->match() is explicitly marked as
"optional". As the only callback every driver implements seems to be
->ioctl() (if we also include the samples), "optional" or not does not
seem to be particularly relevant anyway.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

