Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEDBB5AF80D
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 00:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiIFWmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 18:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiIFWmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 18:42:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4478C440
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 15:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662504119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KaiiwGogUVf/sW/NCZ1A9G8Q7iwk+zy+Q12Kp9/22/g=;
        b=RWyuWuwVftaxK9uT4aSeG5T6s3UY+yDquirO8FIHhqPl7NvbZv7gYtjDCg3QJOXvi2EEy1
        qjquNo8wNiMeeHfNshPg/eF/HbTTX4n5oCKC4NJGyEcide81yo6hbGxO84qtzcFxDnlz4+
        1Lx/YeYv91ItrvTaWn+U0gw+umI3x98=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-509--PdrHpM9OeqE6moozxo53Q-1; Tue, 06 Sep 2022 18:41:58 -0400
X-MC-Unique: -PdrHpM9OeqE6moozxo53Q-1
Received: by mail-io1-f72.google.com with SMTP id be26-20020a056602379a00b0068b50a068baso7934584iob.11
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 15:41:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=KaiiwGogUVf/sW/NCZ1A9G8Q7iwk+zy+Q12Kp9/22/g=;
        b=XCE4W/M6xQiFu5l0Zzb1yzt8dR10ZK+P+7mmLXRFxNWJ8He7MaUu3BYi6AEjOvaZ50
         Y6II8TK+xU1HF+Z0hdZ4JI801z4NJwrShOPeWHnsfwh2zDCQmwRKx0LirczAWQVYV4Jw
         Iiwf3QOESYEGf0rrfzo9l/JkddQTaGpezQMJRfB0gZON/3fq5ZnpW0kZVWRcWffd+6Ng
         5oCgITlWSOvjO3r/F7kTwbOQmpfKTQAARRLNDD5x5yiWJeJlZIb0MCflAPfHjzjva69J
         vM+U+Cxk5t9EJpFFSePljOE7pC3VxJgV8kW2GFushhfw1rwzgBxeMkZvmwKZLycXaSD1
         LwDg==
X-Gm-Message-State: ACgBeo2UUw/tM1Gc0N8AIfXCpHlFmeKAq5awf2ztJIp7F5wwZNYPBlSn
        9oO4n2F6J1aP6TFZyt1aNibLnmVGS4WdU/jSdJl7WYhc0DoX4e0N1jfdaj/e5+wJ3XeSqNtygpV
        dDY9Xrd1IJioXmPiR
X-Received: by 2002:a05:6e02:102e:b0:2f1:4eca:9a13 with SMTP id o14-20020a056e02102e00b002f14eca9a13mr332473ilj.253.1662504117509;
        Tue, 06 Sep 2022 15:41:57 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6hgGiqG9jecy+m8uYtmkseWMgh4xJGw+yZ1NW4U1B7crGOGfiqga+xjAaXhVMhE4rplSgpIg==
X-Received: by 2002:a05:6e02:102e:b0:2f1:4eca:9a13 with SMTP id o14-20020a056e02102e00b002f14eca9a13mr332462ilj.253.1662504117277;
        Tue, 06 Sep 2022 15:41:57 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id u15-20020a02b1cf000000b00344c3de5ec7sm6083130jah.150.2022.09.06.15.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 15:41:56 -0700 (PDT)
Date:   Tue, 6 Sep 2022 16:41:54 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>
Subject: Re: [PATCH V6 vfio 05/10] vfio: Introduce the DMA logging feature
 support
Message-ID: <20220906164154.756e26aa.alex.williamson@redhat.com>
In-Reply-To: <20220905105852.26398-6-yishaih@nvidia.com>
References: <20220905105852.26398-1-yishaih@nvidia.com>
        <20220905105852.26398-6-yishaih@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 5 Sep 2022 13:58:47 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index e05ddc6fe6a5..b17f2f454389 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -108,6 +110,21 @@ struct vfio_migration_ops {
>  				   enum vfio_device_mig_state *curr_state);
>  };
>  
> +/**
> + * @log_start: Optional callback to ask the device start DMA logging.
> + * @log_stop: Optional callback to ask the device stop DMA logging.
> + * @log_read_and_clear: Optional callback to ask the device read
> + *         and clear the dirty DMAs in some given range.

I don't see anywhere in the core that we track the device state
relative to the DEVICE_FEATURE_DMA_LOGGING features, nor do we
explicitly put the responsibility on the driver implementation to
handle invalid user requests.  The mlx5 driver implementation appears
to do this, but maybe we should at least include a requirement here, ex.

   The vfio core implementation of the DEVICE_FEATURE_DMA_LOGGING_ set
   of features does not track logging state relative to the device,
   therefore the device implementation of vfio_log_ops must handle
   arbitrary user requests.  This includes rejecting subsequent calls
   to log_start without an intervening log_stop, as well as graceful
   handling of log_stop and log_read_and_clear from invalid states.

With something like that.

Acked-by: Alex Williamson <alex.williamson@redhat.com>

You can also add my Ack on 3, 4, and (fwiw) 6-10 as I assume this would
be a PR from Leon.  Thanks,

Alex

> + */
> +struct vfio_log_ops {
> +	int (*log_start)(struct vfio_device *device,
> +		struct rb_root_cached *ranges, u32 nnodes, u64 *page_size);
> +	int (*log_stop)(struct vfio_device *device);
> +	int (*log_read_and_clear)(struct vfio_device *device,
> +		unsigned long iova, unsigned long length,
> +		struct iova_bitmap *dirty);
> +};
> +
>  /**
>   * vfio_check_feature - Validate user input for the VFIO_DEVICE_FEATURE ioctl
>   * @flags: Arg from the device_feature op

