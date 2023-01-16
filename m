Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 364AB66CF2B
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 19:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbjAPSxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 13:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233185AbjAPSxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 13:53:39 -0500
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD29044A6;
        Mon, 16 Jan 2023 10:53:36 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 30GIowO42108625
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 18:50:59 GMT
Received: from miraculix.mork.no ([IPv6:2a01:799:c9a:3202:549f:9f7a:c9d8:875b])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 30GIoqV62147959
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 19:50:52 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1673895053; bh=GI4ao4sIS51P0yzLbWC4zM2z/uCOO2WrWpqwELg5Z8E=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=GjoQl0sBJ10POVFRD+gITczT36cIbQByHgUbfh+KTqDWy7+I1y4LjJeOMaWq58grH
         OalXMOSa91tgm/Fw69zTfPI6r87LfjdPfFhzhyU7EKr/sdwIRrltAE65BS0W3bctxL
         lkYFlWs3w/AuXo0DGfw7rZMMVMmFUimuPSwGpwHk=
Received: (nullmailer pid 387010 invoked by uid 1000);
        Mon, 16 Jan 2023 18:50:52 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org,
        Alexander Couzens <lynxis@fe80.eu>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: mtk_sgmii: implement mtk_pcs_ops
Organization: m
References: <Y8VVa0zHk0nCwS1w@shell.armlinux.org.uk>
        <87h6wq35dn.fsf@miraculix.mork.no>
        <Y8VmSrjHTlllaDy2@shell.armlinux.org.uk>
        <87bkmy33ph.fsf@miraculix.mork.no>
        <Y8Vt9vfEa4w8HXHQ@shell.armlinux.org.uk>
        <875yd630cu.fsf@miraculix.mork.no> <871qnu2ztz.fsf@miraculix.mork.no>
        <Y8WNxAQ6C6NyUUn1@shell.armlinux.org.uk>
        <87pmbe1hu0.fsf@miraculix.mork.no> <87lem21hkq.fsf@miraculix.mork.no>
        <Y8WT6GwMqwi8rBe7@shell.armlinux.org.uk>
        <87a62i1ge4.fsf@miraculix.mork.no>
Date:   Mon, 16 Jan 2023 19:50:52 +0100
In-Reply-To: <87a62i1ge4.fsf@miraculix.mork.no> (=?utf-8?Q?=22Bj=C3=B8rn?=
 Mork"'s message of
        "Mon, 16 Jan 2023 19:30:27 +0100")
Message-ID: <875yd61fg3.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.7 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B8rn Mork <bjorn@mork.no> writes:
> "Russell King (Oracle)" <linux@armlinux.org.uk> writes:
>
>> That all looks fine. However, I'm running out of ideas.
>
> Thanks a lot for the effort in any case.  It's comforting that even the
> top experts can't figure out this one :-)
>
>
>> What we seem to have is:
>>
>> PHY:
>> VSPEC1_SGMII_CTRL =3D 0x34da
>> VSPEC1_SGMII_STAT =3D 0x000e
>>
>> The PHY is programmed to exchange SGMII with the host PCS, and it
>> says that it hasn't completed that exchange (bit 5 of STAT).
>>
>> The Mediatek PCS says:
>> BMCR =3D 0x1140		AN enabled
>> BMSR =3D 0x0008		AN capable
>> ADVERTISE =3D 0x0001	SGMII response (bit 14 is clear, hardware is
>> 			supposed to manage that bit)
>> LPA =3D 0x0000		SGMII received control word (nothing)
>> SGMII_MODE =3D 0x011b	SGMII mode, duplex AN, 1000M, Full duplex,
>> 			Remote fault disable
>>
>> which all looks like it should work - but it isn't.
>>
>> One last thing I can think of trying at the moment would be writing
>> the VSPEC1_SGMII_CTRL with 0x36da, setting bit 9 which allegedly
>> restarts the SGMII exchange. There's some comments in the PHY driver
>> that this may be needed - maybe it's necessary once the MAC's PCS
>> has been switched to SGMII mode.
>
>
> Tried that now.  Didn't change anything.  And still no packets.
>
> root@OpenWrt:/# mdio mdio-bus 6:30 raw 8
> 0x34da
> root@OpenWrt:/# mdio mdio-bus 6:30 raw 9
> 0x000e
> root@OpenWrt:/# mdio mdio-bus 6:30 raw 8 0x36da
> root@OpenWrt:/# mdio mdio-bus 6:30 raw 8
> 0x34da
> root@OpenWrt:/# mdio mdio-bus 6:30 raw 9
> 0x000e

