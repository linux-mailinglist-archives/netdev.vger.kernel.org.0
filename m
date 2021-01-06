Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14B622EBF5E
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 15:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbhAFOUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 09:20:50 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:8380 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbhAFOUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 09:20:50 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff5c7190002>; Wed, 06 Jan 2021 06:20:09 -0800
Received: from [172.27.0.41] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 6 Jan
 2021 14:20:08 +0000
Subject: Re: [PATCH iproute2] build: Fix link errors on some systems
To:     Petr Machata <petrm@nvidia.com>
CC:     <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Petr Machata <me@pmachata.org>
References: <1609355503-7981-1-git-send-email-roid@nvidia.com>
 <875z4cwus8.fsf@nvidia.com> <405e8cce-e2dd-891a-dc8a-7c8b0c77f4c6@nvidia.com>
 <4a07fbc9-8e1c-ecd6-ee9e-31d1a952ba42@nvidia.com> <87y2h6urwe.fsf@nvidia.com>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <5ed38f17-be13-0c5b-5b2f-1cb58ee77a8c@nvidia.com>
Date:   Wed, 6 Jan 2021 16:20:05 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <87y2h6urwe.fsf@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609942809; bh=Jrwi9fwwY5HCF12NGkSKJNdkJ05z+cfO5QgHA9Na5kE=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=qjUzEb6ds3kYYi1u1S1nl8QwT7yx5arHPkpzoLo3S1KN2bc2heiQp64bTMpRQI43A
         7iMO+/Ib/iQIwuRYIBCWp5L2PrLEcP6XUJO5gjd9jHP4+NJOtiL9G7h/CXmR/l6pz6
         FJrK66isrbvI6OlOiDui9+TIo+Tt4JwA43dgbuvOXkg6VJOhNfmUfnkZTZEjFlJvs1
         vCkYLKnp1zO/QvySl3NxQHrDiBSARpp63lkPvguegRFGaFI3XUCwV0gKvckpGKVbNR
         jPMmHosUyH79Csjs3iZU/O9odhw6S+G94sTif/ZBwg156xAbHX6V6k388Yb9vFT5fS
         tf+C4YhnTI8Sw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-01-06 3:16 PM, Petr Machata wrote:
> 
> Roi Dayan <roid@nvidia.com> writes:
> 
>> On 2021-01-06 10:42 AM, Roi Dayan wrote:
>>>
>>> On 2021-01-04 6:07 PM, Petr Machata wrote:
>>>>
>>>> I think that just adding an unnecessary -lm is more of a tidiness issue
>>>> than anything else. One way to avoid it is to split the -lm deps out
>>>> from util.c / json_print.c to like util_math.c / json_print_math.c. That
>>>> way they will be in an .o of their own, and won't be linked in unless
>>>> the binary in question needs the code. Then the binaries that do call it
>>>> can keep on linking in -lm like they did so far.
>>>>
>>>> Thoughts?
>>>>
>>> ok fine by me.
>>
>> I looked at this and for get_size()/rate/.. it went smooth.
>> but for print_color_size() there is an issue that it uses
>> _IS_JSON_CONTEXT and statuic *_jw which are defined in json_print.c
>> Is it ok to expose those in json_print.h now so json_print_math.c
>> could use?
> 
> You don't need json_print_math.h IMHO, it can all be backed by the same
> header, just different implementation modules. From the API point of
> view, I don't think the user should really care which of the symbols use
> math (though of course they will have to know whether to link in -lm).

right ok.

> 
> Regarding the publishing, the _jw reference can be changed to a call to
> is_json_context(), which does the same thing. Then _jw can stay private
> in json_print.c.
> 
> Exposing an _IS_JSON_CONTEXT / _IS_FP_CONTEXT might be odd on account of
> the initial underscore, but since it's only used in implementations,
> maybe it's OK?
> 

With is_json_context() I cannot check the type passed by the caller.
i.e. PRINT_JSON, PRINT_FP, PRINT_ANY.

 From what I see now callers use is_json_context() to decide which print
to use. but in print_color_size() I should check the type to decide
which print.

