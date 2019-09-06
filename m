Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8975EAB883
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 14:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404870AbfIFMzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 08:55:37 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:59532 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404862AbfIFMzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 08:55:37 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 59DAA80064;
        Fri,  6 Sep 2019 12:55:35 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 6 Sep
 2019 05:55:30 -0700
Subject: Re: [PATCH net-next,v3 0/4] flow_offload: update mangle action
 representation
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <netfilter-devel@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <jakub.kicinski@netronome.com>,
        <jiri@resnulli.us>, <saeedm@mellanox.com>, <vishal@chelsio.com>,
        <vladbu@mellanox.com>
References: <20190906000403.3701-1-pablo@netfilter.org>
 <679ced4b-8bcd-5479-2773-7c75452c2a32@solarflare.com>
 <20190906105638.hylw6quhk7t3wff2@salvia>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <b8baf681-b808-4b83-d521-0353c3136516@solarflare.com>
Date:   Fri, 6 Sep 2019 13:55:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190906105638.hylw6quhk7t3wff2@salvia>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24892.005
X-TM-AS-Result: No-14.083900-4.000000-10
X-TMASE-MatchedRID: eVEkOcJu0F4eimh1YYHcKB4ejJMDGBzF69aS+7/zbj+qvcIF1TcLYDS1
        m54gUL0X+/AprGlolD3RCiTlD5priogsbrQhlb+3A9lly13c/gEA+JHhu0IR5g6QlBHhBZuwJg6
        dxhIIpObg15yuT3ujaI6S9ESgFkF85lKdq+fFOu1l2ityh8f8aR5FmvZzFEQuy5JfHvVu9IuPtO
        ITsGXyUQlvIRdkXB5Jrmd2YQW9ckOH0DP1fa76LHNjCNHNJIs4BGvINcfHqhcELMPQNzyJSzd36
        q149aCOWSIvbfNk0AD8orpFUn4ofXtopSgDSMBh/ccgt/EtX/37DSw7+Hy7ebKeTtOdjMy6ttNu
        UtVl2ix1Joq1iFPTtp/dut57ghdMNyl1nd9CIt2DGx/OQ1GV8t0H8LFZNFG7bkV4e2xSge4O3C+
        DKtjulrE5c7tCjJn18xDNupGzB33by8j2VMPW/xyFdNnda6Rv
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--14.083900-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24892.005
X-MDID: 1567774536-VJ3_WtU_1EQl
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/09/2019 11:56, Pablo Neira Ayuso wrote:
> On Fri, Sep 06, 2019 at 11:02:18AM +0100, Edward Cree wrote:
>> Still NAK for the same reasons as three versions ago (when it was called
>>  "netfilter: payload mangling offload support"), you've never managed to
>>  explain why this extra API complexity is useful.  (Reducing LOC does not
>>  mean you've reduced complexity.)
> Oh well...
>
> Patch 1) Mask is inverted for no reason, just because tc pedit needs
> this in this way. All drivers reverse this mask.
>
> Patch 2) All drivers mask out meaningless fields in the value field.
To be clear: I have no issue with these two patches; they look fine to me.
(Though I'd like to see some comments on struct flow_action_entry specifying
 the semantics of these fields, especially if they're going to differ from
 the corresponding fields in struct tc_pedit_key.)

> Patch 3) Without this patchset, offsets are on the 32-bit boundary.
> Drivers need to play with the 32-bit mask to infer what field they are
> supposed to mangle... eg. with 32-bit offset alignment, checking if
> the use want to alter the ttl/hop_limit need for helper structures to
> check the 32-bit mask. Mangling a IPv6 address comes with one single
> action...
Drivers are still going to need to handle multiple pedit actions, in
 case the original rule wanted to mangle two non-consecutive fields.
And you can't just coalesce all consecutive mangles, because if you
 mangle two consecutive fields (e.g. UDP sport and dport) the driver
 still needs to disentangle that if it works on a 'fields' (rather
 than 'u32s') level.
So either have the core convert things into named protocol fields
 (i.e. "set src IPv6 to 1234::5 and add 1 to UDP sport"), or leave
 the current sequence-of-u32-mangles as it is.  This in-between "we'll
 coalesce things together despite not knowing what fields they are" is
 neither fish nor fowl.

-Ed
