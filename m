Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8D967FA5B
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 20:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbjA1TJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 14:09:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbjA1TJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 14:09:44 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AE65E2310A;
        Sat, 28 Jan 2023 11:09:40 -0800 (PST)
Date:   Sat, 28 Jan 2023 20:09:36 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        ozsh@nvidia.com, marcelo.leitner@gmail.com,
        simon.horman@corigine.com
Subject: Re: [PATCH net-next v5 6/7] net/sched: act_ct: offload UDP NEW
 connections
Message-ID: <Y9Vy8Duq8nf/KeRW@salvia>
References: <20230127183845.597861-1-vladbu@nvidia.com>
 <20230127183845.597861-7-vladbu@nvidia.com>
 <Y9U+pW/2qDskLiYc@salvia>
 <87r0veejeb.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87r0veejeb.fsf@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 28, 2023 at 05:31:40PM +0200, Vlad Buslov wrote:
> 
> On Sat 28 Jan 2023 at 16:26, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Hi Vlad,
> >
> > On Fri, Jan 27, 2023 at 07:38:44PM +0100, Vlad Buslov wrote:
> >> Modify the offload algorithm of UDP connections to the following:
> >> 
> >> - Offload NEW connection as unidirectional.
> >> 
> >> - When connection state changes to ESTABLISHED also update the hardware
> >> flow. However, in order to prevent act_ct from spamming offload add wq for
> >> every packet coming in reply direction in this state verify whether
> >> connection has already been updated to ESTABLISHED in the drivers. If that
> >> it the case, then skip flow_table and let conntrack handle such packets
> >> which will also allow conntrack to potentially promote the connection to
> >> ASSURED.
> >> 
> >> - When connection state changes to ASSURED set the flow_table flow
> >> NF_FLOW_HW_BIDIRECTIONAL flag which will cause refresh mechanism to offload
> >> the reply direction.
> >> 
> >> All other protocols have their offload algorithm preserved and are always
> >> offloaded as bidirectional.
> >> 
> >> Note that this change tries to minimize the load on flow_table add
> >> workqueue. First, it tracks the last ctinfo that was offloaded by using new
> >> flow 'ext_data' field and doesn't schedule the refresh for reply direction
> >> packets when the offloads have already been updated with current ctinfo.
> >> Second, when 'add' task executes on workqueue it always update the offload
> >> with current flow state (by checking 'bidirectional' flow flag and
> >> obtaining actual ctinfo/cookie through meta action instead of caching any
> >> of these from the moment of scheduling the 'add' work) preventing the need
> >> from scheduling more updates if state changed concurrently while the 'add'
> >> work was pending on workqueue.
> >
> > Could you use a flag to achieve what you need instead of this ext_data
> > field? Better this ext_data and the flag, I prefer the flags.
> 
> Sure, np. Do you prefer the functionality to be offloaded to gc (as in
> earlier versions of this series) or leverage 'refresh' code as in
> versions 4-5?

No, I prefer generic gc/refresh mechanism is not used for this.

What I mean is: could you replace this new ->ext_data generic pointer
by a flag to annotate what you need? Between this generic pointer and
a flag, I prefer a flag.
