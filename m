Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0B654BAE20
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 01:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiBRAGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 19:06:14 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:48362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbiBRAFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 19:05:41 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3B3FB24F29;
        Thu, 17 Feb 2022 16:05:14 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id F2C8960028;
        Fri, 18 Feb 2022 01:04:30 +0100 (CET)
Date:   Fri, 18 Feb 2022 01:05:11 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Paul Blakey <paulb@nvidia.com>, dev@openvswitch.org,
        netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        davem@davemloft.net, Jiri Pirko <jiri@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>, coreteam@netfilter.org
Subject: Re: [PATCH net 1/1] net/sched: act_ct: Fix flow table lookup failure
 with no originating ifindex
Message-ID: <Yg7itx2dt4rIa24W@salvia>
References: <20220217093424.23601-1-paulb@nvidia.com>
 <Yg5Tz5ucVAI3zOTs@salvia>
 <20220217232708.yhigtv2ssrlfsexs@t14s.localdomain>
 <Yg7gWIrIlGDDiVer@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yg7gWIrIlGDDiVer@salvia>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 18, 2022 at 12:55:07AM +0100, Pablo Neira Ayuso wrote:
> On Thu, Feb 17, 2022 at 08:27:08PM -0300, Marcelo Ricardo Leitner wrote:
> > On Thu, Feb 17, 2022 at 02:55:27PM +0100, Pablo Neira Ayuso wrote:
> > > On Thu, Feb 17, 2022 at 11:34:24AM +0200, Paul Blakey wrote:
> > > > After cited commit optimizted hw insertion, flow table entries are
> > > > populated with ifindex information which was intended to only be used
> > > > for HW offload. This tuple ifindex is hashed in the flow table key, so
> > > > it must be filled for lookup to be successful. But tuple ifindex is only
> > > > relevant for the netfilter flowtables (nft), so it's not filled in
> > > > act_ct flow table lookup, resulting in lookup failure, and no SW
> > > > offload and no offload teardown for TCP connection FIN/RST packets.
> > > > 
> > > > To fix this, allow flow tables that don't hash the ifindex.
> > > > Netfilter flow tables will keep using ifindex for a more specific
> > > > offload, while act_ct will not.
> > > 
> > > Using iif == zero should be enough to specify not set?
> > 
> > You mean, when searching, if search input iif == zero, to simply not
> > check it? That seems dangerous somehow.
> 
> dev_new_index() does not allocate ifindex as zero.
> 
> Anyway, @Paul: could you add a tc_ifidx field instead in the union
> right after __hash instead to fix 9795ded7f924?

I mean this incomplete patch below:

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index a3647fadf1cc..d4fa4f716f68 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -142,6 +142,7 @@ struct flow_offload_tuple {
                        u8              h_source[ETH_ALEN];
                        u8              h_dest[ETH_ALEN];
                } out;
+               u32                     tc_ifidx;
        };
 };

You will need to update nf_flow_rule_match() to set key->meta.ingress_ifindex to
use tc_ifidx if it is set to non-zero value.
