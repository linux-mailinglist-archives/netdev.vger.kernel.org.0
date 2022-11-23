Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5408363691D
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 19:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239284AbiKWSit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 13:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238995AbiKWSin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 13:38:43 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8849A59FCA;
        Wed, 23 Nov 2022 10:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669228722; x=1700764722;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PrECQPqdLE0ZYRqQmQCc6XOHXU9mzomT8nw/PVSmjns=;
  b=bEwWj7xZuJJ+bgsgPeEkizVgTH7NlFPxN09RLC06VYNnvltU/jv7S5+H
   l+1RUsRS9AvLeAIrSoV0CSMSJV+plvs02HF5EgU2OMVze43uB1fb7SfnX
   J2+WpfuQmag3Vb6k5Jruakg2O89UllidXqW5j7Nkqz3EHojmm7Gzk0UsI
   /sBSFWYidBu0e8Z5k6M8Kb3168TxBcrLoQI0aoZfJoKxKW96plpcHyGEu
   p0JjHO/m9+5mg9B6xQBdO6llX6mzL1x6PNB6oSRAijibWdCKLwhcg1Fba
   hDmoQzLN5sTe9Cj1ebSoUK7GFnJizVkvrJUoUdKUPpdoLrt28LUh7a0oY
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="378393974"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="378393974"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 10:38:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="766821814"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="766821814"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga004.jf.intel.com with ESMTP; 23 Nov 2022 10:38:38 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2ANIcabI004421;
        Wed, 23 Nov 2022 18:38:37 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     wangchuanlei <wangchuanlei@inspur.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>, pabeni@redhat.com,
        echaudro@redhat.com, pshelar@ovn.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, wangpeihui@inspur.com,
        netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [openvswitch v4] openvswitch: Add support to count upcall packets
Date:   Wed, 23 Nov 2022 19:38:34 +0100
Message-Id: <20221123183834.489456-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123091843.3414856-1-wangchuanlei@inspur.com>
References: <20221123091843.3414856-1-wangchuanlei@inspur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wangchuanlei <wangchuanlei@inspur.com>
Date: Wed, 23 Nov 2022 04:18:43 -0500

> Add support to count upall packets, when kmod of openvswitch
> upcall to userspace , here count the number of packets for
> upcall succeed and failed, which is a better way to see how
> many packets upcalled to userspace(ovs-vswitchd) on every
> interfaces.
> 
> Here optimize the function used by comments of v3.
> 
> Changes since v3:
> - use nested NLA_NESTED attribute in netlink message
> 
> Changes since v2:
> - add count of upcall failed packets
> 
> Changes since v1:
> - add count of upcall succeed packets
> 
> Signed-off-by: wangchuanlei <wangchuanlei@inspur.com>
> ---
>  include/uapi/linux/openvswitch.h | 19 ++++++++++++
>  net/openvswitch/datapath.c       | 52 ++++++++++++++++++++++++++++++++
>  net/openvswitch/datapath.h       | 12 ++++++++
>  net/openvswitch/vport.c          | 48 +++++++++++++++++++++++++++++
>  net/openvswitch/vport.h          |  6 ++++
>  5 files changed, 137 insertions(+)
> 
> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
> index 94066f87e9ee..fa13bce15fae 100644
> --- a/include/uapi/linux/openvswitch.h
> +++ b/include/uapi/linux/openvswitch.h
> @@ -126,6 +126,11 @@ struct ovs_vport_stats {
>  	__u64   tx_dropped;		/* no space available in linux  */
>  };
>  
> +struct ovs_vport_upcall_stats {
> +	uint64_t   upcall_success;	/* total packets upcalls succeed */
> +	uint64_t   upcall_fail;		/* total packets upcalls failed  */

Please no uint64_t int the UAPI headers. __u64 as above.

> +};
> +
>  /* Allow last Netlink attribute to be unaligned */
>  #define OVS_DP_F_UNALIGNED	(1 << 0)
>  
> @@ -277,11 +282,25 @@ enum ovs_vport_attr {
>  	OVS_VPORT_ATTR_PAD,
>  	OVS_VPORT_ATTR_IFINDEX,
>  	OVS_VPORT_ATTR_NETNSID,
> +	OVS_VPORT_ATTR_UPCALL_STATS, /* struct ovs_vport_upcall_stats */
>  	__OVS_VPORT_ATTR_MAX
>  };
>  
>  #define OVS_VPORT_ATTR_MAX (__OVS_VPORT_ATTR_MAX - 1)
>  
> +/**
> + * enum ovs_vport_upcall_attr - attributes for %OVS_VPORT_UPCALL* commands
> + * @OVS_VPORT_UPCALL_SUCCESS: 64-bit upcall success packets.
> + * @OVS_VPORT_UPCALL_FAIL: 64-bit upcall fail packets.
> + */
> +enum ovs_vport_upcall_attr {
> +	OVS_VPORT_UPCALL_SUCCESS, /* 64-bit upcall success packets */
> +	OVS_VPORT_UPCALL_FAIL, /* 64-bit upcall fail packets */
> +	__OVS_VPORT_UPCALL_MAX
> +};
> +
> +#define OVS_VPORT_UPCALL_MAX (__OVS_VPORT_UPCALL_MAX-1)

