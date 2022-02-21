Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AAF14BD46E
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 05:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240305AbiBUD5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 22:57:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233632AbiBUD5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 22:57:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3DDD512765
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 19:57:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645415829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JO9yta0D9MTaM6Hn9atbwRQ06DwqfbnCXKNaGNYnIJw=;
        b=Zya10IpHT+GcY/NIX/gNrFwAoaVnGimUZf+jOcThDJkuSxnyX5UOVHkMhBLrJoCigoBHrv
        xo8E24rG7GomU0Cs8WESsmGIEK+lSfCoqm8K4TR6ja9rHq/JTDq5P0NxGS4drrwpX8+ytj
        Xe19OA8D2ClqE9aEeOxzlWYjLeByKhU=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-88-CfBKzJKBMh2wJ7oRjHaO4A-1; Sun, 20 Feb 2022 22:57:08 -0500
X-MC-Unique: CfBKzJKBMh2wJ7oRjHaO4A-1
Received: by mail-pf1-f197.google.com with SMTP id z28-20020aa79f9c000000b004e10449d919so4262885pfr.4
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 19:57:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JO9yta0D9MTaM6Hn9atbwRQ06DwqfbnCXKNaGNYnIJw=;
        b=RRfScEv2AgeYwo+Q5/ZVyuQ5Om9CUNjANL7d+QaHRfIt9xCV6KvzYm/trghZEeC8yW
         q+bHn3u2kYL+A4YSe3alODU0l/GzucwvMxtrntRFOzGdPBH/+RQUqLGz81oBBXeXXLd0
         gsQ8d8Tb1ORc6yZHDsabPZUPMt1BCWvNlkai/fQCjxaRuwKm60aoQk+uT50FU+ePC7nH
         Sx3KLmmpa3tNI+BVEjb8dD2smwtHgJL97X4hUqEhZ8Gw7dC+2n3TF/KyNozqhTjrkW0/
         oOJoZzk5nrg68ghZ1RzAs6MNOIanKt/2yjSMjtf+OPOKbdpTX976eHTtCLT7BvLh7DAR
         ep/w==
X-Gm-Message-State: AOAM533srmZAlPIQ6/gL7E5lxL0vtMOTIC5EEg3+SKZE/Jn9hfE6kDkl
        J76Dmuoofc98u3/Hrx1sND7oOP5Xtksc4lZD4Sc9TF0oohnq+QB3n2VNtI/6sRi3HxIU/OPbk4D
        VzY6q82yE7Kwhcl7g
X-Received: by 2002:a62:e917:0:b0:4e0:1646:3b82 with SMTP id j23-20020a62e917000000b004e016463b82mr18436212pfh.57.1645415827057;
        Sun, 20 Feb 2022 19:57:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzoBYCvEeDSAFbmX2RwZEIT0h0i81nDpRN7i8ht4JmsRT3gKz7VEMk48H3d3WSU1ne83k5xyQ==
X-Received: by 2002:a62:e917:0:b0:4e0:1646:3b82 with SMTP id j23-20020a62e917000000b004e016463b82mr18436193pfh.57.1645415826755;
        Sun, 20 Feb 2022 19:57:06 -0800 (PST)
Received: from [10.72.12.96] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m7sm3229651pgq.43.2022.02.20.19.57.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Feb 2022 19:57:06 -0800 (PST)
Message-ID: <986a234d-098b-2577-be2f-7c6853e73ee6@redhat.com>
Date:   Mon, 21 Feb 2022 11:57:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH v2 2/4] vdpa: Allow for printing negotiated features of a
 device
Content-Language: en-US
To:     Eli Cohen <elic@nvidia.com>, stephen@networkplumber.org,
        netdev@vger.kernel.org
