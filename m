Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C23B1314925
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 07:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhBIGzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 01:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhBIGzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 01:55:38 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058B8C061786;
        Mon,  8 Feb 2021 22:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=OzzFdviJ3ca1aQZZTAKj959JS8Sn/ctRbmRVuQ03I/U=; b=ll+JsQ5AoghPrXK9rpxpro4Jfe
        gpnfbvgMQsjQ2DrrN6AqBjKTwKnRh2+Zv0aMURdoh/HkBTDDCelEw4aYrqKwz5BLBxgk7zhJ/8XYV
        VHKK6vbsdoQT501C1SDQwNaQuHjycnq/ggXvy3tsvsF/PfJ32h/VrnRSy+LUVGjP6X58T3SoJOkSj
        DF1Xb4GD+IwwbaBA11q2Lar0KgcOCmPpQII52bkj0rA5xzX8m0HOnFSz/xGYD0RM3uRbF+cSi1GEh
        UKjbgNqu6ZeeNTzZurKbgLhGGMyOMfpCbHXBdfprRnx4cv7AcFl3YVMwg/zmAOclBf22RNxzC5qK5
        YJyo1d9Q==;
Received: from [2601:1c0:6280:3f0::cf3b]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l9MvF-0000f1-OP; Tue, 09 Feb 2021 06:54:54 +0000
Subject: Re: [PATCH bpf v2] selftests/bpf: remove bash feature in
 test_xdp_redirect.sh
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        u9012063@gmail.com
References: <20210206092654.155239-1-bjorn.topel@gmail.com>
 <CAEf4BzZ4aU26HGxYsOg4ma52bq9ghLDMJD03O1oQaRd8q0=ofA@mail.gmail.com>
 <f2970774-02a0-dd88-242c-d1fb9c7b3ce6@intel.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <36d7e0f5-e3e4-637e-d970-1dc69d1055c0@infradead.org>
Date:   Mon, 8 Feb 2021 22:54:49 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <f2970774-02a0-dd88-242c-d1fb9c7b3ce6@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/8/21 10:41 PM, Björn Töpel wrote:
> On 2021-02-09 06:52, Andrii Nakryiko wrote:
>> On Sat, Feb 6, 2021 at 1:29 AM Björn Töpel <bjorn.topel@gmail.com> wrote:
>>>
>>> From: Björn Töpel <bjorn.topel@intel.com>
>>>
>>> The test_xdp_redirect.sh script uses a bash redirect feature,
>>> '&>/dev/null'. Use '>/dev/null 2>&1' instead.
>>
>> We have plenty of explicit bash uses in selftest scripts, I'm not sure
>> it's a good idea to make scripts more verbose.
>>
> 
> $ cd tools/testing/selftests
> $ git grep '\#!/bin/bash'|wc -l
> 282
> $ git grep '\#!/bin/sh'|wc -l
> 164
> 
> Andrii/Randy, I'm fine with whatever. I just want to be able to run the
> test on Debian-derived systems. ;-)
> 
> 
>>>
>>> Also remove the 'set -e' since the script actually relies on that the
>>> return value can be used to determine pass/fail of the test.
>>
>> This sounds like a dubious decision. The script checks return results
>> only of last two commands, for which it's better to write and if
>> [<first command>] && [<second command>] check and leave set -e intact.
>>
> 
> Ok!
> 
> Please decide on the shell flavor, and I'll respin a v3.

In general shell scripts in the kernel try not to use bash (we have taken
several patches to convert from /bin/bash to /bin/sh scripts).
OTOH, perf and bpf seem to be large exceptions to this trend,
so it is apparently OK to use bash. :)
Sorry to sidetrack you.

-- 
~Randy

