Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0F57410C
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 23:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388456AbfGXVt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 17:49:26 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:34416 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387517AbfGXVtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 17:49:24 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 191686C0072;
        Wed, 24 Jul 2019 21:49:23 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 24 Jul
 2019 14:49:19 -0700
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
 <927da9ee-c2fc-8556-fbeb-e26ea1c98d1e@solarflare.com>
 <d7ca6e7a-b80e-12e8-9050-c25b8b92bf26@gmail.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <a30137b4-1b01-df6e-c771-c5ddd1cfc490@solarflare.com>
Date:   Wed, 24 Jul 2019 22:49:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <d7ca6e7a-b80e-12e8-9050-c25b8b92bf26@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24792.002
X-TM-AS-Result: No-1.193700-4.000000-10
X-TMASE-MatchedRID: 8+bhjh9TQnHmLzc6AOD8DfHkpkyUphL9jIW07F8rFN/DQHsHQgjORD9D
        1N9xZ1/uafo8fdAv8snbDN6NSGrgx/C0efWAZXQdA9lly13c/gGMeFePU0tuMFLDlDlwWhcNjL4
        B9OUMY3WK8CLgrr3ye/fTd3Re7mQ63dpCt+02H6wvLP1C8DIeOudppbZRNp/IGsYFEOAsQ4jgcJ
        c1hBF7dkb1kKOfXoc7AvAS+4MtyNGfrFd6kw/dZyD3NF+wUeO92oQN+Q/21gSA6UrbM3j3qb7It
        ozLGgGlgGzqIeUiWyVUo0GMV1nFMP9IzD24yv0faEIbyoxb4rJfrNvzYhXvjNeM7+ynemuGi836
        2cmVmYCvAt00xEbNkV+24nCsUSFNjaPj0W1qn0TKayT/BQTiGh7uR6YYccjuvSZj/CFUC5q5u2n
        a0+bP0/7Bt8u0/kaNm7Fem/DfFB68TlkL1HNe4ETQ+Q5GfbR/QvLcPlsXjlydukAkCxaa0k3oBZ
        kjZklkBsRAh8WmTAcG2WAWHb2qekrMHC7kmmSWc5S6hNczuvhDDKa3G4nrLQ==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.193700-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24792.002
X-MDID: 1564004963-HG61dfVPYY18
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/07/2019 17:48, Eric Dumazet wrote:
>> but the rest is the stuff we're polling for for low latency.
>> I'm putting a gro_normal_list() call after the trace_napi_poll() in
>>  napi_busy_loop() and testing that, let's see how it goes...
One thing that's causing me some uncertainty: busy_poll_stop() does a
 napi->poll(), which can potentially gro_normal_one() something.  But
 when I tried to put a gro_normal_list() just after that, I ran into
 list corruption because it could race against the one in
 napi_complete_done().  I'm not entirely sure how, my current theory
 goes something like:
- clear_bit(IN_BUSY_POLL)
- task switch, start napi poll
- get as far as starting gro_normal_list()
- task switch back to busy_poll_stop()
- local_bh_disable()
- do a napi poll
- start gro_normal_list()
- list corruption ensues as we have two instances of
  netif_receive_skb_list_internal() trying to consume the same list
But I may be wildly mistaken.
Questions that arise from that:
1) Is it safe to potentially be adding to the rx_list (gro_normal_one(),
   which in theory can end up calling gro_normal_list() as well) within
   busy_poll_stop()?  I haven't ever seen a splat from that, but it seems
   every bit as possible as what I have been seeing.
2) Why does busy_poll_stop() not do its local_bh_disable() *before*
   clearing napi state bits, which (if I'm understanding correctly) would
   ensure an ordinary napi poll can't race with the one in busy_poll_stop()?

Apart from that I have indeed established that with the patches as posted
 busy-polling latency is awful, but adding a gro_normal_list() into
 napi_busy_loop() fixes that, as expected.

-Ed
