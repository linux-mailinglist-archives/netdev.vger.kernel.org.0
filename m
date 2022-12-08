Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70D686469FE
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 08:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiLHH7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 02:59:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiLHH7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 02:59:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC8D53EFA
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 23:58:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670486292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xKnA6+o1j0ubcuLgviFu4MhSvtGbC+IvnZZO+RMTrGM=;
        b=T/PPK9ZbHk+tGKKK4J+5KHXHJg9pX/xxgregEmQ9Qhh0W5AcWnBZLJGo/vkhouPeuIOHI/
        9p7BIoTmE3+R2IQbq0UgL32XgfPgI2XoLCDgJVs+crzSPTYDf7hssTpzXBFbrfPnkB1pGT
        uPH1Y2Z93kPOIeC1Q5BOO8oFl6tDkP8=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-654-uxmTWeLpMNuSbQcZPU6yhQ-1; Thu, 08 Dec 2022 02:58:10 -0500
X-MC-Unique: uxmTWeLpMNuSbQcZPU6yhQ-1
Received: by mail-ej1-f70.google.com with SMTP id ds15-20020a170907724f00b007c0abebc958so593596ejc.2
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 23:58:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xKnA6+o1j0ubcuLgviFu4MhSvtGbC+IvnZZO+RMTrGM=;
        b=eh4urANdS1pQplXiCpN5I9fkMc8uDngzDC0ZdClwR8K63EsjcNL4UIrYDUH2F3pnh0
         p5Sp8eZL4JGjkj6PitN8TwXDGyBoCfq5LQKtCODMt7zLBFx7rhcOVXj25/8PzWdIxQVy
         gVCGTFToRppGlnQlmqRxb2F9UbuSuXnvm3SB1krig811aj6P3OOBZH1OWFYa7kJsYe/c
         DnhzQiFr0WUqHCQw6FCZG7lC3S8xKYO3aS7RXMDIA4Ah23s3ME4+ZhRsfAzlYo/1lHlh
         kiVSfCs6FmVqyM81DCWNHN618hRuqVOnm6PCl+I+XsYGCrQoIRR40/Xg4FtF6+aeQXiO
         PFxA==
X-Gm-Message-State: ANoB5pk7oBbtug2jmRFcLu8DH3l+u60hXznvXM6UT+KFw6mWCxcs6VVx
        +Pdd0lqgrOYEmVbwR7vQkKCRPBHDLc7SbyC5uYfFbA+D5y6O9FtaAmlgzOPuLsQk2MW4/coypI2
        RwFATpg17ROt6sXNW
X-Received: by 2002:a17:907:d68a:b0:7ae:f148:980c with SMTP id wf10-20020a170907d68a00b007aef148980cmr1691760ejc.28.1670486289343;
        Wed, 07 Dec 2022 23:58:09 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6/BN8zJCigMqEXnNmeh7RBI5N2xNDJtenurPVCx6NbkdicMQBdGhJy1dRxRbzaIW8se1V5oA==
X-Received: by 2002:a17:907:d68a:b0:7ae:f148:980c with SMTP id wf10-20020a170907d68a00b007aef148980cmr1691743ejc.28.1670486289028;
        Wed, 07 Dec 2022 23:58:09 -0800 (PST)
Received: from [10.39.192.171] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id b7-20020a17090630c700b007b790c18264sm9340459ejb.159.2022.12.07.23.58.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Dec 2022 23:58:08 -0800 (PST)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     wangchuanlei <wangchuanlei@inspur.com>
Cc:     leon@kernel.org, jiri@resnulli.us, alexandr.lobakin@intel.com,
        pabeni@redhat.com, pshelar@ovn.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, wangpeihui@inspur.com,
        netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [PATCH v9 net-next] net: openvswitch: Add support to
 count upcall packets
Date:   Thu, 08 Dec 2022 08:58:07 +0100
X-Mailer: MailMate (1.14r5930)
Message-ID: <79DD2DD8-0EFB-47D3-8C88-71211CD6AA11@redhat.com>
In-Reply-To: <20221207013857.4066561-1-wangchuanlei@inspur.com>
References: <20221207013857.4066561-1-wangchuanlei@inspur.com>
MIME-Version: 1.0
Content-Type: text/plain
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



