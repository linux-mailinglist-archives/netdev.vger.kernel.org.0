Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A12361DBBFA
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 19:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgETRw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 13:52:28 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:34676 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726436AbgETRw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 13:52:27 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.143])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id D8F11200BB;
        Wed, 20 May 2020 17:52:26 +0000 (UTC)
Received: from us4-mdac16-38.at1.mdlocal (unknown [10.110.51.53])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id D6F0E8009B;
        Wed, 20 May 2020 17:52:26 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.8])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 61FD740061;
        Wed, 20 May 2020 17:52:26 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id F089D4C009B;
        Wed, 20 May 2020 17:52:25 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 20 May
 2020 18:52:19 +0100
Subject: Re: [PATCH v3 net-next] net: flow_offload: simplify hw stats check
 handling
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <jiri@resnulli.us>,
        <kuba@kernel.org>
References: <2cf9024d-1568-4594-5763-6c4e4e8fe47b@solarflare.com>
 <f2586a0e-fce1-cee9-e2dc-f3dc73500515@solarflare.com>
 <20200520173216.GA28641@salvia>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <6e83fd83-86fd-981a-d080-269b9fd3e20f@solarflare.com>
Date:   Wed, 20 May 2020 18:52:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200520173216.GA28641@salvia>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25430.003
X-TM-AS-Result: No-5.158100-8.000000-10
X-TMASE-MatchedRID: scwq2vQP8OG8rRvefcjeTR4ejJMDGBzF69aS+7/zbj+qvcIF1TcLYD6P
        hj6DfZCEcf+//KzNhNGE/M8/lUcrM8e3wV6A2hchBWXr+dSZ1T0GchEhVwJY39Uf6bWFkfAuMk2
        soYXYWBKPKEoHTEz5lLZO1++fulf40YRMm/X9bI5JUdgxNDUXWjg6RKCx6bV17K5p55rm0/Nxmp
        lAleOtpEPoNa37ZjLwcskIOhkWTOL4miWUEaTQPqMY62qeQBkLfS0Ip2eEHnzWRN8STJpl3PoLR
        4+zsDTtJC9jS54qtzWrM9sujA4gXlbniNbrVL0vVpZITW7Nwiak6fA/SZcZ9g==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.158100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25430.003
X-MDID: 1589997146-dWzB2_nHfUAg
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/05/2020 18:32, Pablo Neira Ayuso wrote:
> On Wed, May 20, 2020 at 06:31:05PM +0100, Edward Cree wrote:
>> On 20/05/2020 18:21, Edward Cree wrote:
>>> @@ -582,7 +590,7 @@ nf_flow_offload_rule_alloc(struct net *net,
>>>  	const struct flow_offload_tuple *tuple;
>>>  	struct nf_flow_rule *flow_rule;
>>>  	struct dst_entry *other_dst;
>>> -	int err = -ENOMEM;
>>> +	int err = -ENOMEM, i;
>>>  
>>>  	flow_rule = kzalloc(sizeof(*flow_rule), GFP_KERNEL);
>>>  	if (!flow_rule)
>> Whoops, this changebar isn't meant to be there.  Somehow I missed
>>  the unused var warning when I built it, too.
>> Drop this, I'll spin v4.
> The nf_tables_offload.c update is missing, please include this in v4.
Hmm.  Rather than me trying to whack-a-mole all the places in
 netfilter that create actions... given that the other user is TC,
 which explicitly sets hw_stats, maybe I should instead make
 flow_rule_alloc() populate all the hw_stats with DONT_CARE?
It certainly makes for a shorter patch, and makes it less likely
 that bugs will be introduced later when new action offloads get
 added to netfilter by forgetting to set hw_stats.
And it means the patch doesn't rely on me knowing things about
 netfilter internals which I apparently don't.

-ed
