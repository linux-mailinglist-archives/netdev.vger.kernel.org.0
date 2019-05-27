Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADD32B896
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 17:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbfE0Pr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 11:47:26 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:33116 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbfE0Pr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 11:47:26 -0400
Received: by mail-ed1-f67.google.com with SMTP id n17so27375612edb.0
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 08:47:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=dYvtZe8NZ2mWk6AP9i6tCL6vfk/7tsGyF4TTVtbZfF8=;
        b=VIW0mWMAkXIWn3TqiAbu7jFbfqZnWXK2qTzvT6hgvRk2H1LhBQo8fviOiRhPTzj2TA
         X5LpF8lw+ULwgRzGoQn8uG6IVsiEHCUkIBASheYOlA5qOOylv4ZYPOKCw7rcGGH2PKsJ
         bsFwP6xBtsFgkwmBDDpIuAXYLbYO9j51thxL5ba2pRjLUqXxTpfKzUjD8O9n+FSnh0Z+
         rNRpJSiFxygOZOD9BZtf7LbAGWUSdnfhQ5dwzN5BCeDUwt3Wz7VNsRKCnDUrCSc0du7O
         F3MjGuA1TF3acORo0VDX5d6u3rWKCn3WxRodJ0/KKn6jrQvmhr2WMPWNQuV9s4j3kdfK
         qxdw==
X-Gm-Message-State: APjAAAWKcLR3uYYrl/AzzwFaDaxEIjF1j5qqzdUuNQ8vxkN+heD4nZBT
        0jbPctdzCf9k+lLbexO7Jk0BbW7kXug=
X-Google-Smtp-Source: APXvYqyYrH0O6TWXftYrRkWeJNNGB8hibDlal9k40il90e7iZmO4qlYt8hWIGb0xtaVV8Pj5Zs5tQA==
X-Received: by 2002:a17:906:58c8:: with SMTP id e8mr85294298ejs.268.1558972042136;
        Mon, 27 May 2019 08:47:22 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id j13sm3397362eda.91.2019.05.27.08.47.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 27 May 2019 08:47:21 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5E1FC18031C; Mon, 27 May 2019 17:47:20 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Cc:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v5] net: sched: Introduce act_ctinfo action
In-Reply-To: <20190527111716.94736-1-ldir@darbyshire-bryant.me.uk>
References: <87h89kx74q.fsf@toke.dk> <20190527111716.94736-1-ldir@darbyshire-bryant.me.uk>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 27 May 2019 17:47:20 +0200
Message-ID: <8736kzyk53.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk> writes:

