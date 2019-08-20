Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6608C9686D
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 20:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730142AbfHTSPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 14:15:17 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:51910 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727006AbfHTSPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 14:15:17 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id C1D4D100077;
        Tue, 20 Aug 2019 18:15:15 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 20 Aug
 2019 11:15:11 -0700
Subject: Re: [PATCH net-next 1/2] net: flow_offload: mangle 128-bit packet
 field with one action
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <netfilter-devel@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <jakub.kicinski@netronome.com>,
        <jiri@resnulli.us>, <vladbu@mellanox.com>
References: <20190820105225.13943-1-pablo@netfilter.org>
 <f18d8369-f87d-5b9a-6c9d-daf48a3b95f1@solarflare.com>
 <20190820144453.ckme6oj2c4hmofhu@salvia>
 <c8a00a98-74eb-9f8d-660f-c2ea159dec91@solarflare.com>
 <20190820173344.3nrzfjboyztz3lji@salvia>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <f4cf8a97-3322-d982-6068-d4c0ce997b1c@solarflare.com>
Date:   Tue, 20 Aug 2019 19:15:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190820173344.3nrzfjboyztz3lji@salvia>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24858.005
X-TM-AS-Result: No-5.519200-4.000000-10
X-TMASE-MatchedRID: 9zTThWtzImsbF9xF7zzuNfZvT2zYoYOwC/ExpXrHizyXLxteTkbUDyiZ
        psjkkNK7cOwULTxNTS38nUTy5iFBDFtxk61WvxUuiVJZi91I9JhgFto/VVnNJUTqq9Xa45y5r4D
        XF8+ppZAzhlbHXiALdFQHo6JVIdqWHxrbuiP4bz4iMpIfyuUBO9THOkgubClWpZud0fqWp9ijxY
        yRBa/qJQOkBnb8H8GWDV8DVAd6AO/dB/CxWTRRu4as+d5/8j56Nk8z7eUgWBlSB56NfcvC2fRy9
        sZeYHW39O/qj5Q5uaW6DnxS4FLt5w==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.519200-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24858.005
X-MDID: 1566324916-NrYtBXEXYXn9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/08/2019 18:33, Pablo Neira Ayuso wrote:
> I can update tc pedit to generate one single action for offset
> consecutive packet editions, if that is the concern, I'll send a v2.
IMHO the fix belongs in TC userland (i.e. iproute2), to turn a single action on the commandline for an ipv6 addr into four pedit actions before the kernel ever sees it.
Similarly if nftables wants to use this it should generate four separate pedit actions, probably in the kernel netfilter code as (I assume) your uAPI talks in terms of named fields rather than the u32ish offsets and masks of tc pedit.
The TC (well, flow_offload now I suppose) API should be kept narrow, not widened for things that can already be expressed adequately.  Your array of words inside a pedit action looks like a kind of loop unrolling but for data structures, which doesn't look sensible to me.

-Ed
