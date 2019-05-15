Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B78E81EB65
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 11:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbfEOJrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 05:47:09 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:39616 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725954AbfEOJrI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 May 2019 05:47:08 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3839380D;
        Wed, 15 May 2019 02:47:08 -0700 (PDT)
Received: from fuggles.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B1F153F703;
        Wed, 15 May 2019 02:47:06 -0700 (PDT)
Date:   Wed, 15 May 2019 10:47:04 +0100
From:   Will Deacon <will.deacon@arm.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Zhangshaokun <zhangshaokun@hisilicon.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        ilias.apalodimas@linaro.org,
        "huanglingyan (A)" <huanglingyan2@huawei.com>, steve.capper@arm.com
Subject: Re: [PATCH] arm64: do_csum: implement accelerated scalar version
Message-ID: <20190515094704.GC24357@fuggles.cambridge.arm.com>
References: <20190218230842.11448-1-ard.biesheuvel@linaro.org>
 <d7a16ebd-073f-f50e-9651-68606d10b01c@hisilicon.com>
 <20190412095243.GA27193@fuggles.cambridge.arm.com>
 <41b30c72-c1c5-14b2-b2e1-3507d552830d@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41b30c72-c1c5-14b2-b2e1-3507d552830d@arm.com>
User-Agent: Mutt/1.11.1+86 (6f28e57d73f2) ()
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 15, 2019 at 07:18:22PM +0100, Robin Murphy wrote:
> On 12/04/2019 10:52, Will Deacon wrote:
> > I'm waiting for Robin to come back with numbers for a C implementation.
> > 
> > Robin -- did you get anywhere with that?
> 
> Still not what I would call finished, but where I've got so far (besides an
> increasingly elaborate test rig) is as below - it still wants some unrolling
> in the middle to really fly (and actual testing on BE), but the worst-case
> performance already equals or just beats this asm version on Cortex-A53 with
> GCC 7 (by virtue of being alignment-insensitive and branchless except for
> the loop). Unfortunately, the advantage of C code being instrumentable does
> also come around to bite me...

Is there any interest from anybody in spinning a proper patch out of this?
Shaokun?

Will

> /* Looks dumb, but generates nice-ish code */
> static u64 accumulate(u64 sum, u64 data)
> {
> 	__uint128_t tmp = (__uint128_t)sum + data;
> 	return tmp + (tmp >> 64);
> }
> 
> unsigned int do_csum_c(const unsigned char *buff, int len)
> {
> 	unsigned int offset, shift, sum, count;
> 	u64 data, *ptr;
> 	u64 sum64 = 0;
> 
> 	offset = (unsigned long)buff & 0x7;
> 	/*
> 	 * This is to all intents and purposes safe, since rounding down cannot
> 	 * result in a different page or cache line being accessed, and @buff
> 	 * should absolutely not be pointing to anything read-sensitive.
> 	 * It does, however, piss off KASAN...
> 	 */
> 	ptr = (u64 *)(buff - offset);
> 	shift = offset * 8;
> 
> 	/*
> 	 * Head: zero out any excess leading bytes. Shifting back by the same
> 	 * amount should be at least as fast as any other way of handling the
> 	 * odd/even alignment, and means we can ignore it until the very end.
> 	 */
> 	data = *ptr++;
> #ifdef __LITTLE_ENDIAN
> 	data = (data >> shift) << shift;
> #else
> 	data = (data << shift) >> shift;
> #endif
> 	count = 8 - offset;
> 
> 	/* Body: straightforward aligned loads from here on... */
> 	//TODO: fancy stuff with larger strides and uint128s?
> 	while(len > count) {
> 		sum64 = accumulate(sum64, data);
> 		data = *ptr++;
> 		count += 8;
> 	}
> 	/*
> 	 * Tail: zero any over-read bytes similarly to the head, again
> 	 * preserving odd/even alignment.
> 	 */
> 	shift = (count - len) * 8;
> #ifdef __LITTLE_ENDIAN
> 	data = (data << shift) >> shift;
> #else
> 	data = (data >> shift) << shift;
> #endif
> 	sum64 = accumulate(sum64, data);
> 
> 	/* Finally, folding */
> 	sum64 += (sum64 >> 32) | (sum64 << 32);
> 	sum = sum64 >> 32;
> 	sum += (sum >> 16) | (sum << 16);
> 	if (offset & 1)
> 		return (u16)swab32(sum);
> 
> 	return sum >> 16;
> }
