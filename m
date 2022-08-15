Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7BC59327D
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 17:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbiHOPwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 11:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiHOPwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 11:52:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ECCB117077
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 08:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660578767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/Nqcs8aa7/L83Uz8Dknl+flwCz9c6FCbM8IP+tpiszM=;
        b=LJV0rGhk8+m1VfBz1ftBaZDSIud14xwNc7ZzRJBKvi19YB3pahEWHmK4SRNzEgoKlt8b97
        cbgLG4nHvHwZ/7g36jPbWm/a3SYeMMjLqvEEaN40DTZan3VbbVUAKTdNCAw3VXrEAza5G2
        7aBsz5tcWzUZgCVm2f+//XZ1k/w7bQc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-611-FHYvPShnMuaqSYTzzwaBnw-1; Mon, 15 Aug 2022 11:52:46 -0400
X-MC-Unique: FHYvPShnMuaqSYTzzwaBnw-1
Received: by mail-ed1-f71.google.com with SMTP id g8-20020a056402424800b0043e81c582a4so4987242edb.17
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 08:52:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=/Nqcs8aa7/L83Uz8Dknl+flwCz9c6FCbM8IP+tpiszM=;
        b=8HmFmwVxePCPFQYthNT24e99NIYVMcyzz/D1WlC/EvFcY1YaNh99fZtmMdpJEW6Nw1
         GDM7tUNDYrkFgOs9NvwXX2+9lL79eKckG9aNZcvDV7GFEZWQUpt10BbYRzf+CYLCluWf
         shoACFjbN4JCLWbqgVVJ3664HWfiieDeTt4mOvEI34TqvJzEUjmdGw7E+BXmKUF8lq3M
         W9IyTqARg+xyBNNs+SomZ/Iwh7l/wK1Jkd3tlDiQQ0ru+SzB0Z0yExExzp4w7tKOFec+
         DD5JAh8jU6I4r/CVrY8dJf0L9vUb5JkQH7Nd/c2BwREAIcoeStnadslpO5iyyvPrxc7v
         aetA==
X-Gm-Message-State: ACgBeo07pwIZT4WeeIk3afkCtXxJo5GriGqP+zXYrswo24F1ZtdGGfYX
        WfGrsF+YJonHu9TTDKQj7PcOQ7dX/0REBme5VX+YQj78Xh7sNnauyIYFN0QuDkfPI1r1LJkFiX2
        IiimH8NZnkUP7elRe
X-Received: by 2002:aa7:d292:0:b0:43d:7923:66cd with SMTP id w18-20020aa7d292000000b0043d792366cdmr14420714edq.403.1660578765282;
        Mon, 15 Aug 2022 08:52:45 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6nIFBB+89khXDcKZ1x+E5GSpuggmwuIXVyMYifWU71qMF4gZFv0oZKWPNyImccf4QH1VsZkQ==
X-Received: by 2002:aa7:d292:0:b0:43d:7923:66cd with SMTP id w18-20020aa7d292000000b0043d792366cdmr14420699edq.403.1660578765066;
        Mon, 15 Aug 2022 08:52:45 -0700 (PDT)
Received: from redhat.com ([2.54.169.49])
        by smtp.gmail.com with ESMTPSA id z28-20020a17090674dc00b00734bfab4d64sm4157408ejl.25.2022.08.15.08.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 08:52:44 -0700 (PDT)
Date:   Mon, 15 Aug 2022 11:52:40 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org, parav@nvidia.com,
        xieyongji@bytedance.com, gautam.dawar@amd.com
Subject: Re: [PATCH 2/2] vDPA: conditionally read fields in virtio-net dev
Message-ID: <20220815114900-mutt-send-email-mst@kernel.org>
References: <20220815092638.504528-1-lingshan.zhu@intel.com>
 <20220815092638.504528-3-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220815092638.504528-3-lingshan.zhu@intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 05:26:38PM +0800, Zhu Lingshan wrote:
> Some fields of virtio-net device config space are
> conditional on the feature bits, the spec says:
> 
> "The mac address field always exists
> (though is only valid if VIRTIO_NET_F_MAC is set)"
> 
> "max_virtqueue_pairs only exists if VIRTIO_NET_F_MQ
> or VIRTIO_NET_F_RSS is set"
> 
> "mtu only exists if VIRTIO_NET_F_MTU is set"
> 
> so we should read MTU, MAC and MQ in the device config
> space only when these feature bits are offered.
> 
> For MQ, if both VIRTIO_NET_F_MQ and VIRTIO_NET_F_RSS are
> not set, the virtio device should have
> one queue pair as default value, so when userspace querying queue pair numbers,
> it should return mq=1 than zero.
> 
> For MTU, if VIRTIO_NET_F_MTU is not set, we should not read
> MTU from the device config sapce.
> RFC894 <A Standard for the Transmission of IP Datagrams over Ethernet Networks>
> says:"The minimum length of the data field of a packet sent over an
> Ethernet is 1500 octets, thus the maximum length of an IP datagram
> sent over an Ethernet is 1500 octets.  Implementations are encouraged
> to support full-length packets"
> 
> virtio spec says:"The virtio network device is a virtual ethernet card",
> so the default MTU value should be 1500 for virtio-net.
> 
> For MAC, the spec says:"If the VIRTIO_NET_F_MAC feature bit is set,
> the configuration space mac entry indicates the “physical” address
> of the network card, otherwise the driver would typically
> generate a random local MAC address." So there is no
> default MAC address if VIRTIO_NET_F_MAC not set.
> 
> This commits introduces functions vdpa_dev_net_mtu_config_fill()
> and vdpa_dev_net_mac_config_fill() to fill MTU and MAC.
> It also fixes vdpa_dev_net_mq_config_fill() to report correct
> MQ when _F_MQ is not present.
> 
> These functions should check devices features than driver
> features, and struct vdpa_device is not needed as a parameter
> 
> The test & userspace tool output:
> 
> Feature bit VIRTIO_NET_F_MTU, VIRTIO_NET_F_RSS, VIRTIO_NET_F_MQ
> and VIRTIO_NET_F_MAC can be mask out by hardcode.
> 
> However, it is challenging to "disable" the related fields
> in the HW device config space, so let's just assume the values
> are meaningless if the feature bits are not set.
> 
> Before this change, when feature bits for RSS, MQ, MTU and MAC
> are not set, iproute2 output:
> $vdpa vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false mtu 1500
>   negotiated_features

