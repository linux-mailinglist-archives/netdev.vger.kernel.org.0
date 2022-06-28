Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3F855E911
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346120AbiF1NkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 09:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbiF1NkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 09:40:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7C0D0A18C
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 06:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656423607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JI0SMOllATTHDDnFWqGpyGyrKVYRMdL/R18gEZANfRM=;
        b=N34XgfuTdposPCi0F6k6e4iuPT82msTP2J4ss2z7m/um3AtaLhefhSKPt1tBD0K8XGMBKl
        dGl3VwoiOZCTdPvwm2CAxh5o6WnVizKMRpVZGlAahX2bYrEnBu9ojLXMunA/HbuwxoHnAK
        9Er1GQfW+qlcQfiIJMV/WOuTPJwQskI=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-ccr7ydHHP4-6kuEYORuMWQ-1; Tue, 28 Jun 2022 09:40:06 -0400
X-MC-Unique: ccr7ydHHP4-6kuEYORuMWQ-1
Received: by mail-qv1-f71.google.com with SMTP id mz4-20020a0562142d0400b004726d99aa49so5010602qvb.10
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 06:40:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=JI0SMOllATTHDDnFWqGpyGyrKVYRMdL/R18gEZANfRM=;
        b=XeZMF9jETpBCdxw09EJW9MxUy2EMnY3mvpXlPwinqJjy++672s0XCKBuDJcKjr7A1W
         8UEFO6T1G0ORdl7oqXVTWfAQmKLqEDpNMI/Jq9OBjD//6mF7pl3sRm2+xas/oyueCB/i
         Tvt3OlULykrgKigazheuq/K2xz22DBdtja6RitKwfN0Ys2hpdbcwQe9zcYo3FE2jyyMf
         qT+JftniILthlxprjDeKGtgJqrQRhOVMif+OFwyfuHQFVPUpBuSCBlWjZc7OGX8752JW
         EFsr4wemvYkksdA8xhmpnNwUq+I4jg0Z7AejXmzndsJYT9/YwWOy843Nzwzby2UUhWig
         0jPQ==
X-Gm-Message-State: AJIora9H8XGhFZd92YGDSPvBOxKhYoGC8qylN7By2uybHmYvPW06+Clu
        bP+jsK2E12vq5OgugXu1pN4ZtSF0wvIzpHVeayNpyMAg/RXs3cHr83tjpgl1zVBARNnKsaSBlVg
        jMaGwLTPtppaVD8SG
X-Received: by 2002:a05:6214:509c:b0:470:529a:1d76 with SMTP id kk28-20020a056214509c00b00470529a1d76mr3556348qvb.7.1656423605653;
        Tue, 28 Jun 2022 06:40:05 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uR1KivmrgHGt9XzHfmrBurNzgAa+UdSQyz20DSSdlK3mKA/+nt175Sp7jgxeEBsCjfL+bPrw==
X-Received: by 2002:a05:6214:509c:b0:470:529a:1d76 with SMTP id kk28-20020a056214509c00b00470529a1d76mr3556306qvb.7.1656423605246;
        Tue, 28 Jun 2022 06:40:05 -0700 (PDT)
Received: from sgarzare-redhat (host-87-11-6-149.retail.telecomitalia.it. [87.11.6.149])
        by smtp.gmail.com with ESMTPSA id bl10-20020a05620a1a8a00b006a67eb4610fsm11214694qkb.116.2022.06.28.06.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 06:40:04 -0700 (PDT)
Date:   Tue, 28 Jun 2022 15:39:55 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>
Cc:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        lulu@redhat.com, tanuj.kamde@amd.com,
        Si-Wei Liu <si-wei.liu@oracle.com>, Piotr.Uminski@intel.com,
        habetsm.xilinx@gmail.com, gautam.dawar@amd.com, pabloc@xilinx.com,
        Zhu Lingshan <lingshan.zhu@intel.com>, lvivier@redhat.com,
        Longpeng <longpeng2@huawei.com>, dinang@xilinx.com,
        martinh@xilinx.com, martinpo@xilinx.com,
        Eli Cohen <elic@nvidia.com>, ecree.xilinx@gmail.com,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, hanand@xilinx.com,
        Xie Yongji <xieyongji@bytedance.com>,
        Zhang Min <zhang.min9@zte.com.cn>
Subject: Re: [PATCH v6 1/4] vdpa: Add suspend operation
Message-ID: <20220628133955.sj32sfounu4byggl@sgarzare-redhat>
References: <20220623160738.632852-1-eperezma@redhat.com>
 <20220623160738.632852-2-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220623160738.632852-2-eperezma@redhat.com>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 23, 2022 at 06:07:35PM +0200, Eugenio Pérez wrote:
>This operation is optional: It it's not implemented, backend feature bit
>will not be exposed.
>
>Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
>---
> include/linux/vdpa.h | 4 ++++
> 1 file changed, 4 insertions(+)
>
>diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
>index 7b4a13d3bd91..d282f464d2f1 100644
>--- a/include/linux/vdpa.h
>+++ b/include/linux/vdpa.h
>@@ -218,6 +218,9 @@ struct vdpa_map_file {
>  * @reset:			Reset device
>  *				@vdev: vdpa device
>  *				Returns integer: success (0) or error (< 0)
>+ * @suspend:			Suspend or resume the device (optional)
                                            ^
IIUC we removed the resume operation (that should be done with reset),
so should we update this documentation?

Thanks,
Stefano

>+ *				@vdev: vdpa device
>+ *				Returns integer: success (0) or error (< 0)
>  * @get_config_size:		Get the size of the configuration space includes
>  *				fields that are conditional on feature bits.
>  *				@vdev: vdpa device
>@@ -319,6 +322,7 @@ struct vdpa_config_ops {
> 	u8 (*get_status)(struct vdpa_device *vdev);
> 	void (*set_status)(struct vdpa_device *vdev, u8 status);
> 	int (*reset)(struct vdpa_device *vdev);
>+	int (*suspend)(struct vdpa_device *vdev);
> 	size_t (*get_config_size)(struct vdpa_device *vdev);
> 	void (*get_config)(struct vdpa_device *vdev, unsigned int offset,
> 			   void *buf, unsigned int len);
>-- 
>2.31.1
>

