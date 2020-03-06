Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 615F017C601
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 20:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgCFTLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 14:11:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:38886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbgCFTLK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 14:11:10 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F29BC20656;
        Fri,  6 Mar 2020 19:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583521869;
        bh=I5XbT8QZEW6+CEYOiuZ0DU2H6PyHZynEgjZpEpbsnZ4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sVeVXl5pj9av2XR9MjMwsvB2SUSwWJ7mN6asO6kfYFkmcNrnR/Jc/I0D/E1c6mI1A
         nKBcTtMmBD3cZR3rlM/wuh+C/B9PauxDpS9efUXLzZCDKSHjwLYdAXC7ANMb7zQ3iA
         EudlYYRLU2UCpf8F1ntZ2n3IMG0zWADrGgxMuUUw=
Date:   Fri, 6 Mar 2020 11:11:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Po Liu <Po.Liu@nxp.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, vinicius.gomes@intel.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        roy.zang@nxp.com, mingkai.hu@nxp.com, jerry.huang@nxp.com,
        leoyang.li@nxp.com, michael.chan@broadcom.com, vishal@chelsio.com,
        saeedm@mellanox.com, leon@kernel.org, jiri@mellanox.com,
        idosch@mellanox.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, john.hurley@netronome.com,
        simon.horman@netronome.com, pieter.jansenvanvuuren@netronome.com,
        pablo@netfilter.org, moshe@mellanox.com,
        ivan.khoronzhuk@linaro.org, m-karicheri2@ti.com,
        andre.guedes@linux.intel.com, jakub.kicinski@netronome.com
Subject: Re: [RFC,net-next  2/9] net: qos: introduce a gate control flow
 action
Message-ID: <20200306111106.09416f43@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200306125608.11717-3-Po.Liu@nxp.com>
References: <20200306125608.11717-1-Po.Liu@nxp.com>
        <20200306125608.11717-3-Po.Liu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 Mar 2020 20:56:00 +0800 Po Liu wrote:
> Introduce a ingress frame gate control flow action. tc create a gate
> action would provide a gate list to control when open/close state. when
> the gate open state, the flow could pass but not when gate state is
> close. The driver would repeat the gate list cyclically. User also could
> assign a time point to start the gate list by the basetime parameter. if
> the basetime has passed current time, start time would calculate by the
> cycletime of the gate list.
> The action gate behavior try to keep according to the IEEE 802.1Qci spec.
> For the software simulation, require the user input the clock type.
> 
> Below is the setting example in user space:
> 
> > tc qdisc add dev eth0 ingress  
> 
> > tc filter add dev eth0 parent ffff: protocol ip \  
> 	   flower src_ip 192.168.0.20 \
> 	   action gate index 2 \
> 	   sched-entry OPEN 200000000 -1 -1 \
> 	   sched-entry CLOSE 100000000 -1 -1
> 
> > tc chain del dev eth0 ingress chain 0  
> 
> "sched-entry" follow the name taprio style. gate state is
> "OPEN"/"CLOSE". Follow the period nanosecond. Then next -1 is internal
> priority value means which ingress queue should put. "-1" means
> wildcard. The last value optional specifies the maximum number of
> MSDU octets that are permitted to pass the gate during the specified
> time interval.
> 
> NOTE: This software simulator version not separate the admin/operation
> state machine. Update setting would overwrite stop the previos setting
> and waiting new cycle start.
> 
> Signed-off-by: Po Liu <Po.Liu@nxp.com>

> diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
> new file mode 100644
> index 000000000000..c2c243ca028c
> --- /dev/null
> +++ b/net/sched/act_gate.c
> @@ -0,0 +1,645 @@
> +// SPDX-License-Identifier: (GPL-2.0+)

Why the parenthesis?