where does it get 1500? what if there's e.g. 0 in the mtu field?

> without this commit, function vdpa_dev_net_config_fill()
> reads all config space fields unconditionally, so let's
> assume the MAC and MTU are meaningless, and it checks
> MQ with driver_features, so we don't see max_vq_pairs.
> 
> After applying this commit, when feature bits for
> MQ, RSS, MAC and MTU are not set,iproute2 output:
> $vdpa dev config show vdpa0
> vdpa0: link up link_announce false max_vq_pairs 1 mtu 1500
>   negotiated_features
> 
> As explained above:
> Here is no MAC, because VIRTIO_NET_F_MAC is not set,
> and there is no default value for MAC. It shows
> max_vq_paris = 1 because even without MQ feature,
> a functional virtio-net must have one queue pair.
> mtu = 1500 is the default value as ethernet
> required.
> 
> This commit also add supplementary comments for
> __virtio16_to_cpu(true, xxx) operations in
> vdpa_dev_net_config_fill() and vdpa_fill_stats_rec()
> 
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  drivers/vdpa/vdpa.c | 60 +++++++++++++++++++++++++++++++++++----------
>  1 file changed, 47 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> index efb55a06e961..a74660b98979 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -801,19 +801,44 @@ static int vdpa_nl_cmd_dev_get_dumpit(struct sk_buff *msg, struct netlink_callba
>  	return msg->len;
>  }
>  
> -static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
> -				       struct sk_buff *msg, u64 features,
> +static int vdpa_dev_net_mq_config_fill(struct sk_buff *msg, u64 features,
>  				       const struct virtio_net_config *config)
>  {
>  	u16 val_u16;
>  
> -	if ((features & BIT_ULL(VIRTIO_NET_F_MQ)) == 0)
> -		return 0;
> +	if ((features & BIT_ULL(VIRTIO_NET_F_MQ)) == 0 &&
> +	    (features & BIT_ULL(VIRTIO_NET_F_RSS)) == 0)
> +		val_u16 = 1;
> +	else
> +		val_u16 = __virtio16_to_cpu(true, config->max_virtqueue_pairs);
>  
> -	val_u16 = le16_to_cpu(config->max_virtqueue_pairs);
>  	return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, val_u16);
>  }
>  
> +static int vdpa_dev_net_mtu_config_fill(struct sk_buff *msg, u64 features,
> +					const struct virtio_net_config *config)
> +{
> +	u16 val_u16;
> +
> +	if ((features & BIT_ULL(VIRTIO_NET_F_MTU)) == 0)
> +		val_u16 = 1500;
> +	else
> +		val_u16 = __virtio16_to_cpu(true, config->mtu);
> +
> +	return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16);
> +}
> +
> +static int vdpa_dev_net_mac_config_fill(struct sk_buff *msg, u64 features,
> +					const struct virtio_net_config *config)
> +{
> +	if ((features & BIT_ULL(VIRTIO_NET_F_MAC)) == 0)
> +		return 0;
> +	else
> +		return  nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR,
> +				sizeof(config->mac), config->mac);
> +}
> +
> +
>  static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *msg)
>  {
>  	struct virtio_net_config config = {};
> @@ -822,18 +847,16 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>  
>  	vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
>  
> -	if (nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR, sizeof(config.mac),
> -		    config.mac))
> -		return -EMSGSIZE;
> +	/*
> +	 * Assume little endian for now, userspace can tweak this for
> +	 * legacy guest support.
> +	 */
> +	val_u16 = __virtio16_to_cpu(true, config.status);
>  
>  	val_u16 = __virtio16_to_cpu(true, config.status);
>  	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
>  		return -EMSGSIZE;
>  
> -	val_u16 = __virtio16_to_cpu(true, config.mtu);
> -	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
> -		return -EMSGSIZE;
> -
>  	features_driver = vdev->config->get_driver_features(vdev);
>  	if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
>  			      VDPA_ATTR_PAD))
> @@ -846,7 +869,13 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>  			      VDPA_ATTR_PAD))
>  		return -EMSGSIZE;
>  
> -	return vdpa_dev_net_mq_config_fill(vdev, msg, features_driver, &config);
> +	if (vdpa_dev_net_mac_config_fill(msg, features_device, &config))
> +		return -EMSGSIZE;
> +
> +	if (vdpa_dev_net_mtu_config_fill(msg, features_device, &config))
> +		return -EMSGSIZE;
> +
> +	return vdpa_dev_net_mq_config_fill(msg, features_device, &config);
>  }
>  
>  static int
> @@ -914,6 +943,11 @@ static int vdpa_fill_stats_rec(struct vdpa_device *vdev, struct sk_buff *msg,
>  	}
>  	vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
>  
> +	/*
> +	 * Assume little endian for now, userspace can tweak this for
> +	 * legacy guest support.
> +	 */
> +
>  	max_vqp = __virtio16_to_cpu(true, config.max_virtqueue_pairs);
>  	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, max_vqp))
>  		return -EMSGSIZE;
> -- 
> 2.31.1

