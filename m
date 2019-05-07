Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE687163BB
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 14:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbfEGM1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 08:27:24 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:46416 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726329AbfEGM1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 08:27:23 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (Proofpoint Essentials ESMTP Server) with ESMTPS id 98C7F180050;
        Tue,  7 May 2019 12:27:21 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 7 May
 2019 05:27:17 -0700
Subject: Re: [RFC PATCH net-next 2/3] flow_offload: restore ability to collect
 separate stats per action
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        "Cong Wang" <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Anjali Singhai Jain <anjali.singhai@intel.com>,
        Or Gerlitz <gerlitz.or@gmail.com>
References: <alpine.LFD.2.21.1905031603340.11823@ehc-opti7040.uk.solarflarecom.com>
 <20190504022759.64232fc0@cakuba.netronome.com>
 <db827a95-1042-cf74-1378-8e2eac356e6d@mojatatu.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <1b37d659-5a2b-6130-e8d6-c15d6f57b55e@solarflare.com>
Date:   Tue, 7 May 2019 13:27:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <db827a95-1042-cf74-1378-8e2eac356e6d@mojatatu.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24596.005
X-TM-AS-Result: No-9.557400-4.000000-10
X-TMASE-MatchedRID: 8+bhjh9TQnEOwH4pD14DsPHkpkyUphL9XsJIQWO/qJVnnK6mXN72mw/x
        9pUv0o6LTiQecD9aKoSmgEH3vUzB3T9/6/cgYWdXdPuue3cRiRguFjL0BGSgFwbYcy9YQl6eQoZ
        WNsznCcB+cF4VoGbxbsnxAZU+IVnO64dDeOHpGHBLxLYX2WS87ywJzaIVMjGtUCgEErrUGFzgdb
        Ow50s7YrsrX+DAazgiMHPOlYJGd+yF9Rq0eQRY1HbtLK/jNLwLGSqdEmeD/nUoglbEnCQocYRp0
        uV6Yx1jOAVPf0uep4YHbUB9wsCn6qB11RkmaqHef01qcJQDhV6L6a+kPOEFsFc/CedjlcvkwKjL
        tlNOpCbnzlXMYw4XMAGLeSok4rrZC24oEZ6SpSk6XEE7Yhw4FgefYaJ6SJ6otLKQMZwMTspPKlc
        stuCyEeEYB5IM4HzC1zNwDXWbHDtDDKa3G4nrLQ==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--9.557400-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24596.005
X-MDID: 1557232042-gLQ2yFu5btL0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/05/2019 13:41, Jamal Hadi Salim wrote:
> On 2019-05-04 2:27 a.m., Jakub Kicinski wrote:
>> On Fri, 3 May 2019 16:06:55 +0100, Edward Cree wrote:
>>> Introduce a new offload command TC_CLSFLOWER_STATS_BYINDEX, similar to
>>>   the existing TC_CLSFLOWER_STATS but specifying an action_index (the
>>>   tcfa_index of the action), which is called for each stats-having action
>>>   on the rule.  Drivers should implement either, but not both, of these
>>>   commands.
>
> [..]
>>
>> It feels a little strange to me to call the new stats updates from
>> cls_flower, if we really want to support action sharing correctly.
>>
>> Can RTM_GETACTION not be used to dump actions without dumping the
>> classifiers?  If we dump from the classifiers wouldn't that lead to
>> stale stats being returned?
>
> Not sure about the staleness factor, but:
> For efficiency reasons we certainly need the RTM_GETACTION approach
> (as you stated above we dont need to dump all that classifier info if
> all we want are stats). This becomes a big deal if you have a lot
> of stats/rules.
I don't know much of anything about RTM_GETACTION, but it doesn't appear
 to be part of the current "tc offload" world, which AIUI is very much
 centred around cls_flower.  I'm just trying to make counters in
 cls_flower offload do 'the right thing' (whatever that may be), anything
 else is out of scope.

> Most H/W i have seen has a global indexed stats table which is
> shared by different action types (droppers, accept, mirror etc).
> The specific actions may also have their own tables which also
> then refer to the 32 bit index used in the stats table[1].
> So for this to work well, the action will need at minimal to have
> two indices one that is used in hardware stats table
> and another that is kernel mapped to identify the attributes. Of
> course we'll need to have a skip_sw flag etc.
I'm not sure I'm parsing this correctly, but are you saying that the
 index namespace is per-action type?  I.e. a mirred and a drop action
 could have the same index yet expect to have separate counters?  My
 approach here has assumed that in such a case they would share their
 counters.
