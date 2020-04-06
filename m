Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 419151A002A
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 23:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgDFVdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 17:33:17 -0400
Received: from forward105o.mail.yandex.net ([37.140.190.183]:43130 "EHLO
        forward105o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726332AbgDFVdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 17:33:16 -0400
X-Greylist: delayed 496 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Apr 2020 17:33:13 EDT
Received: from mxback4g.mail.yandex.net (mxback4g.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:165])
        by forward105o.mail.yandex.net (Yandex) with ESMTP id 8EE32420056F;
        Tue,  7 Apr 2020 00:24:55 +0300 (MSK)
Received: from sas8-6bf5c5d991b2.qloud-c.yandex.net (sas8-6bf5c5d991b2.qloud-c.yandex.net [2a02:6b8:c1b:2a1f:0:640:6bf5:c5d9])
        by mxback4g.mail.yandex.net (mxback/Yandex) with ESMTP id rZ0X9GBYNE-Or8uJu58;
        Tue, 07 Apr 2020 00:24:55 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1586208295;
        bh=ylo4x/Q6roQpWhci6FeEVGlLIJ9AseZrMZBQ8493un8=;
        h=In-Reply-To:Cc:To:From:Subject:References:Date:Message-ID;
        b=q5DsCVxa3kgJ5LTNKC9BjvDoavjElVw+QAjQKBpRX3fvf98fGvCawyC1qxrI8bp72
         bExX/RRhxZYjW6rJtsxITX/NCavsnOxIJd1HRjepJYfl5Mm4t6BWjqlFLNt+EbNKsD
         LCoIixSv+H6fy6hAEPAi3+yfVMezeMUlwFOVey38=
Authentication-Results: mxback4g.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by sas8-6bf5c5d991b2.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id 1RRGL8wSk2-Op2OUFOY;
        Tue, 07 Apr 2020 00:24:52 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Message-ID: <82d244d47e0f0ddaa0a9aee4620fa9fc31fe98f7.camel@yandex.ru>
Subject: Re: [PATCH net-next] net: dsa: add GRO support via gro_cells
From:   Alexander Lobakin <bloodyreaper@yandex.ru>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Russell King <linux@armlinux.org.uk>,
        Microchip Linux Driver Support <unglinuxdriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mao Wenan <maowenan@huawei.com>
Date:   Tue, 07 Apr 2020 00:24:18 +0300
In-Reply-To: <c362ec65-ec84-52bb-a06e-d2ffad8bf52d@gmail.com>
References: <97a880e4-de7d-1f94-d35b-2635fbd8237e@gmail.com>
         <20200406191113.5983-1-bloodyreaper@yandex.ru>
         <c362ec65-ec84-52bb-a06e-d2ffad8bf52d@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 04/06/2020 at 13:16 -0700, Florian Fainelli wrote:
