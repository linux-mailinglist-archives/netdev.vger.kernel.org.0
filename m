Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6B5358F90F
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 10:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234489AbiHKI3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 04:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234456AbiHKI3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 04:29:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 09B5790836
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 01:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660206556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FxVByzSzFDmsCiLB/TiRSXnYOQzfrWFzUNaldqvoDEA=;
        b=FcuPBac9nPT8MZMNA0pvH3pQdYJ6MuzVJkVA59rxA9BLjP33Jq9yD1AYRXF85QFAqFqeDU
        wvzOWtrUmztqKERLfFOw+8RLIzdktCFIbxb6wb+VtiL4J+zzUmAcD4ixs8CKMNziCy/ZqW
        XR+Ku1lQuZTmqEYWk13zAaSCwpQqors=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-173-2c48XTdIOmuqaI5sVywO-A-1; Thu, 11 Aug 2022 04:29:14 -0400
X-MC-Unique: 2c48XTdIOmuqaI5sVywO-A-1
Received: by mail-wm1-f70.google.com with SMTP id c17-20020a7bc011000000b003a2bfaf8d3dso8438337wmb.0
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 01:29:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=FxVByzSzFDmsCiLB/TiRSXnYOQzfrWFzUNaldqvoDEA=;
        b=mp3gSSRpk9LvcODmpzRH/vCRAGTekk+SSUwDZwatFlFKcd1mXpdxZ0GjgFRgphiwi1
         L1yxcCNsFg/UHxEau+DM5jgpcUI/gtce3YjyGEntReMq7yA58e9vq7nr38jSTB8prhUb
         AyQQH431HqpCjNFNdfJXiPIsHffDcMMVVpJsBhZBiKOhOGbKyXlc7a5dlqYKmo7irLQL
         OfRGz3xMJWDZHXUo0If2D2Rstszy3RyNFptDt7+ccUM3bQsBDhXwzfyzZPczMjKfRnnO
         Vt2Sf53fH3Tgr5cTv8Xzwous1OPCoMN6n5V6wF08n5t0w0KeHmCb4Hn5PoV8juLu5/4g
         kVSw==
X-Gm-Message-State: ACgBeo2YaGD15kN8+JlRPcx5AFER43681jy2EaaT7aUb/CdhZYRqVVMJ
        VuJjzzRuVqxE8x+LaOolL4JpXtuhx0ghKBO/e8dBMf8nkX8yis9bVy7F4kyPildEeqlRGO0hPy5
        DWzaQCBaXdFTqvctz
X-Received: by 2002:a7b:cbd7:0:b0:3a5:500e:13bc with SMTP id n23-20020a7bcbd7000000b003a5500e13bcmr4872412wmi.83.1660206553689;
        Thu, 11 Aug 2022 01:29:13 -0700 (PDT)
X-Google-Smtp-Source: AA6agR66zsuUOgvuqZVbOtSOAaY+Zmwp04081qg20ikPfEaP/6IS6rnkd3YWhqyK4i6W0P73yvfqIw==
X-Received: by 2002:a7b:cbd7:0:b0:3a5:500e:13bc with SMTP id n23-20020a7bcbd7000000b003a5500e13bcmr4872374wmi.83.1660206553473;
        Thu, 11 Aug 2022 01:29:13 -0700 (PDT)
Received: from redhat.com ([2.52.152.113])
        by smtp.gmail.com with ESMTPSA id m21-20020a05600c3b1500b003a317ee3036sm5522733wms.2.2022.08.11.01.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 01:29:12 -0700 (PDT)
Date:   Thu, 11 Aug 2022 04:29:06 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        dinang@xilinx.com, martinpo@xilinx.com,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Piotr.Uminski@intel.com, gautam.dawar@amd.com,
        ecree.xilinx@gmail.com, martinh@xilinx.com,
        Stefano Garzarella <sgarzare@redhat.com>, pabloc@xilinx.com,
        habetsm.xilinx@gmail.com, lvivier@redhat.com,
        Zhu Lingshan <lingshan.zhu@intel.com>, tanuj.kamde@amd.com,
        Longpeng <longpeng2@huawei.com>, lulu@redhat.com,
        hanand@xilinx.com, Parav Pandit <parav@nvidia.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Eli Cohen <elic@nvidia.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH v7 3/4] vhost-vdpa: uAPI to suspend the device
Message-ID: <20220811042847-mutt-send-email-mst@kernel.org>
References: <20220810171512.2343333-1-eperezma@redhat.com>
 <20220810171512.2343333-4-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220810171512.2343333-4-eperezma@redhat.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 10, 2022 at 07:15:11PM +0200, Eugenio Pérez wrote:
> The ioctl adds support for suspending the device from userspace.
> 
> This is a must before getting virtqueue indexes (base) for live migration,
> since the device could modify them after userland gets them. There are
> individual ways to perform that action for some devices
> (VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but there was no
> way to perform it for any vhost device (and, in particular, vhost-vdpa).
> 
> After a successful return of the ioctl call the device must not process
> more virtqueue descriptors. The device can answer to read or writes of
> config fields as if it were not suspended. In particular, writing to
> "queue_enable" with a value of 1 will not make the device start
> processing buffers of the virtqueue.
> 
> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
> Message-Id: <20220623160738.632852-4-eperezma@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

You are not supposed to include upstream maintainer's signoff
like this.

> ---
> v7: Delete argument to ioctl, unused
> ---
>  drivers/vhost/vdpa.c       | 19 +++++++++++++++++++
>  include/uapi/linux/vhost.h |  9 +++++++++
>  2 files changed, 28 insertions(+)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 3d636e192061..7fa671ac4bdf 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -478,6 +478,22 @@ static long vhost_vdpa_get_vqs_count(struct vhost_vdpa *v, u32 __user *argp)
>  	return 0;
>  }
>  
> +/* After a successful return of ioctl the device must not process more
> + * virtqueue descriptors. The device can answer to read or writes of config
> + * fields as if it were not suspended. In particular, writing to "queue_enable"
> + * with a value of 1 will not make the device start processing buffers.
> + */
> +static long vhost_vdpa_suspend(struct vhost_vdpa *v)
> +{
> +	struct vdpa_device *vdpa = v->vdpa;
> +	const struct vdpa_config_ops *ops = vdpa->config;
> +
> +	if (!ops->suspend)
> +		return -EOPNOTSUPP;
> +
> +	return ops->suspend(vdpa);
> +}
> +
>  static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>  				   void __user *argp)
>  {
> @@ -654,6 +670,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
>  	case VHOST_VDPA_GET_VQS_COUNT:
>  		r = vhost_vdpa_get_vqs_count(v, argp);
>  		break;
> +	case VHOST_VDPA_SUSPEND:
> +		r = vhost_vdpa_suspend(v);
> +		break;
>  	default:
>  		r = vhost_dev_ioctl(&v->vdev, cmd, argp);
>  		if (r == -ENOIOCTLCMD)
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index cab645d4a645..f9f115a7c75b 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -171,4 +171,13 @@
>  #define VHOST_VDPA_SET_GROUP_ASID	_IOW(VHOST_VIRTIO, 0x7C, \
>  					     struct vhost_vring_state)
>  
> +/* Suspend a device so it does not process virtqueue requests anymore
> + *
> + * After the return of ioctl the device must preserve all the necessary state
> + * (the virtqueue vring base plus the possible device specific states) that is
> + * required for restoring in the future. The device must not change its
> + * configuration after that point.
> + */
> +#define VHOST_VDPA_SUSPEND		_IO(VHOST_VIRTIO, 0x7D)
> +
>  #endif
> -- 
> 2.31.1

