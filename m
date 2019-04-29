Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92A05E456
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 16:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbfD2OLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 10:11:15 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:53040 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728235AbfD2OLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 10:11:15 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (Proofpoint Essentials ESMTP Server) with ESMTPS id 3A53A68008A;
        Mon, 29 Apr 2019 14:11:12 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 29 Apr
 2019 07:11:08 -0700
Subject: Re: TC stats / hw offload question
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>,
        netdev <netdev@vger.kernel.org>, "Jiri Pirko" <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>
References: <26f0cfc9-3bef-8579-72cc-aa6c5ccecd43@solarflare.com>
 <4cb765dd-453f-3139-bce6-6e0b31167aec@mojatatu.com>
 <ec4092a6-196d-7eca-04be-0654e762c0b2@solarflare.com>
 <20190424141139.5c5vhihie5mryxlt@salvia>
 <26afcaaf-abdf-42ad-1715-5af9c6f3c2ef@solarflare.com>
 <58c74d0f-b92e-31f9-9828-24fb04129534@solarflare.com>
 <20190425223346.zqfadtphmhuj7ohp@salvia>
 <e09faf92-c947-5b98-78d3-a37a28c0fc59@solarflare.com>
 <20190426184943.idewf2rqebvslcva@salvia>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <97133878-8e78-287b-9854-431b116b0788@solarflare.com>
Date:   Mon, 29 Apr 2019 15:11:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190426184943.idewf2rqebvslcva@salvia>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24580.005
X-TM-AS-Result: No-8.417400-4.000000-10
X-TMASE-MatchedRID: 6otD/cJAac0bF9xF7zzuNSa1MaKuob8PC/ExpXrHizxUvqB5o/Lqc0Lf
        0JDl5+CERwDy7RKHPV/YKBp+S1KnXCJAWxI5I0CvGuE3UyUHG1dimi8LvNfmr2ecrqZc3vabkaC
        qYviih52OUwv1pUGYjY2OEUwrJHaAVfY45uDlUEeiVU7u7I4INbuesBT0pDFR27DI4Z+qeoarWF
        zW8k/GrcRHH5tvu//50+dfYMSQgqk77EsBOi8++sHTFfzPrJ63LAnNohUyMa3I9BHsOEzeNp6In
        ad+l2RRQ8kDN7SWFOwO4HTQVaW9lbZpmC5x7+hkngIgpj8eDcCcIZLVZAQa0N/C2riNn8beKrau
        Xd3MZDU8etQHMROUZsz+Ba7+nv3ukvYsOvVngsQ9eMHZbISgggyeErTZLPsBDzxGm92nK91+3Bn
        dfXUhXQ==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.417400-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24580.005
X-MDID: 1556547074-dS0m53ttW-FG
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/04/2019 19:49, Pablo Neira Ayuso wrote:
> On Fri, Apr 26, 2019 at 01:13:41PM +0100, Edward Cree wrote:
>> Thus if (and only if) two TC actions have the same tcfa_index, they will
>>  share a single counter in the HW.
>> I gathered from a previous conversation with Jamal[1] that that was the
>>  correct behaviour:
>>> Note, your counters should also be shareable; example, count all
>>> the drops in one counter across multiple flows as in the following
>>> case where counter index 1 is used.
>>>
>>> tc flower match foo action drop index 1
>>> tc flower match bar action drop index 1
> The flow_action_entry structure needs a new 'counter_index' field to
> store this. The tc_setup_flow_action() function needs to be updated
> for this for the FLOW_ACTION_{ACCEPT,DROP,REDIRECT,MIRRED} cases to
> set this entry->counter_index field to tcfa_index, so the driver has
> access to this.
Hmm, I'm still not sure this solves everything.
Before, we could write
tc flower match foo \
    action mirred egress mirror eth1 index 1 \
    action mirred egress redirect eth2 index 2
and have two distinct HW counters (one of which might e.g. be shared
 with another rule).  But when reading those counters, under
 fl_hw_update_stats(), the driver only gets to return one set of flow
 stats for both actions.
Previously, the driver's TC_CLSFLOWER_STATS handler was updating the
 action stats directly, so was able to do something different for each
 action, but that's not possible in 5.1.  At stats gathering time, the
 driver doesn't even have access to anything that's per-action and
 thus could have a flow_stats member shoved in it.
AFAICT, the only reason this isn't a regression is that existing
 drivers didn't implement the old semantics correctly.
This is a bit of a mess; the best idea I've got is for the
 TC_CLSFLOWER_STATS call to include a tcfa_index.  Then the driver
 returns counter stats for that index, and tcf_exts_stats_update()
 only updates those actions whose index matches.  But then
 fl_hw_update_stats() would have to iterate over all the indices in
 f->exts.  What do you think?

-Ed
