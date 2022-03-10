Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0813D4D407F
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 06:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239384AbiCJFBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 00:01:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiCJFBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 00:01:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0C512D900
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 21:00:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6ACD461874
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 05:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3DBCC340E8;
        Thu, 10 Mar 2022 05:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646888409;
        bh=I9BEHg74Yk6nXMvkjgTI1dMQ7hbgH5pd6Oe7nEU2J5s=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=etnWuWXXToZvkXDU+dGVBD6I86l1YQeEAJ6Q5h0B8hT8IsPMXiqku+N73l5ikGJ+x
         e7IRfuxA2Z6jUC+6lbiS5dCjmwWW+eXTjd+vjQjz7WVvEfoqKDVbieRuEqJqiV0LZ3
         PJLS7EdCNMCJ+xQZv82s/Vtd+3GYe2mM16cRXXEbxzKLG5upv71gKuSa/DF/s+7GaI
         T0oS7WiE48U8N2OE5zbzPLh0awZE8eCjbsz9LlbWfciPjnl4I4/xxBEMS4ZWZ+0C7G
         CmGI/Tn/GcF6fIec5veakZ0HGv0g90isjk1L8SGAqG4nSnTgGyMKGUpu3jAfxZrPDF
         ZP+7z+3qV5dkQ==
Message-ID: <2d4bc28e-41a8-c6ce-7d52-cb1d9f523e70@kernel.org>
Date:   Wed, 9 Mar 2022 22:00:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH v5 3/4] vdpa: Support for configuring max VQ pairs for a
 device
Content-Language: en-US
To:     Eli Cohen <elic@nvidia.com>, stephen@networkplumber.org,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        jasowang@redhat.com, si-wei.liu@oracle.com
Cc:     mst@redhat.com, lulu@redhat.com, parav@nvidia.com
References: <20220309164609.7233-1-elic@nvidia.com>
 <20220309164609.7233-4-elic@nvidia.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220309164609.7233-4-elic@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/22 9:46 AM, Eli Cohen wrote:
