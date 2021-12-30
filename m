Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C21848191A
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 04:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235580AbhL3D6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 22:58:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:3816 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233004AbhL3D6Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Dec 2021 22:58:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640836704; x=1672372704;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qA4qXuFzsM17bl0+F2oanP1CfIWqGLkjjVJzEV1J2zo=;
  b=E/dFu0CDa7s3TZypsF9k+sUy6hWPXYBdFnePGSqNZ9bSyfvA/qgsvj+t
   KiAdQR3mjs8uyaZf+xxxUEfQ/B+u5uGOZVcEk7ipheKaIlhN76cxAry4U
   rt6JHJChIrcWqp5UJkaRpy3yUQwoQIv6TwX+glTkm4CDhT+dhTQicN+ID
   aISEua7XPqR5gzSuNIhEk/CkUMI2DegwTWKMkS5cwI72/JDYTaxMSojqZ
   KHDV7+A7iLzR739P7W0cWgZOyKvNRmOnglGxBKUI35Z+IoGd6BdEEQ4Ii
   JItpd3wzAtm9KBk/y4TNGf9fjZ9hbrc5ZLdiEIbw6DxhRedZQtjLauYxW
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10212"; a="239154609"
X-IronPort-AV: E=Sophos;i="5.88,247,1635231600"; 
   d="scan'208";a="239154609"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2021 19:58:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,247,1635231600"; 
   d="scan'208";a="609801520"
Received: from p12hl98bong5.png.intel.com ([10.158.65.178])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Dec 2021 19:58:20 -0800
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     bjorn@kernel.org, Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH bpf-next v2 0/7] samples/bpf: xdpsock app enhancements
Date:   Thu, 30 Dec 2021 11:54:40 +0800
Message-Id: <20211230035447.523177-1-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First of all, sorry for taking more time to get back to this series and
thanks to all valuble feedback in series-1 at [1] from Jesper and Song
Liu.

Since then I have looked into what Jesper suggested in [2] and worked on
revising the patch series into several patches for ease of review:

v1->v2:
1/7: [No change]. Add VLAN tag (ID & Priority) to the generated Tx-Only
     frames.

2/7: [No change]. Add DMAC and SMAC setting to the generated Tx-Only
     frames. If parameters are not set, previous DMAC and SMAC are used.

3/7: [New]. Add support for selecting different CLOCK for clock_gettime()
     used in get_nsecs.

4/7: [New]. This is a total rework from series-1 3/4-patch [3]. It uses
     clock_nanosleep() suggested by Jesper. In addition, added statistic
     for Tx schedule variance under application stat (-a|--app-stats).
     Make the cyclic Tx operation and --poll mode to be mutually-
     exclusive. Still, the ability to specify TX cycle time and used
     together with batch size and packet count remain the same.

5/7: [New]. Add the support for TX process schedule policy and priority
     setting. By default, SCHED_OTHER policy is used. This too is matching
     the schedule policy setting in [2].

6/7: [Change]. This is update from series-1 4/4-patch [4]. Added TX clean
     process time-out in 1s granularity with configurable retries count
     (-O|--retries).

7/7: [New]. Added timestamp for TX packet following pktgen_hdr format
     matching the implementation in [2]. However, the sequence ID remains
     the same as it is instead of process schedule diff in [2].

To summarize on what program options have been added with v2 series
using an example below:-

 DMAC (-G)                 = fa:8d:f1:e2:0b:e8
 SMAC (-H)                 = ce:17:07:17:3e:3a

 VLAN tagged (-V)
 VLAN ID (-J)              = 12
 VLAN Pri (-K)             = 3

 Tx Queue (-q)             = 3
 Cycle Time in us (-T)     = 1000
 Batch (-b)                = 2
 Packet Count              = 6
 Tx schedule policy (-W)   = FIFO
 Tx schedule priority (-U) = 50
 Clock selection (-w)      = REALTIME

 Tx timeout retries(-O)    = 5
 Tx timestamp (-y)
 Cyclic Tx schedule stat (-a)

Note: xdpsock sets UDP dest-port and src-port to 0x1000 as default.

 Sending Board
 =============
 $ xdpsock -i eth0 -t -N -z -H ce:17:07:17:3e:3a -G fa:8d:f1:e2:0b:e8 \
   -V -J 12 -K 3 -q 3 \
   -T 1000 -b 2 -C 6 -W FIFO -U 50 -w REALTIME \
   -O 5 -y -a

  sock0@eth0:3 txonly xdp-drv
                    pps            pkts           0.00
 rx                 0              0
 tx                 0              6

                    calls/s        count
 rx empty polls     0              0
 fill fail polls    0              0
 copy tx sendtos    0              0
 tx wakeup sendtos  0              5
 opt polls          0              0

                    period     min        ave        max        cycle
 Cyclic TX          1000000    31033      32009      33397      3

 Receiving Board
 ===============
 $ tcpdump -nei eth0 udp port 0x1000 -vv -Q in -X \
    --time-stamp-precision nano
tcpdump: listening on eth0, link-type EN10MB (Ethernet), capture size 262144 bytes
03:46:40.520111580 ce:17:07:17:3e:3a > fa:8d:f1:e2:0b:e8, ethertype 802.1Q (0x8100), length 62: vlan 12, p 3, ethertype IPv4, (tos 0x0, ttl 64, id 0, offset 0, flags [none], proto UDP (17), length 44)
    10.10.10.16.4096 > 10.10.10.32.4096: [udp sum ok] UDP, length 16
        0x0000:  4500 002c 0000 0000 4011 527e 0a0a 0a10  E..,....@.R~....
        0x0010:  0a0a 0a20 1000 1000 0018 e997 be9b e955  ...............U
        0x0020:  0000 0000 61cd 2ba1 0006 987c            ....a.+....|