> On 4/6/2020 12:11 PM, Alexander Lobakin wrote:
> > 06.04.2020, 20:57, "Florian Fainelli" <f.fainelli@gmail.com>:
> > > On 4/6/2020 10:34 AM, Alexander Lobakin wrote:
> > > >  06.04.2020, 18:21, "Alexander Lobakin" <bloodyreaper@yandex.ru>:
> > > > >  06.04.2020, 17:48, "Andrew Lunn" <andrew@lunn.ch>:
> > > > > >   On Mon, Apr 06, 2020 at 01:59:10PM +0300, Alexander Lobakin wrote:
> > > > > > >    gro_cells lib is used by different encapsulating netdevices, such as
> > > > > > >    geneve, macsec, vxlan etc. to speed up decapsulated traffic processing.
> > > > > > >    CPU tag is a sort of "encapsulation", and we can use the same mechs to
> > > > > > >    greatly improve overall DSA performance.
> > > > > > >    skbs are passed to the GRO layer after removing CPU tags, so we don't
> > > > > > >    need any new packet offload types as it was firstly proposed by me in
> > > > > > >    the first GRO-over-DSA variant [1].
> > > > > > > 
> > > > > > >    The size of struct gro_cells is sizeof(void *), so hot struct
> > > > > > >    dsa_slave_priv becomes only 4/8 bytes bigger, and all critical fields
> > > > > > >    remain in one 32-byte cacheline.
> > > > > > >    The other positive side effect is that drivers for network devices
> > > > > > >    that can be shipped as CPU ports of DSA-driven switches can now use
> > > > > > >    napi_gro_frags() to pass skbs to kernel. Packets built that way are
> > > > > > >    completely non-linear and are likely being dropped without GRO.
> > > > > > > 
> > > > > > >    This was tested on to-be-mainlined-soon Ethernet driver that uses
> > > > > > >    napi_gro_frags(), and the overall performance was on par with the
> > > > > > >    variant from [1], sometimes even better due to minimal overhead.
> > > > > > >    net.core.gro_normal_batch tuning may help to push it to the limit
> > > > > > >    on particular setups and platforms.
> > > > > > > 
> > > > > > >    [1] https://lore.kernel.org/netdev/20191230143028.27313-1-alobakin@dlink.ru/
> > > > > > 
> > > > > >   Hi Alexander
> > > > > 
> > > > >  Hi Andrew!
> > > > > 
> > > > > >   net-next is closed at the moment. So you should of posted this with an
> > > > > >   RFC prefix.
> > > > > 
> > > > >  I saw that it's closed, but didn't knew about "RFC" tags for that period,
> > > > >  sorry.
> > > > > 
> > > > > >   The implementation looks nice and simple. But it would be nice to have
> > > > > >   some performance figures.
> > > > > 
> > > > >  I'll do, sure. I think I'll collect the stats with various main receiving
> > > > >  functions in Ethernet driver (napi_gro_frags(), napi_gro_receive(),
> > > > >  netif_receive_skb(), netif_receive_skb_list()), and with and without this
> > > > >  patch to make them as complete as possible.
> > > > 
> > > >  OK, so here we go.
> > > > 
> > > >  My device is 1.2 GHz 4-core MIPS32 R2. Ethernet controller representing
> > > >  the CPU port is capable of S/G, fraglists S/G, TSO4/6 and GSO UDP L4.
> > > >  Tests are performed through simple IPoE VLAN NAT forwarding setup
> > > >  (port0 <-> port1.218) with iperf3 in TCP mode.
> > > >  net.core.gro_normal_batch is always set to 16 as that value seems to be
> > > >  the most effective for that particular hardware and drivers.
> > > > 
> > > >  Packet counters on eth0 are the real numbers of ongoing frames. Counters
> > > >  on portX are pure-software and are updated inside networking stack.
> > > > 
> > > >  ---------------------------------------------------------------------
> > > > 
> > > >  netif_receive_skb() in Eth driver, no patch:
> > > > 
> > > >  [ ID] Interval Transfer Bitrate Retr
> > > >  [ 5] 0.00-120.01 sec 9.00 GBytes 644 Mbits/sec 413 sender
> > > >  [ 5] 0.00-120.00 sec 8.99 GBytes 644 Mbits/sec receiver
> > > > 
> > > >  eth0
> > > >  RX packets:7097731 errors:0 dropped:0 overruns:0 frame:0
> > > >  TX packets:7097702 errors:0 dropped:0 overruns:0 carrier:0
> > > > 
> > > >  port0
> > > >  RX packets:426050 errors:0 dropped:0 overruns:0 frame:0
> > > >  TX packets:6671829 errors:0 dropped:0 overruns:0 carrier:0
> > > > 
> > > >  port1
> > > >  RX packets:6671681 errors:0 dropped:0 overruns:0 carrier:0
> > > >  TX packets:425862 errors:0 dropped:0 overruns:0 carrier:0
> > > > 
> > > >  port1.218
> > > >  RX packets:6671677 errors:0 dropped:0 overruns:0 frame:0
> > > >  TX packets:425851 errors:0 dropped:0 overruns:0 carrier:0
> > > > 
> > > >  ---------------------------------------------------------------------
> > > > 
> > > >  netif_receive_skb_list() in Eth driver, no patch:
> > > > 
> > > >  [ ID] Interval Transfer Bitrate Retr
> > > >  [ 5] 0.00-120.01 sec 9.48 GBytes 679 Mbits/sec 129 sender
> > > >  [ 5] 0.00-120.00 sec 9.48 GBytes 679 Mbits/sec receiver
> > > > 
> > > >  eth0
> > > >  RX packets:7448098 errors:0 dropped:0 overruns:0 frame:0
> > > >  TX packets:7448073 errors:0 dropped:0 overruns:0 carrier:0
> > > > 
> > > >  port0
> > > >  RX packets:416115 errors:0 dropped:0 overruns:0 frame:0
> > > >  TX packets:7032121 errors:0 dropped:0 overruns:0 carrier:0
> > > > 
> > > >  port1
> > > >  RX packets:7031983 errors:0 dropped:0 overruns:0 frame:0
> > > >  TX packets:415941 errors:0 dropped:0 overruns:0 carrier:0
> > > > 
> > > >  port1.218
> > > >  RX packets:7031978 errors:0 dropped:0 overruns:0 frame:0
> > > >  TX packets:415930 errors:0 dropped:0 overruns:0 carrier:0
> > > > 
> > > >  ---------------------------------------------------------------------
> > > > 
> > > >  napi_gro_receive() in Eth driver, no patch:
> > > > 
> > > >  [ ID] Interval Transfer Bitrate Retr
> > > >  [ 5] 0.00-120.01 sec 10.0 GBytes 718 Mbits/sec 107 sender
> > > >  [ 5] 0.00-120.00 sec 10.0 GBytes 718 Mbits/sec receiver
> > > > 
> > > >  eth0
> > > >  RX packets:7868281 errors:0 dropped:0 overruns:0 frame:0
> > > >  TX packets:7868267 errors:0 dropped:0 overruns:0 carrier:0
> > > > 
> > > >  port0
> > > >  RX packets:429082 errors:0 dropped:0 overruns:0 frame:0
> > > >  TX packets:7439343 errors:0 dropped:0 overruns:0 carrier:0
> > > > 
> > > >  port1
> > > >  RX packets:7439199 errors:0 dropped:0 overruns:0 frame:0
> > > >  TX packets:428913 errors:0 dropped:0 overruns:0 carrier:0
> > > > 
> > > >  port1.218
> > > >  RX packets:7439195 errors:0 dropped:0 overruns:0 frame:0
> > > >  TX packets:428902 errors:0 dropped:0 overruns:0 carrier:0
> > > > 
> > > >  =====================================================================
> > > > 
> > > >  netif_receive_skb() in Eth driver + patch:
> > > > 
> > > >  [ ID] Interval Transfer Bitrate Retr
> > > >  [ 5] 0.00-120.01 sec 12.2 GBytes 870 Mbits/sec 2267 sender
> > > >  [ 5] 0.00-120.00 sec 12.2 GBytes 870 Mbits/sec receiver
> > > > 
> > > >  eth0
> > > >  RX packets:9474792 errors:0 dropped:0 overruns:0 frame:0
> > > >  TX packets:9474777 errors:0 dropped:0 overruns:0 carrier:0
> > > > 
> > > >  port0
> > > >  RX packets:455200 errors:0 dropped:0 overruns:0 frame:0
> > > >  TX packets:353288 errors:0 dropped:0 overruns:0 carrier:0
> > > > 
> > > >  port1
> > > >  RX packets:9019592 errors:0 dropped:0 overruns:0 frame:0
> > > >  TX packets:455035 errors:0 dropped:0 overruns:0 carrier:0
> > > > 
> > > >  port1.218
> > > >  RX packets:353144 errors:0 dropped:0 overruns:0 frame:0
> > > >  TX packets:455024 errors:0 dropped:0 overruns:0 carrier:0
> > > > 
> > > >  ---------------------------------------------------------------------
> > > > 
> > > >  netif_receive_skb_list() in Eth driver + patch:
> > > > 
> > > >  [ ID] Interval Transfer Bitrate Retr
> > > >  [ 5] 0.00-120.01 sec 11.6 GBytes 827 Mbits/sec 2224 sender
> > > >  [ 5] 0.00-120.00 sec 11.5 GBytes 827 Mbits/sec receiver
> > > > 
> > > >  eth0
> > > >  RX packets:8981651 errors:0 dropped:0 overruns:0 frame:0
> > > >  TX packets:898187 errors:0 dropped:0 overruns:0 carrier:0
> > > > 
> > > >  port0
> > > >  RX packets:436159 errors:0 dropped:0 overruns:0 frame:0
> > > >  TX packets:335665 errors:0 dropped:0 overruns:0 carrier:0
> > > > 
> > > >  port1
> > > >  RX packets:8545492 errors:0 dropped:0 overruns:0 frame:0
> > > >  TX packets:436071 errors:0 dropped:0 overruns:0 carrier:0
> > > > 
> > > >  port1.218
> > > >  RX packets:335593 errors:0 dropped:0 overruns:0 frame:0
> > > >  TX packets:436065 errors:0 dropped:0 overruns:0 carrier:0
> > > > 
> > > >  -----------------------------------------------------------
> > > > 
> > > >  napi_gro_receive() in Eth driver + patch:
> > > > 
> > > >  [ ID] Interval Transfer Bitrate Retr
> > > >  [ 5] 0.00-120.01 sec 11.8 GBytes 855 Mbits/sec 122 sender
> > > >  [ 5] 0.00-120.00 sec 11.8 GBytes 855 Mbits/sec receiver
> > > > 
> > > >  eth0
> > > >  RX packets:9292214 errors:0 dropped:0 overruns:0 frame:0
> > > >  TX packets:9292190 errors:0 dropped:0 overruns:0 carrier:0
> > > > 
> > > >  port0
> > > >  RX packets:438516 errors:0 dropped:0 overruns:0 frame:0
> > > >  TX packets:347236 errors:0 dropped:0 overruns:0 carrier:0
> > > > 
> > > >  port1
> > > >  RX packets:8853698 errors:0 dropped:0 overruns:0 frame:0
> > > >  TX packets:438331 errors:0 dropped:0 overruns:0 carrier:0
> > > > 
> > > >  port1.218
> > > >  RX packets:347082 errors:0 dropped:0 overruns:0 frame:0
> > > >  TX packets:438320 errors:0 dropped:0 overruns:0 carrier:0
> > > > 
> > > >  -----------------------------------------------------------
> > > > 
> > > >  The main goal is achieved: we have about 100-200 Mbps of performance
> > > >  boost while in-stack skbs are greatly reduced from ~8-9 millions to
> > > >  ~350000 (compare port0 TX and port1 RX without patch and with it).
> > > 
> > > And the number of TCP retries is also lower, which likely means that we
> > > are making better use of the flow control built into the hardware/driver
> > > here?
> > > 
> > > BTW do you know why you have so many retries though? It sounds like your
> > > flow control is missing a few edge cases, or that you have an incorrect
> > > configuration of your TX admission queue.
> > 
> > Well, I have the same question TBH. All these ~1.5 years that I'm
> > working on these switches I have pretty chaotic number of TCP
> > retransmissions each time I change something in the code. They are
> > less likely to happen when the average CPU load is lower, but ~100
> > is the best result I ever got.
> > Seems like I should stop trying to push software throughput to
> > the max for a while and pay more attention to this and to hardware
> > configuration instead and check if I miss something :) 
> 
> I have had to debug such a problem on some of our systems recently and
> it came down to being a couple of things for those systems:
> 
> - as a receiver, we could create fast re-transmissions on the sender
> side because of packet loss which was because the switch is able to push
> packets faster than the DSA master being able to write them to DRAM. One
> way to work around this is to clock the Ethernet MAC higher, at the cost
> of power consumption.
> 
> - as a sender, we could have fast re-transmissions when we were
> ourselves a "fast" CPU (1.7GHz or higher for Gigabit throughput), that
> part is still being root caused, but I think it comes down to flow
> control being incorrectly set-up in hardware, which means you could lose
> packets between your ndo_start_xmit() and not having the software TXQ
> assert XON/XOFF properly
> 
> So in both cases, packet loss is responsible for those fast
> re-transmissions, but they are barely observable (case #1 was, since the
> switch port counter did not match the Ethernet MAC MIB counters) since
> you have a black hole effect.

Thank you for so detailed response! I suppose there might be both of
these on my system, I'll have a look at this soon.

