Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 975DA2F6BF8
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 21:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbhANUUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 15:20:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727367AbhANUUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 15:20:11 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B31C061575
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 12:19:30 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id p22so7097527edu.11
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 12:19:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=92gVkIhOAvDPXM7dxLqoVI6xEZ9/0Qens1Q58GqvE6o=;
        b=DzkcyDEo5vqPyxCbbFh5FO6DyVDTjPM80Z51lIMY3rebrypJCyp5hG87Wku7h0yo78
         NQokGvZQrdh6BwLOCaSkQeoW6w5OsiqTVAqccg0ik5acJsOAP0bpgHzgUNKDcqaR/kut
         1rJE5vE+lleErYC9U3xT5cOjN/gnw11Q3HxWYj2UY33u1Hcxtw+r1Lsgxu4gi09x4wM2
         CSXaM4JDCz45rg3M7ix/8sI4/I0P1Sh30vHrDgFHY9OvWhr0NvNzBONP8b6bb2tSS529
         +vN4FYSrU/dEtUqHs8X51kSbalRVrWso3dSOMeRQRdRhVLkJaemKcdKcGZSCBRXf7Cco
         os7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=92gVkIhOAvDPXM7dxLqoVI6xEZ9/0Qens1Q58GqvE6o=;
        b=F/HyvugTOQ/E5RKU8IrD9rIzv6AdIS3n1/LjyDUSRRu6WQJ7hNmGEAakhlJwDqo8Aw
         Y3LGaXNrqIwMF+cbAbsUXz4EzE3YodkdMO8n3TmCc7zrV6NQYiCR4lYQL2xYQtph896g
         PplM/AqTmX13KFw472+UuV2KOBAL8g+twnyj8V9627N82xGDvM0/m8VWRuXnTJilyTv3
         /+fC+qtb7igx4AoY75jlL2Y7s3A4z4PXV0ry1KKL5EEU235dduKqeRRm965fBs57LJxj
         RRJq5GvVGqVkl2gMLXEIvr/wqsghVU+1SxLL/nFiIJ6gJiKdfuv8CIhmAOA916/oi/Td
         cPfg==
X-Gm-Message-State: AOAM530AdYMx0tqT+EOAY6NEJYAdz4p+qpNCQvpel5yssgUAQBzmjShM
        T5Pqnd5xzoMNiVx7pHOMKIs=
X-Google-Smtp-Source: ABdhPJy8kfkDAeIUQd2KLb2EU6DlgpxvPYE3RPvNv+k+pA3RXikedVW5OSnA/5Q54ZnaeNf6NbBdoA==
X-Received: by 2002:aa7:c58a:: with SMTP id g10mr6934696edq.315.1610655569444;
        Thu, 14 Jan 2021 12:19:29 -0800 (PST)
Received: from [192.168.1.11] ([213.57.108.142])
        by smtp.gmail.com with ESMTPSA id gt18sm1061284ejb.104.2021.01.14.12.19.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jan 2021 12:19:28 -0800 (PST)
Subject: Re: [PATCH v2 net-next 02/21] net: Introduce direct data placement
 tcp offload
To:     Eric Dumazet <edumazet@google.com>,
        Boris Pismenny <borisp@mellanox.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, sagi@grimberg.me, axboe@fb.com,
        kbusch@kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        David Ahern <dsahern@gmail.com>, smalin@marvell.com,
        boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev <netdev@vger.kernel.org>, benishay@nvidia.com,
        ogerlitz@nvidia.com, yorayz@nvidia.com,
        Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
References: <20210114151033.13020-1-borisp@mellanox.com>
 <20210114151033.13020-3-borisp@mellanox.com>
 <CANn89iJaFRFxVe-eV7hcwC_5Zp+HtWHxTQt+BNYcKOwZUriSDg@mail.gmail.com>
