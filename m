Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1A4457762A
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 14:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbiGQMe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 08:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiGQMeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 08:34:25 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E861409A;
        Sun, 17 Jul 2022 05:34:23 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id B476B1886603;
        Sun, 17 Jul 2022 12:34:22 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id A495425032B7;
        Sun, 17 Jul 2022 12:34:22 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 899B5A1E00AF; Sun, 17 Jul 2022 12:34:22 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Sun, 17 Jul 2022 14:34:22 +0200
From:   netdev@kapio-technology.com
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 net-next 5/6] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
In-Reply-To: <20220717004725.ngix64ou2mz566is@skbuf>
References: <20220707152930.1789437-1-netdev@kapio-technology.com>
 <20220707152930.1789437-6-netdev@kapio-technology.com>
 <20220717004725.ngix64ou2mz566is@skbuf>
User-Agent: Gigahost Webmail
Message-ID: <3918e3d1a8b78dedc14b950ba1eee8d5@kapio-technology.com>
X-Sender: netdev@kapio-technology.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,FROM_FMBLA_NEWDOM28,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 
> In other words, this patch set makes MAB work and breaks everything 
> else.
> I'm willing to investigate exactly what is it that breaks the other
> selftest, but not today. It may be related to the "RTNETLINK answers:
> File exists"
> messages, which themselves come from the commands
> | bridge fdb add 00:01:02:03:04:01 dev lan2 master static
> 
> If I were to randomly guess at almost 4AM in the morning, it has to do 
> with
> "bridge fdb add" rather than the "bridge fdb replace" that's used for
> the MAB selftest. The fact I pointed out a few revisions ago, that MAB
> needs to be opt-in, is now coming back to bite us. Since it's not
> opt-in, the mv88e6xxx driver always creates locked FDB entries, and 
> when
> we try to "bridge fdb add", the kernel says "hey, the FDB entry is
> already there!". Is that it?

Yes, that sounds like a reasonable explanation, as it adds 'ext learned, 
offloaded' entries. If you try and replace the 'add' with 'replace' in 
those tests, does it work?

> 
> As for how to opt into MAB. Hmm. MAB seems to be essentially CPU
> assisted learning, which creates locked FDB entries. I wonder whether 
> we
> should reconsider the position that address learning makes no sense on
> locked ports, and say that "+locked -learning" means no MAB, and
> "+locked +learning" means MAB? This would make a bunch of things more
> natural to handle in the kernel, and would also give us the opt-in we 
> need.

I have done the one and then the other. We need to have some final 
decision on this point. And remember that this gave rise to an extra 
patch to fix link-local learning if learning is turned on on a locked 
port, which resulted in the decision to allways have learning off on 
locked ports.

> 
> 
> 
> Side note, the VTU and ATU member violation printks annoy me so badly.
> They aren't stating something super useful and they're a DoS attack
> vector in itself, even if they're rate limited. I wonder whether we
> could just turn the prints into a set of ethtool counters and call it a 
> day?

Sounds like a good idea to me. :-)
