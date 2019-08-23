Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E20509AECF
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 14:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390742AbfHWMKv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 23 Aug 2019 08:10:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38842 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730989AbfHWMKu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 08:10:50 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 149C41801594;
        Fri, 23 Aug 2019 12:10:50 +0000 (UTC)
Received: from [10.36.116.150] (ovpn-116-150.ams2.redhat.com [10.36.116.150])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6FD2526377;
        Fri, 23 Aug 2019 12:10:47 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Ilya Maximets" <i.maximets@samsung.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@intel.com>,
        "Magnus Karlsson" <magnus.karlsson@intel.com>,
        "Jakub Kicinski" <jakub.kicinski@netronome.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        "William Tu" <u9012063@gmail.com>,
        "Alexander Duyck" <alexander.duyck@gmail.com>
Subject: Re: [PATCH net v3] ixgbe: fix double clean of tx descriptors with xdp
Date:   Fri, 23 Aug 2019 14:10:45 +0200
Message-ID: <660415CE-6748-4749-84D6-7007F69D8EFB@redhat.com>
In-Reply-To: <20190822171237.20798-1-i.maximets@samsung.com>
References: <CGME20190822171243eucas1p12213f2239d6c36be515dade41ed7470b@eucas1p1.samsung.com>
 <20190822171237.20798-1-i.maximets@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.63]); Fri, 23 Aug 2019 12:10:50 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22 Aug 2019, at 19:12, Ilya Maximets wrote:

> Tx code doesn't clear the descriptors' status after cleaning.
> So, if the budget is larger than number of used elems in a ring, some
> descriptors will be accounted twice and xsk_umem_complete_tx will move
> prod_tail far beyond the prod_head breaking the completion queue ring.
>
> Fix that by limiting the number of descriptors to clean by the number
> of used descriptors in the tx ring.
>
> 'ixgbe_clean_xdp_tx_irq()' function refactored to look more like
> 'ixgbe_xsk_clean_tx_ring()' since we're allowed to directly use
> 'next_to_clean' and 'next_to_use' indexes.
>
> Fixes: 8221c5eba8c1 ("ixgbe: add AF_XDP zero-copy Tx support")
> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
> ---
>
> Version 3:
>   * Reverted some refactoring made for v2.
>   * Eliminated 'budget' for tx clean.
>   * prefetch returned.
>
> Version 2:
>   * 'ixgbe_clean_xdp_tx_irq()' refactored to look more like
>     'ixgbe_xsk_clean_tx_ring()'.
>
>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 29 
> ++++++++------------
>  1 file changed, 11 insertions(+), 18 deletions(-)
>

Did some test with and without the fix applied. For PVP the results are 
a little different depending on the packet size (note this is a single 
run, no deviation).
For the same physical port in and out it’s faster! Note this was OVS 
AF_XDP using a XENA tester at 10G wire speed.


+--------------------------------------------------------------------------------+
| Physical to Virtual to Physical test, L3 flows[port redirect]          
         |
+-----------------+--------------------------------------------------------------+
|                 | Packet size                                          
         |
+-----------------+--------+--------+--------+--------+--------+--------+--------+
| Number of flows |   64   |  128   |  256   |  512   |  768   |  1024  
|  1514  |
+-----------------+--------+--------+--------+--------+--------+--------+--------+
| [NO FIX]   1000 | 739161 | 700091 | 690034 | 659894 | 618128 | 594223 
| 537504 |
+-----------------+--------+--------+--------+--------+--------+--------+--------+
| [FIX]      1000 | 742317 | 708391 | 689952 | 658034 | 626056 | 587653 
| 530885 |
+-----------------+--------+--------+--------+--------+--------+--------+--------+

+--------------------------------------------------------------------------------------+
| Physical loopback test, L3 flows[port redirect]                        
               |
+-----------------+--------------------------------------------------------------------+
|                 | Packet size                                          
               |
+-----------------+---------+---------+---------+---------+---------+---------+--------+
| Number of flows |   64    |   128   |   256   |   512   |   768   |  
1024   |  1514  |
+-----------------+---------+---------+---------+---------+---------+---------+--------+
| [NO FIX]   1000 | 2573298 | 2227578 | 2514318 | 2298204 | 1081861 | 
1015173 | 788081 |
+-----------------+---------+---------+---------+---------+---------+---------+--------+
| [FIX]      1000 | 3343188 | 3234993 | 3151833 | 2349597 | 1586276 | 
1197304 | 814854 |
+-----------------+---------+---------+---------+---------+---------+---------+--------+


Tested-by: Eelco Chaudron <echaudro@redhat.com>
