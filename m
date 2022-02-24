Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2474C28E6
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 11:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233230AbiBXKJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 05:09:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233227AbiBXKJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 05:09:40 -0500
Received: from mail.tintel.eu (mail.tintel.eu [51.83.127.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223D128AD96;
        Thu, 24 Feb 2022 02:09:05 -0800 (PST)
Received: from localhost (localhost [IPv6:::1])
        by mail.tintel.eu (Postfix) with ESMTP id 50C8C434FC4A;
        Thu, 24 Feb 2022 11:09:02 +0100 (CET)
Received: from mail.tintel.eu ([IPv6:::1])
        by localhost (mail.tintel.eu [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id SFVhmd4-Hbc4; Thu, 24 Feb 2022 11:09:01 +0100 (CET)
Received: from localhost (localhost [IPv6:::1])
        by mail.tintel.eu (Postfix) with ESMTP id BBDAB434FC4B;
        Thu, 24 Feb 2022 11:09:01 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.tintel.eu BBDAB434FC4B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux-ipv6.be;
        s=502B7754-045F-11E5-BBC5-64595FD46BE8; t=1645697341;
        bh=NsEziSD8zXGAxjibXFGFRrDDNKL9BST7ZKyzNe6aCCc=;
        h=Message-ID:Date:MIME-Version:To:From;
        b=cjdelavZb9bpnlZ24Xu1lGiiftDZaQ9y9quF0qr572LG3GfZefKKt9dUqmP7bjiLj
         R1a8lWip6pBHta8VooDEz3xgPmIt8MdklEls7mtZKSqClTrUKqLM5TJBk0v+8Siyyx
         keJo3orc3JNB7CeA95rH4x8IBQDcFtW6jFtaYZlc=
X-Virus-Scanned: amavisd-new at mail.tintel.eu
Received: from mail.tintel.eu ([IPv6:::1])
        by localhost (mail.tintel.eu [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id 0BgzWEgqgmxJ; Thu, 24 Feb 2022 11:09:01 +0100 (CET)
Received: from [IPV6:2001:67c:21bc:20::10] (unknown [IPv6:2001:67c:21bc:20::10])
        (Authenticated sender: stijn@tintel.eu)
        by mail.tintel.eu (Postfix) with ESMTPSA id E115A434FC4A;
        Thu, 24 Feb 2022 11:09:00 +0100 (CET)
Message-ID: <ac624e07-5310-438a-dce3-d2edb01e8031@linux-ipv6.be>
Date:   Thu, 24 Feb 2022 12:08:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] libbpf: fix BPF_MAP_TYPE_PERF_EVENT_ARRAY auto-pinning
Content-Language: en-GB
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Song Liu <song@kernel.org>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
References: <20220222204236.2192513-1-stijn@linux-ipv6.be>
 <CAPhsuW6WgjL_atKCivbk5iMNBFHuSGcjAC0tdZYag2fOesUBKA@mail.gmail.com>
 <CAEf4BzYuk2Rur-pae7gbuXSb=ayJ0fUREStdWyorWgd_q1D9zQ@mail.gmail.com>
From:   Stijn Tintel <stijn@linux-ipv6.be>
In-Reply-To: <CAEf4BzYuk2Rur-pae7gbuXSb=ayJ0fUREStdWyorWgd_q1D9zQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/02/2022 01:15, Andrii Nakryiko wrote:
> On Tue, Feb 22, 2022 at 6:37 PM Song Liu <song@kernel.org> wrote:
>> On Tue, Feb 22, 2022 at 12:51 PM Stijn Tintel <stijn@linux-ipv6.be> wrote:
>>> When a BPF map of type BPF_MAP_TYPE_PERF_EVENT_ARRAY doesn't have the
>>> max_entries parameter set, this parameter will be set to the number of
>>> possible CPUs. Due to this, the map_is_reuse_compat function will return
>>> false, causing the following error when trying to reuse the map:
>>>
>>> libbpf: couldn't reuse pinned map at '/sys/fs/bpf/m_logging': parameter mismatch
>>>
>>> Fix this by checking against the number of possible CPUs if the
>>> max_entries parameter is not set in the map definition.
>>>
>>> Fixes: 57a00f41644f ("libbpf: Add auto-pinning of maps when loading BPF objects")
>>> Signed-off-by: Stijn Tintel <stijn@linux-ipv6.be>
>> Acked-by: Song Liu <songliubraving@fb.com>
>>
>> I think the following fix would be more future proof, but the patch
>> as-is is better for
>> stable backport? How about we add a follow up patch on top of current
>> patch to fix
>> def->max_entries once for all?
> Keeping special logic for PERF_EVENT_ARRAY in one place is
> preferrable. With this, the changes in map_is_reuse_compat() shouldn't
> be necessary at all. Stijn, can you please send v2 with Song's
> proposed changes?
>
Will do!

Thanks,
Stijn

