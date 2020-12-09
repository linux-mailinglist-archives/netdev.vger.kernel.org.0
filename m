Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9052D3D4C
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 09:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgLII0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 03:26:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbgLII0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 03:26:09 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65423C0613D6
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 00:25:28 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id lt17so868917ejb.3
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 00:25:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vObXydUW0UVv6YJ6tKDX5OM1cYwJwAuJ0yJUA+AFQUY=;
        b=HHipdgwlt3DObeEHboinNYqWVJczcegdmRMaVNWSO9ryVbP+v/jt4IsLW/QybAjabS
         EKcNbcSUo126naO5lErTnNN3V6RzMr30jK+nNXpFr42eh7uFglPp0QA0bsmoI+fEiQnf
         5GDZnvEFywwAJvaUo32Oy7+c6i6h5TpyAj07b4jk82YG1DNbthDROXBk5liuTgGVL+mo
         PuPbVe9PphmKGy7e33YBptyFgANaTO3GqkwbOAvLBPbHYwIeHxojbfE8xMTHqI7xVHDE
         vIVZYHGl6OgF1cdp2o8Mw2+B+5Sy+GQKPXdAH+m9V4MH0YiTV8czP6BwFwTjn6Bovrjz
         pVIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vObXydUW0UVv6YJ6tKDX5OM1cYwJwAuJ0yJUA+AFQUY=;
        b=FYL2OZNpLR8zjUuTxyPy3XX5BjlvQypRiEcRdtxylI4RqqlsKtAH2NGk4E1rAFWhJn
         9gnlEZxclPr+b8++HfzhSlCDnkadZjiJAyECtG+ExHh3mjHhXxOqqiaHPTFJ10LSjjo4
         4GKHMZVPw27WwFF0AiAZg4YtjDbaDQ3EEB2/mKWW4stT/0Q/OO1/w6rdVcD7jwzbWCXM
         3mrWVmFtA3+sm16sL+ydciQSNd1NOOV9RmRT1GenFytIvdqwgnyDcg3Y9kwpxCmsDEx7
         4Jwonqi4JKstXgyXhqOLSfmGfk99oI5aP2QVdjQi5+zUGf2mDbkMvbo7lqwauSaUFSgT
         AH0Q==
X-Gm-Message-State: AOAM532Wk7Nvs7pKzOq4FKLMS3ZJqwCRsKIop02KPhCHDbzga0zE8PB2
        RIia88VaODTjzovKzgvHQbQ=
X-Google-Smtp-Source: ABdhPJzbzd0VZ1AKGVp3uHTOs/2w4ISoZPe6jhUwtFpSsjdnwWHUv8PvL3iS4yQEwVG8Rx3Y03LwGw==
X-Received: by 2002:a17:907:9691:: with SMTP id hd17mr1074458ejc.306.1607502327107;
        Wed, 09 Dec 2020 00:25:27 -0800 (PST)
Received: from [132.68.43.153] ([132.68.43.153])
        by smtp.gmail.com with ESMTPSA id da9sm825367edb.84.2020.12.09.00.25.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Dec 2020 00:25:26 -0800 (PST)
Subject: Re: [PATCH v1 net-next 02/15] net: Introduce direct data placement
 tcp offload
To:     David Ahern <dsahern@gmail.com>,
        Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
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
 <824e3bea-60d2-5a4d-e8ce-770d70f0ba37@gmail.com>
