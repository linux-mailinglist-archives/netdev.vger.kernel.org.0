Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 511C4674FD9
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 09:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjATIxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 03:53:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjATIxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 03:53:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968625B9A
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 00:52:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674204760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JX7cSnmRj5odrp9epb0eSRVpnWx88LuuvW+Uj+VscN8=;
        b=DPBP3GJwdMV6rGBTM2hX3xHQJB1bSyNvXH/IltNdd9QNROedXve5Rx/PrE+vO5LVKI2FTD
        jXbaCjbrcx8ORH/1HY3fsgmI0/bQsCqWgvjb6VmFryzQLV7M6SwnPtQuRKdGzjZ+cNfiWA
        aQRwDTM6i7Fu6fi5AQc4mtGGU04vUJ0=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-477-TI0dGy4UPSee0CMhOO-W1A-1; Fri, 20 Jan 2023 03:52:36 -0500
X-MC-Unique: TI0dGy4UPSee0CMhOO-W1A-1
Received: by mail-ej1-f71.google.com with SMTP id gn31-20020a1709070d1f00b0087024adbba2so3406910ejc.20
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 00:52:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JX7cSnmRj5odrp9epb0eSRVpnWx88LuuvW+Uj+VscN8=;
        b=GMMroLqKuZfUt1ulIBrjGza6bkPIKqAdfqBljPPI4yu0R2T9MP16Gwq2Vgb7l7pXZe
         gSsMu8b+NnFrCOVZg/6jCCi2ZklR7T08ykvhpys3VOiNTccSbmYDe/I1nhaSRO2GeUp3
         axOmlNsv56RV+7ZEk5VlW23fPNSnzOKP7iSmqZ4kvPD/tLrNLT86j5pfu8klscdnnLff
         dCy3kI1MQje2k6eLvTWNbmScF9Wofx4hpJifTLcUPbROkGbrXm6vOndrLf8bBEzWHYaI
         fnCKWAojZ2GlUArpsbtkBDt0LGcSKKt6uaGkVHjzqHDAvN1/CZMm90z3muSwKcaRXn49
         x90w==
X-Gm-Message-State: AFqh2kpJiZyKmZMNum0ACaNHGiMkROJcpqi2jJ8bEyhy5cp5CY/Nvy6z
        HpbA3DQnN7frYP20CUjU01vTLRjjHu52R/NUi+DxLbOwmHgCRVI3HoxTcl7+FmJ6Yr2dIu4AiGL
        e3h9TzRUu7qHUnbrQ
X-Received: by 2002:a05:6402:5508:b0:49e:9751:2f17 with SMTP id fi8-20020a056402550800b0049e97512f17mr3955390edb.17.1674204755685;
        Fri, 20 Jan 2023 00:52:35 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuBuZX6eoY187ZIrq4ChdQRMWXhXLwhqMY3LdelWyWTti8Lr+t2tU2GiPwdtDljaDyUFoaOlQ==
X-Received: by 2002:a05:6402:5508:b0:49e:9751:2f17 with SMTP id fi8-20020a056402550800b0049e97512f17mr3955374edb.17.1674204755397;
        Fri, 20 Jan 2023 00:52:35 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-124-97.dyn.eolo.it. [146.241.124.97])
        by smtp.gmail.com with ESMTPSA id t20-20020a056402021400b0049e210884dasm6034248edv.15.2023.01.20.00.52.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 00:52:34 -0800 (PST)
Message-ID: <e279ebf025b62b8ce8878d16d1a77afb2e59ca7e.camel@redhat.com>
Subject: Re: [PATCH v9 01/25] net: Introduce direct data placement tcp
 offload
From:   Paolo Abeni <pabeni@redhat.com>
To:     Aurelien Aptel <aaptel@nvidia.com>, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, sagi@grimberg.me, hch@lst.de,
        kbusch@kernel.org, axboe@fb.com, chaitanyak@nvidia.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     Boris Pismenny <borisp@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com
Date:   Fri, 20 Jan 2023 09:52:34 +0100
In-Reply-To: <20230117153535.1945554-2-aaptel@nvidia.com>
References: <20230117153535.1945554-1-aaptel@nvidia.com>
         <20230117153535.1945554-2-aaptel@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-01-17 at 17:35 +0200, Aurelien Aptel wrote:
