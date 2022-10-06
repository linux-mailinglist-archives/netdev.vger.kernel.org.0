Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C05BC5F6979
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 16:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbiJFOTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 10:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbiJFOTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 10:19:20 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DA2A4B1B90
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 07:17:56 -0700 (PDT)
Date:   Thu, 6 Oct 2022 16:11:24 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        ovs-dev@openvswitch.org, davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>
Subject: Re: [PATCH net-next 3/3] net: sched: add helper support in act_ct
Message-ID: <Yz7iDEjVbHrPUPT4@salvia>
References: <cover.1664932669.git.lucien.xin@gmail.com>
 <bc53ffac4d6be2616d053684fb6670f478b4324b.1664932669.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <bc53ffac4d6be2616d053684fb6670f478b4324b.1664932669.git.lucien.xin@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 04, 2022 at 09:19:56PM -0400, Xin Long wrote:
[...]
> @@ -1119,6 +1135,22 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>  	if (err != NF_ACCEPT)
>  		goto drop;
>  
> +	if (commit && p->helper && !nfct_help(ct)) {
> +		err = __nf_ct_try_assign_helper(ct, p->tmpl, GFP_ATOMIC);
> +		if (err)
> +			goto drop;
> +		add_helper = true;
> +		if (p->ct_action & TCA_CT_ACT_NAT && !nfct_seqadj(ct)) {
> +			if (!nfct_seqadj_ext_add(ct))

You can only add ct extensions if ct is !nf_ct_is_confirmed(ct)), is
this guaranteed in this codepath?

> +				return -EINVAL;
> +		}
> +	}
> +
> +	if (nf_ct_is_confirmed(ct) ? ((!cached && !skip_add) || add_helper) : commit) {
> +		if (nf_ct_helper(skb, family) != NF_ACCEPT)
> +			goto drop;
> +	}
> +
>  	if (commit) {
>  		tcf_ct_act_set_mark(ct, p->mark, p->mark_mask);
>  		tcf_ct_act_set_labels(ct, p->labels, p->labels_mask);
