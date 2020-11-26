Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E49A32C59A2
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 17:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391568AbgKZQyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 11:54:35 -0500
Received: from mailout07.rmx.de ([94.199.90.95]:53362 "EHLO mailout07.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391465AbgKZQye (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Nov 2020 11:54:34 -0500
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout07.rmx.de (Postfix) with ESMTPS id 4ChkPc1vV0zBwxF;
        Thu, 26 Nov 2020 17:54:28 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4ChkPM3pMvz2xdT;
        Thu, 26 Nov 2020 17:54:15 +0100 (CET)
Received: from n95hx1g2.localnet (192.168.54.88) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Thu, 26 Nov
 2020 17:53:14 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     <Tristram.Ha@microchip.com>
CC:     <olteanv@gmail.com>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <richardcochran@gmail.com>, <robh+dt@kernel.org>,
        <vivien.didelot@gmail.com>, <davem@davemloft.net>,
        <kurt.kanzenbach@linutronix.de>, <george.mccollister@gmail.com>,
        <marex@denx.de>, <helmut.grohne@intenta.de>,
        <pbarker@konsulko.com>, <Codrin.Ciubotariu@microchip.com>,
        <Woojung.Huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3 00/12] net: dsa: microchip: PTP support for KSZ956x
Date:   Thu, 26 Nov 2020 17:53:07 +0100
Message-ID: <12878838.xADNQ6XqJ4@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <3569829.EPWo3g8d0Q@n95hx1g2>
References: <20201118203013.5077-1-ceggers@arri.de> <BYAPR11MB35582F880B533EB2EE0CDD1DECE00@BYAPR11MB3558.namprd11.prod.outlook.com> <3569829.EPWo3g8d0Q@n95hx1g2>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.88]
X-RMX-ID: 20201126-175415-4ChkPM3pMvz2xdT-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Microchip,

as ACL based blocking of PTP traffic seems not to work, I tried to install MAC
based static lookup rules on the switch I successfully managed to block other
non-PTP traffic, but for PTP the lookup table entry (see below) seems not to
work. Incoming SYNC messages on port are still forwarded to port 2.

The table entry is based on the multicast MAC used for PTP. With PTP domains!=0
there could be 128 possible MAC addresses that needs to blocked (but the switch
has only 16 entries in the static table). Is there any way to block the whole
PTP multicast address range (01:00:5E:00:01:81-01:00:5E:00:01:ff)? The data sheet
mentions that the static address table can be used for multicast addresses,
so there should be a way.

Alternatively, is there a hidden "disable TC" setting which disables the
transparent clock entirely?

regards
Christian

        Look-up Tables
        ALU_STAT_CTL 00000001  TABLE_INDEX       0       START_FINISH   idle             TABLE_SELECT Static Address
                               ACTION     read

        Static Address Table
        ALU_VAL_A    80000000  VALID      valid            SRC_FILTER     disabled       DST_FILTER   disabled
                               PRIORITY             0      MSTP                     0
        ALU_VAL_B    80000000  OVERRIDE   enabled          USE_FID        disabled
                               PRT3_FWD   disabled         PRT2_FWD       disabled       PRT1_FWD     disabled
        ALU_VAL_C    00000100  FID                  0      MAC_0_1              01:00
        ALU_VAL_D    5E000181  MAC_2_5    5E:00:01:81


On Wednesday, 25 November 2020, 22:08:39 CET, Christian Eggers wrote:
> I need some help from Microchip, please read below.
> 
> On Thursday, 19 November 2020, 19:51:15 CET, Tristram.Ha@microchip.com wrote:
> > There is one more requirement that is a little difficult to do.  The calculated peer delay
> > needs to be programmed in hardware register, but the regular PTP stack has no way to
> > send that command.  I think the driver has to do its own calculation by snooping on the
> > Pdelay_Req/Pdelay_Resp/Pdelay_Resp_Follow_Up messages.
> 
> In an (offline) discussion with Vladimir we discovered, that the KSZ switch
> behaves different as ptp4l expects: 
> 
> The KSZ switch forwards PTP (e.g. SYNC) messages in hardware (with updating
> the correction field). For this, the peer delays need be configured for each
> port.
> 
> ptp4l in turn expects to do the forwarding in software (for the P2P_TC clock
> configuration). For this, no hardware configuration of the peer delay is
> necessary. But due to limitations of currently available hardware, this TC
> forwarding is currently only supported for 2 step clocks, as a one-step clock
> would probably fully replace the originTimestamp field (similar as a BC, but
> not as a TC).
> 
> Vladimir suggested to configure an ACL in the KSZ switch to block forwarding
> of PTP messages between the user ports and to run ptp4l as BC. My idea is to
> simply block forwarding of UDP messages with destination ports 319+320 and
> L2 messages with the PTP Ether-Type.
> 
> I installed the following ACL (for UDP) in the Port ACL Access registers 0-F:
> |_0__1__2__3__4__5__6__7__8__9__A__B__C__D__E__F
> | 00 39 01 40 01 3F 42 22 00 00 00 60 00 00 00 01
> ACL index: 0
> 
> Match: 
> - MD=11 (L4)
> - ENB=10 (UDP ports)
> - S/D=0 (dst)
> - EQ=1 (equal)
> - MAX_PORT=320
> - MIN_PORT=319
> - PC=01 (min or max)
> - PRO=17 (UDP, don't care?)
> - FME=0 (disabled)
> 
> Action:
> - PM=0 (disabled)
> - P=0 (don't care)
> - RPE=0 (disabled)
> - RP=0 (don't care)
> - MM=11 (replace)
> - PORT_FWD_MAP: all ports to 0
> 
> Processing entry:
> - Ruleset=0x0001
> - FRN=0
> 
> Unfortunately, with this configuration PTP messages are still forwarded from
> port 1 to port 2. Although I was successful in blocking other communication
> (e.g. by MAC address), the matching rules above seem not to work. Is there an
> error in the ACL, or is forwarding of PTP traffic independent of configured
> ACLs?
> 
> regards
> Christian
> 




