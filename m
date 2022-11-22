Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9DC563355D
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 07:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbiKVGd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 01:33:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbiKVGdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 01:33:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E6F22DD8
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 22:32:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669098777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m5DjO7BjpyUGy3S6uOAU9v7mQBK1GOx/SrNCagtFGjM=;
        b=RlwJVr5OJDiOr1Ub8SbCvjOetL3PKwfa2XJfPuIkABEBB1fapoSqQ57gHA5+kwBI5FQGp2
        uCm2c+SEqI/Vy873JbNqjU4GzaNGk40IUXxhdA/UexN7YwM2FFO93+AbDP47r1QvsTF97E
        HyeS/ZJ9GZ5JSZS4bVMB01RW+lSv9zw=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-654-aBSsKu4gMJeOE3lTaiOKUQ-1; Tue, 22 Nov 2022 01:32:55 -0500
X-MC-Unique: aBSsKu4gMJeOE3lTaiOKUQ-1
Received: by mail-oo1-f69.google.com with SMTP id v13-20020a4a314d000000b0049ef3d0a60dso6099542oog.10
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 22:32:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m5DjO7BjpyUGy3S6uOAU9v7mQBK1GOx/SrNCagtFGjM=;
        b=21RIbhv65gTTMyO6kAlVxFohN48IYoK0dEZvvKZXNlF02V3YkZPMQkmhP1aF0+7aJ8
         nDjuGybAIZEOmVxnxIdaOeBt7YVgw+idRkIc3khC8C5XYDa05zzCcC2mLZA2X2ydxZdl
         /uMwBXWFfMxyhv6DDQEblaIczG47Ks3u1FJtl/5A1chAtAPCSifvbN8VdrTi3V7Tr6OY
         BESDSNWKcXFOE3XWdsj8OG4lGVMJi7tzk3+ri0O5dspGJnIGxDpeGM1xCT+MwnTOczA7
         oGkG5rtHxV0eHvbIf+ei+p18gl9/vb6447aPmQCqGy953UX721Ukt5S5RxhgVojf66w2
         yFKw==
X-Gm-Message-State: ANoB5pkvtdSMMVgYY9FsadsTrwlf3bvBe6Rw+bcLAKjapjp9/LsJLyma
        myFvxS/lZHcGMPaDB5Nzub8wW4ZgimntJYWG8Hg5+LPt/mCWvbd4GtNsO/suiDLBbO2cIIjhhrG
        3mCUBQonv05G9Xc9mze+n5wBxiSoXLTd4
X-Received: by 2002:a05:6830:6505:b0:66c:fb5b:4904 with SMTP id cm5-20020a056830650500b0066cfb5b4904mr11337010otb.237.1669098774058;
        Mon, 21 Nov 2022 22:32:54 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5JzAIPl3s0pitkJaRFZp3vPbW9B2doZPZpd4MPKePy8uj/VMJ81moMQRFVX8LAVZf99DB0wU+lIfnDqO3zuXg=
X-Received: by 2002:a05:6830:6505:b0:66c:fb5b:4904 with SMTP id
 cm5-20020a056830650500b0066cfb5b4904mr11337001otb.237.1669098773829; Mon, 21
 Nov 2022 22:32:53 -0800 (PST)
MIME-Version: 1.0
References: <20221118225656.48309-1-snelson@pensando.io> <20221118225656.48309-18-snelson@pensando.io>
In-Reply-To: <20221118225656.48309-18-snelson@pensando.io>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 22 Nov 2022 14:32:42 +0800
Message-ID: <CACGkMEuVYUFJzdKDRGo2B3BNtaPaWduHr+jLNAfwCOzpr-5fcg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 17/19] pds_vdpa: add vdpa config client commands
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mst@redhat.com, virtualization@lists.linux-foundation.org,
        drivers@pensando.io
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 19, 2022 at 6:57 AM Shannon Nelson <snelson@pensando.io> wrote:
>
> These are the adminq commands that will be needed for
> setting up and using the vDPA device.
>
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---
>  drivers/vdpa/pds/Makefile   |   1 +
>  drivers/vdpa/pds/cmds.c     | 266 ++++++++++++++++++++++++++++++++++++
>  drivers/vdpa/pds/cmds.h     |  17 +++
>  drivers/vdpa/pds/vdpa_dev.h |  60 ++++++++
>  4 files changed, 344 insertions(+)
>  create mode 100644 drivers/vdpa/pds/cmds.c
>  create mode 100644 drivers/vdpa/pds/cmds.h
>  create mode 100644 drivers/vdpa/pds/vdpa_dev.h
>

[...]

> +struct pds_vdpa_device {
> +       struct vdpa_device vdpa_dev;
> +       struct pds_vdpa_aux *vdpa_aux;
> +       struct pds_vdpa_hw hw;
> +
> +       struct virtio_net_config vn_config;
> +       dma_addr_t vn_config_pa;

So this is the dma address not necessarily pa, we'd better drop the "pa" suffix.

Thanks

> +       struct dentry *dentry;
> +};
> +
> +int pds_vdpa_get_mgmt_info(struct pds_vdpa_aux *vdpa_aux);
> +
> +#endif /* _VDPA_DEV_H_ */
> --
> 2.17.1
>

