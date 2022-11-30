Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5040B63CF1E
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 07:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233843AbiK3GMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 01:12:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232267AbiK3GMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 01:12:48 -0500
Received: from unicom145.biz-email.net (unicom145.biz-email.net [210.51.26.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295571DF2E;
        Tue, 29 Nov 2022 22:12:44 -0800 (PST)
Received: from ([60.208.111.195])
        by unicom145.biz-email.net ((D)) with ASMTP (SSL) id YHQ00039;
        Wed, 30 Nov 2022 14:12:39 +0800
Received: from localhost.localdomain (10.180.206.146) by
 jtjnmail201609.home.langchao.com (10.100.2.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 30 Nov 2022 14:12:38 +0800
From:   wangchuanlei <wangchuanlei@inspur.com>
To:     <echaudro@redhat.com>
CC:     <wangpeihui@inspur.com>, <alexandr.lobakin@intel.com>,
        <pabeni@redhat.com>, <pshelar@ovn.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <dev@openvswitch.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [openvswitch v4] openvswitch: Add support to count upcall packets
Date:   Wed, 30 Nov 2022 01:12:35 -0500
Message-ID: <20221130061235.20560-1-wangchuanlei@inspur.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.180.206.146]
X-ClientProxiedBy: Jtjnmail201613.home.langchao.com (10.100.2.13) To
 jtjnmail201609.home.langchao.com (10.100.2.9)
tUid:   20221130141239111e6ed07f264d3d4c1fcfef2b5929d8
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

Hi,Eelco Chaudron

> +struct ovs_vport_upcall_stats {
> +     uint64_t   upcall_success;      /* total packets upcalls succeed */
> +     uint64_t   upcall_fail;         /* total packets upcalls failed  */
> +};

This is no longer a user API data structure, so it should be removed from this include.
--This structure will used in userspace, ovs-vswitchd will use it.
 -- and that will be another patch of ovs-vswitchd. so it keep it here ?


>Thank you for review ,Eelco Chaudron,
>I will a new version of this patch soon based on comments of you and Alexander.

Best regards!
wangchuanlei


On 23 Nov 2022, at 10:18, wangchuanlei wrote:

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

There is already a review from Alexander, so I only commented on some things that caught my attention after glazing over the patch.
I will do a full review of the next revisions.

//Eelco


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
> +};

This is no longer a user API data structure, so it should be removed from this include.

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

Here you have comments ending with and without a dot (.), maybe make it uniform.
Maybe the comment on the structure can be removed as they are explained right above?


> +
> +#define OVS_VPORT_UPCALL_MAX (__OVS_VPORT_UPCALL_MAX-1)
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
> +{
> +	if (upcall_info->cmd == OVS_PACKET_CMD_MISS ||
> +	    upcall_info->cmd == OVS_PACKET_CMD_ACTION) {
> +		const struct vport *p = OVS_CB(skb)->input_vport;
> +		struct vport_upcall_stats_percpu *vport_stats;
> +
> +		vport_stats = this_cpu_ptr(p->vport_upcall_stats_percpu);
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
>
> @@ -1825,6 +1849,13 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
>  		goto err_destroy_portids;
>  	}
>
> +	vport->vport_upcall_stats_percpu =
> +				netdev_alloc_pcpu_stats(struct vport_upcall_stats_percpu);
> +	if (!vport->vport_upcall_stats_percpu) {
> +		err = -ENOMEM;
> +		goto err_destroy_upcall_stats;
> +	}
> +
>  	err = ovs_dp_cmd_fill_info(dp, reply, info->snd_portid,
>  				   info->snd_seq, 0, OVS_DP_CMD_NEW);
>  	BUG_ON(err < 0);
> @@ -1837,6 +1868,7 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
>  	ovs_notify(&dp_datapath_genl_family, reply, info);
>  	return 0;
>
> +err_destroy_upcall_stats:
>  err_destroy_portids:
>  	kfree(rcu_dereference_raw(dp->upcall_portids));
>  err_unlock_and_destroy_meters:
> @@ -2068,6 +2100,8 @@ static int ovs_vport_cmd_fill_info(struct vport 
> *vport, struct sk_buff *skb,  {
>  	struct ovs_header *ovs_header;
>  	struct ovs_vport_stats vport_stats;
> +	struct ovs_vport_upcall_stats stat;
> +	struct nlattr *nla;
>  	int err;
>
>  	ovs_header = genlmsg_put(skb, portid, seq, &dp_vport_genl_family, @@ 
> -2097,6 +2131,15 @@ static int ovs_vport_cmd_fill_info(struct vport *vport, struct sk_buff *skb,
>  			  OVS_VPORT_ATTR_PAD))
>  		goto nla_put_failure;
>
> +	nla = nla_nest_start_noflag(skb, OVS_VPORT_ATTR_UPCALL_STATS);
> +	if (!nla)
> +		goto nla_put_failure;
> +
> +	ovs_vport_get_upcall_stats(vport, &stat);
> +	if (ovs_vport_put_upcall_stats(skb, &stat))
> +		goto nla_put_failure;
> +	nla_nest_end(skb, nla);
> +
>  	if (ovs_vport_get_upcall_portids(vport, skb))
>  		goto nla_put_failure;
>
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
> +
>  	err = ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
>  				      info->snd_portid, info->snd_seq, 0,
>  				      OVS_VPORT_CMD_NEW, GFP_KERNEL); @@ -2507,6 +2558,7 @@ 
> static const struct nla_policy vport_policy[OVS_VPORT_ATTR_MAX + 1] = {
>  	[OVS_VPORT_ATTR_OPTIONS] = { .type = NLA_NESTED },
>  	[OVS_VPORT_ATTR_IFINDEX] = { .type = NLA_U32 },
>  	[OVS_VPORT_ATTR_NETNSID] = { .type = NLA_S32 },
> +	[OVS_VPORT_ATTR_UPCALL_STATS] = { .type = NLA_NESTED },
>  };
>
>  static const struct genl_small_ops dp_vport_genl_ops[] = { diff --git 
> a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h index 
> 0cd29971a907..933dec5e4175 100644
> --- a/net/openvswitch/datapath.h
> +++ b/net/openvswitch/datapath.h
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
>
>  	struct list_head detach_list;
>  	struct rcu_head rcu;
> --
> 2.27.0