Spaces around arithm operator ('-').

> +
>  enum {
>  	OVS_VXLAN_EXT_UNSPEC,
>  	OVS_VXLAN_EXT_GBP,	/* Flag or __u32 */
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index c8a9075ddd0a..5254c51cfa60 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -209,6 +209,25 @@ static struct vport *new_vport(const struct vport_parms *parms)
>  	return vport;
>  }
>  
> +static void ovs_vport_upcalls(struct sk_buff *skb,
> +			      const struct dp_upcall_info *upcall_info,
> +			      bool upcall_success)

                              ^^^^^^^^^^^^^^^^^^^

Just `bool success`? It's clear that is's about upcalls, I don't see
a need to repeat it in every argument's name.

> +{
> +	if (upcall_info->cmd == OVS_PACKET_CMD_MISS ||
> +	    upcall_info->cmd == OVS_PACKET_CMD_ACTION) {

	if (cmd != MISS && cmd != ACTION)
		return;

Saves 1 indent level.

> +		const struct vport *p = OVS_CB(skb)->input_vport;
> +		struct vport_upcall_stats_percpu *vport_stats;
> +
> +		vport_stats = this_cpu_ptr(p->vport_upcall_stats_percpu);

Why make a separate structure? You can just expand dp_stats_percpu,
this function would then be just a couple lines in ovs_dp_upcall().

> +		u64_stats_update_begin(&vport_stats->syncp);
> +		if (upcall_success)
> +			u64_stats_inc(&vport_stats->n_upcall_success);
> +		else
> +			u64_stats_inc(&vport_stats->n_upcall_fail);
> +		u64_stats_update_end(&vport_stats->syncp);
> +	}
> +}
> +
>  void ovs_dp_detach_port(struct vport *p)
>  {
>  	ASSERT_OVSL();
> @@ -216,6 +235,9 @@ void ovs_dp_detach_port(struct vport *p)
>  	/* First drop references to device. */
>  	hlist_del_rcu(&p->dp_hash_node);
>  
> +	/* Free percpu memory */
> +	free_percpu(p->vport_upcall_stats_percpu);
> +
>  	/* Then destroy it. */
>  	ovs_vport_del(p);
>  }
> @@ -305,6 +327,8 @@ int ovs_dp_upcall(struct datapath *dp, struct sk_buff *skb,
>  		err = queue_userspace_packet(dp, skb, key, upcall_info, cutlen);
>  	else
>  		err = queue_gso_packets(dp, skb, key, upcall_info, cutlen);
> +
> +	ovs_vport_upcalls(skb, upcall_info, !err);
>  	if (err)
>  		goto err;

Also, as you may see, your ::upcall_fail counter will be always
exactly the same as stats->n_lost. So there's no point introducing
a new one.
However, you can expand the structure dp_stats_percpu and add a new
field there which would store the number of successfull upcalls.
...but I don't see a reason for this to be honest. From my PoV,
it's better to count the number of successfully processed packets
at the end of queue_userspace_packet() right before the 'out:'
label[0]. But please make sure then you don't duplicate some other
counter (I'm not deep into OvS, so can't say for sure if there's
anything similar to what you want).

>  
> @@ -1825,6 +1849,13 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
>  		goto err_destroy_portids;
>  	}
>  
> +	vport->vport_upcall_stats_percpu =

This can be at least twice shorter, e.g. 'upcall_stats'. Don't try
to describe every detail in symbol names.

> +				netdev_alloc_pcpu_stats(struct vport_upcall_stats_percpu);
> +	if (!vport->vport_upcall_stats_percpu) {
> +		err = -ENOMEM;
> +		goto err_destroy_upcall_stats;

I know you followed the previous label logics, but you actually
aren't destroying the stats under this label. Here you should
have `goto err_destroy_portids` as that's what you're actually doing
on that error path.

> +	}
> +
>  	err = ovs_dp_cmd_fill_info(dp, reply, info->snd_portid,
>  				   info->snd_seq, 0, OVS_DP_CMD_NEW);
>  	BUG_ON(err < 0);

[...]

> @@ -2278,6 +2321,14 @@ static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
>  		goto exit_unlock_free;
>  	}
>  
> +	vport->vport_upcall_stats_percpu =
> +		netdev_alloc_pcpu_stats(struct vport_upcall_stats_percpu);
> +
> +	if (!vport->vport_upcall_stats_percpu) {
> +		err = -ENOMEM;
> +		goto exit_unlock_free;
> +	}

