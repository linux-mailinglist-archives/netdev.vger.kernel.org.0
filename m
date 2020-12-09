Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A5E2D3809
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 01:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbgLIA6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 19:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgLIA6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 19:58:30 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84961C0613CF
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 16:57:49 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id f16so594624otl.11
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 16:57:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=d+Ta5VhLflN8h9c0mJTQ91PYg0td3FMkdI9L8EOZ3ok=;
        b=UikNsFk1ugdHry+y5Y7UiKY5rYaebyhgA3SgpeISNYd66jL4EQDu8k57diO3NaBKJL
         EDpG0cwv9YkJVVCfhAMANcEOxYoR4yay7HHYlRIOo1LfVWSUvSDYyf5+oXqQ9UJoP7zT
         ruM1E4NonBIs/nyKoFzsiLMuDzQvTv+4jZTd+0+vOqgl55Fo1neNCeT3+wK3dW2YvU8d
         CBcNM5Indap0ChOuvex9aBAfcirYG/lCYwqScfvqx8Zz6ijwUYO57Mq83kj/ZXfiGUIe
         LzK0GyFy9ECxCewCgUXKXeTlYCz7nXcbudC7+DSdOYk/H3lyBzkF7u/c86YBuf3y4W61
         dcMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d+Ta5VhLflN8h9c0mJTQ91PYg0td3FMkdI9L8EOZ3ok=;
        b=HI7PIzoB2Usr2ta6qb2Kx49clVakO7Qrayr9Rza2q87H2VlxMoFPM1tGWPY4xXcmT3
         Be6qsHD4ENulBNe59kjNGpc8O2SC3OWHY4kn5+9tM1ki+5zhy4wO+aXSxI/DWL+O8TRr
         yDaJ4nQ3KYAang1KVNKnVHcdokLkzQQ6rtUvizKQ825f+2VjeXD6Fb0cLDMLV9y+qbyK
         H6b3Al/f8JZ6UIo7JQ2sD5/tsjEtwJGNV4Bkz1c2XEFXHHLMH1x/QBACpbE8eNnATRhz
         qGgsnoUBu3/GtkQWonU2egEwuKm7oBdQCbUnofwYjBfD5Ugqx6dYIYAyRIIQ7mzckYHv
         XK4g==
X-Gm-Message-State: AOAM533h8pX3Bro4AYyYSKqb6EdNfZukkS2af4znEiEqa6SquFV9qJ4K
        3QcWqnfnHdd+nye+rnxfG/c=
X-Google-Smtp-Source: ABdhPJzQIfe8s+f3XV6ymAucoUBMBOAzmKH5CfjY17MNs4ZAjgrqGgTsXE6hLniur+CUVTqTzbK2fw==
X-Received: by 2002:a9d:d31:: with SMTP id 46mr658318oti.1.1607475468900;
        Tue, 08 Dec 2020 16:57:48 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:64fc:adeb:84f9:fa62])
        by smtp.googlemail.com with ESMTPSA id r12sm163751ooo.25.2020.12.08.16.57.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 16:57:48 -0800 (PST)
Subject: Re: [PATCH v1 net-next 02/15] net: Introduce direct data placement
 tcp offload
To:     Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de,
        sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
References: <20201207210649.19194-1-borisp@mellanox.com>
 <20201207210649.19194-3-borisp@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <824e3bea-60d2-5a4d-e8ce-770d70f0ba37@gmail.com>
