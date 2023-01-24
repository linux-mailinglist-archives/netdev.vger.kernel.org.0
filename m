Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF57679088
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 06:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbjAXF5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 00:57:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232712AbjAXF5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 00:57:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E31366A3
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 21:56:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674539717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9+nMn4Y7ib+ksp4an8hs+mxpzKixV/6cqrHGLxmxmZs=;
        b=Fv+zftM/+sdrzkt6rdetvf/WJi6bEZ2SsstXemXyQrpRJ3fmrYrDGhqUdH0JcAW3dESW+P
        hc8x7Zz6VZ53s4Vff+RN9wZqfkEXCRqOIanlbsboXXhBzAl6T7uprwDIH2qitYh2NePZVp
        j+5kgltXBJADMgAFT2cFsSDmIe1mTt8=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-128-KqYz8AdvM-i0OpsgJqmOCg-1; Tue, 24 Jan 2023 00:55:15 -0500
X-MC-Unique: KqYz8AdvM-i0OpsgJqmOCg-1
Received: by mail-ua1-f69.google.com with SMTP id p25-20020ab05859000000b006001ac8d2efso4069202uac.11
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 21:55:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9+nMn4Y7ib+ksp4an8hs+mxpzKixV/6cqrHGLxmxmZs=;
        b=LuoJhPQpccOmVsNwmuhvh6l28illtoZ8Yw3fEacEtNqFE20hnjruLvGbtoICfE7KPp
         M0260jLSBCmpfJQW1/WGffBstRtN6YcIg3XkK4OCCRZPmw5lpWcEaHKIeJzxpL5BR3uk
         Z4tXEeebA5iIPfPU5b36o5A794uvVwKB5Eot4bt+IKasIotsDMc6U+i2deohLwHnF+x7
         GL2kCp4WKWKDswUi8hpmZJ4oiYGab8gtTm+DjYlXIO/lCFKtg+bDN5ZyaL8WM5oG9cWL
         /Q+t4RIFdM1MjDUF892RgIt6kup/UXVfqmpqyLpERFnzqAHZtAH1GUF27l6avYHnnMDk
         IC6g==
X-Gm-Message-State: AFqh2krqKLH69a9D95CJphAuRnRvXd9i4Cb2/eXD7Il+ILNNnLZjFhaT
        59Grde/wgVUMGCdnF2Asz/93mR/QAqcnugAPQwCHSZLobNQUyHLHk12q7eRaMAFcvVO4phyHorA
        8L3WDoH7c2VW5yDzg
X-Received: by 2002:a05:6102:1517:b0:3d3:c855:bf54 with SMTP id f23-20020a056102151700b003d3c855bf54mr16402957vsv.34.1674539714882;
        Mon, 23 Jan 2023 21:55:14 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtIO8aXO9i+HLzZc6kLGRsWHVrO9s72UFSgMG1EytTFL2SpZojIc12K4cwqrrKZT6og3irEcA==
X-Received: by 2002:a05:6102:1517:b0:3d3:c855:bf54 with SMTP id f23-20020a056102151700b003d3c855bf54mr16402943vsv.34.1674539714642;
        Mon, 23 Jan 2023 21:55:14 -0800 (PST)
Received: from redhat.com ([45.144.113.7])
        by smtp.gmail.com with ESMTPSA id r15-20020ab04a4f000000b006180bedf1b8sm83195uae.26.2023.01.23.21.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 21:55:14 -0800 (PST)
Date:   Tue, 24 Jan 2023 00:55:06 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, jhubbard@nvidia.com,
        tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com,
        mkoutny@suse.com, daniel@ffwll.ch,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 02/19] drivers/vhost: Convert to use vm_account
Message-ID: <20230124005356-mutt-send-email-mst@kernel.org>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <97a17a6ab7e59be4287a2a94d43bb787300476b4.1674538665.git-series.apopple@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97a17a6ab7e59be4287a2a94d43bb787300476b4.1674538665.git-series.apopple@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 24, 2023 at 04:42:31PM +1100, Alistair Popple wrote:
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index ec32f78..a31dd53 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c

...

> @@ -780,6 +780,10 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
>  	u32 asid = iotlb_to_asid(iotlb);
>  	int r = 0;
>  
> +	if (!vdpa->use_va)
> +		if (vm_account_pinned(&dev->vm_account, PFN_DOWN(size)))
> +			return -ENOMEM;
> +
>  	r = vhost_iotlb_add_range_ctx(iotlb, iova, iova + size - 1,
>  				      pa, perm, opaque);
>  	if (r)

I suspect some error handling will have to be reworked then, no?

> -- 
> git-series 0.9.1

