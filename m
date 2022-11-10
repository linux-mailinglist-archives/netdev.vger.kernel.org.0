Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1811624099
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 12:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbiKJLBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 06:01:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiKJLBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 06:01:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E782BED
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 03:00:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668078057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CwbSqqY2hb3WR/MXwVveDXiN+xYjgQSy8jvdiQxJZNc=;
        b=WpI29B40JYjE387L/UhOUYEr2vI2lAIJ7gW1v2r/6vb/qt+ZBRCEar4KZlS1o5H3PPh/VY
        9fVi2mLl71Vkv+Tkc0fe4kljq7rJt9OyMkK9Mx7sEHn917mmoRgTcmtUy8D3k8fhAavSLS
        KfPNEKC9yhveVFsIxkaeAqybBRrhqO8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-479-Gy0eefGdO_ONpj-IVURjlA-1; Thu, 10 Nov 2022 06:00:56 -0500
X-MC-Unique: Gy0eefGdO_ONpj-IVURjlA-1
Received: by mail-wm1-f69.google.com with SMTP id s7-20020a1cf207000000b003cf56bad2e2so452781wmc.9
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 03:00:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CwbSqqY2hb3WR/MXwVveDXiN+xYjgQSy8jvdiQxJZNc=;
        b=MEo4lB9NGK9o52v+ysi4QxsHXqSHxEOvJui04xuEPWSYoNVjtD3AZXmEtLmU6/OC97
         3tpRtXP799KFgl0FUKMf7/sAFvFHZeUOOH1AGP9NsW3wWqpUWTk1HM4VFUHTI98TF7e+
         npJi8bvg5lemlzzFAJp9ANhaz8I98toaW4aovy8OjWQ8VIruZVzZs4O9P+IdViWLEKor
         T1CqMbiHk8brpjDTiprsGa79rpEb3HgeddyCMAiHCl/Bcoywdnc4Q+lXkO9XfyF+DwkV
         AcAJlVNOIkQ4vTEA+xp52O0seOQZWcE16c9Hj5dRWBrh9LiOSLRUL4T916tPriCL7l8m
         bEeQ==
X-Gm-Message-State: ACrzQf3kRQd3m/a0mC4GpQA6ex5YUNqTdw/T+LS1p1KErDoXSshjapUN
        Cfj642vMlhgS/mlvXEq+uJaShjcrqd26ZxbE9daLnRybQspUeA3Hmeho7ZEeX1jgG2Ls7yw+PXZ
        uxiBlQGNyplJ51YEu
X-Received: by 2002:a05:600c:1c1e:b0:3c6:e39f:e62f with SMTP id j30-20020a05600c1c1e00b003c6e39fe62fmr43868088wms.69.1668078054868;
        Thu, 10 Nov 2022 03:00:54 -0800 (PST)
X-Google-Smtp-Source: AMsMyM4Ajw4uJhHQeCBCbastVdKk5Eu6v3FVjoJaLO45qp7Uq8i3+/fisD08QUrRVDg1+f42Hux1vQ==
X-Received: by 2002:a05:600c:1c1e:b0:3c6:e39f:e62f with SMTP id j30-20020a05600c1c1e00b003c6e39fe62fmr43868065wms.69.1668078054548;
        Thu, 10 Nov 2022 03:00:54 -0800 (PST)
Received: from redhat.com ([2.52.3.250])
        by smtp.gmail.com with ESMTPSA id 26-20020a05600c029a00b003cf5ec79bf9sm4718384wmk.40.2022.11.10.03.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 03:00:54 -0800 (PST)
Date:   Thu, 10 Nov 2022 06:00:50 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     dsahern@kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org, si-wei.liu@oracle.com,
        eperezma@redhat.com, lingshan.zhu@intel.com, elic@nvidia.com
Subject: Re: [PATCH] vdpa: allow provisioning device features
Message-ID: <20221110055242-mutt-send-email-mst@kernel.org>
References: <20221110075821.3818-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110075821.3818-1-jasowang@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 03:58:21PM +0800, Jason Wang wrote:
> This patch allows device features to be provisioned via vdpa. This
> will be useful for preserving migration compatibility between source
> and destination:
> 
> # vdpa dev add name dev1 mgmtdev pci/0000:02:00.0 device_features 0x300020000
> # dev1: mac 52:54:00:12:34:56 link up link_announce false mtu 65535
>       negotiated_features CTRL_VQ VERSION_1 ACCESS_PLATFORM
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  man/man8/vdpa-dev.8            | 10 ++++++++++
>  vdpa/include/uapi/linux/vdpa.h |  1 +
>  vdpa/vdpa.c                    | 27 ++++++++++++++++++++++++++-
>  3 files changed, 37 insertions(+), 1 deletion(-)
> 
> diff --git a/man/man8/vdpa-dev.8 b/man/man8/vdpa-dev.8
> index 9faf3838..bb45b4a6 100644
> --- a/man/man8/vdpa-dev.8
> +++ b/man/man8/vdpa-dev.8
> @@ -31,6 +31,7 @@ vdpa-dev \- vdpa device configuration
>  .I NAME
>  .B mgmtdev
>  .I MGMTDEV
> +.RI "[ device_features " DEVICE_FEATURES " ]"
>  .RI "[ mac " MACADDR " ]"
>  .RI "[ mtu " MTU " ]"
>  .RI "[ max_vqp " MAX_VQ_PAIRS " ]"
> @@ -74,6 +75,10 @@ Name of the new vdpa device to add.
>  Name of the management device to use for device addition.
>  
>  .PP
> +.BI device_features " DEVICE_FEAETURES"

typo

> +- specifies the device features that is provisioned for the new vdpa device.

