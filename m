Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4E683A43DC
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 16:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbhFKOOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 10:14:46 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:55162 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhFKOOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 10:14:45 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 15BECg8R105380;
        Fri, 11 Jun 2021 09:12:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1623420762;
        bh=iyppNXbBzmlI+Ah4mML7hB+/CjxQw85eWqJJe5YA+Os=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=RJ6m0UAyqdV/w/ERvOKL7sGG19am/JF4LBUdfIq4svoDS1PnBDg9VmbTUXnv74fb/
         lz+53P0Pcc2KUqqTXb48e5nKhWAs1YoiHZg2gGZFOPY76SPCn/uLKgl22joW4tFw2y
         DGsmC5ti4DrmzSx/3NgxjHufrVHsUqDU52bPXXQM=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 15BECgrq002939
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 11 Jun 2021 09:12:42 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Fri, 11
 Jun 2021 09:12:34 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Fri, 11 Jun 2021 09:12:34 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 15BECVeP112972;
        Fri, 11 Jun 2021 09:12:32 -0500
Subject: Re: Ethernet padding - ti_cpsw vs DSA tail tag
To:     Vladimir Oltean <olteanv@gmail.com>,
        Ben Hutchings <ben.hutchings@essensium.com>
CC:     <netdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <20210531124051.GA15218@cephalopod>
 <20210531142914.bfvcbhglqz55us6s@skbuf>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <beeec51d-268f-8fd3-6955-9031e62bad84@ti.com>
