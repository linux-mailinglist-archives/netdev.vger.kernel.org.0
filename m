Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D86F19FDE4
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 21:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbgDFTLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 15:11:33 -0400
Received: from forward106p.mail.yandex.net ([77.88.28.109]:51202 "EHLO
        forward106p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725928AbgDFTLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 15:11:33 -0400
Received: from forward100q.mail.yandex.net (forward100q.mail.yandex.net [IPv6:2a02:6b8:c0e:4b:0:640:4012:bb97])
        by forward106p.mail.yandex.net (Yandex) with ESMTP id 345B01C80565;
        Mon,  6 Apr 2020 22:11:29 +0300 (MSK)
Received: from mxback1q.mail.yandex.net (mxback1q.mail.yandex.net [IPv6:2a02:6b8:c0e:39:0:640:25b3:aea5])
        by forward100q.mail.yandex.net (Yandex) with ESMTP id 2CF627080014;
        Mon,  6 Apr 2020 22:11:29 +0300 (MSK)
Received: from vla3-3dd1bd6927b2.qloud-c.yandex.net (vla3-3dd1bd6927b2.qloud-c.yandex.net [2a02:6b8:c15:350f:0:640:3dd1:bd69])
        by mxback1q.mail.yandex.net (mxback/Yandex) with ESMTP id 0kHgAgVLWR-BQDqE1Re;
        Mon, 06 Apr 2020 22:11:29 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1586200289;
        bh=1VcoKan0Z08qea+vCKDcuAyu+FVCyJzkg8zpty9cfcg=;
        h=In-Reply-To:Subject:To:From:Cc:References:Date:Message-Id;
        b=j5IYEJ58eWEoa2LGxsKqgjb2XpUqdflbq+AwspY1NbmxRtEZGVKyA3nvseEJKRW5O
         NUlt7yfpnPCfCTYike+KkIFjF/pEgu5ZIUZ5xeRA17tRtEc73Ga79Qk5YAipPtRiBD
         yKLFIkJv7cmkKoxwE6Ab+mDFO3xehUVyQAWacNH8=
Authentication-Results: mxback1q.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by vla3-3dd1bd6927b2.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id LMgrxo4Dm0-BO3m4D6W;
        Mon, 06 Apr 2020 22:11:26 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Alexander Lobakin <bloodyreaper@yandex.ru>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Alexander Lobakin <bloodyreaper@yandex.ru>,
        Andrew Lunn <andrew@lunn.ch>,
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
Subject: Re: [PATCH net-next] net: dsa: add GRO support via gro_cells
Date:   Mon,  6 Apr 2020 22:11:13 +0300
Message-Id: <20200406191113.5983-1-bloodyreaper@yandex.ru>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <97a880e4-de7d-1f94-d35b-2635fbd8237e@gmail.com>
References: <97a880e4-de7d-1f94-d35b-2635fbd8237e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

06.04.2020, 20:57, "Florian Fainelli" <f.fainelli@gmail.com>:
> On 4/6/2020 10:34 AM, Alexander Lobakin wrote:
>>  06.04.2020, 18:21, "Alexander Lobakin" <bloodyreaper@yandex.ru>:
>>>  06.04.2020, 17:48, "Andrew Lunn" <andrew@lunn.ch>:
>>>>   On Mon, Apr 06, 2020 at 01:59:10PM +0300, Alexander Lobakin wrote:
>>>>>    gro_cells lib is used by different encapsulating netdevices, such as
>>>>>    geneve, macsec, vxlan etc. to speed up decapsulated traffic processing.
>>>>>    CPU tag is a sort of "encapsulation", and we can use the same mechs to
>>>>>    greatly improve overall DSA performance.
>>>>>    skbs are passed to the GRO layer after removing CPU tags, so we don't
>>>>>    need any new packet offload types as it was firstly proposed by me in
>>>>>    the first GRO-over-DSA variant [1].
>>>>>
>>>>>    The size of struct gro_cells is sizeof(void *), so hot struct
>>>>>    dsa_slave_priv becomes only 4/8 bytes bigger, and all critical fields
>>>>>    remain in one 32-byte cacheline.
>>>>>    The other positive side effect is that drivers for network devices
>>>>>    that can be shipped as CPU ports of DSA-driven switches can now use
>>>>>    napi_gro_frags() to pass skbs to kernel. Packets built that way are
>>>>>    completely non-linear and are likely being dropped without GRO.
>>>>>
>>>>>    This was tested on to-be-mainlined-soon Ethernet driver that uses
>>>>>    napi_gro_frags(), and the overall performance was on par with the
>>>>>    variant from [1], sometimes even better due to minimal overhead.
>>>>>    net.core.gro_normal_batch tuning may help to push it to the limit
>>>>>    on particular setups and platforms.
>>>>>
>>>>>    [1] https://lore.kernel.org/netdev/20191230143028.27313-1-alobakin@dlink.ru/
>>>>
>>>>   Hi Alexander
>>>
>>>  Hi Andrew!
>>>
>>>>   net-next is closed at the moment. So you should of posted this with an
>>>>   RFC prefix.
>>>
>>>  I saw that it's closed, but didn't knew about "RFC" tags for that period,
>>>  sorry.
>>>
>>>>   The implementation looks nice and simple. But it would be nice to have
>>>>   some performance figures.
>>>
>>>  I'll do, sure. I think I'll collect the stats with various main receiving
>>>  functions in Ethernet driver (napi_gro_frags(), napi_gro_receive(),
>>>  netif_receive_skb(), netif_receive_skb_list()), and with and without this
>>>  patch to make them as complete as possible.
>>
>>  OK, so here we go.
>>
>>  My device is 1.2 GHz 4-core MIPS32 R2. Ethernet controller representing
>>  the CPU port is capable of S/G, fraglists S/G, TSO4/6 and GSO UDP L4.
>>  Tests are performed through simple IPoE VLAN NAT forwarding setup
>>  (port0 <-> port1.218) with iperf3 in TCP mode.
>>  net.core.gro_normal_batch is always set to 16 as that value seems to be
>>  the most effective for that particular hardware and drivers.
>>
>>  Packet counters on eth0 are the real numbers of ongoing frames. Counters
>>  on portX are pure-software and are updated inside networking stack.
>>
>>  ---------------------------------------------------------------------
>>
>>  netif_receive_skb() in Eth driver, no patch:
>>
>>  [ ID] Interval Transfer Bitrate Retr
>>  [ 5] 0.00-120.01 sec 9.00 GBytes 644 Mbits/sec 413 sender
>>  [ 5] 0.00-120.00 sec 8.99 GBytes 644 Mbits/sec receiver
>>
>>  eth0
>>  RX packets:7097731 errors:0 dropped:0 overruns:0 frame:0
>>  TX packets:7097702 errors:0 dropped:0 overruns:0 carrier:0
>>
>>  port0
>>  RX packets:426050 errors:0 dropped:0 overruns:0 frame:0
>>  TX packets:6671829 errors:0 dropped:0 overruns:0 carrier:0
>>
>>  port1
>>  RX packets:6671681 errors:0 dropped:0 overruns:0 carrier:0
>>  TX packets:425862 errors:0 dropped:0 overruns:0 carrier:0
>>
>>  port1.218
>>  RX packets:6671677 errors:0 dropped:0 overruns:0 frame:0
>>  TX packets:425851 errors:0 dropped:0 overruns:0 carrier:0
>>
>>  ---------------------------------------------------------------------
>>
>>  netif_receive_skb_list() in Eth driver, no patch:
>>
>>  [ ID] Interval Transfer Bitrate Retr
>>  [ 5] 0.00-120.01 sec 9.48 GBytes 679 Mbits/sec 129 sender
>>  [ 5] 0.00-120.00 sec 9.48 GBytes 679 Mbits/sec receiver
>>
>>  eth0
>>  RX packets:7448098 errors:0 dropped:0 overruns:0 frame:0
>>  TX packets:7448073 errors:0 dropped:0 overruns:0 carrier:0
>>
>>  port0
>>  RX packets:416115 errors:0 dropped:0 overruns:0 frame:0
>>  TX packets:7032121 errors:0 dropped:0 overruns:0 carrier:0
>>
>>  port1
>>  RX packets:7031983 errors:0 dropped:0 overruns:0 frame:0
>>  TX packets:415941 errors:0 dropped:0 overruns:0 carrier:0
>>
>>  port1.218
>>  RX packets:7031978 errors:0 dropped:0 overruns:0 frame:0
>>  TX packets:415930 errors:0 dropped:0 overruns:0 carrier:0
>>
>>  ---------------------------------------------------------------------
>>
>>  napi_gro_receive() in Eth driver, no patch:
>>
>>  [ ID] Interval Transfer Bitrate Retr
>>  [ 5] 0.00-120.01 sec 10.0 GBytes 718 Mbits/sec 107 sender
>>  [ 5] 0.00-120.00 sec 10.0 GBytes 718 Mbits/sec receiver
>>
>>  eth0
>>  RX packets:7868281 errors:0 dropped:0 overruns:0 frame:0
>>  TX packets:7868267 errors:0 dropped:0 overruns:0 carrier:0
>>
>>  port0
>>  RX packets:429082 errors:0 dropped:0 overruns:0 frame:0
>>  TX packets:7439343 errors:0 dropped:0 overruns:0 carrier:0
>>
>>  port1
>>  RX packets:7439199 errors:0 dropped:0 overruns:0 frame:0
>>  TX packets:428913 errors:0 dropped:0 overruns:0 carrier:0
>>
>>  port1.218
>>  RX packets:7439195 errors:0 dropped:0 overruns:0 frame:0
>>  TX packets:428902 errors:0 dropped:0 overruns:0 carrier:0
>>
>>  =====================================================================
>>
>>  netif_receive_skb() in Eth driver + patch:
>>
>>  [ ID] Interval Transfer Bitrate Retr
>>  [ 5] 0.00-120.01 sec 12.2 GBytes 870 Mbits/sec 2267 sender
>>  [ 5] 0.00-120.00 sec 12.2 GBytes 870 Mbits/sec receiver
>>
>>  eth0
>>  RX packets:9474792 errors:0 dropped:0 overruns:0 frame:0
>>  TX packets:9474777 errors:0 dropped:0 overruns:0 carrier:0
>>
>>  port0
>>  RX packets:455200 errors:0 dropped:0 overruns:0 frame:0
>>  TX packets:353288 errors:0 dropped:0 overruns:0 carrier:0
>>
>>  port1
>>  RX packets:9019592 errors:0 dropped:0 overruns:0 frame:0
>>  TX packets:455035 errors:0 dropped:0 overruns:0 carrier:0
>>
>>  port1.218
>>  RX packets:353144 errors:0 dropped:0 overruns:0 frame:0
>>  TX packets:455024 errors:0 dropped:0 overruns:0 carrier:0
>>
>>  ---------------------------------------------------------------------
>>
>>  netif_receive_skb_list() in Eth driver + patch:
>>
>>  [ ID] Interval Transfer Bitrate Retr
>>  [ 5] 0.00-120.01 sec 11.6 GBytes 827 Mbits/sec 2224 sender
>>  [ 5] 0.00-120.00 sec 11.5 GBytes 827 Mbits/sec receiver
>>
>>  eth0
>>  RX packets:8981651 errors:0 dropped:0 overruns:0 frame:0
>>  TX packets:898187 errors:0 dropped:0 overruns:0 carrier:0
>>
>>  port0
>>  RX packets:436159 errors:0 dropped:0 overruns:0 frame:0
>>  TX packets:335665 errors:0 dropped:0 overruns:0 carrier:0
>>
>>  port1
>>  RX packets:8545492 errors:0 dropped:0 overruns:0 frame:0
>>  TX packets:436071 errors:0 dropped:0 overruns:0 carrier:0
>>
>>  port1.218
>>  RX packets:335593 errors:0 dropped:0 overruns:0 frame:0
>>  TX packets:436065 errors:0 dropped:0 overruns:0 carrier:0
>>
>>  -----------------------------------------------------------
>>
>>  napi_gro_receive() in Eth driver + patch:
>>
>>  [ ID] Interval Transfer Bitrate Retr
>>  [ 5] 0.00-120.01 sec 11.8 GBytes 855 Mbits/sec 122 sender
>>  [ 5] 0.00-120.00 sec 11.8 GBytes 855 Mbits/sec receiver
>>
>>  eth0
>>  RX packets:9292214 errors:0 dropped:0 overruns:0 frame:0
>>  TX packets:9292190 errors:0 dropped:0 overruns:0 carrier:0
>>
>>  port0
>>  RX packets:438516 errors:0 dropped:0 overruns:0 frame:0
>>  TX packets:347236 errors:0 dropped:0 overruns:0 carrier:0
>>
>>  port1
>>  RX packets:8853698 errors:0 dropped:0 overruns:0 frame:0
>>  TX packets:438331 errors:0 dropped:0 overruns:0 carrier:0
>>
>>  port1.218
>>  RX packets:347082 errors:0 dropped:0 overruns:0 frame:0
>>  TX packets:438320 errors:0 dropped:0 overruns:0 carrier:0
>>
>>  -----------------------------------------------------------
>>
>>  The main goal is achieved: we have about 100-200 Mbps of performance
>>  boost while in-stack skbs are greatly reduced from ~8-9 millions to
>>  ~350000 (compare port0 TX and port1 RX without patch and with it).
>
> And the number of TCP retries is also lower, which likely means that we
> are making better use of the flow control built into the hardware/driver
> here?
>
> BTW do you know why you have so many retries though? It sounds like your
> flow control is missing a few edge cases, or that you have an incorrect
> configuration of your TX admission queue.

Well, I have the same question TBH. All these ~1.5 years that I'm
working on these switches I have pretty chaotic number of TCP
retransmissions each time I change something in the code. They are
less likely to happen when the average CPU load is lower, but ~100
is the best result I ever got.
Seems like I should stop trying to push software throughput to
the max for a while and pay more attention to this and to hardware
configuration instead and check if I miss something :) 

>>  The main bottleneck in gro_cells setup is that GRO layer starts to
>>  work only after skb are being processed by DSA stack, so they are
>>  going frame-by-frame until that moment (RX counter on port1).
>>
>>  If one day we change the way of handling incoming packets (not
>>  through fake packet_type), we could avoid that by unblocking GRO
>>  processing in between Eth driver and DSA core.
>>  With my custom packet_offload for ETH_P_XDSA that works only for
>>  my CPU tag format I have about ~910-920 Mbps on the same platform.
>>  This way doesn't fit mainline code of course, so I'm working on
>>  alternative Rx paths for DSA, e.g. through net_device::rx_handler()
>>  etc.
>>
>>  Until then, gro_cells really improve things a lot while the actual
>>  patch is tiny.
> --
> Florian
