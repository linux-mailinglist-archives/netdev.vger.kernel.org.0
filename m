Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0135234BC8D
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 16:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbhC1OLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 10:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhC1OKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 10:10:47 -0400
X-Greylist: delayed 310 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 28 Mar 2021 07:10:46 PDT
Received: from forward105p.mail.yandex.net (forward105p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F8AC061756
        for <netdev@vger.kernel.org>; Sun, 28 Mar 2021 07:10:46 -0700 (PDT)
Received: from forward103q.mail.yandex.net (forward103q.mail.yandex.net [IPv6:2a02:6b8:c0e:50:0:640:b21c:d009])
        by forward105p.mail.yandex.net (Yandex) with ESMTP id B97B54D40F7A;
        Sun, 28 Mar 2021 17:05:31 +0300 (MSK)
Received: from vla1-2a93b1d0b0e8.qloud-c.yandex.net (vla1-2a93b1d0b0e8.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:1e22:0:640:2a93:b1d0])
        by forward103q.mail.yandex.net (Yandex) with ESMTP id B592661E0004;
        Sun, 28 Mar 2021 17:05:31 +0300 (MSK)
Received: from vla1-cde8305024b9.qloud-c.yandex.net (vla1-cde8305024b9.qloud-c.yandex.net [2a02:6b8:c0d:4201:0:640:cde8:3050])
        by vla1-2a93b1d0b0e8.qloud-c.yandex.net (mxback/Yandex) with ESMTP id O9Cpr4auxp-5VJe3quk;
        Sun, 28 Mar 2021 17:05:31 +0300
Authentication-Results: vla1-2a93b1d0b0e8.qloud-c.yandex.net; dkim=pass
Received: by vla1-cde8305024b9.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id Bu5NsoNcYL-5UKulaZj;
        Sun, 28 Mar 2021 17:05:30 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Michal Soltys <msoltyspl@yandex.pl>
Subject: [BUG / question] in routing rules, some options (e.g. ipproto, sport)
 cause rules to be ignored in presence of packet marks
To:     Linux Netdev List <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Message-ID: <babb2ebf-862a-d05f-305a-e894e88f601e@yandex.pl>
Date:   Sun, 28 Mar 2021 16:05:29 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm not sure how it behaved in earlier kernels (can check later), but it 
is / looks bugged in at least recent 5.x+ ones (tests were done with 
5.11.8 and 5.10.25).

Consider following setup:

# ip -o ad sh
1: lo    inet 127.0.0.1/8 scope host lo
2: right1    inet 10.0.10.2/24 scope global
3: right2    inet 10.0.20.2/24 scope global

# ip ro sh tab main
default via 10.0.10.1 dev right1
10.0.10.0/24 dev right1 proto kernel scope link src 10.0.10.2
10.0.20.0/24 dev right2 proto kernel scope link src 10.0.20.2

# ip ro sh tab 123
default via 10.0.20.1 dev right2 src 10.0.20.2

And routing rules:

0:      from all lookup local
9:      from all fwmark 0x1 ipproto udp sport 1194 lookup 123
10:     from all ipproto udp sport 1194 lookup 123
32766:  from all lookup main
32767:  from all lookup default

This - without any mangling via ipt/nft or by other means - works 
correctly, for example:

nc -u -p 1194 1.2.3.4 12345

will be routed out correctly via 'right2' using 10.0.20.2

But if we add mark to locally outgoing packets:

iptables -t mangle -A OUTPUT -j MARK --set-mark 1

Then *both* rule 9 and rule 10 will be ignored during reroute check. 
tcpdump on interface 'right1' will show:

# tcpdump -nvi right1 udp
tcpdump: listening on right1, link-type EN10MB (Ethernet), snapshot 
length 262144 bytes
13:21:59.684928 IP (tos 0x0, ttl 64, id 8801, offset 0, flags [DF], 
proto UDP (17), length 33)
     10.0.20.2.1194 > 1.2.3.4.12345: UDP, length 5

Initial routing decision in rule 10 will set the address correctly, but 
the packet goes out via interface right1, ignoring both 9 and 10.

If I add another routing roule:

8:      from all fwmark 0x1 lookup 123

Then the packects will flow correctly - but I *cannot* use (from the 
ones I tested): sport, dport, ipproto, uidrange - as they will cause the 
rule to be ignored. For example, this setup of routing rules will fail, 
if there is any mark set on a packet (nc had uid 1120):

# ip ru sh
0:      from all lookup local
10:     from all ipproto udp lookup 123
10:     from all sport 1194 lookup 123
10:     from all dport 12345 lookup 123
10:     from all uidrange 1120-1120 lookup 123
32766:  from all lookup main
32767:  from all lookup default

Adding correct fwmark to the above rules will have *no* effect either. 
Only fwmark *alone* will work (or in combination with: iif, from, to - 
from the ones I tested).

I peeked at fib_rule_match() in net/core/fib_rules.c - but it doesn't 
look like there is anything wrong there. I initially suspected lack of 
'rule->mark &&' in mark related line - but considering that rules such 
as 'from all fwmark 1 sport 1194 lookup main' also fail, it doesn't look 
like it's the culprit (and mark_mask covers that test either way).

OTOH, perhaps nf_ip_reroute() / ip_route_me_harder() are somehow the 
culprit here - but I haven't analyzed them yet. Perhaps it's just an 
issue of changing output interface incorrectly after ip_route_me_harder() ?

Is this a bug ? Or am I misinterpreting how 'reroute check' works after 
initial routing decision ? One would expect routing rules during 
post-mangle check to not be ignored out of the blue, only because packet 
mark changed on the packet. Not mentioning both marks and routing rules 
can be used for separate purposes (e.g. marks for shaping).

