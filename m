Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE4494C1970
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 18:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243216AbiBWRHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 12:07:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243208AbiBWRG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 12:06:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 17C3F583B6
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 09:06:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645635983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OdhMSjzenM1uAIsnbqo9rXhRZ5TBT2FTULmZ23R9wDg=;
        b=Z5p6XWikyzj9bA6nS1ZONkbxSdPoL/QGbbb5dkAYCJe1MPHVKYgzXlGI6C12ur7OFte6ZB
        PiuE+pAgFyjQaxXO90pX3kfgVZM8rmXq/0iAeoyrtzr1VCDwQV4P2v+bddJVUkyUHt+9zk
        7kSGYCR1xLY8BcR1zlWwfzXq5r9jXeA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-42---G7p4icMOm0TjUV1mgtbQ-1; Wed, 23 Feb 2022 12:06:17 -0500
X-MC-Unique: --G7p4icMOm0TjUV1mgtbQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A5E3C1091DA1;
        Wed, 23 Feb 2022 17:06:15 +0000 (UTC)
Received: from localhost (unknown [10.39.193.96])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 43153804F8;
        Wed, 23 Feb 2022 17:06:15 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        bhelgaas@google.com, jgg@nvidia.com, saeedm@nvidia.com
Cc:     linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, yishaih@nvidia.com,
        maorg@nvidia.com, ashok.raj@intel.com, kevin.tian@intel.com,
        shameerali.kolothum.thodi@huawei.com
Subject: Re: [PATCH V8 mlx5-next 09/15] vfio: Define device migration
 protocol v2
In-Reply-To: <20220220095716.153757-10-yishaih@nvidia.com>
Organization: Red Hat GmbH
References: <20220220095716.153757-1-yishaih@nvidia.com>
 <20220220095716.153757-10-yishaih@nvidia.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Wed, 23 Feb 2022 18:06:13 +0100
Message-ID: <87ley17bsq.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 20 2022, Yishai Hadas <yishaih@nvidia.com> wrote:

> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index ca69516f869d..3bbadcdbc9c8 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -56,6 +56,14 @@ struct vfio_device {
>   *         match, -errno for abort (ex. match with insufficient or incorrect
>   *         additional args)
>   * @device_feature: Fill in the VFIO_DEVICE_FEATURE ioctl
> + * @migration_set_state: Optional callback to change the migration state for
> + *         devices that support migration. The returned FD is used for data
> + *         transfer according to the FSM definition. The driver is responsible
> + *         to ensure that FD reaches end of stream or error whenever the
> + *         migration FSM leaves a data transfer state or before close_device()
> + *         returns.
> + * @migration_get_state: Optional callback to get the migration state for
> + *         devices that support migration.

Nit: I'd add "mandatory for VFIO_DEVICE_FEATURE_MIGRATION migration
support" to both descriptions to be a bit more explicit.

(...)

> +/*
> + * Indicates the device can support the migration API through
> + * VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE. If present flags must be non-zero and
> + * VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE is supported. The RUNNING and

I'm having trouble parsing this. I think what it tries to say is that at
least one of the flags defined below must be set?

> + * ERROR states are always supported if this GET succeeds.

What about the following instead:

"Indicates device support for the migration API through
VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE. If present, the RUNNING and ERROR
states are always supported. Support for additional states is indicated
via the flags field; at least one of the flags defined below must be
set."

> + *
> + * VFIO_MIGRATION_STOP_COPY means that STOP, STOP_COPY and
> + * RESUMING are supported.
> + */
> +struct vfio_device_feature_migration {
> +	__aligned_u64 flags;
> +#define VFIO_MIGRATION_STOP_COPY	(1 << 0)
> +};