Date:   Fri, 11 Jun 2021 17:12:28 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210531142914.bfvcbhglqz55us6s@skbuf>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 31/05/2021 17:29, Vladimir Oltean wrote:
> Hi Ben,
> 
> On Mon, May 31, 2021 at 02:40:52PM +0200, Ben Hutchings wrote:
>> I'm working on a system that uses a TI Sitara SoC with one of its
>> Ethernet ports connected to the host port of a Microchip KSZ8795
>> switch.  I'm updating the kernel from 4.14.y to 5.10.y.  Currently I
>> am using the ti_cpsw driver, but it looks like the ti_cpsw_new driver
>> has the same issue.
>>
>> The Microchip switch expects a tail tag on ingress from the host port
>> to control which external port(s) to forward to.  This must appear
>> immediately before the frame checksum.  The DSA core correctly pads
>> outgoing skbs to at least 60 bytes before tag_ksz appends the tag.
>>
>> However, since commit 9421c9015047 ("net: ethernet: ti: cpsw: fix min
>> eth packet size"), the cpsw driver pads outgoing skbs to at least 64
>> bytes.  This means that in smaller packets the tag byte is no longer
>> at the tail.
>>
>> It's not obvious to me where this should be fixed.  Should drivers
>> that pad in ndo_start_xmit be aware of any tail tag that needs to be
>> moved?  Should DSA be aware that a lower driver has a minimum size >
>> 60 bytes?
> 
> These are good questions.
> 
> In principle, DSA needs a hint from the master driver for tail taggers
> to work properly. We should pad to ETH_ZLEN + <the hint value> before
> inserting the tail tag. This is for correctness, to ensure we do not
> operate in marginal conditions which are not guaranteed to work.
> 
> A naive approach would be to take the hint from master->min_mtu.
> However, the first issue that appears is that the dev->min_mtu value is
> not always set quite correctly.
> 
> The MTU in general measures the number of bytes in the L2 payload (i.e.
> not counting the Ethernet + VLAN header, nor FCS). The DSA tag is
> considered to be a part of the L2 payload from the perspective of a
> DSA-unaware master.
> 
> But ether_setup() sets up dev->min_mtu by default to ETH_MIN_MTU (68),
> which cites RFC791. This says:
> 
>      Every internet module must be able to forward a datagram of 68
>      octets without further fragmentation.  This is because an internet
>      header may be up to 60 octets, and the minimum fragment is 8 octets.
> 
> But many drivers simply don't set dev->min_mtu = 0, even if they support
> sending minimum-sized Ethernet frames. Many set dev->min_mtu to ETH_ZLEN,
> proving nothing except the fact that they don't understand that the
> Ethernet header should not be counted by the MTU anyway.
> 
> So to work with these drivers which leave dev->min_mtu = ETH_MIN_MTU, we
> would have to pad the packets in DSA to ETH_ZLEN + ETH_MIN_MTU. This is
> not quite ideal, so even if it would be the correct approach, a large
> amount of drivers would have to be converted to set dev->min_mtu = 0
> before we could consider switching to that and not have too many
> regressions.
> 
> Also, dev->min_mtu does not appear to have a very strict definition
> anywhere other than "Interface Minimum MTU value". My hopes were some
> guarantees along the lines of "if you try to send a packet with a
> smaller L2 payload than dev->mtu, the controller might pad the packet".
> But no luck with that, it seems.
> 
> Going to commit 9421c9015047, it looks like that took a shortcut for
> performance reasons, and omitted to check whether the skb is actually
> VLAN-tagged or not, and if egress untagging was requested or not.
> My understanding is that packets smaller than CPSW_MIN_PACKET_SIZE _can_
> be sent, it's only that the value was chosen (too) conservatively as
> VLAN_ETH_ZLEN.

It can. HW limit is ETH_ZLEN and issue fixed by referred commit happens only
for packets sent from Host to Ext. Port with vid un-tagged enabled.

> The cpsw driver might be able to check whether the packet
> is a VLAN tagged one by looking at skb->protocol, and choose the pad
> size dynamically. Although I can understand why Grygorii might not want
> to do that.

Yeah. It's pretty complicated as will require maintain list of untugged vlans and
analyze frame in driver (seems vlan info not provided by upper layer when packet reaches
driver and !NETIF_F_HW_VLAN_CTAG_TX). Internally we carry very simple patch which
allows to change it (but it's module parameter).

Posted patch for cpsw-switch [1] and think I'll just post revert for legacy cpsw.

> 
> The pitfall is that even if we declare the proper min_mtu value for
> every master driver, it would still not avoid padding in the cpsw case.
> This is because the reason cpsw pads is due to VLAN, but VLAN is not
> part of the L2 payload, so cpsw would still declare dev->min_mtu = 0 in
> spite of needing to pad.

Yah. all MTU staff is L3 specific.

> 
> The only honest solution might be to extend struct net_device and add a
> pad_size value somewhere in there. You might be able to find a hole with
> pahole or something, and it doesn't need to be larger than an u8 (for up
> to 255 bytes of padding). Then cpsw can set master->pad_size, and DSA
> can look at it for tail taggers.
> 

There are:
	unsigned int		mtu;
	unsigned short		needed_headroom;
	unsigned short		needed_tailroom;
	unsigned short		hard_header_len;
	unsigned int		min_mtu;
	unsigned int		max_mtu;
	unsigned char		min_header_len;

  *	@mtu:		Interface MTU value
  *	@min_mtu:	Interface Minimum MTU value
  *	@max_mtu:	Interface Maximum MTU value
  *	@hard_header_len: Maximum hardware header length.
  *	@min_header_len:  Minimum hardware header length
  *	@needed_headroom: Extra headroom the hardware may need, but not in all
  *			  cases can this be guaranteed
  *	@needed_tailroom: Extra tailroom the hardware may need, but not in all
  *			  cases can this be guaranteed. Some cases also use
  *			  LL_MAX_HEADER instead to allocate the skb

but none of them seems suitable as here we are talking about min Eth frame lengs.
Any way, even if decided to add smth. new - it need to be configuarble.

[1] https://patchwork.kernel.org/project/netdevbpf/patch/20210611132732.10690-1-grygorii.strashko@ti.com/
-- 
Best regards,
grygorii
