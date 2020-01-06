Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14691130CC4
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 05:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbgAFE1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 23:27:37 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:45646 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727432AbgAFE1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 23:27:37 -0500
Received: by mail-io1-f68.google.com with SMTP id i11so47259363ioi.12
        for <netdev@vger.kernel.org>; Sun, 05 Jan 2020 20:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VPt8wg33N/0AV9jgLY5b6unP5jiLV1KWTBcKCBU2haA=;
        b=UFXE+Ngqj3DNgEX6b+H9GvDJlfokyOnqb/y4Pwb02lFYQddl1q2BXTgqmOgMKHarpH
         zuCdwHuuqt6YrSm+Vp2yBsJmCxuASvc/FtDw/Lo1qZaNBf0o2ZcUJcYwSWtpII3Fytfx
         D+y8thmkoNvs9NjeSlvhHRVpnaetd8FaMaYAoZwdcSpLWjixJQiL2eIC3SqOlW8U50gI
         r337IFdjcFdMRzns3+pqaxFQT7XiLTUNgVL1XSzJk6IYAqozV4TJvm/ddpxXSbpPcFsN
         FOoOCNs+QmIzcMcZK+J9leXyaN4qlCwuHV51zBGWs4PrZgR77ilJStYKOqs0NNfK58bH
         5fEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VPt8wg33N/0AV9jgLY5b6unP5jiLV1KWTBcKCBU2haA=;
        b=IbM+dmr1NUFKSiJb7qsd1kd8RR9Btc2OiBIXKPMzsjopwbo1pzlIbDkqV8Saq++r1D
         b9XMDlh2DUez3A5LLKrcz5+sfORZ5zWqK9VmtjZjiUGN2yA06rC2Wc5bJEKcgnRYUrwT
         nwZCJ0hPtjr6Q4Roz4oCa53fixHiceLiMnPD8LNeCY+unalQ4yy00dtwnhi+YRv/5LD4
         R/d0/m8aUbkDiSmyHjYf/EyBqdpSlQkMXH22w3me4ufKoC1YgDjshwnZF0W9c02vYyKl
         OICWDet9sHE7dWsgZMHq8JfeMrarXkWHfKirgGHBe28rrDZo9trPnX467mUMY7GP0RCR
         1ruQ==
X-Gm-Message-State: APjAAAXgzP31/VjLP/YE/RFbCIXARRAjyO1o9cKg4Hyz5A0ZAlbcZx4a
        /eamC9O6yRLuzdX4z0OfZHc=
X-Google-Smtp-Source: APXvYqw+ZQZJOsN4Vo1Ge7FCeKwJrtowAynrh9AukuWG6WBlpKox9j2LIssqqv+Nj+sxXDl9n/ybmQ==
X-Received: by 2002:a5e:8d14:: with SMTP id m20mr64156437ioj.282.1578284856437;
        Sun, 05 Jan 2020 20:27:36 -0800 (PST)
Received: from ?IPv6:2601:282:800:7a:25de:66a4:163b:14df? ([2601:282:800:7a:25de:66a4:163b:14df])
        by smtp.googlemail.com with ESMTPSA id k17sm16870219ioh.64.2020.01.05.20.27.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jan 2020 20:27:35 -0800 (PST)
Subject: Re: VRF + ip xfrm, egress ESP packet looping when qdisc configured
To:     Trev Larock <trev@larock.ca>
Cc:     netdev@vger.kernel.org, Ben Greear <greearb@candelatech.com>
References: <CAHgT=KfpKenfzn3+uiVdF-B3mGv30Ngu70y6Zn+wH0GcGcDFYQ@mail.gmail.com>
 <ff36e5d0-0b01-9683-1698-474468067402@gmail.com>
 <CAHgT=KcQb4ngBmhU82cc+XbW_2RvYfi0OwH5ROstkw9DD8G3mA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5e8522fb-d383-c0ea-f013-8625f204c4ce@gmail.com>
