Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7CCD4BD478
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 05:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242220AbiBUD7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 22:59:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233632AbiBUD7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 22:59:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A139351E72
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 19:58:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645415918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lDMA9bBeQIDn1Dg8UmtwgqOpL2IgXMpjzKkQnXB3h40=;
        b=SRNB6MAx872QkXCVy0waWyYmc6zTrfXI+l/DyL+gIOXtzDC5EkQza9HDxR98hMvfqZiCtt
        3Wlp4tYNh6+iFiDHEdEAd+7f7st1R4vhES6WI6rzPD5SGSJCfk1EF5itLi8UAUqARWKYZK
        Rr2ZQP5by/kWoTy6W2U1kRlOcq15AWQ=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-440-VdVnEqA0PaCK8RGXzCgC_A-1; Sun, 20 Feb 2022 22:58:37 -0500
X-MC-Unique: VdVnEqA0PaCK8RGXzCgC_A-1
Received: by mail-pj1-f71.google.com with SMTP id m19-20020a17090aab1300b001bbef243093so4924378pjq.1
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 19:58:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lDMA9bBeQIDn1Dg8UmtwgqOpL2IgXMpjzKkQnXB3h40=;
        b=hmslWFW84/C4UOPol93izzUoWqFkANwm1BCf14ouHTMa6EP1jy6y6lqR7YfgHeNmLr
         3j6c1hXGcGolYxofJokKuCSwTs37DnT0nrQeGmplrUC+9m0uzVs+MGCcopRdxP03+mLG
         gcsP3tO3aV40wJHHVbttFINd9HxwVsrZxtsRMgr1D9XQWZeZ/VDkN97/BMR+CgfT1HE5
         +XyS+Nqy8zjlAL70w2BUUa1t5SYpSfkKg57ujhaEk2a3dbx3R9TPYjzznyp0iEY5zoJC
         cg+Y/wCt99dWRgChAU4i/chQBPKVYmnUWDlyCX/+9Bihn8PMQJN3AK3FvUL5PvFW4wyl
         oYiw==
X-Gm-Message-State: AOAM531B0lbMBvZLbMNbczQGEebMXTmBlHb0VMuPVlTGU0o+GDNpfQFP
        OKe+p+Zz6LgnsgYiFjcDTWSkJmWyukmv3mGMDK5Dymoi8Km8fiqWEA1r25tmupQuaaqm/3kf5+s
        RUa49x8RoQTwHqHG5
X-Received: by 2002:a17:90a:480e:b0:1bc:1d88:8d4e with SMTP id a14-20020a17090a480e00b001bc1d888d4emr6281610pjh.157.1645415916413;
        Sun, 20 Feb 2022 19:58:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxw58fBVvffTweTGNkCS8fa6tGLxvJi7NO0f+mn6RmyA7RcEs7ppvJpRe8g2PrSaGWk2V+NRw==
X-Received: by 2002:a17:90a:480e:b0:1bc:1d88:8d4e with SMTP id a14-20020a17090a480e00b001bc1d888d4emr6281591pjh.157.1645415916145;
        Sun, 20 Feb 2022 19:58:36 -0800 (PST)
Received: from [10.72.12.96] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 8sm10648859pfl.164.2022.02.20.19.58.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Feb 2022 19:58:35 -0800 (PST)
Message-ID: <2eaa5546-a1d9-76ca-e1d5-410399e27d3a@redhat.com>
Date:   Mon, 21 Feb 2022 11:58:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH v2 3/4] vdpa: Support for configuring max VQ pairs for a
 device
Content-Language: en-US
To:     Eli Cohen <elic@nvidia.com>, stephen@networkplumber.org,
        netdev@vger.kernel.org
Cc:     lulu@redhat.com, si-wei.liu@oracle.com
References: <20220217123024.33201-1-elic@nvidia.com>
 <20220217123024.33201-4-elic@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220217123024.33201-4-elic@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/2/17 下午8:30, Eli Cohen 写道:
