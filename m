Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7F36366D1
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 18:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239088AbiKWRR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 12:17:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239221AbiKWRRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 12:17:46 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF9BD13D19
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 09:17:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669223862; x=1700759862;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vivwRExL113GQdvXUaAnZ5oMbHK62yes42Tsh0EjULw=;
  b=gOzgNY9b88YNLpHw5w5RUDg0IMwk457Hm8k9Dh0TIhpUG8gOXLKxqFhV
   BppRBsH8lOeBBGkHSV39cNcfE2aWcCAWU5pNu1UhL+0iRpd8F8mpN3rTA
   3EpFrWyfJlvybg9IOrzkLfwdj9/NonIlBi4MDh+M+pZrzhtlto56fnptp
   maImrMq1X2vgFkOpb7Y9C/GRj4+nJg+jw3y1ovdzXCrQJOpsL3I3l5Iz+
   mIrhdyNwTlmmxnRpBXdXuGtEoXODMr6oJ5P7ymrRXR95WGDLnF00VKsgp
   H5TEkinp9KMIeEJ3ihCNkhmffGKohTm3f7s1RVJiEFstCU3AKqAqXZYJe
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="315269902"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="315269902"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 09:17:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="644186870"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="644186870"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga007.fm.intel.com with ESMTP; 23 Nov 2022 09:17:18 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2ANHHHVd019962;
        Wed, 23 Nov 2022 17:17:17 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     nb <nikolay.borisov@virtuozzo.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        nhorman@tuxdriver.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, kernel@openvz.org
Subject: Re: [PATCH net-next v2 1/3] drop_monitor: Implement namespace filtering/reporting for software drops
Date:   Wed, 23 Nov 2022 18:16:48 +0100
Message-Id: <20221123171648.486674-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <a5a38555-b784-0eee-edcd-38509994ae81@virtuozzo.com>
References: <20221123142817.2094993-1-nikolay.borisov@virtuozzo.com> <20221123142817.2094993-2-nikolay.borisov@virtuozzo.com> <20221123153314.483642-1-alexandr.lobakin@intel.com> <a5a38555-b784-0eee-edcd-38509994ae81@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: nb <nikolay.borisov@virtuozzo.com>
Date: Wed, 23 Nov 2022 18:04:25 +0200

> On 23.11.22 г. 17:33 ч., Alexander Lobakin wrote:
> > From: Nikolay Borisov <nikolay.borisov@virtuozzo.com>
> > Date: Wed, 23 Nov 2022 16:28:15 +0200
> > 
> 
> <snip>
> 
> >> @@ -1283,6 +1304,14 @@ static void net_dm_trunc_len_set(struct genl_info *info)
> >>   	net_dm_trunc_len = nla_get_u32(info->attrs[NET_DM_ATTR_TRUNC_LEN]);
> >>   }
> >>   
> >> +static void net_dm_ns_set(struct genl_info *info)
> >> +{
> >> +	if (!info->attrs[NET_DM_ATTR_NS])
> >> +		return;
> >> +
> >> +	net_dm_ns = nla_get_u32(info->attrs[NET_DM_ATTR_NS]);
> > 
> > So, if I got it correctly, it can limit the scope to only one netns.
> > Isn't that not flexible enough? What about a white- or black- list
> > of NSes to filter or filter-out?
> 
> Can do, however my current use case is to really pin-point a single 
> offending container, but yeah, you are right that a list would be more 
> flexible. I would consider doing this provided there are no blockers in 
> the code overall. Do you have any idea whether a black/white list would 
> be better? This also begs the question whether we'll support some fixed 
> amount of ns i.e an array or a list and allow an "infinite" amount of ns 
> filtering ...

I'd go with list_head to not make it limited or consume a fixed
amount of memory regardless of the actual amount of rules.

You can make it work as both white/black by having a switch
"inverse", which makes the list filtering or filtering out.

> 
> > 
> >> +}
> >> +
> >>   static void net_dm_queue_len_set(struct genl_info *info)
> >>   {
> >>   	if (!info->attrs[NET_DM_ATTR_QUEUE_LEN])
> >> @@ -1310,6 +1339,8 @@ static int net_dm_cmd_config(struct sk_buff *skb,
> >>   
> >>   	net_dm_queue_len_set(info);
> >>   
> >> +	net_dm_ns_set(info);
> >> +
> >>   	return 0;
> >>   }
> >>   
> >> @@ -1589,6 +1620,7 @@ static const struct nla_policy net_dm_nl_policy[NET_DM_ATTR_MAX + 1] = {
> >>   	[NET_DM_ATTR_ALERT_MODE] = { .type = NLA_U8 },
> >>   	[NET_DM_ATTR_TRUNC_LEN] = { .type = NLA_U32 },
> >>   	[NET_DM_ATTR_QUEUE_LEN] = { .type = NLA_U32 },
> >> +	[NET_DM_ATTR_NS]	= { .type = NLA_U32 },
> >>   	[NET_DM_ATTR_SW_DROPS]	= {. type = NLA_FLAG },
> >>   	[NET_DM_ATTR_HW_DROPS]	= {. type = NLA_FLAG },
> >>   };
> >> -- 
> >> 2.34.1
> > 
> > Thanks,
> > Olek

Thanks,
Olek
