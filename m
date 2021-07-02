Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87ED93BA098
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 14:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbhGBMje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 08:39:34 -0400
Received: from www259.your-server.de ([188.40.28.39]:51600 "EHLO
        www259.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232249AbhGBMjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 08:39:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=waldheinz.de; s=default1911; h=MIME-Version:Content-Type:In-Reply-To:
        References:Subject:Cc:To:From:Message-ID:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
        bh=R8qlMxybNCl24ASkaoOgw8qDrbqZwoKnwrfyU+rzea0=; b=iotnpxYXHM4503PVNT6DAiTMkl
        gWU6h1rvXpNywc6jvTsHgt4Eq+KrAsLcnkacwlmsDWuJFRe/XYC8Y7io+2ZGkyt971264co13nbBP
        S8Su4Z8Dfpr5PIjVTjhOdDI3H8zIaIANdOlmrXgfQLKlLkAydF3uo3gytK22vBjZIZHdgMdJCdwvn
        m1+fmLU2l0iE5+tJkhKe9Xyno6AJAHLSZu+7zxfy/r810DyGnmF5XhIRDEAvCaSbx76wdmmbqkdlA
        UXIreL6IFK18ZtKLyFR30Y+NmLtCXjZEgEjGKVRu2Olk4SYI88/Rs4EcMh3euOmJaf9nZ6vi74mD6
        cBBq+PJQ==;
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www259.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <mt@waldheinz.de>)
        id 1lzIPS-00093S-VJ; Fri, 02 Jul 2021 14:36:42 +0200
Received: from [192.168.0.32] (helo=mail.your-server.de)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-CHACHA20-POLY1305:256)
        (Exim 4.92)
        (envelope-from <mt@waldheinz.de>)
        id 1lzIPS-000PYW-NF; Fri, 02 Jul 2021 14:36:42 +0200
Received: from ip4d1584d2.dynamic.kabel-deutschland.de
 (ip4d1584d2.dynamic.kabel-deutschland.de [77.21.132.210]) by
 mail.your-server.de (Horde Framework) with HTTPS; Fri, 02 Jul 2021 14:36:42
 +0200
Date:   Fri, 02 Jul 2021 14:36:42 +0200
Message-ID: <20210702143642.Horde.PFbG3LFNTZ3wp0TYiBRGsCM@mail.your-server.de>
From:   Matthias Treydte <mt@waldheinz.de>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, stable@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        regressions@lists.linux.dev, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
Subject: Re: [regression] UDP recv data corruption
References: <20210701124732.Horde.HT4urccbfqv0Nr1Aayuy0BM@mail.your-server.de>
 <38ddc0e8-ba27-279b-8b76-4062db6719c6@gmail.com>
 <CA+FuTSc3POcZo0En3JBqRwq2+eF645_Cs4U-4nBmTs9FvjoVkg@mail.gmail.com>
