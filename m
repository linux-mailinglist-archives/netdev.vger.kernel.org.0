Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B41B240AF5
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 18:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgHJQJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 12:09:46 -0400
Received: from bert.scottdial.com ([104.237.142.221]:50952 "EHLO
        bert.scottdial.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbgHJQJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 12:09:46 -0400
Received: from mail.scottdial.com (mail.scottdial.com [10.8.0.6])
        by bert.scottdial.com (Postfix) with ESMTP id C00E455D8E0;
        Mon, 10 Aug 2020 12:09:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.scottdial.com (Postfix) with ESMTP id 5D00F111B498;
        Mon, 10 Aug 2020 12:09:43 -0400 (EDT)
Received: from mail.scottdial.com ([127.0.0.1])
        by localhost (mail.scottdial.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id QqXWQqRqVMkN; Mon, 10 Aug 2020 12:09:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.scottdial.com (Postfix) with ESMTP id 9C219111B499;
        Mon, 10 Aug 2020 12:09:41 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.scottdial.com 9C219111B499
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=scottdial.com;
        s=24B7B964-7506-11E8-A7D6-CF6FBF8C6FCF; t=1597075781;
        bh=wNy1XyhVsfquc4ctXPEuwQIkMVN0ZkmOYRWr/geGRUY=;
        h=To:From:Message-ID:Date:MIME-Version;
        b=oIrrpNfKNnWY1t2NsUdQW8mr3rR9Hk7hg0lAXibz7DGr0DlMkal7VWZSFAAtlJ761
         NFu+ngM98jhXfqYSVvOzjxPqF/RZxoR/JGD6jV/uC6Qd0UDzdltUvdg1NdZGJ0gx9a
         QQbnULYT5hSj9CWh8Sk/xncPzhkSiU90w8RycP3wyzKinFps6nnOIIjShqIXhlg+k9
         tKRwf5kA1Q632mQ2V4jU9h/y/SRcRrdAX5tOEjBlyD4C+GvhGiotQn/eE7DLkF/Yv6
         15DSUUGiUv4uW5TOvQubWE33cNC3IuWnkBaDg7NGPwnZrkygtohwfIvPq1Xz9t7WQ/
         zMix+X43FiBtQ==
X-Virus-Scanned: amavisd-new at scottdial.com
Received: from mail.scottdial.com ([127.0.0.1])
        by localhost (mail.scottdial.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id cAG-HUHt1Nrf; Mon, 10 Aug 2020 12:09:41 -0400 (EDT)
Received: from [172.17.2.2] (unknown [172.17.2.2])
        by mail.scottdial.com (Postfix) with ESMTPSA id 383D8111B498;
        Mon, 10 Aug 2020 12:09:41 -0400 (EDT)
Subject: Re: Severe performance regression in "net: macsec: preserve ingress
 frame ordering"
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     linux-crypto@vger.kernel.org, Ryan Cox <ryan_cox@byu.edu>,
        netdev@vger.kernel.org, davem@davemloft.net,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        ebiggers@google.com
References: <1b0cec71-d084-8153-2ba4-72ce71abeb65@byu.edu>
 <a335c8eb-0450-1274-d1bf-3908dcd9b251@scottdial.com>
 <20200810133427.GB1128331@bistromath.localdomain>
From:   Scott Dial <scott@scottdial.com>
Message-ID: <7663cbb1-7a55-6986-7d5d-8fab55887a80@scottdial.com>
Date:   Mon, 10 Aug 2020 12:09:40 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200810133427.GB1128331@bistromath.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/10/2020 9:34 AM, Sabrina Dubroca wrote:
> [adding the linux-crypto list]
>=20
> 2020-08-06, 23:48:16 -0400, Scott Dial wrote:
>> On 8/6/2020 5:11 PM, Ryan Cox wrote:
>>> With 5.7 I get:
>>> * 9.90 Gb/s with no macsec at all
>>> * 1.80 Gb/s with macsec WITHOUT encryption
>>> * 1.00 Gb/s (sometimes, but often less) with macsec WITH encryption
>>>
>>> With 5.7 but with ab046a5d4be4c90a3952a0eae75617b49c0cb01b reverted, =
I get:
>>> * 9.90 Gb/s with no macsec at all
>>> * 7.33 Gb/s with macsec WITHOUT encryption
>>> * 9.83 Gb/s with macsec WITH encryption
>>>
>>> On tests where performance is bad (including macsec without encryptio=
n),
>>> iperf3 is at 100% CPU usage.=C2=A0 I was able to run it under `perf r=
ecord`on
>>> iperf3 in a number of the tests but, unfortunately, I have had troubl=
e
>>> compiling perf for my own 5.7 compilations (definitely PEBKAC).=C2=A0=
 If it
>>> would be useful I can work on fixing the perf compilation issues.
>>
>> For certain, you are measuring the difference between AES-NI doing
>> gcm(aes) and gcm_base(ctr(aes-aesni),ghash-generic). Specifically, the
>> hotspot is ghash-generic's implementation of ghash_update() function.
>> I appreciate your testing because I was limited in my ability to test
>> beyond 1Gb/s.
>>
>> The aes-aesni driver is smart enough to use the FPU if it's not busy a=
nd
>> fallback to the CPU otherwise. Unfortunately, the ghash-clmulni driver
>> does not have that kind of logic in it and only provides an async vers=
ion,
>> so we are forced to use the ghash-generic implementation, which is a p=
ure
>> CPU implementation. The ideal would be for aesni_intel to provide a
>> synchronous version of gcm(aes) that fell back to the CPU if the FPU i=
s
>> busy.
>> I don't know if the crypto maintainers would be open to such a change,=
 but
>> if the choice was between reverting and patching the crypto code, then=
 I
>> would work on patching the crypto code.
>=20
> To the crypto folks, a bit of context: Scott wrote commit ab046a5d4be4
> ("net: macsec: preserve ingress frame ordering"), which made MACsec
> use gcm(aes) with CRYPTO_ALG_ASYNC. This prevents out of order
> decryption, but reduces performance. We'd like to restore performance
> on systems where the FPU is available without breaking MACsec for
> systems where the FPU is often busy.
>=20
> A quick and dirty alternative might be to let the administrator decide
> if they're ok with some out of order. Maybe they know that their FPU
> will be mostly idle so it won't even be an issue (or maybe the
> opposite, ie keep the fast default and let admins fix their setups
> with an extra flag).

I can appreciate favoring performance over correctness as practical
concern, but I'd suggest that the out-of-order decryption *is* a
performance concern as well. We can debate realness of my workload, but
even in Ryan's tests on an otherwise idle server, he showed 0.07% of the
frames needed to be dispatched to cryptd, and that for whatever reason
it's more often with encryption disabled, which correlates to his
decrease in throughput (9.83 Gb/s to 7.33 Gb/s, and 9.19 Gb/s to 6.00
Gb/s), perhaps causing exponential backoff from TCP retries. I can
resurrect my test setup, but my numbers were worse than Ryan's.

In any case, I counted 18 implementations of HW accelerated gcm(aes) in
the kernel, with 3 of those implementations are in arch (x86, arm64, and
s390) and the rest are crypto device drivers. Of all those
implementations, the AES-NI implementation is the only one that
dispatches to cryptd (via code in cypto/simd.c). AFAICT, every other
implementation of gcm(aes) is synchronous, but they would require closer
inspection to be certain. So, I'd like to focus on what we can do to
improve crypto/simd.c to provide a synchronous implementation of
gcm(aes) for AES-NI when possible, which is the vast majority of the time=
.

I would be interested in proposing a change to improve this issue, but
I'm not sure the direction that the maintainers of this code would
prefer. Since these changes to the crypto API are fairly recent, there
may be context that I am not aware of. However, I think it would be
straight-forward to add another API to crypto/simd.c that allocated sync
algorithms, and I would be willing to do the work.

The only challenge I see in implementing such a change is deciding how
to select a fallback algorithm. The most flexible solution would be to
call crypto_alloc_aead with CRYPTO_ALG_ASYNC during the init to pick the
"best" fallback (in case there is alternative HW offloading available),
but that would almost certainly pick itself and it's not obvious to me
how to avoid that. On the other hand, the caller to the new API could
explicitly declare a fallback algorithm (e.g.,
"gcm_base(ctr(aes-aesni),ghash-generic)"), which probably is the correct
answer anyways -- what are the chances that there is multiple HW
offloads for gcm(aes)? In that case, a possible API would be:

int simd_register_aeads_compat_sync(struct aead_alg *algs,
                                    char **fallback_algs,
                                    int count,
			            struct simd_aead_alg **simd_algs);

Beyond MACsec, it's worth noting that the mac80211 code for AES-GCMP and
BIP-GMAC also use gcm(aes) in sync mode because decryption occurs in a
softirq, however I imagine nobody has reported an issue because the link
speed is typically slower and those encryption modes are still uncommon.

--=20
Scott Dial
scott@scottdial.com
