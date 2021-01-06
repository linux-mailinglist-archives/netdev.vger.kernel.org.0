Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA5342EBB36
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 09:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbhAFIna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 03:43:30 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2625 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726433AbhAFIna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 03:43:30 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff5780a0000>; Wed, 06 Jan 2021 00:42:50 -0800
Received: from [172.27.0.41] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 6 Jan
 2021 08:42:48 +0000
Subject: Re: [PATCH iproute2] build: Fix link errors on some systems
To:     Petr Machata <petrm@nvidia.com>
CC:     <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Petr Machata <me@pmachata.org>
References: <1609355503-7981-1-git-send-email-roid@nvidia.com>
 <875z4cwus8.fsf@nvidia.com>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <405e8cce-e2dd-891a-dc8a-7c8b0c77f4c6@nvidia.com>
Date:   Wed, 6 Jan 2021 10:42:35 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <875z4cwus8.fsf@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609922570; bh=6w6+3cHIReLsc+Y6XCDVZp7JQtFRlFh85dC2ADvLWoc=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=D0jRAhH6DRWv/Ivx4nJ+E581vb6dQ9JOGWjNzx5U/5GO4CQLDLjaRPuGp4DC0awpk
         qfGAvZN9mokMspgBAPpsIurEDN3Lt63z80JVEP8fnprtRVPJc34/4cwauC7xYQl2Dl
         NHKGJCJtAgN/HG/U1LvRKHd47uLUDM3h5Vafra5sYA9CvXYKCpOuuAb7e5wzmAQi0O
         550op2TyzIp5q2kIjVjKYVFVVR+/XNiMMTi+0QSils+E/SO1CKEoVBzg0oQc7J5sky
         e5HV2HJtCBLoXEKJlPhs1/W3LrDwC+RPbTaX2FB9CusjRvkykLMh8QjKLbzQgM5PoU
         YMinIRraZ67hg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-01-04 6:07 PM, Petr Machata wrote:
> 
> Roi Dayan <roid@nvidia.com> writes:
> 
>> Since moving get_rate() and get_size() from tc to lib, on some
>> systems we fail to link because of missing the math lib.
>> Move the link flag from tc makefile to the main makefile.
> 
> Hmm, yeah, it gets optimized out on x86-64. The issue is reproducible
> on any platform with -O0.
> 
>> ../lib/libutil.a(utils.o): In function `get_rate':
>> utils.c:(.text+0x10dc): undefined reference to `floor'
>> ../lib/libutil.a(utils.o): In function `get_size':
>> utils.c:(.text+0x1394): undefined reference to `floor'
>> ../lib/libutil.a(json_print.o): In function `sprint_size':
>> json_print.c:(.text+0x14c0): undefined reference to `rint'
>> json_print.c:(.text+0x14f4): undefined reference to `rint'
>> json_print.c:(.text+0x157c): undefined reference to `rint'
>>
>> Fixes: f3be0e6366ac ("lib: Move get_rate(), get_rate64() from tc here")
>> Fixes: 44396bdfcc0a ("lib: Move get_size() from tc here")
>> Fixes: adbe5de96662 ("lib: Move sprint_size() from tc here, add print_size()")
>> Signed-off-by: Roi Dayan <roid@nvidia.com>
>> ---
>>   Makefile    | 1 +
>>   tc/Makefile | 2 +-
>>   2 files changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/Makefile b/Makefile
>> index e64c65992585..2a604ec58905 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -59,6 +59,7 @@ SUBDIRS=lib ip tc bridge misc netem genl tipc devlink rdma dcb man
>>   
>>   LIBNETLINK=../lib/libutil.a ../lib/libnetlink.a
>>   LDLIBS += $(LIBNETLINK)
>> +LDFLAGS += -lm
>>   
>>   all: config.mk
>>   	@set -e; \
>> diff --git a/tc/Makefile b/tc/Makefile
>> index 5a517af20b7c..8d91900716c1 100644
>> --- a/tc/Makefile
>> +++ b/tc/Makefile
>> @@ -110,7 +110,7 @@ ifneq ($(TC_CONFIG_NO_XT),y)
>>   endif
>>   
>>   TCOBJ += $(TCMODULES)
>> -LDLIBS += -L. -lm
>> +LDLIBS += -L.
>>   
>>   ifeq ($(SHARED_LIBS),y)
>>   LDLIBS += -ldl
> 
> This will work, but it will give a libm dependency to all the tools.
> util.c currently tries not to do that:
> 
> 	/* emulate ceil() without having to bring-in -lm and always be >= 1 */
> 	*val = t;
> 	if (*val < t)
> 		*val += 1;
> 
> I think that just adding an unnecessary -lm is more of a tidiness issue
> than anything else. One way to avoid it is to split the -lm deps out
> from util.c / json_print.c to like util_math.c / json_print_math.c. That
> way they will be in an .o of their own, and won't be linked in unless
> the binary in question needs the code. Then the binaries that do call it
> can keep on linking in -lm like they did so far.
> 
> Thoughts?
> 

ok fine by me.