On 7 Dec 2022, at 2:38, wangchuanlei wrote:

> Add support to count upall packets, when kmod of openvswitch
> upcall to count the number of packets for upcall succeed and
> failed, which is a better way to see how many packets upcalled
> on every interfaces.
>
> Signed-off-by: wangchuanlei <wangchuanlei@inspur.com>

The changes look good to me.

Acked-by: Eelco Chaudron <echaudro@redhat.com>

> ---
> Changes since v4 - v9:
> - optimize the function used by comments
>
> Changes since v3:
> - use nested NLA_NESTED attribute in netlink message
>
> Changes since v2:
> - add count of upcall failed packets
>
> Changes since v1:
> - add count of upcall succeed packets
> ---
>  include/uapi/linux/openvswitch.h | 14 +++++++++
>  net/openvswitch/datapath.c       | 41 ++++++++++++++++++++++++++
>  net/openvswitch/vport.c          | 50 ++++++++++++++++++++++++++++++++=

>  net/openvswitch/vport.h          | 16 ++++++++++
>  4 files changed, 121 insertions(+)
>
> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/open=
vswitch.h
> index 94066f87e9ee..c5d62ee82567 100644
> --- a/include/uapi/linux/openvswitch.h
> +++ b/include/uapi/linux/openvswitch.h
> @@ -277,11 +277,25 @@ enum ovs_vport_attr {
>  	OVS_VPORT_ATTR_PAD,
>  	OVS_VPORT_ATTR_IFINDEX,
>  	OVS_VPORT_ATTR_NETNSID,
> +	OVS_VPORT_ATTR_UPCALL_STATS,
>  	__OVS_VPORT_ATTR_MAX
>  };
>
>  #define OVS_VPORT_ATTR_MAX (__OVS_VPORT_ATTR_MAX - 1)
>
> +/**
> + * enum ovs_vport_upcall_attr - attributes for %OVS_VPORT_UPCALL* comm=
ands
> + * @OVS_VPORT_UPCALL_SUCCESS: 64-bit upcall success packets.
> + * @OVS_VPORT_UPCALL_FAIL: 64-bit upcall fail packets.
> + */
> +enum ovs_vport_upcall_attr {
> +	OVS_VPORT_UPCALL_ATTR_SUCCESS,
> +	OVS_VPORT_UPCALL_ATTR_FAIL,
> +	__OVS_VPORT_UPCALL_ATTR_MAX
> +};
> +
> +#define OVS_VPORT_UPCALL_ATTR_MAX (__OVS_VPORT_UPCALL_ATTR_MAX - 1)
> +
>  enum {
>  	OVS_VXLAN_EXT_UNSPEC,
>  	OVS_VXLAN_EXT_GBP,	/* Flag or __u32 */
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index c8a9075ddd0a..1d379d943e00 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -209,6 +209,26 @@ static struct vport *new_vport(const struct vport_=
parms *parms)
>  	return vport;
>  }
>
> +static void ovs_vport_update_upcall_stats(struct sk_buff *skb,
> +					  const struct dp_upcall_info *upcall_info,
> +					  bool upcall_result)
> +{
> +	struct vport *p =3D OVS_CB(skb)->input_vport;
> +	struct vport_upcall_stats_percpu *stats;
> +
> +	if (upcall_info->cmd !=3D OVS_PACKET_CMD_MISS &&
> +	    upcall_info->cmd !=3D OVS_PACKET_CMD_ACTION)
> +		return;
> +
> +	stats =3D this_cpu_ptr(p->upcall_stats);
> +	u64_stats_update_begin(&stats->syncp);
> +	if (upcall_result)
> +		u64_stats_inc(&stats->n_success);
> +	else
> +		u64_stats_inc(&stats->n_fail);
> +	u64_stats_update_end(&stats->syncp);
> +}
> +
>  void ovs_dp_detach_port(struct vport *p)
>  {
>  	ASSERT_OVSL();
> @@ -216,6 +236,9 @@ void ovs_dp_detach_port(struct vport *p)
>  	/* First drop references to device. */
>  	hlist_del_rcu(&p->dp_hash_node);
>
> +	/* Free percpu memory */
> +	free_percpu(p->upcall_stats);
> +
>  	/* Then destroy it. */
>  	ovs_vport_del(p);
>  }
> @@ -305,6 +328,8 @@ int ovs_dp_upcall(struct datapath *dp, struct sk_bu=
ff *skb,
>  		err =3D queue_userspace_packet(dp, skb, key, upcall_info, cutlen);
>  	else
>  		err =3D queue_gso_packets(dp, skb, key, upcall_info, cutlen);
> +
> +	ovs_vport_update_upcall_stats(skb, upcall_info, !err);
>  	if (err)
>  		goto err;
>
> @@ -1825,6 +1850,12 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, s=
truct genl_info *info)
>  		goto err_destroy_portids;
>  	}
>
> +	vport->upcall_stats =3D netdev_alloc_pcpu_stats(struct vport_upcall_s=
tats_percpu);
> +	if (!vport->upcall_stats) {
> +		err =3D -ENOMEM;
> +		goto err_destroy_portids;
> +	}
> +
>  	err =3D ovs_dp_cmd_fill_info(dp, reply, info->snd_portid,
>  				   info->snd_seq, 0, OVS_DP_CMD_NEW);
>  	BUG_ON(err < 0);
> @@ -2097,6 +2128,9 @@ static int ovs_vport_cmd_fill_info(struct vport *=
vport, struct sk_buff *skb,
>  			  OVS_VPORT_ATTR_PAD))
>  		goto nla_put_failure;
>
> +	if (ovs_vport_get_upcall_stats(vport, skb))
> +		goto nla_put_failure;
> +
>  	if (ovs_vport_get_upcall_portids(vport, skb))
>  		goto nla_put_failure;
>
> @@ -2278,6 +2312,12 @@ static int ovs_vport_cmd_new(struct sk_buff *skb=
, struct genl_info *info)
>  		goto exit_unlock_free;
>  	}
>
> +	vport->upcall_stats =3D netdev_alloc_pcpu_stats(struct vport_upcall_s=
tats_percpu);
> +	if (!vport->upcall_stats) {
> +		err =3D -ENOMEM;
> +		goto exit_unlock_free;
> +	}
> +
>  	err =3D ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
>  				      info->snd_portid, info->snd_seq, 0,
>  				      OVS_VPORT_CMD_NEW, GFP_KERNEL);
> @@ -2507,6 +2547,7 @@ static const struct nla_policy vport_policy[OVS_V=
PORT_ATTR_MAX + 1] =3D {
>  	[OVS_VPORT_ATTR_OPTIONS] =3D { .type =3D NLA_NESTED },
>  	[OVS_VPORT_ATTR_IFINDEX] =3D { .type =3D NLA_U32 },
>  	[OVS_VPORT_ATTR_NETNSID] =3D { .type =3D NLA_S32 },
> +	[OVS_VPORT_ATTR_UPCALL_STATS] =3D { .type =3D NLA_NESTED },
>  };
>
>  static const struct genl_small_ops dp_vport_genl_ops[] =3D {
> diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
> index 82a74f998966..7e0f5c45b512 100644
> --- a/net/openvswitch/vport.c
> +++ b/net/openvswitch/vport.c
> @@ -284,6 +284,56 @@ void ovs_vport_get_stats(struct vport *vport, stru=
ct ovs_vport_stats *stats)
>  	stats->tx_packets =3D dev_stats->tx_packets;
>  }
>
> +/**
> + *	ovs_vport_get_upcall_stats - retrieve upcall stats
> + *
> + * @vport: vport from which to retrieve the stats.
> + * @skb: sk_buff where upcall stats should be appended.
> + *
> + * Retrieves upcall stats for the given device.
> + *
> + * Must be called with ovs_mutex or rcu_read_lock.
> + */
> +int ovs_vport_get_upcall_stats(struct vport *vport, struct sk_buff *sk=
b)
> +{
> +	struct nlattr *nla;
> +	int i;
> +
> +	__u64 tx_success =3D 0;
> +	__u64 tx_fail =3D 0;
> +
> +	for_each_possible_cpu(i) {
> +		const struct vport_upcall_stats_percpu *stats;
> +		unsigned int start;
> +
> +		stats =3D per_cpu_ptr(vport->upcall_stats, i);
> +		do {
> +			start =3D u64_stats_fetch_begin(&stats->syncp);
> +			tx_success +=3D u64_stats_read(&stats->n_success);
> +			tx_fail +=3D u64_stats_read(&stats->n_fail);
> +		} while (u64_stats_fetch_retry(&stats->syncp, start));
> +	}
> +
> +	nla =3D nla_nest_start_noflag(skb, OVS_VPORT_ATTR_UPCALL_STATS);
> +	if (!nla)
> +		return -EMSGSIZE;
> +
> +	if (nla_put_u64_64bit(skb, OVS_VPORT_UPCALL_ATTR_SUCCESS, tx_success,=

> +			      OVS_VPORT_ATTR_PAD)) {
> +		nla_nest_cancel(skb, nla);
> +		return -EMSGSIZE;
> +	}
> +
> +	if (nla_put_u64_64bit(skb, OVS_VPORT_UPCALL_ATTR_FAIL, tx_fail,
> +			      OVS_VPORT_ATTR_PAD)) {
> +		nla_nest_cancel(skb, nla);
> +		return -EMSGSIZE;
> +	}
> +	nla_nest_end(skb, nla);
> +
> +	return 0;
> +}
> +
>  /**
>   *	ovs_vport_get_options - retrieve device options
>   *
> diff --git a/net/openvswitch/vport.h b/net/openvswitch/vport.h
> index 7d276f60c000..3af18b5faa95 100644
> --- a/net/openvswitch/vport.h
> +++ b/net/openvswitch/vport.h
> @@ -32,6 +32,8 @@ struct vport *ovs_vport_locate(const struct net *net,=
 const char *name);
>
>  void ovs_vport_get_stats(struct vport *, struct ovs_vport_stats *);
>
> +int ovs_vport_get_upcall_stats(struct vport *vport, struct sk_buff *sk=
b);
> +
>  int ovs_vport_set_options(struct vport *, struct nlattr *options);
>  int ovs_vport_get_options(const struct vport *, struct sk_buff *);
>
> @@ -65,6 +67,7 @@ struct vport_portids {
>   * @hash_node: Element in @dev_table hash table in vport.c.
>   * @dp_hash_node: Element in @datapath->ports hash table in datapath.c=
=2E
>   * @ops: Class structure.
> + * @upcall_stats: Upcall stats of every ports.
>   * @detach_list: list used for detaching vport in net-exit call.
>   * @rcu: RCU callback head for deferred destruction.
>   */
> @@ -78,6 +81,7 @@ struct vport {
>  	struct hlist_node hash_node;
>  	struct hlist_node dp_hash_node;
>  	const struct vport_ops *ops;
> +	struct vport_upcall_stats_percpu __percpu *upcall_stats;
>
>  	struct list_head detach_list;
>  	struct rcu_head rcu;
> @@ -137,6 +141,18 @@ struct vport_ops {
>  	struct list_head list;
>  };
>
> +/**
> + * struct vport_upcall_stats_percpu - per-cpu packet upcall statistics=
 for
> + * a given vport.
> + * @n_success: Number of packets that upcall to userspace succeed.
> + * @n_fail:    Number of packets that upcall to userspace failed.
> + */
> +struct vport_upcall_stats_percpu {
> +	struct u64_stats_sync syncp;
> +	u64_stats_t n_success;
> +	u64_stats_t n_fail;
> +};
> +
>  struct vport *ovs_vport_alloc(int priv_size, const struct vport_ops *,=

>  			      const struct vport_parms *);
>  void ovs_vport_free(struct vport *);
> -- =

> 2.27.0