Date:   Tue, 8 Dec 2020 17:57:46 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201207210649.19194-3-borisp@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/7/20 2:06 PM, Boris Pismenny wrote:
> diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
> index 934de56644e7..fb35dcac03d2 100644
> --- a/include/linux/netdev_features.h
> +++ b/include/linux/netdev_features.h
> @@ -84,6 +84,7 @@ enum {
>  	NETIF_F_GRO_FRAGLIST_BIT,	/* Fraglist GRO */
>  
>  	NETIF_F_HW_MACSEC_BIT,		/* Offload MACsec operations */
> +	NETIF_F_HW_TCP_DDP_BIT,		/* TCP direct data placement offload */
>  
>  	/*
>  	 * Add your fresh new feature above and remember to update
> @@ -157,6 +158,7 @@ enum {
>  #define NETIF_F_GRO_FRAGLIST	__NETIF_F(GRO_FRAGLIST)
>  #define NETIF_F_GSO_FRAGLIST	__NETIF_F(GSO_FRAGLIST)
>  #define NETIF_F_HW_MACSEC	__NETIF_F(HW_MACSEC)
> +#define NETIF_F_HW_TCP_DDP	__NETIF_F(HW_TCP_DDP)

All of the DDP naming seems wrong to me. I realize the specific use case
is targeted payloads of a ULP, but it is still S/W handing H/W specific
buffers for a payload of a flow.


>  
>  /* Finds the next feature with the highest number of the range of start till 0.
>   */
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index a07c8e431f45..755766976408 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -934,6 +934,7 @@ struct dev_ifalias {
>  
>  struct devlink;
>  struct tlsdev_ops;
> +struct tcp_ddp_dev_ops;
>  
>  struct netdev_name_node {
>  	struct hlist_node hlist;
> @@ -1930,6 +1931,10 @@ struct net_device {
>  	const struct tlsdev_ops *tlsdev_ops;
>  #endif
>  
> +#ifdef CONFIG_TCP_DDP
> +	const struct tcp_ddp_dev_ops *tcp_ddp_ops;
> +#endif
> +
>  	const struct header_ops *header_ops;
>  
>  	unsigned int		flags;
> diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
> index 7338b3865a2a..a08b85b53aa8 100644
> --- a/include/net/inet_connection_sock.h
> +++ b/include/net/inet_connection_sock.h
> @@ -66,6 +66,8 @@ struct inet_connection_sock_af_ops {
>   * @icsk_ulp_ops	   Pluggable ULP control hook
>   * @icsk_ulp_data	   ULP private data
>   * @icsk_clean_acked	   Clean acked data hook
> + * @icsk_ulp_ddp_ops	   Pluggable ULP direct data placement control hook
> + * @icsk_ulp_ddp_data	   ULP direct data placement private data

Neither of these socket layer intrusions are needed. All references but
1 -- the skbuff check -- are in the mlx5 driver. Any skb check that is
needed can be handled with a different setting.

>   * @icsk_listen_portaddr_node	hash to the portaddr listener hashtable
>   * @icsk_ca_state:	   Congestion control state
>   * @icsk_retransmits:	   Number of unrecovered [RTO] timeouts
> @@ -94,6 +96,8 @@ struct inet_connection_sock {
>  	const struct tcp_ulp_ops  *icsk_ulp_ops;
>  	void __rcu		  *icsk_ulp_data;
>  	void (*icsk_clean_acked)(struct sock *sk, u32 acked_seq);
> +	const struct tcp_ddp_ulp_ops  *icsk_ulp_ddp_ops;
> +	void __rcu		  *icsk_ulp_ddp_data;
>  	struct hlist_node         icsk_listen_portaddr_node;
>  	unsigned int		  (*icsk_sync_mss)(struct sock *sk, u32 pmtu);
>  	__u8			  icsk_ca_state:5,
> diff --git a/include/net/tcp_ddp.h b/include/net/tcp_ddp.h
> new file mode 100644
> index 000000000000..df3264be4600
> --- /dev/null
> +++ b/include/net/tcp_ddp.h
> @@ -0,0 +1,129 @@
> +/* SPDX-License-Identifier: GPL-2.0
> + *
> + * tcp_ddp.h
> + *	Author:	Boris Pismenny <borisp@mellanox.com>
> + *	Copyright (C) 2020 Mellanox Technologies.
> + */
> +#ifndef _TCP_DDP_H
> +#define _TCP_DDP_H
> +
> +#include <linux/netdevice.h>
> +#include <net/inet_connection_sock.h>
> +#include <net/sock.h>
> +
> +/* limits returned by the offload driver, zero means don't care */
> +struct tcp_ddp_limits {
> +	int	 max_ddp_sgl_len;
> +};
> +
> +enum tcp_ddp_type {
> +	TCP_DDP_NVME = 1,
> +};
> +
> +/**
> + * struct tcp_ddp_config - Generic tcp ddp configuration: tcp ddp IO queue
> + * config implementations must use this as the first member.
> + * Add new instances of tcp_ddp_config below (nvme-tcp, etc.).
> + */
> +struct tcp_ddp_config {
> +	enum tcp_ddp_type    type;
> +	unsigned char        buf[];

you have this variable length buf, but it is not used (as far as I can
tell). But then ...


> +};
> +
> +/**
> + * struct nvme_tcp_ddp_config - nvme tcp ddp configuration for an IO queue
> + *
> + * @pfv:        pdu version (e.g., NVME_TCP_PFV_1_0)
> + * @cpda:       controller pdu data alignmend (dwords, 0's based)
> + * @dgst:       digest types enabled.
> + *              The netdev will offload crc if ddp_crc is supported.
> + * @queue_size: number of nvme-tcp IO queue elements
> + * @queue_id:   queue identifier
> + * @cpu_io:     cpu core running the IO thread for this queue
> + */
> +struct nvme_tcp_ddp_config {
> +	struct tcp_ddp_config   cfg;

... how would you use it within another struct like this?

> +
> +	u16			pfv;
> +	u8			cpda;
> +	u8			dgst;
> +	int			queue_size;
> +	int			queue_id;
> +	int			io_cpu;
> +};
> +
> +/**
> + * struct tcp_ddp_io - tcp ddp configuration for an IO request.
> + *
> + * @command_id:  identifier on the wire associated with these buffers
> + * @nents:       number of entries in the sg_table
> + * @sg_table:    describing the buffers for this IO request
> + * @first_sgl:   first SGL in sg_table
> + */
> +struct tcp_ddp_io {
> +	u32			command_id;
> +	int			nents;
> +	struct sg_table		sg_table;
> +	struct scatterlist	first_sgl[SG_CHUNK_SIZE];
> +};
> +
> +/* struct tcp_ddp_dev_ops - operations used by an upper layer protocol to configure ddp offload
> + *
> + * @tcp_ddp_limits:    limit the number of scatter gather entries per IO.
> + *                     the device driver can use this to limit the resources allocated per queue.
> + * @tcp_ddp_sk_add:    add offload for the queue represennted by the socket+config pair.
> + *                     this function is used to configure either copy, crc or both offloads.
> + * @tcp_ddp_sk_del:    remove offload from the socket, and release any device related resources.
> + * @tcp_ddp_setup:     request copy offload for buffers associated with a command_id in tcp_ddp_io.
> + * @tcp_ddp_teardown:  release offload resources association between buffers and command_id in
> + *                     tcp_ddp_io.
> + * @tcp_ddp_resync:    respond to the driver's resync_request. Called only if resync is successful.
> + */
> +struct tcp_ddp_dev_ops {
> +	int (*tcp_ddp_limits)(struct net_device *netdev,
> +			      struct tcp_ddp_limits *limits);
> +	int (*tcp_ddp_sk_add)(struct net_device *netdev,
> +			      struct sock *sk,
> +			      struct tcp_ddp_config *config);
> +	void (*tcp_ddp_sk_del)(struct net_device *netdev,
> +			       struct sock *sk);
> +	int (*tcp_ddp_setup)(struct net_device *netdev,
> +			     struct sock *sk,
> +			     struct tcp_ddp_io *io);
> +	int (*tcp_ddp_teardown)(struct net_device *netdev,
> +				struct sock *sk,
> +				struct tcp_ddp_io *io,
> +				void *ddp_ctx);
> +	void (*tcp_ddp_resync)(struct net_device *netdev,
> +			       struct sock *sk, u32 seq);
> +};
> +
> +#define TCP_DDP_RESYNC_REQ (1 << 0)
> +
> +/**
> + * struct tcp_ddp_ulp_ops - Interface to register uppper layer Direct Data Placement (DDP) TCP offload
> + */
> +struct tcp_ddp_ulp_ops {
> +	/* NIC requests ulp to indicate if @seq is the start of a message */
> +	bool (*resync_request)(struct sock *sk, u32 seq, u32 flags);
> +	/* NIC driver informs the ulp that ddp teardown is done - used for async completions*/
> +	void (*ddp_teardown_done)(void *ddp_ctx);
> +};
> +
> +/**
> + * struct tcp_ddp_ctx - Generic tcp ddp context: device driver per queue contexts must
> + * use this as the first member.
> + */
> +struct tcp_ddp_ctx {
> +	enum tcp_ddp_type    type;
> +	unsigned char        buf[];

similar to my comment above, I did not see any uses of the buf element.




