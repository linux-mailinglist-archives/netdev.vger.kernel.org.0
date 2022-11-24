Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A19596375C8
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 11:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiKXKAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 05:00:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiKXKAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 05:00:51 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4F9DF175A7
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 02:00:50 -0800 (PST)
Date:   Thu, 24 Nov 2022 11:00:45 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Xin Long <lucien.xin@gmail.com>, dev@openvswitch.org,
        ovs-dev@openvswitch.org, Davide Caratti <dcaratti@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        network dev <netdev@vger.kernel.org>,
        Paul Blakey <paulb@nvidia.com>,
        Florian Westphal <fw@strlen.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, kuba@kernel.org,
        Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net
Subject: Re: [ovs-dev] [PATCHv2 net-next 5/5] net: move the nat function to
 nf_nat_ovs for ovs and tc
Message-ID: <Y39AzcHNCbeTePjK@salvia>
References: <cover.1669138256.git.lucien.xin@gmail.com>
 <bf19487f4dfc8cd91a4395672d9905b10917128d.1669138256.git.lucien.xin@gmail.com>
 <Y343wyO20XUvwuvg@t14s.localdomain>
 <20221123151335.ssrnv7jfrdugmcgg@t14s.localdomain>
 <CADvbK_eYRZxaNreBmvXmAQzH+JLbiK-9UhKqzH2CM2sHt1bvQQ@mail.gmail.com>
 <Y35q4NVXC2D4mgPc@t14s.localdomain>
 <CADvbK_e+tgefsiB1N-7CHUR35P-sDfaOqRVp281VhrQO2ot_hQ@mail.gmail.com>
 <Y35xs4Saj8coBmUH@t14s.localdomain>
 <CADvbK_c9WpRSaqNkC5MrK9=xXGSE+or-R6=hSwCyeSqm7GO-nw@mail.gmail.com>
 <Y36Oy1gT2KwQH07Y@t14s.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y36Oy1gT2KwQH07Y@t14s.localdomain>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 06:21:15PM -0300, Marcelo Ricardo Leitner wrote:
> On Wed, Nov 23, 2022 at 02:55:05PM -0500, Xin Long wrote:
> > On Wed, Nov 23, 2022 at 2:17 PM Marcelo Ricardo Leitner
> > <marcelo.leitner@gmail.com> wrote:
[...]
> > > > "table=1, in_port=veth1,tcp,tcp_dst=2121,ct_state=+trk+new
> > > > actions=ct(nat(dst=7.7.16.3)),ct(commit, nat(src=7.7.16.1),
> > > > alg=ftp),veth2"
> > > >
> > > > as long as it allows the 1st one doesn't commit, which is a simple
> > > > check in parse_nat().
> > > > I tested it, TC already supports it. I'm not sure about drivers, but I
> > >
> > > There's an outstanding issue with act_ct that it may reuse an old
> > > CT cache. Fixing it could (I'm not sure) impact this use case:
> > >
> > > https://bugzilla.redhat.com/show_bug.cgi?id=2099220
> > > same issue in ovs was fixed in
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=2061ecfdf2350994e5b61c43e50e98a7a70e95ee
> > >
> > > (please don't ask me who would NAT and then overwrite IP addresses and
> > > then NAT it again :D)
> > I thought only traditional NAT would change IP, I'm too naive.
> > 
> > nftables names this as "stateless NAT."
> > With two CTs in the same zone for full nat is more close to the
> > netfilter's NAT processing (the same CT goes from prerouting to
> > postrouting).
> > Now I'm wondering how nftables handles the stateful NAT and stateless
> > NAT at the same time.
> 
> Me too.

There is a 'notrack' action to skip connection tracking for the flows
where the user needs stateless NAT.
