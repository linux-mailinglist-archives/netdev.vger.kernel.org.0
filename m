Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E148168B00B
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 14:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbjBENtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 08:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjBENtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 08:49:24 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1A51B32A;
        Sun,  5 Feb 2023 05:49:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1675604935;
        bh=sh2QK16ajiIUZ6sLRB8xaX+Lgaf861SAzsVejT9xz+I=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=KcJMHlzX3R8SjCCXgm78d8voqX09aSkxNgCFlBRxKfmGXRfxTt6oqz6PvQH1brKEj
         VuhhutKNzPdJjeCW9pTSaVOrht3k+9J1XE04nQIVZvMuEjT/KAh0akJGMh1zpqd/CE
         qAHCtvTTI3/6U2FqDtooxfncGcj3blA3GRd/BHUjrYdPClw4BEPF+Kh5xmES9pglEH
         x3JlF+Rz05AWuucUsazS/kBYtiMKriIBQUHAEvNIdf6w7Yy3+o/OGG55CertQPgJcE
         VeaD8ugb3/klDqtxQ/CTbZfoI9NHduiItb5oYJyxO3hOpvrr9HIrEfwmuEH9Ctpra9
         q7MupmA2FfsXA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [80.245.77.40] ([80.245.77.40]) by web-mail.gmx.net
 (3c-app-gmx-bs34.server.lan [172.19.170.86]) (via HTTP); Sun, 5 Feb 2023
 14:48:55 +0100
MIME-Version: 1.0
Message-ID: <trinity-757008e9-a0a8-4d44-8b0a-53efa718218e-1675604935206@3c-app-gmx-bs34>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>
Subject: Aw: Re: [BUG] vlan-aware bridge breaks vlan on another port on same
 gmac
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 5 Feb 2023 14:48:55 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <trinity-4103b9e0-48e7-4de5-8757-21670a613f64-1675182218246@3c-app-gmx-bs58>
References: <trinity-e6294d28-636c-4c40-bb8b-b523521b00be-1674233135062@3c-app-gmx-bs36>
 <20230120172132.rfo3kf4fmkxtw4cl@skbuf>
 <trinity-b0df6ff8-cceb-4aa5-a26f-41bc04dc289c-1674303103108@3c-app-gmx-bap60>
 <20230121122223.3kfcwxqtqm3b6po5@skbuf>
 <trinity-7c2af652-d3f8-4086-ba12-85cd18cd6a1a-1674304362789@3c-app-gmx-bap60>
 <20230121133549.vibz2infg5jwupdc@skbuf>
 <trinity-cbf3ad23-15c0-4c77-828b-94c76c1785a1-1674310370120@3c-app-gmx-bap60>
 <20230130125813.asx5qtm6ttuwdobo@skbuf>
 <trinity-4103b9e0-48e7-4de5-8757-21670a613f64-1675182218246@3c-app-gmx-bs58>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:i9+kEGc2y10RVtdALC/xZZssnriEBF6wVa+EtPjQIreNdNdozAPjre4Xv+Ec7Iyk7ydSx
 wxl7Q8JSNDBNXILO9vqadmACZNnwgzIt8UoMyVWTLz3bYBz8PtLs57OugiHtepfUV4EwIZq/WDYA
 HXetFjsruxTwVtoSJrbAibh0CekUBZRrHdbgAkVirBzfvAdqZI0vL15HJyTSTneHgjckptYp06bP
 f96vJZoUCv9hGVHvIT+22rRwRAaE8nFsFmxfGqa23LdrK51k5pobqA+LZY5IZ0DmgvhrgPTs0vlS
 ks=