And just as we were about to give up I got another datapoint.

Changed phy-mode and managed mode as follows in the device tree as a
last desperate attempt:

	mac@1 {
		compatible =3D "mediatek,eth-mac";
		reg =3D <1>;
		label =3D "wan";
//		phy-mode =3D "2500base-x";
		phy-mode =3D "sgmii";
		managed =3D "in-band-status";
		phy-handle =3D <&phy6>;
	};

Made things fail with 2.5G, as expected I guess. But this actually works
with 1G!

Except for an unexpected packet drop.  But at least there are packets
coming through at 1G now.  This is the remote end of the link:

ns-enp3s0# ethtool -s enp3s0 autoneg off speed 1000 duplex full
ns-enp3s0# ping  192.168.0.1
PING 192.168.0.1 (192.168.0.1) 56(84) bytes of data.
64 bytes from 192.168.0.1: icmp_seq=3D1 ttl=3D64 time=3D0.544 ms
64 bytes from 192.168.0.1: icmp_seq=3D3 ttl=3D64 time=3D0.283 ms
64 bytes from 192.168.0.1: icmp_seq=3D4 ttl=3D64 time=3D0.261 ms
64 bytes from 192.168.0.1: icmp_seq=3D5 ttl=3D64 time=3D0.295 ms
64 bytes from 192.168.0.1: icmp_seq=3D6 ttl=3D64 time=3D0.273 ms
64 bytes from 192.168.0.1: icmp_seq=3D7 ttl=3D64 time=3D0.290 ms
64 bytes from 192.168.0.1: icmp_seq=3D8 ttl=3D64 time=3D0.266 ms
64 bytes from 192.168.0.1: icmp_seq=3D9 ttl=3D64 time=3D0.269 ms
64 bytes from 192.168.0.1: icmp_seq=3D10 ttl=3D64 time=3D0.270 ms
64 bytes from 192.168.0.1: icmp_seq=3D11 ttl=3D64 time=3D0.261 ms
64 bytes from 192.168.0.1: icmp_seq=3D12 ttl=3D64 time=3D0.261 ms
64 bytes from 192.168.0.1: icmp_seq=3D13 ttl=3D64 time=3D0.266 ms
^C
--- 192.168.0.1 ping statistics ---
13 packets transmitted, 12 received, 7.69231% packet loss, time 12282ms
rtt min/avg/max/mdev =3D 0.261/0.294/0.544/0.075 ms
ns-enp3s0# ethtool enp3s0
Settings for enp3s0:
        Supported ports: [ TP ]
        Supported link modes:   100baseT/Full
                                1000baseT/Full
                                10000baseT/Full
                                2500baseT/Full
                                5000baseT/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  1000baseT/Full
        Advertised pause frame use: Symmetric
        Advertised auto-negotiation: No
        Advertised FEC modes: Not reported
        Speed: 1000Mb/s
        Duplex: Full
        Auto-negotiation: off
        Port: Twisted Pair
        PHYAD: 0
        Transceiver: internal
        MDI-X: Unknown
        Supports Wake-on: pg
        Wake-on: g
        Current message level: 0x00000005 (5)
                               drv link
        Link detected: yes
.

The MT7986 end looks like this:

