Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15043130FD
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 17:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbfECPOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 11:14:24 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:55861 "EHLO
        caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726468AbfECPOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 11:14:24 -0400
Received: by caffeine.csclub.uwaterloo.ca (Postfix, from userid 20367)
        id 60E64461D3A; Fri,  3 May 2019 11:14:21 -0400 (EDT)
Date:   Fri, 3 May 2019 11:14:21 -0400
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Subject: Re: [Intel-wired-lan] i40e X722 RSS problem with NAT-Traversal IPsec
 packets
Message-ID: <20190503151421.akvmu77lghxcouni@csclub.uwaterloo.ca>
References: <20190501205215.ptoi2czhklte5jbm@csclub.uwaterloo.ca>
 <CAKgT0UczVvREiXwde6yJ8_i9RT2z7FhenEutXJKW8AmDypn_0g@mail.gmail.com>
 <20190502151140.gf5ugodqamtdd5tz@csclub.uwaterloo.ca>
 <CAKgT0Uc_OUAcPfRe6yCSwpYXCXomOXKG2Yvy9c1_1RJn-7Cb5g@mail.gmail.com>
 <20190502171636.3yquioe3gcwsxlus@csclub.uwaterloo.ca>
 <CAKgT0Ufk8LXMb9vVWfvgbjbQFKAuenncf95pfkA0P1t-3+Ni_g@mail.gmail.com>
 <20190502175513.ei7kjug3az6fe753@csclub.uwaterloo.ca>
 <20190502185250.vlsainugtn6zjd6p@csclub.uwaterloo.ca>
 <CAKgT0Uc_YVzns+26-TL+hhmErqG4_w4evRqLCaa=7nME7Zq+Vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0Uc_YVzns+26-TL+hhmErqG4_w4evRqLCaa=7nME7Zq+Vg@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
From:   lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 02, 2019 at 01:59:46PM -0700, Alexander Duyck wrote:
> If I recall correctly RSS is only using something like the lower 9
> bits (indirection table size of 512) of the resultant hash on the
> X722, even fewer if you have fewer queues that are a power of 2 and
> happen to program the indirection table in a round robin fashion. So
> for example on my system setup with 32 queues it is technically only
> using the lower 5 bits of the hash.
> 
> One issue as a result of that is that you can end up with swaths of
> bits that don't really seem to impact the hash all that much since it
> will never actually change those bits of the resultant hash. In order
> to guarantee that every bit in the input impacts the hash you have to
> make certain you have to gaps in the key wider than the bits you
> examine in the final hash.
> 
> A quick and dirty way to verify that the hash key is part of the issue
> would be to use something like a simple repeating value such as AA:55
> as your hash key. With something like that every bit you change in the
> UDP port number should result in a change in the final RSS hash for
> queue counts of 3 or greater. The downside is the upper 16 bits of the
> hash are identical to the lower 16 so the actual hash value itself
> isn't as useful.

OK I set the hkey to
aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55
and still only see queue 0 and 2 getting hit with a couple of dozen
different UDP port numbers I picked.  Changing the hash with ethtool to
that didn't even move where the tcp packets for my ssh connection are
going (they are always on queue 2 it seems).

Does it just not hash UDP packets correctly?  Is it even doing RSS?
(the register I checked claimed it is).

This system has 40 queues assigned by default since that is how many
CPUs there are.  Changing it to a lower number didn't make a difference
(I tried 32 and 8).

-- 
Len Sorensen
