Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E67221EC7B
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 12:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbfEOK6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 06:58:01 -0400
Received: from foss.arm.com ([217.140.101.70]:40700 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725953AbfEOK6A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 May 2019 06:58:00 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CB36880D;
        Wed, 15 May 2019 03:57:59 -0700 (PDT)
Received: from [10.1.196.75] (e110467-lin.cambridge.arm.com [10.1.196.75])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4E1CF3F703;
        Wed, 15 May 2019 03:57:58 -0700 (PDT)
Subject: Re: [PATCH] arm64: do_csum: implement accelerated scalar version
To:     David Laight <David.Laight@ACULAB.COM>,
        'Will Deacon' <will.deacon@arm.com>
Cc:     Zhangshaokun <zhangshaokun@hisilicon.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "huanglingyan (A)" <huanglingyan2@huawei.com>,
        "steve.capper@arm.com" <steve.capper@arm.com>
References: <20190218230842.11448-1-ard.biesheuvel@linaro.org>
 <d7a16ebd-073f-f50e-9651-68606d10b01c@hisilicon.com>
 <20190412095243.GA27193@fuggles.cambridge.arm.com>
 <41b30c72-c1c5-14b2-b2e1-3507d552830d@arm.com>
 <20190515094704.GC24357@fuggles.cambridge.arm.com>
 <6e755b2daaf341128cb3b54f36172442@AcuMS.aculab.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <3d4fdbb5-7c7f-9331-187e-14c09dd1c18d@arm.com>
Date:   Wed, 15 May 2019 11:57:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <6e755b2daaf341128cb3b54f36172442@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/05/2019 11:15, David Laight wrote:
> ...
>>> 	ptr = (u64 *)(buff - offset);
>>> 	shift = offset * 8;
>>>
>>> 	/*
>>> 	 * Head: zero out any excess leading bytes. Shifting back by the same
>>> 	 * amount should be at least as fast as any other way of handling the
>>> 	 * odd/even alignment, and means we can ignore it until the very end.
>>> 	 */
>>> 	data = *ptr++;
>>> #ifdef __LITTLE_ENDIAN
>>> 	data = (data >> shift) << shift;
>>> #else
>>> 	data = (data << shift) >> shift;
>>> #endif
> 
> I suspect that
> #ifdef __LITTLE_ENDIAN
> 	data &= ~0ull << shift;
> #else
> 	data &= ~0ull >> shift;
> #endif
> is likely to be better.

Out of interest, better in which respects? For the A64 ISA at least, 
that would take 3 instructions plus an additional scratch register, e.g.:

	MOV	x2, #~0
	LSL	x2, x2, x1
	AND	x0, x0, x1

(alternatively "AND x0, x0, x1 LSL x2" to save 4 bytes of code, but that 
will typically take as many cycles if not more than just pipelining the 
two 'simple' ALU instructions)

Whereas the original is just two shift instruction in-place.

	LSR	x0, x0, x1
	LSL	x0, x0, x1

If the operation were repeated, the constant generation could certainly 
be amortised over multiple subsequent ANDs for a net win, but that isn't 
the case here.

Robin.
