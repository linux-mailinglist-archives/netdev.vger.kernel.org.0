Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0486F1997
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 15:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346039AbjD1Ncg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 09:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbjD1Ncf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 09:32:35 -0400
Received: from sender3-op-o19.zoho.com (sender3-op-o19.zoho.com [136.143.184.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116AA2713
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 06:32:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1682688731; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=VUUUukItlpLkMBSvv1yKvc8IbNhQanuwRGAsbMhxd7yq+1rjcQXqZwqEiY1TIBsKdP0MudfS7HNGp2Y23FChagbjlzzYWwqyFl6JKcEgLHmzSxcdJLxERmjd+mrJz4s6hyWua4OqIaOzqk4VXA+siTuLiQQZFtiHsdENKWYb7s4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1682688731; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=eWJUu3MXtAInyVwcNSn1TKt1WBrgVJBe6+wMvt9t3wc=; 
        b=fOJWHpmQm7m0Uu6xO/MMCZaCyEKL3McT7s8uIcaZI4rX93px2GTdoCyEJppKvUSrYisAcv1yxjfrxW5pYB1Ca24/tH3JuCkMHzvNqa0mwdparMsoorZs1h1e0sw2ZjXsrI/n0qjLKs9luBhULlYruuc0abaW1H4DBlZQEO4XK10=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1682688731;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=eWJUu3MXtAInyVwcNSn1TKt1WBrgVJBe6+wMvt9t3wc=;
        b=RmnkVnR93hfr+RwCsCyDn6hb1ayPrXjE7C9oTTofTFi+v7Zzf94N+Vdy5ZN5wNTU
        b9nD265eTFB1uvHd/4Y6PubArCnfqxYVCbdmNvANNpouAA7VjT9xsloGvUOQ4V+HzHm
        gk6MMdFx7pvhl9Xe5ZpvDPS+UigxYFgzantPtXng=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1682688728972928.4817194188719; Fri, 28 Apr 2023 06:32:08 -0700 (PDT)
Message-ID: <0183eb91-8517-f40f-c2bb-b229e45d6fa5@arinc9.com>
Date:   Fri, 28 Apr 2023 16:31:53 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: MT7530 bug, forward broadcast and unknown frames to the correct
 CPU port
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     DENG Qingfang <dqfext@gmail.com>, Greg Ungerer <gerg@kernel.org>,
        Daniel Golle <daniel@makrotopia.org>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        mithat.guner@xeront.com, erkin.bozoglu@xeront.com,
        bartel.eerdekens@constell8.be, netdev <netdev@vger.kernel.org>
References: <8a955c34-5724-af9d-d828-a8786bcc08b0@arinc9.com>
 <8a955c34-5724-af9d-d828-a8786bcc08b0@arinc9.com>
 <20230426205450.kez5m5jr4xch7hql@skbuf>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230426205450.kez5m5jr4xch7hql@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.04.2023 23:54, Vladimir Oltean wrote:
> On Sun, Apr 23, 2023 at 06:22:41PM +0300, Arınç ÜNAL wrote:
>> Hey there folks,
>>
>> On mt753x_cpu_port_enable() there's code [0] that sets which port to forward
>> the broadcast, unknown multicast, and unknown unicast frames to. Since
>> mt753x_cpu_port_enable() runs twice when both CPU ports are enabled, port 6
>> becomes the port to forward the frames to. But port 5 is the active port, so
>> no broadcast frames received from the user ports will be forwarded to port
>> 5. This breaks network connectivity when multiple ports are being used as
>> CPU ports.
>>
>> My testing shows that only after receiving a broadcast ARP frame from port 5
>> then forwarding it to the user port, the unicast frames received from that
>> user port will be forwarded to port 5. I tested this with ping.
>>
>> Forwarding broadcast and unknown unicast frames to the CPU port was done
>> with commit 5a30833b9a16 ("net: dsa: mt7530: support MDB and bridge flag
>> operations"). I suppose forwarding the broadcast frames only to the CPU port
>> is what "disable flooding" here means.
> 
> Flooding means forwarding a packet that does not have a precise destination
> (its MAC DA is not present in the FDB or MDB). Flooding is done towards
> the ports that have flooding enabled.
> 
>>
>> It’s a mystery to me how the switch classifies multicast and unicast frames
>> as unknown. Bartel's testing showed LLDP frames fall under this category.
> 
> What is mysterious exactly? What's not in the FDB/MDB is unknown. And
> DSA, unless the requirements from dsa_switch_supports_uc_filtering() and
> dsa_switch_supports_mc_filtering() are satisfied, will not program MAC
> addresses for host RX filtering to the CPU port(s).
> 
> This switch apparently has the option to automatically learn from the MAC SA
> of packets injected by software. That option is automatically enabled
> unless MTK_HDR_XMIT_SA_DIS is set (which currently it never is).
> 
> So when software sends a broadcast ARP frame from port 5, the switch
> learns the MAC SA of this packet (which is the software MAC address of
> the user port) and it associates it with port 5. So future traffic
> destined to the user port's software MAC address now reaches port 5, the
> active CPU port (and the real CPU port from DSA's perspective).
> 
> Wait 5 minutes for the learned FDB entry to expire, and the problem will
> probably be back.

Understood, thank you.

> 
> LLDP frames should not obey the same rules. They are sent to the MAC DA
> of 01:80:c2:00:00:0e, which is in the link-local multicast address space
> (hence the "LL" in the name), and which according to IEEE 802.1Q-2018 is
> the "Nearest Bridge group address":
> 
> | The Nearest Bridge group address is an address that no conformant TPMR
> | component, S-VLAN component, C-VLAN component, or MAC Bridge can
> | forward. PDUs transmitted using this destination address, or any of the
> | other addresses that appear in all three tables, can therefore travel no
> | further than those stations that can be reached via a single individual
> | LAN from the originating station. Hence the Nearest Bridge group address
> | is also known as the Individual LAN Scope group address.
> 
> Removing a packet from the forwarding data plane and delivering it only
> to the CPU is known as "trapping", and thus, it is not "flooding".
> 
> The MAC SA learning trick will not make port 5 see LLDP frames, since
> those are not targeted towards a unicast MAC address which could be
> learned.

Got it. Bartel has already wrote code to trap the LLDP frames with :03 
and :0E MAC DA to the CPU port by utilising the MT753X_RGAC2 (0x2C) 
register.

I will make sure the code gets in after the issues with multiple CPUs 
are dealt with.

> 
>>
>> Until the driver supports changing the DSA conduit, unknown frames should be
>> forwarded to the active CPU port, not the numerically greater one. Any ideas
>> how to address this and the "disable flooding" case?
> 
> I think I also signaled the reverse problem in the other thread:
> https://lore.kernel.org/netdev/20230222193951.rjxgxmopyatyv2t7@skbuf/

/* BPDU to CPU port */
dsa_switch_for_each_cpu_port(cpu_dp, ds) {
	mt7530_rmw(priv, MT7531_CFC, MT7531_CPU_PMAP_MASK,
			BIT(cpu_dp->index));
	break;
}

I don't really understand this. This doesn't seem to be related to 
processing BPDUs. This looks something extra for MT7531, on top of 
MT7530_MFC.

If both CPU ports are enabled, should BIT(5) and BIT(6) on 
MT7531_CPU_PMAP_MASK be set to 1?

> 
> Well, the most important step in fixing the problem would be to
> politically decide which port should be the active CPU port in the case
> of multiple choices, then to start fixing up the bits in the driver that
> disagree with that. Having half the code think it's 5 and the other half
> think it's 6 surely isn't any good.
> 
> There was a discussion in the other thread with Frank that port 6 would
> be somehow preferable if both are available, but I haven't seen convincing
> enough arguments yet.

It seems to be fine for MT7530, but MT7531BE has got RGMII on port 5. It 
would be much better to use port 6 which has got a 2.5G SGMII link.

The preferred_default_local_cpu_port operation should work properly 
after we figure out the issue above and below.

> 
>>
>> There's also this "set the CPU number" code that runs only for MT7621. I'm
>> not sure why this is needed or why it's only needed for MT7621. Greg, could
>> you shed some light on this since you added this code with commit
>> ddda1ac116c8 ("net: dsa: mt7530: support the 7530 switch on the Mediatek
>> MT7621 SoC")?
>>
>> There're more things to discuss after supporting changing the DSA conduit,
>> such as which CPU port to forward the unknown frames to, when user ports
>> under different conduits receive unknown frames. What makes sense to me is,
>> if there are multiple CPU ports being used, forward the unknown frames to
>> port 6. This is already the case except the code runs twice. If not, set it
>> to whatever 'int port' is, which is the default behaviour already.
>>
>> [0] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/drivers/net/dsa/mt7530.c#n1005
> 
> I suspect you may not have run sufficient tests. When there are 2 CPU
> ports, both of them should be candidates for flooding unknown traffic.
> Don't worry, software won't see duplicates, because the user <-> CPU port
> affinity setting should restrict forwarding of the flooded frames to a
> single CPU port.
> 
> You might be confused by several things about this:
> 
> 	/* Disable flooding by default */
> 	mt7530_rmw(priv, MT7530_MFC, BC_FFP_MASK | UNM_FFP_MASK | UNU_FFP_MASK,
> 		   BC_FFP(BIT(port)) | UNM_FFP(BIT(port)) | UNU_FFP(BIT(port)));
> 
> First, the comment. It means to say: "disable flooding on all ports
> except for this CPU port".
> 
> Then, the fact that it runs twice, unsetting flooding for the first CPU
> port (5) and setting it for the second one (6). There should be no
> hardware limitation there. Both BIT(5) and BIT(6) could be part of the
> flood mask without any problem.
> 
> Perhaps the issue is that MT7530_MFC should have been written to all
> zeroes as a first step, and then, every mt753x_cpu_port_enable() call
> enables flooding to the "int port" argument.

Thanks a lot! I'm just learning about the process of bit masking. If I 
understand correctly, masks for BC, UNM, and UNU are defined to have 8 bits.

UNU_FFP(~0) means that all bits are set to 1. I am supposed to first 
clear them, then set bit 5 and 6 to 1.

Before mt753x_cpu_port_enable():

mt7530_rmw(priv, MT7530_MFC, BC_FFP_MASK | UNM_FFP_MASK | UNU_FFP_MASK, 0);

For every mt753x_cpu_port_enable():

mt7530_rmw(priv, MT7530_MFC, BC_FFP_MASK | UNM_FFP_MASK | UNU_FFP_MASK,
	   (BC_FFP(BIT(port))) & BC_FFP_MASK | (UNM_FFP(BIT(port))) &
	   UNM_FFP_MASK | (UNU_FFP(BIT(port))) & UNU_FFP_MASK);

> 
> That being said, with trapped packets, software can end up processing
> traffic on a conduit interface that didn't originate from a user port
> affine to it. Software (DSA) should be fine with it, as long as the
> hardware is fine with it too.
> 
> The only thing to keep in mind is that the designated CPU port for
> trapped packets should always be reselected based on which conduit
> interface is up. Maybe lan0's conduit interface is eth0, which is up,
> but its trapped packets are handled by eth1 through some previous
> configuration, and eth1 went down. You don't want lan0 to lose packets.

If I understand correctly, this should be done on the port_change_master 
member whilst support for changing the DSA conduit is being introduced. 
I'm taking a note for when I get to this, thanks.

Arınç
