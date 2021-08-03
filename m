Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B43363DF219
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbhHCQGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:06:47 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:57801 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbhHCQGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 12:06:46 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id A7A97200BFF1;
        Tue,  3 Aug 2021 18:06:33 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be A7A97200BFF1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1628006793;
        bh=ccxZEbWfpIpAkEBoNZKIw0Nv2nbaM5YZA1KGk0VoK8I=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=WpfSEq9ksTmYkPuiZuj90n1eVD3b5JuD9ZM2dzWbxwWotmMlcDU7+Bzl96gvnXy9M
         VYo9wFQrzX15JbZ3ysmVELHHNYYChjAZo1jRPR1WcRHZ5RiyRU2imTHhtNPuA+o5K+
         rohEvE+kXRFX50pi+QbRbKNHq3L2AyYNQQkJtjbHR+qqrouGOKuJywqNbs+V/QhX2b
         ceGifwLOJoryqbQu37ha7xFVEYVmCUt48nWfeCUr9shuw313xIPiKoV5GLDytyT0Ff
         bliosX5bKe6ywDwCIx3dtpRLSDZ68gqXqmoUlVKhWMLql30t8El1lzuFttAlWw+Uof
         mb6pZIL/Hz9Cg==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 9CC13600DD841;
        Tue,  3 Aug 2021 18:06:33 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id VG9DFQZs6U8z; Tue,  3 Aug 2021 18:06:33 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 836B16008D552;
        Tue,  3 Aug 2021 18:06:33 +0200 (CEST)
Date:   Tue, 3 Aug 2021 18:06:33 +0200 (CEST)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, tom@herbertland.com
Message-ID: <989297896.30838930.1628006793490.JavaMail.zimbra@uliege.be>
In-Reply-To: <ce46ace3-11b9-6a75-b665-cee79252550e@gmail.com>
References: <20210802205133.24071-1-justin.iurman@uliege.be> <ce46ace3-11b9-6a75-b665-cee79252550e@gmail.com>
Subject: Re: [RFC net-next] ipv6: Attempt to improve options code parsing
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF90 (Linux)/8.8.15_GA_4026)
Thread-Topic: ipv6: Attempt to improve options code parsing
Thread-Index: TzYWc8XXuSa6+xhoSFACtb8Qr+ikRQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> As per Eric's comment on a previous patchset that was adding a new HopbyHop
>> option, i.e. why should a new option appear before or after existing ones in the
>> list, here is an attempt to suppress such competition. It also improves the
>> efficiency and fasten the process of matching a Hbh or Dst option, which is
>> probably something we want regarding the list of new options that could quickly
>> grow in the future.
>> 
>> Basically, the two "lists" of options (Hbh and Dst) are replaced by two arrays.
>> Each array has a size of 256 (for each code point). Each code point points to a
>> function to process its specific option.
>> 
>> Thoughts?
>> 
> Hi Justin
> 
> I think this still suffers from indirect call costs (CONFIG_RETPOLINE=y),
> and eventually use more dcache.

Agree with both. It was the compromise for such a solution, unfortunately.

> Since we only deal with two sets/arrays, I would simply get rid of them
> and inline the code using two switch() clauses.

Indeed, this is the more efficient. However, we still have two "issues":
 - ip6_parse_tlv will keep growing and code could look ugly at some point
 - there is still a "competition" between options, i.e. "I want to be at the top of the list"

Anyway, your solution is better than the current one so it's probably the way to go right now.
