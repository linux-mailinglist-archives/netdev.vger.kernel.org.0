Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DADD95969E
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 10:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfF1I5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 04:57:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:49184 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725873AbfF1I5U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 04:57:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CB729AE36;
        Fri, 28 Jun 2019 08:57:18 +0000 (UTC)
Date:   Fri, 28 Jun 2019 17:57:13 +0900
From:   Benjamin Poirier <bpoirier@suse.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev <GR-Linux-NIC-Dev@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [EXT] [PATCH net-next 03/16] qlge: Deduplicate lbq_buf_size
Message-ID: <20190628085713.GB14978@f1>
References: <20190617074858.32467-1-bpoirier@suse.com>
 <20190617074858.32467-3-bpoirier@suse.com>
 <DM6PR18MB2697BAC4CA9B876306BEDBEBABE20@DM6PR18MB2697.namprd18.prod.outlook.com>
 <20190626113726.GB27420@f1>
 <CA+FuTSfKw6aaXk0hA0p_AUp9Oa_D+5Bwst8HUz7mJM-wO5Obow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+FuTSfKw6aaXk0hA0p_AUp9Oa_D+5Bwst8HUz7mJM-wO5Obow@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/06/26 11:42, Willem de Bruijn wrote:
> On Wed, Jun 26, 2019 at 7:37 AM Benjamin Poirier <bpoirier@suse.com> wrote:
> >
> > On 2019/06/26 09:24, Manish Chopra wrote:
> > > > -----Original Message-----
> > > > From: Benjamin Poirier <bpoirier@suse.com>
> > > > Sent: Monday, June 17, 2019 1:19 PM
> > > > To: Manish Chopra <manishc@marvell.com>; GR-Linux-NIC-Dev <GR-Linux-
> > > > NIC-Dev@marvell.com>; netdev@vger.kernel.org
> > > > Subject: [EXT] [PATCH net-next 03/16] qlge: Deduplicate lbq_buf_size
> > > >
> > > > External Email
> > > >
> > > > ----------------------------------------------------------------------
> > > > lbq_buf_size is duplicated to every rx_ring structure whereas lbq_buf_order is
> > > > present once in the ql_adapter structure. All rings use the same buf size, keep
> > > > only one copy of it. Also factor out the calculation of lbq_buf_size instead of
> > > > having two copies.
> > > >
> > > > Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
> > > > ---
> > [...]
> > >
> > > Not sure if this change is really required, I think fields relevant to rx_ring should be present in the rx_ring structure.
> > > There are various other fields like "lbq_len" and "lbq_size" which would be same for all rx rings but still under the relevant rx_ring structure.
> 
> The one argument against deduplicating might be if the original fields
> are in a hot cacheline and the new location adds a cacheline access to
> a hot path. Not sure if that is relevant here. But maybe something to
> double check.
> 

Thanks for the hint. I didn't check before because my hunch was that
this driver is not near that level of optimization but I checked now and
got the following results.

The other side of the link is doing pktgen of 257B frames (smallest to
exercise the lbq path), over 10 runs of 100s, number of frames received
by the stack before/after applying this patch:
before: 1487000±2000pps
after: 1538000±2000pps
(3.4% improvement)

Looking with perf stat, boiling down the numbers to be per packet, most
interesting differences are:
cycles -4.32%
instructions -0.97%
L1-dcache-loads +6.30%
L1-dcache-load-misses -1.26%
LLC-loads +2.93%
LLC-load-misses -1.16%

So, fewer cycles/packet, fewer cache misses. Note however that
L1-dcache-loads had high variability between runs (~12%).

Looking with pahole, struct rx_ring is reduced by 8 bytes but its a 784
bytes structure full of holes to begin with.

Numbers are from an old Xeon E3-1275

Full output follows:
root@dtest:~# cat /tmp/mini.sh
#!/bin/bash

da=$(ethtool -S ql1 | awk '/rx_nic_fifo_drop/ {print $2}')
ra=$(ip -s link show dev ql1 | awk 'NR == 4 {print $2}')
sleep 100
db=$(ethtool -S ql1 | awk '/rx_nic_fifo_drop/ {print $2}')
rb=$(ip -s link show dev ql1 | awk 'NR == 4 {print $2}')
echo "rx $((rb - ra))"
echo "dropped $((db - da))"

