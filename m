Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6B36F24C1
	for <lists+netdev@lfdr.de>; Sat, 29 Apr 2023 15:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbjD2NEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Apr 2023 09:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjD2NEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Apr 2023 09:04:36 -0400
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F06D1FD5
        for <netdev@vger.kernel.org>; Sat, 29 Apr 2023 06:04:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1682773454; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=XJhlCuxwhXTSjuJdGcYs/vCZ9G+G/oh6nlMcREBx2Jd5jthkFg/GovvFKhQnL62qL51xMlPX3fzz9kERW1sJBaH3jc241XJ9QOccWPRz3ASiQsuPr5M6XoCm1SZu3S8zWsA1ptCIP8bGiVLDfcKmCA5WsMY6HcL1ptlnFEOAzu4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1682773454; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=yUDzPU7xT19VU3tguL842vRbZB9sQaSg21dx+w9aAuA=; 
        b=gZykOPDCBj9cmaCpJRX5mvk+gKbLFacqYOL7tXR23ezzftuaT0DaMK3IzoT9KBNvCdzYfaDuTHkuMAhXhyJNMm8Rtbpj6ixv1QOdNLlXYjqAUMdRFp8fT9ZKX8t/Yp6elMJzT7Hsb6SSV39IgRNLB3QRD+anfpj7EL9QQrUJ46k=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1682773454;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:From:From:Subject:Subject:To:To:Cc:Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=yUDzPU7xT19VU3tguL842vRbZB9sQaSg21dx+w9aAuA=;
        b=OZJ76cL4tJ6jqKomRpXolPsrYcWh4XbiZc5qIr0MaW9XbtlEvvyS3zVa5BpErAAP
        E4T97ItjIHW8Ner11Znu8Zjr8I7zguwN9kZg1cj3VIQvbIyT8brjq28flrGf3XBXqRC
        l+AlX3A50G68rybEv7EYc2ylEG+Q8QrN9P9KdsDw=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 168277345351671.8481128776989; Sat, 29 Apr 2023 06:04:13 -0700 (PDT)
Message-ID: <8d6a46a7-a769-4532-dd44-f230b705a675@arinc9.com>
Date:   Sat, 29 Apr 2023 16:03:57 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
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
 <0183eb91-8517-f40f-c2bb-b229e45d6fa5@arinc9.com>
Content-Language: en-US
In-Reply-To: <0183eb91-8517-f40f-c2bb-b229e45d6fa5@arinc9.com>
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

(The netdev mailing list didn't like the big attachments so I'm sending
this again with links to the documents instead.)

I'm answering to myself now that I know better.