> +static const struct nla_policy entry_policy[TCA_GATE_ENTRY_MAX + 1] = {
> +	[TCA_GATE_ENTRY_INDEX]		= { .type = NLA_U32 },
> +	[TCA_GATE_ENTRY_GATE]		= { .type = NLA_FLAG },
> +	[TCA_GATE_ENTRY_INTERVAL]	= { .type = NLA_U32 },
> +	[TCA_GATE_ENTRY_IPV]		= { .type = NLA_S32 },
> +	[TCA_GATE_ENTRY_MAX_OCTETS]	= { .type = NLA_S32 },
> +};
> +
> +static const struct nla_policy gate_policy[TCA_GATE_MAX + 1] = {
> +	[TCA_GATE_PARMS]		= { .len = sizeof(struct tc_gate) },
> +	[TCA_GATE_PRIORITY]		= { .type = NLA_S32 },
> +	[TCA_GATE_ENTRY_LIST]		= { .type = NLA_NESTED },
> +	[TCA_GATE_BASE_TIME]		= { .type = NLA_U64 },
> +	[TCA_GATE_CYCLE_TIME]		= { .type = NLA_U64 },
> +	[TCA_GATE_CYCLE_TIME_EXT]	= { .type = NLA_U64 },
> +	[TCA_GATE_FLAGS]		= { .type = NLA_U32 },
> +	[TCA_GATE_CLOCKID]		= { .type = NLA_S32 },
> +};
> +
> +static int fill_gate_entry(struct nlattr **tb, struct tcfg_gate_entry *entry,
> +			   struct netlink_ext_ack *extack)
> +{
> +	u32 interval = 0;
> +
> +	if (tb[TCA_GATE_ENTRY_GATE])
> +		entry->gate_state = 1;
> +	else
> +		entry->gate_state = 0;

nla_get_flag()

> +
> +	if (tb[TCA_GATE_ENTRY_INTERVAL])
> +		interval = nla_get_u32(tb[TCA_GATE_ENTRY_INTERVAL]);
> +
> +	if (interval == 0) {
> +		NL_SET_ERR_MSG(extack, "Invalid interval for schedule entry");
> +		return -EINVAL;
> +	}

> +static int parse_gate_list(struct nlattr *list,
> +			   struct tcf_gate_params *sched,
> +			   struct netlink_ext_ack *extack)
> +{
> +	struct nlattr *n;
> +	int err, rem;
> +	int i = 0;
> +
> +	if (!list)
> +		return -EINVAL;
> +
> +	nla_for_each_nested(n, list, rem) {
> +		struct tcfg_gate_entry *entry;
> +
> +		if (nla_type(n) != TCA_GATE_ONE_ENTRY) {
> +			NL_SET_ERR_MSG(extack, "Attribute isn't type 'entry'");
> +			continue;
> +		}
> +
> +		entry = kzalloc(sizeof(*entry), GFP_KERNEL);
> +		if (!entry) {
> +			NL_SET_ERR_MSG(extack, "Not enough memory for entry");
> +			return -ENOMEM;
> +		}
> +
> +		err = parse_gate_entry(n, entry, i, extack);
> +		if (err < 0) {
> +			kfree(entry);

doesn't this leak previously added entries?

> +			return err;
> +		}
> +
> +		list_add_tail(&entry->list, &sched->entries);
> +		i++;
> +	}
> +
> +	sched->num_entries = i;
> +
> +	return i;
> +}


> +static int parse_gate_entry(struct nlattr *n, struct  tcfg_gate_entry *entry,
> +			    int index, struct netlink_ext_ack *extack)
> +{
> +	struct nlattr *tb[TCA_GATE_ENTRY_MAX + 1] = { };
> +	int err;
> +
> +	err = nla_parse_nested_deprecated(tb, TCA_GATE_ENTRY_MAX, n,

Please don't use the deprecated calls in new code.

> +					  entry_policy, NULL);
> +	if (err < 0) {
> +		NL_SET_ERR_MSG(extack, "Could not parse nested entry");
> +		return -EINVAL;
> +	}
> +
> +	entry->index = index;
> +
> +	return fill_gate_entry(tb, entry, extack);
> +}