> From: Boris Pismenny <borisp@nvidia.com>
>=20
> This commit introduces direct data placement (DDP) offload for TCP.
>=20
> The motivation is saving compute resources/cycles that are spent
> to copy data from SKBs to the block layer buffers and CRC
> calculation/verification for received PDUs (Protocol Data Units).
>=20
> The DDP capability is accompanied by new net_device operations that
> configure hardware contexts.
>=20
> There is a context per socket, and a context per DDP operation.
> Additionally, a resynchronization routine is used to assist
> hardware handle TCP OOO, and continue the offload. Furthermore,
> we let the offloading driver advertise what is the max hw
> sectors/segments.
>=20
> The interface includes five net-device ddp operations:
>=20
>  1. sk_add - add offload for the queue represented by socket+config pair
>  2. sk_del - remove the offload for the socket/queue
>  3. ddp_setup - request copy offload for buffers associated with an IO
>  4. ddp_teardown - release offload resources for that IO
>  5. limits - query NIC driver for quirks and limitations (e.g.
>              max number of scatter gather entries per IO)
>=20
> Using this interface, the NIC hardware will scatter TCP payload
> directly to the BIO pages according to the command_id.
>=20
> To maintain the correctness of the network stack, the driver is
> expected to construct SKBs that point to the BIO pages.
>=20
> The SKB passed to the network stack from the driver represents
> data as it is on the wire, while it is pointing directly to data
> in destination buffers.
>=20
> As a result, data from page frags should not be copied out to
> the linear part. To avoid needless copies, such as when using
> skb_condense, we mark the skb->ulp_ddp bit.
> In addition, the skb->ulp_crc will be used by the upper layers to
> determine if CRC re-calculation is required. The two separated skb
> indications are needed to avoid false positives GRO flushing events.
>=20
> Follow-up patches will use this interface for DDP in NVMe-TCP.
>=20
> Capability bits stored in net_device allow drivers to report which
> ULP DDP capabilities a device supports. Control over these
> capabilities will be exposed to userspace in later patches.
>=20
> Signed-off-by: Boris Pismenny <borisp@nvidia.com>
> Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
> Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
> Signed-off-by: Yoray Zack <yorayz@nvidia.com>
> Signed-off-by: Shai Malin <smalin@nvidia.com>
> Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
> ---
>  include/linux/netdevice.h          |  15 +++
>  include/linux/skbuff.h             |  24 ++++
>  include/net/inet_connection_sock.h |   4 +
>  include/net/ulp_ddp.h              | 173 +++++++++++++++++++++++++++++
>  include/net/ulp_ddp_caps.h         |  41 +++++++
>  net/Kconfig                        |  20 ++++
>  net/core/skbuff.c                  |   3 +-
>  net/ipv4/tcp_input.c               |   8 ++
>  net/ipv4/tcp_ipv4.c                |   3 +
>  net/ipv4/tcp_offload.c             |   3 +
>  10 files changed, 293 insertions(+), 1 deletion(-)
>  create mode 100644 include/net/ulp_ddp.h
>  create mode 100644 include/net/ulp_ddp_caps.h
>=20
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index aad12a179e54..289cfdade177 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -52,6 +52,10 @@
>  #include <net/net_trackers.h>
>  #include <net/net_debug.h>
> =20
> +#ifdef CONFIG_ULP_DDP
> +#include <net/ulp_ddp_caps.h>
> +#endif
> +
>  struct netpoll_info;
>  struct device;
>  struct ethtool_ops;
> @@ -1392,6 +1396,8 @@ struct netdev_net_notifier {
>   *	Get hardware timestamp based on normal/adjustable time or free runnin=
g
>   *	cycle counter. This function is required if physical clock supports a
>   *	free running cycle counter.
> + * struct ulp_ddp_dev_ops *ulp_ddp_ops;
> + *	ULP DDP operations (see include/net/ulp_ddp.h)
>   */
>  struct net_device_ops {
>  	int			(*ndo_init)(struct net_device *dev);
> @@ -1616,6 +1622,9 @@ struct net_device_ops {
>  	ktime_t			(*ndo_get_tstamp)(struct net_device *dev,
>  						  const struct skb_shared_hwtstamps *hwtstamps,
>  						  bool cycles);
> +#if IS_ENABLED(CONFIG_ULP_DDP)
> +	const struct ulp_ddp_dev_ops	*ulp_ddp_ops;
> +#endif
>  };
> =20
>  /**
> @@ -1783,6 +1792,9 @@ enum netdev_ml_priv_type {
>   *	@mpls_features:	Mask of features inheritable by MPLS
>   *	@gso_partial_features: value(s) from NETIF_F_GSO\*
>   *
> + *	@ulp_ddp_caps:	Bitflags keeping track of supported and enabled
> + *			ULP DDP capabilities.
> + *
>   *	@ifindex:	interface index
>   *	@group:		The group the device belongs to
>   *
> @@ -2071,6 +2083,9 @@ struct net_device {
>  	netdev_features_t	mpls_features;
>  	netdev_features_t	gso_partial_features;
> =20
> +#ifdef CONFIG_ULP_DDP
> +	struct ulp_ddp_netdev_caps ulp_ddp_caps;
> +#endif
>  	unsigned int		min_mtu;
>  	unsigned int		max_mtu;
>  	unsigned short		type;
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 4c8492401a10..8708c5935e89 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -811,6 +811,8 @@ typedef unsigned char *sk_buff_data_t;
>   *		delivery_time in mono clock base (i.e. EDT).  Otherwise, the
>   *		skb->tstamp has the (rcv) timestamp at ingress and
>   *		delivery_time at egress.
> + *	@ulp_ddp: DDP offloaded
> + *	@ulp_crc: CRC offloaded
>   *	@napi_id: id of the NAPI struct this skb came from
>   *	@sender_cpu: (aka @napi_id) source CPU in XPS
>   *	@alloc_cpu: CPU which did the skb allocation.
> @@ -983,6 +985,10 @@ struct sk_buff {
>  	__u8			slow_gro:1;
>  	__u8			csum_not_inet:1;
>  	__u8			scm_io_uring:1;
> +#ifdef CONFIG_ULP_DDP
> +	__u8                    ulp_ddp:1;
> +	__u8			ulp_crc:1;
> +#endif
> =20
>  #ifdef CONFIG_NET_SCHED
>  	__u16			tc_index;	/* traffic control index */
> @@ -5053,5 +5059,23 @@ static inline void skb_mark_for_recycle(struct sk_=
buff *skb)
>  }
>  #endif
> =20
> +static inline bool skb_is_ulp_ddp(struct sk_buff *skb)
> +{
> +#ifdef CONFIG_ULP_DDP
> +	return skb->ulp_ddp;
> +#else
> +	return 0;
> +#endif
> +}
> +
> +static inline bool skb_is_ulp_crc(struct sk_buff *skb)
> +{
> +#ifdef CONFIG_ULP_DDP
> +	return skb->ulp_crc;
> +#else
> +	return 0;
> +#endif
> +}
> +
>  #endif	/* __KERNEL__ */
>  #endif	/* _LINUX_SKBUFF_H */
> diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connec=
tion_sock.h
> index c2b15f7e5516..2ba73167b3bb 100644
> --- a/include/net/inet_connection_sock.h
> +++ b/include/net/inet_connection_sock.h
> @@ -68,6 +68,8 @@ struct inet_connection_sock_af_ops {
>   * @icsk_ulp_ops	   Pluggable ULP control hook
>   * @icsk_ulp_data	   ULP private data
>   * @icsk_clean_acked	   Clean acked data hook
> + * @icsk_ulp_ddp_ops	   Pluggable ULP direct data placement control hook
> + * @icsk_ulp_ddp_data	   ULP direct data placement private data
>   * @icsk_ca_state:	   Congestion control state
>   * @icsk_retransmits:	   Number of unrecovered [RTO] timeouts
>   * @icsk_pending:	   Scheduled timer event
> @@ -98,6 +100,8 @@ struct inet_connection_sock {
>  	const struct tcp_ulp_ops  *icsk_ulp_ops;
>  	void __rcu		  *icsk_ulp_data;
>  	void (*icsk_clean_acked)(struct sock *sk, u32 acked_seq);
> +	const struct ulp_ddp_ulp_ops  *icsk_ulp_ddp_ops;
> +	void __rcu		  *icsk_ulp_ddp_data;

The above probably need a

#if IS_ENABLED(CONFIG_ULP_DDP)

compiler guard.

Have you considered avoiding adding the above fields here, and instead
pass them as argument for the setup() H/W offload operation?=C2=A0

I feel like such fields belong more naturally to the DDP offload
context/queue and currently the icsk DDP ops are only used by the
offloading driver. Additionally it looks strange to me 2 consecutive
different set of ULPs inside the same object (sock).

Thanks,

Paolo