Cc:     lulu@redhat.com, si-wei.liu@oracle.com
References: <20220217123024.33201-1-elic@nvidia.com>
 <20220217123024.33201-3-elic@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220217123024.33201-3-elic@nvidia.com>
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
> When reading the configuration of a vdpa device, check if the
> VDPA_ATTR_DEV_NEGOTIATED_FEATURES is available. If it is, parse the
> feature bits and print a string representation of each of the feature
> bits.
>
> We keep the strings in two different arrays. One for net device related
> devices and one for generic feature bits.
>
> In this patch we parse only net device specific features. Support for
> other devices can be added later. If the device queried is not a net
> device, we print its bit number only.
>
> Examples:
> 1. Standard presentation
> $ vdpa dev config show vdpa-a
> vdpa-a: mac 00:00:00:00:88:88 link up link_announce false max_vq_pairs 2 mtu 9000
>    negotiated_features CSUM GUEST_CSUM MTU MAC HOST_TSO4 HOST_TSO6 STATUS \
> CTRL_VQ MQ CTRL_MAC_ADDR VERSION_1 ACCESS_PLATFORM
>
> 2. json output
> $ vdpa -j dev config show vdpa-a
> {"config":{"vdpa-a":{"mac":"00:00:00:00:88:88","link":"up","link_announce":false,\
> "max_vq_pairs":2,"mtu":9000,"negotiated_features":["CSUM","GUEST_CSUM",\
> "MTU","MAC","HOST_TSO4","HOST_TSO6","STATUS","CTRL_VQ","MQ","CTRL_MAC_ADDR",\
> "VERSION_1","ACCESS_PLATFORM"]}}}
>
> 3. Pretty json
> $ vdpa -jp dev config show vdpa-a
> {
>      "config": {
>          "vdpa-a": {
>              "mac": "00:00:00:00:88:88",
>              "link ": "up",
>              "link_announce ": false,
>              "max_vq_pairs": 2,
>              "mtu": 9000,
>              "negotiated_features": [
> "CSUM","GUEST_CSUM","MTU","MAC","HOST_TSO4","HOST_TSO6","STATUS","CTRL_VQ",\
> "MQ","CTRL_MAC_ADDR","VERSION_1","ACCESS_PLATFORM" ]
>          }
>      }
> }
>
> Signed-off-by: Eli Cohen <elic@nvidia.com>
> ---
>   vdpa/include/uapi/linux/vdpa.h |   2 +
>   vdpa/vdpa.c                    | 108 ++++++++++++++++++++++++++++++++-
>   2 files changed, 107 insertions(+), 3 deletions(-)
>
> diff --git a/vdpa/include/uapi/linux/vdpa.h b/vdpa/include/uapi/linux/vdpa.h
> index b7eab069988a..748c350450b2 100644
> --- a/vdpa/include/uapi/linux/vdpa.h
> +++ b/vdpa/include/uapi/linux/vdpa.h
> @@ -40,6 +40,8 @@ enum vdpa_attr {
>   	VDPA_ATTR_DEV_NET_CFG_MAX_VQP,		/* u16 */
>   	VDPA_ATTR_DEV_NET_CFG_MTU,		/* u16 */
>   
> +	VDPA_ATTR_DEV_NEGOTIATED_FEATURES,	/* u64 */
> +
>   	/* new attributes must be added above here */
>   	VDPA_ATTR_MAX,
>   };
> diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
> index 4ccb564872a0..f60e647b8cf8 100644
> --- a/vdpa/vdpa.c
> +++ b/vdpa/vdpa.c
> @@ -10,6 +10,8 @@
>   #include <linux/virtio_net.h>
>   #include <linux/netlink.h>
>   #include <libmnl/libmnl.h>
> +#include <linux/virtio_ring.h>
> +#include <linux/virtio_config.h>
>   #include "mnl_utils.h"
>   #include <rt_names.h>
>   
> @@ -78,6 +80,7 @@ static const enum mnl_attr_data_type vdpa_policy[VDPA_ATTR_MAX + 1] = {
>   	[VDPA_ATTR_DEV_VENDOR_ID] = MNL_TYPE_U32,
>   	[VDPA_ATTR_DEV_MAX_VQS] = MNL_TYPE_U32,
>   	[VDPA_ATTR_DEV_MAX_VQ_SIZE] = MNL_TYPE_U16,
> +	[VDPA_ATTR_DEV_NEGOTIATED_FEATURES] = MNL_TYPE_U64,
>   };
>   
>   static int attr_cb(const struct nlattr *attr, void *data)
> @@ -385,6 +388,96 @@ static const char *parse_class(int num)
>   	return class ? class : "< unknown class >";
>   }
>   
> +static const char * const net_feature_strs[64] = {
> +	[VIRTIO_NET_F_CSUM] = "CSUM",
> +	[VIRTIO_NET_F_GUEST_CSUM] = "GUEST_CSUM",
> +	[VIRTIO_NET_F_CTRL_GUEST_OFFLOADS] = "CTRL_GUEST_OFFLOADS",
> +	[VIRTIO_NET_F_MTU] = "MTU",
> +	[VIRTIO_NET_F_MAC] = "MAC",
> +	[VIRTIO_NET_F_GUEST_TSO4] = "GUEST_TSO4",
> +	[VIRTIO_NET_F_GUEST_TSO6] = "GUEST_TSO6",
> +	[VIRTIO_NET_F_GUEST_ECN] = "GUEST_ECN",
> +	[VIRTIO_NET_F_GUEST_UFO] = "GUEST_UFO",
> +	[VIRTIO_NET_F_HOST_TSO4] = "HOST_TSO4",
> +	[VIRTIO_NET_F_HOST_TSO6] = "HOST_TSO6",
> +	[VIRTIO_NET_F_HOST_ECN] = "HOST_ECN",
> +	[VIRTIO_NET_F_HOST_UFO] = "HOST_UFO",
> +	[VIRTIO_NET_F_MRG_RXBUF] = "MRG_RXBUF",
> +	[VIRTIO_NET_F_STATUS] = "STATUS",
> +	[VIRTIO_NET_F_CTRL_VQ] = "CTRL_VQ",
> +	[VIRTIO_NET_F_CTRL_RX] = "CTRL_RX",
> +	[VIRTIO_NET_F_CTRL_VLAN] = "CTRL_VLAN",
> +	[VIRTIO_NET_F_CTRL_RX_EXTRA] = "CTRL_RX_EXTRA",
> +	[VIRTIO_NET_F_GUEST_ANNOUNCE] = "GUEST_ANNOUNCE",
> +	[VIRTIO_NET_F_MQ] = "MQ",
> +	[VIRTIO_F_NOTIFY_ON_EMPTY] = "NOTIFY_ON_EMPTY",
> +	[VIRTIO_NET_F_CTRL_MAC_ADDR] = "CTRL_MAC_ADDR",
> +	[VIRTIO_F_ANY_LAYOUT] = "ANY_LAYOUT",
> +	[VIRTIO_NET_F_RSC_EXT] = "RSC_EXT",
> +	[VIRTIO_NET_F_HASH_REPORT] = "HASH_REPORT",
> +	[VIRTIO_NET_F_RSS] = "RSS",
> +	[VIRTIO_NET_F_STANDBY] = "STANDBY",
> +	[VIRTIO_NET_F_SPEED_DUPLEX] = "SPEED_DUPLEX",
> +};
> +
> +#define VIRTIO_F_IN_ORDER 35
> +#define VIRTIO_F_NOTIFICATION_DATA 38
> +#define VDPA_EXT_FEATURES_SZ (VIRTIO_TRANSPORT_F_END - \
> +			      VIRTIO_TRANSPORT_F_START + 1)
> +
> +static const char * const ext_feature_strs[VDPA_EXT_FEATURES_SZ] = {
> +	[VIRTIO_RING_F_INDIRECT_DESC - VIRTIO_TRANSPORT_F_START] = "RING_INDIRECT_DESC",
> +	[VIRTIO_RING_F_EVENT_IDX - VIRTIO_TRANSPORT_F_START] = "RING_EVENT_IDX",
> +	[VIRTIO_F_VERSION_1 - VIRTIO_TRANSPORT_F_START] = "VERSION_1",
> +	[VIRTIO_F_ACCESS_PLATFORM - VIRTIO_TRANSPORT_F_START] = "ACCESS_PLATFORM",
> +	[VIRTIO_F_RING_PACKED - VIRTIO_TRANSPORT_F_START] = "RING_PACKED",
> +	[VIRTIO_F_IN_ORDER - VIRTIO_TRANSPORT_F_START] = "IN_ORDER",
> +	[VIRTIO_F_ORDER_PLATFORM - VIRTIO_TRANSPORT_F_START] = "ORDER_PLATFORM",
> +	[VIRTIO_F_SR_IOV - VIRTIO_TRANSPORT_F_START] = "SR_IOV",
> +	[VIRTIO_F_NOTIFICATION_DATA - VIRTIO_TRANSPORT_F_START] = "NOTIFICATION_DATA",
> +};
> +
> +static const char * const *dev_to_feature_str[] = {
> +	[VIRTIO_ID_NET] = net_feature_strs,
> +};
> +
> +static void print_features(struct vdpa *vdpa, uint64_t features, bool mgmtdevf,
> +			   uint16_t dev_id)
> +{
> +	const char * const *feature_strs = NULL;
> +	const char *s;
> +	int i;
> +
> +	if (dev_id < ARRAY_SIZE(dev_to_feature_str))
> +		feature_strs = dev_to_feature_str[dev_id];
> +
> +	if (mgmtdevf)
> +		pr_out_array_start(vdpa, "dev_features");
> +	else
> +		pr_out_array_start(vdpa, "negotiated_features");
> +
> +	for (i = 0; i < 64; i++) {
> +		if (!(features & (1ULL << i)))
> +			continue;
> +
> +		if (i < VIRTIO_TRANSPORT_F_START || i > VIRTIO_TRANSPORT_F_END) {
> +			if (feature_strs) {
> +				s = feature_strs[i];
> +			} else {
> +				s = NULL;
> +			}
> +		} else {
> +			s = ext_feature_strs[i - VIRTIO_TRANSPORT_F_START];
> +		}
> +		if (!s)
> +			print_uint(PRINT_ANY, NULL, " bit_%d", i);
> +		else
> +			print_string(PRINT_ANY, NULL, " %s", s);
> +	}
> +
> +	pr_out_array_end(vdpa);
> +}
> +
>   static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
>   				struct nlattr **tb)
>   {
> @@ -395,7 +488,6 @@ static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
>   
>   	if (tb[VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES]) {
>   		uint64_t classes = mnl_attr_get_u64(tb[VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES]);
> -


Unnecessary changes.


>   		pr_out_array_start(vdpa, "supported_classes");
>   
>   		for (i = 1; i < 64; i++) {
> @@ -579,9 +671,10 @@ static int cmd_dev_del(struct vdpa *vdpa,  int argc, char **argv)
>   	return mnlu_gen_socket_sndrcv(&vdpa->nlg, nlh, NULL, NULL);
>   }
>   
> -static void pr_out_dev_net_config(struct nlattr **tb)
> +static void pr_out_dev_net_config(struct vdpa *vdpa, struct nlattr **tb)
>   {
>   	SPRINT_BUF(macaddr);
> +	uint64_t val_u64;
>   	uint16_t val_u16;
>   
>   	if (tb[VDPA_ATTR_DEV_NET_CFG_MACADDR]) {
> @@ -610,6 +703,15 @@ static void pr_out_dev_net_config(struct nlattr **tb)
>   		val_u16 = mnl_attr_get_u16(tb[VDPA_ATTR_DEV_NET_CFG_MTU]);
>   		print_uint(PRINT_ANY, "mtu", "mtu %d ", val_u16);
>   	}
> +	if (tb[VDPA_ATTR_DEV_NEGOTIATED_FEATURES]) {
> +		uint16_t dev_id = 0;
> +
> +		if (tb[VDPA_ATTR_DEV_ID])
> +			dev_id = mnl_attr_get_u32(tb[VDPA_ATTR_DEV_ID]);
> +
> +		val_u64 = mnl_attr_get_u64(tb[VDPA_ATTR_DEV_NEGOTIATED_FEATURES]);
> +		print_features(vdpa, val_u64, false, dev_id);
> +	}
>   }
>   
>   static void pr_out_dev_config(struct vdpa *vdpa, struct nlattr **tb)
> @@ -619,7 +721,7 @@ static void pr_out_dev_config(struct vdpa *vdpa, struct nlattr **tb)
>   	pr_out_vdev_handle_start(vdpa, tb);
>   	switch (device_id) {
>   	case VIRTIO_ID_NET:
> -		pr_out_dev_net_config(tb);
> +		pr_out_dev_net_config(vdpa, tb);
>   		break;
>   	default:


I wonder if we need a warning here.

Otherwise looks good to me.

Thanks


>   		break;

