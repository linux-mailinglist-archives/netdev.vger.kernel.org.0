Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85658686AE8
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 16:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbjBAPzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 10:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231904AbjBAPzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 10:55:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C53AD19
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 07:54:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675266764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XzoNqKV6Cz9SVsHFKDeNJCe9fKu9P6AEJ0vvGP1TI1k=;
        b=ePDbu7mCgGkPMe1fxfhnL/O/zC9RaRkyMsoHTNfyYBNcBrXvcMDpNOK8zD9fvIw8CrVRLG
        NyulC5msUVJw3/33Kf/ocG4err3w69erJ0vzcwmD6r3xU0m/RD8zjC8GKYjveQ5k0ewi+M
        A64baU3FIyY8j6ZYOcIWvECpThCNPas=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-478-RfTBTzHtMPundOidqiMpWA-1; Wed, 01 Feb 2023 10:52:41 -0500
X-MC-Unique: RfTBTzHtMPundOidqiMpWA-1
Received: by mail-wm1-f71.google.com with SMTP id iz20-20020a05600c555400b003dc53fcc88fso1189563wmb.2
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 07:52:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XzoNqKV6Cz9SVsHFKDeNJCe9fKu9P6AEJ0vvGP1TI1k=;
        b=omIHQwY6C94OOheqOvZS7KjAULUKNCV8Fhpn2XWMoKoodos0X9l2RmZ5nAJ8IqtsP2
         WIadJP0JC/6XyvzOHa6oKhNh9TfLVrWsdVrIsCRU+kANH67D50rV7U2iaAofhA5rrYsd
         pHp6mlBQ82iTTrBnfbNh+j62ZzBUuzkbfWH3KfKbGBZLttkF/W0bPxo91EFbu9P4Ldvh
         iGJamLLrnccA6Iy1sg4eSIz+YVh1VSDv4nAtOUfX0Fkm8Z/QCtPdFdw+tUEwkmiIjoMw
         DiWS969/gL4tw8gkJja6LU484CjMUNY/IPwMSh6XFU/lPCibOKlwHZS9iwWCmjsDXMzV
         CMAw==
X-Gm-Message-State: AO0yUKWPAUFkduUQetJuXwOh6hin5H0aOOvp1Dooxnh+8NFGUOsImFT8
        D0j3ddZVq53mo9ys3t5yi0S/vnKQTzKyKM2hNOGnDt2obG8FIxEdhVQ0xChm/48dWs4R4z+vBVQ
        VwUcRC7K6Vu/Nwez8
X-Received: by 2002:a5d:68c8:0:b0:2bb:6b92:d4cc with SMTP id p8-20020a5d68c8000000b002bb6b92d4ccmr2670033wrw.53.1675266759390;
        Wed, 01 Feb 2023 07:52:39 -0800 (PST)
X-Google-Smtp-Source: AK7set8qYSlMDMNOSFaN19grpNcj5RrzZI2G3D9+Cd/RumqUU7LsytpntPRQ2vaoy76EUXG76UA3pA==
X-Received: by 2002:a5d:68c8:0:b0:2bb:6b92:d4cc with SMTP id p8-20020a5d68c8000000b002bb6b92d4ccmr2670025wrw.53.1675266759217;
        Wed, 01 Feb 2023 07:52:39 -0800 (PST)
Received: from redhat.com ([2.52.144.173])
        by smtp.gmail.com with ESMTPSA id j15-20020a5d452f000000b002be505ab59asm17589261wra.97.2023.02.01.07.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 07:52:38 -0800 (PST)
Date:   Wed, 1 Feb 2023 10:52:35 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org,
        Eugenio Perez Martin <eperezma@redhat.com>
Subject: Re: [PATCH] vhost-vdpa: print error when vhost_vdpa_alloc_domain
 fails
Message-ID: <20230201105200-mutt-send-email-mst@kernel.org>
References: <20230201152018.1270226-1-alvaro.karsz@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201152018.1270226-1-alvaro.karsz@solid-run.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 05:20:18PM +0200, Alvaro Karsz wrote:
> Add a print explaining why vhost_vdpa_alloc_domain failed if the device
> is not IOMMU cache coherent capable.
> 
> Without this print, we have no hint why the operation failed.
> 
> For example:
> 
> $ virsh start <domain>
> 	error: Failed to start domain <domain>
> 	error: Unable to open '/dev/vhost-vdpa-<idx>' for vdpa device:
> 	       Unknown error 524
> 
> Suggested-by: Eugenio Perez Martin <eperezma@redhat.com>
> Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>

I'm not sure this is a good idea. Userspace is not supposed to be
able to trigger dev_err.

> ---
>  drivers/vhost/vdpa.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 23db92388393..56287506aa0d 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -1151,8 +1151,11 @@ static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
>  	if (!bus)
>  		return -EFAULT;
>  
> -	if (!device_iommu_capable(dma_dev, IOMMU_CAP_CACHE_COHERENCY))
> +	if (!device_iommu_capable(dma_dev, IOMMU_CAP_CACHE_COHERENCY)) {
> +		dev_err(&v->dev,
> +			"Failed to allocate domain, device is not IOMMU cache coherent capable\n");
>  		return -ENOTSUPP;
> +	}
>  
>  	v->domain = iommu_domain_alloc(bus);
>  	if (!v->domain)
> -- 
> 2.34.1