UI-OutboundReport: notjunk:1;M01:P0:efn2t2RjW/A=;ZWZ6kchknbt+Py7TnVTAMZ607vh
 kR7/lYhMaGoCBQzdkVYm2Zw3s9McyQHXPnhN5Q+OttbWm+YlIB7lZ/ytiBC94NFZBnpv3illw
 i/QWjbhNdfsImSovXPubG+7IFlKi/MBhbmWnutj1/5vH2CbgoZ2ZZ4xlLuQY0+1jR67Mh/Hzi
 iTEaACrd0Xw4FdB0Kl90qypnFI5fjoTXay1pp8WSSeWLCq1aRxXiVHfYeR4ARZCYxjIPogdWO
 vh7V3anz86QmUr6fx9eqwhF3ko/tusPtbw7irj7Rqae9lcJygHjmoLLS8NIx0B1DF4IZ3HX5f
 g2mz+QiXpl3QC1ZiWY25FK3MIiauA7jojUI19eHIDF+hakQ7UpHQKPWJlq7s8Rx0SRbpS4bpz
 +Qw0bt4sK8LqKfcceEecZ9TtwPOfo6gwXMU8DQkLvDgBHh6IFuX0ljxB4VkQwD/4I+albLA5h
 ONcYWYvT8P11+djj0DN0UerbXsl1Bte1qTHDVuT90B1QP2hLWSO2zcFnGaJD4dudwKTAFowrq
 xnaskuX27zdF5eUoAasUzMdcn0aLAq/hWdLCQVdvV6F8B2BMYcjRxSYBCmtdNDq8fGP1YcVxM
 48NchBkBBD5RqSUqu6wMCGQVCsWUuGc9fd5ylPeHESD748Ek3hQ0J347BFbEn0aU++cnoG8r4
 8gNny3Jq2QsxU9b+FHHBvd4/0voH/rabz8D874AFW7yZ92o3FPIgP8k3k2JDSeHkCZG7iwoUS
 OPYprVEcsIn5XAIB12sDUagrAIbgr3vPGaEnZAlguF1fKQgtPiAAvAvMszchnEb9WiWKeCF9p
 FmHOjmG3+Kv+gH0V7V76F+pgGjYfx8yoFcRA04pqnQV+M=
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

sorry for the delay, i'm very busy recently :(

noticed that i missed 2 commands ("bridge vlan add vid ..." below) when te=
sting the vlan-aware bridge...now both ports are working with vlan-tagging=
...the one inside (lan0) the bridge (lanbr0) and the one outside (wan).

BRIDGE=3Dlanbr0
netif=3Dlan0
vid=3D500
#ip link add name ${BRIDGE} type bridge
ip link add name ${BRIDGE} type bridge vlan_filtering 1 vlan_default_pvid =
1
ip link set ${BRIDGE} up
ip link set $netif master ${BRIDGE}
ip link set $netif up
bridge vlan add vid $vid dev ${BRIDGE} self
bridge vlan add vid $vid dev $netif

#extract vlan from bridge to own netdev
ip link add link ${BRIDGE} name vlan$vid type vlan id $vid
ip a a 192.168.110.5/24 dev vlan$vid
ip link set vlan$vid up

btw can i see somehow if a bridge is vlan-aware (the flag itself)..."bridg=
e vlan" command also lists non-vlan-aware bridges with vlan-id "1 pvid egr=
ess untagged"

so vladimir your last patch works well, thx for it. you can add my tested-=
by when upstreaming

regards Frank


> Gesendet: Dienstag, 31. Januar 2023 um 17:23 Uhr
> Von: "Frank Wunderlich" <frank-w@public-files.de>
> An: "Vladimir Oltean" <olteanv@gmail.com>
> Cc: "Andrew Lunn" <andrew@lunn.ch>, "Florian Fainelli" <f.fainelli@gmail=
.com>, "David S. Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@g=
oogle.com>, "Jakub Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redh=
at.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, "Landen Cha=
o" <Landen.Chao@mediatek.com>, "Sean Wang" <sean.wang@mediatek.com>, "DENG=
 Qingfang" <dqfext@gmail.com>, "Matthias Brugger" <matthias.bgg@gmail.com>=
