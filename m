Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C69372DF95C
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 07:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbgLUGsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 01:48:35 -0500
Received: from mout01.posteo.de ([185.67.36.65]:36921 "EHLO mout01.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725937AbgLUGse (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 01:48:34 -0500
Received: from submission (posteo.de [89.146.220.130]) 
        by mout01.posteo.de (Postfix) with ESMTPS id 8D8DC16005F
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 07:47:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1608533256; bh=d+eWlpd66fQCAbRyHjgHWikxw1sXpu3YtkJCMQr5H0Y=;
        h=Subject:From:Cc:Date:From;
        b=de65CfyPKKIE4C9NPd6sKvSzlZf5APOVdUPUgXBV3cXgqjK6lue91YN8O60fR5c9s
         HKRxOj/JQfRmpWeVDRopBQvOw2LCIjh4cnlgdstsGOEOWn5rOgBXEBhCQsaxEVnr8W
         mWq0C17lAwcy9qTLzcJo0BBCB6TBbrNFcmRN5td2SPrwqbRij+YNjTnKBhx9JNI7rA
         jwYeN+91bKZ7mimIpnN71Xxn7g1HnQIKfzJF2Wyc9+2CKqfPEEHRtTiF4fBBC2tSqe
         vot3xWHV8GjHvyXhpgguL1QCXy1YKkoP3NXUCy+aHqcF1MnhqORHoEDjJ8+ZYU17t4
         NigizY7iSxYHg==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4Czqlr15z6z9rxK
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 07:47:36 +0100 (CET)
Subject: Re: PROBLEM: Poor wlan performance with lots of retries since kernel
 5.9
From:   Rainer Suhm <automat@posteo.de>
Cc:     netdev@vger.kernel.org
References: <c885eca1-1563-f0a6-bf21-a8fc8762a68e@posteo.de>
Reply-To: "David S. Miller" <davem@davemloft.net>,
          Eric Dumazet <edumazet@google.com>
Message-ID: <366d211d-dea0-bf07-0970-10ee0038a5f5@posteo.de>
Date:   Mon, 21 Dec 2020 07:47:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <c885eca1-1563-f0a6-bf21-a8fc8762a68e@posteo.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 21.12.20 um 00:19 schrieb Rainer Suhm:
> Since kernel 5.9 I do have very poor wlan performance with one of my machines.
> The transmission rate is only about a tenth of normal speed (~60MB/s -> 6 MB/s).
> iperf3 -c <server> shows hundreds of retries per second
> --- snip ---
> [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> [  5]   0.00-1.00   sec  8.55 MBytes  71.7 Mbits/sec  649   1.41 KBytes
> [  5]   1.00-2.00   sec  5.78 MBytes  48.5 Mbits/sec  366   17.0 KBytes
> [  5]   2.00-3.00   sec  5.97 MBytes  50.0 Mbits/sec  371   19.8 KBytes
> [  5]   3.00-4.00   sec  5.84 MBytes  49.0 Mbits/sec  390   17.0 KBytes
> [  5]   4.00-5.00   sec  6.21 MBytes  52.1 Mbits/sec  380   19.8 KBytes
> [  5]   5.00-6.00   sec  4.54 MBytes  38.1 Mbits/sec  299   1.41 KBytes
> [  5]   6.00-7.00   sec  6.34 MBytes  53.2 Mbits/sec  367   26.9 KBytes
> [  5]   7.00-8.00   sec  6.15 MBytes  51.6 Mbits/sec  390   19.8 KBytes
> [  5]   8.00-9.00   sec  5.65 MBytes  47.4 Mbits/sec  370   2.83 KBytes
> [  5]   9.00-10.00  sec  5.78 MBytes  48.5 Mbits/sec  377   21.2 KBytes
> - - - - - - - - - - - - - - - - - - - - - - - - -
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.00  sec  60.8 MBytes  51.0 Mbits/sec  3959             sender
> [  5]   0.00-10.00  sec  60.1 MBytes  50.4 Mbits/sec                  receiver
> --- snap ---
> (this measurement was taken after booting from the current official arch iso)
> 
> The problem is only when transmitting data. Receiving (iperf3 -c <server> -R) works ok.
> No related errors/warnings in dmesg.
> The problem exists since kernel v5.9 up to 10.0.2-rc1
> Using other (older) WiFi firmware doesn't help.
> Hardware: TUXEDO InfinityBook S 14 v5/L140CU,
> with Intel(R) Wi-Fi 6 AX200 160MHz, REV=0x340
> The machine runs Arch Linux, all updates installed.
> On all my other laptops this problem doesn't show up.
> 
> 
> Bisecting leads to:
> --- snip ---
> 3d5b459ba0e3788ab471e8cb98eee89964a9c5e8 is the first bad commit
> commit 3d5b459ba0e3788ab471e8cb98eee89964a9c5e8
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Wed Jun 17 20:53:26 2020 -0700
> 
>       net: tso: add UDP segmentation support
>       Note that like TCP, we do not support additional encapsulations,
>       and that checksums must be offloaded to the NIC.
>       Signed-off-by: Eric Dumazet <edumazet@google.com>
>       Signed-off-by: David S. Miller <davem@davemloft.net>
> 
>    net/core/tso.c | 29 ++++++++++++++++++-----------
>    1 file changed, 18 insertions(+), 11 deletions(-)
> --- snap ---
> 
> After reverting e89964a9c5e8, everything seems ok. WLan works with expected speed, and iperf3 doesn't show retries any more.
> I confirm this for kernels 5.10.1 and 5.10.2-rc1 (00017-gc96cfd687a3f).
> 
> If I should provide more information, let me know.
> Please note: I'm not on any list. So please make sure to address me explicitly if replying to this mail.
> 
> 
> Thx
> Rainer
> 

Sorry,
I have to resend this message, as it could not be delivered to the netdev list because of missing TLS.

--- snip ---
Final-Recipient: rfc822; netdev@vger.kernel.org
Original-Recipient: rfc822;netdev@vger.kernel.org
Action: failed
Status: 5.7.4
Diagnostic-Code: X-Postfix; TLS is required, but was not offered by host
     vger.kernel.org[23.128.96.18]
--- snap ---

For now I switched the need for TLS off.
Hope that helps.


Thx
Rainer
