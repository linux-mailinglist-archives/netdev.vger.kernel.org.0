Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16F2963CFD3
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 08:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbiK3Hor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 02:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233456AbiK3Hoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 02:44:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD90F6153C
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 23:43:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669794229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ngJm2cHEr9xMJzpUAPXQZau+HVdasggr+8mPvspHzzU=;
        b=DiQCk6nBYB01iBN9ef9sLQZONw6P5ajLJ8TMqYLcFot8tI9AkZ6x+iP8S24zD5tzsaCmEi
        7GXTS7+h0H6Ny4euEp7fSuBbtcGfu1efcFqrhRJdPe9crQvOjH/4Sb4KAIeujipfSS/pXP
        xQecHZ7fcuC3mxC/exMDD19K+Yf7CjI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-221-5xESrwsiM3SLPtVF_hjSbA-1; Wed, 30 Nov 2022 02:43:33 -0500
X-MC-Unique: 5xESrwsiM3SLPtVF_hjSbA-1
Received: by mail-ed1-f69.google.com with SMTP id c9-20020a05640227c900b00463de74bc15so9390349ede.13
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 23:43:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ngJm2cHEr9xMJzpUAPXQZau+HVdasggr+8mPvspHzzU=;
        b=b9YVofePJUUTYQyS8pQizXLXBqqnhIO7Ejhcw7mwHAQ+eEKJTSnUbbajqFb0CHBwcp
         o9vSP43VHjhGcaNc+Kn83HyQWWXXFsfVQMCq2ZLBan8PXghZFTxW3YvraiM7LKO8MgEQ
         csHLxpRPQuVteDitHXbKvW0RgxMPPmfY2gZqdU2nR69cEkYoOlxbcsguAZKI4+fwaj9v
         xfW3W7MFQ6brWy2LL3ruGMTuoxH4HZMqwlBDNZW5RkhK/CPxbfgs+unqfAXOQB84cFA+
         MIeASYFg4odcgpRFij0IMtnO4dQaoUcTnsUv+3Wkyd0p002w0rhZcvvenceFoFsw3bkZ
         x09w==
X-Gm-Message-State: ANoB5plfwL2HA+RcmqRM1/cuf1LHRg1kq6dm7F7xbUFDb1Ipdp9sxLm2
        gnKWcb+EWVG8yjxIh4HfVcknluCUPZxGyMkojPESOHzZ1Y7unbzDWOy7mamasMS9lCKBnaQmsPm
        CmokcY62ctbj+Ypla
X-Received: by 2002:a05:6402:3886:b0:463:ab08:2bc6 with SMTP id fd6-20020a056402388600b00463ab082bc6mr37555418edb.143.1669794212026;
        Tue, 29 Nov 2022 23:43:32 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5O9EA7d0S0201KesVmYfgVbq6L4sfyjUBhwacjg2v31O61IS14oSYFLqBgL6+cI0kGDEyXog==
X-Received: by 2002:a05:6402:3886:b0:463:ab08:2bc6 with SMTP id fd6-20020a056402388600b00463ab082bc6mr37555402edb.143.1669794211673;
        Tue, 29 Nov 2022 23:43:31 -0800 (PST)
Received: from [192.168.178.1] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id p23-20020aa7d317000000b00461cdda400esm336919edq.4.2022.11.29.23.43.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Nov 2022 23:43:30 -0800 (PST)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     wangchuanlei <wangchuanlei@inspur.com>
Cc:     alexandr.lobakin@intel.com, pabeni@redhat.com, pshelar@ovn.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        wangpeihui@inspur.com, netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [PATCH v5 net-next] net: openvswitch: Add support to
 count upcall packets
Date:   Wed, 30 Nov 2022 08:43:28 +0100
X-Mailer: MailMate (1.14r5928)
Message-ID: <25D6A730-6B7E-458B-96B3-2C5C525FEF8B@redhat.com>
In-Reply-To: <20221130072530.334688-1-wangchuanlei@inspur.com>
References: <20221130072530.334688-1-wangchuanlei@inspur.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 30 Nov 2022, at 8:25, wangchuanlei wrote:

