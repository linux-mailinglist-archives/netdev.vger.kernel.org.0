Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB22F17EDC
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 19:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbfEHRHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 13:07:23 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:56036 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728929AbfEHRHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 13:07:23 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (Proofpoint Essentials ESMTP Server) with ESMTPS id 8218A80007D;
        Wed,  8 May 2019 17:07:21 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 8 May
 2019 10:07:17 -0700
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
        "Anjali Singhai Jain" <anjali.singhai@intel.com>,
        Or Gerlitz <gerlitz.or@gmail.com>
References: <alpine.LFD.2.21.1905031603340.11823@ehc-opti7040.uk.solarflarecom.com>
 <20190504022759.64232fc0@cakuba.netronome.com>
 <db827a95-1042-cf74-1378-8e2eac356e6d@mojatatu.com>
 <1b37d659-5a2b-6130-e8d6-c15d6f57b55e@solarflare.com>
 <ab1f179e-9a91-837b-28c8-81eecbd09e7f@mojatatu.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <1c0d0a0a-a74b-c887-d615-0f0c0d2e1b9a@solarflare.com>
Date:   Wed, 8 May 2019 18:07:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <ab1f179e-9a91-837b-28c8-81eecbd09e7f@mojatatu.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24598.005
X-TM-AS-Result: No-6.494400-4.000000-10
X-TMASE-MatchedRID: 9zTThWtzImsOwH4pD14DsPHkpkyUphL97yWPaQc4INTNDTnArhVuta0R
        omhWPJaQz73JpzohJLUUU1QqiMTlE8ELNaJ3xbLZolVO7uyOCDW/zKpacmFSwUfLNMv2kATUH0M
        oG6N39woIlaeG67IFR8mfKGAL1SNKB7W827nnV43AJnGRMfFxySseSAhqf1rRxIfiDorMW4FP/W
        ufUTopH+fOVcxjDhcwPcCXjNqUmkXCttcwYNipXyBYBMziildmKJX5NIHMozdUyFPNdWccFV8Fn
        spFB05j4qYP1S8fshFWXGvUUmKP2w==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.494400-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24598.005
X-MDID: 1557335242-cDpd4Z_SIzex
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/05/2019 15:02, Jamal Hadi Salim wrote:
> The lazy thing most people have done is essentially assume that
> there is a stat per filter rule...
> I wouldnt call it the 'the right thing'
Yup, that's why I'm trying to not do that ;-)

> Yes, the index at tc semantics level is per-action type.
> So "mirred index 1" and "drop index 1" are not the same stats counter.
Ok, then that kills the design I used here that relied entirely on the
 index to specify counters.
I guess instead I'll have to go with the approach Pablo suggested,
 passing an array of struct flow_stats in the callback, thus using
 the index into that array (which corresponds to the index in
 f->exts->actions) to identify different counters.
Which means I will have to change all the existing drivers, which will
 largely revert (from the drivers' perspective) the change when Pablo
 took f->exts away from them — they will go back to calling something
 that looks a lot like tcf_exts_stats_update().
However, that'll mean the API has in-tree users, so it might be
 considered mergeable(?)

-Ed