> ctinfo is a new tc filter action module.  It is designed to restore
> information contained in firewall conntrack marks to other packet fields
> and is typically used on packet ingress paths.  At present it has two
> independent sub-functions or operating modes, DSCP restoration mode &
> skb mark restoration mode.
>
> The DSCP restore mode:
>
> This mode copies DSCP values that have been placed in the firewall
> conntrack mark back into the IPv4/v6 diffserv fields of relevant
> packets.
>
> The DSCP restoration is intended for use and has been found useful for
> restoring ingress classifications based on egress classifications across
> links that bleach or otherwise change DSCP, typically home ISP Internet
> links.  Restoring DSCP on ingress on the WAN link allows qdiscs such as
> but by no means limited to CAKE to shape inbound packets according to
> policies that are easier to set & mark on egress.
>
> Ingress classification is traditionally a challenging task since
> iptables rules haven't yet run and tc filter/eBPF programs are pre-NAT
> lookups, hence are unable to see internal IPv4 addresses as used on the
> typical home masquerading gateway.  Thus marking the connection in some
> manner on egress for later restoration of classification on ingress is
> easier to implement.
>
> Parameters related to DSCP restore mode:
>
> dscpmask - a 32 bit mask of 6 contiguous bits and indicate bits of the
> conntrack mark field contain the DSCP value to be restored.
>
> statemask - a 32 bit mask of (usually) 1 bit length, outside the area
> specified by dscpmask.  This represents a conditional operation flag
> whereby the DSCP is only restored if the flag is set.  This is useful to
> implement a 'one shot' iptables based classification where the
> 'complicated' iptables rules are only run once to classify the
> connection on initial (egress) packet and subsequent packets are all
> marked/restored with the same DSCP.  A mask of zero disables the
> conditional behaviour ie. the conntrack mark DSCP bits are always
> restored to the ip diffserv field (assuming the conntrack entry is found
> & the skb is an ipv4/ipv6 type)
>
> e.g. dscpmask 0xfc000000 statemask 0x01000000
>
> |----0xFC----conntrack mark----000000---|
> | Bits 31-26 | bit 25 | bit24 |~~~ Bit 0|
> | DSCP       | unused | flag  |unused   |
> |-----------------------0x01---000000---|
>       |                   |
>       |                   |
>       ---|             Conditional flag
>          v             only restore if set
> |-ip diffserv-|
> | 6 bits      |
> |-------------|
>
> The skb mark restore mode (cpmark):
>
> This mode copies the firewall conntrack mark to the skb's mark field.
> It is completely the functional equivalent of the existing act_connmark
> action with the additional feature of being able to apply a mask to the
> restored value.
>
> Parameters related to skb mark restore mode:
>
> mask - a 32 bit mask applied to the firewall conntrack mark to mask out
> bits unwanted for restoration.  This can be useful where the conntrack
> mark is being used for different purposes by different applications.  If
> not specified and by default the whole mark field is copied (i.e.
> default mask of 0xffffffff)
>
> e.g. mask 0x00ffffff to mask out the top 8 bits being used by the
> aforementioned DSCP restore mode.
>
> |----0x00----conntrack mark----ffffff---|
> | Bits 31-24 |                          |
> | DSCP & flag|      some value here     |
> |---------------------------------------|
> 			|
> 			|
> 			v
> |------------skb mark-------------------|
> |            |                          |
> |  zeroed    |                          |
> |---------------------------------------|
>
> Overall parameters:
>
> zone - conntrack zone
>
> control - action related control (reclassify | pipe | drop | continue |
> ok | goto chain <CHAIN_INDEX>)
>
> Mode specific values are passed as parameter structures across netlink.
> Similarly statistics indicating DSCP & skb mark restoration counts are
> also returned via netlink.
>
> Signed-off-by: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>

I like the new commit message! :)

> ---
> v2 - add equivalent connmark functionality with an enhancement
>     to accept a mask
>     pass statistics for each sub-function as individual netlink
>     attributes and stop (ab)using overlimits, drops
>     update the testing config correctly
> v3 - fix a licensing silly & tidy up GPL boilerplate
> v4 - drop stray copy paste inline
>     reverse christmas tree local vars
> v5 - rebase on net-next/master not net/master by mistake - doh! now
>      applies!

Still getting errors from 'git am' for your email. It helps to add
--ignore-whitespace, but then I get ^M line endings in the resulting
file...