> Add support to count upall packets, when kmod of openvswitch
> upcall to userspace , here count the number of packets for
> upcall succeed and failed, which is a better way to see how
> many packets upcalled to userspace(ovs-vswitchd) on every
> interfaces.
>
> Here modify format of code used by comments of v4.
>
> Changes since v4:
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
>
> Signed-off-by: wangchuanlei <wangchuanlei@inspur.com>
> ---
>  include/uapi/linux/openvswitch.h | 19 ++++++++++++
>  net/openvswitch/datapath.c       | 50 ++++++++++++++++++++++++++++++++=

>  net/openvswitch/vport.c          | 44 ++++++++++++++++++++++++++++
>  net/openvswitch/vport.h          | 19 ++++++++++++
>  4 files changed, 132 insertions(+)
>
> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/open=
vswitch.h
> index 94066f87e9ee..ad7cea9827cc 100644
> --- a/include/uapi/linux/openvswitch.h
> +++ b/include/uapi/linux/openvswitch.h
> @@ -126,6 +126,11 @@ struct ovs_vport_stats {
>  	__u64   tx_dropped;		/* no space available in linux  */
>  };
>
> +struct ovs_vport_upcall_stats {
> +	__u64   tx_success;		/* total packets upcalls succeed */
> +	__u64   tx_fail;		/* total packets upcalls failed  */
> +};
> +

=3D> This is no longer a user API data structure, so it should be removed=
 from this include.
=3D>  --This structure will used in userspace, ovs-vswitchd will use it.
=3D>  -- and that will be another patch of ovs-vswitchd. so it keep it he=
re ?