Date:   Sun, 5 Jan 2020 21:27:34 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <CAHgT=KcQb4ngBmhU82cc+XbW_2RvYfi0OwH5ROstkw9DD8G3mA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/3/20 10:56 PM, Trev Larock wrote:
> On Thu, Jan 2, 2020 at 11:44 PM David Ahern <dsahern@gmail.com> wrote:
>> Ben, cc-ed, has done some IPsec + VRF work.
>>
>> I have not done much wth xfrm + vrf. Can you re-create this with network
>> namespaces? If so, send the commands and I will take a look when I can.
>>
> Thanks for responding David, under namespace the same behavior is seen.
> Setup for host1 was fedora31 kernel 5.3.7-301.fc31.x86_64, host2 optional
> 
>           host1 netns ns0                      |  host2
>          +---------------+                     |
>          |     vrf0      |                     |
>          +---------------+                     |
>             |                                  |
>             |                                  |
>          +--------+                            |
>          | enp0s8 | 192.168.56.116 --------------- 192.168.56.114
>          +--------+                            |
>                                                |
>  ip netns add ns0
>  ip netns exec ns0 ip link set lo up
>  ip link set dev enp0s8 netns ns0
>  sysctl net.ipv4.tcp_l3mdev_accept=1
>  ip netns exec ns0 sysctl net.ipv4.tcp_l3mdev_accept=1
>  ip netns exec ns0 ip addr add 192.168.56.116/24 dev enp0s8
>  ip netns exec ns0 ip link set enp0s8 up
>  ip netns exec ns0 ip link add dev vrf0 type vrf table 300
>  ip netns exec ns0 ip link set dev vrf0 up
>  ip netns exec ns0 ip link set dev enp0s8 master vrf0
>  ip netns exec ns0 ip xfrm policy add src 192.168.56.116/32 dst
> 192.168.56.114/32 dir out priority 367231 ptype main tmpl src
> 192.168.56.116 dst 192.168.56.114 proto esp spi 0x1234567 reqid 1 mode
> tunnel
>  ip netns exec ns0 ip xfrm state add src 192.168.56.116 dst
> 192.168.56.114 proto esp spi 0x1234567 reqid 1 mode tunnel aead
> 'rfc4106(gcm(aes))'
> 0x68db8eabd7f61557247f28f95e668f19855e086d02b21488fde4f5fcc9d42fcfbc9a2e35
> 128 sel src 192.168.56.116/32 dst 192.168.56.114/32
> 
> # With qdisc have the looping ESP packet in vrf0
>  ip netns exec ns0 tc qdisc add dev vrf0 root netem delay 0ms
> # ping to trigger policy
>  ip netns exec ns0 ping -c 1 -w 1 -I vrf0 192.168.56.114
> # monitor with tcpdump
>  ip netns exec ns0 tcpdump -i vrf0 host 192.168.56.114
> 
> Thanks
> Trev
> 

Hi: I meant a series of commands using *only* network namespaces for
host1 and host2. e.g.,

ip link add veth1 type veth peer name veth2
ip link add dev vrf0 type vrf table 300
ip link set dev vrf0 up
ip link set dev veth1 master vrf0
ip addr add 192.168.56.116/24 dev veth1
ip li set dev veth1 up

ip netns add host2
ip netns exec host2 ip link set lo up
ip link set dev veth2 netns host2
ip netns exec host2 sysctl net.ipv4.tcp_l3mdev_accept=1
ip -netns host2 addr add 192.168.56.114/24 dev veth2
ip -netns host2 link set veth2 up


I was able to adapt your commands with the above and reproduced the
problem. I need to think about the proper solution.

Also, I looked at my commands from a few years ago (IPsec with VRF) and
noticed you are not adding a device context to the xfrm policy and
state. e.g.,

ip xfrm policy flush
ip xfrm policy add src 192.168.56.0/24 dst 192.168.56.0/24 \
  dev vrf0 ...

ip xfrm state flush
ip xfrm state add src 192.168.56.116 dst 192.168.56.114 \
...
   sel dev vrf0 src 192.168.56.116 dst 192.168.56.114

