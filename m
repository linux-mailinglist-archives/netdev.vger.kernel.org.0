Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 783924FC81A
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 01:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233174AbiDKXdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 19:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbiDKXdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 19:33:19 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD394B1E0
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 16:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649719863; x=1681255863;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=I2hHSGjL5JPe2QvCCifaeCB+3R+ek7wCqVeYv6Fujf0=;
  b=BOfJyUYCKhl6xoxZ4paWZZ8ogW+WRd1W5rXJFpKsTX4DJkeX/syAjC/H
   7pHArd1Ujdi+ljq/ylzCyBEOFee30gEyXbnF7Y0em0Pw92L1i9aXR0284
   nihCXPq4mptDR2bykJkbdVO1tKTG2ptjmMqJeDDjeDPGHtKimyqx/jPv5
   k7EQIhpuby15oiqS7K0KM/SS6Zd67/zF8MWLiI0TIiUYtcrExMRNGrK0Z
   Eoaa/NJa0LRwheH5YNO0o/f2EmmSLQXcJIifwGwFkDiUxl7drskSb6P7w
   mdsPrZuCEi8M/A3YaPgvSCWvbVKyol9/865/XbO8xFUvWYEz4IW9G9D/y
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10314"; a="261084891"
X-IronPort-AV: E=Sophos;i="5.90,252,1643702400"; 
   d="scan'208";a="261084891"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2022 16:31:03 -0700
X-IronPort-AV: E=Sophos;i="5.90,252,1643702400"; 
   d="scan'208";a="590091399"
Received: from vcostago-mobl3.jf.intel.com (HELO vcostago-mobl3) ([10.24.14.61])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2022 16:31:03 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "kuba@kernel.org" <kuba@kernel.org>, Po Liu <po.liu@nxp.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v4 02/12] taprio: Add support for frame
 preemption offload
In-Reply-To: <20210627195826.fax7l4hd2itze4pi@skbuf>
References: <20210626003314.3159402-1-vinicius.gomes@intel.com>
 <20210626003314.3159402-3-vinicius.gomes@intel.com>
 <20210627195826.fax7l4hd2itze4pi@skbuf>