03:46:40.520112163 ce:17:07:17:3e:3a > fa:8d:f1:e2:0b:e8, ethertype 802.1Q (0x8100), length 62: vlan 12, p 3, ethertype IPv4, (tos 0x0, ttl 64, id 0, offset 0, flags [none], proto UDP (17), length 44)
    10.10.10.16.4096 > 10.10.10.32.4096: [udp sum ok] UDP, length 16
        0x0000:  4500 002c 0000 0000 4011 527e 0a0a 0a10  E..,....@.R~....
        0x0010:  0a0a 0a20 1000 1000 0018 e996 be9b e955  ...............U
        0x0020:  0000 0001 61cd 2ba1 0006 987c            ....a.+....|
03:46:40.521066860 ce:17:07:17:3e:3a > fa:8d:f1:e2:0b:e8, ethertype 802.1Q (0x8100), length 62: vlan 12, p 3, ethertype IPv4, (tos 0x0, ttl 64, id 0, offset 0, flags [none], proto UDP (17), length 44)
    10.10.10.16.4096 > 10.10.10.32.4096: [udp sum ok] UDP, length 16
        0x0000:  4500 002c 0000 0000 4011 527e 0a0a 0a10  E..,....@.R~....
        0x0010:  0a0a 0a20 1000 1000 0018 e5af be9b e955  ...............U
        0x0020:  0000 0002 61cd 2ba1 0006 9c62            ....a.+....b
03:46:40.521067012 ce:17:07:17:3e:3a > fa:8d:f1:e2:0b:e8, ethertype 802.1Q (0x8100), length 62: vlan 12, p 3, ethertype IPv4, (tos 0x0, ttl 64, id 0, offset 0, flags [none], proto UDP (17), length 44)
    10.10.10.16.4096 > 10.10.10.32.4096: [udp sum ok] UDP, length 16
        0x0000:  4500 002c 0000 0000 4011 527e 0a0a 0a10  E..,....@.R~....
        0x0010:  0a0a 0a20 1000 1000 0018 e5ae be9b e955  ...............U
        0x0020:  0000 0003 61cd 2ba1 0006 9c62            ....a.+....b
03:46:40.522061935 ce:17:07:17:3e:3a > fa:8d:f1:e2:0b:e8, ethertype 802.1Q (0x8100), length 62: vlan 12, p 3, ethertype IPv4, (tos 0x0, ttl 64, id 0, offset 0, flags [none], proto UDP (17), length 44)
    10.10.10.16.4096 > 10.10.10.32.4096: [udp sum ok] UDP, length 16
        0x0000:  4500 002c 0000 0000 4011 527e 0a0a 0a10  E..,....@.R~....
        0x0010:  0a0a 0a20 1000 1000 0018 e1c5 be9b e955  ...............U
        0x0020:  0000 0004 61cd 2ba1 0006 a04a            ....a.+....J
03:46:40.522062173 ce:17:07:17:3e:3a > fa:8d:f1:e2:0b:e8, ethertype 802.1Q (0x8100), length 62: vlan 12, p 3, ethertype IPv4, (tos 0x0, ttl 64, id 0, offset 0, flags [none], proto UDP (17), length 44)
    10.10.10.16.4096 > 10.10.10.32.4096: [udp sum ok] UDP, length 16
        0x0000:  4500 002c 0000 0000 4011 527e 0a0a 0a10  E..,....@.R~....
        0x0010:  0a0a 0a20 1000 1000 0018 e1c4 be9b e955  ...............U
        0x0020:  0000 0005 61cd 2ba1 0006 a04a            ....a.+....J

I have tested the above with both tagged and untagged packet format and
based on the timestamp in tcpdump found that the timing of the batch
cyclic transmission is correct.

Appreciate if community can give the patch series v2 a try and point out
any gap.

Thanks
Boon Leong

[1] https://patchwork.kernel.org/project/netdevbpf/cover/20211124091821.3916046-1-boon.leong.ong@intel.com/
[2] https://github.com/netoptimizer/network-testing/blob/master/src/udp_pacer.c
[3] https://patchwork.kernel.org/project/netdevbpf/patch/20211124091821.3916046-4-boon.leong.ong@intel.com/
[4] https://patchwork.kernel.org/project/netdevbpf/patch/20211124091821.3916046-5-boon.leong.ong@intel.com/

Ong Boon Leong (7):
  samples/bpf: xdpsock: add VLAN support for Tx-only operation
  samples/bpf: xdpsock: add Dest and Src MAC setting for Tx-only
    operation
  samples/bpf: xdpsock: add clockid selection support
  samples/bpf: xdpsock: add cyclic TX operation capability
  samples/bpf: xdpsock: add sched policy and priority support
  samples/bpf: xdpsock: add time-out for cleaning Tx
  samples/bpf: xdpsock: add timestamp for Tx-only operation

 samples/bpf/xdpsock_user.c | 363 ++++++++++++++++++++++++++++++++++---
 1 file changed, 341 insertions(+), 22 deletions(-)

-- 
2.25.1

