Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9C5B672DD
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 17:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbfGLP74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 11:59:56 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:51974 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726992AbfGLP7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 11:59:55 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 376354C0061;
        Fri, 12 Jul 2019 15:59:54 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 12 Jul
 2019 08:59:50 -0700
Subject: Re: [RFC PATCH net-next 0/3] net: batched receive in GRO path
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>
References: <7920e85c-439e-0622-46f8-0602cf37e306@solarflare.com>
 <c80a9e7846bf903728327a1ca2c3bdcc078057a2.camel@redhat.com>
 <677040f4-05d1-e664-d24a-5ee2d2edcdbd@solarflare.com>
 <1735314f-3c6a-45fc-0270-b90cc4d5d6ba@gmail.com>
 <4516a34a-5a88-88ef-e761-7512dff4f3ce@solarflare.com>
 <38ff0ce0-7e26-1683-90f0-adc9c0ac9abe@gmail.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <927da9ee-c2fc-8556-fbeb-e26ea1c98d1e@solarflare.com>
Date:   Fri, 12 Jul 2019 16:59:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <38ff0ce0-7e26-1683-90f0-adc9c0ac9abe@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24752.005
X-TM-AS-Result: No-0.793900-4.000000-10
X-TMASE-MatchedRID: zGP2F0O7j/vmLzc6AOD8DfHkpkyUphL9vMRNh9hLjFkN1GharxC4Vh8a
        RhKglPt8MkD82d8QeUgrnb4nIraZw+q4eBfl/7E8M71h0SMVl8IGchEhVwJY3/pmcjkHZ8l7sVQ
        jUK5/ysnC4wmUkR7jamggkMcg8tITxnMngDvUy6nvWGhFrXKaNviH64jt3FfED5cyUgWQb9WQ2R
        P0epqKb+aP62L1S/onX7bicKxRIU2jXmQlwROveWrz/G/ZSbVq+gtHj7OwNO34ZhR52Rc1akmYJ
        UcmmmV4EcBCAINv3nste9qj8HHZNGBDg9q5BJMbWsXfcuk2iQb1JkrkU09vPuXq904rTlMak0kG
        S3cR7Ps9Dz34CBgs2IfMZMegLDIeGU0pKnas+RbnCJftFZkZizYJYNFU00e7N+XOQZygrvY=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.793900-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24752.005
X-MDID: 1562947194-MOInDFL7mw6C
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/07/2019 18:39, Eric Dumazet wrote:
> Holding a small packet in the list up to the point we call busy_poll_stop()
> will basically make busypoll non working anymore.
>
> napi_complete_done() has special behavior when busy polling is active.
Yep, I get it now, sorry for being dumb :)
Essentially we're saying that things coalesced by GRO are 'bulk' traffic and
 can wait around, but the rest is the stuff we're polling for for low latency.
I'm putting a gro_normal_list() call after the trace_napi_poll() in
 napi_busy_loop() and testing that, let's see how it goes...
