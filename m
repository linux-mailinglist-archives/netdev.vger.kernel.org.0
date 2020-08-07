Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8D123E66A
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 05:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgHGDye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 23:54:34 -0400
Received: from bert.scottdial.com ([104.237.142.221]:50932 "EHLO
        bert.scottdial.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbgHGDye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 23:54:34 -0400
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Aug 2020 23:54:33 EDT
Received: from mail.scottdial.com (mail.scottdial.com [10.8.0.6])
        by bert.scottdial.com (Postfix) with ESMTP id 066BC55D8E0;
        Thu,  6 Aug 2020 23:48:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.scottdial.com (Postfix) with ESMTP id 9B0E5111B498;
        Thu,  6 Aug 2020 23:48:18 -0400 (EDT)
Received: from mail.scottdial.com ([127.0.0.1])
        by localhost (mail.scottdial.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id qq_0G-g00mCK; Thu,  6 Aug 2020 23:48:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.scottdial.com (Postfix) with ESMTP id 1A61B111B499;
        Thu,  6 Aug 2020 23:48:17 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.scottdial.com 1A61B111B499
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=scottdial.com;
        s=24B7B964-7506-11E8-A7D6-CF6FBF8C6FCF; t=1596772097;
        bh=Y3LP9ocxM+kIX7jqlzS8eHDhCzjt3h2gOn3M4dd4FwM=;
        h=To:From:Message-ID:Date:MIME-Version;
        b=NtduPuFI6Wp2ylGrCKMkRmp2yCSB/tyNMjbKqKMUtwmg5aRqAPmxmstRh3Rjj6le9
         RkHBvERyWer3c0N8QzYewUmleyv9mgGcv4N28IyrSZP8mwtChHutem/QtZHI4VyY9D
         Xfc9Jxj8vQ2hMQUDbSFM3WqFH26g46SsSVTbC/LzQ7TCe3TdP2UKrCcIkoC8JFhnpe
         nChqoZOa36Pv8pIE8PiQrnJzr80M0LnDEI4u/rqRyn41CndD+rW2AnU/oKpWvSZVHz
         ckCT6hzmBxZsTpsT0NOyyZDjhGIyeZTnRjCViEaUhpoWsfX1s1sYp7MkpPFCQL5gsc
         uehK8ONMkiRog==
X-Virus-Scanned: amavisd-new at scottdial.com
Received: from mail.scottdial.com ([127.0.0.1])
        by localhost (mail.scottdial.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id lUvO4T70Grwn; Thu,  6 Aug 2020 23:48:16 -0400 (EDT)
Received: from [172.17.2.2] (unknown [172.17.2.2])
        by mail.scottdial.com (Postfix) with ESMTPSA id BD1A2111B498;
        Thu,  6 Aug 2020 23:48:16 -0400 (EDT)
Subject: Re: Severe performance regression in "net: macsec: preserve ingress
 frame ordering"
To:     Ryan Cox <ryan_cox@byu.edu>, netdev@vger.kernel.org,
        davem@davemloft.net, sd@queasysnail.net
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>
References: <1b0cec71-d084-8153-2ba4-72ce71abeb65@byu.edu>
From:   Scott Dial <scott@scottdial.com>
Message-ID: <a335c8eb-0450-1274-d1bf-3908dcd9b251@scottdial.com>
Date:   Thu, 6 Aug 2020 23:48:16 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <1b0cec71-d084-8153-2ba4-72ce71abeb65@byu.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/6/2020 5:11 PM, Ryan Cox wrote:
> With 5.7 I get:
> * 9.90 Gb/s with no macsec at all
> * 1.80 Gb/s with macsec WITHOUT encryption
> * 1.00 Gb/s (sometimes, but often less) with macsec WITH encryption
>=20
> With 5.7 but with ab046a5d4be4c90a3952a0eae75617b49c0cb01b reverted, I =
get:
> * 9.90 Gb/s with no macsec at all
> * 7.33 Gb/s with macsec WITHOUT encryption
> * 9.83 Gb/s with macsec WITH encryption
>=20
> On tests where performance is bad (including macsec without encryption)=
,
> iperf3 is at 100% CPU usage.=C2=A0 I was able to run it under `perf rec=
ord`on
> iperf3 in a number of the tests but, unfortunately, I have had trouble
> compiling perf for my own 5.7 compilations (definitely PEBKAC).=C2=A0 I=
f it
> would be useful I can work on fixing the perf compilation issues.

For certain, you are measuring the difference between AES-NI doing
gcm(aes) and gcm_base(ctr(aes-aesni),ghash-generic). Specifically, the
hotspot is ghash-generic's implementation of ghash_update() function.
I appreciate your testing because I was limited in my ability to test
beyond 1Gb/s.

The aes-aesni driver is smart enough to use the FPU if it's not busy and
fallback to the CPU otherwise. Unfortunately, the ghash-clmulni driver
does not have that kind of logic in it and only provides an async version=
,
so we are forced to use the ghash-generic implementation, which is a pure
CPU implementation. The ideal would be for aesni_intel to provide a
synchronous version of gcm(aes) that fell back to the CPU if the FPU is
busy.
I don't know if the crypto maintainers would be open to such a change, bu=
t
if the choice was between reverting and patching the crypto code, then I
would work on patching the crypto code.

In any case, you didn't report how many packets arrived out of order, whi=
ch
was the issue being addressed by my change. It would be helpful to get
the output of "ip -s macsec show" and specifically the InPktsDelayed
counter. Did iperf3 report out-of-order packets with the patch reverted?
Otherwise, if this is the only process running on your test servers,
then you may not be generating any contention for the FPU, which is the
source of the out-of-order issue. Maybe you could run prime95 to busy
the FPU to see the issue that I was seeing.

I have a product that is a secure router with a half-dozen MACsec
interfaces, boots from a LUKS-encrypted disk, and has a number of TLS
control and status interfaces for local devices attached to product.
Without this patch, the system was completely unusable due to the
out-of-order issue causing TCP retries and UDP out-of-order issues. I
have not seen any examples of this MACsec driver in the wild, so I
assumed nobody had noticed the out-of-order issue because of synthetic
testing.
--=20
Scott Dial
scott@scottdial.com
