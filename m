Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7825201FDB
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 04:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731970AbgFTCmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 22:42:21 -0400
Received: from mail-eopbgr70074.outbound.protection.outlook.com ([40.107.7.74]:40705
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726545AbgFTCmU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 22:42:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mWmZta3qyddF8AyIFKx+gQenhG8LpWqn4bFDwqHb7nPokCiexgkC0Rf/vv1b0OhPs6h8k7fnoL65j0B6VVHH1c11K1w5rdU5B41q640GDHfYkhTVLkziKp+/y9HYZpanReG/VSq1OPBjAB2JEI70Jd3SMXHwZ3E/4qMBSCLJ8eS3dU6EhwGeE+gNMuY/+UgdjpV0xWWQh+kQlVgvE/GHJ1xtNjnktFzLEKaHMtU4UIJOw7fML89D34xRnweZ6OJekeRsDHuvyZxS7ajrbOkBvfr8bGueH5hgpkw05vtuE/7aOskSGLkiiiDiDWZ5IPrvCT3bspGFTKDwzVmfTVcg8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VQGfHPWa2lEySiOVMQgAFizxjMuSTHWBPIG8svOqmG8=;
 b=eb0xfWDNd+f8VAxLaYGHtcpnXuwQ/gmNexW1etGMsjNiT6CIvrbQp9JzvzDAj3fi6Xr9769yGqCzZVa9ssq3H2CG7/qd8Sc+Rdi/n+KyBbheusBpHElJE/ZkeeeM8K0g+uRL0/8R+vgS3iUtNx6VyqtTIdGos4/1JKVFDANY0NWRrWf4YVv6xqaQddweP2gBFyiMFDYKvPsR6dLkoiY6VlP6Xk+w6CNgRLZEXGlD+I1zi6F1dOWFlaLkaM09I0PYxY5Wgpi/vgkjFtx8q3nuKs/b6gnyjYBIzvMKzv5D7Hw2evgtTz1hPiDeNE5TTNnyfBecxl1wicsIeddL8vlHoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VQGfHPWa2lEySiOVMQgAFizxjMuSTHWBPIG8svOqmG8=;
 b=pWjbUoe2sV/3Qn4WEJkT6pPIayy+oEBS4xQKIGIcdhpVFMRsvvts5ygHUk7Ai8z6P9B3gwleJsPYRnNC1lVh6SDekma8+NVbHgSQUCUSHRdrvDOPRGeGzMlMluL3BdSuMvQ6+JBApeUtO/EFowMbdB3b4zizQT11tgnCQDhCxVI=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from DB6PR0501MB2648.eurprd05.prod.outlook.com (2603:10a6:4:80::18)
 by DB6PR0501MB2597.eurprd05.prod.outlook.com (2603:10a6:4:5f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Sat, 20 Jun
 2020 02:42:13 +0000
Received: from DB6PR0501MB2648.eurprd05.prod.outlook.com
 ([fe80::4468:73d7:aecb:d08]) by DB6PR0501MB2648.eurprd05.prod.outlook.com
 ([fe80::4468:73d7:aecb:d08%7]) with mapi id 15.20.3109.021; Sat, 20 Jun 2020
 02:42:13 +0000
Subject: Re: [PATCH net-next 1/3] net/sched: Introduce action hash
To:     Davide Caratti <dcaratti@redhat.com>, netdev@vger.kernel.org
Cc:     jiri@resnulli.us, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        Jiri Pirko <jiri@mellanox.com>
References: <20200618221548.3805-1-lariel@mellanox.com>
 <20200618221548.3805-2-lariel@mellanox.com>
 <000266053809204e05e2dba71d62fab734cf6c97.camel@redhat.com>
From:   Ariel Levkovich <lariel@mellanox.com>
Message-ID: <00f14b6d-cd58-b1e0-4ba9-803b31aac41f@mellanox.com>
Date:   Fri, 19 Jun 2020 21:13:40 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <000266053809204e05e2dba71d62fab734cf6c97.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: MN2PR16CA0054.namprd16.prod.outlook.com
 (2603:10b6:208:234::23) To DB6PR0501MB2648.eurprd05.prod.outlook.com
 (2603:10a6:4:80::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2604:2000:1342:c20:1f0:6449:4f6c:39e8] (2604:2000:1342:c20:1f0:6449:4f6c:39e8) by MN2PR16CA0054.namprd16.prod.outlook.com (2603:10b6:208:234::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Sat, 20 Jun 2020 02:42:12 +0000
X-Originating-IP: [2604:2000:1342:c20:1f0:6449:4f6c:39e8]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b1fb0a0c-2379-4aec-7710-08d814c38990
X-MS-TrafficTypeDiagnostic: DB6PR0501MB2597:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0501MB259772BAC04268A047C6FB8DBA990@DB6PR0501MB2597.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0440AC9990
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aia06TyykB9RkSrSFIQn7uGVoCa7E4Az/gwORfr8KQE1+qsGf30ljUPfuGcO3l/fBFadtpMaK+74zIj+K05wZRnaWQqIG2AXFXI5blzFu/p6tgSxrvuDl2I5pi7cxI1emhR16g9Dkq1yTf2XFHbNOq/i8XH3BJviweq0LHr8IrW/RiJpMfypB0H1ONCw9igLF5WiOrF04KvUO1DAX6hOIlZFMk2H0Fe9cumJJ3NPjLjSw5Q6QxNcrCSJ9u5aw+VyqAenGR1f7UiHCPasrGK+9ZiX01W+S5fXfG4Ef+1zuwHlE4kuFeh/rlSYVewC8kEOrhjEKoBKgwTvl8yo5MwNKJjqRi4caJj5jJHDq46nqSvMgwL7CjF06fs1iXrQ1ErmE/aUMZSgYO0wsZe9zzadrrIcKKraA0FrTgIH4+b2FmCPqrgLp9HigPHlOHvIc6jq3f5ho6lvF+QtEFxNnSu0GQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR0501MB2648.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(39860400002)(376002)(366004)(346002)(6486002)(86362001)(478600001)(6666004)(36756003)(31686004)(107886003)(966005)(2906002)(5660300002)(53546011)(186003)(2616005)(316002)(4326008)(83380400001)(52116002)(8676002)(66476007)(66556008)(66946007)(16526019)(31696002)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: E/GJm9Kh2L2gujd+7aJh6IoIIZBXV69qU9ENXhUrjsajl2PonSQPA6Lyxc8PNEDOl/QvR6P3bjyOEPjU+Xlyc1SMsiaLltvT7e5wFoZAvCT0UkA7SQq7pIGXTw6Gc9ykLZV3zRvbVDluGlfVGNJ8uGhkOLuH8AUwbetFs3/aw4hR7bJ3gMvLmK5vWPVM4KIJzsIjDQF7c3S9KqYDKBtCtB/U7WYC8RATSH65rXa+TxSjWNLzDh2Vz29Jo+sQ3IpR1OBBGiMByWR/jutLtqAYAxyDeGj3rxbrMEsZ7w393fQUGHOn3ij+WdnPWLmIuPqg8HZjjjUWVkdIfMUdc7DleKiCLHSpnArLQURuOo6OiK2OMvFDS4roqQg0/qNI7Vd2PEw4OLpVWrctXIXsuroMJzEhuo+8X3mkOcmqLyQTmLPDCTnTau/LqAOFR/SAJfkfPmKPhAn6KT6XRsT9lX4mPIa7qASgYlNuL1+5pNv+Si4Jb07M+78d4ujQmVpAw+/KuIlbTd/22ZdBKpCMyojA7lYrxUqy/3vwCZTMXqE0Qdc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1fb0a0c-2379-4aec-7710-08d814c38990
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2020 02:42:13.4108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iRxHHtM+mC+I1ElEGvDr97KtWnYbLwg9cMOJ+JdQlotNg7Iwr75dOxp2NzAx7CagOWpcGl7ofAok3za9/Tm9qA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2597
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/19/20 12:13 PM, Davide Caratti wrote:
> hello Ariel,
>
> (I'm doing a resend because I suspect that my original reply was dropped
> somewhere).
>
> Thanks for your patch! some comments/questions below:
>
> On Fri, 2020-06-19 at 01:15 +0300, Ariel Levkovich wrote:
>> Allow setting a hash value to a packet for a future match.
>>
>> The action will determine the packet's hash result according to
>> the selected hash type.
>> The first option is to select a basic asymmetric l4 hash calculation
>> on the packet headers which will either use the skb->hash value as
>> if such was already calculated and set by the device driver, or it
>> will perform the kernel jenkins hash function on the packet which will
>> generate the result otherwise.
> If I understand correctly, this new tc action is going to change the skb
> metadata based on some operation done on the packet. Linux has already a
> tc module that does this job, it's act_skbedit.
>
> Wouldn't it be possible to extend act_skbedit instead of adding a new tc
> action? that would save us from some bugs we already encountered in the
> past (maybe I spotted a couple of them below), and we would also leverage on
> the existing tests.
>
>> The other option is for user to provide an BPF program which is
>> dedicated to calculate the hash. In such case the program is loaded
>> and used by tc to perform the hash calculation and provide it to
>> the hash action to be stored in skb->hash field.
>>
>> The BPF option can be useful for future HW offload support of the hash
>> calculation by emulating the HW hash function when it's different than
>> the kernel's but yet we want to maintain consistency between the SW and
>> the HW.
> Like Daniel noticed, this can be done by act_bpf. Using 'jump'
> or 'goto_chain' control actions, it should be possible to get to the same
> result combining act_skbedit and act_bpf. WDYT?


Hi Davide and Daniel,

First of all, thanks for your review and comments.


I'll try to address both of your comments regarding existing 
alternatives to this new action

here so that we can have a single thread about it.

Act_bpf indeed can provide a similar functionality. Furthermore, there 
are already existing BPF helpers

to allow user to change skb->hash within the BPF program, so there's no 
need to perform act_skbedit

after act_bpf.


However, since we are trying to offer the user multiple methods to 
calculate the hash, and not only

using a BPF program, act_bpf on its own is not enough.

If we are looking at HW offload (as Daniel mentioned), like I mentioned 
in the cover letter,

it is important that SW will be able to get the same hash result as in 
HW for a certain packet.

When certain HW is not able to forward TC the hash result, using a BPF 
program that mimics the

HW hash function is useful to maintain consistency but there are cases 
where the HW can and

does forward the hash value via the received packet's metadata and the 
vendor driver already

fills in the skb->hash with this value. In such cases BPF program usage 
can be avoided.

So to sum it up, this api is offering user both ways to calculate the hash:

1. Use the value that is already there (If the vendor driver already set 
it. If not, calculate using Linux jhash).

2. Use a given BPF program to calculate the hash and to set skb->hash 
with it.


It's true, you can cover both cases with BPF - meaning, always use BPF 
even if HW/driver can provide hash

to TC in other means but we thought about giving an option to avoid 
writing and using BPF when

it's not necessary.


Appreciate your further comments and thoughts about this and of course, 
the code comments

will be addressed and fixed.


Ariel


>
>> Usage is as follows:
>>
>> $ tc filter add dev ens1f0_0 ingress \
>> prio 1 chain 0 proto ip \
>> flower ip_proto tcp \
>> action hash bpf object-file <bpf file> \
>> action goto chain 2
> [...]
>
>> diff --git a/include/net/act_api.h b/include/net/act_api.h
>> index 8c3934880670..b7e5d060bd2f 100644
>> --- a/include/net/act_api.h
>> +++ b/include/net/act_api.h
>> @@ -12,6 +12,8 @@
>>   #include <net/net_namespace.h>
>>   #include <net/netns/generic.h>
>>   
>> +#define ACT_BPF_NAME_LEN	256
>> +
> (BTW, line above seems to be a leftover. Correct?)
>
>>   struct tcf_idrinfo {
>>   	struct mutex	lock;
>>   	struct idr	action_idr;
>>
> [...]
>
>> new file mode 100644
>> index 000000000000..40a5c34f8745
>> --- /dev/null
>> +++ b/net/sched/act_hash.c
>> @@ -0,0 +1,376 @@
>> +// SPDX-License-Identifier: GPL-2.0-or-later
>> +/* -
>> + * net/sched/act_hash.c  Hash calculation action
>> + *
>> + * Author:   Ariel Levkovich <lariel@mellanox.com>
>> + */
>> +
>> +#include <linux/init.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/rtnetlink.h>
>> +#include <linux/skbuff.h>
>> +#include <linux/filter.h>
>> +#include <net/netlink.h>
>> +#include <net/pkt_sched.h>
>> +#include <net/pkt_cls.h>
>> +#include <linux/tc_act/tc_hash.h>
>> +#include <net/tc_act/tc_hash.h>
>> +
>> +#define ACT_HASH_BPF_NAME_LEN	256
>> +
>> +static unsigned int hash_net_id;
>> +static struct tc_action_ops act_hash_ops;
>> +
>> +static int tcf_hash_act(struct sk_buff *skb, const struct tc_action *a,
>> +			struct tcf_result *res)
>> +{
>> +	struct tcf_hash *h = to_hash(a);
>> +	struct tcf_hash_params *p;
>> +	int action;
>> +	u32 hash;
>> +
>> +	tcf_lastuse_update(&h->tcf_tm);
>> +	tcf_action_update_bstats(&h->common, skb);
>> +
>> +	p = rcu_dereference_bh(h->hash_p);
>> +
>> +	action = READ_ONCE(h->tcf_action);
>> +
>> +	switch (p->alg) {
>> +	case TCA_HASH_ALG_L4:
>> +		hash = skb_get_hash(skb);
>> +		/* If a hash basis was provided, add it into
>> +		 * hash calculation here and re-set skb->hash
>> +		 * to the new result with sw_hash indication
>> +		 * and keeping the l4 hash indication.
>> +		 */
>> +		hash = jhash_1word(hash, p->basis);
>> +		__skb_set_sw_hash(skb, hash, skb->l4_hash);
> can you consider moving the above line to the data path of act_skbedit, and
> extend the control plane accordingly?
>
>> +		break;
>> +	case TCA_HASH_ALG_BPF:
> here the code is assuming that the action is at tc ingress. But
> theoretically we could install this action also on egress, nobody is
> forbidding that.  whouldn't it be better to add proper checks (or using
> directly act_bpf with appropriate control action, that already does this
> job)?
>
>> +		__skb_push(skb, skb->mac_len);
>> +		bpf_compute_data_pointers(skb);
>> +		hash = BPF_PROG_RUN(p->prog, skb);
>> +		__skb_pull(skb, skb->mac_len);
>> +		/* The BPF program hash function type is
>> +		 * unknown so only the sw hash bit is set.
>> +		 */
>> +		__skb_set_sw_hash(skb, hash, false);
>> +		break;
>> +	}
>> +	return action;
>> +}
>> +
>> +static const struct nla_policy hash_policy[TCA_HASH_MAX + 1] = {
>> +	[TCA_HASH_PARMS]	= { .type = NLA_EXACT_LEN, .len = sizeof(struct tc_hash) },
>> +	[TCA_HASH_ALG]		= { .type = NLA_U32 },
>> +	[TCA_HASH_BASIS]	= { .type = NLA_U32 },
>> +	[TCA_HASH_BPF_FD]	= { .type = NLA_U32 },
>> +	[TCA_HASH_BPF_NAME]	= { .type = NLA_NUL_STRING,
>> +				    .len = ACT_HASH_BPF_NAME_LEN },
>> +};
>> +
>> +static int tcf_hash_bpf_init(struct nlattr **tb, struct tcf_hash_params *params)
>> +{
>> +	struct bpf_prog *fp;
>> +	char *name = NULL;
>> +	u32 bpf_fd;
>> +
>> +	bpf_fd = nla_get_u32(tb[TCA_HASH_BPF_FD]);
> shouldn't we check for non-NULL tb[TCA_HASH_BPF_FD] to avoid a kernel crash here?
> please note, act_bpf does it:
>
> https://elixir.bootlin.com/linux/v5.8-rc1/source/net/sched/act_bpf.c#L337
>
> [...]
>
>> +static int tcf_hash_init(struct net *net, struct nlattr *nla,
>> +			 struct nlattr *est, struct tc_action **a,
>> +			 int replace, int bind, bool rtnl_held,
>> +			 struct tcf_proto *tp, u32 flags,
>> +			 struct netlink_ext_ack *extack)
>> +{
> [...]
>
>> +
>> +	if (!tb[TCA_HASH_ALG]) {
>> +		NL_SET_ERR_MSG_MOD(extack, "Missing hash algorithm selection");
>> +		err = -EINVAL;
>> +		goto cleanup;
>> +	}
>> +
>> +	p->alg = nla_get_u32(tb[TCA_HASH_ALG]);
> I don't understand why 'p->alg' is assigned and then validated. Wouldn't
> it be better to validate it earlier, and assign only when we know it's a
> good value? this would also avoid the spinlock unbalance below:
>
>> +	spin_lock_bh(&h->tcf_lock);
>> +
>> +	switch (p->alg) {
>> +	case TCA_HASH_ALG_L4:
>> +		break;
>> +	case TCA_HASH_ALG_BPF:
>> +		if (res != ACT_P_CREATED) {
>> +			params = rcu_dereference_protected(h->hash_p, 1);
>> +			old.prog = params->prog;
>> +			old.bpf_name = params->bpf_name;
>> +		}
>> +
>> +		err = tcf_hash_bpf_init(tb, p);
>> +		if (err)
>> +			goto cleanup;
> shouldn't we spin_unlock_bh() here?
>> +
>> +		break;
>> +	default:
>> +		NL_SET_ERR_MSG_MOD(extack, "Hash type not supported");
>> +		err = -EINVAL;
>> +		goto cleanup;
> shouldn't we spin_unlock_bh() here?
>
>> +	}
>> +	if (tb[TCA_HASH_BASIS])
>> +		p->basis = nla_get_u32(tb[TCA_HASH_BASIS]);
>> +
>> +	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
>> +	p = rcu_replace_pointer(h->hash_p, p,
>> +				lockdep_is_held(&h->tcf_lock));
>> +	spin_unlock_bh(&h->tcf_lock);
>> +
>> +	if (goto_ch)
>> +		tcf_chain_put_by_act(goto_ch);
>> +	if (p)
>> +		kfree_rcu(p, rcu);
>> +
>> +	if (res == ACT_P_CREATED) {
>> +		tcf_idr_insert(tn, *a);
>> +	} else {
>> +		synchronize_rcu();
>> +		tcf_hash_bpf_cleanup(&old);
>> +	}
>> +
>> +	return res;
>> +
>> +cleanup:
>> +	if (goto_ch)
>> +		tcf_chain_put_by_act(goto_ch);
>> +	kfree(p);
>> +
>> +release_idr:
>> +	tcf_idr_release(*a, bind);
>> +	return err;
>> +}
> thank you in advance for any feedback!
>

