Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04EEAE7B1
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 18:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728621AbfD2QZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 12:25:17 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:51622 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728518AbfD2QZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 12:25:17 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (Proofpoint Essentials ESMTP Server) with ESMTPS id 1435A140092;
        Mon, 29 Apr 2019 16:25:15 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 29 Apr
 2019 09:25:12 -0700
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
 <97133878-8e78-287b-9854-431b116b0788@solarflare.com>
 <20190429152128.4mbqyipjv25jiiko@salvia>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <e30859ad-a4e9-b0fb-f37d-4e8dcf638fdb@solarflare.com>
Date:   Mon, 29 Apr 2019 17:25:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190429152128.4mbqyipjv25jiiko@salvia>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24580.005
X-TM-AS-Result: No-12.581000-4.000000-10
X-TMASE-MatchedRID: HXSqh3WYKfsbF9xF7zzuNSa1MaKuob8PC/ExpXrHizxV1lQ/Hn0TOvPM
        gMdM5A4ejL4yZhAqBTn74R5CCqjLXtbIurZnjVAYg2gX/Emjy1SjOD+AkhTbUzbV6I7x0gIJmpY
        YVVDsQzBUvbjPASn0LB2Pk0f04far4V7Lw7fwUM8zw5Ejs3g1lrQ0n3DEfu2Ti2g8XzxCDfthcJ
        qAtNJYSM41PT2VftWQuyS8CWRLQohqcOCJ4oqGatIxRgow+5HIPj366R4tj3WbKItl61J/yZkw8
        KdMzN86KrauXd3MZDWXf5sC39gVVOxaE5MUcTt+mZ6WwpKpbyqbYn5Qbl7Hnr82zIuRjhqBxYVz
        I3UCCaY=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--12.581000-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24580.005
X-MDID: 1556555116-vWo3jFxkVZsE
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/04/2019 16:21, Pablo Neira Ayuso wrote:
> On Mon, Apr 29, 2019 at 03:11:06PM +0100, Edward Cree wrote:
>> This is a bit of a mess; the best idea I've got is for the
>>  TC_CLSFLOWER_STATS call to include a tcfa_index.  Then the driver
>>  returns counter stats for that index, and tcf_exts_stats_update()
>>  only updates those actions whose index matches.  But then
>>  fl_hw_update_stats() would have to iterate over all the indices in
>>  f->exts.  What do you think?
> You could extend struct flow_stats to pass an array of stats to the
> driver, including one stats per action and the counter index. Then,
> tcf_exts_stats_update() uses this array of stats to update per-action
> stats.
Yes, but that means allocating the flow_stats.stats array each time;
 I'd rather avoid memory allocation unless it's necessary.  As long as
 we can move the preempt_disable() inside the loop that's currently in
 tcf_exts_stats_update() (i.e. only disable pre-emption across each
 individual call to tcf_action_stats_update()) I think we can.
I think I prefer my approach (ask for one tcfa_index at a time); but
 unmodified drivers that don't look at the passed index would return
 zeroes for actions after the first, so we'll need some way to handle
 those drivers separately (e.g. one tc_setup_cb_call with "answer
 this one if you don't do indices" and a bunch more with specified
 index values).  I think that requires much less change to the
 existing drivers than putting an array back in the API, and keeps as
 much of the work as possible in the core where it won't have to be
 replicated in every driver.
I'll put an RFC patch together soonish if no objections.

-Ed
