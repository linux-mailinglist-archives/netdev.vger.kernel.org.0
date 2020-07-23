Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2373522A55A
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 04:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387497AbgGWCf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 22:35:57 -0400
Received: from mail-proxy25223.qiye.163.com ([103.129.252.23]:8003 "EHLO
        mail-proxy25223.qiye.163.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731405AbgGWCf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 22:35:56 -0400
Received: from [192.168.188.14] (unknown [106.75.220.2])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 728A841AD9;
        Thu, 23 Jul 2020 10:35:54 +0800 (CST)
Subject: Re: [PATCH net] openvswitch: fix drop over mtu packet after defrag in
 act_ct
From:   wenxu <wenxu@ucloud.cn>
To:     paulb@mellanox.com, Pravin Shelar <pshelar@ovn.org>
References: <1595300992-18381-1-git-send-email-wenxu@ucloud.cn>
Cc:     netdev@vger.kernel.org
Message-ID: <25c70926-1f20-395e-952c-b802aca2cbdc@ucloud.cn>
Date:   Thu, 23 Jul 2020 10:35:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1595300992-18381-1-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZSBoZQxpOT08aGE9CVkpOQk5PTEpMTk9MT05VGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVKS0tZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NBA6IRw*Tj5CCTwdN0MQIxEt
        NjkKCUJVSlVKTkJOT0xKTE5PQktPVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLTVVM
        TlVJSUtVSVlXWQgBWUFPT0NINwY+
X-HM-Tid: 0a737986f5842086kuqy728a841ad9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi paulb & Pravin,


Could you review for this patch> Thanks.


BR

wenxu

On 7/21/2020 11:09 AM, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
>
> When openvswitch conntrack offload with act_ct action. Fragment packets
> defrag in the ingress tc act_ct action and miss the next chain. Then the
> packet pass to the openvswitch datapath without the mru. The defrag over
> mtu packet will be dropped in output of openvswitch for over mtu.
>
> "kernel: net2: dropped over-mtu packet: 1508 > 1500"
>
> Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  include/linux/skbuff.h    | 1 +
>  include/net/sch_generic.h | 1 +
>  net/openvswitch/flow.c    | 1 +
>  net/sched/act_ct.c        | 8 ++++++--
>  net/sched/cls_api.c       | 1 +
>  5 files changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 0c0377f..0d842d6 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -283,6 +283,7 @@ struct nf_bridge_info {
>   */
>  struct tc_skb_ext {
>  	__u32 chain;
> +	__u16 mru;
>  };
>  #endif
>  
> diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
> index c510b03..45401d5 100644
> --- a/include/net/sch_generic.h
> +++ b/include/net/sch_generic.h
> @@ -384,6 +384,7 @@ struct qdisc_skb_cb {
>  	};
>  #define QDISC_CB_PRIV_LEN 20
>  	unsigned char		data[QDISC_CB_PRIV_LEN];
> +	u16			mru;
>  };
>  
>  typedef void tcf_chain_head_change_t(struct tcf_proto *tp_head, void *priv);
> diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
> index 9d375e7..03942c3 100644
> --- a/net/openvswitch/flow.c
> +++ b/net/openvswitch/flow.c
> @@ -890,6 +890,7 @@ int ovs_flow_key_extract(const struct ip_tunnel_info *tun_info,
>  	if (static_branch_unlikely(&tc_recirc_sharing_support)) {
>  		tc_ext = skb_ext_find(skb, TC_SKB_EXT);
>  		key->recirc_id = tc_ext ? tc_ext->chain : 0;
> +		OVS_CB(skb)->mru = tc_ext ? tc_ext->mru : 0;
>  	} else {
>  		key->recirc_id = 0;
>  	}
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index 5928efb..69445ab 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -706,8 +706,10 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
>  		if (err && err != -EINPROGRESS)
>  			goto out_free;
>  
> -		if (!err)
> +		if (!err) {
>  			*defrag = true;
> +			cb.mru = IPCB(skb)->frag_max_size;
> +		}
>  	} else { /* NFPROTO_IPV6 */
>  #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
>  		enum ip6_defrag_users user = IP6_DEFRAG_CONNTRACK_IN + zone;
> @@ -717,8 +719,10 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
>  		if (err && err != -EINPROGRESS)
>  			goto out_free;
>  
> -		if (!err)
> +		if (!err) {
>  			*defrag = true;
> +			cb.mru = IP6CB(skb)->frag_max_size;
> +		}
>  #else
>  		err = -EOPNOTSUPP;
>  		goto out_free;
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index e62beec..a4d9eaa 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -1628,6 +1628,7 @@ int tcf_classify_ingress(struct sk_buff *skb,
>  		if (WARN_ON_ONCE(!ext))
>  			return TC_ACT_SHOT;
>  		ext->chain = last_executed_chain;
> +		ext->mru = qdisc_skb_cb(skb)->mru;
>  	}
>  
>  	return ret;
