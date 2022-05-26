Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1F9F535083
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 16:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244071AbiEZOXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 10:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243206AbiEZOXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 10:23:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CD5A9C5E51
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 07:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653575011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PIs2TnkQYfNX5UnfDwJthJ+utgn6CIbjyk+tWQwa1VU=;
        b=LXhuK3e4DQT1TfPNgjQITzGr4DXYgZUam0jZVMEb0ZXeHn5v5vTAA+tVT7h5afb7SyyrKw
        uZhj7dDrYWgb71NX2PA1n5KmQFSe2VzYXmRaTuSzMfkKZZN2/d0AU3lLboutHWFTts7E/Q
        B6WgySLemdO0sODl9eP52WlMvmFSgZ8=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-01yvNjMCM2mUILP6T1AGjw-1; Thu, 26 May 2022 10:23:30 -0400
X-MC-Unique: 01yvNjMCM2mUILP6T1AGjw-1
Received: by mail-qk1-f197.google.com with SMTP id g14-20020ae9e10e000000b006a394d35dbfso1477139qkm.5
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 07:23:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=PIs2TnkQYfNX5UnfDwJthJ+utgn6CIbjyk+tWQwa1VU=;
        b=PUDMHfyQTntqSCkWLtyDpgvYA2hFyKwK9V9z7TRePvvv3weFgKWTOFejiIhWmpQAG8
         tHA8GoucaLxtGMAtKtktKlSl6+itM7mBP9RPQw9b16v80yt0z4oVIxzT+rWTa0wWyG5r
         Sz4ctCBRxh67qV4UMXXxj11XZ+1OTpP9M9wGXNKnEzAK99RtIqSaLvDrLG4/GXvTgxjY
         EkRPO6nYUFJZ1lE6335Ie+tKSG1UgK4qIzRzXJchZ7dzzDDES63N2gIONl9jSHQwEeje
         xEdGNRkUWwGRz1JvPZgVHE0qf6iFDWzjbcaMQsfz6gGJ50yZSU0eDHz4w0hz4llw5N+K
         1gOQ==
X-Gm-Message-State: AOAM532XvEP/qzzRohAlrY21jnUxtQFox4LSEcumeR2V5lzryuXj2FQA
        1PCReUoYbWxPshAUQ8OGJ3Yd+XBckrdlnOA4z6zq1hF9R4OWSInGXVtpIjXewMAnDtPSPVmtzE6
        lr2sGx426zYnuDR5b
X-Received: by 2002:ae9:e90d:0:b0:6a3:28eb:1a4f with SMTP id x13-20020ae9e90d000000b006a328eb1a4fmr25047865qkf.21.1653575009370;
        Thu, 26 May 2022 07:23:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwnsTslbqm3Ty98MkhbvTDM22jLrcctXdBNbGWftZfctg4y2SKQBw+AQi/5d92FEvX7YhHSHQ==
X-Received: by 2002:ae9:e90d:0:b0:6a3:28eb:1a4f with SMTP id x13-20020ae9e90d000000b006a328eb1a4fmr25047843qkf.21.1653575009105;
        Thu, 26 May 2022 07:23:29 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-16.business.telecomitalia.it. [87.12.25.16])
        by smtp.gmail.com with ESMTPSA id j19-20020ac85f93000000b002f3bbad9e37sm1031494qta.91.2022.05.26.07.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 07:23:28 -0700 (PDT)
Date:   Thu, 26 May 2022 16:23:18 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        netdev@vger.kernel.org, martinh@xilinx.com, martinpo@xilinx.com,
        lvivier@redhat.com, pabloc@xilinx.com,
        Parav Pandit <parav@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>, lulu@redhat.com,
        Zhu Lingshan <lingshan.zhu@intel.com>, Piotr.Uminski@intel.com,
        Si-Wei Liu <si-wei.liu@oracle.com>, ecree.xilinx@gmail.com,
        gautam.dawar@amd.com, habetsm.xilinx@gmail.com,
        tanuj.kamde@amd.com, hanand@xilinx.com, dinang@xilinx.com,
        Longpeng <longpeng2@huawei.com>
Subject: Re: [PATCH v4 1/4] vdpa: Add stop operation
Message-ID: <20220526142318.mi2kfywbpvuky4lw@sgarzare-redhat>
References: <20220526124338.36247-1-eperezma@redhat.com>
 <20220526124338.36247-2-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220526124338.36247-2-eperezma@redhat.com>
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 26, 2022 at 02:43:35PM +0200, Eugenio Pérez wrote:
>This operation is optional: It it's not implemented, backend feature bit
>will not be exposed.
>
>Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
>---
> include/linux/vdpa.h | 6 ++++++
> 1 file changed, 6 insertions(+)
>
>diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
>index 15af802d41c4..ddfebc4e1e01 100644
>--- a/include/linux/vdpa.h
>+++ b/include/linux/vdpa.h
>@@ -215,6 +215,11 @@ struct vdpa_map_file {
>  * @reset:			Reset device
>  *				@vdev: vdpa device
>  *				Returns integer: success (0) or error (< 0)
>+ * @stop:			Stop or resume the device (optional, but it must
>+ *				be implemented if require device stop)
>+ *				@vdev: vdpa device
>+ *				@stop: stop (true), not stop (false)

Sorry for just seeing this now, but if you have to send a v5, maybe we 
could use "resume" here instead of "not stop".

Thanks,
Stefano

>+ *				Returns integer: success (0) or error (< 0)
>  * @get_config_size:		Get the size of the configuration space includes
>  *				fields that are conditional on feature bits.
>  *				@vdev: vdpa device
>@@ -316,6 +321,7 @@ struct vdpa_config_ops {
> 	u8 (*get_status)(struct vdpa_device *vdev);
> 	void (*set_status)(struct vdpa_device *vdev, u8 status);
> 	int (*reset)(struct vdpa_device *vdev);
>+	int (*stop)(struct vdpa_device *vdev, bool stop);
> 	size_t (*get_config_size)(struct vdpa_device *vdev);
> 	void (*get_config)(struct vdpa_device *vdev, unsigned int offset,
> 			   void *buf, unsigned int len);
>-- 
>2.31.1
>