>      rename connmark to cpmark.
>      always use structures across netlink to pass parameters.
>      rework commit message to clarify modes & applicable parameters
>      without getting bogged down in userspace syntax.
>      restrict dscpmask parameter to 6 contiguous bits only instead
>      of >=6 contiguous bits.
>      re-order netlink TLV values into functional groupings.
>
>  include/net/tc_act/tc_ctinfo.h            |  28 ++
>  include/uapi/linux/pkt_cls.h              |   1 +
>  include/uapi/linux/tc_act/tc_ctinfo.h     |  52 +++
>  net/sched/Kconfig                         |  17 +
>  net/sched/Makefile                        |   1 +
>  net/sched/act_ctinfo.c                    | 415 ++++++++++++++++++++++
>  tools/testing/selftests/tc-testing/config |   1 +
>  7 files changed, 515 insertions(+)
>  create mode 100644 include/net/tc_act/tc_ctinfo.h
>  create mode 100644 include/uapi/linux/tc_act/tc_ctinfo.h
>  create mode 100644 net/sched/act_ctinfo.c
>
> diff --git a/include/net/tc_act/tc_ctinfo.h b/include/net/tc_act/tc_ctinfo.h
> new file mode 100644
> index 000000000000..d6a688571672
> --- /dev/null
> +++ b/include/net/tc_act/tc_ctinfo.h
> @@ -0,0 +1,28 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __NET_TC_CTINFO_H
> +#define __NET_TC_CTINFO_H
> +
> +#include <net/act_api.h>
> +
> +struct tcf_ctinfo_params {
> +	struct rcu_head rcu;
> +	struct net *net;
> +	u32 dscpmask;
> +	u32 dscpstatemask;
> +	u32 cpmarkmask;
> +	u16 zone;
> +	u8 mode;
> +	u8 dscpmaskshift;
> +};
> +
> +struct tcf_ctinfo {
> +	struct tc_action common;
> +	struct tcf_ctinfo_params __rcu *params;
> +	u64 stats_dscp_set;
> +	u64 stats_dscp_error;
> +	u64 stats_cpmark_set;
> +};
> +
> +#define to_ctinfo(a) ((struct tcf_ctinfo *)a)
> +
> +#endif /* __NET_TC_CTINFO_H */
> diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
> index 51a0496f78ea..a93680fc4bfa 100644
> --- a/include/uapi/linux/pkt_cls.h
> +++ b/include/uapi/linux/pkt_cls.h
> @@ -105,6 +105,7 @@ enum tca_id {
>  	TCA_ID_IFE = TCA_ACT_IFE,
>  	TCA_ID_SAMPLE = TCA_ACT_SAMPLE,
>  	/* other actions go here */
> +	TCA_ID_CTINFO,
>  	__TCA_ID_MAX = 255
>  };
>  
> diff --git a/include/uapi/linux/tc_act/tc_ctinfo.h b/include/uapi/linux/tc_act/tc_ctinfo.h
> new file mode 100644
> index 000000000000..48c40f657575
> --- /dev/null
> +++ b/include/uapi/linux/tc_act/tc_ctinfo.h
> @@ -0,0 +1,52 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +#ifndef __UAPI_TC_CTINFO_H
> +#define __UAPI_TC_CTINFO_H
> +
> +#include <linux/types.h>
> +#include <linux/pkt_cls.h>
> +
> +struct tc_ctinfo {
> +	tc_gen;
> +};
> +
> +struct tc_ctinfo_dscp {
> +	__u32 mask;
> +	__u32 statemask;
> +};
> +
> +struct tc_ctinfo_cpmark {
> +	__u32 mask;
> +};
> +
> +struct tc_ctinfo_stats_dscp {
> +	__u64 set;
> +	__u64 error;
> +};
> +
> +struct tc_ctinfo_stats_cpmark {
> +	__u64 set;
> +};

Ugh, no, single-entry structs are not an improvement, sorry.

I get that you want to have descriptive names, but you already get that
from the netlink type names. Besides, 'mask' and 'statemask' are not
really dependent anyway; 'statemask' could reasonably be unset with no
effect on the mask value, no?

