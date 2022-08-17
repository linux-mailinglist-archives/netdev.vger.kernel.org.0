Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56012597A16
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 01:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239084AbiHQXPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 19:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233622AbiHQXPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 19:15:14 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EDD08E0D5
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 16:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660778112; x=1692314112;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=HvE7G+irDJXQMD+JqVwWi98XFYGjILwjySQTowuYHWA=;
  b=Ww696gTX9PoM3UMdhSmIdD+ZpzQ43Ur/+miYh0STgi3L7IN28oUzYZ4D
   mVQoygg3MqeWcaSAXeHI7Pj41BZL1D9oYrjMUbKkNlxtglNJiOIpMhSiK
   fywElDc1ejdJrkE2hGrx/lPxTPQcN732bt+N3Ft47lfWn/ZBgjzASDrIo
   eWV/92WtxUMniDBhathCZmp5QZRF45aRgUZHB8H8jrD23PUYkxdcVRnFB
   yw1QassKKjJB5wv5di0Qzmobvt8uN9fbOu6UnPDAS5qa8LumGqmvuIopm
   Vo2RRGRRMQrrWiC00vhgjHP+U658OLR+GxH9IGiPPp0xm7WhezkW3PImJ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="291376323"
X-IronPort-AV: E=Sophos;i="5.93,244,1654585200"; 
   d="scan'208";a="291376323"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 16:15:12 -0700
X-IronPort-AV: E=Sophos;i="5.93,244,1654585200"; 
   d="scan'208";a="749884526"
Received: from kyamada-mobl.amr.corp.intel.com (HELO vcostago-mobl3) ([10.212.63.87])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 16:15:11 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>
Subject: Re: [RFC PATCH net-next 2/7] net: ethtool: add support for Frame
 Preemption and MAC Merge layer
In-Reply-To: <20220816222920.1952936-3-vladimir.oltean@nxp.com>
References: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
 <20220816222920.1952936-3-vladimir.oltean@nxp.com>
Date:   Wed, 17 Aug 2022 16:15:11 -0700
Message-ID: <87bksi31j4.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> Frame preemption (IEEE 802.1Q-2018 clause 6.7.2) and the MAC merge
> sublayer (IEEE 802.3-2018 clause 99) are 2 specifications, part of the
> Time Sensitive Networking enhancements, which work together to minimize
> latency caused by frame interference. The overall goal of TSN is for
> normal traffic and traffic belonging to real-time control processes to
> be able to cohabitate on the same L2 network and not bother each other
> too much.
>
> They achieve this (partly) by introducing the concept of preemptable
> traffic, i.e. Ethernet frames that have an altered Start-Of-Frame
> delimiter, which can be fragmented and reassembled at L2 on a link-local
> basis. The non-preemptable frames are called express traffic, and they
> can preempt preemptable frames, therefore having lower latency, which
> can matter at lower (100 Mbps) link speeds, or at high MTUs (jumbo
> frames around 9K). Preemption is not recursive, i.e. a PT frame cannot
> preempt another PT frame. Preemption also does not depend upon priority,
> or otherwise said, an ET frame with prio 0 will still preempt a PT frame
> with prio 7.

I liked that in the API sense, using this "prio" concept we gain more
flexibility, and we can express better what the hardware you work with
can do, i.e. priority (for frame preemption purposes?) and queues are
orthogonal.

The problem I have is that the hardware I work with is more limited (as
are some stmmac-based NICs that I am aware of) frame preemption
capability and "priority" are attached to queues.

From the API perspective, it seems that I could say that "fp-prio" 0 is
associated with queue 0, fp-prio 1 to queue 1, and so on, and everything
will work.

The only thing that I am not happy at all is that there are exactly 8
fp-prios.

The Linux network stack is more flexible than what 802.1Q defines, think
skb->priority, number of TCs, as you said earlier, I would hate to
impose some almost artificial limits here. And in future we are going to
see TSN enabled devices with lots more queues.

In short:
 - Comment: this section of the RFC is hardware independent, this
 behavior of queues and priorities being orthogonal is only valid for
 some implementations;
 - Question: would it be against the intention of the API to have a 1:1
 map of priorities to queues?
 - Deal breaker: fixed 8 prios;

