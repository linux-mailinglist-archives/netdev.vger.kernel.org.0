Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29AE26363CA
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 16:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238618AbiKWPdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 10:33:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236921AbiKWPdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 10:33:43 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17BD663EE
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 07:33:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669217621; x=1700753621;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m/aVgymTos4Ftb+Gh6/eAJ99Blu1RvFuNxuPztTJziI=;
  b=ja8KsEnSA7TSH6AmtEI1ut6Jh059Kl6DXpIE9C8eT8ihyBj20E1iLeKR
   k6/pycJHDOe55raA5Tz3/UeAU1s0rcvW0Y9tnePdZCB+4JvLDfa0dMKzj
   8JtV7139dVQuZQfUa/Dc8SPT8pUBN615etcwzJ6bCsMf+dgzXConluzgV
   YTY39SLSXK3Mo6d0/9sNdIyHbz34VV+gkMDZzLcIREXk+heh5LKBFELcJ
   wW/WNPt3UfJUo5vZ2IjXtRXIUNAAl+S0EfnszERCImtwSl1x5ujU4XZWf
   RFCYcQbzgoelLl9wqGFcANBdCUFoKJn8smBh7/xF9KrBnHTPml73l9ZRV
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="294480257"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="294480257"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 07:33:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="730817888"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="730817888"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Nov 2022 07:33:39 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2ANFXcjP028901;
        Wed, 23 Nov 2022 15:33:38 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Nikolay Borisov <nikolay.borisov@virtuozzo.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        nhorman@tuxdriver.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, kernel@virtuozzo.com
Subject: Re: [PATCH net-next v2 1/3] drop_monitor: Implement namespace filtering/reporting for software drops
Date:   Wed, 23 Nov 2022 16:33:14 +0100
Message-Id: <20221123153314.483642-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123142817.2094993-2-nikolay.borisov@virtuozzo.com>
References: <20221123142817.2094993-1-nikolay.borisov@virtuozzo.com> <20221123142817.2094993-2-nikolay.borisov@virtuozzo.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Borisov <nikolay.borisov@virtuozzo.com>
Date: Wed, 23 Nov 2022 16:28:15 +0200

