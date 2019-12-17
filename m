Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2521C123279
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbfLQQae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:30:34 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:41812 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728188AbfLQQae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 11:30:34 -0500
Received: by mail-lj1-f193.google.com with SMTP id h23so11634037ljc.8
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 08:30:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Hxtg+YPeEh/CJ4PM9f7LQ6pCe3SqbPbTeTT9Ww5LcjE=;
        b=HT6uRgsiNb/eThMajw5UupWJSOZmSdm5zNrkj23Tsf6mkEvs0+V91gmlDj0tsNb/5b
         O4wlb6h6ufbaft78jUOoCukes8g83GHtwpw/JQTNliicZDVkG1mBq4XU5j31J9d9YZMF
         ARscxprCG2s1mQXQA1tCmxQOxXcsJBpT4NWRU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Hxtg+YPeEh/CJ4PM9f7LQ6pCe3SqbPbTeTT9Ww5LcjE=;
        b=HgxU4C3jwNjds/j1PHVoOOMCk+cYGpUHQodRQtGR8nV2uE/mDxJ5Dr5MQujBxsPyy8
         A8GI50cA+LcpoDLtWHoRefHc8jd4vFDxhIBVtQDAcFITbZLpIWGOdTNKe8mkim3oeU5H
         LzPZjbeKfKFwfF21ftlhm/4IoxNcD5hSWjCjlx7dl006yzRUDHKs51wG8P6oqKUi0kwd
         LAUpxnlVOAwd+GKy5voxu4i7UipD8V4ilY06eFa2rDmrhy+txsbLn0c70fnC/xPwDh7x
         zOaC18dnSl8abdsbwkowmeXQ6FAsdYEVR/zmDLTCNR6NEbUbeHCg1BrarJrD76BAPzmU
         x/mg==
X-Gm-Message-State: APjAAAVl8eD7U0mlgG0N+5uAMxHI6B6AptS3DahjOOVAx+bjkRUZBiXG
        xxUK+cdd3lpnjKczf1C6xuRleg==
X-Google-Smtp-Source: APXvYqxUjwrZS0rHP0TdP+4SpIDpWvHE3HfzPqlbo+em+QsQDIE+wfhwdoLWbJXBYrutq/V/OuY4MQ==
X-Received: by 2002:a2e:9886:: with SMTP id b6mr3880532ljj.47.1576600231473;
        Tue, 17 Dec 2019 08:30:31 -0800 (PST)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id y29sm12866981ljd.88.2019.12.17.08.30.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2019 08:30:30 -0800 (PST)
Subject: Re: [PATCH net-next v2] openvswitch: add TTL decrement action
To:     Matteo Croce <mcroce@redhat.com>, netdev@vger.kernel.org,
        dev@openvswitch.org
Cc:     linux-kernel@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bindiya Kurle <bindiyakurle@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        Ben Pfaff <blp@ovn.org>
References: <20191217155102.46039-1-mcroce@redhat.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <cf5b01f8-b4e4-90da-0ee7-b1d81ee6d342@cumulusnetworks.com>
Date:   Tue, 17 Dec 2019 18:30:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191217155102.46039-1-mcroce@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/12/2019 17:51, Matteo Croce wrote:
> New action to decrement TTL instead of setting it to a fixed value.
> This action will decrement the TTL and, in case of expired TTL, drop it
> or execute an action passed via a nested attribute.
> The default TTL expired action is to drop the packet.
> 
> Supports both IPv4 and IPv6 via the ttl and hop_limit fields, respectively.
> 
> Tested with a corresponding change in the userspace:
> 
>     # ovs-dpctl dump-flows
>     in_port(2),eth(),eth_type(0x0800), packets:0, bytes:0, used:never, actions:dec_ttl{ttl<=1 action:(drop)},1,1
>     in_port(1),eth(),eth_type(0x0800), packets:0, bytes:0, used:never, actions:dec_ttl{ttl<=1 action:(drop)},1,2
>     in_port(1),eth(),eth_type(0x0806), packets:0, bytes:0, used:never, actions:2
>     in_port(2),eth(),eth_type(0x0806), packets:0, bytes:0, used:never, actions:1
> 
>     # ping -c1 192.168.0.2 -t 42
>     IP (tos 0x0, ttl 41, id 61647, offset 0, flags [DF], proto ICMP (1), length 84)
>         192.168.0.1 > 192.168.0.2: ICMP echo request, id 386, seq 1, length 64
>     # ping -c1 192.168.0.2 -t 120
>     IP (tos 0x0, ttl 119, id 62070, offset 0, flags [DF], proto ICMP (1), length 84)
>         192.168.0.1 > 192.168.0.2: ICMP echo request, id 388, seq 1, length 64
>     # ping -c1 192.168.0.2 -t 1
>     #
> 
> Co-authored-by: Bindiya Kurle <bindiyakurle@gmail.com>
> Signed-off-by: Bindiya Kurle <bindiyakurle@gmail.com>
> Signed-off-by: Matteo Croce <mcroce@redhat.com>
> ---
>  include/uapi/linux/openvswitch.h |  22 +++++++
>  net/openvswitch/actions.c        |  71 +++++++++++++++++++++
>  net/openvswitch/flow_netlink.c   | 105 +++++++++++++++++++++++++++++++
>  3 files changed, 198 insertions(+)
> 

