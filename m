Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86CA6242801
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 12:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbgHLKFH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 12 Aug 2020 06:05:07 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38778 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727065AbgHLKFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 06:05:07 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-Ae0TLzu7OEi0DkqR7I9Y2A-1; Wed, 12 Aug 2020 06:04:48 -0400
X-MC-Unique: Ae0TLzu7OEi0DkqR7I9Y2A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4AB031DE4;
        Wed, 12 Aug 2020 10:04:47 +0000 (UTC)
Received: from bistromath.localdomain (ovpn-112-107.ams2.redhat.com [10.36.112.107])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 37E495D9D7;
        Wed, 12 Aug 2020 10:04:44 +0000 (UTC)
Date:   Wed, 12 Aug 2020 12:04:43 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Scott Dial <scott@scottdial.com>
Cc:     linux-crypto@vger.kernel.org, Ryan Cox <ryan_cox@byu.edu>,
        netdev@vger.kernel.org, davem@davemloft.net,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        ebiggers@google.com
Subject: Re: Severe performance regression in "net: macsec: preserve ingress
 frame ordering"
Message-ID: <20200812100443.GF1128331@bistromath.localdomain>
References: <1b0cec71-d084-8153-2ba4-72ce71abeb65@byu.edu>
 <a335c8eb-0450-1274-d1bf-3908dcd9b251@scottdial.com>
 <20200810133427.GB1128331@bistromath.localdomain>
 <7663cbb1-7a55-6986-7d5d-8fab55887a80@scottdial.com>
MIME-Version: 1.0
In-Reply-To: <7663cbb1-7a55-6986-7d5d-8fab55887a80@scottdial.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sd@queasysnail.net
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-08-10, 12:09:40 -0400, Scott Dial wrote:
> On 8/10/2020 9:34 AM, Sabrina Dubroca wrote:
> > [adding the linux-crypto list]
> > 
> > 2020-08-06, 23:48:16 -0400, Scott Dial wrote:
> >> On 8/6/2020 5:11 PM, Ryan Cox wrote:
> >>> With 5.7 I get:
> >>> * 9.90 Gb/s with no macsec at all
> >>> * 1.80 Gb/s with macsec WITHOUT encryption
> >>> * 1.00 Gb/s (sometimes, but often less) with macsec WITH encryption
> >>>
> >>> With 5.7 but with ab046a5d4be4c90a3952a0eae75617b49c0cb01b reverted, I get:
> >>> * 9.90 Gb/s with no macsec at all
> >>> * 7.33 Gb/s with macsec WITHOUT encryption
> >>> * 9.83 Gb/s with macsec WITH encryption
> >>>
> >>> On tests where performance is bad (including macsec without encryption),
> >>> iperf3 is at 100% CPU usage.  I was able to run it under `perf record`on
> >>> iperf3 in a number of the tests but, unfortunately, I have had trouble
> >>> compiling perf for my own 5.7 compilations (definitely PEBKAC).  If it
> >>> would be useful I can work on fixing the perf compilation issues.
> >>
> >> For certain, you are measuring the difference between AES-NI doing
> >> gcm(aes) and gcm_base(ctr(aes-aesni),ghash-generic). Specifically, the
> >> hotspot is ghash-generic's implementation of ghash_update() function.
> >> I appreciate your testing because I was limited in my ability to test
> >> beyond 1Gb/s.
> >>
> >> The aes-aesni driver is smart enough to use the FPU if it's not busy and
> >> fallback to the CPU otherwise. Unfortunately, the ghash-clmulni driver
> >> does not have that kind of logic in it and only provides an async version,
> >> so we are forced to use the ghash-generic implementation, which is a pure
> >> CPU implementation. The ideal would be for aesni_intel to provide a
> >> synchronous version of gcm(aes) that fell back to the CPU if the FPU is
> >> busy.
> >> I don't know if the crypto maintainers would be open to such a change, but
> >> if the choice was between reverting and patching the crypto code, then I
> >> would work on patching the crypto code.
> > 
> > To the crypto folks, a bit of context: Scott wrote commit ab046a5d4be4
> > ("net: macsec: preserve ingress frame ordering"), which made MACsec
> > use gcm(aes) with CRYPTO_ALG_ASYNC. This prevents out of order
> > decryption, but reduces performance. We'd like to restore performance
> > on systems where the FPU is available without breaking MACsec for
> > systems where the FPU is often busy.
> > 
> > A quick and dirty alternative might be to let the administrator decide
> > if they're ok with some out of order. Maybe they know that their FPU
> > will be mostly idle so it won't even be an issue (or maybe the
> > opposite, ie keep the fast default and let admins fix their setups
> > with an extra flag).
> 
> I can appreciate favoring performance over correctness as practical
> concern, but I'd suggest that the out-of-order decryption *is* a
> performance concern as well. We can debate realness of my workload, but
> even in Ryan's tests on an otherwise idle server, he showed 0.07% of the
> frames needed to be dispatched to cryptd, and that for whatever reason
> it's more often with encryption disabled, which correlates to his
> decrease in throughput (9.83 Gb/s to 7.33 Gb/s, and 9.19 Gb/s to 6.00
> Gb/s), perhaps causing exponential backoff from TCP retries. I can
> resurrect my test setup, but my numbers were worse than Ryan's.
> 
> In any case, I counted 18 implementations of HW accelerated gcm(aes) in
> the kernel, with 3 of those implementations are in arch (x86, arm64, and
> s390) and the rest are crypto device drivers. Of all those
> implementations, the AES-NI implementation is the only one that
> dispatches to cryptd (via code in cypto/simd.c). AFAICT, every other
> implementation of gcm(aes) is synchronous, but they would require closer
> inspection to be certain.

