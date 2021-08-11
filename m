Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DADF3E925D
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 15:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbhHKNQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 09:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbhHKNQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 09:16:51 -0400
Received: from tulum.helixd.com (unknown [IPv6:2604:4500:0:9::b0fd:3c92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5B3C061765
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 06:16:28 -0700 (PDT)
Received: from [IPv6:2600:8801:8800:12e8:bca6:fa07:303d:4438] (unknown [IPv6:2600:8801:8800:12e8:bca6:fa07:303d:4438])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        (Authenticated sender: dalcocer@helixd.com)
        by tulum.helixd.com (Postfix) with ESMTPSA id 211692078D;
        Wed, 11 Aug 2021 06:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tulum.helixd.com;
        s=mail; t=1628687786;
        bh=bc9i0B74Hq9sZyLe4NMK2HdDLylVecv7T32qXRY2/Pc=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=LBfyEORoJDB8LTpcQV9+k6NrM492awCvU1/2VAvFr+Lo5p77KbGQN/YBcUGw9Yz8R
         mDyCIFkqZh4yugFNq0gCOJ/e0sM39pDrO/FqodjAK8Pj4hL01mLO848605SMy1NTp7
         WPnQZbxM5Ah0Cy5+h2UFv1eO5Vuwi7UHEwAOqLms=
Subject: Re: Marvell switch port shows LOWERLAYERDOWN, ping fails
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <YQGgvj2e7dqrHDCc@lunn.ch>
 <59790fef-bf4a-17e5-4927-5f8d8a1645f7@helixd.com> <YQGu2r02XdMR5Ajp@lunn.ch>
 <11b81662-e9ce-591c-122a-af280f1e1f59@helixd.com>
 <fea36eed-eaff-4381-b2fd-628b60237aab@helixd.com>
 <de5758c6-4379-1b70-19ff-d6dd2b3ea269@helixd.com>
 <4902bb0e-87ad-3fa4-f7af-bbe7b43ad68f@helixd.com> <YQ7Xo3UII/1Gw/G1@lunn.ch>
 <ac33ec5f-568e-e43c-5d58-48876a7d9b0d@helixd.com>
 <404e5b00-59ee-1165-4f7c-d0853c730354@helixd.com> <YRL6B3fh7IrLQZST@lunn.ch>
From:   Dario Alcocer <dalcocer@helixd.com>
Message-ID: <4d3f83bd-d3ee-a965-dc2d-6e6a615ab284@helixd.com>
Date:   Wed, 11 Aug 2021 06:16:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YRL6B3fh7IrLQZST@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/10/21 3:13 PM, Andrew Lunn wrote:
> On Tue, Aug 10, 2021 at 01:58:21PM -0700, Dario Alcocer wrote:
>> Well, I misread the schematic; the DSA ports are connected via four pins on
>> each of the MV88E6176 chips (S_RXP, S_RXN, S_TXP, S_TXN):
>>
>> S_RXP (PHY 0x1E) <---> S_TXP (PHY 0x1A)
>> S_RXN (PHY 0x1E) <---> S_TXN (PHY 0x1A)
>> S_TXP (PHY 0x1E) <---> S_RXP (PHY 0x1A)
>> S_TXN (PHY 0x1E) <---> S_RXN (PHY 0x1A)
>>
>> As you mentioned before, 1G requires 4 pairs. Thus, it seems that phy-mode =
>> "1000base-x" and speed = <1000> cannot be used for the SERDES link.
> 
> You are mixing up the link from a MAC to a PHY, and from a PHY over a
> cable to another PHY.
> 
> An Ethernet cable has 4 pairs, and it is the PHYs job to generate and
> receive the signals over these four pairs. How those signals look is
> all part of the 802.3 standard, nothing you can configure.
> 
> There are a number of different ways you can connect a MAC to a PHY,
> or a MAC to another MAC. The generic name for this is MII, Media
> Independent Interface.  The number of copper tracks between the MAC
> and PHY varies. Gigabit MII has around 22 pins, here as Reduced
> Gigabit MII has 11 pins. And a SERDES 100Base-X only has 4 pins.
> 
> So 1000base-x is correct.

Ok, thanks for the explanation. I've put back 1000base-x for the DSA ports.

> I don't have the datasheet for the 6176, but i assume it is similar to
> the 6352. The SERDES can be connected to either port4 or port5. The
> S_SEL pin is used to configure this. For the 6352, S_SEL=1 means port
> 5. You can also configure the port to 100Base-FX or 1000Base-X/SGMII
> using the S_MODE pin. S_MODE=1 means 1000Base-X or SGMII.
> 
> The CMODE, or Config mode, the lowest nibble of the port status
> register, tells you what it is actually using. A value of 0xf means a
> copper PHY. 0x8 is 100Base-FX. 0x9 = 1000Base-X, 0x0a = SGMII.

Thanks for this information. It was the key that helped me finally get 
the SERDES link working.

The clue was that CMODE == 0x9 for 1000Base-X. I went back to look at 
the CMODE dumped for each port from mv88e6xxx_dump, and I noticed that 
port 5 had the lower nibble set to 0x9. It was then I realized I had 
specified the wrong DSA ports for the SERDES link.

I corrected the error in the DSA device-tree fragment:

@@ -67,10 +67,10 @@
                                          phy-handle = <&switch0phy2>;
                                  };

-                                switch0port4: port@4 {
-                                        reg = <4>;
+                                switch0port5: port@5 {
+                                        reg = <5>;
                                          phy-mode = "1000base-x";
-                                        link = <&switch1port4>;
+                                        link = <&switch1port5>;
                                          fixed-link {
                                                  speed = <1000>;
                                                  full-duplex;
@@ -112,9 +112,9 @@
                                          label = "dmz";
                                  };

-                                switch1port4: port@4 {
-                                        reg = <4>;
-                                        link = <&switch0port4>;
+                                switch1port5: port@5 {
+                                        reg = <5>;
+                                        link = <&switch0port5>;
                                          phy-mode = "1000base-x";
                                          fixed-link {
                                                  speed = <1000>;

This change is what finally allowed pings to work using the lan1 port.

The register dumps for both DSA ports now show traffic going across the 
SERDES link (note the non-zero value for "RX frame count"):

root@dali:~# mv88e6xxx_dump --port 5 mdio_bus/stmmac-0:1a
Using device <mdio_bus/stmmac-0:1a>
00 Port status                            0x0e09
       Pause Enabled                        0
       My Pause                             0
       802.3 PHY Detected                   0
       Link Status                          Up
       Duplex                               Full
       Speed                                1000 Mbps
       EEE Enabled                          0
       Transmitter Paused                   0
       Flow Control                         0
       Config Mode                          0x9
01 Physical control                       0x003e
       RGMII Receive Timing Control         Default
       RGMII Transmit Timing Control        Default
       200 BASE Mode                        100
       Flow Control's Forced value          0
       Force Flow Control                   0
       Link's Forced value                  Up
       Force Link                           1
       Duplex's Forced value                Full
       Force Duplex                         1
       Force Speed                          1000 Mbps
02 Jamming control                        0x0000
03 Switch ID                              0x1761
04 Port control                           0x053f
       Source Address Filtering controls    Disabled
       Egress Mode                          Unmodified
       Ingress & Egress Header Mode         0
       IGMP and MLD Snooping                1
       Frame Mode                           DSA
       VLAN Tunnel                          0
       TagIfBoth                            0
       Initial Priority assignment          Tag & IP Priority
       Egress Flooding mode                 Allow unknown DA
       Port State                           Forwarding
05 Port control 1                         0x8000
       Message Port                         1
       Trunk Port                           0
       Trunk ID                             0
       FID[11:4]                            0x000
06 Port base VLAN map                     0x005f
       FID[3:0]                             0x000
       VLANTable                            0 1 2 3 4 6
07 Def VLAN ID & Prio                     0x0000
       Default Priority                     0x0
       Force to use Default VID             0
       Default VLAN Identifier              0
08 Port control 2                         0x0080
       Force good FCS in the frame          0
       Jumbo Mode                           1522
       802.1QMode                           Disabled
       Discard Tagged Frames                0
       Discard Untagged Frames              0
       Map using DA hits                    1
       ARP Mirror enable                    0
       Egress Monitor Source Port           0
       Ingress Monitor Source Port          0
       Use Default Queue Priority           0
       Default Queue Priority               0x0
09 Egress rate control                    0x0001
0a Egress rate control 2                  0x0000
0b Port association vec                   0x0020
0c Port ATU control                       0x0000
0d Override                               0x0000
0e Policy control                         0x0000
0f Port ether type                        0x9100
10 In discard low                         0x0000
11 In discard high                        0x0000
12 In filtered                            0x0000
13 RX frame count                         0x01c5
14 Reserved                               0x0000
15 Reserved                               0x0000
16 LED control                            0x0033
17 Reserved                               0x0000
18 Tag remap low                          0x3210
19 Tag remap high                         0x7654
1a Reserved                               0x0000
1b Queue counters                         0x8000
1c Reserved                               0x0000
1d Reserved                               0x0000
1e Reserved                               0x0000
1f Reserved                               0x0000
root@dali:~# mv88e6xxx_dump --port 5 mdio_bus/stmmac-0:1e
Using device <mdio_bus/stmmac-0:1a>
00 Port status                            0x0e09
       Pause Enabled                        0
       My Pause                             0
       802.3 PHY Detected                   0
       Link Status                          Up
       Duplex                               Full
       Speed                                1000 Mbps
       EEE Enabled                          0
       Transmitter Paused                   0
       Flow Control                         0
       Config Mode                          0x9
01 Physical control                       0x003e
       RGMII Receive Timing Control         Default
       RGMII Transmit Timing Control        Default
       200 BASE Mode                        100
       Flow Control's Forced value          0
       Force Flow Control                   0
       Link's Forced value                  Up
       Force Link                           1
       Duplex's Forced value                Full
       Force Duplex                         1
       Force Speed                          1000 Mbps
02 Jamming control                        0x0000
03 Switch ID                              0x1761
04 Port control                           0x053f
       Source Address Filtering controls    Disabled
       Egress Mode                          Unmodified
       Ingress & Egress Header Mode         0
       IGMP and MLD Snooping                1
       Frame Mode                           DSA
       VLAN Tunnel                          0
       TagIfBoth                            0
       Initial Priority assignment          Tag & IP Priority
       Egress Flooding mode                 Allow unknown DA
       Port State                           Forwarding
05 Port control 1                         0x8000
       Message Port                         1
       Trunk Port                           0
       Trunk ID                             0
       FID[11:4]                            0x000
06 Port base VLAN map                     0x005f
       FID[3:0]                             0x000
       VLANTable                            0 1 2 3 4 6
07 Def VLAN ID & Prio                     0x0000
       Default Priority                     0x0
       Force to use Default VID             0
       Default VLAN Identifier              0
08 Port control 2                         0x0080
       Force good FCS in the frame          0
       Jumbo Mode                           1522
       802.1QMode                           Disabled
       Discard Tagged Frames                0
       Discard Untagged Frames              0
       Map using DA hits                    1
       ARP Mirror enable                    0
       Egress Monitor Source Port           0
       Ingress Monitor Source Port          0
       Use Default Queue Priority           0
       Default Queue Priority               0x0
09 Egress rate control                    0x0001
0a Egress rate control 2                  0x0000
0b Port association vec                   0x0020
0c Port ATU control                       0x0000
0d Override                               0x0000
0e Policy control                         0x0000
0f Port ether type                        0x9100
10 In discard low                         0x0000
11 In discard high                        0x0000
12 In filtered                            0x0000
13 RX frame count                         0x01c5
14 Reserved                               0x0000
15 Reserved                               0x0000
16 LED control                            0x0033
17 Reserved                               0x0000
18 Tag remap low                          0x3210
19 Tag remap high                         0x7654
1a Reserved                               0x0000
1b Queue counters                         0x8000
1c Reserved                               0x0000
1d Reserved                               0x0000
1e Reserved                               0x0000
1f Reserved                               0x0000

Many, many thanks for all the feedback that helped me finally solve this 
issue!