>
> In terms of implementation, the specs talk about the fact that the
> express traffic is handled by an express MAC (eMAC) and the preemptable
> traffic by a preemptable MAC (pMAC), and these MACs are multiplexed on
> the same MII by a MAC merge layer.
>
> On RX, packets go to the eMAC or to the pMAC based on their SFD (the
> definition of which was generalized to SMD, Start-of-mPacket-Delimiter,
> where mPacket is essentially an Ethernet frame fragment, or a complete
> frame). On TX, the eMAC/pMAC classification decision is taken by the
> 802.1Q spec, based on packet priority (each of the 8 priority values may
> have an admin-status of preemptable or express).
>
> I have modeled both the Ethernet part of the spec and the queuing part
> as separate netlink messages, with separate ethtool command sets
> intended for them. I am slightly flexible as to where to place the FP
> settings; there were previous discussions about placing them in tc.
> At the moment I haven't received a good enough argument to move them out
> of ethtool, so here they are.
> https://patchwork.kernel.org/project/netdevbpf/cover/20220520011538.1098888-1-vinicius.gomes@intel.com/
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  include/linux/ethtool.h              |  59 ++++++
>  include/uapi/linux/ethtool.h         |  15 ++
>  include/uapi/linux/ethtool_netlink.h |  82 ++++++++
>  net/ethtool/Makefile                 |   3 +-
>  net/ethtool/fp.c                     | 295 +++++++++++++++++++++++++++
>  net/ethtool/mm.c                     | 228 +++++++++++++++++++++
>  net/ethtool/netlink.c                |  38 ++++
>  net/ethtool/netlink.h                |   8 +
>  8 files changed, 727 insertions(+), 1 deletion(-)
>  create mode 100644 net/ethtool/fp.c
>  create mode 100644 net/ethtool/mm.c
>
> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
> index 99dc7bfbcd3c..fa504dd22bf6 100644
> --- a/include/linux/ethtool.h
> +++ b/include/linux/ethtool.h
> @@ -453,6 +453,49 @@ struct ethtool_module_power_mode_params {
>  	enum ethtool_module_power_mode mode;
>  };
>  
> +/**
> + * struct ethtool_fp_param - 802.1Q Frame Preemption parameters
> + */
> +struct ethtool_fp_param {
> +	u8 preemptable_prios;
> +	u32 hold_advance;
> +	u32 release_advance;
> +};
> +
> +/**
> + * struct ethtool_mm_state - 802.3 MAC merge layer state
> + */
> +struct ethtool_mm_state {
> +	u32 verify_time;
> +	enum ethtool_mm_verify_status verify_status;
> +	bool supported;
> +	bool enabled;
> +	bool active;
> +	u8 add_frag_size;
> +};
> +
> +/**
> + * struct ethtool_mm_cfg - 802.3 MAC merge layer configuration
> + */
> +struct ethtool_mm_cfg {
> +	u32 verify_time;
> +	bool verify_disable;
> +	bool enabled;
> +	u8 add_frag_size;
> +};
> +
> +/* struct ethtool_mm_stats - 802.3 MAC merge layer statistics, as defined in
> + * IEEE 802.3-2018 subclause 30.14.1 oMACMergeEntity managed object class
> + */
> +struct ethtool_mm_stats {
> +	u64 MACMergeFrameAssErrorCount;
> +	u64 MACMergeFrameSmdErrorCount;
> +	u64 MACMergeFrameAssOkCount;
> +	u64 MACMergeFragCountRx;
> +	u64 MACMergeFragCountTx;
> +	u64 MACMergeHoldCount;
> +};
> +
>  /**
>   * struct ethtool_ops - optional netdev operations
>   * @cap_link_lanes_supported: indicates if the driver supports lanes
> @@ -624,6 +667,11 @@ struct ethtool_module_power_mode_params {
>   *	plugged-in.
>   * @set_module_power_mode: Set the power mode policy for the plug-in module
>   *	used by the network device.
> + * @get_fp_param: Query the 802.1Q Frame Preemption parameters.
> + * @set_fp_param: Set the 802.1Q Frame Preemption parameters.
> + * @get_mm_state: Query the 802.3 MAC Merge layer state.
> + * @set_mm_cfg: Set the 802.3 MAC Merge layer parameters.
> + * @get_mm_stats: Query the 802.3 MAC Merge layer statistics.
>   *
>   * All operations are optional (i.e. the function pointer may be set
>   * to %NULL) and callers must take this into account.  Callers must
> @@ -760,6 +808,17 @@ struct ethtool_ops {
>  	int	(*set_module_power_mode)(struct net_device *dev,
>  					 const struct ethtool_module_power_mode_params *params,
>  					 struct netlink_ext_ack *extack);
> +	void	(*get_fp_param)(struct net_device *dev,
> +				struct ethtool_fp_param *params);
> +	int	(*set_fp_param)(struct net_device *dev,
> +				const struct ethtool_fp_param *params,
> +				struct netlink_ext_ack *extack);
> +	void	(*get_mm_state)(struct net_device *dev,
> +				struct ethtool_mm_state *state);
> +	int	(*set_mm_cfg)(struct net_device *dev, struct ethtool_mm_cfg *cfg,
> +			      struct netlink_ext_ack *extack);
> +	void	(*get_mm_stats)(struct net_device *dev,
> +				struct ethtool_mm_stats *stats);
>  };
>  
>  int ethtool_check_ops(const struct ethtool_ops *ops);
> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index 2d5741fd44bb..7a21fcb26a43 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -736,6 +736,21 @@ enum ethtool_module_power_mode {
>  	ETHTOOL_MODULE_POWER_MODE_HIGH,
>  };
>  
> +/* Values from ieee8021FramePreemptionAdminStatus */
> +enum ethtool_fp_admin_status {
> +	ETHTOOL_FP_PARAM_ENTRY_ADMIN_STATUS_EXPRESS = 1,
> +	ETHTOOL_FP_PARAM_ENTRY_ADMIN_STATUS_PREEMPTABLE = 2,
> +};
> +
> +enum ethtool_mm_verify_status {
> +	ETHTOOL_MM_VERIFY_STATUS_UNKNOWN,
> +	ETHTOOL_MM_VERIFY_STATUS_INITIAL,
> +	ETHTOOL_MM_VERIFY_STATUS_VERIFYING,
> +	ETHTOOL_MM_VERIFY_STATUS_SUCCEEDED,
> +	ETHTOOL_MM_VERIFY_STATUS_FAILED,
> +	ETHTOOL_MM_VERIFY_STATUS_DISABLED,
> +};
> +
>  /**
>   * struct ethtool_gstrings - string set for data tagging
>   * @cmd: Command number = %ETHTOOL_GSTRINGS
> diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
> index d2fb4f7be61b..658810274c49 100644
> --- a/include/uapi/linux/ethtool_netlink.h
> +++ b/include/uapi/linux/ethtool_netlink.h
> @@ -49,6 +49,10 @@ enum {
>  	ETHTOOL_MSG_PHC_VCLOCKS_GET,
>  	ETHTOOL_MSG_MODULE_GET,
>  	ETHTOOL_MSG_MODULE_SET,
> +	ETHTOOL_MSG_FP_GET,
> +	ETHTOOL_MSG_FP_SET,
> +	ETHTOOL_MSG_MM_GET,
> +	ETHTOOL_MSG_MM_SET,
>  
>  	/* add new constants above here */
>  	__ETHTOOL_MSG_USER_CNT,
> @@ -94,6 +98,10 @@ enum {
>  	ETHTOOL_MSG_PHC_VCLOCKS_GET_REPLY,
>  	ETHTOOL_MSG_MODULE_GET_REPLY,
>  	ETHTOOL_MSG_MODULE_NTF,
> +	ETHTOOL_MSG_FP_GET_REPLY,
> +	ETHTOOL_MSG_FP_NTF,
> +	ETHTOOL_MSG_MM_GET_REPLY,
> +	ETHTOOL_MSG_MM_NTF,
>  
>  	/* add new constants above here */
>  	__ETHTOOL_MSG_KERNEL_CNT,
> @@ -862,6 +870,80 @@ enum {
>  	ETHTOOL_A_MODULE_MAX = (__ETHTOOL_A_MODULE_CNT - 1)
>  };
>  
> +/* FRAME PREEMPTION (802.1Q) */
> +
> +enum {
> +	ETHTOOL_A_FP_PARAM_ENTRY_UNSPEC,
> +	ETHTOOL_A_FP_PARAM_ENTRY_PRIO,		/* u8 */
> +	ETHTOOL_A_FP_PARAM_ENTRY_ADMIN_STATUS,	/* u8 */
> +
> +	/* add new constants above here */
> +	__ETHTOOL_A_FP_PARAM_ENTRY_CNT,
> +	ETHTOOL_A_FP_PARAM_ENTRY_MAX = (__ETHTOOL_A_FP_PARAM_ENTRY_CNT - 1)
> +};
> +
> +enum {
> +	ETHTOOL_A_FP_PARAM_UNSPEC,
> +	ETHTOOL_A_FP_PARAM_ENTRY,		/* nest */
> +
> +	/* add new constants above here */
> +	__ETHTOOL_A_FP_PARAM_CNT,
> +	ETHTOOL_A_FP_PARAM_MAX = (__ETHTOOL_A_FP_PARAM_CNT - 1)
> +};
> +
> +enum {
> +	ETHTOOL_A_FP_UNSPEC,
> +	ETHTOOL_A_FP_HEADER,			/* nest - _A_HEADER_* */
> +	ETHTOOL_A_FP_PARAM_TABLE,		/* nest */
> +	ETHTOOL_A_FP_HOLD_ADVANCE,		/* u32 */
> +	ETHTOOL_A_FP_RELEASE_ADVANCE,		/* u32 */
> +
> +	/* add new constants above here */
> +	__ETHTOOL_A_FP_CNT,
> +	ETHTOOL_A_FP_MAX = (__ETHTOOL_A_FP_CNT - 1)
> +};
> +
> +/* MAC MERGE (802.3) */
> +
> +enum {
> +	ETHTOOL_A_MM_STAT_UNSPEC,
> +	ETHTOOL_A_MM_STAT_PAD,
> +
> +	/* aMACMergeFrameAssErrorCount */
> +	ETHTOOL_A_MM_STAT_REASSEMBLY_ERRORS,	/* u64 */
> +	/* aMACMergeFrameSmdErrorCount */
> +	ETHTOOL_A_MM_STAT_SMD_ERRORS,		/* u64 */
> +	/* aMACMergeFrameAssOkCount */
> +	ETHTOOL_A_MM_STAT_REASSEMBLY_OK,	/* u64 */
> +	/* aMACMergeFragCountRx */
> +	ETHTOOL_A_MM_STAT_RX_FRAG_COUNT,	/* u64 */
> +	/* aMACMergeFragCountTx */
> +	ETHTOOL_A_MM_STAT_TX_FRAG_COUNT,	/* u64 */
> +	/* aMACMergeHoldCount */
> +	ETHTOOL_A_MM_STAT_HOLD_COUNT,		/* u64 */
> +
> +	/* add new constants above here */
> +	__ETHTOOL_A_MM_STAT_CNT,
> +	ETHTOOL_A_MM_STAT_MAX = (__ETHTOOL_A_MM_STAT_CNT - 1)
> +};
> +
> +enum {
> +	ETHTOOL_A_MM_UNSPEC,
> +	ETHTOOL_A_MM_HEADER,			/* nest - _A_HEADER_* */
> +	ETHTOOL_A_MM_VERIFY_STATUS,		/* u8 */
> +	ETHTOOL_A_MM_VERIFY_DISABLE,		/* u8 */
> +	ETHTOOL_A_MM_VERIFY_TIME,		/* u32 */
> +	ETHTOOL_A_MM_SUPPORTED,			/* u8 */
> +	ETHTOOL_A_MM_ENABLED,			/* u8 */
> +	ETHTOOL_A_MM_ACTIVE,			/* u8 */
> +	ETHTOOL_A_MM_ADD_FRAG_SIZE,		/* u8 */
> +	ETHTOOL_A_MM_STATS,			/* nest - _A_MM_STAT_* */
> +
> +	/* add new constants above here */
> +	__ETHTOOL_A_MM_CNT,
> +	ETHTOOL_A_MM_MAX = (__ETHTOOL_A_MM_CNT - 1)
> +};
> +
>  /* generic netlink info */
>  #define ETHTOOL_GENL_NAME "ethtool"
>  #define ETHTOOL_GENL_VERSION 1
> diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
> index b76432e70e6b..31e056f17856 100644
> --- a/net/ethtool/Makefile
> +++ b/net/ethtool/Makefile
> @@ -7,4 +7,5 @@ obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
>  ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o \
>  		   linkstate.o debug.o wol.o features.o privflags.o rings.o \
>  		   channels.o coalesce.o pause.o eee.o tsinfo.o cabletest.o \
> -		   tunnels.o fec.o eeprom.o stats.o phc_vclocks.o module.o
> +		   tunnels.o fec.o eeprom.o stats.o phc_vclocks.o module.o \
> +		   fp.o mm.o
> diff --git a/net/ethtool/fp.c b/net/ethtool/fp.c
> new file mode 100644
> index 000000000000..20f19d8c1461
> --- /dev/null
> +++ b/net/ethtool/fp.c
> @@ -0,0 +1,295 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright 2022 NXP
> + */
> +#include "common.h"
> +#include "netlink.h"
> +
> +struct fp_req_info {
> +	struct ethnl_req_info		base;
> +};
> +
> +struct fp_reply_data {
> +	struct ethnl_reply_data		base;
> +	struct ethtool_fp_param		params;
> +};
> +
> +#define FP_REPDATA(__reply_base) \
> +	container_of(__reply_base, struct fp_reply_data, base)
> +
> +const struct nla_policy ethnl_fp_get_policy[ETHTOOL_A_FP_HEADER + 1] = {
> +	[ETHTOOL_A_FP_HEADER] = NLA_POLICY_NESTED(ethnl_header_policy),
> +};
> +
> +static int fp_prepare_data(const struct ethnl_req_info *req_base,
> +			   struct ethnl_reply_data *reply_base,
> +			   struct genl_info *info)
> +{
> +	struct fp_reply_data *data = FP_REPDATA(reply_base);
> +	struct net_device *dev = reply_base->dev;
> +	int ret;
> +
> +	if (!dev->ethtool_ops->get_fp_param)
> +		return -EOPNOTSUPP;
> +
> +	ret = ethnl_ops_begin(dev);
> +	if (ret < 0)
> +		return ret;
> +
> +	dev->ethtool_ops->get_fp_param(dev, &data->params);
> +	ethnl_ops_complete(dev);
> +
> +	return 0;
> +}
> +
> +static int fp_reply_size(const struct ethnl_req_info *req_base,
> +			 const struct ethnl_reply_data *reply_base)
> +{
> +	int len = 0;
> +
> +	len += nla_total_size(0); /* _FP_PARAM_ENTRY */
> +	len += nla_total_size(sizeof(u8)); /* _FP_PARAM_ENTRY_PRIO */
> +	len += nla_total_size(sizeof(u8)); /* _FP_PARAM_ENTRY_ADMIN_STATUS */
> +	len *= 8; /* 8 prios */
> +	len += nla_total_size(0); /* _FP_PARAM_TABLE */
> +	len += nla_total_size(sizeof(u32)); /* _FP_HOLD_ADVANCE */
> +	len += nla_total_size(sizeof(u32)); /* _FP_RELEASE_ADVANCE */
> +
> +	return len;
> +}
> +
> +static int fp_fill_reply(struct sk_buff *skb,
> +			 const struct ethnl_req_info *req_base,
> +			 const struct ethnl_reply_data *reply_base)
> +{
> +	const struct fp_reply_data *data = FP_REPDATA(reply_base);
> +	const struct ethtool_fp_param *params = &data->params;
> +	enum ethtool_fp_admin_status admin_status;
> +	struct nlattr *nest_table, *nest_entry;
> +	int prio;
> +	int ret;
> +
> +	if (nla_put_u32(skb, ETHTOOL_A_FP_HOLD_ADVANCE, params->hold_advance) ||
> +	    nla_put_u32(skb, ETHTOOL_A_FP_RELEASE_ADVANCE, params->release_advance))
> +		return -EMSGSIZE;
> +
> +	nest_table = nla_nest_start(skb, ETHTOOL_A_FP_PARAM_TABLE);
> +	if (!nest_table)
> +		return -EMSGSIZE;
> +
> +	for (prio = 0; prio < 8; prio++) {
> +		admin_status = (params->preemptable_prios & BIT(prio)) ?
> +			ETHTOOL_FP_PARAM_ENTRY_ADMIN_STATUS_PREEMPTABLE :
> +			ETHTOOL_FP_PARAM_ENTRY_ADMIN_STATUS_EXPRESS;
> +
> +		nest_entry = nla_nest_start(skb, ETHTOOL_A_FP_PARAM_ENTRY);
> +		if (!nest_entry)
> +			goto nla_nest_cancel_table;
> +
> +		if (nla_put_u8(skb, ETHTOOL_A_FP_PARAM_ENTRY_PRIO, prio))
> +			goto nla_nest_cancel_entry;
> +
> +		if (nla_put_u8(skb, ETHTOOL_A_FP_PARAM_ENTRY_ADMIN_STATUS,
> +			       admin_status))
> +			goto nla_nest_cancel_entry;
> +
> +		nla_nest_end(skb, nest_entry);
> +	}
> +
> +	nla_nest_end(skb, nest_table);
> +
> +	return 0;
> +
> +nla_nest_cancel_entry:
> +	nla_nest_cancel(skb, nest_entry);
> +nla_nest_cancel_table:
> +	nla_nest_cancel(skb, nest_table);
> +	return ret;
> +}
> +
> +const struct ethnl_request_ops ethnl_fp_request_ops = {
> +	.request_cmd		= ETHTOOL_MSG_FP_GET,
> +	.reply_cmd		= ETHTOOL_MSG_FP_GET_REPLY,
> +	.hdr_attr		= ETHTOOL_A_FP_HEADER,
> +	.req_info_size		= sizeof(struct fp_req_info),
> +	.reply_data_size	= sizeof(struct fp_reply_data),
> +
> +	.prepare_data		= fp_prepare_data,
> +	.reply_size		= fp_reply_size,
> +	.fill_reply		= fp_fill_reply,
> +};
> +
> +static const struct nla_policy
> +ethnl_fp_set_param_entry_policy[ETHTOOL_A_FP_PARAM_ENTRY_MAX  + 1] = {
> +	[ETHTOOL_A_FP_PARAM_ENTRY_PRIO] = { .type = NLA_U8 },
> +	[ETHTOOL_A_FP_PARAM_ENTRY_ADMIN_STATUS] = { .type = NLA_U8 },
> +};
> +
> +static const struct nla_policy
> +ethnl_fp_set_param_table_policy[ETHTOOL_A_FP_PARAM_MAX + 1] = {
> +	[ETHTOOL_A_FP_PARAM_ENTRY] = NLA_POLICY_NESTED(ethnl_fp_set_param_entry_policy),
> +};
> +
> +const struct nla_policy ethnl_fp_set_policy[ETHTOOL_A_FP_MAX + 1] = {
> +	[ETHTOOL_A_FP_HEADER] = NLA_POLICY_NESTED(ethnl_header_policy),
> +	[ETHTOOL_A_FP_PARAM_TABLE] = NLA_POLICY_NESTED(ethnl_fp_set_param_table_policy),
> +};
> +
> +static int fp_parse_param_entry(const struct nlattr *nest,
> +				struct ethtool_fp_param *params,
> +				u8 *seen_prios, bool *mod,
> +				struct netlink_ext_ack *extack)
> +{
> +	struct nlattr *tb[ARRAY_SIZE(ethnl_fp_set_param_entry_policy)];
> +	u8 preemptable_prios = params->preemptable_prios;
> +	u8 prio, admin_status;
> +	int ret;
> +
> +	if (!nest)
> +		return 0;
> +
> +	ret = nla_parse_nested(tb,
> +			       ARRAY_SIZE(ethnl_fp_set_param_entry_policy) - 1,
> +			       nest, ethnl_fp_set_param_entry_policy,
> +			       extack);
> +	if (ret)
> +		return ret;
> +
> +	if (!tb[ETHTOOL_A_FP_PARAM_ENTRY_PRIO]) {
> +		NL_SET_ERR_MSG_ATTR(extack, nest,
> +				    "Missing 'prio' attribute");
> +		return -EINVAL;
> +	}
> +
> +	if (!tb[ETHTOOL_A_FP_PARAM_ENTRY_ADMIN_STATUS]) {
> +		NL_SET_ERR_MSG_ATTR(extack, nest,
> +				    "Missing 'admin_status' attribute");
> +		return -EINVAL;
> +	}
> +
> +	prio = nla_get_u8(tb[ETHTOOL_A_FP_PARAM_ENTRY_PRIO]);
> +	if (prio >= 8) {
> +		NL_SET_ERR_MSG_ATTR(extack, nest,
> +				    "Range exceeded for 'prio' attribute");
> +		return -ERANGE;
> +	}
> +
> +	if (*seen_prios & BIT(prio)) {
> +		NL_SET_ERR_MSG_ATTR(extack, nest,
> +				    "Duplicate 'prio' attribute");
> +		return -EINVAL;
> +	}
> +
> +	*seen_prios |= BIT(prio);
> +
> +	admin_status = nla_get_u8(tb[ETHTOOL_A_FP_PARAM_ENTRY_ADMIN_STATUS]);
> +	switch (admin_status) {
> +	case ETHTOOL_FP_PARAM_ENTRY_ADMIN_STATUS_PREEMPTABLE:
> +		preemptable_prios |= BIT(prio);
> +		break;
> +	case ETHTOOL_FP_PARAM_ENTRY_ADMIN_STATUS_EXPRESS:
> +		preemptable_prios &= ~BIT(prio);
> +		break;
> +	default:
> +		NL_SET_ERR_MSG_ATTR(extack, nest,
> +				    "Unexpected value for 'admin_status' attribute");
> +		return -EINVAL;
> +	}
> +
> +	if (preemptable_prios != params->preemptable_prios) {
> +		params->preemptable_prios = preemptable_prios;
> +		*mod = true;
> +	}
> +
> +	return 0;
> +}
> +
> +static int fp_parse_param_table(const struct nlattr *nest,
> +				struct ethtool_fp_param *params, bool *mod,
> +				struct netlink_ext_ack *extack)
> +{
> +	u8 seen_prios = 0;
> +	struct nlattr *n;
> +	int rem, ret;
> +
> +	if (!nest)
> +		return 0;
> +
> +	nla_for_each_nested(n, nest, rem) {
> +		struct sched_entry *entry;
> +
> +		if (nla_type(n) != ETHTOOL_A_FP_PARAM_ENTRY) {
> +			NL_SET_ERR_MSG_ATTR(extack, n,
> +					    "Attribute is not of type 'entry'");
> +			continue;
> +		}
> +
> +		ret = fp_parse_param_entry(n, params, &seen_prios, mod, extack);
> +		if (ret < 0) {
> +			kfree(entry);
> +			return ret;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +int ethnl_set_fp_param(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct netlink_ext_ack *extack = info->extack;
> +	struct ethnl_req_info req_info = {};
> +	struct ethtool_fp_param params = {};
> +	struct nlattr **tb = info->attrs;
> +	const struct ethtool_ops *ops;
> +	struct net_device *dev;
> +	bool mod = false;
> +	int ret;
> +
> +	ret = ethnl_parse_header_dev_get(&req_info, tb[ETHTOOL_A_FP_HEADER],
> +					 genl_info_net(info), extack, true);
> +	if (ret)
> +		return ret;
> +
> +	dev = req_info.dev;
> +	ops = dev->ethtool_ops;
> +
> +	if (!ops->get_fp_param || !ops->set_fp_param) {
> +		ret = -EOPNOTSUPP;
> +		goto out_dev;
> +	}
> +
> +	rtnl_lock();
> +	ret = ethnl_ops_begin(dev);
> +	if (ret)
> +		goto out_rtnl;
> +
> +	dev->ethtool_ops->get_fp_param(dev, &params);
> +
> +	ethnl_update_u32(&params.hold_advance, tb[ETHTOOL_A_FP_HOLD_ADVANCE],
> +			 &mod);
> +	ethnl_update_u32(&params.release_advance,
> +			 tb[ETHTOOL_A_FP_RELEASE_ADVANCE], &mod);
> +
> +	ret = fp_parse_param_table(tb[ETHTOOL_A_FP_PARAM_TABLE], &params, &mod,
> +				   extack);
> +	if (ret || !mod)
> +		goto out_ops;
> +
> +	ret = dev->ethtool_ops->set_fp_param(dev, &params, extack);
> +	if (ret) {
> +		if (!extack->_msg)
> +			NL_SET_ERR_MSG(extack,
> +				       "Failed to update frame preemption parameters");
> +		goto out_ops;
> +	}
> +
> +	ethtool_notify(dev, ETHTOOL_MSG_FP_NTF, NULL);
> +
> +out_ops:
> +	ethnl_ops_complete(dev);
> +out_rtnl:
> +	rtnl_unlock();
> +out_dev:
> +	dev_put(dev);
> +	return ret;
> +}
> diff --git a/net/ethtool/mm.c b/net/ethtool/mm.c
> new file mode 100644
> index 000000000000..d4731fb7aee4
> --- /dev/null
> +++ b/net/ethtool/mm.c
> @@ -0,0 +1,228 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright 2022 NXP
> + */
> +#include "common.h"
> +#include "netlink.h"
> +
> +struct mm_req_info {
> +	struct ethnl_req_info		base;
> +};
> +
> +struct mm_reply_data {
> +	struct ethnl_reply_data		base;
> +	struct ethtool_mm_state		state;
> +	struct ethtool_mm_stats		stats;
> +};
> +
> +#define MM_REPDATA(__reply_base) \
> +	container_of(__reply_base, struct mm_reply_data, base)
> +
> +#define ETHTOOL_MM_STAT_CNT \
> +	(__ETHTOOL_A_MM_STAT_CNT - (ETHTOOL_A_MM_STAT_PAD + 1))
> +
> +const struct nla_policy ethnl_mm_get_policy[ETHTOOL_A_MM_HEADER + 1] = {
> +	[ETHTOOL_A_MM_HEADER] = NLA_POLICY_NESTED(ethnl_header_policy_stats),
> +};
> +
> +static int mm_prepare_data(const struct ethnl_req_info *req_base,
> +			   struct ethnl_reply_data *reply_base,
> +			   struct genl_info *info)
> +{
> +	struct mm_reply_data *data = MM_REPDATA(reply_base);
> +	struct net_device *dev = reply_base->dev;
> +	const struct ethtool_ops *ops;
> +	int ret;
> +
> +	ops = dev->ethtool_ops;
> +
> +	if (!ops->get_mm_state)
> +		return -EOPNOTSUPP;
> +
> +	ethtool_stats_init((u64 *)&data->stats,
> +			   sizeof(data->stats) / sizeof(u64));
> +
> +	ret = ethnl_ops_begin(dev);
> +	if (ret < 0)
> +		return ret;
> +
> +	ops->get_mm_state(dev, &data->state);
> +
> +	if (ops->get_mm_stats && (req_base->flags & ETHTOOL_FLAG_STATS))
> +		ops->get_mm_stats(dev, &data->stats);
> +
> +	ethnl_ops_complete(dev);
> +
> +	return 0;
> +}
> +
> +static int mm_reply_size(const struct ethnl_req_info *req_base,
> +			 const struct ethnl_reply_data *reply_base)
> +{
> +	int len = 0;
> +
> +	len += nla_total_size(sizeof(u8)); /* _MM_VERIFY_STATUS */
> +	len += nla_total_size(sizeof(u32)); /* _MM_VERIFY_TIME */
> +	len += nla_total_size(sizeof(u8)); /* _MM_SUPPORTED */
> +	len += nla_total_size(sizeof(u8)); /* _MM_ENABLED */
> +	len += nla_total_size(sizeof(u8)); /* _MM_ACTIVE */
> +	len += nla_total_size(sizeof(u8)); /* _MM_ADD_FRAG_SIZE */
> +
> +	if (req_base->flags & ETHTOOL_FLAG_STATS)
> +		len += nla_total_size(0) + /* _MM_STATS */
> +		       nla_total_size_64bit(sizeof(u64)) * ETHTOOL_MM_STAT_CNT;
> +
> +	return len;
> +}
> +
> +static int mm_put_stat(struct sk_buff *skb, u64 val, u16 attrtype)
> +{
> +	if (val == ETHTOOL_STAT_NOT_SET)
> +		return 0;
> +	if (nla_put_u64_64bit(skb, attrtype, val, ETHTOOL_A_MM_STAT_PAD))
> +		return -EMSGSIZE;
> +	return 0;
> +}
> +
> +static int mm_put_stats(struct sk_buff *skb,
> +			const struct ethtool_mm_stats *stats)
> +{
> +	struct nlattr *nest;
> +
> +	nest = nla_nest_start(skb, ETHTOOL_A_MM_STATS);
> +	if (!nest)
> +		return -EMSGSIZE;
> +
> +	if (mm_put_stat(skb, stats->MACMergeFrameAssErrorCount,
> +			ETHTOOL_A_MM_STAT_REASSEMBLY_ERRORS) ||
> +	    mm_put_stat(skb, stats->MACMergeFrameSmdErrorCount,
> +			ETHTOOL_A_MM_STAT_SMD_ERRORS) ||
> +	    mm_put_stat(skb, stats->MACMergeFrameAssOkCount,
> +			ETHTOOL_A_MM_STAT_REASSEMBLY_OK) ||
> +	    mm_put_stat(skb, stats->MACMergeFragCountRx,
> +			ETHTOOL_A_MM_STAT_RX_FRAG_COUNT) ||
> +	    mm_put_stat(skb, stats->MACMergeFragCountTx,
> +			ETHTOOL_A_MM_STAT_TX_FRAG_COUNT) ||
> +	    mm_put_stat(skb, stats->MACMergeHoldCount,
> +			ETHTOOL_A_MM_STAT_HOLD_COUNT))
> +		goto err_cancel;
> +
> +	nla_nest_end(skb, nest);
> +	return 0;
> +
> +err_cancel:
> +	nla_nest_cancel(skb, nest);
> +	return -EMSGSIZE;
> +}
> +
> +static int mm_fill_reply(struct sk_buff *skb,
> +			 const struct ethnl_req_info *req_base,
> +			 const struct ethnl_reply_data *reply_base)
> +{
> +	const struct mm_reply_data *data = MM_REPDATA(reply_base);
> +	const struct ethtool_mm_state *state = &data->state;
> +
> +	if (nla_put_u8(skb, ETHTOOL_A_MM_VERIFY_STATUS, state->verify_status) ||
> +	    nla_put_u32(skb, ETHTOOL_A_MM_VERIFY_TIME, state->verify_time) ||
> +	    nla_put_u8(skb, ETHTOOL_A_MM_SUPPORTED, state->supported) ||
> +	    nla_put_u8(skb, ETHTOOL_A_MM_ENABLED, state->enabled) ||
> +	    nla_put_u8(skb, ETHTOOL_A_MM_ACTIVE, state->active) ||
> +	    nla_put_u8(skb, ETHTOOL_A_MM_ADD_FRAG_SIZE, state->add_frag_size))
> +		return -EMSGSIZE;
> +
> +	if (req_base->flags & ETHTOOL_FLAG_STATS &&
> +	    mm_put_stats(skb, &data->stats))
> +		return -EMSGSIZE;
> +
> +	return 0;
> +}
> +
> +const struct ethnl_request_ops ethnl_mm_request_ops = {
> +	.request_cmd		= ETHTOOL_MSG_MM_GET,
> +	.reply_cmd		= ETHTOOL_MSG_MM_GET_REPLY,
> +	.hdr_attr		= ETHTOOL_A_MM_HEADER,
> +	.req_info_size		= sizeof(struct mm_req_info),
> +	.reply_data_size	= sizeof(struct mm_reply_data),
> +
> +	.prepare_data		= mm_prepare_data,
> +	.reply_size		= mm_reply_size,
> +	.fill_reply		= mm_fill_reply,
> +};
> +
> +const struct nla_policy ethnl_mm_set_policy[ETHTOOL_A_MM_MAX + 1] = {
> +	[ETHTOOL_A_MM_HEADER] = NLA_POLICY_NESTED(ethnl_header_policy),
> +	[ETHTOOL_A_MM_VERIFY_DISABLE] = { .type = NLA_U8 },
> +	[ETHTOOL_A_MM_VERIFY_TIME] = { .type = NLA_U32 },
> +	[ETHTOOL_A_MM_ENABLED] = { .type = NLA_U8 },
> +	[ETHTOOL_A_MM_ADD_FRAG_SIZE] = { .type = NLA_U8 },
> +};
> +
> +static void mm_state_to_cfg(const struct ethtool_mm_state *state,
> +			    struct ethtool_mm_cfg *cfg)
> +{
> +	cfg->verify_disable =
> +		state->verify_status == ETHTOOL_MM_VERIFY_STATUS_DISABLED;
> +	cfg->verify_time = state->verify_time;
> +	cfg->enabled = state->enabled;
> +	cfg->add_frag_size = state->add_frag_size;
> +}
> +
> +int ethnl_set_mm_cfg(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct netlink_ext_ack *extack = info->extack;
> +	struct ethnl_req_info req_info = {};
> +	struct ethtool_mm_state state = {};
> +	struct nlattr **tb = info->attrs;
> +	struct ethtool_mm_cfg cfg = {};
> +	const struct ethtool_ops *ops;
> +	struct net_device *dev;
> +	bool mod = false;
> +	int ret;
> +
> +	ret = ethnl_parse_header_dev_get(&req_info, tb[ETHTOOL_A_MM_HEADER],
> +					 genl_info_net(info), extack, true);
> +	if (ret)
> +		return ret;
> +
> +	dev = req_info.dev;
> +	ops = dev->ethtool_ops;
> +
> +	if (!ops->get_mm_state || !ops->set_mm_cfg) {
> +		ret = -EOPNOTSUPP;
> +		goto out_dev;
> +	}
> +
> +	rtnl_lock();
> +	ret = ethnl_ops_begin(dev);
> +	if (ret)
> +		goto out_rtnl;
> +
> +	ops->get_mm_state(dev, &state);
> +
> +	mm_state_to_cfg(&state, &cfg);
> +
> +	ethnl_update_bool(&cfg.verify_disable, tb[ETHTOOL_A_MM_VERIFY_DISABLE],
> +			  &mod);
> +	ethnl_update_u32(&cfg.verify_time, tb[ETHTOOL_A_MM_VERIFY_TIME], &mod);
> +	ethnl_update_bool(&cfg.enabled, tb[ETHTOOL_A_MM_ENABLED], &mod);
> +	ethnl_update_u8(&cfg.add_frag_size, tb[ETHTOOL_A_MM_ADD_FRAG_SIZE],
> +			&mod);
> +
> +	ret = ops->set_mm_cfg(dev, &cfg, extack);
> +	if (ret) {
> +		if (!extack->_msg)
> +			NL_SET_ERR_MSG(extack,
> +				       "Failed to update MAC merge configuration");
> +		goto out_ops;
> +	}
> +
> +	ethtool_notify(dev, ETHTOOL_MSG_MM_NTF, NULL);
> +
> +out_ops:
> +	ethnl_ops_complete(dev);
> +out_rtnl:
> +	rtnl_unlock();
> +out_dev:
> +	dev_put(dev);
> +	return ret;
> +}
> diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
> index e26079e11835..82ad2bd92d70 100644
> --- a/net/ethtool/netlink.c
> +++ b/net/ethtool/netlink.c
> @@ -286,6 +286,8 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
>  	[ETHTOOL_MSG_STATS_GET]		= &ethnl_stats_request_ops,
>  	[ETHTOOL_MSG_PHC_VCLOCKS_GET]	= &ethnl_phc_vclocks_request_ops,
>  	[ETHTOOL_MSG_MODULE_GET]	= &ethnl_module_request_ops,
> +	[ETHTOOL_MSG_FP_GET]		= &ethnl_fp_request_ops,
> +	[ETHTOOL_MSG_MM_GET]		= &ethnl_mm_request_ops,
>  };
>  
>  static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
> @@ -598,6 +600,8 @@ ethnl_default_notify_ops[ETHTOOL_MSG_KERNEL_MAX + 1] = {
>  	[ETHTOOL_MSG_EEE_NTF]		= &ethnl_eee_request_ops,
>  	[ETHTOOL_MSG_FEC_NTF]		= &ethnl_fec_request_ops,
>  	[ETHTOOL_MSG_MODULE_NTF]	= &ethnl_module_request_ops,
> +	[ETHTOOL_MSG_FP_NTF]		= &ethnl_fp_request_ops,
> +	[ETHTOOL_MSG_MM_NTF]		= &ethnl_mm_request_ops,
>  };
>  
>  /* default notification handler */
> @@ -691,6 +695,8 @@ static const ethnl_notify_handler_t ethnl_notify_handlers[] = {
>  	[ETHTOOL_MSG_EEE_NTF]		= ethnl_default_notify,
>  	[ETHTOOL_MSG_FEC_NTF]		= ethnl_default_notify,
>  	[ETHTOOL_MSG_MODULE_NTF]	= ethnl_default_notify,
> +	[ETHTOOL_MSG_FP_NTF]		= ethnl_default_notify,
> +	[ETHTOOL_MSG_MM_NTF]		= ethnl_default_notify,
>  };
>  
>  void ethtool_notify(struct net_device *dev, unsigned int cmd, const void *data)
> @@ -1020,6 +1026,38 @@ static const struct genl_ops ethtool_genl_ops[] = {
>  		.policy = ethnl_module_set_policy,
>  		.maxattr = ARRAY_SIZE(ethnl_module_set_policy) - 1,
>  	},
> +	{
> +		.cmd	= ETHTOOL_MSG_FP_GET,
> +		.doit	= ethnl_default_doit,
> +		.start	= ethnl_default_start,
> +		.dumpit	= ethnl_default_dumpit,
> +		.done	= ethnl_default_done,
> +		.policy = ethnl_fp_get_policy,
> +		.maxattr = ARRAY_SIZE(ethnl_fp_get_policy) - 1,
> +	},
> +	{
> +		.cmd	= ETHTOOL_MSG_FP_SET,
> +		.flags	= GENL_UNS_ADMIN_PERM,
> +		.doit	= ethnl_set_fp_param,
> +		.policy = ethnl_fp_set_policy,
> +		.maxattr = ARRAY_SIZE(ethnl_fp_set_policy) - 1,
> +	},
> +	{
> +		.cmd	= ETHTOOL_MSG_MM_GET,
> +		.doit	= ethnl_default_doit,
> +		.start	= ethnl_default_start,
> +		.dumpit	= ethnl_default_dumpit,
> +		.done	= ethnl_default_done,
> +		.policy = ethnl_mm_get_policy,
> +		.maxattr = ARRAY_SIZE(ethnl_mm_get_policy) - 1,
> +	},
> +	{
> +		.cmd	= ETHTOOL_MSG_MM_SET,
> +		.flags	= GENL_UNS_ADMIN_PERM,
> +		.doit	= ethnl_set_mm_cfg,
> +		.policy = ethnl_mm_set_policy,
> +		.maxattr = ARRAY_SIZE(ethnl_mm_set_policy) - 1,
> +	},
>  };
>  
>  static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
> diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
> index 1653fd2cf0cf..a2e56df74c85 100644
> --- a/net/ethtool/netlink.h
> +++ b/net/ethtool/netlink.h
> @@ -371,6 +371,8 @@ extern const struct ethnl_request_ops ethnl_module_eeprom_request_ops;
>  extern const struct ethnl_request_ops ethnl_stats_request_ops;
>  extern const struct ethnl_request_ops ethnl_phc_vclocks_request_ops;
>  extern const struct ethnl_request_ops ethnl_module_request_ops;
> +extern const struct ethnl_request_ops ethnl_fp_request_ops;
> +extern const struct ethnl_request_ops ethnl_mm_request_ops;
>  
>  extern const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_FLAGS + 1];
>  extern const struct nla_policy ethnl_header_policy_stats[ETHTOOL_A_HEADER_FLAGS + 1];
> @@ -409,6 +411,10 @@ extern const struct nla_policy ethnl_stats_get_policy[ETHTOOL_A_STATS_GROUPS + 1
>  extern const struct nla_policy ethnl_phc_vclocks_get_policy[ETHTOOL_A_PHC_VCLOCKS_HEADER + 1];
>  extern const struct nla_policy ethnl_module_get_policy[ETHTOOL_A_MODULE_HEADER + 1];
>  extern const struct nla_policy ethnl_module_set_policy[ETHTOOL_A_MODULE_POWER_MODE_POLICY + 1];
> +extern const struct nla_policy ethnl_fp_get_policy[ETHTOOL_A_FP_HEADER + 1];
> +extern const struct nla_policy ethnl_fp_set_policy[ETHTOOL_A_FP_MAX + 1];
> +extern const struct nla_policy ethnl_mm_get_policy[ETHTOOL_A_MM_HEADER + 1];
> +extern const struct nla_policy ethnl_mm_set_policy[ETHTOOL_A_MM_MAX + 1];
>  
>  int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
>  int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
> @@ -428,6 +434,8 @@ int ethnl_tunnel_info_start(struct netlink_callback *cb);
>  int ethnl_tunnel_info_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
>  int ethnl_set_fec(struct sk_buff *skb, struct genl_info *info);
>  int ethnl_set_module(struct sk_buff *skb, struct genl_info *info);
> +int ethnl_set_fp_param(struct sk_buff *skb, struct genl_info *info);
> +int ethnl_set_mm_cfg(struct sk_buff *skb, struct genl_info *info);
>  
>  extern const char stats_std_names[__ETHTOOL_STATS_CNT][ETH_GSTRING_LEN];
>  extern const char stats_eth_phy_names[__ETHTOOL_A_STATS_ETH_PHY_CNT][ETH_GSTRING_LEN];
> -- 
> 2.34.1
>

-- 
Vinicius
