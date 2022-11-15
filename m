Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74C446292B8
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 08:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232433AbiKOHwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 02:52:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232338AbiKOHwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 02:52:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C5F71D318
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 23:51:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668498676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gvzMDvZmYCxXSCjHhHhBiRTKtnTjApltT1rs4fNygog=;
        b=chs20kxZw52PDBn7a09xJ1bMmRBzg7UO840sr6Ig/em/UYNINCFdl4DydIbzbaSPkYkxE3
        5pIlT6FeiXuvCI4CtSG9Jb9fX/hOalTMB3Af+J11XhZe5zqYU+Qm8Lqfo35KtEbTLlJWpT
        Fzj+r7ALpS2IxR4JRaSesHgsnpIrKKE=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-45-OPNtw24lNgySBaYPpPNZEQ-1; Tue, 15 Nov 2022 02:51:15 -0500
X-MC-Unique: OPNtw24lNgySBaYPpPNZEQ-1
Received: by mail-ej1-f71.google.com with SMTP id hp16-20020a1709073e1000b007adf5a83df7so6757352ejc.1
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 23:51:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gvzMDvZmYCxXSCjHhHhBiRTKtnTjApltT1rs4fNygog=;
        b=TnvaYdD6wqzRASbDPaCNydVnngLiF3ANq3mEEmH8jwwShfZTmbLmqkP/oEvo3kfcLK
         2VzdXU2My4ohNE4t1aYgQ4ikUyXT6HMERIpyojaLRy2Bdhqx8IkwlQ+3TGJJmV1aP+I/
         Z9VRnCBiRaZ5DRPxEFepsVhP0kEZyt/O4TqhaZqtJXjofFldHayH9As4PhGmwLkSdwit
         oUKmCQuMID70G4XOpBLcU/xs10xV53YzTcAaqA0/vTlAvWpqNN8/+Oyn/jhWyqmWO/tb
         hCdzUrMjC2kRwQSiU+UXspvGNZ9ZJGAY4MnjDC3FhnUx8yiF9g7p9FgiEXnXN1NkvWx2
         GBEg==
X-Gm-Message-State: ANoB5pmOYffLKplM64Vg6egiwGYUy30bcnlXFPJq0NeZT9A667Yw1nXS
        mSN2tKIhSdO8udU/q8xt3bKBqxkSrlXLs5Qfig4FD9mPsJ73z7m+fkbPd/Gyd6/aKsSJ1aoL8wW
        0KpeSWKZNfxKiEW5q
X-Received: by 2002:aa7:da13:0:b0:461:ed76:cb42 with SMTP id r19-20020aa7da13000000b00461ed76cb42mr14339148eds.229.1668498673846;
        Mon, 14 Nov 2022 23:51:13 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5vMSaaeyTtWBHsx1KhZT5L5vaAqAS1S7NEfOfk1LWRn1MZoFLGBJWYkGw9SDwZUV8C9urpog==
X-Received: by 2002:aa7:da13:0:b0:461:ed76:cb42 with SMTP id r19-20020aa7da13000000b00461ed76cb42mr14339142eds.229.1668498673566;
        Mon, 14 Nov 2022 23:51:13 -0800 (PST)
Received: from [10.39.192.204] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id u14-20020aa7d98e000000b004611c230bd0sm4504014eds.37.2022.11.14.23.51.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Nov 2022 23:51:12 -0800 (PST)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     wangchuanlei <wangchuanlei@inspur.com>
Cc:     pshelar@ovn.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, wangpeihui@inspur.com,
        netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] openvswitch: Add support to count upall packets
Date:   Tue, 15 Nov 2022 08:51:10 +0100
X-Mailer: MailMate (1.14r5927)
Message-ID: <4F98F9CC-E02C-4472-BF97-110D53388779@redhat.com>
In-Reply-To: <20221115072848.589294-1-wangchuanlei@inspur.com>
References: <20221115072848.589294-1-wangchuanlei@inspur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 15 Nov 2022, at 8:28, wangchuanlei wrote:

> Added the total number of upcalls and the total of upcall failures.
> Due to ovs-userspace do not support NLA_NESTED, here still use the
> "struct ovs_vport_upcall_stats"

