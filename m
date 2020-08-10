Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F29C2406A1
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 15:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgHJNej convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 10 Aug 2020 09:34:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31546 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726614AbgHJNei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 09:34:38 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-ybAf403CPwebUdQRv3AN3A-1; Mon, 10 Aug 2020 09:34:31 -0400
X-MC-Unique: ybAf403CPwebUdQRv3AN3A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 39FBA1009610;
        Mon, 10 Aug 2020 13:34:30 +0000 (UTC)
Received: from bistromath.localdomain (ovpn-112-107.ams2.redhat.com [10.36.112.107])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B77C919D7E;
        Mon, 10 Aug 2020 13:34:28 +0000 (UTC)
Date:   Mon, 10 Aug 2020 15:34:27 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Scott Dial <scott@scottdial.com>
Cc:     linux-crypto@vger.kernel.org, Ryan Cox <ryan_cox@byu.edu>,
        netdev@vger.kernel.org, davem@davemloft.net,
        Antoine Tenart <antoine.tenart@bootlin.com>
Subject: Re: Severe performance regression in "net: macsec: preserve ingress
 frame ordering"
Message-ID: <20200810133427.GB1128331@bistromath.localdomain>
References: <1b0cec71-d084-8153-2ba4-72ce71abeb65@byu.edu>
 <a335c8eb-0450-1274-d1bf-3908dcd9b251@scottdial.com>
MIME-Version: 1.0
In-Reply-To: <a335c8eb-0450-1274-d1bf-3908dcd9b251@scottdial.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[adding the linux-crypto list]

2020-08-06, 23:48:16 -0400, Scott Dial wrote:
> On 8/6/2020 5:11 PM, Ryan Cox wrote:
> > With 5.7 I get:
> > * 9.90 Gb/s with no macsec at all
> > * 1.80 Gb/s with macsec WITHOUT encryption
> > * 1.00 Gb/s (sometimes, but often less) with macsec WITH encryption
> > 
> > With 5.7 but with ab046a5d4be4c90a3952a0eae75617b49c0cb01b reverted, I get:
> > * 9.90 Gb/s with no macsec at all
> > * 7.33 Gb/s with macsec WITHOUT encryption
> > * 9.83 Gb/s with macsec WITH encryption
> > 
> > On tests where performance is bad (including macsec without encryption),
> > iperf3 is at 100% CPU usage.  I was able to run it under `perf record`on
> > iperf3 in a number of the tests but, unfortunately, I have had trouble
> > compiling perf for my own 5.7 compilations (definitely PEBKAC).  If it
> > would be useful I can work on fixing the perf compilation issues.
> 
> For certain, you are measuring the difference between AES-NI doing
> gcm(aes) and gcm_base(ctr(aes-aesni),ghash-generic). Specifically, the
> hotspot is ghash-generic's implementation of ghash_update() function.
> I appreciate your testing because I was limited in my ability to test
> beyond 1Gb/s.
> 
> The aes-aesni driver is smart enough to use the FPU if it's not busy and
> fallback to the CPU otherwise. Unfortunately, the ghash-clmulni driver
> does not have that kind of logic in it and only provides an async version,
> so we are forced to use the ghash-generic implementation, which is a pure
> CPU implementation. The ideal would be for aesni_intel to provide a
> synchronous version of gcm(aes) that fell back to the CPU if the FPU is
> busy.
> I don't know if the crypto maintainers would be open to such a change, but
> if the choice was between reverting and patching the crypto code, then I
> would work on patching the crypto code.

To the crypto folks, a bit of context: Scott wrote commit ab046a5d4be4
("net: macsec: preserve ingress frame ordering"), which made MACsec
use gcm(aes) with CRYPTO_ALG_ASYNC. This prevents out of order
decryption, but reduces performance. We'd like to restore performance
on systems where the FPU is available without breaking MACsec for
systems where the FPU is often busy.

A quick and dirty alternative might be to let the administrator decide
if they're ok with some out of order. Maybe they know that their FPU
will be mostly idle so it won't even be an issue (or maybe the
opposite, ie keep the fast default and let admins fix their setups
with an extra flag).

> In any case, you didn't report how many packets arrived out of order, which
> was the issue being addressed by my change. It would be helpful to get
> the output of "ip -s macsec show" and specifically the InPktsDelayed
> counter. Did iperf3 report out-of-order packets with the patch reverted?
> Otherwise, if this is the only process running on your test servers,
> then you may not be generating any contention for the FPU, which is the
> source of the out-of-order issue. Maybe you could run prime95 to busy
> the FPU to see the issue that I was seeing.

But that's not necessarily a realistic workload for all machines.

> I have a product that is a secure router with a half-dozen MACsec
> interfaces, boots from a LUKS-encrypted disk, and has a number of TLS
> control and status interfaces for local devices attached to product.
> Without this patch, the system was completely unusable due to the
> out-of-order issue causing TCP retries and UDP out-of-order issues. I
> have not seen any examples of this MACsec driver in the wild, so I
> assumed nobody had noticed the out-of-order issue because of synthetic
> testing.

We have customers using MACsec, and I haven't heard of reports like
yours.

-- 
Sabrina