I randomly picked 2 of them (chcr and inside-secure), and they both
set CRYPTO_ALG_ASYNC, so I guess not.

> So, I'd like to focus on what we can do to
> improve crypto/simd.c to provide a synchronous implementation of
> gcm(aes) for AES-NI when possible, which is the vast majority of the time.
>
> I would be interested in proposing a change to improve this issue, but
> I'm not sure the direction that the maintainers of this code would
> prefer. Since these changes to the crypto API are fairly recent, there
> may be context that I am not aware of. However, I think it would be
> straight-forward to add another API to crypto/simd.c that allocated sync
> algorithms, and I would be willing to do the work.
> 
> The only challenge I see in implementing such a change is deciding how
> to select a fallback algorithm. The most flexible solution would be to
> call crypto_alloc_aead with CRYPTO_ALG_ASYNC during the init to pick the
> "best" fallback (in case there is alternative HW offloading available),
> but that would almost certainly pick itself and it's not obvious to me
> how to avoid that.

It's probably possible to add a PURE_SOFTWARE or whatever flag and
request one of those algorithms for the fallback.

> On the other hand, the caller to the new API could
> explicitly declare a fallback algorithm (e.g.,
> "gcm_base(ctr(aes-aesni),ghash-generic)"), which probably is the correct
> answer anyways --

I would try to avoid that, it seems too error-prone to me.

> what are the chances that there is multiple HW
> offloads for gcm(aes)? In that case, a possible API would be:
> int simd_register_aeads_compat_sync(struct aead_alg *algs,
>                                     char **fallback_algs,
>                                     int count,
> 			            struct simd_aead_alg **simd_algs);
> 
> Beyond MACsec, it's worth noting that the mac80211 code for AES-GCMP and
> BIP-GMAC also use gcm(aes) in sync mode because decryption occurs in a
> softirq, however I imagine nobody has reported an issue because the link
> speed is typically slower and those encryption modes are still uncommon.

Decent wireless cards would do the encryption in hw, no? Also, you
can't notice a performance regression if it's never used the fast
implementation :)

-- 
Sabrina

