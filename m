Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B647F4AEEDD
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 11:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiBIKEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 05:04:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbiBIKEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 05:04:49 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 334BAE040AA1;
        Wed,  9 Feb 2022 02:04:45 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 01617601B3;
        Wed,  9 Feb 2022 11:01:06 +0100 (CET)
Date:   Wed, 9 Feb 2022 11:01:13 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Paul Blakey <paulb@nvidia.com>
Subject: Re: [PATCH net-next 1/3] netfilter: flowtable: Support GRE
Message-ID: <YgOQ6a0itcJjQJqx@salvia>
References: <20220203115941.3107572-1-toshiaki.makita1@gmail.com>
 <20220203115941.3107572-2-toshiaki.makita1@gmail.com>
 <YgFdS0ak3LIR2waA@salvia>
 <9d4fd782-896d-4a44-b596-517c84d97d5a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9d4fd782-896d-4a44-b596-517c84d97d5a@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 08, 2022 at 11:30:03PM +0900, Toshiaki Makita wrote:
> On 2022/02/08 2:56, Pablo Neira Ayuso wrote:
> > On Thu, Feb 03, 2022 at 08:59:39PM +0900, Toshiaki Makita wrote:
[...]
> > > diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> > > index 889cf88..48e2f58 100644
> > > --- a/net/netfilter/nf_flow_table_ip.c
> > > +++ b/net/netfilter/nf_flow_table_ip.c
[...]
> > > @@ -202,15 +209,25 @@ static int nf_flow_tuple_ip(struct sk_buff *skb, const struct net_device *dev,
> > >   	if (!pskb_may_pull(skb, thoff + *hdrsize))
> > >   		return -1;
> > > +	if (ipproto == IPPROTO_GRE) {
> > 
> > No ifdef here? Maybe remove these ifdef everywhere?
> 
> I wanted to avoid adding many ifdefs and I expect this to be compiled out
> when CONFIG_NF_CT_PROTO_GRE=n as this block is unreachable anyway. It rather
> may have been unintuitive though.
> 
> Removing all of these ifdefs will cause inconsistent behavior between
> CONFIG_NF_CT_PROTO_GRE=n/y.
> When CONFIG_NF_CT_PROTO_GRE=n, conntrack cannot determine GRE version, thus
> it will track GREv1 without key infomation, and the flow will be offloaded.
> When CONFIG_NF_CT_PROTO_GRE=y, GREv1 will have key information and will not
> be offloaded.
> I wanted to just refuse offloading of GRE to avoid this inconsistency.
> Anyway this kind of inconsistency seems to happen in software conntrack, so
> if you'd like to remove ifdefs, I will do.

Good point, thanks for explaining. LGTM.

[...]
> > > diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
> > > index 0af34ad..731b5d8 100644
> > > --- a/net/netfilter/nft_flow_offload.c
> > > +++ b/net/netfilter/nft_flow_offload.c
> > > @@ -298,6 +298,19 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
> > >   		break;
> > >   	case IPPROTO_UDP:
> > >   		break;
> > > +#ifdef CONFIG_NF_CT_PROTO_GRE
> > > +	case IPPROTO_GRE: {
> > > +		struct nf_conntrack_tuple *tuple;
> > > +
> > > +		if (ct->status & IPS_NAT_MASK)
> > > +			goto out;
> > 
> > Why this NAT check?
> 
> NAT requires more work. I'd like to start with a minimal GRE support.
> Maybe we can add NAT support later.

Oh well, yes, no problem.
