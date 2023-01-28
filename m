Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4EB667F942
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 16:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbjA1PvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 10:51:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjA1PvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 10:51:23 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C163C26862;
        Sat, 28 Jan 2023 07:51:22 -0800 (PST)
Date:   Sat, 28 Jan 2023 16:51:17 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        ozsh@nvidia.com, marcelo.leitner@gmail.com,
        simon.horman@corigine.com
Subject: Re: [PATCH net-next v5 0/7] Allow offloading of UDP NEW connections
 via act_ct
Message-ID: <Y9VEdYnSLH8YKTZA@salvia>
References: <20230127183845.597861-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230127183845.597861-1-vladbu@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 07:38:38PM +0100, Vlad Buslov wrote:
> Currently only bidirectional established connections can be offloaded
> via act_ct. Such approach allows to hardcode a lot of assumptions into
> act_ct, flow_table and flow_offload intermediate layer codes. In order
> to enabled offloading of unidirectional UDP NEW connections start with
> incrementally changing the following assumptions:
> 
> - Drivers assume that only established connections are offloaded and
>   don't support updating existing connections. Extract ctinfo from meta
>   action cookie and refuse offloading of new connections in the drivers.
> 
> - Fix flow_table offload fixup algorithm to calculate flow timeout
>   according to current connection state instead of hardcoded
>   "established" value.
> 
> - Add new flow_table flow flag that designates bidirectional connections
>   instead of assuming it and hardcoding hardware offload of every flow
>   in both directions.
> 
> - Add new flow_table flow "ext_data" field and use it in act_ct to track
>   the ctinfo of offloaded flows instead of assuming that it is always
>   "established".
> 
> With all the necessary infrastructure in place modify act_ct to offload
> UDP NEW as unidirectional connection. Pass reply direction traffic to CT
> and promote connection to bidirectional when UDP connection state
> changes to "assured". Rely on refresh mechanism to propagate connection
> state change to supporting drivers.
> 
> Note that early drop algorithm that is designed to free up some space in
> connection tracking table when it becomes full (by randomly deleting up
> to 5% of non-established connections) currently ignores connections
> marked as "offloaded". Now, with UDP NEW connections becoming
> "offloaded" it could allow malicious user to perform DoS attack by
> filling the table with non-droppable UDP NEW connections by sending just
> one packet in single direction. To prevent such scenario change early
> drop algorithm to also consider "offloaded" connections for deletion.

If the two changes I propose are doable, then I am OK with this.

I would really like to explore my proposal to turn the workqueue into
a "scanner" that iterates over the entries searching for flows that
need to be offloaded (or updated to bidirectional, like in this new
case). I think it is not too far from what there is in the flowtable
codebase.
