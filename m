Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172222EBE6C
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 14:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbhAFNRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 08:17:34 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:14075 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbhAFNRd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 08:17:33 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff5b8450000>; Wed, 06 Jan 2021 05:16:53 -0800
Received: from yaviefel (172.20.145.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 6 Jan 2021 13:16:51
 +0000
References: <1609355503-7981-1-git-send-email-roid@nvidia.com>
 <875z4cwus8.fsf@nvidia.com>
 <405e8cce-e2dd-891a-dc8a-7c8b0c77f4c6@nvidia.com>
 <4a07fbc9-8e1c-ecd6-ee9e-31d1a952ba42@nvidia.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Petr Machata <petrm@nvidia.com>
To:     Roi Dayan <roid@nvidia.com>
CC:     <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Petr Machata <me@pmachata.org>
Subject: Re: [PATCH iproute2] build: Fix link errors on some systems
In-Reply-To: <4a07fbc9-8e1c-ecd6-ee9e-31d1a952ba42@nvidia.com>
Message-ID: <87y2h6urwe.fsf@nvidia.com>
Date:   Wed, 6 Jan 2021 14:16:49 +0100
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609939013; bh=UoX2I/ghC8sG6a+Abt5Y0UdVRPcbibVy+MMKPU7cP3o=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Message-ID:
         Date:MIME-Version:Content-Type:X-Originating-IP:X-ClientProxiedBy;
        b=Hh3mOHH42LSRRnhSYa+7rJ8kV7iKigParptKj3ZHylcMmgOuGGU94RRWTYNO58NVO
         rCKgV5jFLLHS9IVpBg+QpWSqSu4sB/gif1XRMEna969vtzZEt22t9gqtQWu7+jTh2w
         Za7n7QRPX4crWK6BKjXxlaktzEH/89pLRGAaDxKgboEaso+CNPAXQBWz3Bo3M1TAhI
         1+132ubeEnNFGoZi5ufB6ZHKs11nMDfFz0+kzplF28QEBwJ/IewMBIG6cgYvNSKxuP
         NpbLGAmkYQNhTp6B8o3j0LN/24iYFT/6qkAcGPRAGCZPhyjakCncRb30vvRixvRosv
         Tfep+5ohdVb8w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Roi Dayan <roid@nvidia.com> writes:

> On 2021-01-06 10:42 AM, Roi Dayan wrote:
>> 
>> On 2021-01-04 6:07 PM, Petr Machata wrote:
>>>
>>> I think that just adding an unnecessary -lm is more of a tidiness issue
>>> than anything else. One way to avoid it is to split the -lm deps out
>>> from util.c / json_print.c to like util_math.c / json_print_math.c. That
>>> way they will be in an .o of their own, and won't be linked in unless
>>> the binary in question needs the code. Then the binaries that do call it
>>> can keep on linking in -lm like they did so far.
>>>
>>> Thoughts?
>>>
>> ok fine by me.
>
> I looked at this and for get_size()/rate/.. it went smooth.
> but for print_color_size() there is an issue that it uses
> _IS_JSON_CONTEXT and statuic *_jw which are defined in json_print.c
> Is it ok to expose those in json_print.h now so json_print_math.c
> could use?

You don't need json_print_math.h IMHO, it can all be backed by the same
header, just different implementation modules. From the API point of
view, I don't think the user should really care which of the symbols use
math (though of course they will have to know whether to link in -lm).

Regarding the publishing, the _jw reference can be changed to a call to
is_json_context(), which does the same thing. Then _jw can stay private
in json_print.c.

Exposing an _IS_JSON_CONTEXT / _IS_FP_CONTEXT might be odd on account of
the initial underscore, but since it's only used in implementations,
maybe it's OK?