I propose
	 the device features -> the virtio "device features" bit-mask

features sounds like it's a generic thing, here's it's
the actual binary

and maybe add "the bits can be found under include/uapi/linux/virtio*h,
see macros such as VIRTIO_F_ and VIRTIO_NET_F_ for specific bit values"

> +This is optional.
> +

and if not given what are the features?

>  .BI mac " MACADDR"
>  - specifies the mac address for the new vdpa device.
>  This is applicable only for the network type of vdpa device. This is optional.
> @@ -127,6 +132,11 @@ vdpa dev add name foo mgmtdev vdpa_sim_net
>  Add the vdpa device named foo on the management device vdpa_sim_net.
>  .RE
>  .PP
> +vdpa dev add name foo mgmtdev vdpa_sim_net device_features 0x300020000
> +.RS 4
> +Add the vdpa device named foo on the management device vdpa_sim_net with device_features of 0x300020000
> +.RE
> +.PP
>  vdpa dev add name foo mgmtdev vdpa_sim_net mac 00:11:22:33:44:55
>  .RS 4
>  Add the vdpa device named foo on the management device vdpa_sim_net with mac address of 00:11:22:33:44:55.
> diff --git a/vdpa/include/uapi/linux/vdpa.h b/vdpa/include/uapi/linux/vdpa.h
> index 94e4dad1..7c961991 100644
> --- a/vdpa/include/uapi/linux/vdpa.h
> +++ b/vdpa/include/uapi/linux/vdpa.h
> @@ -51,6 +51,7 @@ enum vdpa_attr {
>  	VDPA_ATTR_DEV_QUEUE_INDEX,              /* u32 */
>  	VDPA_ATTR_DEV_VENDOR_ATTR_NAME,		/* string */
>  	VDPA_ATTR_DEV_VENDOR_ATTR_VALUE,        /* u64 */
> +	VDPA_ATTR_DEV_FEATURES,                 /* u64 */
>  
>  	/* new attributes must be added above here */
>  	VDPA_ATTR_MAX,
> diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
> index b73e40b4..9a866d61 100644
> --- a/vdpa/vdpa.c
> +++ b/vdpa/vdpa.c
> @@ -27,6 +27,7 @@
>  #define VDPA_OPT_VDEV_MTU		BIT(5)
>  #define VDPA_OPT_MAX_VQP		BIT(6)
>  #define VDPA_OPT_QUEUE_INDEX		BIT(7)
> +#define VDPA_OPT_VDEV_FEATURES		BIT(8)
>  
>  struct vdpa_opts {
>  	uint64_t present; /* flags of present items */
> @@ -38,6 +39,7 @@ struct vdpa_opts {
>  	uint16_t mtu;
>  	uint16_t max_vqp;
>  	uint32_t queue_idx;
> +	__u64 device_features;
>  };
>  
>  struct vdpa {

why __u and not uint here?

> @@ -187,6 +189,17 @@ static int vdpa_argv_u32(struct vdpa *vdpa, int argc, char **argv,
>  	return get_u32(result, *argv, 10);
>  }
>  
> +static int vdpa_argv_u64_hex(struct vdpa *vdpa, int argc, char **argv,
> +			     __u64 *result)
> +{
> +	if (argc <= 0 || !*argv) {
> +		fprintf(stderr, "number expected\n");
> +		return -EINVAL;
> +	}
> +
> +	return get_u64(result, *argv, 16);
> +}
> +
>  struct vdpa_args_metadata {
>  	uint64_t o_flag;
>  	const char *err_msg;
> @@ -244,6 +257,10 @@ static void vdpa_opts_put(struct nlmsghdr *nlh, struct vdpa *vdpa)
>  		mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, opts->max_vqp);
>  	if (opts->present & VDPA_OPT_QUEUE_INDEX)
>  		mnl_attr_put_u32(nlh, VDPA_ATTR_DEV_QUEUE_INDEX, opts->queue_idx);
> +	if (opts->present & VDPA_OPT_VDEV_FEATURES) {
> +		mnl_attr_put_u64(nlh, VDPA_ATTR_DEV_FEATURES,
> +				opts->device_features);
> +	}
>  }
>  
>  static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
> @@ -329,6 +346,14 @@ static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
>  
>  			NEXT_ARG_FWD();
>  			o_found |= VDPA_OPT_QUEUE_INDEX;
> +		} else if (!strcmp(*argv, "device_features") &&
> +			   (o_optional & VDPA_OPT_VDEV_FEATURES)) {
> +			NEXT_ARG_FWD();
> +			err = vdpa_argv_u64_hex(vdpa, argc, argv,
> +						&opts->device_features);
> +			if (err)
> +				return err;
> +			o_found |= VDPA_OPT_VDEV_FEATURES;
>  		} else {
>  			fprintf(stderr, "Unknown option \"%s\"\n", *argv);
>  			return -EINVAL;


should not we validate the value we get? e.g. a mac feature
requires that mac is supplied, etc.
in fact hex isn't very user friendly. why not pass feature
names instead?



> @@ -708,7 +733,7 @@ static int cmd_dev_add(struct vdpa *vdpa, int argc, char **argv)
>  	err = vdpa_argv_parse_put(nlh, vdpa, argc, argv,
>  				  VDPA_OPT_VDEV_MGMTDEV_HANDLE | VDPA_OPT_VDEV_NAME,
>  				  VDPA_OPT_VDEV_MAC | VDPA_OPT_VDEV_MTU |
> -				  VDPA_OPT_MAX_VQP);
> +				  VDPA_OPT_MAX_VQP | VDPA_OPT_VDEV_FEATURES);
>  	if (err)
>  		return err;
>  
> -- 
> 2.25.1