> On hosts running multiple containers it's helpful to be able to see
> in which net namespace a particular drop occured. Additionally, it's
> also useful to limit drop point filtering to a single namespace,
> especially for hosts which are dropping skb's at a high rate.
> 
> Signed-off-by: Nikolay Borisov <nikolay.borisov@virtuozzo.com>
> ---
>  include/uapi/linux/net_dropmon.h |  2 ++
>  net/core/drop_monitor.c          | 36 ++++++++++++++++++++++++++++++--
>  2 files changed, 36 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
> index 84f622a66a7a..81eb2bd184e8 100644
> --- a/include/uapi/linux/net_dropmon.h
> +++ b/include/uapi/linux/net_dropmon.h
> @@ -8,6 +8,7 @@
>  struct net_dm_drop_point {
>  	__u8 pc[8];
>  	__u32 count;
> +	__u32 ns_id;
>  };
>  
>  #define is_drop_point_hw(x) do {\
> @@ -94,6 +95,7 @@ enum net_dm_attr {
>  	NET_DM_ATTR_HW_DROPS,			/* flag */
>  	NET_DM_ATTR_FLOW_ACTION_COOKIE,		/* binary */
>  	NET_DM_ATTR_REASON,			/* string */
> +	NET_DM_ATTR_NS,				/* u32 */
>  
>  	__NET_DM_ATTR_MAX,
>  	NET_DM_ATTR_MAX = __NET_DM_ATTR_MAX - 1
> diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
> index f084a4a6b7ab..680f54d21f38 100644
> --- a/net/core/drop_monitor.c
> +++ b/net/core/drop_monitor.c
> @@ -103,6 +103,7 @@ static unsigned long dm_hw_check_delta = 2*HZ;
>  static enum net_dm_alert_mode net_dm_alert_mode = NET_DM_ALERT_MODE_SUMMARY;
>  static u32 net_dm_trunc_len;
>  static u32 net_dm_queue_len = 1000;
> +static u32 net_dm_ns;
>  
>  struct net_dm_alert_ops {
>  	void (*kfree_skb_probe)(void *ignore, struct sk_buff *skb,
> @@ -210,6 +211,19 @@ static void sched_send_work(struct timer_list *t)
>  	schedule_work(&data->dm_alert_work);
>  }
>  
> +static bool drop_point_matches(struct net_dm_drop_point *point, void *location,
> +			       unsigned long ns_id)
> +{
> +	if (net_dm_ns && point->ns_id == net_dm_ns &&
> +	    !memcmp(&location, &point->pc, sizeof(void *)))

                                           ^^^^^^^^^^^^^^

Nit: sizeof(location)?

> +		return true;
> +	else if (net_dm_ns == 0 && point->ns_id == ns_id &&

                 ^^^^^^^^^^^^^^

Just `!net_dm_ns` is preferred.

> +		 !memcmp(&location, &point->pc, sizeof(void *)))
> +		return true;
> +	else
> +		return false;

I think the dup of the last condition can be avoided with oring
`(net_dm_ns && ...) || (!net_dm_ns && ...)`. Then, true/false
becomes redundant:

	return ((net_dm_ns && point->ns_id == net_dm_ns) ||
		(!net_dm_ns && point->ns_id == ns_id)) &&
	       !memcmp(&location, &point->pc, sizeof(location));

> +}
> +
>  static void trace_drop_common(struct sk_buff *skb, void *location)
>  {
>  	struct net_dm_alert_msg *msg;
> @@ -219,7 +233,11 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
>  	int i;
>  	struct sk_buff *dskb;
>  	struct per_cpu_dm_data *data;
> -	unsigned long flags;
> +	unsigned long flags, ns_id = 0;

With that line extension, it breaks RCT style. Yeah, it's already
broken a line above, but let's not introduce more style issues %)

> +
> +	if (skb->dev && net_dm_ns &&

It's faster to test net_dm_ns at first and then skb->dev. The former
is static on the BSS and the latter is dynamic. Plus the former will
be zeroed much more often than the latter.

> +	    dev_net(skb->dev)->ns.inum != net_dm_ns)
> +		return;
>  
>  	local_irq_save(flags);
>  	data = this_cpu_ptr(&dm_cpu_data);
> @@ -233,8 +251,10 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
>  	nla = genlmsg_data(nlmsg_data(nlh));
>  	msg = nla_data(nla);
>  	point = msg->points;
> +	if (skb->dev)
> +		ns_id = dev_net(skb->dev)->ns.inum;
>  	for (i = 0; i < msg->entries; i++) {
> -		if (!memcmp(&location, &point->pc, sizeof(void *))) {
> +		if (drop_point_matches(point, location, ns_id)) {
>  			point->count++;
>  			goto out;
>  		}
> @@ -249,6 +269,7 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
>  	nla->nla_len += NLA_ALIGN(sizeof(struct net_dm_drop_point));
>  	memcpy(point->pc, &location, sizeof(void *));
>  	point->count = 1;
> +	point->ns_id = ns_id;
>  	msg->entries++;
>  
>  	if (!timer_pending(&data->send_timer)) {
> @@ -1283,6 +1304,14 @@ static void net_dm_trunc_len_set(struct genl_info *info)
>  	net_dm_trunc_len = nla_get_u32(info->attrs[NET_DM_ATTR_TRUNC_LEN]);
>  }
>  
> +static void net_dm_ns_set(struct genl_info *info)
> +{
> +	if (!info->attrs[NET_DM_ATTR_NS])
> +		return;
> +
> +	net_dm_ns = nla_get_u32(info->attrs[NET_DM_ATTR_NS]);

So, if I got it correctly, it can limit the scope to only one netns.
Isn't that not flexible enough? What about a white- or black- list
of NSes to filter or filter-out?

> +}
> +
>  static void net_dm_queue_len_set(struct genl_info *info)
>  {
>  	if (!info->attrs[NET_DM_ATTR_QUEUE_LEN])
> @@ -1310,6 +1339,8 @@ static int net_dm_cmd_config(struct sk_buff *skb,
>  
>  	net_dm_queue_len_set(info);
>  
> +	net_dm_ns_set(info);
> +
>  	return 0;
>  }
>  
> @@ -1589,6 +1620,7 @@ static const struct nla_policy net_dm_nl_policy[NET_DM_ATTR_MAX + 1] = {
>  	[NET_DM_ATTR_ALERT_MODE] = { .type = NLA_U8 },
>  	[NET_DM_ATTR_TRUNC_LEN] = { .type = NLA_U32 },
>  	[NET_DM_ATTR_QUEUE_LEN] = { .type = NLA_U32 },
> +	[NET_DM_ATTR_NS]	= { .type = NLA_U32 },
>  	[NET_DM_ATTR_SW_DROPS]	= {. type = NLA_FLAG },
>  	[NET_DM_ATTR_HW_DROPS]	= {. type = NLA_FLAG },
>  };
> -- 
> 2.34.1

Thanks,
Olek
