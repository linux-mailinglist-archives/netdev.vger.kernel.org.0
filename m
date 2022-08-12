Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7815910C5
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 14:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237127AbiHLM3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 08:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235068AbiHLM3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 08:29:53 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D017AC1A;
        Fri, 12 Aug 2022 05:29:51 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 164E11884573;
        Fri, 12 Aug 2022 12:29:49 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 0C00325032BB;
        Fri, 12 Aug 2022 12:29:49 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 0400CA1A004F; Fri, 12 Aug 2022 12:29:48 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Fri, 12 Aug 2022 14:29:48 +0200
From:   netdev@kapio-technology.com
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
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
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 net-next 3/6] drivers: net: dsa: add locked fdb entry
 flag to drivers
User-Agent: Gigahost Webmail
Message-ID: <5a4cfc6246f621d006af69d4d1f61ed1@kapio-technology.com>
X-Sender: netdev@kapio-technology.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-08-11 13:28, Ido Schimmel wrote:

>> > I'm talking about roaming, not forwarding. Let's say you have a locked
>> > entry with MAC X pointing to port Y. Now you get a packet with SMAC X
>> > from port Z which is unlocked. Will the FDB entry roam to port Z? I
>> > think it should, but at least in current implementation it seems that
>> > the "locked" flag will not be reset and having locked entries pointing
>> > to an unlocked port looks like a bug.
>> >
>> 

In general I have been thinking that the said setup is a network 
configuration error as I was arguing in an earlier conversation with 
Vladimir. In this setup we must remember that SMAC X becomes DMAC X in 
the return traffic on the open port. But the question arises to me why 
MAC X would be behind the locked port without getting authed while being 
behind an open port too?
In a real life setup, I don't think you would want random hosts behind a 
locked port in the MAB case, but only the hosts you will let through. 
Other hosts should be regarded as intruders.

If we are talking about a station move, then the locked entry will age 
out and MAC X will function normally on the open port after the timeout, 
which was a case that was taken up in earlier discussions.

But I will anyhow do some testing with this 'edge case' (of being behind 
both a locked and an unlocked port) if I may call it so, and see to that 
the offloaded and non-offloaded cases correspond to each other, and will 
work satisfactory.

I think it will be good to have a flag to enable the mac-auth/MAB 
feature, and I suggest just calling the flag 'mab', as it is short.

Otherwise I don't see any major issues with the whole feature as it is.
