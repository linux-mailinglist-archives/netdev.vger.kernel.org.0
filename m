Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A638D648A8
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 16:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbfGJOwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 10:52:14 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:48416 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726097AbfGJOwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 10:52:13 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4FFFFA40073;
        Wed, 10 Jul 2019 14:52:12 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 10 Jul
 2019 07:52:08 -0700
Subject: Re: [RFC PATCH net-next 0/3] net: batched receive in GRO path
To:     Paolo Abeni <pabeni@redhat.com>, David Miller <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <7920e85c-439e-0622-46f8-0602cf37e306@solarflare.com>
 <c80a9e7846bf903728327a1ca2c3bdcc078057a2.camel@redhat.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <677040f4-05d1-e664-d24a-5ee2d2edcdbd@solarflare.com>
Date:   Wed, 10 Jul 2019 15:52:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <c80a9e7846bf903728327a1ca2c3bdcc078057a2.camel@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24750.005
X-TM-AS-Result: No-4.957400-4.000000-10
X-TMASE-MatchedRID: X4bcv0S75KnmLzc6AOD8DfHkpkyUphL9+IfriO3cV8T5+tteD5RzhWRW
        ePusFQaMQP46fVlibR/zCPLlhTGnu63czi5f92v9Knjj4PzuQYcT2wrWDpJvKDnZfxjBVQRbgYq
        Cs2yuWCZbdScq6YVMbr+l/MvfKaYIX4o9HAogemZTLFbi+a8u3aI0K26z6c862C69GeK9wyi0sx
        58aisyVazDOPZyHOu1ceEONRK33irCetoOXF2sRVb0VO9AmFFdaKq1Yhw50ju67Q3uPo9KIxOC3
        iCulpIKdEq4zFoA8pZ68WLQFTm00WDgAHcIsJL2zNIobH2DzGH348e2CE/wYopc3JtqeiRPXa9+
        3ZJzfMIM4/EABi8Rha4j4Hj3LB/CaBevM/eurMeeAiCmPx4NwHJnzNw42kCxxEHRux+uk8jQ9TR
        N0mhS11EdxJidWUOjb9C/89aoPjQ7oYwEPB4mL5nFo/AWVHrAS4EMi5G6bY6eVvvvn/KGjmKi9O
        PpPTo8rzzfBwjd8W+G7c45hdXqQYVyAlz5A0zC7xsmi8libwVi6nHReNJA8sM4VWYqoYnhs+fe0
        WifpQo=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.957400-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24750.005
X-MDID: 1562770332-OMrC8JgZktOC
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/07/2019 08:27, Paolo Abeni wrote:
> I'm toying with a patch similar to your 3/3 (most relevant difference
> being the lack of a limit to the batch size), on top of ixgbe (which
> sends all the pkts to the GRO engine), and I'm observing more
> controversial results (UDP only):
>
> * when a single rx queue is running, I see a just-above-noise
> peformance delta
> * when multiple rx queues are running, I observe measurable regressions
> (note: I use small pkts, still well under line rate even with multiple
> rx queues)
>
> I'll try to test your patch in the following days.
I look forward to it.

> Side note: I think that in patch 3/3, it's necessary to add a call to
> gro_normal_list() also inside napi_busy_loop().
Hmm, I was caught out by the call to napi_poll() actually being a local
 function pointer, not the static function of the same name.  How did a
 shadow like that ever get allowed?
But in that case I _really_ don't understand napi_busy_loop(); nothing
 in it seems to ever flush GRO, so it's relying on either
 (1) stuff getting flushed because the bucket runs out of space, or
 (2) the next napi poll after busy_poll_stop() doing the flush.
What am I missing, and where exactly in napi_busy_loop() should the
 gro_normal_list() call go?

-Ed
