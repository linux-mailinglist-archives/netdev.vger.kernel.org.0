Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0878A18BFD0
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 20:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbgCSTCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 15:02:38 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:38184 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726867AbgCSTCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 15:02:37 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A85DAA4006B;
        Thu, 19 Mar 2020 19:02:32 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 19 Mar
 2020 19:02:27 +0000
Subject: Re: [PATCH 13/29] netfilter: flowtable: add tunnel match offload
 support
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        <netfilter-devel@vger.kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <wenxu@ucloud.cn>
References: <20200318003956.73573-1-pablo@netfilter.org>
 <20200318003956.73573-14-pablo@netfilter.org>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <72f9e0d8-56ac-aa01-63d1-9ffdab8c13c4@solarflare.com>
Date:   Thu, 19 Mar 2020 19:02:23 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200318003956.73573-14-pablo@netfilter.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25300.003
X-TM-AS-Result: No-13.592000-8.000000-10
X-TMASE-MatchedRID: 6lay9u8oTUMbF9xF7zzuNfZvT2zYoYOwC/ExpXrHizz5+tteD5RzhTx8
        Tx4uKXdeq0GIEVgKOzShkmFbn98rMWdvGUEuKvSc5venhychcY3aCn4DqCiXNv4a3H2JF4EK7Of
        p4TaCvCdZTjyF4JLcZXtbuW3AsS2jkLQe3uHqwd1uh7qwx+D6T6gmQ5FI9tvDsp5O052MzLqeBU
        yBZcYIYGccvdaGwZ/OzFsiSx/yBgssO+kVEfVuQun1HxC6hVB/uw3ECrjepfPfUZT83lbkENGVQ
        rnZJqIeOFGwD8a7+MlHvBtZTCXDqlfLVfbg7RvGIwk7p1qp3JYNhbdB2PFoqcL0PEcqueTypsI2
        zkOap18o6wrN0LO7r/VZHDFcb4BFJ7/22eq+CeHZw6vmg2YxmfxKNdLGV09THdFjikZMLIdOV/B
        stSI7sufOVcxjDhcwAYt5KiTiutlt1O49r1VEa8RB0bsfrpPIfiAqrjYtFiQwFzc406eLPOIriV
        nEUuzfNYLgy/kZy4qE7MbXxE5TPX7cGd19dSFd
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--13.592000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25300.003
X-MDID: 1584644554-II2nbxfTIQj9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/03/2020 00:39, Pablo Neira Ayuso wrote:
> From: wenxu <wenxu@ucloud.cn>
>
> This patch support both ipv4 and ipv6 tunnel_id, tunnel_src and
> tunnel_dst match for flowtable offload
>
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
<snip>
>  static int nf_flow_rule_match(struct nf_flow_match *match,
> -			      const struct flow_offload_tuple *tuple)
> +			      const struct flow_offload_tuple *tuple,
> +			      struct dst_entry *other_dst)
>  {
>  	struct nf_flow_key *mask = &match->mask;
>  	struct nf_flow_key *key = &match->key;
> +	struct ip_tunnel_info *tun_info;
>  
>  	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_META, meta);
>  	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_CONTROL, control);
> @@ -42,6 +92,11 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
>  	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_TCP, tcp);
>  	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_PORTS, tp);
>  
> +	if (other_dst->lwtstate) {
I'm hitting a NULL dereference here, in a non-tunnel-related conntrack offload test:
tc qdisc add dev rh0vr0 ingress
tc qdisc add dev rh0 ingress
tc filter add dev rh0 parent ffff: protocol arp flower action mirred egress redirect dev rh0vr0
tc filter add dev rh0 parent ffff: protocol ip flower ip_proto icmp action mirred egress redirect dev rh0vr0
tc filter add dev rh0 parent ffff: chain 0 flower ct_state -trk action ct zone 1 pipe action goto chain 1
tc filter add dev rh0 parent ffff: chain 1 flower ct_state +trk+new action ct zone 1 commit pipe action mirred egress redirect dev rh0vr0
tc filter add dev rh0 parent ffff: chain 1 flower ct_state +trk+est skip_hw action mirred egress redirect dev rh0vr0
tc filter add dev rh0vr0 parent ffff: protocol arp flower action mirred egress redirect dev rh0
tc filter add dev rh0vr0 parent ffff: protocol ip flower ip_proto icmp action mirred egress redirect dev rh0
tc filter add dev rh0vr0 parent ffff: chain 0 flower ct_state -trk action ct zone 1 pipe action goto chain 1
tc filter add dev rh0vr0 parent ffff: chain 1 flower ct_state +trk+est skip_hw action mirred egress redirect dev rh0

{Open a TCP connection with 'nc'...}

[  113.864770] BUG: kernel NULL pointer dereference, address: 0000000000000050
[  113.867223] #PF: supervisor read access in kernel mode
[  113.868859] #PF: error_code(0x0000) - not-present page
[  113.870495] PGD 8000000119f82067 P4D 8000000119f82067 PUD 16ea1c067 PMD 0
[  113.872565] Oops: 0000 [#1] SMP PTI
[  113.873781] CPU: 0 PID: 269 Comm: kworker/0:4 Tainted: G           OE     5.6.0-rc5+ #47
[  113.876337] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-33-g43f5df79-dirty-20190916_042048-n551jm 04/01/2014
[  113.879839] Workqueue: events flow_offload_work_handler [nf_flow_table]
[  113.881835] RIP: 0010:nf_flow_offload_rule_alloc.isra.21+0xc4/0x3c0 [nf_flow_table]
[  113.884287] Code: 48 89 50 10 44 89 e8 48 89 7b 04 83 f0 01 bf 64 00 00 00 66 89 4b 36 48 98 66 89 73 2c 66 89 7b 0c 48 c1 e0 06 49 8b 44 04 38 <48> 8b 48 50 48 85 c9 0f 84 c4 00 00 00 f6 41 79 01 0f 84 ba 00 00
[  113.889680] RSP: 0018:ffffa7a8c012fdb0 EFLAGS: 00010202
[  113.891336] RAX: 0000000000000000 RBX: ffff9bd02ea16800 RCX: 0000000000000000
[  113.893466] RDX: ffff9bd02ea16840 RSI: 0000000000000060 RDI: 0000000000000064
[  113.895596] RBP: ffffa7a8c012fde0 R08: 0000000000031180 R09: ffff9bd02e884000
[  113.897729] R10: ffffa7a8c012fe00 R11: fefefefefefefeff R12: ffff9bd02ee51840
[  113.899854] R13: 0000000000000000 R14: 0000000000000000 R15: ffff9bcfd9f96e40
[  113.901982] FS:  0000000000000000(0000) GS:ffff9bd032c00000(0000) knlGS:0000000000000000
[  113.904534] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  113.908800] CR2: 0000000000000050 CR3: 000000016ef7e000 CR4: 0000000000000ef0
[  113.910931] Call Trace:
[  113.911896]  ? flow_offload_work_handler+0x1e9/0x2e0 [nf_flow_table]
[  113.913841]  ? __switch_to_asm+0x34/0x70
[  113.915167]  flow_offload_work_handler+0x1e9/0x2e0 [nf_flow_table]
[  113.917063]  ? __switch_to_asm+0x34/0x70
[  113.918392]  ? __switch_to_asm+0x40/0x70
[  113.919717]  ? __switch_to+0x7a/0x3b0
[  113.920975]  ? __switch_to_asm+0x34/0x70
[  113.922300]  process_one_work+0x197/0x390
[  113.923650]  worker_thread+0x30/0x390
[  113.924912]  ? process_one_work+0x390/0x390
[  113.926299]  kthread+0x113/0x130
[  113.927453]  ? kthread_park+0x90/0x90
[  113.928710]  ret_from_fork+0x35/0x40

From matching up the Code: line, it appears that %rax is other_dst;
 the faulting instruction is "mov 0x50(%rax),%rcx".
IOW other_dst == NULL.

-ed
> +		tun_info = lwt_tun_info(other_dst->lwtstate);
> +		nf_flow_rule_lwt_match(match, tun_info);
> +	}
> +
>  	key->meta.ingress_ifindex = tuple->iifidx;
>  	mask->meta.ingress_ifindex = 0xffffffff;
>  
> @@ -480,6 +535,7 @@ nf_flow_offload_rule_alloc(struct net *net,
>  	const struct flow_offload *flow = offload->flow;
>  	const struct flow_offload_tuple *tuple;
>  	struct nf_flow_rule *flow_rule;
> +	struct dst_entry *other_dst;
>  	int err = -ENOMEM;
>  
>  	flow_rule = kzalloc(sizeof(*flow_rule), GFP_KERNEL);
> @@ -495,7 +551,8 @@ nf_flow_offload_rule_alloc(struct net *net,
>  	flow_rule->rule->match.key = &flow_rule->match.key;
>  
>  	tuple = &flow->tuplehash[dir].tuple;
> -	err = nf_flow_rule_match(&flow_rule->match, tuple);
> +	other_dst = flow->tuplehash[!dir].tuple.dst_cache;
> +	err = nf_flow_rule_match(&flow_rule->match, tuple, other_dst);
>  	if (err < 0)
>  		goto err_flow_match;
>  

