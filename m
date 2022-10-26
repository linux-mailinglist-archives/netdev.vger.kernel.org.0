Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 913F060DF08
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 12:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233187AbiJZKui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 06:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiJZKuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 06:50:37 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1A9CC419A4;
        Wed, 26 Oct 2022 03:50:35 -0700 (PDT)
Date:   Wed, 26 Oct 2022 12:50:28 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Michael Lilja <michael.lilja@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH] Periodically flow expire from flow offload tables
Message-ID: <Y1kQ9FhrwxCKIdoe@salvia>
References: <20221023171658.69761-1-michael.lilja@gmail.com>
 <Y1fC5K0EalIYuB7Y@salvia>
 <381FF5B6-4FEF-45E9-92D6-6FE927A5CC2D@gmail.com>
 <Y1fd+DEPZ8xM2x5B@salvia>
 <F754AC3A-D89A-4CF7-97AE-CA59B18A758E@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <F754AC3A-D89A-4CF7-97AE-CA59B18A758E@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Oct 25, 2022 at 03:32:51PM +0200, Michael Lilja wrote:
> Hi, 
> 
> Thanks for the optimisation suggestions, my nft is a rough
> conversion from iptables, I will look into using maps.
> 
> The ingress chain will work fine for SW OFFLOAD but HW OFFLOAD is
> not solved by this, at least what I see is that once a flow is
> offloaded to HW the driver doesn’t see the packets?
>
> If I use the ingress chain I guess I don’t have access to ‘ct mark’
> yet? I could think of a use-case where schedules should only some
> ‘flow type’: meta mask != 0x12340000/16 meta day “Tuesday" meta hour
> >= "06:00" meta hour < "07:00" drop 
> 
> I have more advanced rules that check the ct mark and will need to
> drop if mark == something. These mark == something rules are applied
> ‘runtime’ and flowables doesn’t seem to be flushed on nft load,
> which is also a reason for my ‘flow retire’ from the tables.

It should be also possible to notify the flowtable that the ruleset
has been updated. That won't cover the meta day, hour, time scenario
though. I think both mechanism (the 'retire' feature you propose) and
ruleset update notifications are complementary each other and they
would be good to have.

> So my overall goal is to receive packets, mark them with a value
> depending on 'flow type' and then for the flows that are allowed to
> be forwarded offload them to the ingress flow table for either HW or
> SW offload. Once in a while I will change the verdict of a ‘flow
> type’ and will need that to apply for all existing flows and future
> flows, besides the fixed schedules, and it should work both for SW
> OFFLOAD and HW OFFLOAD.
>
> I only have the M7621 device to play with for HW OFFLOAD, but it
> works fine with my patch.

Thanks for explaining.

My suggestions are:

- Add support for this in the flowtable netlink interface (instead of
  sysctl), I'm going to post a patch to add support for setting the
  flowtable size, it can be used as reference to expose this new
  'retire' feature.

- flow_offload_teardown() already unsets the IPS_OFFLOAD bit, so
  probably your patch can follow that path too (instead of clearing
  IPS_OFFLOAD_BIT from flow_offload_del).

static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
                                    struct flow_offload *flow, void *data)
{
        if (nf_flow_has_expired(flow) ||
            nf_ct_is_dying(flow->ct))
                flow_offload_teardown(flow);
