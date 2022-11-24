Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA8F563705E
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 03:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiKXCY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 21:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiKXCY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 21:24:26 -0500
Received: from unicom145.biz-email.net (unicom145.biz-email.net [210.51.26.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FFFE1218;
        Wed, 23 Nov 2022 18:24:23 -0800 (PST)
Received: from ([60.208.111.195])
        by unicom145.biz-email.net ((D)) with ASMTP (SSL) id SDW00119;
        Thu, 24 Nov 2022 10:24:19 +0800
Received: from localhost.localdomain (10.180.206.146) by
 jtjnmail201612.home.langchao.com (10.100.2.12) with Microsoft SMTP Server id
 15.1.2507.12; Thu, 24 Nov 2022 10:24:18 +0800
From:   wangchuanlei <wangchuanlei@inspur.com>
To:     <alexandr.lobakin@intel.com>, <pabeni@redhat.com>,
        <echaudro@redhat.com>, <pshelar@ovn.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>
CC:     <wangpeihui@inspur.com>, <netdev@vger.kernel.org>,
        <dev@openvswitch.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [openvswitch v4] openvswitch: Add support to count upcall packets
Date:   Wed, 23 Nov 2022 21:24:16 -0500
Message-ID: <20221124022416.4045660-1-wangchuanlei@inspur.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221123183834.489456-1-alexandr.lobakin@intel.com>
References: <20221123183834.489456-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="y"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.206.146]
tUid:   202211241024193b05bc1b7cc9004ab5d07439d7d2a1aa
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
    Thank you for review! I will give a new verson of patch based on your comments,
and i give a explanation on every comments from you, please see below!

Best reagrds!
wangchuanlei

From: Alexander Lobakin [mailto:alexandr.lobakin@intel.com] 
To: wangchuanlei@inspur.com

> From: wangchuanlei <wangchuanlei@inspur.com>
> Date: Wed, 23 Nov 2022 04:18:43 -0500

> Add support to count upall packets, when kmod of openvswitch upcall to 
> userspace , here count the number of packets for upcall succeed and 
> failed, which is a better way to see how many packets upcalled to 
> userspace(ovs-vswitchd) on every interfaces.
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
> diff --git a/include/uapi/linux/openvswitch.h 
> b/include/uapi/linux/openvswitch.h
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

Please no uint64_t int the UAPI headers. __u64 as above.  --Yes !

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
> + * enum ovs_vport_upcall_attr - attributes for %OVS_VPORT_UPCALL* 
> +commands
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

Spaces around arithm operator ('-'). 	 --Yes !

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

Just `bool success`? It's clear that is's about upcalls, I don't see a need to repeat it in every argument's name.
 --Yes !
> +{
> +	if (upcall_info->cmd == OVS_PACKET_CMD_MISS ||
> +	    upcall_info->cmd == OVS_PACKET_CMD_ACTION) {

	if (cmd != MISS && cmd != ACTION)
		return;

Saves 1 indent level. --you are right!

> +		const struct vport *p = OVS_CB(skb)->input_vport;
> +		struct vport_upcall_stats_percpu *vport_stats;
> +
> +		vport_stats = this_cpu_ptr(p->vport_upcall_stats_percpu);

Why make a separate structure? You can just expand dp_stats_percpu, this function would then be just a couple lines in ovs_dp_upcall().
-- emm, beacause of this statistics based on vport, so new structure should insert to "struct vport"


> +		u64_stats_update_begin(&vport_stats->syncp);
> +		if (upcall_success)
> +			u64_stats_inc(&vport_stats->n_upcall_success);
> +		else
> +			u64_stats_inc(&vport_stats->n_upcall_fail);
> +		u64_stats_update_end(&vport_stats->syncp);
> +	}
> +}
> +
>  void ovs_dp_detach_port(struct vport *p)  {
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

Also, as you may see, your ::upcall_fail counter will be always exactly the same as stats->n_lost. So there's no point introducing a new one.
However, you can expand the structure dp_stats_percpu and add a new field there which would store the number of successfull upcalls.
...but I don't see a reason for this to be honest. From my PoV, it's better to count the number of successfully processed packets at the end of queue_userspace_packet() right before the 'out:'
label[0]. But please make sure then you don't duplicate some other counter (I'm not deep into OvS, so can't say for sure if there's anything similar to what you want).
--in ovs ， as stats->n_lost only count the sum of packets of all ports, not on individal port , so expand the structure dp_stats_percpu may be not suitable
--and count upcall failed packets is useful beacuse no all of upcall packets are successfully sent。

>  
> @@ -1825,6 +1849,13 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
>  		goto err_destroy_portids;
>  	}
>  
> +	vport->vport_upcall_stats_percpu =