> Use VDPA_ATTR_DEV_MGMTDEV_MAX_VQS to specify max number of virtqueue
> pairs to configure for a vdpa device when adding a device.
>
> Examples:
> 1. Create a device with 3 virtqueue pairs:
> $ vdpa dev add name vdpa-a mgmtdev auxiliary/mlx5_core.sf.1 max_vqp 3
>
> 2. Read the configuration of a vdpa device
> $ vdpa dev config show vdpa-a
>    vdpa-a: mac 00:00:00:00:88:88 link up link_announce false max_vq_pairs 3 \
>            mtu 1500
>    negotiated_features CSUM GUEST_CSUM MTU MAC HOST_TSO4 HOST_TSO6 STATUS \
>                        CTRL_VQ MQ CTRL_MAC_ADDR VERSION_1 ACCESS_PLATFORM
>
> Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
> Signed-off-by: Eli Cohen <elic@nvidia.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   vdpa/include/uapi/linux/vdpa.h |  1 +
>   vdpa/vdpa.c                    | 27 +++++++++++++++++++++++++--
>   2 files changed, 26 insertions(+), 2 deletions(-)
>
> diff --git a/vdpa/include/uapi/linux/vdpa.h b/vdpa/include/uapi/linux/vdpa.h
> index 748c350450b2..a3ebf4d4d9b8 100644
> --- a/vdpa/include/uapi/linux/vdpa.h
> +++ b/vdpa/include/uapi/linux/vdpa.h
> @@ -41,6 +41,7 @@ enum vdpa_attr {
>   	VDPA_ATTR_DEV_NET_CFG_MTU,		/* u16 */
>   
>   	VDPA_ATTR_DEV_NEGOTIATED_FEATURES,	/* u64 */
> +	VDPA_ATTR_DEV_MGMTDEV_MAX_VQS,          /* u32 */
>   
>   	/* new attributes must be added above here */
>   	VDPA_ATTR_MAX,
> diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
> index f60e647b8cf8..78736b1422b6 100644
> --- a/vdpa/vdpa.c
> +++ b/vdpa/vdpa.c
> @@ -25,6 +25,7 @@
>   #define VDPA_OPT_VDEV_HANDLE		BIT(3)
>   #define VDPA_OPT_VDEV_MAC		BIT(4)
>   #define VDPA_OPT_VDEV_MTU		BIT(5)
> +#define VDPA_OPT_MAX_VQP		BIT(6)
>   
>   struct vdpa_opts {
>   	uint64_t present; /* flags of present items */
> @@ -34,6 +35,7 @@ struct vdpa_opts {
>   	unsigned int device_id;
>   	char mac[ETH_ALEN];
>   	uint16_t mtu;
> +	uint16_t max_vqp;
>   };
>   
>   struct vdpa {
> @@ -81,6 +83,7 @@ static const enum mnl_attr_data_type vdpa_policy[VDPA_ATTR_MAX + 1] = {
>   	[VDPA_ATTR_DEV_MAX_VQS] = MNL_TYPE_U32,
>   	[VDPA_ATTR_DEV_MAX_VQ_SIZE] = MNL_TYPE_U16,
>   	[VDPA_ATTR_DEV_NEGOTIATED_FEATURES] = MNL_TYPE_U64,
> +	[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS] = MNL_TYPE_U32,
>   };
>   
>   static int attr_cb(const struct nlattr *attr, void *data)
> @@ -222,6 +225,8 @@ static void vdpa_opts_put(struct nlmsghdr *nlh, struct vdpa *vdpa)
>   			     sizeof(opts->mac), opts->mac);
>   	if (opts->present & VDPA_OPT_VDEV_MTU)
>   		mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MTU, opts->mtu);
> +	if (opts->present & VDPA_OPT_MAX_VQP)
> +		mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, opts->max_vqp);
>   }
>   
>   static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
> @@ -290,6 +295,14 @@ static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
>   
>   			NEXT_ARG_FWD();
>   			o_found |= VDPA_OPT_VDEV_MTU;
> +		} else if ((matches(*argv, "max_vqp")  == 0) && (o_optional & VDPA_OPT_MAX_VQP)) {
> +			NEXT_ARG_FWD();
> +			err = vdpa_argv_u16(vdpa, argc, argv, &opts->max_vqp);
> +			if (err)
> +				return err;
> +
> +			NEXT_ARG_FWD();
> +			o_found |= VDPA_OPT_MAX_VQP;
>   		} else {
>   			fprintf(stderr, "Unknown option \"%s\"\n", *argv);
>   			return -EINVAL;
> @@ -500,6 +513,15 @@ static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
>   		pr_out_array_end(vdpa);
>   	}
>   
> +	if (tb[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS]) {
> +		uint16_t num_vqs;
> +
> +		if (!vdpa->json_output)
> +			printf("\n");
> +		num_vqs = mnl_attr_get_u16(tb[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS]);
> +		print_uint(PRINT_ANY, "max_supported_vqs", "  max_supported_vqs %d", num_vqs);
> +	}
> +
>   	pr_out_handle_end(vdpa);
>   }
>   
> @@ -559,7 +581,7 @@ static int cmd_mgmtdev(struct vdpa *vdpa, int argc, char **argv)
>   static void cmd_dev_help(void)
>   {
>   	fprintf(stderr, "Usage: vdpa dev show [ DEV ]\n");
> -	fprintf(stderr, "       vdpa dev add name NAME mgmtdev MANAGEMENTDEV [ mac MACADDR ] [ mtu MTU ]\n");
> +	fprintf(stderr, "       vdpa dev add name NAME mgmtdev MANAGEMENTDEV [ mac MACADDR ] [ mtu MTU ] [max_vqp MAX_VQ_PAIRS]\n");
>   	fprintf(stderr, "       vdpa dev del DEV\n");
>   	fprintf(stderr, "Usage: vdpa dev config COMMAND [ OPTIONS ]\n");
>   }
> @@ -649,7 +671,8 @@ static int cmd_dev_add(struct vdpa *vdpa, int argc, char **argv)
>   					  NLM_F_REQUEST | NLM_F_ACK);
>   	err = vdpa_argv_parse_put(nlh, vdpa, argc, argv,
>   				  VDPA_OPT_VDEV_MGMTDEV_HANDLE | VDPA_OPT_VDEV_NAME,
> -				  VDPA_OPT_VDEV_MAC | VDPA_OPT_VDEV_MTU);
> +				  VDPA_OPT_VDEV_MAC | VDPA_OPT_VDEV_MTU |
> +				  VDPA_OPT_MAX_VQP);
>   	if (err)
>   		return err;
>   

