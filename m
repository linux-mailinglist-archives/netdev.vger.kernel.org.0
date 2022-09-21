Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC0035C0045
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 16:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiIUOs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 10:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiIUOs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 10:48:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4E097ED2
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 07:48:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C9EC62380
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 14:48:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B47C433C1;
        Wed, 21 Sep 2022 14:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663771736;
        bh=td/Hoeaf64JNXiS+YTkfoL+LGapAheqKUatm3oSweh0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kEiNGnNVu6dLdmVl2EJYujh9493xI6Lcs2V+BUNx9Qwxd2+7BP+0k7lyAE3Qxp4Lt
         J1lbb6Dp7LYJDq8WX7W9zsQoQS3AlnvTLbOGvWxbgf+LghyDIHY19eK1D7yaAClYOm
         guRu8naIg6uAD3oxlISQ1a8Qzg5Avg+RGf2bBtFOTs/489VQxAbbrF/SB+BaSuWFHz
         B9xJ84//9kJHx3ZKmPCcpmx4U04+WDv+/nhFiA5dxtm/QSU8hD7OB50YLrVXBSFFMG
         rg5Nmi7JIGcss9M3PWPxXAvpUAixP0R8CUCMBLnMv+01CbDo+Zs8xuDe+15kWlddZC
         j+qjk9cPVSgbg==
Date:   Wed, 21 Sep 2022 07:48:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Paul Blakey <paulb@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net 1/1] net: Fix return value of qdisc ingress handling
 on success
Message-ID: <20220921074854.48175d87@kernel.org>
In-Reply-To: <c322d8d6-8594-65a9-0514-3b6486d588fe@iogearbox.net>
References: <1663750248-20363-1-git-send-email-paulb@nvidia.com>
        <c322d8d6-8594-65a9-0514-3b6486d588fe@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Sep 2022 11:11:03 +0200 Daniel Borkmann wrote:
> On 9/21/22 10:50 AM, Paul Blakey wrote:
> > Currently qdisc ingress handling (sch_handle_ingress()) doesn't
> > set a return value and it is left to the old return value of
> > the caller (__netif_receive_skb_core()) which is RX drop, so if
> > the packet is consumed, caller will stop and return this value
> > as if the packet was dropped.
> > 
> > This causes a problem in the kernel tcp stack when having a
> > egress tc rule forwarding to a ingress tc rule.
> > The tcp stack sending packets on the device having the egress rule
> > will see the packets as not successfully transmitted (although they
> > actually were), will not advance it's internal state of sent data,
> > and packets returning on such tcp stream will be dropped by the tcp
> > stack with reason ack-of-unsent-data. See reproduction in [0] below.
> > 
> > Fix that by setting the return value to RX success if
> > the packet was handled successfully.
> > 
> > [0] Reproduction steps:
> >   $ ip link add veth1 type veth peer name peer1
> >   $ ip link add veth2 type veth peer name peer2
> >   $ ifconfig peer1 5.5.5.6/24 up
> >   $ ip netns add ns0
> >   $ ip link set dev peer2 netns ns0
> >   $ ip netns exec ns0 ifconfig peer2 5.5.5.5/24 up
> >   $ ifconfig veth2 0 up
> >   $ ifconfig veth1 0 up
> > 
> >   #ingress forwarding veth1 <-> veth2
> >   $ tc qdisc add dev veth2 ingress
> >   $ tc qdisc add dev veth1 ingress
> >   $ tc filter add dev veth2 ingress prio 1 proto all flower \
> >     action mirred egress redirect dev veth1
> >   $ tc filter add dev veth1 ingress prio 1 proto all flower \
> >     action mirred egress redirect dev veth2
> > 
> >   #steal packet from peer1 egress to veth2 ingress, bypassing the veth pipe
> >   $ tc qdisc add dev peer1 clsact
> >   $ tc filter add dev peer1 egress prio 20 proto ip flower \
> >     action mirred ingress redirect dev veth1
> > 
> >   #run iperf and see connection not running
> >   $ iperf3 -s&
> >   $ ip netns exec ns0 iperf3 -c 5.5.5.6 -i 1
> > 
> >   #delete egress rule, and run again, now should work
> >   $ tc filter del dev peer1 egress
> >   $ ip netns exec ns0 iperf3 -c 5.5.5.6 -i 1
> > 
> > Fixes: 1f211a1b929c ("net, sched: add clsact qdisc")
> > Signed-off-by: Paul Blakey <paulb@nvidia.com>
>
> Looks reasonable and aligns with sch_handle_egress() fwiw. I think your Fixes tag is wrong
> since that commit didn't modify any of the above. This patch should also rather go to net-next
> tree to make sure it has enough soak time to catch potential regressions from this change in
> behavior.

I don't think we do "soak time" in networking. Perhaps we can try 
to use the "CC: stable # after 4 weeks" delay mechanism which Greg
promised at LPC?

> Given the change under TC_ACT_REDIRECT is BPF specific, please also add a BPF selftest
> for tc BPF program to assert the new behavior so we can run it in our BPF CI for every patch.

And it would be great to turn the commands from the commit message
into a selftest as well :S
