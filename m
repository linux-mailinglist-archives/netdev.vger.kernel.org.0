Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0A8589428
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 23:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236511AbiHCVvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 17:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbiHCVvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 17:51:48 -0400
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC83C12AB4
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 14:51:45 -0700 (PDT)
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4Lyltk4J8hz9sQT;
        Wed,  3 Aug 2022 23:51:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1659563502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4ByO9Gbmti/EP3qA25X80VD5nawLqFFDRvbEFHJxy6s=;
        b=xxt1tVL0WVvvyeM/d8MvmOBbT7+rndftC4JDNQh9cyb8Ou5H7YALun2RSPVepq3H62Q+oe
        STSBWGajtxvcKN5Q6iCoWv1v/eNfi0FNGj1fqwJ+0oOIF4Ki8npeYnc8kIp/LmtjBksTZV
        VIhuKExPhD0h086kvPIVIfUV7xBTaa+VJolkIrpDBqroE2/nFgQRD9HFSsLahBtke2zZct
        CBl4S/9Q4jluQjqTV7QgKkFoqJiYMtYCrx1bIoxtWkLH+6vQSif3NI7pFnQlIewjJo3r1z
        xMNE+zRG/aKlUlfjgMTEX5561frR/ctiAwryoQ9AloX6W0CEAs0q042RXIGiwg==
Message-ID: <0e66011d-c3bd-5df2-e81d-5b67e4689330@hauke-m.de>
Date:   Wed, 3 Aug 2022 23:51:41 +0200
MIME-Version: 1.0
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, Aleksander Jan Bajkowski <olek2@wp.pl>
References: <CAFBinCDX5XRyMyOd-+c_Zkn6dawtBpQ9DaPkA4FDC5agL-t8CA@mail.gmail.com>
 <CAFBinCDX5XRyMyOd-+c_Zkn6dawtBpQ9DaPkA4FDC5agL-t8CA@mail.gmail.com>
 <20220727224409.jhdw3hqfta4eg4pi@skbuf>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: net: dsa: lantiq_gswip: getting the first selftests to pass
In-Reply-To: <20220727224409.jhdw3hqfta4eg4pi@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4Lyltk4J8hz9sQT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/28/22 00:44, Vladimir Oltean wrote:
> Hi Martin,
> 
> On Wed, Jul 27, 2022 at 10:36:55PM +0200, Martin Blumenstingl wrote:
>> Hello,
>>
.....
>> Vladimir suggested in [0]:
>>> [...] we'll need to make smaller steps, like disable address
>>> learning on standalone ports, isolate FDBs, maybe offload the bridge TX
>>> forwarding process (in order to populate the "Force no learning" bit in
>>> tag_gswip.c properly), and only then will the local_termination test
>>> also pass [...]
>>
>> Based on the failing tests I am wondering which step would be a good
>> one to start with.
>> Is this problem that the selftests are seeing a flooding issue? In
>> that case I suspect that the "interesting behavior" (of the GSWIP's
>> flooding behavior) that Vladimir described in [1] would be a starting
>> point.
> 
> It has to do with that, yes. What I said there is that the switch
> doesn't autonomously flood unknown packets from one bridged port to
> another, but instead, sends them to the CPU and lets the CPU do it.
> 
> While that is perfectly respectable from a correctness point of view,
> it is also not optimal if you consider performance. The selftests here
> try to capture the fact that the switch doesn't send unknown packets to
> the CPU. And in this case the driver sends them by construction.

This was done intentional, the driver configures the switch to send all 
unknown unicast and unknown multicast packets to the CPU.
The PMAP_3 register configures the target port of unicast packets where 
the destination mac address is not found in the mac forwarding table.
The PMAP_2 register configures where the switch should send multicast 
packets without a destination mac in the mac table.
The PMAP_1 register configures the destination port where all packets 
are forwarded (mirrored) to.

If the packets are mirrored a special bit will be set in the special CPU 
tag. (Bit 0 in Byte 3). I think this will only be set when it is 
forwarded using PMAP_1 register.

I think we can not configure this per source port.

> So the absolute first step would be to control the bridge port flags
> (BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD) and start
> with good defaults for standalone mode (also set skb->offload_fwd_mark
> when appropriate in the tagging protocol driver). I think you can use
> bridge_vlan_aware.sh and bridge_vlan_unaware.sh as starting points to
> check that these flags still work fine after you've offloaded them to
> hardware.

I think it is not possible to configure a per source port flooding.

We can configure a port into these modes:
* listen only
* transmit disable, receive enable
* transmit enable, receive disable
* learning
* forwarding

> When flooding a packet to find its destination can be achieved without
> involving the CPU (*), the next thing will be to simply disable flooding
> packets of all kind to the CPU (except broadcast). That's when you'll
> enjoy watching how all the local_termination.sh selftests fail, and
> you'll be making them pass again, one by one.
> 
>>
>> Full local_termination.sh selftest output:
>> TEST: lan2: Unicast IPv4 to primary MAC address                 [ OK ]
> 
> For this to pass, the driver must properly respond to a port_fdb_add()
> on the CPU port, with the MAC address of the $swp1 user port's net device,
> offloaded in the DSA_DB_PORT corresponding to $swp1.

I think this is already done.

> In turn, for DSA to even consider passing you FDB entries in DSA_DB_PORT,
> you must make dsa_switch_supports_uc_filtering() return true.
> 
> (if you don't know what the words here mean, I've updated the documentation at
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/tree/Documentation/networking/dsa/dsa.rst)
> 
.....
> 
>> TEST: lan2: Unicast IPv4 to unknown MAC address, promisc        [ OK ]
> 
> Now this passes because the expectation of promiscuous ports is to
> receive all packets regardless of MAC DA, that's the definition of
> promiscuity. The driver currently already floods to the CPU, so why
> wouldn't this pass.
> 
> Here, what we actually want to capture is that dsa_slave_manage_host_flood(),
> which responds to changes in the IFF_PROMISC flag on a user port, does
> actually notify the driver via a call to port_set_host_flood() for that
> user port. Through this method, the driver is responsible for turning
> flooding towards the CPU port(s) on or off, from the user port given as
> argument. If CPU flood control does not depend on user port, then you'll
> have to keep CPU flooding enabled as long as any user port wants it.

We could use the mirror feature here.
We could activate port mirror with the CPU port as target and only 
activate receive mirroring on ports where we activate IFF_PROMISC.
....
> 
>> TEST: lan2: Multicast IPv4 to joined group                      [ OK ]
> 
> Here, I used a trivial program I found online to emit a IP_ADD_MEMBERSHIP
> setsockopt, to trigger the kernel code that calls dev_mc_add() on the
> net device. It seems to not be possible by design to join an IP
> multicast group using a dedicated command in a similar way to how you'd
> add an FDB entry on a port; instead the kernel joins the multicast group
> for as long as the user application persists, and leaves the group afterwards.
> 
> As you can probably guess, dev_mc_add() calls made by modules outside
> DSA are translated by dsa_slave_set_rx_mode() into a port_mdb_add() on
> the CPU port, with DSA_DB_PORT.
> 
> If the gswip driver doesn't implement port_mdb_add() but rather treats
> multicast as broadcast (by sending it to the CPU), naturally this test
> "passes" in the sense that it thinks the driver reacted properly to what
> was asked.

Yes port_mdb_add() is not implemented yet, but should be easy, it is the 
same as port_fdb_add() it just allows multiple destinations.

