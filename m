Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58CF8629E5D
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 17:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbiKOQDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 11:03:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiKOQDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 11:03:04 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18E4D5C;
        Tue, 15 Nov 2022 08:03:03 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 17F931883A42;
        Tue, 15 Nov 2022 16:03:02 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id E909C25002DE;
        Tue, 15 Nov 2022 16:03:01 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id C67879EC0020; Tue, 15 Nov 2022 16:03:01 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Tue, 15 Nov 2022 17:03:01 +0100
From:   netdev@kapio-technology.com
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 net-next 0/2] mv88e6xxx: Add MAB offload support
In-Reply-To: <20221115145650.gs7crhkidbq5ko6v@skbuf>
References: <20221112203748.68995-1-netdev@kapio-technology.com>
 <Y3NcOYvCkmcRufIn@shredder>
 <5559fa646aaad7551af9243831b48408@kapio-technology.com>
 <20221115102833.ahwnahrqstcs2eug@skbuf>
 <7c02d4f14e59a6e26431c086a9bb9643@kapio-technology.com>
 <20221115111034.z5bggxqhdf7kbw64@skbuf>
 <0cd30d4517d548f35042a535fd994831@kapio-technology.com>
 <20221115122237.jfa5aqv6hauqid6l@skbuf>
 <fb1707b55bd8629770e77969affaa2f9@kapio-technology.com>
 <20221115145650.gs7crhkidbq5ko6v@skbuf>
User-Agent: Gigahost Webmail
Message-ID: <f229503b98d772c936f1fc8ca826a14f@kapio-technology.com>
X-Sender: netdev@kapio-technology.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-11-15 15:56, Vladimir Oltean wrote:
> On Tue, Nov 15, 2022 at 02:25:13PM +0100, netdev@kapio-technology.com 
> wrote:
>> On 2022-11-15 13:22, Vladimir Oltean wrote:
>> > Do you have a timeline for when the regression was introduced?
>> > Commit 35da1dfd9484 reverts cleanly, so I suppose giving it a go with
>> > that reverted might be worth a shot. Otherwise, a bisect from a known
>> > working version only takes a couple of hours, and shouldn't require
>> > other changes to the setup.
>> 
>> Wow! Reverting 35da1dfd9484 and the problem has disappeared. :-)
> 
> See? That wasn't very painful, was it.

Indeed it was not, when you get a good tip. Thanks alot! :-)

> 
> Now, why doesn't that commit work for you? that's the real question.
> I'm going to say there's a big assumption made there. The old code used
> to poll up to 16 times with sleeps of up to 2 ms in between.
> The new code polls until at least 50 ms have elapsed.
> I can imagine the thought process being something like "hmm, 16*2=32ms,
> let's round that up to 50 just to be sure". But the effective timeout
> was not really increased. Rather said, in the old code there was never
> really an effective timeout, since the polling code could have been
> preempted many times, and these preemptions would not be accounted
> against the msleep(2) calls. Whereas the new code really tracks
> something approximating 50 ms now.
> 
> Could you please add the reverted patch back to your git tree, and see
> by how much do you need to increase the timeout for your system to get
> reliable results?
> 

Yes, so you want me to simply increase the 50ms on line 58 in smi.c...

I have now tried to increase it even to 10000ms == 10s and it didn't 
help,
so something else must be needed...
