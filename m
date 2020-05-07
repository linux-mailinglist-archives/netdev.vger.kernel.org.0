Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEE2F1C9568
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 17:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgEGPt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 11:49:27 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:54828 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725914AbgEGPt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 11:49:27 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.137])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 05633200DB;
        Thu,  7 May 2020 15:49:26 +0000 (UTC)
Received: from us4-mdac16-75.at1.mdlocal (unknown [10.110.50.193])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 02215600A1;
        Thu,  7 May 2020 15:49:26 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.105])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 79FDF220071;
        Thu,  7 May 2020 15:49:25 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 1E0829C0059;
        Thu,  7 May 2020 15:49:25 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 7 May 2020
 16:49:19 +0100
Subject: Re: [RFC PATCH net] net: flow_offload: simplify hw stats check
 handling
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <netfilter-devel@vger.kernel.org>, <jiri@resnulli.us>,
        <kuba@kernel.org>
References: <49176c41-3696-86d9-f0eb-c20207cd6d23@solarflare.com>
 <20200507153231.GA10250@salvia>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <9000b990-9a25-936e-6063-0034429256f0@solarflare.com>
Date:   Thu, 7 May 2020 16:49:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200507153231.GA10250@salvia>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25404.003
X-TM-AS-Result: No-3.237200-8.000000-10
X-TMASE-MatchedRID: HXSqh3WYKfu8rRvefcjeTR4ejJMDGBzF69aS+7/zbj+qvcIF1TcLYHWQ
        EG9fkFjnBsHk0c28yIFTtuW5X/TasP7tHrro2/8xoxjrap5AGQsX2zxRNhh61ahHWxx1acUUwOW
        nbwsz43KkOO100bSZNV7pYW/UsTx9Nfo8TyvB3qEqsMfMfrOZRUloPruIq9jT0fdJMjDg/DLzPv
        RcNNSOxi+vBc4/NAwnAGyNPhznEz9JxzdMxVoC9pU7Bltw5qVLwCx/VTlAePqbKItl61J/ycnjL
        TA/UDoASXhbxZVQ5H+OhzOa6g8KrefhcPyBtEzPjgrh35LW8ry5rk5R+EBE4JnzTmj6cLSx/g3I
        edOBH38+hOvIJEYQOBeqwX5fidXjeswl8UtIMAtGSq2MHFuGT+L59MzH0po2K2yzo9Rrj9wPoYC
        35RuihKPUI7hfQSp53zHerOgw3HE=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.237200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25404.003
X-MDID: 1588866566-T8A8QSxSbPCB
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/05/2020 16:32, Pablo Neira Ayuso wrote:
> On Thu, May 07, 2020 at 03:59:09PM +0100, Edward Cree wrote:
>> Make FLOW_ACTION_HW_STATS_DONT_CARE be all bits, rather than none, so that
>>  drivers and __flow_action_hw_stats_check can use simple bitwise checks.
> 
> You have have to explain why this makes sense in terms of semantics.
> 
> _DISABLED and _ANY are contradicting each other.
No, they aren't.  The DISABLED bit means "I will accept disabled", it doesn't
 mean "I insist on disabled".  What _does_ mean "I insist on disabled" is if
 the DISABLED bit is set and no other bits are.
So DISABLED | ANY means "I accept disabled; I also accept immediate or
 delayed".  A.k.a. "I don't care, do what you like".

>> In mlxsw we check for DISABLED first, because we'd rather save the counter
>>  resources in the DONT_CARE case.
> 
> And this also is breaking netfilter again.
> 
> Turning DONT_CARE gives us nothing back at all.
If you set DONT_CARE, then because that includes the DISABLED bit, you will
 get no counter on mlxsw.  I thought that was what netfilter wanted (no
 counters by default)?

On 07/05/2020 16:36, Pablo Neira Ayuso wrote:
> What if the driver does not support to disable counters?
> 
> It will have to check for _DONT_CARE here.
No, it would just go
    if (hw_stats & _IMMEDIATE) {
        configure_me_a_counter();
    } else {
        error("Only hw_stats_type immediate supported");
    }
And this will work fine, because _DONT_CARE & _IMMEDIATE == _IMMEDIATE,
 whereas _DISABLED & _IMMEDIATE == 0.

> And _DISABLED implies "bail out if you cannot disable".
See above; with the new semantics, the "bail out" condition is "if you
 cannot satisfy any of the bits that were set".  Which means if
 _DISABLED is the only bit set, and you cannot disable, you bail out;
 but if _DISABLED and (say) _IMMEDIATE are both set, that means "bail
 out if you don't support _IMMEDIATE *and* cannot disable" (i.e. if you
 only support _DELAYED).

-ed
