Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52D7F4FE528
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 17:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357351AbiDLPxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 11:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357316AbiDLPxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 11:53:36 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B45B5F8EA;
        Tue, 12 Apr 2022 08:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:
        From:References:Cc:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe
        :List-Post:List-Owner:List-Archive;
        bh=mrCm7O0AOGuUALk8FdZFHmOnDPg19J6/n+0pIC0Acp0=; b=VQ2/JqQvNP2N9xFX9FKsYFdCZ2
        GtyGq0jli90l9GBUz7tsQWFvyErRHsEz/GuarzC8CJYV7HKBNVyZ5eMHsyZ3AxHzl17ZI1OrQ01Ua
        pHRwNYaSUPpCtSfHwAiy5Z+L0Pp9Nh/a4mlfHYQaLbQ4Vubs3Z4M7q0UqLUpqookJC0w=;
Received: from p57a6f1f9.dip0.t-ipconnect.de ([87.166.241.249] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1neInJ-0003dk-U7; Tue, 12 Apr 2022 17:51:06 +0200
Message-ID: <29cecc87-8689-6a73-a5ef-43eb2b8f33cd@nbd.name>
Date:   Tue, 12 Apr 2022 17:51:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20220405195755.10817-1-nbd@nbd.name>
 <20220405195755.10817-15-nbd@nbd.name> <Yk8pJRxnVCfdk8xi@lunn.ch>
 <f25a6278-1baf-cc27-702a-5d93eedda438@nbd.name> <YlQmf7qGAnq/3nW0@lunn.ch>
 <ece29b0d-bbbe-7c03-a6b4-60e44453ca31@nbd.name> <YlV5jEzNZT1aKmNL@lunn.ch>
 <ee1d6c89-95f4-bf28-cf25-36b18ffb342f@nbd.name> <YlWK5Dozpo7nIS9j@lunn.ch>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH v2 14/14] net: ethernet: mtk_eth_soc: support creating mac
 address based offload entries
In-Reply-To: <YlWK5Dozpo7nIS9j@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12.04.22 16:21, Andrew Lunn wrote:
> On Tue, Apr 12, 2022 at 03:49:51PM +0200, Felix Fietkau wrote:
>> 
>> On 12.04.22 15:07, Andrew Lunn wrote:
>> > > > > > > I'm trying to understand the architecture here.
>> > > > > > > We have an Ethernet interface and a Wireless interface. The slow
>> > > > > path
>> > > > > > is that frames ingress from one of these interfaces, Linux decides
>> > > > > > what to do with them, either L2 or L3, and they then egress probably
>> > > > > > out the other interface.
>> > > > > > > The hardware will look at the frames and try to spot flows? It
>> > > > > will
>> > > > > > then report any it finds. You can then add an offload, telling it for
>> > > > > > a flow it needs to perform L2 or L3 processing, and egress out a
>> > > > > > specific port? Linux then no longer sees the frame, the hardware
>> > > > > > handles it, until the flow times out?
>> > > > > Yes, the hw handles it until either the flow times out, or the corresponding
>> > > > > offload entry is removed.
>> > > > > > > For OpenWrt I also wrote a daemon that uses tc classifier
>> > > BPF to accelerate
>> > > > > the software bridge and create hardware offload entries as well via hardware
>> > > > > TC flower rules: https://github.com/nbd168/bridger
>> > > > > It works in combination with these changes.
>> > > > > What about the bridge? In Linux, it is the software bridge which
>> > > > controls all this at L2, and it should be offloading the flows, via
>> > > > switchdev. The egress port you derive here is from the software bridge
>> > > > FDB?
>> > 
>> > > My code uses netlink to fetch and monitor the bridge configuration,
>> > > including fdb, port state, vlans, etc. and it uses that for the offload path
>> > > - no extra configuration needed.
>> > 
>> > So this is where we get into architecture issues. Do we really want
>> > Linux to have two ways for setting up L2 networking? It was decided
>> > that users should not need to know about how to use an accelerator,
>> > they should not use additional tools, it should just look like
>> > linux. The user should just add the WiFi netdev to the bridge and
>> > switchdev will do the rest to offload L2 switching to the hardware.
>> > 
>> > You appear to be saying you need a daemon in userspace. That is not
>> > how every other accelerate works in Linux networking.
>> > 
>> > We the Linux network community need to decided if we want this?
> 
>> The problem here is that it can't be fully transparent. Enabling hardware
>> offload for LAN -> WiFi comes at a cost of bypassing airtime fairness and
>> mac80211's bufferbloat mitigation.
>> Some people want this anyway (often but not always for benchmark/marketing
>> purposes), but it's not something that I would want to have enabled by
>> default simply by a wifi netdev to a bridge.
> 
> So this sounds like a generic issue. How does IPA handle this? Looping
> in Alex Elder.
> 
> There is already something partially in this direction in the
> bridge. You can add a static entry with our without self. This
> controls if a specific static entry in the FDB is offloaded to the
> accelerate or not. Maybe you can add an attribute to a port which
> determines if dynamic entries are self or not, so you can decide if
> frames egressing out a specific interface are accelerated or not,
> depending on user choice. Since such a change should not touch the
> fast path, it has a better chance of being merged.
Sounds interesting. If there is some overlap and if we can get some 
common code in place, it might be worth looking into for the MTK offload 
as well. I do think this will take more time though.

>> Initially, I wanted to put more of the state tracking code in the kernel. I
>> made the first implementation of my acceleration code as a patch to the
>> network bridge - speeding up bridge unicast forwarding significantly for any
>> device regardless of hardware support. I wanted to build on that to avoid
>> putting a lot of FDB/VLAN related tracking directly into the driver.
> 
> But the driver is the correct place for this. How generic is the state
> tracking? Do you expect any other hardware to need the same state
> tracking? IPA? Some other accelerate your know of?
It basically has to keep track of all possible destination ports, their 
STP state, all their fdb entries, member VLANs of all ports. It has to 
quickly react to changes in any of these.
In order to implement this properly, I would also need to make more 
changes to mac80211. Right now, mac80211 drivers do not have access to 
the net_device pointer of virtual interfaces. So mac80211 itself would 
likely need to implement the switchdev ops and handle some of this.

There are also some other issues where I don't know how this is supposed 
to be solved properly:
On MT7622 most of the bridge ports are connected to a MT7531 switch 
using DSA. Offloading (lan->wlan bridging or L3/L4 NAT/routing) is not 
handled by the switch itself, it is handled by a packet processing 
engine in the SoC, which knows how to handle the DSA tags of the MT7531 
switch.

So if I were to handle this through switchdev implemented on the wlan 
and ethernet devices, it would technically not be part of the same 
switch, since it's a behind a different component with a different driver.

Also, is switchdev able to handle the situation where only parts of the 
traffic is offloaded and the rest (e.g. multicast) is handled through 
the regular software path?

In my opinion, handling it through the TC offload has a number of 
advantages:
- It's a lot simpler
- It uses the same kind of offloading rules that my software fastpath 
already uses
- It allows more fine grained control over which traffic should be 
offloaded (src mac -> destination MAC tuple)

I also plan on extending my software fast path code to support emulating 
bridging of WiFi client mode interfaces. This involves doing some MAC 
address translation with some IP address tracking. I want that to 
support hardware offload as well.

I really don't think that desire for supporting switchdev based offload 
should be a blocker for accepting this code now, especially since my 
implementation relies on existing Linux network APIs without inventing 
any new ones, and there are valid use cases for using it, even with 
switchdev support in place.

- Felix
