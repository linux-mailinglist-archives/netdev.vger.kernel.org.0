Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6FAC13011D
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 06:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbgADF5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jan 2020 00:57:21 -0500
Received: from dpmailmta01-29.doteasy.com ([65.61.219.9]:59497 "EHLO
        dpmailmta01.doteasy.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725790AbgADF5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jan 2020 00:57:20 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=192.168.101.84;
Received: from dpmailrp04.doteasy.com (unverified [192.168.101.84]) 
        by dpmailmta01.doteasy.com (DEO) with ESMTP id 53060957-1394429 
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 21:57:19 -0800
Received: from dpmail22.doteasy.com (dpmail22.doteasy.com [192.168.101.22])
        by dpmailrp04.doteasy.com (8.14.4/8.14.4/Debian-8+deb8u2) with ESMTP id 0045vIhY026142
        for <netdev@vger.kernel.org>; Fri, 3 Jan 2020 21:57:19 -0800
X-SmarterMail-Authenticated-As: trev@larock.ca
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169]) by dpmail22.doteasy.com with SMTP;
   Fri, 3 Jan 2020 21:57:03 -0800
Received: by mail-lj1-f169.google.com with SMTP id a13so45778375ljm.10
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 21:56:53 -0800 (PST)
X-Gm-Message-State: APjAAAX4aPgH04D2qAfERYdc2k7jto3eZ6rKcVM0tRWcihRTtg7RqBuM
        jNOPD/HwwklB7sT1x+kB0Vqhp/rBtouqsgO85z8=
X-Google-Smtp-Source: APXvYqwQ4837SMUl5XzmLTsjSDrz7mHiKhb6H40LRv/+iQmkfTspxGcc9GS0Ko5VUoleHozDRn9WZME0QK8pQigUpbQ=
X-Received: by 2002:a2e:9e43:: with SMTP id g3mr39065616ljk.37.1578117412719;
 Fri, 03 Jan 2020 21:56:52 -0800 (PST)
MIME-Version: 1.0
References: <CAHgT=KfpKenfzn3+uiVdF-B3mGv30Ngu70y6Zn+wH0GcGcDFYQ@mail.gmail.com>
 <ff36e5d0-0b01-9683-1698-474468067402@gmail.com>
In-Reply-To: <ff36e5d0-0b01-9683-1698-474468067402@gmail.com>
From:   Trev Larock <trev@larock.ca>
Date:   Sat, 4 Jan 2020 00:56:41 -0500
X-Gmail-Original-Message-ID: <CAHgT=KcQb4ngBmhU82cc+XbW_2RvYfi0OwH5ROstkw9DD8G3mA@mail.gmail.com>
Message-ID: <CAHgT=KcQb4ngBmhU82cc+XbW_2RvYfi0OwH5ROstkw9DD8G3mA@mail.gmail.com>
Subject: Re: VRF + ip xfrm, egress ESP packet looping when qdisc configured
To:     David Ahern <dsahern@gmail.com>
Cc:     Trev Larock <trev@larock.ca>, netdev@vger.kernel.org,
        Ben Greear <greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
X-Exim-Id: CAHgT=KcQb4ngBmhU82cc+XbW_2RvYfi0OwH5ROstkw9DD8G3mA
X-Bayes-Prob: 0.0001 (Score 0, tokens from: base:default, @@RPTN)
X-Spam-Score: 0.00 () [Hold at 5.00] 
X-CanIt-Geo: No geolocation information available for 192.168.101.22
X-CanItPRO-Stream: base:default
X-Canit-Stats-ID: 011K5ViT4 - 1bb2611b9953 - 20200103
X-Scanned-By: CanIt (www . roaringpenguin . com) on 192.168.101.84
X-To-Not-Matched: true
X-Originating-IP: 192.168.101.84
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 2, 2020 at 11:44 PM David Ahern <dsahern@gmail.com> wrote:
> Ben, cc-ed, has done some IPsec + VRF work.
>
> I have not done much wth xfrm + vrf. Can you re-create this with network
> namespaces? If so, send the commands and I will take a look when I can.
>
Thanks for responding David, under namespace the same behavior is seen.
Setup for host1 was fedora31 kernel 5.3.7-301.fc31.x86_64, host2 optional

          host1 netns ns0                      |  host2
         +---------------+                     |
         |     vrf0      |                     |
         +---------------+                     |
            |                                  |
            |                                  |
         +--------+                            |
         | enp0s8 | 192.168.56.116 --------------- 192.168.56.114
         +--------+                            |
                                               |
 ip netns add ns0
 ip netns exec ns0 ip link set lo up
 ip link set dev enp0s8 netns ns0
 sysctl net.ipv4.tcp_l3mdev_accept=1
 ip netns exec ns0 sysctl net.ipv4.tcp_l3mdev_accept=1
 ip netns exec ns0 ip addr add 192.168.56.116/24 dev enp0s8
 ip netns exec ns0 ip link set enp0s8 up
 ip netns exec ns0 ip link add dev vrf0 type vrf table 300
 ip netns exec ns0 ip link set dev vrf0 up
 ip netns exec ns0 ip link set dev enp0s8 master vrf0
 ip netns exec ns0 ip xfrm policy add src 192.168.56.116/32 dst
192.168.56.114/32 dir out priority 367231 ptype main tmpl src
192.168.56.116 dst 192.168.56.114 proto esp spi 0x1234567 reqid 1 mode
tunnel
 ip netns exec ns0 ip xfrm state add src 192.168.56.116 dst
192.168.56.114 proto esp spi 0x1234567 reqid 1 mode tunnel aead
'rfc4106(gcm(aes))'
0x68db8eabd7f61557247f28f95e668f19855e086d02b21488fde4f5fcc9d42fcfbc9a2e35
128 sel src 192.168.56.116/32 dst 192.168.56.114/32

# With qdisc have the looping ESP packet in vrf0
 ip netns exec ns0 tc qdisc add dev vrf0 root netem delay 0ms
# ping to trigger policy
 ip netns exec ns0 ping -c 1 -w 1 -I vrf0 192.168.56.114
# monitor with tcpdump
 ip netns exec ns0 tcpdump -i vrf0 host 192.168.56.114

Thanks
Trev

