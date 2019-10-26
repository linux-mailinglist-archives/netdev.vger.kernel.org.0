Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD84E58F2
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 09:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbfJZHH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 03:07:59 -0400
Received: from mail-40133.protonmail.ch ([185.70.40.133]:13641 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbfJZHH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 03:07:59 -0400
Date:   Sat, 26 Oct 2019 07:07:52 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1572073674;
        bh=YONr+5ayW21xtIqUS97YxUotqp8FVLfpeK8sdBitQag=;
        h=Date:To:From:Reply-To:Subject:Feedback-ID:From;
        b=fCTceVSJEOK7htL3BHMXVSr+k3fPrQWEmF9+vlQ+fzCJ16P+jdnsaasgw2qYM6AZN
         z4LYIpUO9mf0ubIKUoKYDvCVgi43Mh5qKa8x+Ej8jFEalNquPdzRV9Alfkf6X0STtN
         icdKRhMHYUDPFKE/Lnu9MbQKMZDh/xGLBhlJohy4=
To:     "alexander.h.duyck@redhat.com" <alexander.h.duyck@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        Netdev <netdev@vger.kernel.org>,
        "lartc@vger.kernel.org" <lartc@vger.kernel.org>
From:   Ttttabcd <ttttabcd@protonmail.com>
Reply-To: Ttttabcd <ttttabcd@protonmail.com>
Subject: Commit 0ddcf43d5d4a causes the local table to conflict with the main table
Message-ID: <YWOrt002RdCqkBeUL04N1MVxcsjRvmCb4iqMW67EmAQIG5erLlSntgQWmSYiHXAT8kgFTceURhTaP8dAp9nPD9q3lquhb0MTIRlP4Vy5k3Y=@protonmail.com>
Feedback-ID: EvWK9os_-weOBrycfL_HEFp-ixys9sxnciOqqctCHB9kjCM4ip8VR9shOcMQZgeZ7RCnmNC4HYjcUKNMz31NBA==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_REPLYTO
        autolearn=no autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.protonmail.ch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recently I was implementing a transparent proxy project. Naturally, I start=
ed to research the Linux local routing table and the tproxy module.

But when I was studying the behavior of the local routing table, something =
strange happened, which caused me to spend a lot of time thinking about why=
.

ip route add local 0.0.0.0/0 dev lo

At the beginning, I tested a local routing table and added 0.0.0.0/0 to let=
 the system think that the entire IPv4 space is a local address.

ip rule
0:=09from all lookup local
32766:=09from all lookup main
32767:=09from all lookup default

I did not add any policy routing, everything stays normal

ip route show table main
default via 192.168.3.1 dev wlan0 proto dhcp metric 600
192.168.3.0/24 dev wlan0 proto kernel scope link src 192.168.3.62 metric 60=
0

The above is my main routing table, I am now on a network of 192.168.3.0/24=
, the default route is 192.168.3.1.

ip route show table local
local default dev lo scope host
broadcast 127.0.0.0 dev lo proto kernel scope link src 127.0.0.1
local 127.0.0.0/8 dev lo proto kernel scope host src 127.0.0.1
local 127.0.0.1 dev lo proto kernel scope host src 127.0.0.1
broadcast 127.255.255.255 dev lo proto kernel scope link src 127.0.0.1
broadcast 192.168.3.0 dev wlan0 proto kernel scope link src 192.168.3.62
local 192.168.3.62 dev wlan0 proto kernel scope host src 192.168.3.62
broadcast 192.168.3.255 dev wlan0 proto kernel scope link src 192.168.3.62

The above is my current local routing table, you can see that 0.0.0.0/0 (de=
fault) has been added, and 127.0.0.1, 127.0.0.0/8, 192.168.3.62 is also my =
local address.

According to the correct theory, all IPv4 addresses are now my local addres=
s, so whatever address I want to connect to should be routed to the loopbac=
k interface and sent back to myself.

ip route get 1.1.1.1
local 1.1.1.1 dev lo src 1.1.1.1 uid 0
    cache <local>

ip route get 192.168.3.100
192.168.3.100 dev wlan0 src 192.168.3.62 uid 0
    cache

But I did some testing but found that it was not like this. For example, I =
tested that 1.1.1.1 will be routed to lo, but 192.168.3.100 will be routed =
to wlan0. 192.168.3.100 is not routed according to the contents of the loca=
l routing table! 192.168.3.100 is normally routed in the main table.

This is the wrong handling. The correct way is that according to the priori=
ty of the policy routing, the local table has higher priority than the main=
 table. It should match the local table first. As long as there is a corres=
ponding routing table entry in the local table, the main table will not be =
used.

This problem has been a headache for me for a long time because it is incon=
sistent with the description of the ip rule by the Manual page. Until I fou=
nd an amazing fact in /proc/net/fib_trie.

/proc/net/fib_trie

Main:
  +-- 0.0.0.0/0 3 0 5
     |-- 0.0.0.0
        /0 host LOCAL
        /0 universe UNICAST
     +-- 127.0.0.0/8 2 0 2
        +-- 127.0.0.0/31 1 0 0
           |-- 127.0.0.0
              /32 link BROADCAST
              /8 host LOCAL
           |-- 127.0.0.1
              /32 host LOCAL
        |-- 127.255.255.255
           /32 link BROADCAST
     +-- 192.168.3.0/24 2 1 2
        +-- 192.168.3.0/26 2 0 2
           |-- 192.168.3.0
              /32 link BROADCAST
              /24 link UNICAST
           |-- 192.168.3.62
              /32 host LOCAL
        |-- 192.168.3.255
           /32 link BROADCAST
Local:
  +-- 0.0.0.0/0 3 0 5
     |-- 0.0.0.0
        /0 host LOCAL
        /0 universe UNICAST
     +-- 127.0.0.0/8 2 0 2
        +-- 127.0.0.0/31 1 0 0
           |-- 127.0.0.0
              /32 link BROADCAST
              /8 host LOCAL
           |-- 127.0.0.1
              /32 host LOCAL
        |-- 127.255.255.255
           /32 link BROADCAST
     +-- 192.168.3.0/24 2 1 2
        +-- 192.168.3.0/26 2 0 2
           |-- 192.168.3.0
              /32 link BROADCAST
              /24 link UNICAST
           |-- 192.168.3.62
              /32 host LOCAL
        |-- 192.168.3.255
           /32 link BROADCAST

The contents of the main table and the local table are actually the same! W=
hat is this strange phenomenon?

The strange thing is not over yet, then I accidentally added a policy route=
.

ip rule add table 100 priority 10

ip rule
0:=09from all lookup local
10:=09from all lookup 100
32766:=09from all lookup main
32767:=09from all lookup default

I added table 100 with a priority of 10.So the RPDB has become like the abo=
ve.

The miracle happened, the local table and the main table restored what I th=
ought it should be, they were separated!

/proc/net/fib_trie

Main:
  +-- 0.0.0.0/0 3 0 6
     |-- 0.0.0.0
        /0 universe UNICAST
     |-- 192.168.3.0
        /24 link UNICAST
Local:
  +-- 0.0.0.0/0 3 0 5
     |-- 0.0.0.0
        /0 host LOCAL
     +-- 127.0.0.0/8 2 0 2
        +-- 127.0.0.0/31 1 0 0
           |-- 127.0.0.0
              /32 link BROADCAST
              /8 host LOCAL
           |-- 127.0.0.1
              /32 host LOCAL
        |-- 127.255.255.255
           /32 link BROADCAST
     +-- 192.168.3.0/24 2 1 2
        +-- 192.168.3.0/26 2 0 2
           |-- 192.168.3.0
              /32 link BROADCAST
           |-- 192.168.3.62
              /32 host LOCAL
        |-- 192.168.3.255
           /32 link BROADCAST

So I immediately conducted the previous test.

ip route get 1.1.1.1
local 1.1.1.1 dev lo table local src 1.1.1.1 uid 0
    cache <local>

ip route get 192.168.3.100
local 192.168.3.100 dev lo table local src 192.168.3.100 uid 0
    cache <local>

The result is correct this time, both 1.1.1.1 and 192.168.3.100 are routed =
to the lo interface. And from the "table local" in the output, it seems tha=
t this time the local table is actually used.

Now I have a drink, which is really too ridiculous...

ip rule del table 100

Then I deleted the policy route I just added.

ip rule
0:=09from all lookup local
32766:=09from all lookup main
32767:=09from all lookup default

The RPDB recovered from the beginning, but the magic is that the main and l=
ocal tables are still separate and not merged as they did at the beginning.

Main:
  +-- 0.0.0.0/0 3 0 6
     |-- 0.0.0.0
        /0 universe UNICAST
     |-- 192.168.3.0
        /24 link UNICAST
Local:
  +-- 0.0.0.0/0 3 0 5
     |-- 0.0.0.0
        /0 host LOCAL
     +-- 127.0.0.0/8 2 0 2
        +-- 127.0.0.0/31 1 0 0
           |-- 127.0.0.0
              /32 link BROADCAST
              /8 host LOCAL
           |-- 127.0.0.1
              /32 host LOCAL
        |-- 127.255.255.255
           /32 link BROADCAST
     +-- 192.168.3.0/24 2 1 2
        +-- 192.168.3.0/26 2 0 2
           |-- 192.168.3.0
              /32 link BROADCAST
           |-- 192.168.3.62
              /32 host LOCAL
        |-- 192.168.3.255
           /32 link BROADCAST

And the previous routing test is still correct, 1.1.1.1 and 192.168.3.100 a=
re routed to lo.

ip route get 1.1.1.1
local 1.1.1.1 dev lo table local src 1.1.1.1 uid 0
    cache <local>

ip route get 192.168.3.100
local 192.168.3.100 dev lo table local src 192.168.3.100 uid 0
    cache <local>

The same RPDB will produce different results! This is even more ridiculous,=
 so I went to have a drink again...

I began to understand that this is a man-made implementation error, not a m=
istake in my use.

So, I have been at Google for a long time, and in the end I found Commit 0d=
dcf43d5d4a, which is the root cause of the above problems.

In this patch, in order to improve efficiency, the local table and the main=
 table are merged, and the local table is re-separated from the main table =
when the custom FIB rule is enabled.

This is in full compliance with the situation I described above, yes, it is=
 caused by this patch.

Then we can discuss it now.

Obviously, merging the main table and the local table breaks the rules of t=
he routing table priority. The local table should be searched independently=
 before the main table.

Perhaps as described in this patch, this can have some performance improvem=
ents, but is it worthwhile to have a little bit of performance improvement =
that undermines the entire routing rule? This is worth thinking about.

Suppose now that a software engineer wants to add 192.168.0.0/16 to the loc=
al address, so he naturally executed the following command.

ip route add local 192.168.0.0/16 dev lo

But he does not know that there is a trap in the main table, another overla=
pping route!

ip route
192.168.3.0/24 dev wlan0 proto kernel scope link src 192.168.3.62 metric 60=
0

ip route get 192.168.1.100
local 192.168.1.100 dev lo src 192.168.1.100 uid 0
    cache <local>

ip route get 192.168.3.100
192.168.3.100 dev wlan0 src 192.168.3.62 uid 0
    cache

This will cause the entire network of 192.168.3.0/24 not to be routed to th=
e local lo interface as he thought!

This will lead to bugs that are very difficult to find! If I am not a progr=
ammer who knows a little about the kernel implementation, I can't find out =
what caused the problem (I checked a lot of source code and read a lot of p=
atches and kernel mail to solve this problem).

Of course, you can say that no one will modify the local routing table unde=
r normal circumstances. But is the linux system also designed for geeks? Is=
 it also designed for programmers who want to exploit the full potential of=
 the system?

If you provide a mechanism to modify the local table, you must ensure that =
the mechanism is working correctly.

And it's absolutely impossible to make this mechanism a significant differe=
nce in the execution process after triggering some incredible conditions (c=
ustom FIB rules are enabled, even if they are later disabled).

In summary, I don't think this Commit 0ddcf43d5d4a is a good idea.

Welcome to discuss.