From:   Boris Pismenny <borispismenny@gmail.com>
Message-ID: <a5de567b-c07e-d21b-318a-5d2a9e38045c@gmail.com>
Date:   Wed, 9 Dec 2020 10:25:24 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <824e3bea-60d2-5a4d-e8ce-770d70f0ba37@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 09/12/2020 2:57, David Ahern wrote:
> On 12/7/20 2:06 PM, Boris Pismenny wrote:
>> diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
>> index 934de56644e7..fb35dcac03d2 100644
>> --- a/include/linux/netdev_features.h
>> +++ b/include/linux/netdev_features.h
>> @@ -84,6 +84,7 @@ enum {
>>  	NETIF_F_GRO_FRAGLIST_BIT,	/* Fraglist GRO */
>>  
>>  	NETIF_F_HW_MACSEC_BIT,		/* Offload MACsec operations */
>> +	NETIF_F_HW_TCP_DDP_BIT,		/* TCP direct data placement offload */
>>  
>>  	/*
>>  	 * Add your fresh new feature above and remember to update
>> @@ -157,6 +158,7 @@ enum {
>>  #define NETIF_F_GRO_FRAGLIST	__NETIF_F(GRO_FRAGLIST)
>>  #define NETIF_F_GSO_FRAGLIST	__NETIF_F(GSO_FRAGLIST)
>>  #define NETIF_F_HW_MACSEC	__NETIF_F(HW_MACSEC)
>> +#define NETIF_F_HW_TCP_DDP	__NETIF_F(HW_TCP_DDP)
> 
> All of the DDP naming seems wrong to me. I realize the specific use case
> is targeted payloads of a ULP, but it is still S/W handing H/W specific
> buffers for a payload of a flow.
> 
> 

This is intended to be used strictly by ULPs. DDP is how such things were
called in the past. It is more than zerocopy as explained before, so naming
it zerocopy will be misleading at best. I can propose another name. How about:
"Autonomous copy offload (ACO)" and "Autonomous crc offload (ACRC)"?
This will indicate that it is independent of other offloads, i.e. autonomous,
while also informing users of the functionality (copy/crc). Other names are
welcome too.


>>   * @icsk_listen_portaddr_node	hash to the portaddr listener hashtable
>>   * @icsk_ca_state:	   Congestion control state
>>   * @icsk_retransmits:	   Number of unrecovered [RTO] timeouts
>> @@ -94,6 +96,8 @@ struct inet_connection_sock {
>>  	const struct tcp_ulp_ops  *icsk_ulp_ops;
>>  	void __rcu		  *icsk_ulp_data;
>>  	void (*icsk_clean_acked)(struct sock *sk, u32 acked_seq);
>> +	const struct tcp_ddp_ulp_ops  *icsk_ulp_ddp_ops;
>> +	void __rcu		  *icsk_ulp_ddp_data;
>>  	struct hlist_node         icsk_listen_portaddr_node;
>>  	unsigned int		  (*icsk_sync_mss)(struct sock *sk, u32 pmtu);
>>  	__u8			  icsk_ca_state:5,
>> diff --git a/include/net/tcp_ddp.h b/include/net/tcp_ddp.h
>> new file mode 100644
>> index 000000000000..df3264be4600
>> --- /dev/null
>> +++ b/include/net/tcp_ddp.h
>> @@ -0,0 +1,129 @@
>> +/* SPDX-License-Identifier: GPL-2.0
>> + *
>> + * tcp_ddp.h
>> + *	Author:	Boris Pismenny <borisp@mellanox.com>
>> + *	Copyright (C) 2020 Mellanox Technologies.
>> + */
>> +#ifndef _TCP_DDP_H
>> +#define _TCP_DDP_H
>> +
>> +#include <linux/netdevice.h>
>> +#include <net/inet_connection_sock.h>
>> +#include <net/sock.h>
>> +
>> +/* limits returned by the offload driver, zero means don't care */
>> +struct tcp_ddp_limits {
>> +	int	 max_ddp_sgl_len;
>> +};
>> +
>> +enum tcp_ddp_type {
>> +	TCP_DDP_NVME = 1,
>> +};
>> +
>> +/**
>> + * struct tcp_ddp_config - Generic tcp ddp configuration: tcp ddp IO queue
>> + * config implementations must use this as the first member.
>> + * Add new instances of tcp_ddp_config below (nvme-tcp, etc.).
>> + */
>> +struct tcp_ddp_config {
>> +	enum tcp_ddp_type    type;
>> +	unsigned char        buf[];
> 
> you have this variable length buf, but it is not used (as far as I can
> tell). But then ...
> 
> 

True. This buf[] is here to indicate that users are expected to extend it with
the ULP specific data as in nvme_tcp_config. We can remove it and leave a comment
if you prefer that.

>> +};
>> +
>> +/**
>> + * struct nvme_tcp_ddp_config - nvme tcp ddp configuration for an IO queue
>> + *
>> + * @pfv:        pdu version (e.g., NVME_TCP_PFV_1_0)
>> + * @cpda:       controller pdu data alignmend (dwords, 0's based)
>> + * @dgst:       digest types enabled.
>> + *              The netdev will offload crc if ddp_crc is supported.
>> + * @queue_size: number of nvme-tcp IO queue elements
>> + * @queue_id:   queue identifier
>> + * @cpu_io:     cpu core running the IO thread for this queue
>> + */
>> +struct nvme_tcp_ddp_config {
>> +	struct tcp_ddp_config   cfg;
> 
> ... how would you use it within another struct like this?
> 

You don't.

>> +
>> +	u16			pfv;
>> +	u8			cpda;
>> +	u8			dgst;
>> +	int			queue_size;
>> +	int			queue_id;
>> +	int			io_cpu;
>> +};
>> +
>> +/**
>> + * struct tcp_ddp_io - tcp ddp configuration for an IO request.
>> + *
>> + * @command_id:  identifier on the wire associated with these buffers
>> + * @nents:       number of entries in the sg_table
>> + * @sg_table:    describing the buffers for this IO request
>> + * @first_sgl:   first SGL in sg_table
>> + */
>> +struct tcp_ddp_io {
>> +	u32			command_id;
>> +	int			nents;
>> +	struct sg_table		sg_table;
>> +	struct scatterlist	first_sgl[SG_CHUNK_SIZE];
>> +};
>> +
>> +/* struct tcp_ddp_dev_ops - operations used by an upper layer protocol to configure ddp offload
>> + *
>> + * @tcp_ddp_limits:    limit the number of scatter gather entries per IO.
>> + *                     the device driver can use this to limit the resources allocated per queue.
>> + * @tcp_ddp_sk_add:    add offload for the queue represennted by the socket+config pair.
>> + *                     this function is used to configure either copy, crc or both offloads.
>> + * @tcp_ddp_sk_del:    remove offload from the socket, and release any device related resources.
>> + * @tcp_ddp_setup:     request copy offload for buffers associated with a command_id in tcp_ddp_io.
>> + * @tcp_ddp_teardown:  release offload resources association between buffers and command_id in
>> + *                     tcp_ddp_io.
>> + * @tcp_ddp_resync:    respond to the driver's resync_request. Called only if resync is successful.
>> + */
>> +struct tcp_ddp_dev_ops {
>> +	int (*tcp_ddp_limits)(struct net_device *netdev,
>> +			      struct tcp_ddp_limits *limits);
>> +	int (*tcp_ddp_sk_add)(struct net_device *netdev,
>> +			      struct sock *sk,
>> +			      struct tcp_ddp_config *config);
>> +	void (*tcp_ddp_sk_del)(struct net_device *netdev,
>> +			       struct sock *sk);
>> +	int (*tcp_ddp_setup)(struct net_device *netdev,
>> +			     struct sock *sk,
>> +			     struct tcp_ddp_io *io);
>> +	int (*tcp_ddp_teardown)(struct net_device *netdev,
>> +				struct sock *sk,
>> +				struct tcp_ddp_io *io,
>> +				void *ddp_ctx);
>> +	void (*tcp_ddp_resync)(struct net_device *netdev,
>> +			       struct sock *sk, u32 seq);
>> +};
>> +
>> +#define TCP_DDP_RESYNC_REQ (1 << 0)
>> +
>> +/**
>> + * struct tcp_ddp_ulp_ops - Interface to register uppper layer Direct Data Placement (DDP) TCP offload
>> + */
>> +struct tcp_ddp_ulp_ops {
>> +	/* NIC requests ulp to indicate if @seq is the start of a message */
>> +	bool (*resync_request)(struct sock *sk, u32 seq, u32 flags);
>> +	/* NIC driver informs the ulp that ddp teardown is done - used for async completions*/
>> +	void (*ddp_teardown_done)(void *ddp_ctx);
>> +};
>> +
>> +/**
>> + * struct tcp_ddp_ctx - Generic tcp ddp context: device driver per queue contexts must
>> + * use this as the first member.
>> + */
>> +struct tcp_ddp_ctx {
>> +	enum tcp_ddp_type    type;
>> +	unsigned char        buf[];
> 
> similar to my comment above, I did not see any uses of the buf element.
> 

Same idea, we will remove it an leave a comment.
