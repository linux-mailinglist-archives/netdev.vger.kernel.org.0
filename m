Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD648D08C
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 12:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbfHNKTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 06:19:13 -0400
Received: from mail.thelounge.net ([91.118.73.15]:25791 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbfHNKTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 06:19:13 -0400
Received: from srv-rhsoft.rhsoft.net  (Authenticated sender: h.reindl@thelounge.net) by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 467ltL60M1zXMk;
        Wed, 14 Aug 2019 12:19:06 +0200 (CEST)
Subject: Re: [PATCH AUTOSEL 4.19 04/42] netfilter: conntrack: always store
 window size un-scaled
To:     Thomas Jarosch <thomas.jarosch@intra2net.com>,
        Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Florian Westphal <fw@strlen.de>,
        Jakub Jankowski <shasta@toxcorp.com>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
References: <20190802132302.13537-1-sashal@kernel.org>
 <20190802132302.13537-4-sashal@kernel.org>
 <20190808090209.wb63n6ibii4ivvba@intra2net.com>
From:   Reindl Harald <h.reindl@thelounge.net>
Openpgp: id=9D2B46CDBC140A36753AE4D733174D5A5892B7B8;
 url=https://arrakis-tls.thelounge.net/gpg/h.reindl_thelounge.net.pub.txt
Organization: the lounge interactive design
Message-ID: <41ce587d-dfaa-fe6b-66a8-58ba1a3a2872@thelounge.net>
Date:   Wed, 14 Aug 2019 12:19:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190808090209.wb63n6ibii4ivvba@intra2net.com>
Content-Type: text/plain; charset=utf-8
Content-Language: de-CH
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

that's still not in 5.2.8

without the exception and "nf_conntrack_tcp_timeout_max_retrans = 60" a
vnc-over-ssh session having the VNC view in the background freezes
within 60 secods

-----------------------------------------------------------------------------------------------
IPV4 TABLE MANGLE (STATEFUL PRE-NAT/FILTER)
-----------------------------------------------------------------------------------------------
Chain PREROUTING (policy ACCEPT 100 packets, 9437 bytes)
num   pkts bytes target     prot opt in     out     source
 destination
1     6526 3892K ACCEPT     all  --  *      *       0.0.0.0/0
 0.0.0.0/0            ctstate RELATED,ESTABLISHED
2      125  6264 ACCEPT     all  --  lo     *       0.0.0.0/0
 0.0.0.0/0
3       64  4952 ACCEPT     all  --  vmnet8 *       0.0.0.0/0
 0.0.0.0/0
4        1    40 DROP       all  --  *      *       0.0.0.0/0
 0.0.0.0/0            ctstate INVALID

-------- Weitergeleitete Nachricht --------
Betreff: [PATCH AUTOSEL 5.2 07/76] netfilter: conntrack: always store
window size un-scaled

Am 08.08.19 um 11:02 schrieb Thomas Jarosch:
> Hello together,
> 
> You wrote on Fri, Aug 02, 2019 at 09:22:24AM -0400:
>> From: Florian Westphal <fw@strlen.de>
>>
>> [ Upstream commit 959b69ef57db00cb33e9c4777400ae7183ebddd3 ]
>>
>> Jakub Jankowski reported following oddity:
>>
>> After 3 way handshake completes, timeout of new connection is set to
>> max_retrans (300s) instead of established (5 days).
>>
>> shortened excerpt from pcap provided:
>> 25.070622 IP (flags [DF], proto TCP (6), length 52)
>> 10.8.5.4.1025 > 10.8.1.2.80: Flags [S], seq 11, win 64240, [wscale 8]
>> 26.070462 IP (flags [DF], proto TCP (6), length 48)
>> 10.8.1.2.80 > 10.8.5.4.1025: Flags [S.], seq 82, ack 12, win 65535, [wscale 3]
>> 27.070449 IP (flags [DF], proto TCP (6), length 40)
>> 10.8.5.4.1025 > 10.8.1.2.80: Flags [.], ack 83, win 512, length 0
>>
>> Turns out the last_win is of u16 type, but we store the scaled value:
>> 512 << 8 (== 0x20000) becomes 0 window.
>>
>> The Fixes tag is not correct, as the bug has existed forever, but
>> without that change all that this causes might cause is to mistake a
>> window update (to-nonzero-from-zero) for a retransmit.
>>
>> Fixes: fbcd253d2448b8 ("netfilter: conntrack: lower timeout to RETRANS seconds if window is 0")
>> Reported-by: Jakub Jankowski <shasta@toxcorp.com>
>> Tested-by: Jakub Jankowski <shasta@toxcorp.com>
>> Signed-off-by: Florian Westphal <fw@strlen.de>
>> Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
>> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> Also:
> Tested-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
> 
> ;)
> 
> We've hit the issue with the wrong conntrack timeout at two different sites,
> long-lived connections to a SAP server over IPSec VPN were constantly dropping.
> 
> For us this was a regression after updating from kernel 3.14 to 4.19.
> Yesterday I've applied the patch to kernel 4.19.57 and the problem is fixed.
> 
> The issue was extra hard to debug as we could just boot the new kernel
> for twenty minutes in the evening on these productive systems.
> 
> The stable kernel patch from last Friday came right on time. I was just
> about the replay the TCP connection with tcpreplay, so this saved
> me from another week of debugging. Thanks everyone!