From:   Boris Pismenny <borispismenny@gmail.com>
Message-ID: <62d4606a-0a41-2b12-cf16-3523d0b73573@gmail.com>
Date:   Thu, 14 Jan 2021 22:19:25 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CANn89iJaFRFxVe-eV7hcwC_5Zp+HtWHxTQt+BNYcKOwZUriSDg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 14/01/2021 17:57, Eric Dumazet wrote:
> On Thu, Jan 14, 2021 at 4:10 PM Boris Pismenny <borisp@mellanox.com> wrote:
>>
>> This commit introduces direct data placement offload for TCP.
>> This capability is accompanied by new net_device operations that
>> configure hardware contexts. There is a context per socket, and a context per DDP
>> opreation. Additionally, a resynchronization routine is used to assist
>> hardware handle TCP OOO, and continue the offload.
>> Furthermore, we let the offloading driver advertise what is the max hw
>> sectors/segments.
>>
>> Using this interface, the NIC hardware will scatter TCP payload directly
>> to the BIO pages according to the command_id.
>> To maintain the correctness of the network stack, the driver is expected
>> to construct SKBs that point to the BIO pages.
>>
>> This, the SKB represents the data on the wire, while it is pointing
>> to data that is already placed in the destination buffer.
>> As a result, data from page frags should not be copied out to
>> the linear part.
>>
>> As SKBs that use DDP are already very memory efficient, we modify
>> skb_condence to avoid copying data from fragments to the linear
>> part of SKBs that belong to a socket that uses DDP offload.
>>
>> A follow-up patch will use this interface for DDP in NVMe-TCP.
>>
>> Signed-off-by: Boris Pismenny <borisp@mellanox.com>
>> Signed-off-by: Ben Ben-Ishay <benishay@mellanox.com>
>> Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
>> Signed-off-by: Yoray Zack <yorayz@mellanox.com>
>> ---
>>  include/linux/netdev_features.h    |   2 +
>>  include/linux/netdevice.h          |   5 ++
>>  include/net/inet_connection_sock.h |   4 +
>>  include/net/tcp_ddp.h              | 136 +++++++++++++++++++++++++++++
>>  net/Kconfig                        |   9 ++
>>  net/core/skbuff.c                  |   9 +-
>>  net/ethtool/common.c               |   1 +
>>  7 files changed, 165 insertions(+), 1 deletion(-)
>>  create mode 100644 include/net/tcp_ddp.h
>>
>> diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
>> index 934de56644e7..fb35dcac03d2 100644
>> --- a/include/linux/netdev_features.h
>> +++ b/include/linux/netdev_features.h
>> @@ -84,6 +84,7 @@ enum {
>>         NETIF_F_GRO_FRAGLIST_BIT,       /* Fraglist GRO */
>>
>>         NETIF_F_HW_MACSEC_BIT,          /* Offload MACsec operations */
>> +       NETIF_F_HW_TCP_DDP_BIT,         /* TCP direct data placement offload */
>>
>>         /*
>>          * Add your fresh new feature above and remember to update
>> @@ -157,6 +158,7 @@ enum {
>>  #define NETIF_F_GRO_FRAGLIST   __NETIF_F(GRO_FRAGLIST)
>>  #define NETIF_F_GSO_FRAGLIST   __NETIF_F(GSO_FRAGLIST)
>>  #define NETIF_F_HW_MACSEC      __NETIF_F(HW_MACSEC)
>> +#define NETIF_F_HW_TCP_DDP     __NETIF_F(HW_TCP_DDP)
>>
>>  /* Finds the next feature with the highest number of the range of start till 0.
>>   */
>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>> index 259be67644e3..3dd3cdf5dec3 100644
>> --- a/include/linux/netdevice.h
>> +++ b/include/linux/netdevice.h
>> @@ -941,6 +941,7 @@ struct dev_ifalias {
>>
>>  struct devlink;
>>  struct tlsdev_ops;
>> +struct tcp_ddp_dev_ops;
>>
>>  struct netdev_name_node {
>>         struct hlist_node hlist;
>> @@ -1937,6 +1938,10 @@ struct net_device {
>>         const struct tlsdev_ops *tlsdev_ops;
>>  #endif
>>
>> +#ifdef CONFIG_TCP_DDP
>> +       const struct tcp_ddp_dev_ops *tcp_ddp_ops;
>> +#endif
>> +
>>         const struct header_ops *header_ops;
>>
>>         unsigned int            flags;
>> diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
>> index 7338b3865a2a..a08b85b53aa8 100644
>> --- a/include/net/inet_connection_sock.h
>> +++ b/include/net/inet_connection_sock.h
>> @@ -66,6 +66,8 @@ struct inet_connection_sock_af_ops {
>>   * @icsk_ulp_ops          Pluggable ULP control hook
>>   * @icsk_ulp_data         ULP private data
>>   * @icsk_clean_acked      Clean acked data hook
>> + * @icsk_ulp_ddp_ops      Pluggable ULP direct data placement control hook
>> + * @icsk_ulp_ddp_data     ULP direct data placement private data
>>   * @icsk_listen_portaddr_node  hash to the portaddr listener hashtable
>>   * @icsk_ca_state:        Congestion control state
>>   * @icsk_retransmits:     Number of unrecovered [RTO] timeouts
>> @@ -94,6 +96,8 @@ struct inet_connection_sock {
>>         const struct tcp_ulp_ops  *icsk_ulp_ops;
>>         void __rcu                *icsk_ulp_data;
>>         void (*icsk_clean_acked)(struct sock *sk, u32 acked_seq);
> 
> #ifdef CONFIG_TCP_DDP ?
> 
>> +       const struct tcp_ddp_ulp_ops  *icsk_ulp_ddp_ops;
>> +       void __rcu                *icsk_ulp_ddp_data;
>>         struct hlist_node         icsk_listen_portaddr_node;
>>         unsigned int              (*icsk_sync_mss)(struct sock *sk, u32 pmtu);
>>         __u8                      icsk_ca_state:5,
>> diff --git a/include/net/tcp_ddp.h b/include/net/tcp_ddp.h
>> new file mode 100644
>> index 000000000000..31e5b1a16d0f
>> --- /dev/null
>> +++ b/include/net/tcp_ddp.h
>> @@ -0,0 +1,136 @@
>> +/* SPDX-License-Identifier: GPL-2.0
>> + *
>> + * tcp_ddp.h
>> + *     Author: Boris Pismenny <borisp@mellanox.com>
>> + *     Copyright (C) 2021 Mellanox Technologies.
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
>> +       int      max_ddp_sgl_len;
>> +};
>> +
>> +enum tcp_ddp_type {
>> +       TCP_DDP_NVME = 1,
>> +};
>> +
>> +/**
>> + * struct tcp_ddp_config - Generic tcp ddp configuration: tcp ddp IO queue
>> + * config implementations must use this as the first member.
>> + * Add new instances of tcp_ddp_config below (nvme-tcp, etc.).
>> + */
>> +struct tcp_ddp_config {
>> +       enum tcp_ddp_type    type;
>> +       unsigned char        buf[];
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
>> +       struct tcp_ddp_config   cfg;
>> +
>> +       u16                     pfv;
>> +       u8                      cpda;
>> +       u8                      dgst;
>> +       int                     queue_size;
>> +       int                     queue_id;
>> +       int                     io_cpu;
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
>> +       u32                     command_id;
>> +       int                     nents;
>> +       struct sg_table         sg_table;
>> +       struct scatterlist      first_sgl[SG_CHUNK_SIZE];
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
>> +       int (*tcp_ddp_limits)(struct net_device *netdev,
>> +                             struct tcp_ddp_limits *limits);
>> +       int (*tcp_ddp_sk_add)(struct net_device *netdev,
>> +                             struct sock *sk,
>> +                             struct tcp_ddp_config *config);
>> +       void (*tcp_ddp_sk_del)(struct net_device *netdev,
>> +                              struct sock *sk);
>> +       int (*tcp_ddp_setup)(struct net_device *netdev,
>> +                            struct sock *sk,
>> +                            struct tcp_ddp_io *io);
>> +       int (*tcp_ddp_teardown)(struct net_device *netdev,
>> +                               struct sock *sk,
>> +                               struct tcp_ddp_io *io,
>> +                               void *ddp_ctx);
>> +       void (*tcp_ddp_resync)(struct net_device *netdev,
>> +                              struct sock *sk, u32 seq);
>> +};
>> +
>> +#define TCP_DDP_RESYNC_REQ BIT(0)
>> +
>> +/**
>> + * struct tcp_ddp_ulp_ops - Interface to register uppper layer Direct Data Placement (DDP) TCP offload
>> + */
>> +struct tcp_ddp_ulp_ops {
>> +       /* NIC requests ulp to indicate if @seq is the start of a message */
>> +       bool (*resync_request)(struct sock *sk, u32 seq, u32 flags);
>> +       /* NIC driver informs the ulp that ddp teardown is done - used for async completions*/
>> +       void (*ddp_teardown_done)(void *ddp_ctx);
>> +};
>> +
>> +/**
>> + * struct tcp_ddp_ctx - Generic tcp ddp context: device driver per queue contexts must
>> + * use this as the first member.
>> + */
>> +struct tcp_ddp_ctx {
>> +       enum tcp_ddp_type    type;
>> +       unsigned char        buf[];
>> +};
>> +
>> +static inline struct tcp_ddp_ctx *tcp_ddp_get_ctx(const struct sock *sk)
>> +{
>> +       struct inet_connection_sock *icsk = inet_csk(sk);
>> +
>> +       return (__force struct tcp_ddp_ctx *)icsk->icsk_ulp_ddp_data;
>> +}
>> +
>> +static inline void tcp_ddp_set_ctx(struct sock *sk, void *ctx)
>> +{
>> +       struct inet_connection_sock *icsk = inet_csk(sk);
>> +
>> +       rcu_assign_pointer(icsk->icsk_ulp_ddp_data, ctx);
>> +}
>> +
>> +#endif //_TCP_DDP_H
>> diff --git a/net/Kconfig b/net/Kconfig
>> index f4c32d982af6..3876861cdc90 100644
>> --- a/net/Kconfig
>> +++ b/net/Kconfig
>> @@ -457,6 +457,15 @@ config ETHTOOL_NETLINK
>>           netlink. It provides better extensibility and some new features,
>>           e.g. notification messages.
>>
>> +config TCP_DDP
>> +       bool "TCP direct data placement offload"
>> +       default n
>> +       help
>> +         Direct Data Placement (DDP) offload for TCP enables ULP, such as
>> +         NVMe-TCP/iSCSI, to request the NIC to place TCP payload data
>> +         of a command response directly into kernel pages.
>> +
>> +
>>  endif   # if NET
>>
>>  # Used by archs to tell that they support BPF JIT compiler plus which flavour.
>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>> index f62cae3f75d8..791c1b6bc067 100644
>> --- a/net/core/skbuff.c
>> +++ b/net/core/skbuff.c
>> @@ -69,6 +69,7 @@
>>  #include <net/xfrm.h>
>>  #include <net/mpls.h>
>>  #include <net/mptcp.h>
>> +#include <net/tcp_ddp.h>
>>
>>  #include <linux/uaccess.h>
>>  #include <trace/events/skb.h>
>> @@ -6140,9 +6141,15 @@ EXPORT_SYMBOL(pskb_extract);
>>   */
>>  void skb_condense(struct sk_buff *skb)
>>  {
>> +       bool is_ddp = false;
>> +
>> +#ifdef CONFIG_TCP_DDP
> 
> This looks strange to me : TCP should call this helper while skb->sk is NULL
> 
> Are you sure this is not dead code ?
> 

Will verify again on Sunday. AFAICT, early demux sets skb->sk before this code
is called. Just to clarify, the purpose of this code is to avoid skb condensing
data that is already placed into destination buffers.

>> +       is_ddp = skb->sk && inet_csk(skb->sk) &&
>> +                inet_csk(skb->sk)->icsk_ulp_ddp_data;
>> +#endif
>>         if (skb->data_len) {
>>                 if (skb->data_len > skb->end - skb->tail ||
>> -                   skb_cloned(skb))
>> +                   skb_cloned(skb) || is_ddp)
>>                         return;
>>
>>                 /* Nice, we can free page frag(s) right now */
>> diff --git a/net/ethtool/common.c b/net/ethtool/common.c
>> index 24036e3055a1..a2ff7a4a6bbf 100644
>> --- a/net/ethtool/common.c
>> +++ b/net/ethtool/common.c
>> @@ -68,6 +68,7 @@ const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN] = {
>>         [NETIF_F_HW_TLS_RX_BIT] =        "tls-hw-rx-offload",
>>         [NETIF_F_GRO_FRAGLIST_BIT] =     "rx-gro-list",
>>         [NETIF_F_HW_MACSEC_BIT] =        "macsec-hw-offload",
>> +       [NETIF_F_HW_TCP_DDP_BIT] =       "tcp-ddp-offload",
>>  };
>>
>>  const char
>> --
>> 2.24.1
>>
