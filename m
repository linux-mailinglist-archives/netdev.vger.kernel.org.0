Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B98BE60D73F
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 00:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbiJYWjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 18:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232471AbiJYWjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 18:39:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39DB1F9E0
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 15:39:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDBC8B81F4D
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 22:39:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1FF3C433D6;
        Tue, 25 Oct 2022 22:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666737567;
        bh=AoyyzEpnw+t2R29yjb3Gs/q5K+EEtgxfzfWYQ8Eg0H8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=INBfO1fWQAshPScb6xwVOFbgzjSajHIINoGcfavL7C66A1YvuVwiijdTmdj6gHkBx
         kSPwtbSP5xEPY47NThEFHzUFjnMD8JxCpFbVZbi4xMOihHJ0e4/zXVZkfe4Tt6QBw5
         umGQuv1AJz0B6634FMxgOt/E5xRa4q22GorC3vW+DOg9PisH7FP+XWlIjGGzg/jJkC
         Ci0Z4n6qVd+Kk7ZuMKED5kYyc0DmubkwWOn6oJuOAuDjkUvpO4S+A7L7umKmC4b6ZE
         YFv4RC4TJT/J2UI7gFl6HS0wwYQ/hYCEQ7DVIOf85JNCUobz3AkeJj9KHIjCgseKlE
         WlQNojUuhX3wA==
Date:   Tue, 25 Oct 2022 15:39:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aurelien Aptel <aaptel@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, saeedm@nvidia.com, tariqt@nvidia.com,
        leon@kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me,
        hch@lst.de, kbusch@kernel.org, axboe@fb.com, chaitanyak@nvidia.com,
        smalin@nvidia.com, ogerlitz@nvidia.com, yorayz@nvidia.com,
        borisp@nvidia.com, aurelien.aptel@gmail.com, malin1024@gmail.com
Subject: Re: [PATCH v7 01/23] net: Introduce direct data placement tcp
 offload
Message-ID: <20221025153925.64b5b040@kernel.org>
In-Reply-To: <20221025135958.6242-2-aaptel@nvidia.com>
References: <20221025135958.6242-1-aaptel@nvidia.com>
        <20221025135958.6242-2-aaptel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Oct 2022 16:59:36 +0300 Aurelien Aptel wrote:
> diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
> index 7c2d77d75a88..bf7391aa04c7 100644
> --- a/include/linux/netdev_features.h
> +++ b/include/linux/netdev_features.h
> @@ -14,7 +14,7 @@ typedef u64 netdev_features_t;
>  enum {
>  	NETIF_F_SG_BIT,			/* Scatter/gather IO. */
>  	NETIF_F_IP_CSUM_BIT,		/* Can checksum TCP/UDP over IPv4. */
> -	__UNUSED_NETIF_F_1,
> +	NETIF_F_HW_ULP_DDP_BIT,         /* ULP direct data placement offload */

Why do you need a feature bit if there is a whole caps / limit querying
mechanism? 

>  	NETIF_F_HW_CSUM_BIT,		/* Can checksum all the packets. */
>  	NETIF_F_IPV6_CSUM_BIT,		/* Can checksum TCP/UDP over IPV6 */
>  	NETIF_F_HIGHDMA_BIT,		/* Can DMA to high memory. */
> @@ -168,6 +168,7 @@ enum {
>  #define NETIF_F_HW_HSR_TAG_RM	__NETIF_F(HW_HSR_TAG_RM)
>  #define NETIF_F_HW_HSR_FWD	__NETIF_F(HW_HSR_FWD)
>  #define NETIF_F_HW_HSR_DUP	__NETIF_F(HW_HSR_DUP)
> +#define NETIF_F_HW_ULP_DDP	__NETIF_F(HW_ULP_DDP)
>  
>  /* Finds the next feature with the highest number of the range of start-1 till 0.
>   */
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index eddf8ee270e7..84554f26ad6b 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1043,6 +1043,7 @@ struct dev_ifalias {
>  
>  struct devlink;
>  struct tlsdev_ops;
> +struct ulp_ddp_dev_ops;

I thought forward declarations are not required for struct members, 
are they?

>  struct netdev_net_notifier {
>  	struct list_head list;
> @@ -2096,6 +2097,10 @@ struct net_device {
>  	const struct tlsdev_ops *tlsdev_ops;
>  #endif
>  
> +#if IS_ENABLED(CONFIG_ULP_DDP)
> +	const struct ulp_ddp_dev_ops *ulp_ddp_ops;
> +#endif

It's somewhat unclear to me why we add ops to struct net_device,
rather than to ops.. can you explain?

>  	const struct header_ops *header_ops;
>  
>  	unsigned char		operstate;

> +#include <linux/netdevice.h>
> +#include <net/inet_connection_sock.h>
> +#include <net/sock.h>
> +
> +enum ulp_ddp_type {
> +	ULP_DDP_NVME = 1,

I think the DDP and the NVME parts should have more separation.

Are you planning to implement pure TCP placement, without NIC trying 
to also "add value" by processing whatever TCP is carrying.

Can you split the DDP and NVME harder in the API, somehow?

> +};
> +
> +enum ulp_ddp_offload_capabilities {
> +	ULP_DDP_C_NVME_TCP = 1,
> +	ULP_DDP_C_NVME_TCP_DDGST_RX = 2,
> +};
> +
> +/**
> + * struct ulp_ddp_limits - Generic ulp ddp limits: tcp ddp
> + * protocol limits.
> + * Protocol implementations must use this as the first member.
> + * Add new instances of ulp_ddp_limits below (nvme-tcp, etc.).
> + *
> + * @type:		type of this limits struct
> + * @offload_capabilities:bitmask of supported offload types
> + * @max_ddp_sgl_len:	maximum sgl size supported (zero means no limit)
> + * @io_threshold:	minimum payload size required to offload
> + * @buf:		protocol-specific limits struct (if any)
> + */
> +struct ulp_ddp_limits {

Why is this called limits not capabilities / caps?

> +	enum ulp_ddp_type	type;
> +	u64			offload_capabilities;
> +	int			max_ddp_sgl_len;
> +	int			io_threshold;
> +	unsigned char		buf[];

Just put a union of all the protos here.

> +};
> +
> +/**
> + * struct nvme_tcp_ddp_limits - nvme tcp driver limitations
> + *
> + * @lmt:		generic ULP limits struct
> + * @full_ccid_range:	true if the driver supports the full CID range
> + */
> +struct nvme_tcp_ddp_limits {
> +	struct ulp_ddp_limits	lmt;
> +
> +	bool			full_ccid_range;
> +};

> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 0640453fce54..df37db420110 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -5233,6 +5233,10 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
>  		memcpy(nskb->cb, skb->cb, sizeof(skb->cb));
>  #ifdef CONFIG_TLS_DEVICE
>  		nskb->decrypted = skb->decrypted;
> +#endif
> +#ifdef CONFIG_ULP_DDP
> +		nskb->ulp_ddp = skb->ulp_ddp;
> +		nskb->ulp_crc = skb->ulp_crc;
>  #endif
>  		TCP_SKB_CB(nskb)->seq = TCP_SKB_CB(nskb)->end_seq = start;
>  		if (list)
> @@ -5266,6 +5270,10 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
>  #ifdef CONFIG_TLS_DEVICE
>  				if (skb->decrypted != nskb->decrypted)
>  					goto end;
> +#endif
> +#ifdef CONFIG_ULP_DDP

no ifdef needed

> +				if (skb_is_ulp_crc(skb) != skb_is_ulp_crc(nskb))
> +					goto end;
>  #endif
>  			}
>  		}

