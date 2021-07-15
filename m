Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4C33C9ED1
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 14:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237359AbhGOMnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 08:43:16 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:59086
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229946AbhGOMnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 08:43:15 -0400
Received: from [10.172.193.212] (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id BBB854057E;
        Thu, 15 Jul 2021 12:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1626352821;
        bh=AmOVYckpwNAaXTV3DzCNna6wdwLn6NLZ6K6/8u4iK8w=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=WiC1/QqjZB3fmo4rjb9Pq0sxQyEydMClS3x8p1GFnd22mZswav06O+Wt9S0RZH3CG
         +qgkm6TOibZc+2TKs5P52KDj1qtLeQW09skug3Z0vkcxsXUm7/Lt5eCz69MX8OVJ/1
         LKmkMvUKqQmn63fBR9/ymj0m2f041x4ogXzLJqpWEP6QsIjcyri5UO9DyEZ8/hfM0n
         mZN8M615+d3TUEeXMO0FVp3CHNe/mYotHK0YTpuvZHji+ZEllJLI4qpYZvsMTX0XOe
         2dBoCmFgEV/9xW0HxBRK4WrqU761i4n9Lpz3W3236RT1lvkLs/kenyB31WXTI9eNE+
         BJNuTM6RL3hYg==
Subject: Re: Range checking on r1 in function reg_set_seen in
 arch/s390/net/bpf_jit_comp.c
To:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        linux-s390@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        bpf@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <845025d4-11b9-b16d-1dd6-1e0bd66b0e20@canonical.com>
 <8b280523cf98294bee897615de84546e241b4e11.camel@linux.ibm.com>
From:   Colin Ian King <colin.king@canonical.com>
Message-ID: <96c114c8-1369-05d3-6b44-78ac4e5e73fb@canonical.com>
Date:   Thu, 15 Jul 2021 13:40:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <8b280523cf98294bee897615de84546e241b4e11.camel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/07/2021 13:09, Ilya Leoshkevich wrote:
> On Thu, 2021-07-15 at 13:02 +0100, Colin Ian King wrote:
>> Hi
>>
>> Static analysis with cppcheck picked up an interesting issue with the
>> following inline helper function in arch/s390/net/bpf_jit_comp.c :
>>
>> static inline void reg_set_seen(struct bpf_jit *jit, u32 b1)
>> {
>>         u32 r1 = reg2hex[b1];
>>
>>         if (!jit->seen_reg[r1] && r1 >= 6 && r1 <= 15)
>>                 jit->seen_reg[r1] = 1;
>> }
>>
>> Although I believe r1 is always within range, the range check on r1
>> is
>> being performed before the more cache/memory expensive lookup on
>> jit->seen_reg[r1].  I can't see why the range change is being
>> performed
>> after the access of jit->seen_reg[r1]. The following seems more
>> correct:
>>
>>         if (r1 >= 6 && r1 <= 15 && !jit->seen_reg[r1])
>>                 jit->seen_reg[r1] = 1;
>>
>> ..since the check on r1 are less expensive than !jit->seen_reg[r1]
>> and
>> also the range check ensures the array access is not out of bounds. I
>> was just wondering if I'm missing something deeper to why the order
>> is
>> the way it is.
>>
>> Colin
> 
> Hi,
> 
> I think your analysis is correct, thanks for spotting this!
> Even though I don't think the performance difference would be 
> measurable here, not confusing future readers is a good reason
> to make a change that you suggest.
> Do you plan to send a patch?

I'll send a patch later today.  Colin
> 
> Best regards,
> Ilya
> 

