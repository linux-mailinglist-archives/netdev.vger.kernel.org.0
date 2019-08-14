Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86E4D8D7D4
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 18:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbfHNQR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 12:17:27 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:39858 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726522AbfHNQR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 12:17:26 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 7DE2FA40063;
        Wed, 14 Aug 2019 16:17:25 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 14 Aug
 2019 09:17:21 -0700
Subject: Re: [PATCH net-next,v4 08/12] drivers: net: use flow block API
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>
References: <20190709205550.3160-1-pablo@netfilter.org>
 <20190709205550.3160-9-pablo@netfilter.org>
 <75eec70e-60de-e33b-aea0-be595ca625f4@solarflare.com>
 <20190813195126.ilwtoljk2csco73m@salvia>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <b3232864-3800-e2a4-9ee3-2cfcf222a148@solarflare.com>
Date:   Wed, 14 Aug 2019 17:17:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190813195126.ilwtoljk2csco73m@salvia>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24846.005
X-TM-AS-Result: No-10.910200-4.000000-10
X-TMASE-MatchedRID: fE0JoqABJp0bF9xF7zzuNfZvT2zYoYOwC/ExpXrHizw/hcT28SJs8v/p
        7AIzNMBS5sErdUkMbqaXeiT2Em65KDwe897U/PjCpyEWs4H2Rqc0bM+gM8H/Ugv1OPvvDLzsAUq
        wO9pSIT01wrEZp8hyYqPCbIW4ooFkLbUbaWIvlY9xoP7A9oFi1mcCy3wC35zdikvLPxTKpjhWj9
        Xdj6pyaN4rjaopPTS8q2A6xYQhHEUnAOBcD3t42fChiQolft/y+IfriO3cV8RGM2uNXRqsUqKOH
        /xyOViuW2Ak0gmF7uqz0ZOkreXeRsTnL4nkk931Z93oz43dfXHNUTeBBPKQKlNtD3nNFtZWfD1p
        /kSNbAKpDgMfeL8P3pTIMHQYuXBt8aVkBZkOPzLyxz2hgoG97eDTYjejIZTwl23GX7Au7dT8z4k
        rOhCPi+fOVcxjDhcwPcCXjNqUmkUgBwKKRHe+rxKDZnP+4XT4MQ8s8fI0prS8xfdrYf9lylWBsj
        PevZQYw4j67ehcJv4=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--10.910200-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24846.005
X-MDID: 1565799446-xs6DQ6u-OldQ
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/08/2019 20:51, Pablo Neira Ayuso wrote:
> On Mon, Aug 12, 2019 at 06:50:09PM +0100, Edward Cree wrote:
>> Pablo, can you explain (because this commit message doesn't) why these per-
>>  driver lists are needed, and what the information/state is that has module
>>  (rather than, say, netdevice) scope?
> The idea is to update drivers to support one flow_block per subsystem,
> one for ethtool, one for tc, and so on. So far, existing drivers only
> allow for binding one single flow_block to one of the existing
> subsystems. So this limitation applies at driver level.
That argues for per-driver _code_, not for per-driver _state_.  For instance,
 each driver could (more logically) store this information in the netdev
 private data, rather than a static global.  Or even, since each driver
 instance has a unique cb_ident = netdev_priv(net_dev), this doesn't need to
 be local to the driver at all and could just belong to the device owning the
 flow_block (which isn't necessarily the device doing the offload, per
 indirect blocks).

TBH I'm still not clear why you need a flow_block per subsystem, rather than
 just having multiple subsystems feed their offload requests through the same
 flow_block but with different enum tc_setup_type or enum tc_fl_command or
 some other indication that this is "netfilter" rather than "tc" asking for a
 tc_cls_flower_offload.

I'd also like to concur with what Jakub said on v2: "this series is really
 hard to follow... the number of things called some combination of block cb
 and list makes my head hurt :/".

This really needs a design document explaining what all the bits are, how
 they fit together, and why they need to be like that.
