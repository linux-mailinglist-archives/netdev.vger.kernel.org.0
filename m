Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E8B530B84
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 11:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbiEWI2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 04:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231815AbiEWI2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 04:28:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EE1FEE2D
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 01:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653294479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T/1kwIlur/LWGYGUmdTrROiOtB3QTQUmvrtaI59KDYw=;
        b=DBYrKKja10rNPl1IlRLCecq92ogfcoHFZihIU5miFcLlVr/QqiH4e8FjEk/b5p87wtVe9h
        5gHkjPBaoLqOXZGYLNNT22eHQ3OMvRjgNR+Dtz5ALgBMh0kG7ZeFYG7SASZUcK1Pd8F4Ph
        w/ed0/MAwE7XG/St2qje+Fn8ku98A28=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-127-L-r_oNuCOF-K6YfR1Mb9dQ-1; Mon, 23 May 2022 04:27:50 -0400
X-MC-Unique: L-r_oNuCOF-K6YfR1Mb9dQ-1
Received: by mail-qk1-f199.google.com with SMTP id m26-20020a05620a13ba00b006a32a7adb78so9303758qki.10
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 01:27:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=T/1kwIlur/LWGYGUmdTrROiOtB3QTQUmvrtaI59KDYw=;
        b=sYCEVnvuEUnPsXgZXEwUpDy/r2TdSunQQhFO9N/lRU6V8FA7UoHRiaJQBxbzzfugGI
         vvpF8rTq7WpsIXGEOUkmDfqx57A25l1ol4vC3E9WMT8npZftNv0wSOjm7uY7UD/tUhTy
         o6zsKAp7kILlNLPq6psN8ESDhA9xq92Fe/ELvokTszE2Pua79CAldOsMtEjEXqVsVfI6
         ZTqfMO1TijFX/NU9A5h8ISlQZ5+SnC12R2avQqsRbN1CqvKEqHpNPwb0J+gIuArJpRWT
         HBy0LD8Kcx35lA053KRwRl/RsBU21ZUmU/O8lE/Y+rD/LVYwZmbAKO2WjREPzqgPtLLF
         3fxg==
X-Gm-Message-State: AOAM531UHkQG+i3hMC1gKfOr0FPdmnWB16Yzyqp5d/rms1ZTXhp4Iy7n
        M2RouGWwNWht5QhRhXnPGwFUDSV7OcXhBTqsceMdvuJKYQQORDTOhp0XnfiLKq5JseExB6JgAEM
        8Fz6VHaLm3a/Ks7Yn
X-Received: by 2002:ad4:5bef:0:b0:462:3068:9225 with SMTP id k15-20020ad45bef000000b0046230689225mr4664794qvc.26.1653294470037;
        Mon, 23 May 2022 01:27:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxext/h6oF1JgzqF6JvJzAca18yRqrepSqFHtMgfDdKHE+p8QYTPMkUbIPydmmw9aPdDAkBCw==
X-Received: by 2002:ad4:5bef:0:b0:462:3068:9225 with SMTP id k15-20020ad45bef000000b0046230689225mr4664769qvc.26.1653294469789;
        Mon, 23 May 2022 01:27:49 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-16.business.telecomitalia.it. [87.12.25.16])
        by smtp.gmail.com with ESMTPSA id m24-20020ac866d8000000b002f932d920ccsm2544399qtp.64.2022.05.23.01.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 01:27:49 -0700 (PDT)
Date:   Mon, 23 May 2022 10:27:38 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Longpeng <longpeng2@huawei.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, martinh@xilinx.com,
        hanand@xilinx.com, Si-Wei Liu <si-wei.liu@oracle.com>,
        dinang@xilinx.com, Eli Cohen <elic@nvidia.com>, lvivier@redhat.com,
        pabloc@xilinx.com, gautam.dawar@amd.com,
        Xie Yongji <xieyongji@bytedance.com>, habetsm.xilinx@gmail.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        tanuj.kamde@amd.com, Wu Zongyong <wuzongyong@linux.alibaba.com>,
        martinpo@xilinx.com, lulu@redhat.com, ecree.xilinx@gmail.com,
        Parav Pandit <parav@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Zhang Min <zhang.min9@zte.com.cn>
