Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AAEC10E5B
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 23:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbfEAVDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 17:03:33 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:38843 "EHLO
        caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726120AbfEAVDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 17:03:33 -0400
Received: by caffeine.csclub.uwaterloo.ca (Postfix, from userid 20367)
        id 2E52D461D3A; Wed,  1 May 2019 16:52:16 -0400 (EDT)
Date:   Wed, 1 May 2019 16:52:16 -0400
To:     linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Len Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: i40e X722 RSS problem with NAT-Traversal IPsec packets
Message-ID: <20190501205215.ptoi2czhklte5jbm@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
From:   lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have hit a strange problem with RSS on the X722 on our new servers
(S2600WFT based).

The RSS hash is distributing most packets across cores quite nicely, with
one exception.  ESP encapsulated in UDP is always going to queue 0 no
matter what the hash key is set to or how many cores have queues assigned.
So if terminating IPsec tunnels that are using NAT-Traversal, all packets
arrive on the same core, which clearly isn't good for scalability.
Other UDP packets are fine, TCP is fine, ICMP, ESP, etc have no problem
that we have seen, only the ESP in UDP packets.

Given the packets are UDP packets I would have hoped they would just
be distributed using the source and destination ip and port values as
other UDP packets seem to be, but they are not.  I vaguely suspect the
UDP tunnel handling support the card has for this since it claims to
use the internal packet's values for RSS rather than the UDP packet
itself for certain supported types of UDP encapsulated IP traffic, but
not ESP in UDP, so perhaps it sees an IP packet inside a UDP packet,
and decides to try and parse it instead, doesn't know how to handle it
and stops without assigning any RSS value to the packet at all rather
than falling back to treating it as a plain UDP packet.  But that's just
guessing based on the documentation of the hardware capabilities.

Here is an example of a packet that always hits queue 0:

14:48:09.014360 54:ee:75:30:f1:e1 > a4:bf:01:4e:0c:87, ethertype IPv4 (0x0800), length 174: (tos 0x0, ttl 64, id 3312, offset 0, flags [DF], proto UDP (17), length 160)
    1.99.99.2.4500 > 1.99.99.1.4500: [no cksum] UDP-encap: ESP(spi=0xac11cadf,seq=0x480), length 132
        0x0000:  4500 00a0 0cf0 4000 4011 6494 0163 6302  E.....@.@.d..cc.
        0x0010:  0163 6301 1194 1194 008c 0000 ac11 cadf  .cc.............
        0x0020:  0000 0480 901d 3b39 e884 0616 fed4 3e37  ......;9......>7
        0x0030:  bb67 bca2 adac e519 c7a9 ced9 00bf 263e  .g............&>
        0x0040:  28a6 ba38 1e8c e6e3 bbf9 e093 1c49 8154  (..8.........I.T
        0x0050:  0d66 c1d5 2416 f4d2 26ec f5a1 773f 4ae2  .f..$...&...w?J.
        0x0060:  8e26 0ed8 0e5f daab 06b2 aa51 2f2f e16e  .&..._.....Q//.n
        0x0070:  22ca dd94 f499 027b 11d0 de7b 4d9d 7af1  "......{...{M.z.
        0x0080:  f468 ae0d ad41 5c96 577d 7b44 1cc4 0ba3  .h...A\.W}{D....
        0x0090:  9ff7 142f b159 c9d0 38e1 c460 120f f4bb  .../.Y..8..`....
14:48:09.014439 a4:bf:01:4e:0c:87 > 54:ee:75:30:f1:e1, ethertype IPv4 (0x0800), length 174: (tos 0x0, ttl 64, id 43796, offset 0, flags [none], proto UDP (17), length 160)
    1.99.99.1.4500 > 1.99.99.2.4500: [no cksum] UDP-encap: ESP(spi=0x47f5919c,seq=0x480), length 132
        0x0000:  4500 00a0 ab14 0000 4011 0670 0163 6301  E.......@..p.cc.
        0x0010:  0163 6302 1194 1194 008c 0000 47f5 919c  .cc.........G...
        0x0020:  0000 0480 106b cafb 14ee f75b 3533 16fb  .....k.....[53..
        0x0030:  87f5 9d90 a73b 8daf 481f 22b7 2b30 b482  .....;..H.".+0..
        0x0040:  a330 1fe4 59da a394 b48b ac77 5a96 dfac  .0..Y......wZ...
        0x0050:  4798 793a ca7e 1af2 a9a8 2f7b 9327 d5b9  G.y:.~..../{.'..
        0x0060:  f8d0 e761 c7b3 a85c c843 ec25 62b2 e083  ...a...\.C.%b...
        0x0070:  f0d5 1097 736b 051a b15d e7de 7f0e b5b7  ....sk...]......
        0x0080:  209b 4d1d af37 c1a1 09a0 a6c9 71cf 7d54  ..M..7......q.}T
        0x0090:  55c3 2797 e622 581f 09cf 9483 2ba5 e64a  U.'.."X.....+..J

This was done on 4.19.28 kernel with the i40e driver in that kernel with
libreswan for IPsec using netkey in the kernel and nat-traversal in use.
The packets are a ping echo and reply pair.  NVM version 3.49 and 4.00
tried so far.

No other network interfaces we have used have had this problem.  RSS has
always just worked until now.

-- 
Len Sorensen