In-Reply-To: <CA+FuTSc3POcZo0En3JBqRwq2+eF645_Cs4U-4nBmTs9FvjoVkg@mail.gmail.com>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
X-Authenticated-Sender: mt@waldheinz.de
X-Virus-Scanned: Clear (ClamAV 0.103.2/26219/Fri Jul  2 13:06:52 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Quoting Willem de Bruijn <willemdebruijn.kernel@gmail.com>:

> That library does not enable UDP_GRO. You do not have any UDP based
> tunnel devices (besides vxlan) configured, either, right?

The configuration is really minimal by now, I also took the bonding
out of the equation. We have systemd configure "en*" with mDNS and DHCP
enabled and that's it. The problem remains.

I also found new hardware on my desk today (some Intel SoC), showing
exactly the same symptoms. So it's really nothing to do with the
hardware.

> It is also unlikely that the device has either of NETIF_F_GRO_FRAGLIST
> or NETIF_F_GRO_UDP_FWD configured. This can be checked with `ethtool
> -K $DEV`, shown as "rx-gro-list" and "rx-udp-gro-forwarding",
> respectively.

The full output of "ethtool -k enp5s0" from that SoC:

Features for enp5s0:
rx-checksumming: on
tx-checksumming: on
         tx-checksum-ipv4: off [fixed]
         tx-checksum-ip-generic: on
         tx-checksum-ipv6: off [fixed]
         tx-checksum-fcoe-crc: off [fixed]
         tx-checksum-sctp: on
scatter-gather: on
         tx-scatter-gather: on
         tx-scatter-gather-fraglist: off [fixed]
tcp-segmentation-offload: on
         tx-tcp-segmentation: on
         tx-tcp-ecn-segmentation: off [fixed]
         tx-tcp-mangleid-segmentation: off
         tx-tcp6-segmentation: on
generic-segmentation-offload: on
generic-receive-offload: on
large-receive-offload: off [fixed]
rx-vlan-offload: on
tx-vlan-offload: on
ntuple-filters: off
receive-hashing: on
highdma: on [fixed]
rx-vlan-filter: on [fixed]
vlan-challenged: off [fixed]
tx-lockless: off [fixed]
netns-local: off [fixed]
tx-gso-robust: off [fixed]
tx-fcoe-segmentation: off [fixed]
tx-gre-segmentation: on
tx-gre-csum-segmentation: on
tx-ipxip4-segmentation: on
tx-ipxip6-segmentation: on
tx-udp_tnl-segmentation: on
tx-udp_tnl-csum-segmentation: on
tx-gso-partial: on
tx-tunnel-remcsum-segmentation: off [fixed]
tx-sctp-segmentation: off [fixed]
tx-esp-segmentation: off [fixed]
tx-udp-segmentation: on
tx-gso-list: off [fixed]
fcoe-mtu: off [fixed]
tx-nocache-copy: off
loopback: off [fixed]
rx-fcs: off [fixed]
rx-all: off
tx-vlan-stag-hw-insert: off [fixed]
rx-vlan-stag-hw-parse: off [fixed]
rx-vlan-stag-filter: off [fixed]
l2-fwd-offload: off [fixed]
hw-tc-offload: on
esp-hw-offload: off [fixed]
esp-tx-csum-hw-offload: off [fixed]
rx-udp_tunnel-port-offload: off [fixed]
tls-hw-tx-offload: off [fixed]
tls-hw-rx-offload: off [fixed]
rx-gro-hw: off [fixed]
tls-hw-record: off [fixed]
rx-gro-list: off
macsec-hw-offload: off [fixed]
rx-udp-gro-forwarding: off
hsr-tag-ins-offload: off [fixed]
hsr-tag-rm-offload: off [fixed]
hsr-fwd-offload: off [fixed]
hsr-dup-offload: off [fixed]

That's the only NIC on this board:

# ip l
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN  
mode DEFAULT group default qlen 1000
     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: enp5s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state  
UP mode DEFAULT group default qlen 1000
     link/ether 00:30:d6:24:99:67 brd ff:ff:ff:ff:ff:ff

> One possible short-term workaround is to disable GRO.

Indeed, "ethtool -K enp5s0 gro off" fixes the problem, and calling it with
"gro on" brings it back.


And to answer Paolo's questions from his mail to the list (@Paolo: I'm  
not subscribed,
please also send to me directly so I don't miss your mail)

> Could you please:
> - tell how frequent is the pkt corruption, even a rough estimate of the
> frequency.

# journalctl --since "5min ago" | grep "Packet corrupt" | wc -l
167

So there are 167 detected failures in 5 minutes, while the system is receiving
at a moderate rate of about 900 pkts/s (according to Prometheus' node exporter
at least, but seems about right)

Next I'll try to capture some broken packets and reply in a separate mail,
I'll have to figure out a good way to do this first.


Thanks for your help,
-Matthias