, "Daniel Golle" <daniel@makrotopia.org>
> Betreff: Aw: Re: [BUG] vlan-aware bridge breaks vlan on another port on =
same gmac
>
> Hi Vladimir,
>
>
> > Gesendet: Montag, 30. Januar 2023 um 13:58 Uhr
> > Von: "Vladimir Oltean" <olteanv@gmail.com>
> > Hi Frank,
> > Sorry for the delay and thanks again for testing.
> >
> > I simply didn't have time to sit down with the hardware documentation
> > and (re)understand the concepts governing this switch.
>
> no problem, same here...not have every day time to dive into it :)
>
> > I now have the patch below which should have everything working. Would
> > you mind testing it?
>
> thanks for your Patch, but unfortunately it looks like does not change b=
ehaviour (have reverted all prevously applied patches,
> only have felix series in).
>
> i can ping over software-vlan on wan-port (and see tagged packets on oth=
er side), till the point i setup the vlan-aware bridge over lan-ports. pin=
g works some time (imho till arp-cache is cleared) and i see untagged pack=
ets leaving wan-port (seen on other end) which should be tagged (wan.110).
>
> and before anything ask: yes, i have set different mac to wan-port (and =
its vlan-interfaces) and lanbr0
>
> 15: lanbr0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue s=
tate DOWN group default qlen 1000
>     link/ether 96:3f:c5:84:65:f0 brd ff:ff:ff:ff:ff:ff
> 17: wan.140@wan: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueu=
e state UP group default qlen 1000
>     link/ether 02:11:02:03:01:40 brd ff:ff:ff:ff:ff:ff
>     inet 192.168.140.1/24 brd 192.168.140.255 scope global wan.140
>        valid_lft forever preferred_lft forever
>     inet6 fe80::11:2ff:fe03:140/64 scope link
>        valid_lft forever preferred_lft forever
> 18: wan.110@wan: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueu=
e state UP group default qlen 1000
>     link/ether 02:11:02:03:01:10 brd ff:ff:ff:ff:ff:ff
>     inet 192.168.110.1/24 brd 192.168.110.255 scope global wan.110
>        valid_lft forever preferred_lft forever
>     inet6 fe80::11:2ff:fe03:110/64 scope link
>        valid_lft forever preferred_lft forever
>
> have not yet defined any vlans in the bridge...only set vlan_awareness..=
.maybe i need to add the wan-vlan
> to the lan bridge too to pass filtering?
>
> i'm unsure if tcpdump on the host interface should see vlan-traffic too =
(but do not show the vlan itself)...
> in working state i see icmp in both tcpdump modes (pinging the full time=
 without the bridge enabled only
> changed tcpdump on the other side):
>
> # tcpdump -nni lanbr0 | grep '\.110\.'
>
> 17:13:36.071047 IP 192.168.110.1 > 192.168.110.3: ICMP echo request, id =
1617, seq 47, length 64
> 17:13:36.071290 IP 192.168.110.3 > 192.168.110.1: ICMP echo reply, id 16=
17, seq 47, length 64
>
> and
>
> tcpdump -nni lanbr0 -e vlan | grep '\.110\.'
>
> 17:16:35.032417 02:11:02:03:01:10 > 08:02:00:00:00:10, ethertype 802.1Q =
(0x8100), length 102: vlan 110, p 0, ethertype IPv4, 192.168.110.1 > 192.1=
68.110.3: ICMP echo request, id 1617, seq 219, length 64
> 17:16:35.032609 08:02:00:00:00:10 > 02:11:02:03:01:10, ethertype 802.1Q =
(0x8100), length 102: vlan 110, p 0, ethertype IPv4, 192.168.110.3 > 192.1=
68.110.1: ICMP echo reply, id 1617, seq 219, length 64
>
> after the vlan_aware bridge goes up i see packets in the non-vlan-mode
>
> if needed here is my current codebase:
> https://github.com/frank-w/BPI-Router-Linux/commits/6.2-rc
>
> regards Frank