root@dtest:~# perf stat -a -r10 -d /tmp/mini.sh
rx 148763519
dropped 296128797
rx 148784865
dropped 296107878
rx 148675349
dropped 296217234
rx 148634271
dropped 296260358
rx 148813581
dropped 296089785
rx 148755713
dropped 296136071
rx 148434116
dropped 296459743
rx 148390638
dropped 296501405
rx 148500812
dropped 296391286
rx 148973912
dropped 295920014

 Performance counter stats for 'system wide' (10 runs):

        800,245.24 msec cpu-clock                 #    8.000 CPUs utilized            ( +-  0.00% )
            11,559      context-switches          #   14.445 M/sec                    ( +-  0.13% )
                36      cpu-migrations            #    0.044 M/sec                    ( +-  7.11% )
            62,100      page-faults               #   77.601 M/sec                    ( +-  0.51% )
   362,221,639,977      cycles                    # 452638.486 GHz                    ( +-  0.77% )  (49.92%)
   515,318,132,327      instructions              #    1.42  insn per cycle           ( +-  0.64% )  (62.42%)
    91,744,969,260      branches                  # 114646115.533 M/sec               ( +-  0.04% )  (62.50%)
       549,681,601      branch-misses             #    0.60% of all branches          ( +-  0.25% )  (62.50%)
   115,207,692,963      L1-dcache-loads           # 143965544.751 M/sec               ( +- 12.09% )  (40.59%)
     2,629,809,584      L1-dcache-load-misses     #    2.28% of all L1-dcache hits    ( +-  3.24% )  (29.90%)
       837,806,984      LLC-loads                 # 1046938.235 M/sec                 ( +-  0.73% )  (25.31%)
       569,343,079      LLC-load-misses           #   67.96% of all LL-cache hits     ( +-  0.07% )  (37.50%)

         100.03177 +- 0.00104 seconds time elapsed  ( +-  0.00% )

#
# changed the driver now to include this patch
#

root@dtest:~# perf stat -a -r10 -d /tmp/mini.sh
rx 154094001
dropped 290799944
rx 153798301
dropped 291094799
rx 153942166
dropped 290950792
rx 154150506
dropped 290743194
rx 154179791
dropped 290712400
rx 153907213
dropped 290985227
rx 153813515
dropped 291078475
rx 153603554
dropped 291289250
rx 153521414
dropped 291372145
rx 153592955
dropped 291299734

 Performance counter stats for 'system wide' (10 runs):

        800,234.85 msec cpu-clock                 #    8.000 CPUs utilized            ( +-  0.00% )
            12,061      context-switches          #   15.072 M/sec                    ( +-  0.61% )
                32      cpu-migrations            #    0.040 M/sec                    ( +-  8.40% )
            62,210      page-faults               #   77.740 M/sec                    ( +-  0.60% )
   358,454,546,598      cycles                    # 447936.882 GHz                    ( +-  1.34% )  (49.84%)
   527,804,259,267      instructions              #    1.47  insn per cycle           ( +-  1.11% )  (62.35%)
    94,904,030,904      branches                  # 118595275.389 M/sec               ( +-  0.05% )  (62.50%)
       568,214,180      branch-misses             #    0.60% of all branches          ( +-  0.12% )  (62.50%)
   126,667,377,528      L1-dcache-loads           # 158287823.791 M/sec               ( +- 12.48% )  (41.21%)
     2,685,865,791      L1-dcache-load-misses     #    2.12% of all L1-dcache hits    ( +-  4.01% )  (29.42%)
       891,939,954      LLC-loads                 # 1114598.225 M/sec                 ( +-  0.73% )  (25.16%)
       582,037,612      LLC-load-misses           #   65.26% of all LL-cache hits     ( +-  0.09% )  (37.50%)

       100.0307117 +- 0.0000810 seconds time elapsed  ( +-  0.00% )