Date:   Mon, 11 Apr 2022 16:31:03 -0700
Message-ID: <874k2zdwp4.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> On Fri, Jun 25, 2021 at 05:33:04PM -0700, Vinicius Costa Gomes wrote:
>> Adds a way to configure which traffic classes are marked as
>> preemptible and which are marked as express.
>> 
>> Even if frame preemption is not a "real" offload, because it can't be
>> executed purely in software, having this information near where the
>> mapping of traffic classes to queues is specified, makes it,
>> hopefully, easier to use.
>> 
>> taprio will receive the information of which traffic classes are
>> marked as express/preemptible, and when offloading frame preemption to
>> the driver will convert the information, so the driver receives which
>> queues are marked as express/preemptible.
>> 
>> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>> ---
>>  include/linux/netdevice.h      |  1 +
>>  include/net/pkt_sched.h        |  4 ++++
>>  include/uapi/linux/pkt_sched.h |  1 +
>>  net/sched/sch_taprio.c         | 43 ++++++++++++++++++++++++++++++----
>>  4 files changed, 44 insertions(+), 5 deletions(-)
>> 
>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>> index be1dcceda5e4..af5d4c5b0ad5 100644
>> --- a/include/linux/netdevice.h
>> +++ b/include/linux/netdevice.h
>> @@ -923,6 +923,7 @@ enum tc_setup_type {
>>  	TC_SETUP_QDISC_TBF,
>>  	TC_SETUP_QDISC_FIFO,
>>  	TC_SETUP_QDISC_HTB,
>> +	TC_SETUP_PREEMPT,
>>  };
>>  
>>  /* These structures hold the attributes of bpf state that are being passed
>> diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
>> index 6d7b12cba015..b4cb479d1cf5 100644
>> --- a/include/net/pkt_sched.h
>> +++ b/include/net/pkt_sched.h
>> @@ -178,6 +178,10 @@ struct tc_taprio_qopt_offload {
>>  	struct tc_taprio_sched_entry entries[];
>>  };
>>  
>> +struct tc_preempt_qopt_offload {
>> +	u32 preemptible_queues;
>> +};
>> +
>>  /* Reference counting */
>>  struct tc_taprio_qopt_offload *taprio_offload_get(struct tc_taprio_qopt_offload
>>  						  *offload);
>> diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
>> index 79a699f106b1..830ce9c9ec6f 100644
>> --- a/include/uapi/linux/pkt_sched.h
>> +++ b/include/uapi/linux/pkt_sched.h
>> @@ -1241,6 +1241,7 @@ enum {
>>  	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION, /* s64 */
>>  	TCA_TAPRIO_ATTR_FLAGS, /* u32 */
>>  	TCA_TAPRIO_ATTR_TXTIME_DELAY, /* u32 */
>> +	TCA_TAPRIO_ATTR_PREEMPT_TCS, /* u32 */
>>  	__TCA_TAPRIO_ATTR_MAX,
>>  };
>>  
>> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
>> index 66fe2b82af9a..58586f98c648 100644
>> --- a/net/sched/sch_taprio.c
>> +++ b/net/sched/sch_taprio.c
>> @@ -64,6 +64,7 @@ struct taprio_sched {
>>  	struct Qdisc **qdiscs;
>>  	struct Qdisc *root;
>>  	u32 flags;
>> +	u32 preemptible_tcs;
>>  	enum tk_offsets tk_offset;
>>  	int clockid;
>>  	atomic64_t picos_per_byte; /* Using picoseconds because for 10Gbps+
>> @@ -786,6 +787,7 @@ static const struct nla_policy taprio_policy[TCA_TAPRIO_ATTR_MAX + 1] = {
>>  	[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION] = { .type = NLA_S64 },
>>  	[TCA_TAPRIO_ATTR_FLAGS]                      = { .type = NLA_U32 },
>>  	[TCA_TAPRIO_ATTR_TXTIME_DELAY]		     = { .type = NLA_U32 },
>> +	[TCA_TAPRIO_ATTR_PREEMPT_TCS]                = { .type = NLA_U32 },
>>  };
>>  
>>  static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
>> @@ -1284,6 +1286,7 @@ static int taprio_disable_offload(struct net_device *dev,
>>  				  struct netlink_ext_ack *extack)
>>  {
>>  	const struct net_device_ops *ops = dev->netdev_ops;
>> +	struct tc_preempt_qopt_offload preempt = { };
>>  	struct tc_taprio_qopt_offload *offload;
>>  	int err;
>>  
>> @@ -1302,13 +1305,15 @@ static int taprio_disable_offload(struct net_device *dev,
>>  	offload->enable = 0;
>>  
>>  	err = ops->ndo_setup_tc(dev, TC_SETUP_QDISC_TAPRIO, offload);
>> -	if (err < 0) {
>> +	if (err < 0)
>>  		NL_SET_ERR_MSG(extack,
>> -			       "Device failed to disable offload");
>> -		goto out;
>> -	}
>> +			       "Device failed to disable taprio offload");
>> +
>> +	err = ops->ndo_setup_tc(dev, TC_SETUP_PREEMPT, &preempt);
>> +	if (err < 0)
>> +		NL_SET_ERR_MSG(extack,
>> +			       "Device failed to disable frame preemption offload");
>
> First line in taprio_disable_offload() is:
>
> 	if (!FULL_OFFLOAD_IS_ENABLED(q->flags))
> 		return 0;
>
> but you said it yourself below that the preemptible queues thing is
> independent of whether you have taprio offload or not (or taprio at
> all). So the queues will never be reset back to the eMAC if you don't
> use full offload (yes, this includes txtime offload too). In fact, it's
> so independent, that I don't even know why we add them to taprio in the
> first place :)

That I didn't change taprio_disable_offload() was a mistake caused in
part by the limitations of the hardware I have (I cannot have txtime
offload and frame preemption enabled at the same time), so I didn't
catch that.

> I think the argument had to do with the hold/advance commands (other
> frame preemption stuff that's already in taprio), but those are really
> special and only to be used in the Qbv+Qbu combination, but the pMAC
> traffic classes? I don't know... Honestly I thought that me asking to
> see preemptible queues implemented for mqprio as well was going to
> discourage you, but oh well...
>

Now, the real important part, if this should be communicated to the
driver via taprio or via ethtool/netlink.   

I don't really have strong opinions on this anymore, the two options are
viable/possible.

This is going to be a niche feature, agreed, so thinking that going with
the one that gives the user more flexibility perhaps is best, i.e. using
ethtool/netlink to communicate which queues should be marked as
preemptible or express.

>>  
>> -out:
>>  	taprio_offload_free(offload);
>>  
>>  	return err;
>> @@ -1525,6 +1530,29 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>>  					       mqprio->prio_tc_map[i]);
>>  	}
>>  
>> +	/* It's valid to enable frame preemption without any kind of
>> +	 * offloading being enabled, so keep it separated.
>> +	 */
>> +	if (tb[TCA_TAPRIO_ATTR_PREEMPT_TCS]) {
>> +		u32 preempt = nla_get_u32(tb[TCA_TAPRIO_ATTR_PREEMPT_TCS]);
>> +		struct tc_preempt_qopt_offload qopt = { };
>> +
>> +		if (preempt == U32_MAX) {
>> +			NL_SET_ERR_MSG(extack, "At least one queue must be not be preemptible");
>> +			err = -EINVAL;
>> +			goto free_sched;
>> +		}
>
> Hmmm, did we somehow agree that at least one traffic class must not be
> preemptible? Citation needed.
>
>> +
>> +		qopt.preemptible_queues = tc_map_to_queue_mask(dev, preempt);
>> +
>> +		err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_PREEMPT,
>> +						    &qopt);
>> +		if (err)
>> +			goto free_sched;
>> +
>> +		q->preemptible_tcs = preempt;
>> +	}
>> +
>>  	if (FULL_OFFLOAD_IS_ENABLED(q->flags))
>>  		err = taprio_enable_offload(dev, q, new_admin, extack);
>>  	else
>> @@ -1681,6 +1709,7 @@ static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
>>  	 */
>>  	q->clockid = -1;
>>  	q->flags = TAPRIO_FLAGS_INVALID;
>> +	q->preemptible_tcs = U32_MAX;
>>  
>>  	spin_lock(&taprio_list_lock);
>>  	list_add(&q->taprio_list, &taprio_list);
>> @@ -1899,6 +1928,10 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
>>  	if (q->flags && nla_put_u32(skb, TCA_TAPRIO_ATTR_FLAGS, q->flags))
>>  		goto options_error;
>>  
>> +	if (q->preemptible_tcs != U32_MAX &&
>> +	    nla_put_u32(skb, TCA_TAPRIO_ATTR_PREEMPT_TCS, q->preemptible_tcs))
>> +		goto options_error;
>> +
>>  	if (q->txtime_delay &&
>>  	    nla_put_u32(skb, TCA_TAPRIO_ATTR_TXTIME_DELAY, q->txtime_delay))
>>  		goto options_error;
>> -- 
>> 2.32.0
>> 



-- 
Vinicius
