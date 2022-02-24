Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06554C2F70
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 16:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236174AbiBXPXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 10:23:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236499AbiBXPXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 10:23:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D129D1B65F6
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 07:22:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645716093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Cs1X/g4/VcYdFDurBVvxcC8xvB0VJR+m/I4hc1Nnw5k=;
        b=fGr5fmcajyJUlpo28yZvNjRtJfJYqP6Y26eB9WBouOVArDut1LQ3DnkOf6mS0rQKJzJC3B
        nxu4WNAwHM+ubLDPqnD3nkyRBz/H06pA6G+3iekzJIBzVlT1YWilKE3HRL2gYyHbeQN/8A
        TVvGFPSReAbl/Y/4UWjCBq6GVliCstE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-G9s_fX5xOzSkQbi3ed5iGw-1; Thu, 24 Feb 2022 10:21:28 -0500
X-MC-Unique: G9s_fX5xOzSkQbi3ed5iGw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 34AB11091DA0;
        Thu, 24 Feb 2022 15:21:26 +0000 (UTC)
Received: from localhost (unknown [10.39.195.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D44657C049;
        Thu, 24 Feb 2022 15:21:12 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        bhelgaas@google.com, jgg@nvidia.com, saeedm@nvidia.com
Cc:     linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, yishaih@nvidia.com,
        maorg@nvidia.com, ashok.raj@intel.com, kevin.tian@intel.com,
        shameerali.kolothum.thodi@huawei.com
Subject: Re: [PATCH V9 mlx5-next 10/15] vfio: Extend the device migration
 protocol with RUNNING_P2P
In-Reply-To: <20220224142024.147653-11-yishaih@nvidia.com>
Organization: Red Hat GmbH
References: <20220224142024.147653-1-yishaih@nvidia.com>
 <20220224142024.147653-11-yishaih@nvidia.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Thu, 24 Feb 2022 16:21:11 +0100
Message-ID: <87fso870k8.fsf@redhat.com>
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

On Thu, Feb 24 2022, Yishai Hadas <yishaih@nvidia.com> wrote:

> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 22ed358c04c5..26a66f68371d 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1011,10 +1011,16 @@ struct vfio_device_feature {
>   *
>   * VFIO_MIGRATION_STOP_COPY means that STOP, STOP_COPY and
>   * RESUMING are supported.
> + *
> + * VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P means that RUNNING_P2P
> + * is supported in addition to the STOP_COPY states.
> + *
> + * Other combinations of flags have behavior to be defined in the future.
>   */
>  struct vfio_device_feature_migration {
>  	__aligned_u64 flags;
>  #define VFIO_MIGRATION_STOP_COPY	(1 << 0)
> +#define VFIO_MIGRATION_P2P		(1 << 1)
>  };

Coming back to my argument (for the previous series) that this should
rather be "at least one of the flags below must be set". If we operate
under the general assumption that each flag indicates that a certain
functionality (including some states) is supported, and that flags may
depend on other flags, we might have a future flag that defines a
different behaviour, but does not depend on STOP_COPY, but rather
conflicts with it. We should not create the impression that STOP_COPY
will neccessarily be mandatory for all time.

So, if we use my suggestion from the last round, what about making the
new addition

"VFIO_MIGRATION_P2P means that RUNNING_P2P is supported in addition to
the STOP_COPY states. It depends on VFIO_MIGRATION_STOP_COPY."

Maybe we could also use the additional clarification

"at least one of the flags below must be set, and flags may depend on or
conflict with each other."

That implies that VFIO_MIGRATION_STOP_COPY is mandatory with the current
set of defined flags. I would not really object to adding "This flag is
currently mandatory", but I do not like singling it out in the general
description of how the flags work.

Sorry if that sounds nitpicky, but I think we really need to make it
clear that we have some nice possible flexibility with how the flags
work.

