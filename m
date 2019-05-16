Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB33F1FDF5
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 05:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbfEPDOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 23:14:44 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7652 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726157AbfEPDOn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 May 2019 23:14:43 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D8D70AD0CB65ACE202E0;
        Thu, 16 May 2019 11:14:41 +0800 (CST)
Received: from [127.0.0.1] (10.74.221.148) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 16 May 2019
 11:14:35 +0800
Subject: Re: [PATCH] arm64: do_csum: implement accelerated scalar version
To:     Will Deacon <will.deacon@arm.com>,
        Robin Murphy <robin.murphy@arm.com>
References: <20190218230842.11448-1-ard.biesheuvel@linaro.org>
 <d7a16ebd-073f-f50e-9651-68606d10b01c@hisilicon.com>
 <20190412095243.GA27193@fuggles.cambridge.arm.com>
 <41b30c72-c1c5-14b2-b2e1-3507d552830d@arm.com>
 <20190515094704.GC24357@fuggles.cambridge.arm.com>
CC:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <ilias.apalodimas@linaro.org>,
        "huanglingyan (A)" <huanglingyan2@huawei.com>,
        <steve.capper@arm.com>
From:   Zhangshaokun <zhangshaokun@hisilicon.com>
Message-ID: <440eb674-0e59-a97e-4a90-0026e2327069@hisilicon.com>
Date:   Thu, 16 May 2019 11:14:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.1.1
MIME-Version: 1.0
In-Reply-To: <20190515094704.GC24357@fuggles.cambridge.arm.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.221.148]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Will,

On 2019/5/15 17:47, Will Deacon wrote:
> On Mon, Apr 15, 2019 at 07:18:22PM +0100, Robin Murphy wrote:
>> On 12/04/2019 10:52, Will Deacon wrote:
>>> I'm waiting for Robin to come back with numbers for a C implementation.
>>>
>>> Robin -- did you get anywhere with that?
>>
>> Still not what I would call finished, but where I've got so far (besides an
>> increasingly elaborate test rig) is as below - it still wants some unrolling
>> in the middle to really fly (and actual testing on BE), but the worst-case
>> performance already equals or just beats this asm version on Cortex-A53 with
>> GCC 7 (by virtue of being alignment-insensitive and branchless except for
>> the loop). Unfortunately, the advantage of C code being instrumentable does
>> also come around to bite me...
> 
> Is there any interest from anybody in spinning a proper patch out of this?
> Shaokun?

HiSilicon's Kunpeng920(Hi1620) benefits from do_csum optimization, if Ard and
Robin are ok, Lingyan or I can try to do it.
Of course, if any guy posts the patch, we are happy to test it.
Any will be ok.

Thanks,
Shaokun

> 
> Will
> 
>> /* Looks dumb, but generates nice-ish code */
>> static u64 accumulate(u64 sum, u64 data)
>> {
>> 	__uint128_t tmp = (__uint128_t)sum + data;
>> 	return tmp + (tmp >> 64);
>> }
>>
>> unsigned int do_csum_c(const unsigned char *buff, int len)
>> {
>> 	unsigned int offset, shift, sum, count;
>> 	u64 data, *ptr;
>> 	u64 sum64 = 0;
>>
>> 	offset = (unsigned long)buff & 0x7;
>> 	/*
>> 	 * This is to all intents and purposes safe, since rounding down cannot
>> 	 * result in a different page or cache line being accessed, and @buff
>> 	 * should absolutely not be pointing to anything read-sensitive.
>> 	 * It does, however, piss off KASAN...
>> 	 */
>> 	ptr = (u64 *)(buff - offset);
>> 	shift = offset * 8;
>>
>> 	/*
>> 	 * Head: zero out any excess leading bytes. Shifting back by the same
>> 	 * amount should be at least as fast as any other way of handling the
>> 	 * odd/even alignment, and means we can ignore it until the very end.
>> 	 */
>> 	data = *ptr++;
>> #ifdef __LITTLE_ENDIAN
>> 	data = (data >> shift) << shift;
>> #else
>> 	data = (data << shift) >> shift;
>> #endif
>> 	count = 8 - offset;
>>
>> 	/* Body: straightforward aligned loads from here on... */
>> 	//TODO: fancy stuff with larger strides and uint128s?
>> 	while(len > count) {
>> 		sum64 = accumulate(sum64, data);
>> 		data = *ptr++;
>> 		count += 8;
>> 	}
>> 	/*
>> 	 * Tail: zero any over-read bytes similarly to the head, again
>> 	 * preserving odd/even alignment.
>> 	 */
>> 	shift = (count - len) * 8;
>> #ifdef __LITTLE_ENDIAN
>> 	data = (data << shift) >> shift;
>> #else
>> 	data = (data >> shift) << shift;
>> #endif
>> 	sum64 = accumulate(sum64, data);
>>
>> 	/* Finally, folding */
>> 	sum64 += (sum64 >> 32) | (sum64 << 32);
>> 	sum = sum64 >> 32;
>> 	sum += (sum >> 16) | (sum << 16);
>> 	if (offset & 1)
>> 		return (u16)swab32(sum);
>>
>> 	return sum >> 16;
>> }
> 
> .
> 

