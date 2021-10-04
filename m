Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 490D24210CA
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 15:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238813AbhJDN4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 09:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238064AbhJDN42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 09:56:28 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F446C061245
        for <netdev@vger.kernel.org>; Mon,  4 Oct 2021 06:45:54 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id y26so72121953lfa.11
        for <netdev@vger.kernel.org>; Mon, 04 Oct 2021 06:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=tjouHpw3FkuEh+ZZBkGOGSRNsz878h1Dp2aom11KaF0=;
        b=rA/9dNYYtVNHe8VcadGJzNBVoD5vLdp504rq1SljGHSQIUlOhUx5nHwe5IBaFQwkfZ
         LpNrRWJQXOuMjHk9624rbhu/iFHdwbqlsniDbh0mdojyD3pcPXHVcrLt9/PwPZJFE1RY
         ZX8JWryiMByWfnb8pVt0FYHuHyq7EJZ+wQKm0jMorRzN4ywkrhvFLWz/Fqp+Y5OYMeD9
         Nv16V2KVhOQDsdiQtTnKdtXV2X7ukolNP+AjVcIQ9P9bU+Hyo2Q2UPmOTcTUp7hnlkPi
         4ln+VL2yK4oT1k3JJqgBWEc9XGiqtGRaq+Xfq/MXjU+I2Lztm/QOad+kWkgtLNBGzHRy
         vCVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=tjouHpw3FkuEh+ZZBkGOGSRNsz878h1Dp2aom11KaF0=;
        b=VyjQyzL3n2vmzTreSFsjxGKy0IDmjRkDKVXF8KvhUgNWfWOuclrB+/teotrk12Njoc
         Yjs9lp8YCAVr1LnicpnqxWeD69mhq8BZxxOgO3Lb+28hhYd0wAKM+G2XjfI/XecEh83+
         vU34DjBz0JUdYcw11ooGoMfQepjCfZqCJhPmL50CsG6Nr513CSSBw6n6/fWP4i8fnFiP
         y7K9EeB5nkjVtGCZeAjI9769yYB2VSToAu+A7tKZp2xmqdauGmAMarz9AcYaN/K30QQh
         JHz4fTrXDqvrPfV81KUFcqSqJSRW9mffYHpeM7nC4rQXzdV3JZSZueIdjHAazbyDJ7iN
         HQug==
X-Gm-Message-State: AOAM531fdFgqxzGF6WVIkUBMNu18TavMOBh6iqe+NFvMD43sFDsbbyOa
        pXPwq9pmk1GM6JKGaFpX4xb3YQ==
X-Google-Smtp-Source: ABdhPJy1mffl8yME1JNvhIbi1HbG2MerAkoF2sL+lZiK3pQnLK1t18SC348Wk/cpVWMNPF5TJRtXPA==
X-Received: by 2002:a05:6512:31d4:: with SMTP id j20mr14079437lfe.135.1633355152803;
        Mon, 04 Oct 2021 06:45:52 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id a7sm472976lfl.125.2021.10.04.06.45.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 06:45:52 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net 1/2] net: dsa: tag_dsa: send packets with TX fwd
 offload from VLAN-unaware bridges using VID 0
In-Reply-To: <20211004111622.wgn3tssr2impfoys@skbuf>
References: <20211003222312.284175-1-vladimir.oltean@nxp.com>
 <20211003222312.284175-2-vladimir.oltean@nxp.com>
 <871r51m540.fsf@waldekranz.com> <20211004111622.wgn3tssr2impfoys@skbuf>