Why do you allocate them twice?

> +
>  	err = ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
>  				      info->snd_portid, info->snd_seq, 0,
>  				      OVS_VPORT_CMD_NEW, GFP_KERNEL);

[...]

> @@ -50,6 +50,18 @@ struct dp_stats_percpu {
>  	struct u64_stats_sync syncp;
>  };
>  
> +/**
> + * struct vport_upcall_stats_percpu - per-cpu packet upcall statistics for
> + * a given vport.
> + * @n_upcall_success: Number of packets that upcall to userspace succeed.
> + * @n_upcall_fail:    Number of packets that upcall to userspace failed.
> + */
> +struct vport_upcall_stats_percpu {
> +	u64_stats_t n_upcall_success;
> +	u64_stats_t n_upcall_fail;
> +	struct u64_stats_sync syncp;

Nit: syncp would feel better at the start. You could then sort the
structure by the field hit probability and reduce cache misses %)

> +};
> +
>  /**
>   * struct dp_nlsk_pids - array of netlink portids of for a datapath.
>   *                       This is used when OVS_DP_F_DISPATCH_UPCALL_PER_CPU
> diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
> index 82a74f998966..a69c9356b57c 100644
> --- a/net/openvswitch/vport.c
> +++ b/net/openvswitch/vport.c
> @@ -284,6 +284,54 @@ void ovs_vport_get_stats(struct vport *vport, struct ovs_vport_stats *stats)
>  	stats->tx_packets = dev_stats->tx_packets;
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
> +void ovs_vport_get_upcall_stats(struct vport *vport, struct ovs_vport_upcall_stats *stats)
> +{
> +	int i;
> +
> +	stats->upcall_success = 0;
> +	stats->upcall_fail = 0;
> +
> +	for_each_possible_cpu(i) {
> +		const struct vport_upcall_stats_percpu *percpu_upcall_stats;

You wouldn't need to linewrap the lines below if you didn't make its
name so huge.

> +		unsigned int start;
> +
> +		percpu_upcall_stats = per_cpu_ptr(vport->vport_upcall_stats_percpu, i);
> +		do {
> +			start = u64_stats_fetch_begin(&percpu_upcall_stats->syncp);
> +			stats->upcall_success +=
> +				u64_stats_read(&percpu_upcall_stats->n_upcall_success);
> +			stats->upcall_fail += u64_stats_read(&percpu_upcall_stats->n_upcall_fail);
> +		} while (u64_stats_fetch_retry(&percpu_upcall_stats->syncp, start));
> +	}
> +}
> +
> +int ovs_vport_put_upcall_stats(struct sk_buff *skb,
> +			       struct ovs_vport_upcall_stats *stats)
> +{
> +	if (nla_put_u64_64bit(skb, OVS_VPORT_UPCALL_SUCCESS, stats->upcall_success,
> +			      OVS_VPORT_ATTR_PAD))
> +		goto nla_put_failure;
> +
> +	if (nla_put_u64_64bit(skb, OVS_VPORT_UPCALL_FAIL, stats->upcall_fail,
> +			      OVS_VPORT_ATTR_PAD))
> +		goto nla_put_failure;
> +
> +	return 0;
> +
> +nla_put_failure:
> +	return -EMSGSIZE;

goto with only one action makes no sense, just exit directly.

> +}
> +
>  /**
>   *	ovs_vport_get_options - retrieve device options
>   *
> diff --git a/net/openvswitch/vport.h b/net/openvswitch/vport.h
> index 7d276f60c000..02cf8c589588 100644
> --- a/net/openvswitch/vport.h
> +++ b/net/openvswitch/vport.h
> @@ -32,6 +32,11 @@ struct vport *ovs_vport_locate(const struct net *net, const char *name);
>  
>  void ovs_vport_get_stats(struct vport *, struct ovs_vport_stats *);
>  
> +void ovs_vport_get_upcall_stats(struct vport *vport,
> +				struct ovs_vport_upcall_stats *stats);
> +int ovs_vport_put_upcall_stats(struct sk_buff *skb,
> +			       struct ovs_vport_upcall_stats *stats);
> +
>  int ovs_vport_set_options(struct vport *, struct nlattr *options);
>  int ovs_vport_get_options(const struct vport *, struct sk_buff *);
>  
> @@ -78,6 +83,7 @@ struct vport {
>  	struct hlist_node hash_node;
>  	struct hlist_node dp_hash_node;
>  	const struct vport_ops *ops;
> +	struct vport_upcall_stats_percpu __percpu *vport_upcall_stats_percpu;

Almost 80 columns in one field definition :D

>  
>  	struct list_head detach_list;
>  	struct rcu_head rcu;
> -- 
> 2.27.0

[0] https://elixir.bootlin.com/linux/v6.1-rc6/source/net/openvswitch/datapath.c#L557

Thanks,
Olek
