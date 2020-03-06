Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB11A17C0FE
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 15:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgCFOzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 09:55:50 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:38880 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726565AbgCFOzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 09:55:49 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id DABE7A4006C;
        Fri,  6 Mar 2020 14:55:47 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 6 Mar 2020
 14:55:41 +0000
Subject: Re: [PATCH net-next ct-offload 02/13] net/sched: act_ct: Instantiate
 flow table entry actions
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "Oz Shlomo" <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
References: <1583422468-8456-1-git-send-email-paulb@mellanox.com>
 <1583422468-8456-3-git-send-email-paulb@mellanox.com>
 <ce72a853-a416-4162-5ffb-c719c98fb7cc@solarflare.com>
 <8f58e2b3-c1f6-4c75-6662-8f356f3b4838@mellanox.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <640d8d41-83e3-af9d-9e7e-f8b8f5c6fb68@solarflare.com>
Date:   Fri, 6 Mar 2020 14:55:37 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <8f58e2b3-c1f6-4c75-6662-8f356f3b4838@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25272.003
X-TM-AS-Result: No-6.434500-8.000000-10
X-TMASE-MatchedRID: VfovoVrt/obmLzc6AOD8DfHkpkyUphL9+IfriO3cV8RPvOpmjDN2ko+u
        WEAswmyPuLWqdf+LclurtvmvUFOgI2szdxlvNr+EIwk7p1qp3JYLBPYMfuIybu1VpmGiDxtcPDA
        DfLdL5BoH/+DcPzl6RwNqjJbFP+t9c0aJdp1qXtMkO5bN+/P8x8GcvcBoab2jB/eejAjH+qTiKq
        oPfA0a+r8ArwL1o8wVTpkdQ6COBA05fJEi9zRcQ6MY62qeQBkLGIMg4+U4kbWs1p4mti9RCGJtB
        O3fjIWiBJCwWhIJtW5Rb64jT6Ref6+/EguYor8cgxsfzkNRlfLdB/CxWTRRu4as+d5/8j56pKlg
        vc30rR1RzVNAPjpmdfeSGQecRj43lg/PPEN5Oe9nIxZyJs78kg==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.434500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25272.003
X-MDID: 1583506548-ilK59XuVPwNx
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/03/2020 13:22, Paul Blakey wrote:
> On 06/03/2020 13:35, Edward Cree wrote:
>> I'm not quite sure what the zone is doing in the action.  Surely it's
>>  a property of the match.  Or does this set a ct_zone for a potential
>>  *second* conntrack lookup?
> this is part of the metadata that driver should mark the with, as it can be matched against in following hardware tables/rules. consider this set of offloaded rules:
<snip>
So, normally I'd expect to use different chains for the different zones.
But I can see that in theory you might want to have some rules shared by
 both, hence being able to put them in the same chain is useful.

Assuming an idealised model of the hardware, with three stages:
* "left-hand rule" - in chain 0, match -trk, action "ct and goto chain"
* "conntrack lookup" - match 5-tuple, return NATted 5-tuple + some flags
* "right-hand rule" - in chain !=0, match +trk(±others), many actions
The zone is set by the left-hand rule, it's a (semi-)implicit input to
 the conntrack lookup, and it can be an explicit match field of the
 right-hand rule (as it is in your example).
But from a logical perspective, the conntrack lookup isn't *producing*
 the zone as an output, it's just forwarding on the zone that was fed to
 it by the left-hand rule.
So, the conntrack entry, which already has the zone in its
 struct flow_match (. struct flow_match_ct .key->ct_zone), doesn't need
 to specify the zone *again* in the action.  If the driver needs to
 supply that piece of information a second time in the action metadata
 for the conntrack action, that's a hardware-specific implementation
 detail.
Or so it seems to me, anyway.

-ed
