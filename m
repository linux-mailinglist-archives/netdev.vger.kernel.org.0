Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F26DD2D8DAD
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 15:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394947AbgLMOAo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 13 Dec 2020 09:00:44 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:55123 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389612AbgLMOAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 09:00:44 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=cambda@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UIR7Bsx_1607867988;
Received: from 192.168.1.7(mailfrom:cambda@linux.alibaba.com fp:SMTPD_---0UIR7Bsx_1607867988)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 13 Dec 2020 21:59:48 +0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.20.0.2.21\))
Subject: Re: [PATCH net-next] net: Limit logical shift left of TCP probe0
 timeout
From:   Cambda Zhu <cambda@linux.alibaba.com>
In-Reply-To: <20201212143259.581aadae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Sun, 13 Dec 2020 21:59:45 +0800
Cc:     Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>,
        Dust Li <dust.li@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <25F89086-3260-48BD-BD69-CCE04821CAE4@linux.alibaba.com>
References: <20201208091910.37618-1-cambda@linux.alibaba.com>
 <20201212143259.581aadae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
To:     Jakub Kicinski <kuba@kernel.org>
X-Mailer: Apple Mail (2.3654.20.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Dec 13, 2020, at 06:32, Jakub Kicinski <kuba@kernel.org> wrote:
> 
> On Tue,  8 Dec 2020 17:19:10 +0800 Cambda Zhu wrote:
>> For each TCP zero window probe, the icsk_backoff is increased by one and
>> its max value is tcp_retries2. If tcp_retries2 is greater than 63, the
>> probe0 timeout shift may exceed its max bits. On x86_64/ARMv8/MIPS, the
>> shift count would be masked to range 0 to 63. And on ARMv7 the result is
>> zero. If the shift count is masked, only several probes will be sent
>> with timeout shorter than TCP_RTO_MAX. But if the timeout is zero, it
>> needs tcp_retries2 times probes to end this false timeout. Besides,
>> bitwise shift greater than or equal to the width is an undefined
>> behavior.
> 
> If icsk_backoff can reach 64, can it not also reach 256 and wrap?

If tcp_retries2 is set greater than 255, it can be wrapped. But for TCP probe0,
it seems to be not a serious problem. The timeout will be icsk_rto and backoff
again. And considering icsk_backoff is 8 bits, not only it may always be lesser
than tcp_retries2, but also may always be lesser than tcp_orphan_retries. And
the icsk_probes_out is 8 bits too. So if the max_probes is greater than 255,
the connection won’t abort even if it’s an orphan sock in some cases.

We can change the type of icsk_backoff/icsk_probes_out to fix these problems.
But I think maybe the retries greater than 255 have no sense indeed and the RFC
only requires the timeout(R2) greater than 100s at least. Could it be better to
limit the min/max ranges of their sysctls?

Regards,
Cambda

> 
> Adding Eric's address from MAINTAINERS to CC.
> 
>> This patch adds a limit to the backoff. The max value of max_when is
>> TCP_RTO_MAX and the min value of timeout base is TCP_RTO_MIN. The limit
>> is the backoff from TCP_RTO_MIN to TCP_RTO_MAX.
> 
>> diff --git a/include/net/tcp.h b/include/net/tcp.h
>> index d4ef5bf94168..82044179c345 100644
>> --- a/include/net/tcp.h
>> +++ b/include/net/tcp.h
>> @@ -1321,7 +1321,9 @@ static inline unsigned long tcp_probe0_base(const struct sock *sk)
>> static inline unsigned long tcp_probe0_when(const struct sock *sk,
>> 					    unsigned long max_when)
>> {
>> -	u64 when = (u64)tcp_probe0_base(sk) << inet_csk(sk)->icsk_backoff;
>> +	u8 backoff = min_t(u8, ilog2(TCP_RTO_MAX / TCP_RTO_MIN) + 1,
>> +			   inet_csk(sk)->icsk_backoff);
>> +	u64 when = (u64)tcp_probe0_base(sk) << backoff;
>> 
>> 	return (unsigned long)min_t(u64, when, max_when);
>> }

