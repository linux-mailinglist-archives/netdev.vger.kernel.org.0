Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A05164C1098
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 11:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239701AbiBWKo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 05:44:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234377AbiBWKo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 05:44:57 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8265158E7D;
        Wed, 23 Feb 2022 02:44:30 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 76F8260238;
        Wed, 23 Feb 2022 11:43:26 +0100 (CET)
Date:   Wed, 23 Feb 2022 11:44:27 +0100
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
Message-ID: <YhYQC+cXcfk6CaOM@salvia>
References: <20220203115941.3107572-1-toshiaki.makita1@gmail.com>
 <20220203115941.3107572-2-toshiaki.makita1@gmail.com>
 <YgFdS0ak3LIR2waA@salvia>
 <9d4fd782-896d-4a44-b596-517c84d97d5a@gmail.com>
 <YgOQ6a0itcJjQJqx@salvia>
 <8309e037-840d-0a7d-26c1-f07fda9ba744@gmail.com>
 <24910a58-5d23-a97c-650f-7b53030dd40d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <24910a58-5d23-a97c-650f-7b53030dd40d@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 19, 2022 at 09:51:37PM +0900, Toshiaki Makita wrote:
> Ping, Pablo?

Please go ahead, these #ifdef can go away later on.

> On 2022/02/12 10:54, Toshiaki Makita wrote:
> > On 2022/02/09 19:01, Pablo Neira Ayuso wrote:
> > > On Tue, Feb 08, 2022 at 11:30:03PM +0900, Toshiaki Makita wrote:
> > > > On 2022/02/08 2:56, Pablo Neira Ayuso wrote:
> > > > > On Thu, Feb 03, 2022 at 08:59:39PM +0900, Toshiaki Makita wrote:
> > > [...]
> > > > > > diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> > > > > > index 889cf88..48e2f58 100644
> > > > > > --- a/net/netfilter/nf_flow_table_ip.c
> > > > > > +++ b/net/netfilter/nf_flow_table_ip.c
> > > [...]
> > > > > > @@ -202,15 +209,25 @@ static int nf_flow_tuple_ip(struct
> > > > > > sk_buff *skb, const struct net_device *dev,
> > > > > >        if (!pskb_may_pull(skb, thoff + *hdrsize))
> > > > > >            return -1;
> > > > > > +    if (ipproto == IPPROTO_GRE) {
> > > > > 
> > > > > No ifdef here? Maybe remove these ifdef everywhere?
> > > > 
> > > > I wanted to avoid adding many ifdefs and I expect this to be compiled out
> > > > when CONFIG_NF_CT_PROTO_GRE=n as this block is unreachable anyway. It rather
> > > > may have been unintuitive though.
> > > > 
> > > > Removing all of these ifdefs will cause inconsistent behavior between
> > > > CONFIG_NF_CT_PROTO_GRE=n/y.
> > > > When CONFIG_NF_CT_PROTO_GRE=n, conntrack cannot determine GRE version, thus
> > > > it will track GREv1 without key infomation, and the flow will be offloaded.
> > > > When CONFIG_NF_CT_PROTO_GRE=y, GREv1 will have key information and will not
> > > > be offloaded.
> > > > I wanted to just refuse offloading of GRE to avoid this inconsistency.
> > > > Anyway this kind of inconsistency seems to happen in software conntrack, so
> > > > if you'd like to remove ifdefs, I will do.
> > > 
> > > Good point, thanks for explaining. LGTM.
> > 
> > Let me confirm, did you agree to keep ifdefs, or delete them?
> > 
> > Toshiaki Makita
