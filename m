Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B61E523C02
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 17:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392131AbfETP0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 11:26:30 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:40314 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730766AbfETP03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 11:26:29 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 23D22B4007C;
        Mon, 20 May 2019 15:26:27 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 20 May
 2019 08:26:22 -0700
Subject: Re: [RFC PATCH v2 net-next 0/3] flow_offload: Re-add per-action
 statistics
To:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>
References: <9b137a90-9bfb-9232-b01b-6b6c10286741@solarflare.com>
 <f4fdc1f1-bee2-8456-8daa-fbf65aabe0d4@solarflare.com>
 <cacfe0ec-4a98-b16b-ef30-647b9e50759d@mojatatu.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <f27a6a44-5016-1d17-580c-08682d29a767@solarflare.com>
Date:   Mon, 20 May 2019 16:26:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <cacfe0ec-4a98-b16b-ef30-647b9e50759d@mojatatu.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24624.005
X-TM-AS-Result: No-12.574600-4.000000-10
X-TMASE-MatchedRID: 0dFPYP4mu5TmLzc6AOD8DfHkpkyUphL9g99C97sXB8BQKAQSutQYXELa
        GegdJ2bmeNpTbJbSd8fNYmiyRY/XVlvLEDLz4/18fid4LSHtIAPHSOYUp9HFyMa9/IwAq2etAUq
        wO9pSIT0X2JC8aIIxe6rbiyJcRE9x6WgBZT4x0yr0MaQO2ri8DAebMc7dN8D4tmTuCy5+VUqx/c
        twRkgblyz8sK84C/nX3LhqCs5FjVBtF6/n498MP5zEHTUOuMX39l9p8mNlkgkELMPQNzyJS+Mmp
        Z6XwS0ifMtvnnFP0XhBfQPbExiy5w66dAsNpdQEboe6sMfg+k+oJkORSPbbw7KeTtOdjMy6f2+C
        ruJb3sw0zRzGUuAaePfu0TSNZMLKJ+JZYQfxoHxSOC+TOar9NK2CCashnFx10fRqqiZ4ZleY9g/
        Nz1T3KT10hssYefLM2YHAy9vdzf5STe2wpWYcpJ4CIKY/Hg3AcmfM3DjaQLHEQdG7H66TyF82MX
        kEdQ77df4Ft2s9cbhHsjTl0dZQjl32hYWyYVnILE69oroAWljCks0I9/2gCw==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--12.574600-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24624.005
X-MDID: 1558365988-AI0r5WKzPJwj
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/05/2019 21:39, Jamal Hadi Salim wrote:
> On 2019-05-17 1:14 p.m., Edward Cree wrote:
>> On 17/05/2019 16:27, Edward Cree wrote:
>>> I'm now leaning towards the
>>>   approach of adding "unsigned long cookie" to struct flow_action_entry
>>>   and populating it with (unsigned long)act in tc_setup_flow_action().
>>
>> For concreteness, here's what that looks like: patch 1 is replaced with
>>   the following, the other two are unchanged.
>> Drivers now have an easier job, as they can just use the cookie directly
>>   as a hashtable key, rather than worrying about which action types share
>>   indices.
>
> Per my other email, this will break tc semantics. It doesnt look
> possible to specify an index from user space. Did i miss
> something?
Unless *I* missed something, I'm not changing the TC<=>user-space API at
 all.  If user space specifies an index, then TC will either create a new
 action with that index, or find an existing one.  Then flow_offload turns
 that into a cookie; in the 'existing action' case it'll be the same
 cookie as any previous offloads of that action, in the 'new action' case
 it'll be a cookie distinct from any existing action.
Drivers aren't interested in the specific index value, only in "which
 other actions (counters) I've offloaded are shared with this one?", which
 the cookie gives them.

With my (unreleased) driver code, I've successfully tested this with e.g.
 the following rules:
tc filter add dev $vfrep parent ffff: protocol arp flower skip_sw \
    action vlan push id 100 protocol 802.1q \
    action mirred egress mirror dev $pf index 101 \
    action vlan pop \
    action drop index 104
tc filter add dev $vfrep parent ffff: protocol ipv4 flower skip_sw \
    action vlan push id 100 protocol 802.1q \
    action mirred egress mirror dev $pf index 102 \
    action vlan pop \
    action drop index 104

Then when viewing with `tc -stats filter show`, the mirreds count their
 traffic separately (and with an extra 4 bytes per packet for the VLAN),
 whereas the drops (index 104, shared) show the total count (and without
 the 4 bytes).

(From your other email)
> tcfa_index + action identifier seem to be sufficiently global, no?
The reason I don't like using the action identifier is because flow_offload
 slightly alters those: mirred gets split into two (FLOW_ACTION_REDIRECT
 and FLOW_ACTION_MIRRED (mirror)).  Technically it'll still work (a redirect
 and a mirror are different actions, so can't have the same index, so it
 doesn't matter if they're treated as the same action-type or not) but it
 feels like a kludge.

-Ed
