Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2766911C4F
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 17:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbfEBPLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 11:11:43 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:52225 "EHLO
        caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726270AbfEBPLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 11:11:42 -0400
Received: by caffeine.csclub.uwaterloo.ca (Postfix, from userid 20367)
        id 3485F461D3A; Thu,  2 May 2019 11:11:40 -0400 (EDT)
Date:   Thu, 2 May 2019 11:11:40 -0400
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Subject: Re: [Intel-wired-lan] i40e X722 RSS problem with NAT-Traversal IPsec
 packets
Message-ID: <20190502151140.gf5ugodqamtdd5tz@csclub.uwaterloo.ca>
References: <20190501205215.ptoi2czhklte5jbm@csclub.uwaterloo.ca>
 <CAKgT0UczVvREiXwde6yJ8_i9RT2z7FhenEutXJKW8AmDypn_0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UczVvREiXwde6yJ8_i9RT2z7FhenEutXJKW8AmDypn_0g@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
From:   lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 01, 2019 at 03:52:57PM -0700, Alexander Duyck wrote:
> I'm not sure how RSS will do much for you here. Basically you only
> have the source IP address as your only source of entropy when it
> comes to RSS since the destination IP should always be the same if you
> are performing a server role and terminating packets on the local
> system and as far as the ports in your example you seem to only be
> using 4500 for both the source and the destination.

I have thousands of IPsec clients connecting.  Simply treating them as
normal UDP packets would work.  The IP address is different, and often
the port too.

> In your testing are you only looking at a point to point connection
> between two systems, or do you have multiple systems accessing the
> system you are testing? I ask as the only way this should do any
> traffic spreading via RSS would be if the source IPs are different and
> that would require multiple client systems accessing the server.

I tried changing the client IP address and the RSS hash key.  It never
changed to another queue.  Something is broken.

> In the case of other encapsulation types over UDP, such as VXLAN, I
> know that a hash value is stored in the UDP source port location
> instead of the true source port number. This allows the RSS hashing to
> occur on this extra information which would allow for a greater
> diversity in hash results. Depending on how you are generating the ESP
> encapsulation you might look at seeing if it would be possible to have
> a hash on the inner data used as the UDP source port in the outgoing
> packets. This would help to resolve this sort of issue.

Well it works on every other network card except this one.  Every other
intel card in the past we have used had no problem doing this right.

You want all the packets for a given ipsec tunnel to go to the same queue.
That is not a problem here.  What you don't want is every ipsec packet
from everyone going to the same queue (always queue 0).  So simply
treating them as UDP packets with a source and destination IP and port
would work perfectly fine.  The X722 isn't doing that.  It is always
assigning a hash value of 0 to these packets.

-- 
Len Sorensen
