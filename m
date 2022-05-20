Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB64D52E678
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 09:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346536AbiETHpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 03:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244406AbiETHpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 03:45:01 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9487814AF70;
        Fri, 20 May 2022 00:45:00 -0700 (PDT)
Date:   Fri, 20 May 2022 09:44:57 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, pabeni@redhat.com,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH net-next 06/11] netfilter: nf_flow_table: count and limit
 hw offloaded entries
Message-ID: <YodG+REOiDa2PMUl@salvia>
References: <20220519220206.722153-1-pablo@netfilter.org>
 <20220519220206.722153-7-pablo@netfilter.org>
 <20220519161136.32fdba19@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220519161136.32fdba19@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 04:11:36PM -0700, Jakub Kicinski wrote:
> On Fri, 20 May 2022 00:02:01 +0200 Pablo Neira Ayuso wrote:
> > To improve hardware offload debuggability and scalability introduce
> > 'nf_flowtable_count_hw' and 'nf_flowtable_max_hw' sysctl entries in new
> > dedicated 'net/netfilter/ft' namespace. Add new pernet struct nf_ft_net in
> > order to store the counter and sysctl header of new sysctl table.
> > 
> > Count the offloaded flows in workqueue add task handler. Verify that
> > offloaded flow total is lower than allowed maximum before calling the
> > driver callbacks. To prevent spamming the 'add' workqueue with tasks when
> > flows can't be offloaded anymore also check that count is below limit
> > before queuing offload work. This doesn't prevent all redundant workqueue
> > task since counter can be taken by concurrent work handler after the check
> > had been performed but before the offload job is executed but it still
> > greatly reduces such occurrences. Note that flows that were not offloaded
> > due to counter being larger than the cap can still be offloaded via refresh
> > function.
> > 
> > Ensure that flows are accounted correctly by verifying IPS_HW_OFFLOAD_BIT
> > value before counting them. This ensures that add/refresh code path
> > increments the counter exactly once per flow when setting the bit and
> > decrements it only for accounted flows when deleting the flow with the bit
> > set.
> 
> Why a sysctl and not a netlink attr per table or per device?

Per-device is not an option, because the flowtable represents a
compound of devices.

Moreover, in tc ct act the flowtable is not bound to a device, while
in netfilter/nf_tables it is.

tc ct act does not expose flowtables to userspace in any way, they
internally allocate one flowtable per zone. I assume there os no good
netlink interface for them.

For netfilter/nftables, it should be possible to add per-flowtable
netlink attributes, my plan is to extend the flowtable netlink
attribute to add a flowtable maximum size.

This sysctl count and limit hw will just work as a global limit (which
is optional), my plan is that the upcoming per-flowtable limit will
just override this global limit.

I think it is a reasonable tradeoff for the different requirements of
the flowtable infrastructure users given there are two clients
currently for this code.