On 28.04.2023 16:31, Arınç ÜNAL wrote:
> On 26.04.2023 23:54, Vladimir Oltean wrote:
>> On Sun, Apr 23, 2023 at 06:22:41PM +0300, Arınç ÜNAL wrote:
>>> Hey there folks,
>>>
>>> On mt753x_cpu_port_enable() there's code [0] that sets which port to 
>>> forward
>>> the broadcast, unknown multicast, and unknown unicast frames to. Since
>>> mt753x_cpu_port_enable() runs twice when both CPU ports are enabled, 
>>> port 6
>>> becomes the port to forward the frames to. But port 5 is the active 
>>> port, so
>>> no broadcast frames received from the user ports will be forwarded to 
>>> port
>>> 5. This breaks network connectivity when multiple ports are being 
>>> used as
>>> CPU ports.
>>>
>>> My testing shows that only after receiving a broadcast ARP frame from 
>>> port 5
>>> then forwarding it to the user port, the unicast frames received from 
>>> that
>>> user port will be forwarded to port 5. I tested this with ping.
>>>
>>> Forwarding broadcast and unknown unicast frames to the CPU port was done
>>> with commit 5a30833b9a16 ("net: dsa: mt7530: support MDB and bridge flag
>>> operations"). I suppose forwarding the broadcast frames only to the 
>>> CPU port
>>> is what "disable flooding" here means.
>>
>> Flooding means forwarding a packet that does not have a precise 
>> destination
>> (its MAC DA is not present in the FDB or MDB). Flooding is done towards
>> the ports that have flooding enabled.
>>
>>>
>>> It’s a mystery to me how the switch classifies multicast and unicast 
>>> frames
>>> as unknown. Bartel's testing showed LLDP frames fall under this 
>>> category.
>>
>> What is mysterious exactly? What's not in the FDB/MDB is unknown. And
>> DSA, unless the requirements from dsa_switch_supports_uc_filtering() and
>> dsa_switch_supports_mc_filtering() are satisfied, will not program MAC
>> addresses for host RX filtering to the CPU port(s).
>>
>> This switch apparently has the option to automatically learn from the 
>> MAC SA
>> of packets injected by software. That option is automatically enabled
>> unless MTK_HDR_XMIT_SA_DIS is set (which currently it never is).
>>
>> So when software sends a broadcast ARP frame from port 5, the switch
>> learns the MAC SA of this packet (which is the software MAC address of
>> the user port) and it associates it with port 5. So future traffic
>> destined to the user port's software MAC address now reaches port 5, the
>> active CPU port (and the real CPU port from DSA's perspective).
>>
>> Wait 5 minutes for the learned FDB entry to expire, and the problem will
>> probably be back.
> 
> Understood, thank you.
> 
>>
>> LLDP frames should not obey the same rules. They are sent to the MAC DA
>> of 01:80:c2:00:00:0e, which is in the link-local multicast address space
>> (hence the "LL" in the name), and which according to IEEE 802.1Q-2018 is
>> the "Nearest Bridge group address":
>>
>> | The Nearest Bridge group address is an address that no conformant TPMR
>> | component, S-VLAN component, C-VLAN component, or MAC Bridge can
>> | forward. PDUs transmitted using this destination address, or any of the
>> | other addresses that appear in all three tables, can therefore 
>> travel no
>> | further than those stations that can be reached via a single individual
>> | LAN from the originating station. Hence the Nearest Bridge group 
>> address
>> | is also known as the Individual LAN Scope group address.
>>
>> Removing a packet from the forwarding data plane and delivering it only
>> to the CPU is known as "trapping", and thus, it is not "flooding".
>>
>> The MAC SA learning trick will not make port 5 see LLDP frames, since
>> those are not targeted towards a unicast MAC address which could be
>> learned.
> 
> Got it. Bartel has already wrote code to trap the LLDP frames with :03 
> and :0E MAC DA to the CPU port by utilising the MT753X_RGAC2 (0x2C) 
> register.
> 
> I will make sure the code gets in after the issues with multiple CPUs 
> are dealt with.
> 
>>
>>>
>>> Until the driver supports changing the DSA conduit, unknown frames 
>>> should be
>>> forwarded to the active CPU port, not the numerically greater one. 
>>> Any ideas
>>> how to address this and the "disable flooding" case?
>>
>> I think I also signaled the reverse problem in the other thread:
>> https://lore.kernel.org/netdev/20230222193951.rjxgxmopyatyv2t7@skbuf/
> 
> /* BPDU to CPU port */
> dsa_switch_for_each_cpu_port(cpu_dp, ds) {
>      mt7530_rmw(priv, MT7531_CFC, MT7531_CPU_PMAP_MASK,
>              BIT(cpu_dp->index));
>      break;
> }
> 
> I don't really understand this. This doesn't seem to be related to 
> processing BPDUs. This looks something extra for MT7531, on top of 
> MT7530_MFC.
> 
> If both CPU ports are enabled, should BIT(5) and BIT(6) on 
> MT7531_CPU_PMAP_MASK be set to 1?

Yes, the MT7531 reference manual [0] points to that. Looks like the
MT7531 switch looks at the CPU ports set on the CPU_PMAP bits for the
BPDU_PORT_FW configuration on the MT753X_BPC register to work.

MT7531 has got the MT7530_MFC register too but it's slightly different.
The last 8 bits on the register are for IGMP/MLD Query Frame Flooding
Ports, instead of CPU_EN, CPU_PORT, MIRROR_EN, MIRROR_PORT on MT7530 [1].

Mirroring and CPU port configuration is handled on MT7531_CFC for
MT7531, so it makes sense.

> 
>>
>> Well, the most important step in fixing the problem would be to
>> politically decide which port should be the active CPU port in the case
>> of multiple choices, then to start fixing up the bits in the driver that
>> disagree with that. Having half the code think it's 5 and the other half
>> think it's 6 surely isn't any good.
>>
>> There was a discussion in the other thread with Frank that port 6 would
>> be somehow preferable if both are available, but I haven't seen 
>> convincing
>> enough arguments yet.
> 
> It seems to be fine for MT7530, but MT7531BE has got RGMII on port 5. It 
> would be much better to use port 6 which has got a 2.5G SGMII link.
> 
> The preferred_default_local_cpu_port operation should work properly 
> after we figure out the issue above and below.
> 
>>
>>>
>>> There's also this "set the CPU number" code that runs only for 
>>> MT7621. I'm
>>> not sure why this is needed or why it's only needed for MT7621. Greg, 
>>> could
>>> you shed some light on this since you added this code with commit
>>> ddda1ac116c8 ("net: dsa: mt7530: support the 7530 switch on the Mediatek
>>> MT7621 SoC")?
>>>
>>> There're more things to discuss after supporting changing the DSA 
>>> conduit,
>>> such as which CPU port to forward the unknown frames to, when user ports
>>> under different conduits receive unknown frames. What makes sense to 
>>> me is,
>>> if there are multiple CPU ports being used, forward the unknown 
>>> frames to
>>> port 6. This is already the case except the code runs twice. If not, 
>>> set it
>>> to whatever 'int port' is, which is the default behaviour already.
>>>
>>> [0] 
>>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/drivers/net/dsa/mt7530.c#n1005
>>
>> I suspect you may not have run sufficient tests. When there are 2 CPU
>> ports, both of them should be candidates for flooding unknown traffic.
>> Don't worry, software won't see duplicates, because the user <-> CPU port
>> affinity setting should restrict forwarding of the flooded frames to a
>> single CPU port.
>>
>> You might be confused by several things about this:
>>
>>     /* Disable flooding by default */
>>     mt7530_rmw(priv, MT7530_MFC, BC_FFP_MASK | UNM_FFP_MASK | 
>> UNU_FFP_MASK,
>>            BC_FFP(BIT(port)) | UNM_FFP(BIT(port)) | UNU_FFP(BIT(port)));
>>
>> First, the comment. It means to say: "disable flooding on all ports
>> except for this CPU port".
>>
>> Then, the fact that it runs twice, unsetting flooding for the first CPU
>> port (5) and setting it for the second one (6). There should be no
>> hardware limitation there. Both BIT(5) and BIT(6) could be part of the
>> flood mask without any problem.
>>
>> Perhaps the issue is that MT7530_MFC should have been written to all
>> zeroes as a first step, and then, every mt753x_cpu_port_enable() call
>> enables flooding to the "int port" argument.
> 
> Thanks a lot! I'm just learning about the process of bit masking. If I 
> understand correctly, masks for BC, UNM, and UNU are defined to have 8 
> bits.
> 
> UNU_FFP(~0) means that all bits are set to 1. I am supposed to first 
> clear them, then set bit 5 and 6 to 1.
> 
> Before mt753x_cpu_port_enable():
> 
> mt7530_rmw(priv, MT7530_MFC, BC_FFP_MASK | UNM_FFP_MASK | UNU_FFP_MASK, 0);
> 
> For every mt753x_cpu_port_enable():
> 
> mt7530_rmw(priv, MT7530_MFC, BC_FFP_MASK | UNM_FFP_MASK | UNU_FFP_MASK,
>         (BC_FFP(BIT(port))) & BC_FFP_MASK | (UNM_FFP(BIT(port))) &
>         UNM_FFP_MASK | (UNU_FFP(BIT(port))) & UNU_FFP_MASK);

This is the final diff I'm going to submit to net.

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 4d5c5820e461..cc5fa641b026 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1008,9 +1008,9 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
  	mt7530_write(priv, MT7530_PVC_P(port),
  		     PORT_SPEC_TAG);
  
-	/* Disable flooding by default */
-	mt7530_rmw(priv, MT7530_MFC, BC_FFP_MASK | UNM_FFP_MASK | UNU_FFP_MASK,
-		   BC_FFP(BIT(port)) | UNM_FFP(BIT(port)) | UNU_FFP(BIT(port)));
+	/* Enable flooding on the CPU port */
+	mt7530_set(priv, MT7530_MFC, BC_FFP(BIT(port)) | UNM_FFP(BIT(port)) |
+		   UNU_FFP(BIT(port)));
  
  	/* Set CPU port number */
  	if (priv->id == ID_MT7621)
@@ -2225,6 +2225,10 @@ mt7530_setup(struct dsa_switch *ds)
  		/* Disable learning by default on all ports */
  		mt7530_set(priv, MT7530_PSC_P(i), SA_DIS);
  
+		/* Disable flooding on all ports */
+		mt7530_clear(priv, MT7530_MFC, BC_FFP(BIT(i)) | UNM_FFP(BIT(i)) |
+			     UNU_FFP(BIT(i)));
+
  		if (dsa_is_cpu_port(ds, i)) {
  			ret = mt753x_cpu_port_enable(ds, i);
  			if (ret)
@@ -2412,6 +2416,10 @@ mt7531_setup(struct dsa_switch *ds)
  
  		mt7530_set(priv, MT7531_DBG_CNT(i), MT7531_DIS_CLR);
  
+		/* Disable flooding on all ports */
+		mt7530_clear(priv, MT7530_MFC, BC_FFP(BIT(i)) | UNM_FFP(BIT(i)) |
+			     UNU_FFP(BIT(i)));
+
  		if (dsa_is_cpu_port(ds, i)) {
  			ret = mt753x_cpu_port_enable(ds, i);
  			if (ret)

[0]
https://drive.google.com/file/d/1aVdQz3rbKWjkvdga8-LQ-VFXjmHR8yf9/view?usp=sharing
[1]
https://github.com/vschagen/documents/blob/main/MT7621_ProgrammingGuide_GSW_v0_3.pdf

Arınç