Subject: Re: [PATCH 4/4] vdpa_sim: Implement stop vdpa op
Message-ID: <20220523082738.h7lvwkysnqhynf37@sgarzare-redhat>
References: <20220520172325.980884-1-eperezma@redhat.com>
 <20220520172325.980884-5-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220520172325.980884-5-eperezma@redhat.com>
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 20, 2022 at 07:23:25PM +0200, Eugenio Pérez wrote:
>Implement stop operation for vdpa_sim devices, so vhost-vdpa will offer
>that backend feature and userspace can effectively stop the device.
>
>This is a must before get virtqueue indexes (base) for live migration,
>since the device could modify them after userland gets them. There are
>individual ways to perform that action for some devices
>(VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but there was no
>way to perform it for any vhost device (and, in particular, vhost-vdpa).
>
>Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
>---
> drivers/vdpa/vdpa_sim/vdpa_sim.c     | 21 +++++++++++++++++++++
> drivers/vdpa/vdpa_sim/vdpa_sim.h     |  1 +
> drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  3 +++
> 3 files changed, 25 insertions(+)
>
>diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
>index 50d721072beb..0515cf314bed 100644
>--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
>+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
>@@ -107,6 +107,7 @@ static void vdpasim_do_reset(struct vdpasim *vdpasim)
> 	for (i = 0; i < vdpasim->dev_attr.nas; i++)
> 		vhost_iotlb_reset(&vdpasim->iommu[i]);
>
>+	vdpasim->running = true;
> 	spin_unlock(&vdpasim->iommu_lock);
>
> 	vdpasim->features = 0;
>@@ -505,6 +506,24 @@ static int vdpasim_reset(struct vdpa_device *vdpa)
> 	return 0;
> }
>
>+static int vdpasim_stop(struct vdpa_device *vdpa, bool stop)
>+{
>+	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
>+	int i;
>+
>+	spin_lock(&vdpasim->lock);
>+	vdpasim->running = !stop;
>+	if (vdpasim->running) {
>+		/* Check for missed buffers */
>+		for (i = 0; i < vdpasim->dev_attr.nvqs; ++i)
>+			vdpasim_kick_vq(vdpa, i);
>+
>+	}
>+	spin_unlock(&vdpasim->lock);
>+
>+	return 0;
>+}
>+
> static size_t vdpasim_get_config_size(struct vdpa_device *vdpa)
> {
> 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
>@@ -694,6 +713,7 @@ static const struct vdpa_config_ops vdpasim_config_ops = {
> 	.get_status             = vdpasim_get_status,
> 	.set_status             = vdpasim_set_status,
> 	.reset			= vdpasim_reset,
>+	.stop			= vdpasim_stop,
> 	.get_config_size        = vdpasim_get_config_size,
> 	.get_config             = vdpasim_get_config,
> 	.set_config             = vdpasim_set_config,
>@@ -726,6 +746,7 @@ static const struct vdpa_config_ops vdpasim_batch_config_ops = {
> 	.get_status             = vdpasim_get_status,
> 	.set_status             = vdpasim_set_status,
> 	.reset			= vdpasim_reset,
>+	.stop			= vdpasim_stop,
> 	.get_config_size        = vdpasim_get_config_size,
> 	.get_config             = vdpasim_get_config,
> 	.set_config             = vdpasim_set_config,
>diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/vdpa_sim.h
>index 622782e92239..061986f30911 100644
>--- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
>+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
>@@ -66,6 +66,7 @@ struct vdpasim {
> 	u32 generation;
> 	u64 features;
> 	u32 groups;
>+	bool running;
> 	/* spinlock to synchronize iommu table */
> 	spinlock_t iommu_lock;
> };
>diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
>index 5125976a4df8..886449e88502 100644
>--- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
>+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
>@@ -154,6 +154,9 @@ static void vdpasim_net_work(struct work_struct *work)
>
> 	spin_lock(&vdpasim->lock);
>
>+	if (!vdpasim->running)
>+		goto out;
>+

It would be nice to do the same for vdpa_sim_blk as well.

Thanks,
Stefano

