Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEAB05A7E45
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 15:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbiHaNIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 09:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbiHaNIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 09:08:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6655EB99E5
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 06:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661951298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hywdEPUBwDEXmtkI0jnmSRJpF0zIazv7Rc1AGtOEGW8=;
        b=OxvkNLH1VNgEJ7/yda7B21ikrZ74DaQIwZT2Zmrm3Qod82wvpWVExHuSIv+n6Vrd8g8v+c
        mnjEltUeDdop7R/QVIOFPK8IN1fxhroR7f2NmC1aqG++JI9m0emrBmP2N8RkaAEw29UUeg
        L6xzEhaa8YH41DzcM8UFXYSSpkKbMr4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-612-ehPz7pK_MMylvIL4jTDCGA-1; Wed, 31 Aug 2022 09:08:17 -0400
X-MC-Unique: ehPz7pK_MMylvIL4jTDCGA-1
Received: by mail-wm1-f71.google.com with SMTP id b4-20020a05600c4e0400b003a5a96f1756so11713870wmq.0
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 06:08:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=hywdEPUBwDEXmtkI0jnmSRJpF0zIazv7Rc1AGtOEGW8=;
        b=0kg1ZWl15YKZLqGnLrQIR/3QZ1LfD6lBmRt0QFx2+ZhsL6tRdg4qO1ov+xE1zJqcYZ
         sWUXmPc+SwuLQyYr8Oqh9+N6lM0MFTAwwn5uF2OgCHwoJEBvK488mfpnLnmmCd6p6qtW
         SQnXG9eRCaRmHWG/kdD8Hp8jT0ta2kObWHSef7JpjcsPruk3p4uor0BfeckA1s0UvEnn
         /1M6IKS5/hyM5cFiDdD7ey3TlpOot7RxULC9SciLlGy5aI9Ie8I5OmpN/+t857annVRg
         wVVtAqHTzEQRw4y++urp1DCKmcaENDTGJDY1GPL3MXGHzTsnXZpCLA6PhK0FM7kwybrL
         OLYQ==
X-Gm-Message-State: ACgBeo3J0k0r6q9NzY4YqhyZXGW4vfe+RxC6XATuogTYOrPgAk3DSfpT
        R4mncnBX4St5hpVB5B0XmtvkAdf+LJU8lQKD3+9c4JgPKmrZZ9eV5iriFAbeOpffopZOGGr+FaE
        QTs6mu4yXiUiNeiNy
X-Received: by 2002:a5d:4082:0:b0:226:d019:c91e with SMTP id o2-20020a5d4082000000b00226d019c91emr11914074wrp.557.1661951296175;
        Wed, 31 Aug 2022 06:08:16 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5ohNbZ482TWkudDJOWI8JLnbpEFRUINvd3UPL3S0CQwHgE0OAjwRxPcbUVSPcRsLsbVCut+g==
X-Received: by 2002:a5d:4082:0:b0:226:d019:c91e with SMTP id o2-20020a5d4082000000b00226d019c91emr11914059wrp.557.1661951295958;
        Wed, 31 Aug 2022 06:08:15 -0700 (PDT)
Received: from redhat.com ([2.55.191.225])
        by smtp.gmail.com with ESMTPSA id t20-20020a05600c199400b003a845621c5bsm2177751wmq.34.2022.08.31.06.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 06:08:15 -0700 (PDT)
Date:   Wed, 31 Aug 2022 09:08:10 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Gavin Li <gavinl@nvidia.com>
Cc:     stephen@networkplumber.org, davem@davemloft.net,
        jesse.brandeburg@intel.com, alexander.h.duyck@intel.com,
        kuba@kernel.org, sridhar.samudrala@intel.com, jasowang@redhat.com,
        loseweigh@gmail.com, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        virtio-dev@lists.oasis-open.org, gavi@nvidia.com, parav@nvidia.com,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>
Subject: Re: [PATCH RESEND v4 1/2] virtio-net: introduce and use helper
 function for guest gso support checks
Message-ID: <20220831090721-mutt-send-email-mst@kernel.org>
References: <20220831130541.81217-1-gavinl@nvidia.com>
 <20220831130541.81217-2-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831130541.81217-2-gavinl@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 31, 2022 at 04:05:40PM +0300, Gavin Li wrote:
> Probe routine is already several hundred lines.
> Use helper function for guest gso support check.
> 
> Signed-off-by: Gavin Li <gavinl@nvidia.com>
> Reviewed-by: Gavi Teitz <gavi@nvidia.com>
> Reviewed-by: Parav Pandit <parav@nvidia.com>
> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
> ---
> changelog:
> v1->v2
> - Add new patch
> ---
>  drivers/net/virtio_net.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 9cce7dec7366..e1904877d461 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3682,6 +3682,14 @@ static int virtnet_validate(struct virtio_device *vdev)
>  	return 0;
>  }
>  
> +static bool virtnet_check_guest_gso(const struct virtnet_info *vi)
> +{
> +	return (virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> +		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO6) ||
> +		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) ||
> +		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO));
> +}
> +

fine but can we please drop the outer ()?
they are necessary with if but not with return.


>  static int virtnet_probe(struct virtio_device *vdev)
>  {
>  	int i, err = -ENOMEM;
> @@ -3777,10 +3785,7 @@ static int virtnet_probe(struct virtio_device *vdev)
>  	spin_lock_init(&vi->refill_lock);
>  
>  	/* If we can receive ANY GSO packets, we must allocate large ones. */
> -	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> -	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6) ||
> -	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_ECN) ||
> -	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_UFO))
> +	if (virtnet_check_guest_gso(vi))
>  		vi->big_packets = true;
>  
>  	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
> -- 
> 2.31.1