root@OpenWrt:/# [   55.659413] mtk_pcs_get_state: bm=3D0x81140, adv=3D0x1a0
[   55.664380] mtk_pcs_get_state: bm=3D0x81140, adv=3D0x1a0
[   58.779924] mtk_pcs_get_state: bm=3D0x81140, adv=3D0x1a0
[   58.784884] mtk_pcs_get_state: bm=3D0x81140, adv=3D0x1a0
[   58.789841] mtk_sgmii_select_pcs: id=3D1
[   58.793581] mtk_pcs_config: interface=3D4
[   58.797399] offset:0 0x81140
[   58.797401] offset:4 0x4d544950
[   58.800273] offset:8 0x1a0
[   58.803397] offset:0x20 0x31120118
[   58.806089] forcing AN
[   58.811826] mtk_pcs_config: rgc3=3D0x0, advertise=3D0x1 (changed), link_=
timer=3D1600000,  sgm_mode=3D0x103, bmcr=3D0x1200, use_an=3D1
[   58.822759] mtk_pcs_restart_an
[   58.825800] mtk_pcs_get_state: bm=3D0x81140, adv=3D0xda014001
[   58.831184] mtk_pcs_get_state: bm=3D0x2c1140, adv=3D0xda014001
[   58.836649] mtk_pcs_link_up: interface=3D4
[   58.840559] offset:0 0xac1140
[   58.840561] offset:4 0x4d544950
[   58.843512] offset:8 0xda014001
[   58.846636] offset:0x20 0x3112011b
[   58.849780] mtk_soc_eth 15100000.ethernet wan: Link is Up - 1Gbps/Full -=
 flow control rx/tx
[   58.861521] IPv6: ADDRCONF(NETDEV_CHANGE): wan: link becomes ready
root@OpenWrt:/# ethtool wan
Settings for wan:
        Supported ports: [  ]
        Supported link modes:   10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
                                2500baseT/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
                                2500baseT/Full
        Advertised pause frame use: Symmetric Receive-only
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Link partner advertised link modes:  1000baseT/Full
        Link partner advertised pause frame use: Symmetric Receive-only
        Link partner advertised auto-negotiation: Yes
        Link partner advertised FEC modes: Not reported
        Speed: 1000Mb/s
        Duplex: Full
        Auto-negotiation: on
        master-slave cfg: preferred slave
        master-slave status: master
        Port: Twisted Pair
        PHYAD: 6
        Transceiver: external
        MDI-X: on (auto)
        Current message level: 0x000000ff (255)
                               drv probe link timer ifdown ifup rx_err tx_e=
rr
        Link detected: yes
root@OpenWrt:/# mdio mdio-bus 6:30 raw 8
0x34da
root@OpenWrt:/# mdio mdio-bus 6:30 raw 9
0x002e

And naturally 100M works too:

root@OpenWrt:/# [  528.859412] mtk_pcs_get_state: bm=3D0x2c1140, adv=3D0x5a=
014001
[  528.864908] mtk_soc_eth 15100000.ethernet wan: Link is Down
[  528.870513] mtk_pcs_get_state: bm=3D0x2c1140, adv=3D0x5a014001
[  528.875983] mtk_pcs_get_state: bm=3D0x2c1140, adv=3D0x5a014001
[  530.939756] mtk_pcs_get_state: bm=3D0x2c1140, adv=3D0xd6014001
[  530.945238] mtk_pcs_link_up: interface=3D4
[  530.949143] offset:0 0x2c1140
[  530.949145] offset:4 0x4d544950
[  530.952107] offset:8 0xd6014001
[  530.955232] offset:0x20 0x3112011b
[  530.958368] mtk_soc_eth 15100000.ethernet wan: Link is Up - 100Mbps/Full=
 - flow control rx/tx
root@OpenWrt:/# mdio mdio-bus 6:30 raw 8
0x34da
root@OpenWrt:/# mdio mdio-bus 6:30 raw 9
0x002d


Now, if we only could figure out what the difference is between this and
what we configure when the mode is changed from 2500base-x to sgmii.



Bj=C3=B8rn