This can be at least twice shorter, e.g. 'upcall_stats'. Don't try to describe every detail in symbol names.
--yes!
> +				netdev_alloc_pcpu_stats(struct vport_upcall_stats_percpu);
> +	if (!vport->vport_upcall_stats_percpu) {
> +		err = -ENOMEM;
> +		goto err_destroy_upcall_stats;

I know you followed the previous label logics, but you actually aren't destroying the stats under this label. Here you should have `goto err_destroy_portids` as that's what you're actually doing on that error path.
--here is just keep format of code, and has no influence on function

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
-- here is in different code segment on in vport_cmd_new , the other is in dp_cmd_new, they are has no collisions

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
> + * struct vport_upcall_stats_percpu - per-cpu packet upcall 
> +statistics for
> + * a given vport.
> + * @n_upcall_success: Number of packets that upcall to userspace succeed.
> + * @n_upcall_fail:    Number of packets that upcall to userspace failed.
> + */
> +struct vport_upcall_stats_percpu {
> +	u64_stats_t n_upcall_success;
> +	u64_stats_t n_upcall_fail;
> +	struct u64_stats_sync syncp;

Nit: syncp would feel better at the start. You could then sort the structure by the field hit probability and reduce cache misses %)
--ok

> +};
> +
>  /**
>   * struct dp_nlsk_pids - array of netlink portids of for a datapath.
>   *                       This is used when OVS_DP_F_DISPATCH_UPCALL_PER_CPU
> diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c index 
> 82a74f998966..a69c9356b57c 100644
> --- a/net/openvswitch/vport.c
> +++ b/net/openvswitch/vport.c
> @@ -284,6 +284,54 @@ void ovs_vport_get_stats(struct vport *vport, struct ovs_vport_stats *stats)
>  	stats->tx_packets = dev_stats->tx_packets;  }
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
> +void ovs_vport_get_upcall_stats(struct vport *vport, struct 
> +ovs_vport_upcall_stats *stats) {
> +	int i;
> +
> +	stats->upcall_success = 0;
> +	stats->upcall_fail = 0;
> +
> +	for_each_possible_cpu(i) {
> +		const struct vport_upcall_stats_percpu *percpu_upcall_stats;

You wouldn't need to linewrap the lines below if you didn't make its name so huge.
--you are right， i  would change the name!
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
> +			       struct ovs_vport_upcall_stats *stats) {
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
--you are right!
> +}
> +
>  /**
>   *	ovs_vport_get_options - retrieve device options
>   *
> diff --git a/net/openvswitch/vport.h b/net/openvswitch/vport.h index 
> 7d276f60c000..02cf8c589588 100644
> --- a/net/openvswitch/vport.h
> +++ b/net/openvswitch/vport.h
> @@ -32,6 +32,11 @@ struct vport *ovs_vport_locate(const struct net 
> *net, const char *name);
>  
>  void ovs_vport_get_stats(struct vport *, struct ovs_vport_stats *);
>  
> +void ovs_vport_get_upcall_stats(struct vport *vport,
> +				struct ovs_vport_upcall_stats *stats); int 
> +ovs_vport_put_upcall_stats(struct sk_buff *skb,
> +			       struct ovs_vport_upcall_stats *stats);
> +
>  int ovs_vport_set_options(struct vport *, struct nlattr *options);  
> int ovs_vport_get_options(const struct vport *, struct sk_buff *);
>  
> @@ -78,6 +83,7 @@ struct vport {
>  	struct hlist_node hash_node;
>  	struct hlist_node dp_hash_node;
>  	const struct vport_ops *ops;
> +	struct vport_upcall_stats_percpu __percpu 
> +*vport_upcall_stats_percpu;

Almost 80 columns in one field definition :D
--yes i would change the name !

>  
>  	struct list_head detach_list;
>  	struct rcu_head rcu;
> --
> 2.27.0

[0] https://elixir.bootlin.com/linux/v6.1-rc6/source/net/openvswitch/datapath.c#L557

Thanks,
Olek

