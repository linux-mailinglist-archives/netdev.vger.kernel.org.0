Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35416511369
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 10:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344335AbiD0IWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 04:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359370AbiD0IWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 04:22:43 -0400
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B8EE6515B0;
        Wed, 27 Apr 2022 01:19:31 -0700 (PDT)
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 23R8JED9002363;
        Wed, 27 Apr 2022 10:19:14 +0200
Date:   Wed, 27 Apr 2022 10:19:14 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     David Laight <David.Laight@aculab.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Moshe Kol <moshe.kol@mail.huji.ac.il>,
        Yossi Gilad <yossi.gilad@mail.huji.ac.il>,
        Amit Klein <aksecurity@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net 6/7] tcp: increase source port perturb table to 2^16
Message-ID: <20220427081914.GA1724@1wt.eu>
References: <20220427065233.2075-1-w@1wt.eu>
 <20220427065233.2075-7-w@1wt.eu>
 <7372f788762140d496c157813b0173e5@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7372f788762140d496c157813b0173e5@AcuMS.aculab.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 08:07:29AM +0000, David Laight wrote:
> From: Willy Tarreau
> > Sent: 27 April 2022 07:53
> > 
> > Moshe Kol, Amit Klein, and Yossi Gilad reported being able to accurately
> > identify a client by forcing it to emit only 40 times more connections
> > than there are entries in the table_perturb[] table. The previous two
> > improvements consisting in resalting the secret every 10s and adding
> > randomness to each port selection only slightly improved the situation,
> > and the current value of 2^8 was too small as it's not very difficult
> > to make a client emit 10k connections in less than 10 seconds.
> > 
> > Thus we're increasing the perturb table from 2^8 to 2^16 so that the the
> > same precision now requires 2.6M connections, which is more difficult in
> > this time frame and harder to hide as a background activity. The impact
> > is that the table now uses 256 kB instead of 1 kB, which could mostly
> > affect devices making frequent outgoing connections. However such
> > components usually target a small set of destinations (load balancers,
> > database clients, perf assessment tools), and in practice only a few
> > entries will be visited, like before.
> 
> Increasing the table size has a bigger impact on anyone trying
> to get the kernel to run in a limited memory footprint.
> 
> All these large tables (often hash tables) soon add up.

We know, and the initial approach that required a significantly larger
table and an extra table per namespace was a no-go. All these are part
of the reasons for the effort it took to refine the solution in order
to avoid such unacceptable costs. The way it was made here makes it easy
to patch the value for small systems if needed and leaves the door open
for a configurable setting in the future if that was estimated necessary
for certain environments.

Willy