> +enum {
> +	TCA_CTINFO_UNSPEC,
> +	TCA_CTINFO_PAD,
> +	TCA_CTINFO_TM,
> +	TCA_CTINFO_ACT,
> +	TCA_CTINFO_ZONE,
> +	TCA_CTINFO_PARMS_DSCP,
> +	TCA_CTINFO_PARMS_CPMARK,
> +	TCA_CTINFO_MODE_DSCP,
> +	TCA_CTINFO_MODE_CPMARK,
> +	TCA_CTINFO_STATS_DSCP,
> +	TCA_CTINFO_STATS_CPMARK,
> +	__TCA_CTINFO_MAX
> +};
> +
> +#define TCA_CTINFO_MAX (__TCA_CTINFO_MAX - 1)
> +
> +enum {
> +	CTINFO_MODE_DSCP	= BIT(0),
> +	CTINFO_MODE_CPMARK	= BIT(1)
> +};
> +
> +#endif
> diff --git a/net/sched/Kconfig b/net/sched/Kconfig
> index 2c72d95c3050..d104f7ee26c7 100644
> --- a/net/sched/Kconfig
> +++ b/net/sched/Kconfig
> @@ -877,6 +877,23 @@ config NET_ACT_CONNMARK
>  	  To compile this code as a module, choose M here: the
>  	  module will be called act_connmark.
>  
> +config NET_ACT_CTINFO
> +        tristate "Netfilter Connection Mark Actions"
> +        depends on NET_CLS_ACT && NETFILTER && IP_NF_IPTABLES
> +        depends on NF_CONNTRACK && NF_CONNTRACK_MARK
> +        help
> +	  Say Y here to allow transfer of a connmark stored information.
> +	  Current actions transfer connmark stored DSCP into
> +	  ipv4/v6 diffserv and/or to transfer connmark to packet
> +	  mark.  Both are useful for restoring egress based marks
> +	  back onto ingress connections for qdisc priority mapping
> +	  purposes.
> +
> +	  If unsure, say N.
> +
> +	  To compile this code as a module, choose M here: the
> +	  module will be called act_ctinfo.
> +
>  config NET_ACT_SKBMOD
>          tristate "skb data modification action"
>          depends on NET_CLS_ACT
> diff --git a/net/sched/Makefile b/net/sched/Makefile
> index 8a40431d7b5c..d54bfcbd7981 100644
> --- a/net/sched/Makefile
> +++ b/net/sched/Makefile
> @@ -21,6 +21,7 @@ obj-$(CONFIG_NET_ACT_CSUM)	+= act_csum.o
>  obj-$(CONFIG_NET_ACT_VLAN)	+= act_vlan.o
>  obj-$(CONFIG_NET_ACT_BPF)	+= act_bpf.o
>  obj-$(CONFIG_NET_ACT_CONNMARK)	+= act_connmark.o
> +obj-$(CONFIG_NET_ACT_CTINFO)	+= act_ctinfo.o
>  obj-$(CONFIG_NET_ACT_SKBMOD)	+= act_skbmod.o
>  obj-$(CONFIG_NET_ACT_IFE)	+= act_ife.o
>  obj-$(CONFIG_NET_IFE_SKBMARK)	+= act_meta_mark.o
> diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
> new file mode 100644
> index 000000000000..efcb7e0b5491
> --- /dev/null
> +++ b/net/sched/act_ctinfo.c
> @@ -0,0 +1,415 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/* net/sched/act_ctinfo.c  netfilter ctinfo connmark actions
> + *
> + * Copyright (c) 2019 Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/skbuff.h>
> +#include <linux/rtnetlink.h>
> +#include <linux/pkt_cls.h>
> +#include <linux/ip.h>
> +#include <linux/ipv6.h>
> +#include <net/netlink.h>
> +#include <net/pkt_sched.h>
> +#include <net/act_api.h>
> +#include <net/pkt_cls.h>
> +#include <uapi/linux/tc_act/tc_ctinfo.h>
> +#include <net/tc_act/tc_ctinfo.h>
> +
> +#include <net/netfilter/nf_conntrack.h>
> +#include <net/netfilter/nf_conntrack_core.h>
> +#include <net/netfilter/nf_conntrack_ecache.h>
> +#include <net/netfilter/nf_conntrack_zones.h>
> +
> +static struct tc_action_ops act_ctinfo_ops;
> +static unsigned int ctinfo_net_id;
> +
> +static void tcf_ctinfo_dscp_set(struct nf_conn *ct, struct tcf_ctinfo *ca,
> +				struct tcf_ctinfo_params *cp,
> +				struct sk_buff *skb, int wlen, int proto)
> +{
> +	u8 dscp, newdscp;
> +
> +	newdscp = (((ct->mark & cp->dscpmask) >> cp->dscpmaskshift) << 2) &
> +		     ~INET_ECN_MASK;
> +
> +	switch (proto) {
> +	case NFPROTO_IPV4:
> +		dscp = ipv4_get_dsfield(ip_hdr(skb)) & ~INET_ECN_MASK;
> +		if (dscp != newdscp) {
> +			if (likely(!skb_try_make_writable(skb, wlen))) {
> +				ipv4_change_dsfield(ip_hdr(skb),
> +						    INET_ECN_MASK,
> +						    newdscp);
> +				ca->stats_dscp_set++;
> +			} else {
> +				ca->stats_dscp_error++;
> +			}
> +		}
> +		break;
> +	case NFPROTO_IPV6:
> +		dscp = ipv6_get_dsfield(ipv6_hdr(skb)) & ~INET_ECN_MASK;
> +		if (dscp != newdscp) {
> +			if (likely(!skb_try_make_writable(skb, wlen))) {
> +				ipv6_change_dsfield(ipv6_hdr(skb),
> +						    INET_ECN_MASK,
> +						    newdscp);
> +				ca->stats_dscp_set++;
> +			} else {
> +				ca->stats_dscp_error++;
> +			}
> +		}
> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
> +static void tcf_ctinfo_cpmark_set(struct nf_conn *ct, struct tcf_ctinfo *ca,
> +				  struct tcf_ctinfo_params *cp,
> +				  struct sk_buff *skb)
> +{
> +	ca->stats_cpmark_set++;
> +	skb->mark = ct->mark & cp->cpmarkmask;
> +}
> +
> +static int tcf_ctinfo_act(struct sk_buff *skb, const struct tc_action *a,
> +			  struct tcf_result *res)
> +{
> +	const struct nf_conntrack_tuple_hash *thash = NULL;
> +	struct tcf_ctinfo *ca = to_ctinfo(a);
> +	struct nf_conntrack_tuple tuple;
> +	struct nf_conntrack_zone zone;
> +	enum ip_conntrack_info ctinfo;
> +	struct tcf_ctinfo_params *cp;
> +	struct nf_conn *ct;
> +	int proto, wlen;
> +	int action;
> +
> +	cp = rcu_dereference_bh(ca->params);
> +
> +	tcf_lastuse_update(&ca->tcf_tm);
> +	bstats_update(&ca->tcf_bstats, skb);
> +	action = READ_ONCE(ca->tcf_action);
> +
> +	wlen = skb_network_offset(skb);
> +	if (tc_skb_protocol(skb) == htons(ETH_P_IP)) {
> +		wlen += sizeof(struct iphdr);
> +		if (!pskb_may_pull(skb, wlen))
> +			goto out;
> +
> +		proto = NFPROTO_IPV4;
> +	} else if (tc_skb_protocol(skb) == htons(ETH_P_IPV6)) {
> +		wlen += sizeof(struct ipv6hdr);
> +		if (!pskb_may_pull(skb, wlen))
> +			goto out;
> +
> +		proto = NFPROTO_IPV6;
> +	} else {
> +		goto out;
> +	}
> +
> +	ct = nf_ct_get(skb, &ctinfo);
> +	if (!ct) { /* look harder, usually ingress */
> +		if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb),
> +				       proto, cp->net, &tuple))
> +			goto out;
> +		zone.id = cp->zone;
> +		zone.dir = NF_CT_DEFAULT_ZONE_DIR;
> +
> +		thash = nf_conntrack_find_get(cp->net, &zone, &tuple);
> +		if (!thash)
> +			goto out;
> +
> +		ct = nf_ct_tuplehash_to_ctrack(thash);
> +	}
> +
> +	if (cp->mode & CTINFO_MODE_DSCP)
> +		if (!cp->dscpstatemask || (ct->mark & cp->dscpstatemask))
> +			tcf_ctinfo_dscp_set(ct, ca, cp, skb, wlen, proto);
> +
> +	if (cp->mode & CTINFO_MODE_CPMARK)
> +		tcf_ctinfo_cpmark_set(ct, ca, cp, skb);
> +
> +	if (thash)
> +		nf_ct_put(ct);
> +out:
> +	return action;
> +}
> +
> +static const struct nla_policy ctinfo_policy[TCA_CTINFO_MAX + 1] = {
> +	[TCA_CTINFO_ACT]	  = { .len = sizeof(struct tc_ctinfo) },
> +	[TCA_CTINFO_ZONE]	  = { .type = NLA_U16 },
> +	[TCA_CTINFO_PARMS_DSCP]   = { .len = sizeof(struct tc_ctinfo_dscp) },
> +	[TCA_CTINFO_PARMS_CPMARK] = { .len = sizeof(struct tc_ctinfo_cpmark) },

The opaque structs mean that you'll actually get *less* netlink validation.

> +	[TCA_CTINFO_MODE_DSCP]    = { .type = NLA_FLAG },
> +	[TCA_CTINFO_MODE_CPMARK]  = { .type = NLA_FLAG },
> +};
> +
> +static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
> +			   struct nlattr *est, struct tc_action **a,
> +			   int ovr, int bind, bool rtnl_held,
> +			   struct tcf_proto *tp,
> +			   struct netlink_ext_ack *extack)
> +{
> +	struct tc_action_net *tn = net_generic(net, ctinfo_net_id);
> +	struct tc_ctinfo_cpmark *cpmarkparm = NULL;
> +	struct nlattr *tb[TCA_CTINFO_MAX + 1];
> +	struct tcf_ctinfo_params *cp_new;
> +	struct tcf_chain *goto_ch = NULL;
> +	struct tc_ctinfo_dscp *dscpparm;
> +	struct tcf_ctinfo *ci;
> +	struct tc_ctinfo *actparm;
> +	int ret = 0, err, i;
> +
> +	if (!nla)
> +		return -EINVAL;
> +
> +	err = nla_parse_nested(tb, TCA_CTINFO_MAX, nla, ctinfo_policy, NULL);
> +	if (err < 0)
> +		return err;
> +
> +	if (!tb[TCA_CTINFO_ACT])
> +		return -EINVAL;
> +
> +	if (tb[TCA_CTINFO_MODE_DSCP] && !tb[TCA_CTINFO_PARMS_DSCP])
> +		return -EINVAL;
> +
> +	if (tb[TCA_CTINFO_PARMS_CPMARK])
> +		cpmarkparm = nla_data(tb[TCA_CTINFO_PARMS_CPMARK]);
> +
> +	dscpparm = nla_data(tb[TCA_CTINFO_PARMS_DSCP]);
> +	actparm = nla_data(tb[TCA_CTINFO_ACT]);
> +
> +	if (dscpparm) {

This is broken; you need to check if tb[TCA_CTINFO_PARMS_DSCP] is NULL
*before* calling nla_data on it. The check afterwards will not fail, as
nla_data() adds a constant value to the 0-pointer.

Maybe just move this whole validation into the

 if(tb[TCA_CTINFO_MODE_DSCP])

check?

> +		/* need contiguous 6 bit mask */
> +		i = dscpparm->mask ? __ffs(dscpparm->mask) : 0;
> +		if ((~0 & (dscpparm->mask >> i)) != 0x3f)
> +			return -EINVAL;
> +		/* mask & statemask must not overlap */
> +		if (dscpparm->mask & dscpparm->statemask)
> +			return -EINVAL;
> +	}
> +
> +	/* done the validation:now to the actual action allocation */
> +	err = tcf_idr_check_alloc(tn, &actparm->index, a, bind);
> +	if (!err) {
> +		ret = tcf_idr_create(tn, actparm->index, est, a,
> +				     &act_ctinfo_ops, bind, false);
> +		if (ret) {
> +			tcf_idr_cleanup(tn, actparm->index);
> +			return ret;
> +		}
> +	} else if (err > 0) {
> +		if (bind) /* don't override defaults */
> +			return 0;
> +		if (!ovr) {
> +			tcf_idr_release(*a, bind);
> +			return -EEXIST;
> +		}
> +	} else {
> +		return err;
> +	}
> +
> +	err = tcf_action_check_ctrlact(actparm->action, tp, &goto_ch, extack);
> +	if (err < 0)
> +		goto release_idr;
> +
> +	ci = to_ctinfo(*a);
> +
> +	cp_new = kzalloc(sizeof(*cp_new), GFP_KERNEL);
> +	if (unlikely(!cp_new)) {
> +		err = -ENOMEM;
> +		goto put_chain;
> +	}
> +
> +	cp_new->net = net;
> +	cp_new->zone = tb[TCA_CTINFO_ZONE] ?
> +			nla_get_u16(tb[TCA_CTINFO_ZONE]) : 0;
> +	if (dscpparm) {
> +		cp_new->dscpmask = dscpparm->mask;
> +		cp_new->dscpmaskshift = cp_new->dscpmask ?
> +				__ffs(cp_new->dscpmask) : 0;
> +		cp_new->dscpstatemask = dscpparm->statemask;
> +	}
> +
> +	if (cpmarkparm)
> +		cp_new->cpmarkmask = cpmarkparm->mask;
> +	else
> +		cp_new->cpmarkmask = ~0;
> +
> +	if (tb[TCA_CTINFO_MODE_DSCP])
> +		cp_new->mode |= CTINFO_MODE_DSCP;
> +	else
> +		cp_new->mode &= ~CTINFO_MODE_DSCP;
> +
> +	if (tb[TCA_CTINFO_MODE_CPMARK])
> +		cp_new->mode |= CTINFO_MODE_CPMARK;
> +	else
> +		cp_new->mode &= ~CTINFO_MODE_CPMARK;
> +
> +	spin_lock_bh(&ci->tcf_lock);
> +	goto_ch = tcf_action_set_ctrlact(*a, actparm->action, goto_ch);
> +	rcu_swap_protected(ci->params, cp_new,
> +			   lockdep_is_held(&ci->tcf_lock));
> +	spin_unlock_bh(&ci->tcf_lock);
> +
> +	if (goto_ch)
> +		tcf_chain_put_by_act(goto_ch);
> +	if (cp_new)
> +		kfree_rcu(cp_new, rcu);
> +
> +	if (ret == ACT_P_CREATED)
> +		tcf_idr_insert(tn, *a);
> +
> +	return ret;
> +
> +put_chain:
> +	if (goto_ch)
> +		tcf_chain_put_by_act(goto_ch);
> +release_idr:
> +	tcf_idr_release(*a, bind);
> +	return err;
> +}
> +
> +static int tcf_ctinfo_dump(struct sk_buff *skb, struct tc_action *a,
> +			   int bind, int ref)
> +{
> +	struct tcf_ctinfo *ci = to_ctinfo(a);
> +	struct tc_ctinfo opt = {
> +		.index   = ci->tcf_index,
> +		.refcnt  = refcount_read(&ci->tcf_refcnt) - ref,
> +		.bindcnt = atomic_read(&ci->tcf_bindcnt) - bind,
> +	};
> +	struct tc_ctinfo_stats_cpmark cpmarkstats;
> +	unsigned char *b = skb_tail_pointer(skb);
> +	struct tc_ctinfo_stats_dscp dscpstats;
> +	struct tc_ctinfo_cpmark cpmarkparm;
> +	struct tc_ctinfo_dscp dscpparm;
> +	struct tcf_ctinfo_params *cp;
> +	struct tcf_t t;
> +
> +	spin_lock_bh(&ci->tcf_lock);
> +	cp = rcu_dereference_protected(ci->params,
> +				       lockdep_is_held(&ci->tcf_lock));
> +	opt.action = ci->tcf_action;
> +
> +	if (nla_put(skb, TCA_CTINFO_ACT, sizeof(opt), &opt))
> +		goto nla_put_failure;
> +
> +	if (cp->mode & CTINFO_MODE_DSCP) {
> +		dscpparm.mask = cp->dscpmask;
> +		dscpparm.statemask = cp->dscpstatemask;
> +		if (nla_put(skb, TCA_CTINFO_PARMS_DSCP, sizeof(dscpparm),
> +			    &dscpparm))
> +			goto nla_put_failure;
> +
> +		if (nla_put_flag(skb, TCA_CTINFO_MODE_DSCP))
> +			goto nla_put_failure;
> +
> +		dscpstats.error = ci->stats_dscp_error;
> +		dscpstats.set = ci->stats_dscp_set;
> +		if (nla_put(skb, TCA_CTINFO_STATS_DSCP, sizeof(dscpstats),
> +			    &dscpstats))
> +			goto nla_put_failure;
> +	}
> +
> +	if (cp->mode & CTINFO_MODE_CPMARK) {
> +		cpmarkparm.mask = cp->cpmarkmask;
> +		if (nla_put(skb, TCA_CTINFO_PARMS_CPMARK, sizeof(cpmarkparm),
> +			    &cpmarkparm))
> +			goto nla_put_failure;
> +
> +		if (nla_put_flag(skb, TCA_CTINFO_MODE_CPMARK))
> +			goto nla_put_failure;
> +
> +		cpmarkstats.set = ci->stats_cpmark_set;
> +		if (nla_put_u64_64bit(skb, TCA_CTINFO_STATS_CPMARK,
> +				      ci->stats_cpmark_set, TCA_CTINFO_PAD))
> +			goto nla_put_failure;
> +	}

I think you should dump all the statistics no matter the configuration.
The configuration might be changed at run-time, in which case the user
will probably still want to see the old stats from before the change.

> +	if (cp->zone) {
> +		if (nla_put_u16(skb, TCA_CTINFO_ZONE, cp->zone))
> +			goto nla_put_failure;
> +	}

The default zone is '0', so there will always be a zone set. I.e., don't
leave out the attribute entirely here, just add it with a 0-value.

> +
> +	tcf_tm_dump(&t, &ci->tcf_tm);
> +	if (nla_put_64bit(skb, TCA_CTINFO_TM, sizeof(t), &t, TCA_CTINFO_PAD))
> +		goto nla_put_failure;
> +
> +	spin_unlock_bh(&ci->tcf_lock);
> +	return skb->len;
> +
> +nla_put_failure:
> +	spin_unlock_bh(&ci->tcf_lock);
> +	nlmsg_trim(skb, b);
> +	return -1;
> +}
> +
> +static int tcf_ctinfo_walker(struct net *net, struct sk_buff *skb,
> +			     struct netlink_callback *cb, int type,
> +			     const struct tc_action_ops *ops,
> +			     struct netlink_ext_ack *extack)
> +{
> +	struct tc_action_net *tn = net_generic(net, ctinfo_net_id);
> +
> +	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
> +}
> +
> +static int tcf_ctinfo_search(struct net *net, struct tc_action **a, u32 index)
> +{
> +	struct tc_action_net *tn = net_generic(net, ctinfo_net_id);
> +
> +	return tcf_idr_search(tn, a, index);
> +}
> +
> +static struct tc_action_ops act_ctinfo_ops = {
> +	.kind	= "ctinfo",
> +	.id	= TCA_ID_CTINFO,
> +	.owner	= THIS_MODULE,
> +	.act	= tcf_ctinfo_act,
> +	.dump	= tcf_ctinfo_dump,
> +	.init	= tcf_ctinfo_init,
> +	.walk	= tcf_ctinfo_walker,
> +	.lookup	= tcf_ctinfo_search,
> +	.size	= sizeof(struct tcf_ctinfo),
> +};
> +
> +static __net_init int ctinfo_init_net(struct net *net)
> +{
> +	struct tc_action_net *tn = net_generic(net, ctinfo_net_id);
> +
> +	return tc_action_net_init(tn, &act_ctinfo_ops);
> +}
> +
> +static void __net_exit ctinfo_exit_net(struct list_head *net_list)
> +{
> +	tc_action_net_exit(net_list, ctinfo_net_id);
> +}
> +
> +static struct pernet_operations ctinfo_net_ops = {
> +	.init		= ctinfo_init_net,
> +	.exit_batch	= ctinfo_exit_net,
> +	.id		= &ctinfo_net_id,
> +	.size		= sizeof(struct tc_action_net),
> +};
> +
> +static int __init ctinfo_init_module(void)
> +{
> +	return tcf_register_action(&act_ctinfo_ops, &ctinfo_net_ops);
> +}
> +
> +static void __exit ctinfo_cleanup_module(void)
> +{
> +	tcf_unregister_action(&act_ctinfo_ops, &ctinfo_net_ops);
> +}
> +
> +module_init(ctinfo_init_module);
> +module_exit(ctinfo_cleanup_module);
> +MODULE_AUTHOR("Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>");
> +MODULE_DESCRIPTION("Connection tracking mark actions");
> +MODULE_LICENSE("GPL");
> diff --git a/tools/testing/selftests/tc-testing/config b/tools/testing/selftests/tc-testing/config
> index 203302065458..b235efd55367 100644
> --- a/tools/testing/selftests/tc-testing/config
> +++ b/tools/testing/selftests/tc-testing/config
> @@ -38,6 +38,7 @@ CONFIG_NET_ACT_CSUM=m
>  CONFIG_NET_ACT_VLAN=m
>  CONFIG_NET_ACT_BPF=m
>  CONFIG_NET_ACT_CONNMARK=m
> +CONFIG_NET_ACT_CTINFO=m
>  CONFIG_NET_ACT_SKBMOD=m
>  CONFIG_NET_ACT_IFE=m
>  CONFIG_NET_ACT_TUNNEL_KEY=m
> -- 
> 2.20.1 (Apple Git-117)
