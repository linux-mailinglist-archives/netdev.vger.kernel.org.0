Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B71345869
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 08:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhCWHPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 03:15:38 -0400
Received: from m97179.mail.qiye.163.com ([220.181.97.179]:63842 "EHLO
        m97179.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbhCWHPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 03:15:33 -0400
Received: from [192.168.188.110] (unknown [106.75.220.2])
        by m97179.mail.qiye.163.com (Hmail) with ESMTPA id 3BDB7E02A5E
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 15:15:30 +0800 (CST)
Subject: Re: [PATCH net] net/sched: act_ct: clear post_ct if doing ct_clear
To:     netdev@vger.kernel.org
References: <dd268092346925b34d5963debfd6df4410545828.1616436250.git.marcelo.leitner@gmail.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <bdc0352f-7171-a12c-9067-b6a60bd2f695@ucloud.cn>
Date:   Tue, 23 Mar 2021 15:15:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <dd268092346925b34d5963debfd6df4410545828.1616436250.git.marcelo.leitner@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZSB5LTEpIT0tKTR8dVkpNSk1PQ0hMSEtITkJVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mz46Eio*Tj0xCx4ILRpOPw41
        E0kaCh5VSlVKTUpNT0NITEhLTklCVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLTVVM
        TlVJSUtVSVlXWQgBWUFIQkhONwY+
X-HM-Tid: 0a785df0436620bdkuqy3bdb7e02a5e
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reviewed-by: wenxu <wenxu@ucloud.cn>


BR

wenxu

On 3/23/2021 2:13 AM, Marcelo Ricardo Leitner wrote:
> From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
>
> Invalid detection works with two distinct moments: act_ct tries to find
> a conntrack entry and set post_ct true, indicating that that was
> attempted. Then, when flow dissector tries to dissect CT info and no
> entry is there, it knows that it was tried and no entry was found, and
> synthesizes/sets
>                   key->ct_state = TCA_FLOWER_KEY_CT_FLAGS_TRACKED |
>                                   TCA_FLOWER_KEY_CT_FLAGS_INVALID;
> mimicing what OVS does.
>
> OVS has this a bit more streamlined, as it recomputes the key after
> trying to find a conntrack entry for it.
>
> Issue here is, when we have 'tc action ct clear', it didn't clear
> post_ct, causing a subsequent match on 'ct_state -trk' to fail, due to
> the above. The fix, thus, is to clear it.
>
> Reproducer rules:
> tc filter add dev enp130s0f0np0_0 ingress prio 1 chain 0 \
> 	protocol ip flower ip_proto tcp ct_state -trk \
> 	action ct zone 1 pipe \
> 	action goto chain 2
> tc filter add dev enp130s0f0np0_0 ingress prio 1 chain 2 \
> 	protocol ip flower \
> 	action ct clear pipe \
> 	action goto chain 4
> tc filter add dev enp130s0f0np0_0 ingress prio 1 chain 4 \
> 	protocol ip flower ct_state -trk \
> 	action mirred egress redirect dev enp130s0f1np1_0
>
> With the fix, the 3rd rule matches, like it does with OVS kernel
> datapath.
>
> Fixes: 7baf2429a1a9 ("net/sched: cls_flower add CT_FLAGS_INVALID flag support")
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
>  net/sched/act_ct.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index f0a0aa125b00ad9e34725daf0ce4457d2d2ec32c..16e888a9601dd18c7b38c6ae72494d1aa975a37e 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -945,13 +945,14 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>  	tcf_lastuse_update(&c->tcf_tm);
>  
>  	if (clear) {
> +		qdisc_skb_cb(skb)->post_ct = false;
>  		ct = nf_ct_get(skb, &ctinfo);
>  		if (ct) {
>  			nf_conntrack_put(&ct->ct_general);
>  			nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
>  		}
>  
> -		goto out;
> +		goto out_clear;
>  	}
>  
>  	family = tcf_ct_skb_nf_family(skb);
> @@ -1030,8 +1031,9 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>  	skb_push_rcsum(skb, nh_ofs);
>  
>  out:
> -	tcf_action_update_bstats(&c->common, skb);
>  	qdisc_skb_cb(skb)->post_ct = true;
> +out_clear:
> +	tcf_action_update_bstats(&c->common, skb);
>  	if (defrag)
>  		qdisc_skb_cb(skb)->pkt_len = skb->len;
>  	return retval;
