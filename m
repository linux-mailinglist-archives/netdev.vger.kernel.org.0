Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71783577274
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 01:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbiGPXds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 19:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233033AbiGPXdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 19:33:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9BF297
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 16:33:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D580060B91
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 23:33:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE76BC34114;
        Sat, 16 Jul 2022 23:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658014421;
        bh=E+qoKtSUzF64HPzPkN4jBLqssakOQtecFqbr+fLqcrM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FEI0Lli4j5RYIXsF6ICNSUvVYxyo6l9GZnmtHkM+XtUCG8KxmzUXcaKp6IgIRyP+9
         DrF7U/l8aPiQDUdoRmVxwJpv1D6pIdjF4ICrFVvC/5cpGmlEiONuqxSQAy4jeOM4Ln
         BsthpWFcNvDKQLu/caDAz5BXDeyyolTX+D0u6h/NQUPRxs6PMOC7447SzOEZryQPe8
         raqfdG8hwUrANtUGm7M4yRaJNxVLIBM7CH4iw07Ob+Nn/9NrSySb8oQpQeaKVYEgn0
         2gZk5YR60MbgG4zjXVw6gxbfLlZRvfIda9bbaTsW/FRuPcMFMf8QfTH3dCcPbfS78C
         P9yK0qzf6ybMA==
Date:   Sat, 16 Jul 2022 16:33:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Brian Hutchinson <b.hutchman@gmail.com>
Subject: Re: [PATCH net] net: dsa: fix bonding with ARP monitoring by
 updating trans_start manually
Message-ID: <20220716163338.189738a4@kernel.org>
In-Reply-To: <20220716133009.eaqthcfyz4bcbjbd@skbuf>
References: <20220715232641.952532-1-vladimir.oltean@nxp.com>
        <20220715170042.4e6e2a32@kernel.org>
        <20220716001443.aooyf5kpbpfjzqgn@skbuf>
        <20220715171959.22e118d7@kernel.org>
        <20220716002612.rd6ir65njzc2g3cc@skbuf>
        <20220715175516.6770c863@kernel.org>
        <20220716133009.eaqthcfyz4bcbjbd@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 16 Jul 2022 13:30:10 +0000 Vladimir Oltean wrote:
> I would need some assistance from Jay or other people more familiar with
> bonding to do that. I'm not exactly clear which packets the bonding
> driver wants to check they have been transmitted in the last interval:
> ARP packets? any packets?

And why - stack has queued a packet to the driver, how is that useful
to assess the fact that the link is up? Can bonding check instead
whether any queue is running? Or maybe the whole thing is just a remnant
of times before the centralized watchdog tx and should be dropped?

> With DSA and switchdev drivers in general,
> they have an offloaded forwarding path as well, so expect that what you
> get through ndo_get_stats64 may also report packets which egressed a
> physical port but weren't originated by the network stack.
> I simply don't know what is a viable substitute for dev_trans_start()
> because I don't understand very well what it intends to capture.

Looking thru the code I stumbled on the implementation of
dev_trans_start() - it already takes care of some upper devices.
Adding DSA handling there would offend my sensibilities slightly
less, if you want to do that. At least it's not on the fast path.
