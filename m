Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3EF64A8AF
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 21:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233643AbiLLUXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 15:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233645AbiLLUXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 15:23:05 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B521147;
        Mon, 12 Dec 2022 12:23:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670876584; x=1702412584;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=pUEOrwjkr8Yz8RkpPmU53Mzy3I7svyoLnp4f2P1JNrA=;
  b=M1hXYDlWHUsgik3EmGB0G7vSlECeLU4+5jaEvtMdVCdzsAtxZ3vDtYjf
   yar+sfW+f3lZilG4pOvrn5v9P5jRCQJw13j1W1uJI3ZknBmEnEkgQTiJH
   dtIS/l5rIWQ2IH3I0SZN5VDdeG7pVcrfLRxAn7Pxc4K6o9ZTusBGzM0KL
   uVngNw+3is29mb1UhDUKEzjcGwcLTBf/xIKZDEbsJNSsxPszKfJI+0YQa
   0TfW3UFDgcdBlJ7hfoNnG4xBZMjLm9Kitqv1qg7qV+HSLn+qha5u6fP7q
   y1u0c1FjVoZZLrmp4D5c6UnBVKZXilYBJjAQCALZF3/A25q/3sUnyddW+
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="297633459"
X-IronPort-AV: E=Sophos;i="5.96,239,1665471600"; 
   d="scan'208";a="297633459"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 12:23:01 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="680806497"
X-IronPort-AV: E=Sophos;i="5.96,239,1665471600"; 
   d="scan'208";a="680806497"
Received: from smuthukr-mobl2.amr.corp.intel.com (HELO vcostago-mobl3) ([10.209.133.186])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 12:22:55 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Lai Peter Jun Ann <jun.ann.lai@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Lai Peter Jun Ann <jun.ann.lai@intel.com>
Subject: Re: [PATCH net-next 1/1] taprio: Add boundary check for sched-entry
 values
In-Reply-To: <1670840632-8754-1-git-send-email-jun.ann.lai@intel.com>
References: <1670840632-8754-1-git-send-email-jun.ann.lai@intel.com>
Date:   Mon, 12 Dec 2022 17:22:52 -0300
Message-ID: <87k02wcqxv.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lai Peter Jun Ann <jun.ann.lai@intel.com> writes:

> From: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
>
> Adds boundary checks for the gatemask provided against the number of
> traffic class defined and the interval times for each sched-entry.
>
> Without this check, the user would not know that the gatemask provided is
> invalid and the driver has already truncated the gatemask provided to
> match the number of traffic class defined.
>
> The interval times is also checked for values less than 0 or for invalid
> inputs such as 00000.
>
> Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
> Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
> Signed-off-by: Lai Peter Jun Ann <jun.ann.lai@intel.com>
> ---
>  net/sched/sch_taprio.c | 32 ++++++++++++++++++++++----------
>  1 file changed, 22 insertions(+), 10 deletions(-)
>
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 570389f..76a461d 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -786,7 +786,8 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
>  
>  static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
>  			    struct sched_entry *entry,
> -			    struct netlink_ext_ack *extack)
> +			    struct netlink_ext_ack *extack,
> +			    u8 num_tc)
>  {
>  	int min_duration = length_to_duration(q, ETH_ZLEN);
>  	u32 interval = 0;
> @@ -806,11 +807,16 @@ static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
>  	/* The interval should allow at least the minimum ethernet
>  	 * frame to go out.
>  	 */
> -	if (interval < min_duration) {
> +	if (interval < min_duration || !interval) {

In what situations the case that interval is zero is not handled by
comparing against 'min_duration'? Is 'min_duration' already less than zero
in the cases you are considering? If that's true, that might mean some
other issue.

Also, this looks like a separate patch.

>  		NL_SET_ERR_MSG(extack, "Invalid interval for schedule entry");
>  		return -EINVAL;
>  	}
>  
> +	if (entry->gate_mask >= BIT_MASK(num_tc)) {
> +		NL_SET_ERR_MSG(extack, "Traffic Class defined less than gatemask");
> +		return -EINVAL;
> +	}
> +

Given the amount of gymnastics that you had to do to make this
information get here, I am considering that adding 'num_tc' to
'taprio_sched' might be a good idea.

And now that I think about it, that sounds better indeed, there are
cases where you are able to add an 'admin' schedule without specifying
any priomap (as it won't change between schedules). Your patch looks
like will give an error for that case as num_tc will be always zero.

After that 'num_tc' patch, it might be nice to add a third patch to the
series that would replace the usages of 'netdev_get_num_tc()' by
'q->num_tc' or something like that.

Does it make sense?

>  	entry->interval = interval;
>  
>  	return 0;
> @@ -818,7 +824,8 @@ static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
>  
>  static int parse_sched_entry(struct taprio_sched *q, struct nlattr *n,
>  			     struct sched_entry *entry, int index,
> -			     struct netlink_ext_ack *extack)
> +			     struct netlink_ext_ack *extack,
> +			     u8 num_tc)
>  {
>  	struct nlattr *tb[TCA_TAPRIO_SCHED_ENTRY_MAX + 1] = { };
>  	int err;
> @@ -832,12 +839,13 @@ static int parse_sched_entry(struct taprio_sched *q, struct nlattr *n,
>  
>  	entry->index = index;
>  
> -	return fill_sched_entry(q, tb, entry, extack);
> +	return fill_sched_entry(q, tb, entry, extack, num_tc);
>  }
>  
>  static int parse_sched_list(struct taprio_sched *q, struct nlattr *list,
>  			    struct sched_gate_list *sched,
> -			    struct netlink_ext_ack *extack)
> +			    struct netlink_ext_ack *extack,
> +			    u8 num_tc)
>  {
>  	struct nlattr *n;
>  	int err, rem;
> @@ -860,7 +868,7 @@ static int parse_sched_list(struct taprio_sched *q, struct nlattr *list,
>  			return -ENOMEM;
>  		}
>  
> -		err = parse_sched_entry(q, n, entry, i, extack);
> +		err = parse_sched_entry(q, n, entry, i, extack, num_tc);
>  		if (err < 0) {
>  			kfree(entry);
>  			return err;
> @@ -877,7 +885,8 @@ static int parse_sched_list(struct taprio_sched *q, struct nlattr *list,
>  
>  static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
>  				 struct sched_gate_list *new,
> -				 struct netlink_ext_ack *extack)
> +				 struct netlink_ext_ack *extack,
> +				 u8 num_tc)
>  {
>  	int err = 0;
>  
> @@ -897,7 +906,7 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
>  
>  	if (tb[TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST])
>  		err = parse_sched_list(q, tb[TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST],
> -				       new, extack);
> +				       new, extack, num_tc);
>  	if (err < 0)
>  		return err;
>  
> @@ -1541,14 +1550,17 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>  	unsigned long flags;
>  	ktime_t start;
>  	int i, err;
> +	u8 num_tc = 0;
>  
>  	err = nla_parse_nested_deprecated(tb, TCA_TAPRIO_ATTR_MAX, opt,
>  					  taprio_policy, extack);
>  	if (err < 0)
>  		return err;
>  
> -	if (tb[TCA_TAPRIO_ATTR_PRIOMAP])
> +	if (tb[TCA_TAPRIO_ATTR_PRIOMAP]) {
>  		mqprio = nla_data(tb[TCA_TAPRIO_ATTR_PRIOMAP]);
> +		num_tc = mqprio->num_tc;
> +	}

I would prefer that you only did this assignment after 'mqprio' was
properly parsed and validated.

>  
>  	err = taprio_new_flags(tb[TCA_TAPRIO_ATTR_FLAGS],
>  			       q->flags, extack);
> @@ -1585,7 +1597,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>  		goto free_sched;
>  	}
>  
> -	err = parse_taprio_schedule(q, tb, new_admin, extack);
> +	err = parse_taprio_schedule(q, tb, new_admin, extack, num_tc);
>  	if (err < 0)
>  		goto free_sched;
>  
> -- 
> 1.9.1
>


Cheers,
-- 
Vinicius