I guess that was the idea, we should start using the NLA_NESTED attribute=
 rather than just embedding data structures.
The required backend support should be there, functions likes nl_msg_star=
t_nested(), and NL_NESTED_FOR_EACH() exists.

> Thank you
> wangchuanlei
>
> On 14 Sep 2022, at 14:14, wangchuanlei wrote:
>
>> Add support to count upcall packets on every interface.
>> I always encounter high cpu use of ovs-vswictchd, this help to check
>> which interface send too many packets without open vlog/set switch,
>> and have no influence on datapath.
>
> Hi,
>
> I did not do a full review, but I think we should not try to make the
>  same mistake as before and embed a structure inside a netlink message.=

>
> You are adding =E2=80=9Cstruct ovs_vport_upcall_stats=E2=80=9D but in t=
heory,
>  you could have just added the new entry to =E2=80=9Covs_vport_stats=E2=
=80=9D.
>  But this is breaking userspace as it expects an exact structure size :=
(
>
> So I think the right approach would be to have =E2=80=9C
> OVS_VPORT_ATTR_UPCALL_STATS=E2=80=9D be an NLA_NESTED type, and have
> individual stat attributes as NLA_U64 (or whatever type you need).
>
> What is also confusing is that you use upcall_packets in
>  ovs_vport_upcall_stats, which to me are the total of up calls,
> but you called it n_missed in your stats. I think you should try to
>  avoid missed in the upcall path, and just call it n_upcall_packets als=
o.
>
> In addition, I think you should keep two types of statics, and make the=
m
>  available, namely the total number of upcalls and the total of upcall
> failures.
>
> Cheers,
>
> Eelco
>
> Signed-off-by: wangchuanlei <wangchuanlei@inspur.com>
> ---
>  include/uapi/linux/openvswitch.h |  6 ++++
>  net/openvswitch/datapath.c       | 54 +++++++++++++++++++++++++++++++-=

>  net/openvswitch/datapath.h       | 12 +++++++
>  net/openvswitch/vport.c          | 33 +++++++++++++++++++
>  net/openvswitch/vport.h          |  4 +++
>  5 files changed, 108 insertions(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/open=
vswitch.h
> index 94066f87e9ee..bb671d92b711 100644
> --- a/include/uapi/linux/openvswitch.h
> +++ b/include/uapi/linux/openvswitch.h
> @@ -126,6 +126,11 @@ struct ovs_vport_stats {
>  	__u64   tx_dropped;		/* no space available in linux  */
>  };
>
> +struct ovs_vport_upcall_stats {
> +	__u64   upcall_success;             /* total packets upcalls  succeed=
 */
> +	__u64   upcall_fail;				/* total packets upcalls  failed */
> +};
> +
>  /* Allow last Netlink attribute to be unaligned */
>  #define OVS_DP_F_UNALIGNED	(1 << 0)
>
> @@ -277,6 +282,7 @@ enum ovs_vport_attr {
>  	OVS_VPORT_ATTR_PAD,
>  	OVS_VPORT_ATTR_IFINDEX,
>  	OVS_VPORT_ATTR_NETNSID,
> +	OVS_VPORT_ATTR_UPCALL_STATS, /* struct ovs_vport_upcall_stats */
>  	__OVS_VPORT_ATTR_MAX
>  };
>
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index c8a9075ddd0a..8b8ea95f94ae 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -209,6 +209,28 @@ static struct vport *new_vport(const struct vport_=
parms *parms)
>  	return vport;
>  }
>
> +static void ovs_vport_upcalls(struct sk_buff *skb,
> +			      const struct dp_upcall_info *upcall_info,
> +			      bool upcall_success)
> +{
> +	if (upcall_info->cmd =3D=3D OVS_PACKET_CMD_MISS ||
> +	    upcall_info->cmd =3D=3D OVS_PACKET_CMD_ACTION) {
> +		const struct vport *p =3D OVS_CB(skb)->input_vport;
> +		struct vport_upcall_stats_percpu *vport_stats;
> +		u64 *stats_counter_upcall;
> +
> +		vport_stats =3D this_cpu_ptr(p->vport_upcall_stats_percpu);
> +		if (upcall_success)
> +			stats_counter_upcall =3D &vport_stats->n_upcall_success;
> +		else
> +			stats_counter_upcall =3D &vport_stats->n_upcall_fail;
> +
> +		u64_stats_update_begin(&vport_stats->syncp);
> +		(*stats_counter_upcall)++;
> +		u64_stats_update_end(&vport_stats->syncp);
> +	}
> +}
> +
>  void ovs_dp_detach_port(struct vport *p)
>  {
>  	ASSERT_OVSL();
> @@ -216,6 +238,9 @@ void ovs_dp_detach_port(struct vport *p)
>  	/* First drop references to device. */
>  	hlist_del_rcu(&p->dp_hash_node);
>
> +	/* Free percpu memory */
> +	free_percpu(p->vport_upcall_stats_percpu);
> +
>  	/* Then destroy it. */
>  	ovs_vport_del(p);
>  }
> @@ -305,8 +330,12 @@ int ovs_dp_upcall(struct datapath *dp, struct sk_b=
uff *skb,
>  		err =3D queue_userspace_packet(dp, skb, key, upcall_info, cutlen);
>  	else
>  		err =3D queue_gso_packets(dp, skb, key, upcall_info, cutlen);
> -	if (err)
> +	if (err) {
> +		ovs_vport_upcalls(skb, upcall_info, false);
>  		goto err;
> +	} else {
> +		ovs_vport_upcalls(skb, upcall_info, true);
> +	}
>
>  	return 0;
>
> @@ -1825,6 +1854,13 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, s=
truct genl_info *info)
>  		goto err_destroy_portids;
>  	}
>
> +	vport->vport_upcall_stats_percpu =3D
> +				netdev_alloc_pcpu_stats(struct vport_upcall_stats_percpu);
> +	if (!vport->vport_upcall_stats_percpu) {
> +		err =3D -ENOMEM;
> +		goto err_destroy_portids;
> +	}
> +
>  	err =3D ovs_dp_cmd_fill_info(dp, reply, info->snd_portid,
>  				   info->snd_seq, 0, OVS_DP_CMD_NEW);
>  	BUG_ON(err < 0);
> @@ -2068,6 +2104,7 @@ static int ovs_vport_cmd_fill_info(struct vport *=
vport, struct sk_buff *skb,
>  {
>  	struct ovs_header *ovs_header;
>  	struct ovs_vport_stats vport_stats;
> +	struct ovs_vport_upcall_stats vport_upcall_stats;
>  	int err;
>
>  	ovs_header =3D genlmsg_put(skb, portid, seq, &dp_vport_genl_family,
> @@ -2097,6 +2134,13 @@ static int ovs_vport_cmd_fill_info(struct vport =
*vport, struct sk_buff *skb,
>  			  OVS_VPORT_ATTR_PAD))
>  		goto nla_put_failure;
>
> +	ovs_vport_get_upcall_stats(vport, &vport_upcall_stats);
> +	if (nla_put_64bit(skb, OVS_VPORT_ATTR_UPCALL_STATS,
> +			  sizeof(struct ovs_vport_upcall_stats),
> +			  &vport_upcall_stats,
> +			  OVS_VPORT_ATTR_PAD))
> +		goto nla_put_failure;
> +
>  	if (ovs_vport_get_upcall_portids(vport, skb))
>  		goto nla_put_failure;
>
> @@ -2278,6 +2322,14 @@ static int ovs_vport_cmd_new(struct sk_buff *skb=
, struct genl_info *info)
>  		goto exit_unlock_free;
>  	}
>
> +	vport->vport_upcall_stats_percpu =3D
> +		netdev_alloc_pcpu_stats(struct vport_upcall_stats_percpu);
> +
> +	if (!vport->vport_upcall_stats_percpu) {
> +		err =3D -ENOMEM;
> +		goto exit_unlock_free;
> +	}
> +
>  	err =3D ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
>  				      info->snd_portid, info->snd_seq, 0,
>  				      OVS_VPORT_CMD_NEW, GFP_KERNEL);
> diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
> index 0cd29971a907..2f40db78d617 100644
> --- a/net/openvswitch/datapath.h
> +++ b/net/openvswitch/datapath.h
> @@ -50,6 +50,18 @@ struct dp_stats_percpu {
>  	struct u64_stats_sync syncp;
>  };
>
> +/**
> + * struct vport_upcall_stats_percpu - per-cpu packet upcall statistics=
 for
> + * a given vport.
> + * @n_upcall_success: Number of packets that upcall to userspace succe=
ed.
> + * @n_upcall_fail:    Number of packets that upcall to userspace faile=
d.
> + */
> +struct vport_upcall_stats_percpu {
> +	u64 n_upcall_success;
> +	u64 n_upcall_fail;
> +	struct u64_stats_sync syncp;
> +};
> +
>  /**
>   * struct dp_nlsk_pids - array of netlink portids of for a datapath.
>   *                       This is used when OVS_DP_F_DISPATCH_UPCALL_PE=
R_CPU
> diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
> index 82a74f998966..39b018da685e 100644
> --- a/net/openvswitch/vport.c
> +++ b/net/openvswitch/vport.c
> @@ -284,6 +284,39 @@ void ovs_vport_get_stats(struct vport *vport, stru=
ct ovs_vport_stats *stats)
>  	stats->tx_packets =3D dev_stats->tx_packets;
>  }
>
> +/**
> + *	ovs_vport_get_upcall_stats - retrieve upcall stats
> + *
> + * @vport: vport from which to retrieve the stats
> + * @ovs_vport_upcall_stats: location to store stats
> + *
> + * Retrieves upcall stats for the given device.
> + *
> + * Must be called with ovs_mutex or rcu_read_lock.
> + */
> +void ovs_vport_get_upcall_stats(struct vport *vport, struct ovs_vport_=
upcall_stats *stats)
> +{
> +	int i;
> +
> +	stats->upcall_success =3D 0;
> +	stats->upcall_fail =3D 0;
> +
> +	for_each_possible_cpu(i) {
> +		const struct vport_upcall_stats_percpu *percpu_upcall_stats;
> +		struct vport_upcall_stats_percpu local_stats;
> +		unsigned int start;
> +
> +		percpu_upcall_stats =3D per_cpu_ptr(vport->vport_upcall_stats_percpu=
, i);
> +		do {
> +			start =3D u64_stats_fetch_begin_irq(&percpu_upcall_stats->syncp);
> +			local_stats =3D *percpu_upcall_stats;
> +		} while (u64_stats_fetch_retry_irq(&percpu_upcall_stats->syncp, star=
t));
> +
> +		stats->upcall_success +=3D local_stats.n_upcall_success;
> +		stats->upcall_fail +=3D local_stats.n_upcall_fail;
> +	}
> +}
> +
>  /**
>   *	ovs_vport_get_options - retrieve device options
>   *
> diff --git a/net/openvswitch/vport.h b/net/openvswitch/vport.h
> index 7d276f60c000..6defacd6d718 100644
> --- a/net/openvswitch/vport.h
> +++ b/net/openvswitch/vport.h
> @@ -32,6 +32,9 @@ struct vport *ovs_vport_locate(const struct net *net,=
 const char *name);
>
>  void ovs_vport_get_stats(struct vport *, struct ovs_vport_stats *);
>
> +void ovs_vport_get_upcall_stats(struct vport *vport,
> +				struct ovs_vport_upcall_stats *stats);
> +
>  int ovs_vport_set_options(struct vport *, struct nlattr *options);
>  int ovs_vport_get_options(const struct vport *, struct sk_buff *);
>
> @@ -78,6 +81,7 @@ struct vport {
>  	struct hlist_node hash_node;
>  	struct hlist_node dp_hash_node;
>  	const struct vport_ops *ops;
> +	struct vport_upcall_stats_percpu __percpu *vport_upcall_stats_percpu;=

>
>  	struct list_head detach_list;
>  	struct rcu_head rcu;
> -- =

> 2.27.0

