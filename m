Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 527D42EBDDF
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 13:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbhAFMv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 07:51:58 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:17626 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbhAFMv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 07:51:58 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff5b2450000>; Wed, 06 Jan 2021 04:51:17 -0800
Received: from [172.27.0.41] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 6 Jan
 2021 12:51:15 +0000
Subject: Re: [PATCH iproute2] build: Fix link errors on some systems
From:   Roi Dayan <roid@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
CC:     <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Petr Machata <me@pmachata.org>
References: <1609355503-7981-1-git-send-email-roid@nvidia.com>
 <875z4cwus8.fsf@nvidia.com> <405e8cce-e2dd-891a-dc8a-7c8b0c77f4c6@nvidia.com>
Message-ID: <4a07fbc9-8e1c-ecd6-ee9e-31d1a952ba42@nvidia.com>
Date:   Wed, 6 Jan 2021 14:51:12 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <405e8cce-e2dd-891a-dc8a-7c8b0c77f4c6@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609937477; bh=7H98C4AZd+1bajsjHvQiIazI8uzfYagm8xbWH+7/61w=;
        h=Subject:From:To:CC:References:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=P8tqyi+j/LjUcTWGikptTTeJkl+HpmvPu8JqKrTr8guBAGWz15yGyKMDWUYMjJyts
         eENQZoHyXuirWEsFunMxqDxb5zb3KK9U9e01PMxk0iQ4IDGAUaFHnkM58q6hW+NzYz
         8UCmazlEw5/IquLDCtJpEJ8op4DhC7xxOZOwbUIV/eamMdVxIYwPTpcZiltln+VklW
         5tWpyAB/2lziK3Obkm0JNBzLBzhC57+9hAegWL3jwWanCJNJapmwcfkG6/5ne8Sikj
         OWmNwMPYiizKAKx5p9hVtzLzcZPm3qz/A7KmKnhRt/QE5RpakYV1wgZ7l4GgEFE7LT
         Pew+xCOnrsjUg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-01-06 10:42 AM, Roi Dayan wrote:
>=20
>=20
> On 2021-01-04 6:07 PM, Petr Machata wrote:
>>
>> Roi Dayan <roid@nvidia.com> writes:
>>
>>> Since moving get_rate() and get_size() from tc to lib, on some
>>> systems we fail to link because of missing the math lib.
>>> Move the link flag from tc makefile to the main makefile.
>>
>> Hmm, yeah, it gets optimized out on x86-64. The issue is reproducible
>> on any platform with -O0.
>>
>>> ../lib/libutil.a(utils.o): In function `get_rate':
>>> utils.c:(.text+0x10dc): undefined reference to `floor'
>>> ../lib/libutil.a(utils.o): In function `get_size':
>>> utils.c:(.text+0x1394): undefined reference to `floor'
>>> ../lib/libutil.a(json_print.o): In function `sprint_size':
>>> json_print.c:(.text+0x14c0): undefined reference to `rint'
>>> json_print.c:(.text+0x14f4): undefined reference to `rint'
>>> json_print.c:(.text+0x157c): undefined reference to `rint'
>>>
>>> Fixes: f3be0e6366ac ("lib: Move get_rate(), get_rate64() from tc here")
>>> Fixes: 44396bdfcc0a ("lib: Move get_size() from tc here")
>>> Fixes: adbe5de96662 ("lib: Move sprint_size() from tc here, add=20
>>> print_size()")
>>> Signed-off-by: Roi Dayan <roid@nvidia.com>
>>> ---
>>> =C2=A0 Makefile=C2=A0=C2=A0=C2=A0 | 1 +
>>> =C2=A0 tc/Makefile | 2 +-
>>> =C2=A0 2 files changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/Makefile b/Makefile
>>> index e64c65992585..2a604ec58905 100644
>>> --- a/Makefile
>>> +++ b/Makefile
>>> @@ -59,6 +59,7 @@ SUBDIRS=3Dlib ip tc bridge misc netem genl tipc=20
>>> devlink rdma dcb man
>>> =C2=A0 LIBNETLINK=3D../lib/libutil.a ../lib/libnetlink.a
>>> =C2=A0 LDLIBS +=3D $(LIBNETLINK)
>>> +LDFLAGS +=3D -lm
>>> =C2=A0 all: config.mk
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 @set -e; \
>>> diff --git a/tc/Makefile b/tc/Makefile
>>> index 5a517af20b7c..8d91900716c1 100644
>>> --- a/tc/Makefile
>>> +++ b/tc/Makefile
>>> @@ -110,7 +110,7 @@ ifneq ($(TC_CONFIG_NO_XT),y)
>>> =C2=A0 endif
>>> =C2=A0 TCOBJ +=3D $(TCMODULES)
>>> -LDLIBS +=3D -L. -lm
>>> +LDLIBS +=3D -L.
>>> =C2=A0 ifeq ($(SHARED_LIBS),y)
>>> =C2=A0 LDLIBS +=3D -ldl
>>
>> This will work, but it will give a libm dependency to all the tools.
>> util.c currently tries not to do that:
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0/* emulate ceil() without having to bring-in -lm=
 and always be >=3D=20
>> 1 */
>> =C2=A0=C2=A0=C2=A0=C2=A0*val =3D t;
>> =C2=A0=C2=A0=C2=A0=C2=A0if (*val < t)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *val +=3D 1;
>>
>> I think that just adding an unnecessary -lm is more of a tidiness issue
>> than anything else. One way to avoid it is to split the -lm deps out
>> from util.c / json_print.c to like util_math.c / json_print_math.c. That
>> way they will be in an .o of their own, and won't be linked in unless
>> the binary in question needs the code. Then the binaries that do call it
>> can keep on linking in -lm like they did so far.
>>
>> Thoughts?
>>
>=20
> ok fine by me.

I looked at this and for get_size()/rate/.. it went smooth.
but for print_color_size() there is an issue that it uses
_IS_JSON_CONTEXT and statuic *_jw which are defined in json_print.c
Is it ok to expose those in json_print.h now so json_print_math.c
could use?
