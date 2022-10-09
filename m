Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 550785F8DCF
	for <lists+netdev@lfdr.de>; Sun,  9 Oct 2022 22:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiJIUHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 16:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiJIUHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 16:07:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0439329818
        for <netdev@vger.kernel.org>; Sun,  9 Oct 2022 13:07:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9CDFCB80D2B
        for <netdev@vger.kernel.org>; Sun,  9 Oct 2022 20:07:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E96DFC433C1;
        Sun,  9 Oct 2022 20:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665346058;
        bh=p/ZFljB8Gjww0GVwNXCSKlsiWyJSKLlC+MFhmRmQ5Jw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=bmKc6EKDKQ+6iqiZWuKFGgzM2Cr13gfrNqEavRk2Z8OGs1x9+AxpFgSgj0Gl+V/41
         oILO7J9OoOQaBTKUJquTc45g61oUlijjYyRSa1CPOfAYMIbHLMTMzuehn1GPwwaSBL
         l+yGG8ok8UJVcCWI0L9um1Pl8iA+i1J6c+Ktsvp7YlXIYS+5aCA96IwRbZSg/qvpFC
         oo8whLXnkDBXlxgO8J5zGd3seYOfpF1D/5YjaDC1vVBQIzMSAGhaRaKIhDYuBMxFd2
         q/YvZXPBdPj/wS9uQqOHAGsdq/xaxUo/Qn7a0JYr/9n+l20+yC4GbL9opwen4SQG4R
         6nEnBDOjZ5KdA==
Message-ID: <0c35a3cc-a790-d8fb-a1a2-aeadf35fb9cf@kernel.org>
Date:   Sun, 9 Oct 2022 14:07:37 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH v2 iproute2-next 2/2] taprio: support dumping and setting
 per-tc max SDU
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
References: <20221004120028.679586-1-vladimir.oltean@nxp.com>
 <20221004120028.679586-2-vladimir.oltean@nxp.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20221004120028.679586-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-11.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/4/22 6:00 AM, Vladimir Oltean wrote:
> diff --git a/tc/q_taprio.c b/tc/q_taprio.c
> index e3af3f3fa047..45f82be1f50a 100644
> --- a/tc/q_taprio.c
> +++ b/tc/q_taprio.c
> @@ -151,13 +151,32 @@ static struct sched_entry *create_entry(uint32_t gatemask, uint32_t interval, ui
>  	return e;
>  }
>  
> +static void add_tc_entries(struct nlmsghdr *n,
> +			   __u32 max_sdu[TC_QOPT_MAX_QUEUE])
> +{
> +	struct rtattr *l;
> +	__u32 tc;
> +
> +	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++) {
> +		l = addattr_nest(n, 1024, TCA_TAPRIO_ATTR_TC_ENTRY | NLA_F_NESTED);
> +
> +		addattr_l(n, 1024, TCA_TAPRIO_TC_ENTRY_INDEX, &tc, sizeof(tc));
> +		addattr_l(n, 1024, TCA_TAPRIO_TC_ENTRY_MAX_SDU,
> +			  &max_sdu[tc], sizeof(max_sdu[tc]));
> +
> +		addattr_nest_end(n, l);


Why the full TC_QOPT_MAX_QUEUE? the parse_opt knows the index of the
last entry used.

> +	}
> +}
> +
>  static int taprio_parse_opt(struct qdisc_util *qu, int argc,
>  			    char **argv, struct nlmsghdr *n, const char *dev)
>  {
> +	__u32 max_sdu[TC_QOPT_MAX_QUEUE] = { };
>  	__s32 clockid = CLOCKID_INVALID;
>  	struct tc_mqprio_qopt opt = { };
>  	__s64 cycle_time_extension = 0;
>  	struct list_head sched_entries;
> +	bool have_tc_entries = false;
>  	struct rtattr *tail, *l;
>  	__u32 taprio_flags = 0;
>  	__u32 txtime_delay = 0;
> @@ -211,6 +230,18 @@ static int taprio_parse_opt(struct qdisc_util *qu, int argc,
>  				free(tmp);
>  				idx++;
>  			}
> +		} else if (strcmp(*argv, "max-sdu") == 0) {
> +			while (idx < TC_QOPT_MAX_QUEUE && NEXT_ARG_OK()) {
> +				NEXT_ARG();
> +				if (get_u32(&max_sdu[idx], *argv, 10)) {
> +					PREV_ARG();
> +					break;
> +				}
> +				idx++;
> +			}
> +			for ( ; idx < TC_QOPT_MAX_QUEUE; idx++)
> +				max_sdu[idx] = 0;

max_sdu is initialized to 0 and you have "have_tc_entries" to detect
multiple options on the command line.

> +			have_tc_entries = true;
>  		} else if (strcmp(*argv, "sched-entry") == 0) {
>  			uint32_t mask, interval;
>  			struct sched_entry *e;
> @@ -341,6 +372,9 @@ static int taprio_parse_opt(struct qdisc_util *qu, int argc,
>  		addattr_l(n, 1024, TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION,
>  			  &cycle_time_extension, sizeof(cycle_time_extension));
>  
> +	if (have_tc_entries)
> +		add_tc_entries(n, max_sdu);
> +
>  	l = addattr_nest(n, 1024, TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST | NLA_F_NESTED);
>  
>  	err = add_sched_list(&sched_entries, n);
> @@ -430,6 +464,59 @@ static int print_schedule(FILE *f, struct rtattr **tb)
>  	return 0;
>  }
>  
> +static void dump_tc_entry(__u32 max_sdu[TC_QOPT_MAX_QUEUE],
> +			  struct rtattr *item, bool *have_tc_entries)
> +{
> +	struct rtattr *tb[TCA_TAPRIO_TC_ENTRY_MAX + 1];
> +	__u32 tc, val = 0;
> +
> +	parse_rtattr_nested(tb, TCA_TAPRIO_TC_ENTRY_MAX, item);
> +
> +	if (!tb[TCA_TAPRIO_TC_ENTRY_INDEX]) {
> +		fprintf(stderr, "Missing tc entry index\n");
> +		return;
> +	}
> +
> +	tc = rta_getattr_u32(tb[TCA_TAPRIO_TC_ENTRY_INDEX]);
> +
> +	if (tb[TCA_TAPRIO_TC_ENTRY_MAX_SDU])
> +		val = rta_getattr_u32(tb[TCA_TAPRIO_TC_ENTRY_MAX_SDU]);
> +
> +	max_sdu[tc] = val;
> +
> +	*have_tc_entries = true;
> +}
> +
> +static void dump_tc_entries(FILE *f, struct rtattr *opt)
> +{
> +	__u32 max_sdu[TC_QOPT_MAX_QUEUE] = {};
> +	bool have_tc_entries = false;
> +	struct rtattr *i;
> +	int tc, rem;
> +
> +	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++)
> +		max_sdu[tc] = 0;

max_sdu is initialized to 0 above when it is declared.

> +
> +	rem = RTA_PAYLOAD(opt);
> +
> +	for (i = RTA_DATA(opt); RTA_OK(i, rem); i = RTA_NEXT(i, rem)) {
> +		if (i->rta_type != (TCA_TAPRIO_ATTR_TC_ENTRY | NLA_F_NESTED))
> +			continue;
> +
> +		dump_tc_entry(max_sdu, i, &have_tc_entries);
> +	}
> +
> +	if (!have_tc_entries)
> +		return;
> +
> +	open_json_array(PRINT_ANY, "max-sdu");
> +	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++)

you can know the max index so why not use it here?

