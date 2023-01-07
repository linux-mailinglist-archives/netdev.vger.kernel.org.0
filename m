Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00055660DEB
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 11:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbjAGKcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 05:32:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbjAGKcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 05:32:10 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B22F285CB2;
        Sat,  7 Jan 2023 02:32:08 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 6EE2C1883903;
        Sat,  7 Jan 2023 10:32:07 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 4924E250007B;
        Sat,  7 Jan 2023 10:32:07 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 3743E91201E4; Sat,  7 Jan 2023 10:32:07 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Sat, 07 Jan 2023 11:32:06 +0100
From:   netdev@kapio-technology.com
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 net-next 3/3] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
In-Reply-To: <20230106164112.qwpqszvrmb5uv437@skbuf>
References: <20230106160529.1668452-1-netdev@kapio-technology.com>
 <20230106160529.1668452-4-netdev@kapio-technology.com>
 <20230106164112.qwpqszvrmb5uv437@skbuf>
User-Agent: Gigahost Webmail
Message-ID: <6abb27f946d39602bd05cdcbea21766c@kapio-technology.com>
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

On 2023-01-06 17:41, Vladimir Oltean wrote:
> On Fri, Jan 06, 2023 at 05:05:29PM +0100, Hans J. Schultz wrote:
>> This implementation for the Marvell mv88e6xxx chip series is based on
>> handling ATU miss violations occurring when packets ingress on a port
>> that is locked with learning on. This will trigger a
>> SWITCHDEV_FDB_ADD_TO_BRIDGE event, which will result in the bridge 
>> module
>> adding a locked FDB entry. This bridge FDB entry will not age out as
>> it has the extern_learn flag set.
>> 
>> Userspace daemons can listen to these events and either accept or deny
>> access for the host, by either replacing the locked FDB entry with a
>> simple entry or leave the locked entry.
>> 
>> If the host MAC address is already present on another port, a ATU
>> member violation will occur, but to no real effect, and the packet 
>> will
>> be dropped in hardware. Statistics on these violations can be shown 
>> with
>> the command and example output of interest:
>> 
>> ethtool -S ethX
>> NIC statistics:
>> ...
>>      atu_member_violation: 5
>>      atu_miss_violation: 23
>> ...
>> 
>> Where ethX is the interface of the MAB enabled port.
>> 
>> Furthermore, as added vlan interfaces where the vid is not added to 
>> the
>> VTU will cause ATU miss violations reporting the FID as
>> MV88E6XXX_FID_STANDALONE, we need to check and skip the miss 
>> violations
>> handling in this case.
>> 
>> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
>> ---
> 
> Please add Acked-by/Reviewed-by tags when posting new versions. 
> However,
> there's no need to repost patches *only* to add the tags. The upstream
> maintainer will do that for acks received on the version they apply.
> 
> If a tag was not added on purpose, please state why and what changed.
> 
> Missing tags:
> 
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
> 
> 
> Please allow at least 24 hours between patch submissions to give time
> for other review comments.

I presume that since I move the exit tag 'out' to this patch, it has 
changed and the review tag is reset?