The above was your response to v4. However, as this structure is not part=
 of the UAPI from the Linux side, it should not be exposed. If you need a=
 similar structure in OVS one should be defined there.


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
> + * enum ovs_vport_upcall_attr - attributes for %OVS_VPORT_UPCALL* comm=
ands
> + * @OVS_VPORT_UPCALL_SUCCESS: 64-bit upcall success packets.
> + * @OVS_VPORT_UPCALL_FAIL: 64-bit upcall fail packets.
> + */
> +enum ovs_vport_upcall_attr {
> +	OVS_VPORT_UPCALL_SUCCESS,
> +	OVS_VPORT_UPCALL_FAIL,
> +	__OVS_VPORT_UPCALL_MAX
> +};
> +
> +#define OVS_VPORT_UPCALL_MAX (__OVS_VPORT_UPCALL_MAX - 1)
> +
>  enum {
>  	OVS_VXLAN_EXT_UNSPEC,
>  	OVS_VXLAN_EXT_GBP,	/* Flag or __u32 */
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index c8a9075ddd0a..f9279aee2adb 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -209,6 +209,26 @@ static struct vport *new_vport(const struct vport_=
parms *parms)
>  	return vport;
>  }
>
> +static void ovs_vport_upcalls(struct sk_buff *skb,
> +			      const struct dp_upcall_info *upcall_info,
> +			      bool upcall_result)
> +{
> +	struct vport *p =3D OVS_CB(skb)->input_vport;
> +	struct vport_upcall_stats_percpu *vport_stats;
> +
> +	if (upcall_info->cmd !=3D OVS_PACKET_CMD_MISS &&
> +	    upcall_info->cmd !=3D OVS_PACKET_CMD_ACTION)
> +		return;
> +
> +	vport_stats =3D this_cpu_ptr(p->upcall_stats);
> +	u64_stats_update_begin(&vport_stats->syncp);
> +	if (upcall_result)
> +		u64_stats_inc(&vport_stats->n_success);
> +	else
> +		u64_stats_inc(&vport_stats->n_fail);
> +	u64_stats_update_end(&vport_stats->syncp);
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
> +	ovs_vport_upcalls(skb, upcall_info, !err);
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
> @@ -2068,6 +2099,8 @@ static int ovs_vport_cmd_fill_info(struct vport *=
vport, struct sk_buff *skb,
>  {
>  	struct ovs_header *ovs_header;
>  	struct ovs_vport_stats vport_stats;
> +	struct ovs_vport_upcall_stats stat;
> +	struct nlattr *nla;
>  	int err;
>
>  	ovs_header =3D genlmsg_put(skb, portid, seq, &dp_vport_genl_family,
> @@ -2097,6 +2130,15 @@ static int ovs_vport_cmd_fill_info(struct vport =
*vport, struct sk_buff *skb,
>  			  OVS_VPORT_ATTR_PAD))
>  		goto nla_put_failure;
>
> +	nla =3D nla_nest_start_noflag(skb, OVS_VPORT_ATTR_UPCALL_STATS);
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
> @@ -2278,6 +2320,13 @@ static int ovs_vport_cmd_new(struct sk_buff *skb=
, struct genl_info *info)
>  		goto exit_unlock_free;
>  	}
>
> +	vport->upcall_stats =3D netdev_alloc_pcpu_stats(struct vport_upcall_s=
tats_percpu);
> +
> +	if (!vport->upcall_stats) {
> +		err =3D -ENOMEM;
> +		goto exit_unlock_free;
> +	}
> +
>  	err =3D ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
>  				      info->snd_portid, info->snd_seq, 0,
>  				      OVS_VPORT_CMD_NEW, GFP_KERNEL);
> @@ -2507,6 +2556,7 @@ static const struct nla_policy vport_policy[OVS_V=
PORT_ATTR_MAX + 1] =3D {
>  	[OVS_VPORT_ATTR_OPTIONS] =3D { .type =3D NLA_NESTED },
>  	[OVS_VPORT_ATTR_IFINDEX] =3D { .type =3D NLA_U32 },
>  	[OVS_VPORT_ATTR_NETNSID] =3D { .type =3D NLA_S32 },
> +	[OVS_VPORT_ATTR_UPCALL_STATS] =3D { .type =3D NLA_NESTED },
>  };
>
>  static const struct genl_small_ops dp_vport_genl_ops[] =3D {
> diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
> index 82a74f998966..fd95536b35ef 100644
> --- a/net/openvswitch/vport.c
> +++ b/net/openvswitch/vport.c
> @@ -284,6 +284,50 @@ void ovs_vport_get_stats(struct vport *vport, stru=
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
> +	stats->tx_success =3D 0;
> +	stats->tx_fail =3D 0;
> +
> +	for_each_possible_cpu(i) {
> +		const struct vport_upcall_stats_percpu *upcall_stats;
> +		unsigned int start;
> +
> +		upcall_stats =3D per_cpu_ptr(vport->upcall_stats, i);
> +		do {
> +			start =3D u64_stats_fetch_begin(&upcall_stats->syncp);
> +			stats->tx_success +=3D u64_stats_read(&upcall_stats->n_success);
> +			stats->tx_fail +=3D u64_stats_read(&upcall_stats->n_fail);
> +		} while (u64_stats_fetch_retry(&upcall_stats->syncp, start));
> +	}
> +}
> +
> +int ovs_vport_put_upcall_stats(struct sk_buff *skb,
> +			       struct ovs_vport_upcall_stats *stats)
> +{
> +	if (nla_put_u64_64bit(skb, OVS_VPORT_UPCALL_SUCCESS, stats->tx_succes=
s,
> +			      OVS_VPORT_ATTR_PAD))
> +		return -EMSGSIZE;
> +
> +	if (nla_put_u64_64bit(skb, OVS_VPORT_UPCALL_FAIL, stats->tx_fail,
> +			      OVS_VPORT_ATTR_PAD))
> +		return -EMSGSIZE;
> +
> +	return 0;
> +}
> +
>  /**
>   *	ovs_vport_get_options - retrieve device options
>   *
> diff --git a/net/openvswitch/vport.h b/net/openvswitch/vport.h
> index 7d276f60c000..b872117af763 100644
> --- a/net/openvswitch/vport.h
> +++ b/net/openvswitch/vport.h
> @@ -32,6 +32,11 @@ struct vport *ovs_vport_locate(const struct net *net=
, const char *name);
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
> @@ -65,6 +70,7 @@ struct vport_portids {
>   * @hash_node: Element in @dev_table hash table in vport.c.
>   * @dp_hash_node: Element in @datapath->ports hash table in datapath.c=
=2E
>   * @ops: Class structure.
> + * @upcall_stats: Upcall stats of every ports.
>   * @detach_list: list used for detaching vport in net-exit call.
>   * @rcu: RCU callback head for deferred destruction.
>   */
> @@ -78,6 +84,7 @@ struct vport {
>  	struct hlist_node hash_node;
>  	struct hlist_node dp_hash_node;
>  	const struct vport_ops *ops;
> +	struct vport_upcall_stats_percpu __percpu *upcall_stats;
>
>  	struct list_head detach_list;
>  	struct rcu_head rcu;
> @@ -137,6 +144,18 @@ struct vport_ops {
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

