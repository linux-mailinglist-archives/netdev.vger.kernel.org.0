Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E213DF407
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 19:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238347AbhHCRl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 13:41:27 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:34482 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238336AbhHCRl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 13:41:26 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id B37D3200CCEE;
        Tue,  3 Aug 2021 19:41:12 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be B37D3200CCEE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1628012472;
        bh=hykQaHUjYKHsbeoX7R2Gj9iNQD34r4+dYYkJzbBLzy0=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=dageIhBMtx55TPXcp6iYGjTXiuY/LWQnR30bvPPesaVrcWn/kH68a+cmIpEBn9i8Q
         hUGjg4Ebe9fCVTthGzZBucsdf/DNkTKqDQWm/J2hADSC86EoNxIqm8lkEYC9EZzkvk
         r+uUj2bREtV08AMzMGy+DCLaM9F1Q4CXlHguCNb+78tTCV84fdwrpEx4QtCmtQB6yG
         n4iJ7PodYrWCC9bBt3XnqlRlM3Sr0kqFoFYysIl6Jn8rY1ZNEdtqHCDEHU3mVEixnv
         sisgt0uyXAnGxRzHh5l41YUK/AM1f402Y+eQWnvxa4vA7K8UPneapGQqs1Vq09Z36R
         HBWckYmpcQX9Q==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id A9CCF600DD841;
        Tue,  3 Aug 2021 19:41:12 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id fb6r_kIPIf0a; Tue,  3 Aug 2021 19:41:12 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 8FE556008D451;
        Tue,  3 Aug 2021 19:41:12 +0200 (CEST)
Date:   Tue, 3 Aug 2021 19:41:12 +0200 (CEST)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, tom@herbertland.com
Message-ID: <2112761850.30866431.1628012472544.JavaMail.zimbra@uliege.be>
In-Reply-To: <aa58193c-0a8f-d11b-fb0c-bc41571e33ac@gmail.com>
References: <20210802205133.24071-1-justin.iurman@uliege.be> <ce46ace3-11b9-6a75-b665-cee79252550e@gmail.com> <989297896.30838930.1628006793490.JavaMail.zimbra@uliege.be> <aa58193c-0a8f-d11b-fb0c-bc41571e33ac@gmail.com>
Subject: Re: [RFC net-next] ipv6: Attempt to improve options code parsing
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF90 (Linux)/8.8.15_GA_4026)
Thread-Topic: ipv6: Attempt to improve options code parsing
Thread-Index: B7PWpTp4E5E8ZaN+o6ZIoZAL5qtMHA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>>> As per Eric's comment on a previous patchset that was adding a new HopbyHop
>>>> option, i.e. why should a new option appear before or after existing ones in the
>>>> list, here is an attempt to suppress such competition. It also improves the
>>>> efficiency and fasten the process of matching a Hbh or Dst option, which is
>>>> probably something we want regarding the list of new options that could quickly
>>>> grow in the future.
>>>>
>>>> Basically, the two "lists" of options (Hbh and Dst) are replaced by two arrays.
>>>> Each array has a size of 256 (for each code point). Each code point points to a
>>>> function to process its specific option.
>>>>
>>>> Thoughts?
>>>>
>>> Hi Justin
>>>
>>> I think this still suffers from indirect call costs (CONFIG_RETPOLINE=y),
>>> and eventually use more dcache.
>> 
>> Agree with both. It was the compromise for such a solution, unfortunately.
>> 
>>> Since we only deal with two sets/arrays, I would simply get rid of them
>>> and inline the code using two switch() clauses.
>> 
>> Indeed, this is the more efficient. However, we still have two "issues":
>>  - ip6_parse_tlv will keep growing and code could look ugly at some point
> 
> Well, in 10 years there has not been a lot of growth.

Indeed, but I think it could grow a lot more in short/middle term. Just have a look at current discussions in the IETF (e.g., 6man) about HopbyHop limitations and anything related, as a way to widely improve their support and not just drop them. A better support could bring new options.
