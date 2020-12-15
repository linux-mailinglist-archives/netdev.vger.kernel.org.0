Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90DC62DADFC
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 14:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgLON37 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 15 Dec 2020 08:29:59 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:32996 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726580AbgLON37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 08:29:59 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=cambda@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UIjac2I_1608038951;
Received: from 30.225.132.127(mailfrom:cambda@linux.alibaba.com fp:SMTPD_---0UIjac2I_1608038951)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 15 Dec 2020 21:29:12 +0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.40.0.2.32\))
Subject: Re: [PATCH net-next] net: Limit logical shift left of TCP probe0
 timeout
From:   Cambda Zhu <cambda@linux.alibaba.com>
In-Reply-To: <CANn89i+=QRibXsm6tw-eVwhB3wjOtgF-MtVu0G--K5=oWP97+A@mail.gmail.com>
Date:   Tue, 15 Dec 2020 21:29:10 +0800
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Dust Li <dust.li@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <43C8F4BF-CF95-4F21-B9C7-E344D2666C70@linux.alibaba.com>
References: <20201208091910.37618-1-cambda@linux.alibaba.com>
 <20201212143259.581aadae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <25F89086-3260-48BD-BD69-CCE04821CAE4@linux.alibaba.com>
 <20201214180840.601055a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89i+=QRibXsm6tw-eVwhB3wjOtgF-MtVu0G--K5=oWP97+A@mail.gmail.com>
To:     Eric Dumazet <edumazet@google.com>
X-Mailer: Apple Mail (2.3654.40.0.2.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Dec 15, 2020, at 19:06, Eric Dumazet <edumazet@google.com> wrote:
> 
> On Tue, Dec 15, 2020 at 3:08 AM Jakub Kicinski <kuba@kernel.org> wrote:
>> 
>> On Sun, 13 Dec 2020 21:59:45 +0800 Cambda Zhu wrote:
>>>> On Dec 13, 2020, at 06:32, Jakub Kicinski <kuba@kernel.org> wrote:
>>>> On Tue,  8 Dec 2020 17:19:10 +0800 Cambda Zhu wrote:
>>>>> For each TCP zero window probe, the icsk_backoff is increased by one and
>>>>> its max value is tcp_retries2. If tcp_retries2 is greater than 63, the
>>>>> probe0 timeout shift may exceed its max bits. On x86_64/ARMv8/MIPS, the
>>>>> shift count would be masked to range 0 to 63. And on ARMv7 the result is
>>>>> zero. If the shift count is masked, only several probes will be sent
>>>>> with timeout shorter than TCP_RTO_MAX. But if the timeout is zero, it
>>>>> needs tcp_retries2 times probes to end this false timeout. Besides,
>>>>> bitwise shift greater than or equal to the width is an undefined
>>>>> behavior.
>>>> 
>>>> If icsk_backoff can reach 64, can it not also reach 256 and wrap?
>>> 
>>> If tcp_retries2 is set greater than 255, it can be wrapped. But for TCP probe0,
>>> it seems to be not a serious problem. The timeout will be icsk_rto and backoff
>>> again. And considering icsk_backoff is 8 bits, not only it may always be lesser
>>> than tcp_retries2, but also may always be lesser than tcp_orphan_retries. And
>>> the icsk_probes_out is 8 bits too. So if the max_probes is greater than 255,
>>> the connection won’t abort even if it’s an orphan sock in some cases.
>>> 
>>> We can change the type of icsk_backoff/icsk_probes_out to fix these problems.
>>> But I think maybe the retries greater than 255 have no sense indeed and the RFC
>>> only requires the timeout(R2) greater than 100s at least. Could it be better to
>>> limit the min/max ranges of their sysctls?
>> 
>> All right, I think the patch is good as is, applied for 5.11, thank you!
> 
> It looks like we can remove the (u64) casts then.
> 
> Also if we _really_ care about icsk_backoff approaching 63, we also
> need to change inet_csk_rto_backoff() ?

Yes, we need. But the socket can close after tcp_orphan_retries times probes even if alive is
always true. And there’re something I’m not very clear yet:
1) inet_csk_rto_backoff() may be not only for TCP, and the RFC 6298 requires the max value
   of RTO is 60 seconds at least. So what’s the proper shift limit?
2) If max_probes is greater than 255, the icsk_probes_out cannot be greater than max_probes
   and the connection may not close forever. This looks more serious.

> 
> Was your patch based on a real world use, or some fuzzer UBSAN report ?
> 

I found this issue not on TCP. I’m developing a private protocol, and in this protocol I made
something like probe0 with max RTO lesser than 120 seconds. I found similar issues on testing
and found Linux TCP have same issues. So it’s not a real world use for TCP and it may be ok to
ignore the issues.

> diff --git a/include/net/inet_connection_sock.h
> b/include/net/inet_connection_sock.h
> index 7338b3865a2a3d278dc27c0167bba1b966bbda9f..a2a145e3b062c0230935c293fc1900df095937d4
> 100644
> --- a/include/net/inet_connection_sock.h
> +++ b/include/net/inet_connection_sock.h
> @@ -242,9 +242,10 @@ static inline unsigned long
> inet_csk_rto_backoff(const struct inet_connection_sock *icsk,
>                     unsigned long max_when)
> {
> -        u64 when = (u64)icsk->icsk_rto << icsk->icsk_backoff;
> +       u8 backoff = min_t(u8, 32U, icsk->icsk_backoff);
> +       u64 when = (u64)icsk->icsk_rto << backoff;
> 
> -        return (unsigned long)min_t(u64, when, max_when);
> +       return (unsigned long)min_t(u64, when, max_when);
> }
> 
> struct sock *inet_csk_accept(struct sock *sk, int flags, int *err, bool kern);
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 78d13c88720fda50e3f1880ac741cea1985ef3e9..fc6e4d40fd94a717d24ebd8aef7f7930a4551fe9
> 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -1328,9 +1328,8 @@ static inline unsigned long
> tcp_probe0_when(const struct sock *sk,
> {
>        u8 backoff = min_t(u8, ilog2(TCP_RTO_MAX / TCP_RTO_MIN) + 1,
>                           inet_csk(sk)->icsk_backoff);
> -       u64 when = (u64)tcp_probe0_base(sk) << backoff;
> 
> -       return (unsigned long)min_t(u64, when, max_when);
> +       return min(tcp_probe0_base(sk) << backoff, max_when);
> }
> 
> static inline void tcp_check_probe_timer(struct sock *sk)