> Use VDPA_ATTR_DEV_MGMTDEV_MAX_VQS to specify max number of virtqueue
> pairs to configure for a vdpa device when adding a device.
> 
> Examples:
> 1. Create a device with 3 virtqueue pairs:
> $ vdpa dev add name vdpa-a mgmtdev auxiliary/mlx5_core.sf.1 max_vqp 3
> 
> 2. Read the configuration of a vdpa device
> $ vdpa dev config show vdpa-a
>   vdpa-a: mac 00:00:00:00:88:88 link up link_announce false max_vq_pairs 3 \
>           mtu 1500
>   negotiated_features CSUM GUEST_CSUM MTU MAC HOST_TSO4 HOST_TSO6 STATUS \
>                       CTRL_VQ MQ CTRL_MAC_ADDR VERSION_1 ACCESS_PLATFORM
> 
> Signed-off-by: Eli Cohen <elic@nvidia.com>
> ---
> v4 -> v5:
> 1. Use u32 arithmetic in pr_out_mgmtdev_show() to be consistend with
>    attribute width.
> 
>  vdpa/include/uapi/linux/vdpa.h |  1 +
>  vdpa/vdpa.c                    | 27 +++++++++++++++++++++++++--
>  2 files changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/vdpa/include/uapi/linux/vdpa.h b/vdpa/include/uapi/linux/vdpa.h
> index 748c350450b2..a3ebf4d4d9b8 100644
> --- a/vdpa/include/uapi/linux/vdpa.h
> +++ b/vdpa/include/uapi/linux/vdpa.h
> @@ -41,6 +41,7 @@ enum vdpa_attr {
>  	VDPA_ATTR_DEV_NET_CFG_MTU,		/* u16 */
>  
>  	VDPA_ATTR_DEV_NEGOTIATED_FEATURES,	/* u64 */
> +	VDPA_ATTR_DEV_MGMTDEV_MAX_VQS,          /* u32 */

rather than add 1 uapi at a time, please sync the uapi file all at once
in a patch before it is needed with a git commit message about where the
uapi file is synched from.

>  
>  	/* new attributes must be added above here */
>  	VDPA_ATTR_MAX,
> diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
> index 5f1aa91a4b96..8b34e29394b2 100644
> --- a/vdpa/vdpa.c
> +++ b/vdpa/vdpa.c
> @@ -25,6 +25,7 @@
>  #define VDPA_OPT_VDEV_HANDLE		BIT(3)
>  #define VDPA_OPT_VDEV_MAC		BIT(4)
>  #define VDPA_OPT_VDEV_MTU		BIT(5)
> +#define VDPA_OPT_MAX_VQP		BIT(6)
>  
>  struct vdpa_opts {
>  	uint64_t present; /* flags of present items */
> @@ -34,6 +35,7 @@ struct vdpa_opts {
>  	unsigned int device_id;
>  	char mac[ETH_ALEN];
>  	uint16_t mtu;
> +	uint16_t max_vqp;
>  };
>  
>  struct vdpa {
> @@ -81,6 +83,7 @@ static const enum mnl_attr_data_type vdpa_policy[VDPA_ATTR_MAX + 1] = {
>  	[VDPA_ATTR_DEV_MAX_VQS] = MNL_TYPE_U32,
>  	[VDPA_ATTR_DEV_MAX_VQ_SIZE] = MNL_TYPE_U16,
>  	[VDPA_ATTR_DEV_NEGOTIATED_FEATURES] = MNL_TYPE_U64,
> +	[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS] = MNL_TYPE_U32,
>  };
>  
>  static int attr_cb(const struct nlattr *attr, void *data)
> @@ -222,6 +225,8 @@ static void vdpa_opts_put(struct nlmsghdr *nlh, struct vdpa *vdpa)
>  			     sizeof(opts->mac), opts->mac);
>  	if (opts->present & VDPA_OPT_VDEV_MTU)
>  		mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MTU, opts->mtu);
> +	if (opts->present & VDPA_OPT_MAX_VQP)
> +		mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, opts->max_vqp);
>  }
>  
>  static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
> @@ -290,6 +295,14 @@ static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
>  
>  			NEXT_ARG_FWD();
>  			o_found |= VDPA_OPT_VDEV_MTU;
> +		} else if ((matches(*argv, "max_vqp")  == 0) && (o_optional & VDPA_OPT_MAX_VQP)) {
> +			NEXT_ARG_FWD();
> +			err = vdpa_argv_u16(vdpa, argc, argv, &opts->max_vqp);
> +			if (err)
> +				return err;
> +
> +			NEXT_ARG_FWD();
> +			o_found |= VDPA_OPT_MAX_VQP;
>  		} else {
>  			fprintf(stderr, "Unknown option \"%s\"\n", *argv);
>  			return -EINVAL;
> @@ -501,6 +514,15 @@ static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
>  		pr_out_array_end(vdpa);
>  	}
>  
> +	if (tb[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS]) {
> +		uint32_t num_vqs;
> +
> +		if (!vdpa->json_output)
> +			printf("\n");
> +		num_vqs = mnl_attr_get_u32(tb[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS]);
> +		print_uint(PRINT_ANY, "max_supported_vqs", "  max_supported_vqs %d", num_vqs);
> +	}
> +
>  	pr_out_handle_end(vdpa);
>  }
>  
> @@ -560,7 +582,7 @@ static int cmd_mgmtdev(struct vdpa *vdpa, int argc, char **argv)
>  static void cmd_dev_help(void)
>  {
>  	fprintf(stderr, "Usage: vdpa dev show [ DEV ]\n");
> -	fprintf(stderr, "       vdpa dev add name NAME mgmtdev MANAGEMENTDEV [ mac MACADDR ] [ mtu MTU ]\n");
> +	fprintf(stderr, "       vdpa dev add name NAME mgmtdev MANAGEMENTDEV [ mac MACADDR ] [ mtu MTU ] [max_vqp MAX_VQ_PAIRS]\n");

keep those lines at about 80 chars