Date:   Mon, 04 Oct 2021 15:45:51 +0200
Message-ID: <87y278lx80.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 11:16, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> On Mon, Oct 04, 2021 at 12:55:27PM +0200, Tobias Waldekranz wrote:
>> On Mon, Oct 04, 2021 at 01:23, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>> > The present code is structured this way due to an incomplete thought
>> > process. In Documentation/networking/switchdev.rst we document that if a
>> > bridge is VLAN-unaware, then the presence or lack of a pvid on a bridge
>> > port (or on the bridge itself, for that matter) should not affect the
>> > ability to receive and transmit tagged or untagged packets.
>> >
>> > If the bridge on behalf of which we are sending this packet is
>> > VLAN-aware, then the TX forwarding offload API ensures that the skb will
>> > be VLAN-tagged (if the packet was sent by user space as untagged, it
>> > will get transmitted town to the driver as tagged with the bridge
>> > device's pvid). But if the bridge is VLAN-unaware, it may or may not be
>> > VLAN-tagged. In fact the logic to insert the bridge's PVID came from the
>> > idea that we should emulate what is being done in the VLAN-aware case.
>> > But we shouldn't.
>> 
>> IMO, the problem here stems from a discrepancy between LinkStreet
>> devices and the bridge, in how PVID is interpreted. For the bridge, when
>> VLAN filtering is disabled, ingressing traffic will be assigned to VID
>> 0. This is true even if the port's PVID is set. A mv88e6xxx port who's
>> QMode bits are set to 00 (802.1Q disabled) OTOH, will assign ingressing
>> traffic to its PVID.
>> 
>> So, in order to match the bridge's behavior, I think we need to rethink
>> how mv88e6xxx deals with non-filtering bridges. At first, one might be
>> tempted to simply leave the hardware PVID at 0. The PVT can then be used
>> to create isolation barriers between different bridges. ATU isolation is
>> really what kills this approach. Since there is no VLAN information in
>> the tag, there is no way to separate flows from different bridges into
>> different FIDs. This is the issue I discovered with the forward
>> offloading series.
>> 
>> > It appears that injecting packets using a VLAN ID of 0 serves the
>> > purpose of forwarding the packets to the egress port with no VLAN tag
>> > added or stripped by the hardware, and no filtering being performed.
>> > So we can simply remove the superfluous logic.
>> 
>> The problem with this patch is that return traffic from the CPU is sent
>> asymmetrically over a different VLAN, which in turn means that it will
>> perform the DA lookup in a different FID (0). The result is that traffic
>> does flow, but for the wrong reason. CPU -> port traffic is now flooded
>> as unknown unicast. An example:
>> 
>> (:aa / 10.1)
>>     br0
>>    /   \
>> sw0p1 sw0p2
>> \         /
>>  \       /
>>   \     /
>>     CPU
>>      |
>>   .--0--.
>>   | sw0 |
>>   '-1-2-'
>>     | '-- sniffer
>>     '---- host (:bb / 10.2)
>> 
>> br0 is created using the default settings. sw0 will have (among others)
>> static entries for the CPU:
>> 
>>     fid:0 addr:aa type:static port:0
>>     fid:1 addr:aa type:static port:0
>> 
>> 1. host sends an ARP for 10.1.
>> 
>> 2. sw0 will add this entry (since vlan_default_pvid is 1):
>> 
>>     fid:1 addr:bb type:age-7 port:1
>
> Well, that's precisely mv88e6xxx's problem, it should not make its
> ports' pvid inherit that of the bridge if the bridge is not VLAN aware.
> Other drivers inherit the bridge pvid only when VLAN filtering is turned
> on. See sja1105, ocelot, mt7530 at the very least. So the entry should
> have been learned in FID 0 here.
>
>> 3. CPU replies with a FORWARD (VID 0).
>> 
>> 4. sw0 will perform a DA lookup in FID 0, missing the entry learned in
>>    step 2.
>> 
>> 5. sw0 floods the frame as unknown unicast to both host and sniffer.
>> 
>> Conversely, if flooding of unknown unicast is disabled on sw0p1:
>> 
>>     $ bridge link set dev sw0p1 flood off
>> 
>> host can no longer communicate with the CPU.
>> 
>> As I alluded to in the forward offloading thread, I think we need to
>> move a scheme where:
>> 
>> 1. mv88e6xxx clears ds->configure_vlan_while_not_filtering.
>
> No, that's the wrong answer, nobody should clear ds->configure_vlan_while_not_filtering.
> mv88e6xxx should leave the pvid at zero* when joining a bridge that is
> not VLAN-aware. It should inherit the bridge pvid when that bridge
> becomes VLAN-aware, and it should reset the pvid to zero* when that
> bridge becomes VLAN-unaware.

Fair enough, even better!

>> 2. Assigns a free VID (and by extension a FID) in the VTU to each
>>    non-filtering bridge.
>
> *with the mention that the pvid of zero will only solve the first half
> of the problem, the discrepancy between the VLAN classified on xmit and
> the VLAN classified on rcv.
>
> It will not solve the ATU (FDB) isolation problem. But to solve the FDB
> isolation problem you need this:
> https://patchwork.kernel.org/project/netdevbpf/cover/20210818120150.892647-1-vladimir.oltean@nxp.com/
>
>> With this in place, the tagger could use the VID associated with the
>> egressing port's bridge in the tag.
>
> So the patch is not incorrect, it is incomplete. And there's nothing
> further I can add to the tagger logic to make it more complete, at least
> not now.
>
> That's one of the reasons why this is merely a "part 1".

Understood. But perhaps you could add the PVID-wrangling-patch you
suggested above to this series? That way we don't surprise any users on
stable by suddenly flooding traffic that used to be forwarded.
