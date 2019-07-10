Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21E6F642D2
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 09:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfGJH1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 03:27:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39102 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726198AbfGJH1E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 03:27:04 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C8DBA308212A;
        Wed, 10 Jul 2019 07:27:03 +0000 (UTC)
Received: from ovpn-116-225.ams2.redhat.com (ovpn-116-225.ams2.redhat.com [10.36.116.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 953D818503;
        Wed, 10 Jul 2019 07:27:02 +0000 (UTC)
Message-ID: <c80a9e7846bf903728327a1ca2c3bdcc078057a2.camel@redhat.com>
Subject: Re: [RFC PATCH net-next 0/3] net: batched receive in GRO path
From:   Paolo Abeni <pabeni@redhat.com>
To:     Edward Cree <ecree@solarflare.com>,
        David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Date:   Wed, 10 Jul 2019 09:27:01 +0200
In-Reply-To: <7920e85c-439e-0622-46f8-0602cf37e306@solarflare.com>
References: <7920e85c-439e-0622-46f8-0602cf37e306@solarflare.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Wed, 10 Jul 2019 07:27:03 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, 2019-07-09 at 20:27 +0100, Edward Cree wrote:
> Where not specified (as batch=), net.core.gro_normal_batch was set to 8.
> The net-next baseline used for these tests was commit 7d30a7f6424e.
> TCP 4 streams, GRO on: all results line rate (9.415Gbps)
> net-next: 210.3% cpu
> after #1: 181.5% cpu (-13.7%, p=0.031 vs net-next)
> after #3: 191.7% cpu (- 8.9%, p=0.102 vs net-next)
> TCP 4 streams, GRO off:
> after #1: 7.785 Gbps
> after #3: 8.387 Gbps (+ 7.7%, p=0.215 vs #1, but note *)
> TCP 1 stream, GRO on: all results line rate & ~200% cpu.
> TCP 1 stream, GRO off:
> after #1: 6.444 Gbps
> after #3: 7.363 Gbps (+14.3%, p=0.003 vs #1)
> batch=16: 7.199 Gbps
> batch= 4: 7.354 Gbps
> batch= 0: 5.899 Gbps
> TCP 100 RR, GRO off:
> net-next: 995.083 us
> after #1: 969.167 us (- 2.6%, p=0.204 vs net-next)
> after #3: 976.433 us (- 1.9%, p=0.254 vs net-next)
> 
> (*) These tests produced a mixture of line-rate and below-line-rate results,
>  meaning that statistically speaking the results were 'censored' by the
>  upper bound, and were thus not normally distributed, making a Welch t-test
>  mathematically invalid.  I therefore also calculated estimators according
>  to [2], which gave the following:
> after #1: 8.155 Gbps
> after #3: 8.716 Gbps (+ 6.9%, p=0.291 vs #1)
> (though my procedure for determining ν wasn't mathematically well-founded
>  either, so take that p-value with a grain of salt).

I'm toying with a patch similar to your 3/3 (most relevant difference
being the lack of a limit to the batch size), on top of ixgbe (which
sends all the pkts to the GRO engine), and I'm observing more
controversial results (UDP only):

* when a single rx queue is running, I see a just-above-noise
peformance delta
* when multiple rx queues are running, I observe measurable regressions
(note: I use small pkts, still well under line rate even with multiple
rx queues)

I'll try to test your patch in the following days.

Side note: I think that in patch 3/3, it's necessary to add a call to
gro_normal_list() also inside napi_busy_loop().

Cheers,

Paolo




