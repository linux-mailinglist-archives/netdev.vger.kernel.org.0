Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B66D861954E
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 12:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbiKDLXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 07:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbiKDLXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 07:23:12 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0328763BD
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 04:23:09 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id A06FA1883880;
        Fri,  4 Nov 2022 11:23:07 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 681AF25002E1;
        Fri,  4 Nov 2022 11:23:07 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 4E2B691201E4; Fri,  4 Nov 2022 11:23:07 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Fri, 04 Nov 2022 12:23:07 +0100
From:   netdev@kapio-technology.com
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        roopa@nvidia.com, razor@blackwall.org, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 1/2] bridge: Add MAC Authentication Bypass (MAB)
 support
In-Reply-To: <20221103231838.fp5nh5g3kv7cz2d2@skbuf>
References: <20221101193922.2125323-1-idosch@nvidia.com>
 <20221101193922.2125323-1-idosch@nvidia.com>
 <20221101193922.2125323-2-idosch@nvidia.com>
 <20221101193922.2125323-2-idosch@nvidia.com>
 <20221103231838.fp5nh5g3kv7cz2d2@skbuf>
User-Agent: Gigahost Webmail
Message-ID: <ce9f4095b216187c1dd5c14cdf4ae9cc@kapio-technology.com>
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

On 2022-11-04 00:18, Vladimir Oltean wrote:
> On Tue, Nov 01, 2022 at 09:39:21PM +0200, Ido Schimmel wrote:
>> From: "Hans J. Schultz" <netdev@kapio-technology.com>
>> 
>> Hosts that support 802.1X authentication are able to authenticate
>> themselves by exchanging EAPOL frames with an authenticator (Ethernet
>> bridge, in this case) and an authentication server. Access to the
>> network is only granted by the authenticator to successfully
>> authenticated hosts.
>> 
>> The above is implemented in the bridge using the "locked" bridge port
>> option. When enabled, link-local frames (e.g., EAPOL) can be locally
>> received by the bridge, but all other frames are dropped unless the 
>> host
>> is authenticated. That is, unless the user space control plane 
>> installed
>> an FDB entry according to which the source address of the frame is
>> located behind the locked ingress port. The entry can be dynamic, in
>> which case learning needs to be enabled so that the entry will be
>> refreshed by incoming traffic.
>> 
>> There are deployments in which not all the devices connected to the
>> authenticator (the bridge) support 802.1X. Such devices can include
>> printers and cameras. One option to support such deployments is to
>> unlock the bridge ports connecting these devices, but a slightly more
>> secure option is to use MAB. When MAB is enabled, the MAC address of 
>> the
>> connected device is used as the user name and password for the
>> authentication.
>> 
>> For MAB to work, the user space control plane needs to be notified 
>> about
>> MAC addresses that are trying to gain access so that they will be
>> compared against an allow list. This can be implemented via the 
>> regular
>> learning process with the sole difference that learned FDB entries are
>> installed with a new "locked" flag indicating that the entry cannot be
>> used to authenticate the device. The flag cannot be set by user space,
>> but user space can clear the flag by replacing the entry, thereby
>> authenticating the device.
>> 
>> Locked FDB entries implement the following semantics with regards to
>> roaming, aging and forwarding:
>> 
>> 1. Roaming: Locked FDB entries can roam to unlocked (authorized) 
>> ports,
>>    in which case the "locked" flag is cleared. FDB entries cannot roam
>>    to locked ports regardless of MAB being enabled or not. Therefore,
>>    locked FDB entries are only created if an FDB entry with the given 
>> {MAC,
>>    VID} does not already exist. This behavior prevents unauthenticated
>>    devices from disrupting traffic destined to already authenticated
>>    devices.
>> 
>> 2. Aging: Locked FDB entries age and refresh by incoming traffic like
>>    regular entries.
>> 
>> 3. Forwarding: Locked FDB entries forward traffic like regular 
>> entries.
>>    If user space detects an unauthorized MAC behind a locked port and
>>    wishes to prevent traffic with this MAC DA from reaching the host, 
>> it
>>    can do so using tc or a different mechanism.
> 
> In other words, a user space MAB daemon has a lot of extra work to do.
> I'm willing to bet it's going to cut 90% of those corners ;) anyway...
> 

I would like to know your (Vladimir) take on the approach of the
implementation for the mv88e6xxx that I have made and which will also be
the basis for how the WesterMo hostapd fork will be afaik...

Is it in general a good idea to use TC filters for specific MACs instead
of having the driver installing blocking entries, which I know the 
Marvell
XCat switchcore will also have (switchcore installed blockig entries)?


>> 
>> Enable the above behavior using a new bridge port option called "mab".
>> It can only be enabled on a bridge port that is both locked and has
>> learning enabled. Locked FDB entries are flushed from the port once 
>> MAB
>> is disabled. A new option is added because there are pure 802.1X
>> deployments that are not interested in notifications about locked FDB
>> entries.
>> 
>> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
>> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
>> ---
> 
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
