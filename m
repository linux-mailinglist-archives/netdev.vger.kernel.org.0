Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB214104187
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 17:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732947AbfKTQzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 11:55:00 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:36924 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732934AbfKTQy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 11:54:59 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D3CC7B8007D;
        Wed, 20 Nov 2019 16:54:57 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 20 Nov
 2019 16:54:51 +0000
Subject: Re: [PATCH net-next v4 0/5] net: introduce and use route hint
To:     Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        "Eric Dumazet" <eric.dumazet@gmail.com>
References: <cover.1574252982.git.pabeni@redhat.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <7b5fe6ee-4fa2-a6bd-890c-160fff3ec74d@solarflare.com>
Date:   Wed, 20 Nov 2019 16:54:47 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <cover.1574252982.git.pabeni@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25054.003
X-TM-AS-Result: No-6.276800-8.000000-10
X-TMASE-MatchedRID: hls5oAVArl/mLzc6AOD8DfHkpkyUphL9Rf40pT7Zmv5v/W4eavUSapT4
        r6hJ177amkxoTJDlzWNb4Fh2UiAd4PXWu0SHMjQBLTHwnYOikQ19twJClWWSl3SvE1gDT3721DQ
        W12L1ci58Ad4EgPHGQ8RqIRn9VYOdYMunTeJZsMlQUls+WYG/w7LUwzrY3osFFvJGNU1BtTDlMv
        pqkHcOysOBiom+a8tvAG6+QM9NR6iuiou+aTfj1smiSRTHZQzXdc0p8KbvPW1oe+v2w6RhK9kbV
        xyiYfRTNNN0dk/lb44qq3YUbX8N0L9ZdlL8eonaRjjVhf+j/wpKdDgyPBo71yq2rl3dzGQ1z0mb
        Rnu/n++d/9kSGm/YvXa9CHaEyjwVTBnadAgCdc9U6q4Cl4ofkCcb9ysEzj2xk46vCHW9WxRJyfs
        VBqEdnFx4+7VedSCX3JLkghNbODAGxECHxaZMBwbZYBYdvap6SswcLuSaZJZzlLqE1zO6+EMMpr
        cbiest
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.276800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25054.003
X-MDID: 1574268898-Jo39NCoo-7Jf
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/11/2019 12:47, Paolo Abeni wrote:
> This series leverages the listification infrastructure to avoid
> unnecessary route lookup on ingress packets. In absence of custom rules,
> packets with equal daddr will usually land on the same dst.
>
> When processing packet bursts (lists) we can easily reference the previous
> dst entry. When we hit the 'same destination' condition we can avoid the
> route lookup, coping the already available dst.
>
> Detailed performance numbers are available in the individual commit
> messages.
I wonder if you could use static keys for the fib*_has_custom_rules()
 and if that would gain you any extra speed?
Other than that,
Acked-by: Edward Cree <ecree@solarflare.com>
 for the series.
>
> v3 -> v4:
>  - move helpers to their own patches (Eric D.)
>  - enable hints for SUBTREE builds (David A.)
>  - re-enable hints for ipv4 forward (David A.)
>
> v2 -> v3:
>  - use fib*_has_custom_rules() helpers (David A.)
>  - add ip*_extract_route_hint() helper (Edward C.)
>  - use prev skb as hint instead of copying data (Willem )
>
> v1 -> v2:
>  - fix build issue with !CONFIG_IP*_MULTIPLE_TABLES
>  - fix potential race in ip6_list_rcv_finish()
>
> Paolo Abeni (5):
>   ipv6: add fib6_has_custom_rules() helper
>   ipv6: keep track of routes using src
>   ipv6: introduce and uses route look hints for list input.
>   ipv4: move fib4_has_custom_rules() helper to public header
>   ipv4: use dst hint for ipv4 list receive
>
>  include/net/ip6_fib.h    | 39 +++++++++++++++++++++++++++++++++++++
>  include/net/ip_fib.h     | 10 ++++++++++
>  include/net/netns/ipv6.h |  3 +++
>  include/net/route.h      |  4 ++++
>  net/ipv4/fib_frontend.c  | 10 ----------
>  net/ipv4/ip_input.c      | 35 +++++++++++++++++++++++++++++----
>  net/ipv4/route.c         | 42 ++++++++++++++++++++++++++++++++++++++++
>  net/ipv6/ip6_fib.c       |  4 ++++
>  net/ipv6/ip6_input.c     | 26 +++++++++++++++++++++++--
>  net/ipv6/route.c         |  3 +++
>  10 files changed, 160 insertions(+), 16 deletions(-)
>