Hi Matteo,

[snip]
> +}
> +
>  /* When 'last' is true, sample() should always consume the 'skb'.
>   * Otherwise, sample() should keep 'skb' intact regardless what
>   * actions are executed within sample().
> @@ -1176,6 +1201,44 @@ static int execute_check_pkt_len(struct datapath *dp, struct sk_buff *skb,
>  			     nla_len(actions), last, clone_flow_key);
>  }
>  
> +static int execute_dec_ttl(struct sk_buff *skb, struct sw_flow_key *key)
> +{
> +	int err;
> +
> +	if (skb->protocol == htons(ETH_P_IPV6)) {
> +		struct ipv6hdr *nh = ipv6_hdr(skb);
> +
> +		err = skb_ensure_writable(skb, skb_network_offset(skb) +
> +					  sizeof(*nh));

skb_ensure_writable() calls pskb_may_pull() which may reallocate so nh might become invalid.
It seems the IPv4 version below is ok as the ptr is reloaded.

One q as I don't know ovs that much - can this action be called only with
skb->protocol ==  ETH_P_IP/IPV6 ? I.e. Are we sure that if it's not v6, then it must be v4 ?


Thanks,
 Nik

> +		if (unlikely(err))
> +			return err;
> +
> +		if (nh->hop_limit <= 1)
> +			return -EHOSTUNREACH;
> +
> +		key->ip.ttl = --nh->hop_limit;
> +	} else {
> +		struct iphdr *nh = ip_hdr(skb);
> +		u8 old_ttl;
> +
> +		err = skb_ensure_writable(skb, skb_network_offset(skb) +
> +					  sizeof(*nh));
> +		if (unlikely(err))
> +			return err;
> +
> +		nh = ip_hdr(skb);
> +		if (nh->ttl <= 1)
> +			return -EHOSTUNREACH;
> +
> +		old_ttl = nh->ttl--;
> +		csum_replace2(&nh->check, htons(old_ttl << 8),
> +			      htons(nh->ttl << 8));
> +		key->ip.ttl = nh->ttl;
> +	}
> +
> +	return 0;
> +}
> +
>  /* Execute a list of actions against 'skb'. */
>  static int do_execute_actions(struct datapath *dp, struct sk_buff *skb,
>  			      struct sw_flow_key *key,
> @@ -1347,6 +1410,14 @@ static int do_execute_actions(struct datapath *dp, struct sk_buff *skb,
>  
>  			break;
>  		}
> +
> +		case OVS_ACTION_ATTR_DEC_TTL:
> +			err = execute_dec_ttl(skb, key);
> +			if (err == -EHOSTUNREACH) {
> +				err = dec_ttl(dp, skb, key, a, true);
> +				return err;
> +			}
> +			break;
>  		}
>  
>  		if (unlikely(err)) {
> diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
> index 65c2e3458ff5..a9eea2ffb8b0 100644
> --- a/net/openvswitch/flow_netlink.c
> +++ b/net/openvswitch/flow_netlink.c
> @@ -61,6 +61,7 @@ static bool actions_may_change_flow(const struct nlattr *actions)
>  		case OVS_ACTION_ATTR_RECIRC:
>  		case OVS_ACTION_ATTR_TRUNC:
>  		case OVS_ACTION_ATTR_USERSPACE:
> +		case OVS_ACTION_ATTR_DEC_TTL:
>  			break;
>  
>  		case OVS_ACTION_ATTR_CT:
> @@ -2494,6 +2495,59 @@ static int validate_and_copy_sample(struct net *net, const struct nlattr *attr,
>  	return 0;
>  }
>  
> +static int validate_and_copy_dec_ttl(struct net *net, const struct nlattr *attr,
> +				     const struct sw_flow_key *key,
> +				     struct sw_flow_actions **sfa,
> +				     __be16 eth_type, __be16 vlan_tci,
> +				     u32 mpls_label_count, bool log)
> +{
> +	struct nlattr *attrs[OVS_DEC_TTL_ATTR_MAX + 1] = { 0 };
> +	const struct nlattr *action_type, *action;
> +	struct nlattr *a;
> +	int rem, start, err;
> +	struct dec_ttl_arg arg;
> +
> +	nla_for_each_nested(a, attr, rem) {
> +		int type = nla_type(a);
> +
> +		if (!type || type > OVS_DEC_TTL_ATTR_MAX || attrs[type])
> +			return -EINVAL;
> +
> +		attrs[type] = a;
> +	}
> +	if (rem)
> +		return -EINVAL;
> +
> +	action_type = attrs[OVS_DEC_TTL_ATTR_ACTION_TYPE];
> +	if (!action_type || nla_len(action_type) != sizeof(u32))
> +		return -EINVAL;
> +
> +	start = add_nested_action_start(sfa, OVS_ACTION_ATTR_DEC_TTL, log);
> +	if (start < 0)
> +		return start;
> +
> +	arg.action_type = nla_get_u32(action_type);
> +	err = ovs_nla_add_action(sfa, OVS_DEC_TTL_ATTR_ARG,
> +				 &arg, sizeof(arg), log);
> +	if (err)
> +		return err;
> +
> +	if (arg.action_type == OVS_DEC_TTL_ACTION_USER_SPACE) {
> +		action = attrs[OVS_DEC_TTL_ATTR_ACTION];
> +		if (!action || (nla_len(action) && nla_len(action) < NLA_HDRLEN))
> +			return -EINVAL;
> +
> +		err = __ovs_nla_copy_actions(net, action, key, sfa, eth_type,
> +					     vlan_tci, mpls_label_count, log);
> +		if (err)
> +			return err;
> +	}
> +
> +	add_nested_action_end(*sfa, start);
> +
> +	return 0;
> +}
> +
>  static int validate_and_copy_clone(struct net *net,
>  				   const struct nlattr *attr,
>  				   const struct sw_flow_key *key,
> @@ -3005,6 +3059,7 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
>  			[OVS_ACTION_ATTR_METER] = sizeof(u32),
>  			[OVS_ACTION_ATTR_CLONE] = (u32)-1,
>  			[OVS_ACTION_ATTR_CHECK_PKT_LEN] = (u32)-1,
> +			[OVS_ACTION_ATTR_DEC_TTL] = (u32)-1,
>  		};
>  		const struct ovs_action_push_vlan *vlan;
>  		int type = nla_type(a);
> @@ -3233,6 +3288,15 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
>  			break;
>  		}
>  
> +		case OVS_ACTION_ATTR_DEC_TTL:
> +			err = validate_and_copy_dec_ttl(net, a, key, sfa,
> +							eth_type, vlan_tci,
> +							mpls_label_count, log);
> +			if (err)
> +				return err;
> +			skip_copy = true;
> +			break;
> +
>  		default:
>  			OVS_NLERR(log, "Unknown Action type %d", type);
>  			return -EINVAL;
> @@ -3404,6 +3468,41 @@ static int check_pkt_len_action_to_attr(const struct nlattr *attr,
>  	return err;
>  }
>  
> +static int dec_ttl_action_to_attr(const struct nlattr *att, struct sk_buff *skb)
> +{
> +	struct nlattr *start, *ac_start = NULL, *dec_ttl;
> +	int err = 0, rem = nla_len(att);
> +	const struct dec_ttl_arg *arg;
> +	struct nlattr *actions;
> +
> +	start = nla_nest_start_noflag(skb, OVS_ACTION_ATTR_DEC_TTL);
> +	if (!start)
> +		return -EMSGSIZE;
> +
> +	dec_ttl = nla_data(att);
> +	arg = nla_data(dec_ttl);
> +	actions = nla_next(dec_ttl, &rem);
> +
> +	if (nla_put_u32(skb, OVS_DEC_TTL_ATTR_ACTION_TYPE, arg->action_type)) {
> +		nla_nest_cancel(skb, start);
> +		return -EMSGSIZE;
> +	}
> +
> +	if (arg->action_type == OVS_DEC_TTL_ACTION_USER_SPACE) {
> +		ac_start = nla_nest_start_noflag(skb, OVS_DEC_TTL_ATTR_ACTION);
> +		if (!ac_start) {
> +			nla_nest_cancel(skb, ac_start);
> +			nla_nest_cancel(skb, start);
> +			return -EMSGSIZE;
> +		}
> +		err = ovs_nla_put_actions(actions, rem, skb);
> +		nla_nest_end(skb, ac_start);
> +	}
> +	nla_nest_end(skb, start);
> +
> +	return err;
> +}
> +
>  static int set_action_to_attr(const struct nlattr *a, struct sk_buff *skb)
>  {
>  	const struct nlattr *ovs_key = nla_data(a);
> @@ -3504,6 +3603,12 @@ int ovs_nla_put_actions(const struct nlattr *attr, int len, struct sk_buff *skb)
>  				return err;
>  			break;
>  
> +		case OVS_ACTION_ATTR_DEC_TTL:
> +			err = dec_ttl_action_to_attr(a, skb);
> +			if (err)
> +				return err;
> +			break;
> +
>  		default:
>  			if (nla_put(skb, type, nla_len(a), nla_data(a)))
>  				return -EMSGSIZE;
> 

