Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF9BD4C3003
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 16:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236237AbiBXPi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 10:38:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236134AbiBXPiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 10:38:54 -0500
X-Greylist: delayed 154540 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 24 Feb 2022 07:38:22 PST
Received: from mail.tintel.eu (mail.tintel.eu [IPv6:2001:41d0:a:6e77:0:ff:fe5c:6a54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446611BE4CF;
        Thu, 24 Feb 2022 07:38:22 -0800 (PST)
Received: from localhost (localhost [IPv6:::1])
        by mail.tintel.eu (Postfix) with ESMTP id 29FBA424DC5A;
        Thu, 24 Feb 2022 16:38:20 +0100 (CET)
Received: from mail.tintel.eu ([IPv6:::1])
        by localhost (mail.tintel.eu [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id Eu0qMrATjC32; Thu, 24 Feb 2022 16:38:19 +0100 (CET)
Received: from localhost (localhost [IPv6:::1])
        by mail.tintel.eu (Postfix) with ESMTP id 67D1842A43DC;
        Thu, 24 Feb 2022 16:38:19 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.tintel.eu 67D1842A43DC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux-ipv6.be;
        s=502B7754-045F-11E5-BBC5-64595FD46BE8; t=1645717099;
        bh=fHTcMK2fjry/ZwLUwGR9VTL4Aj2hsXiagbddnpv2XGo=;
        h=Message-ID:Date:MIME-Version:From:To;
        b=FO8WdDV8uji5PVkWOA5cQGMJlBitplUUfCXWUHxvPuPDokv3IdAK6TgZSLCWVxsq7
         iUKErd5VtF9S3tSY8EfsYfQT/vHN3GkwY0AKkvtOlqzO0GFSiN7rq5xxfnM/Ei4Jde
         j1Wg/+G6RYUxzlP9AK5O5XN7B7Ge2+CU/cJfErtk=
X-Virus-Scanned: amavisd-new at mail.tintel.eu
Received: from mail.tintel.eu ([IPv6:::1])
        by localhost (mail.tintel.eu [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id qHjvbEqDfLeW; Thu, 24 Feb 2022 16:38:19 +0100 (CET)
Received: from [IPV6:2001:67c:21bc:20::10] (unknown [IPv6:2001:67c:21bc:20::10])
        (Authenticated sender: stijn@tintel.eu)
        by mail.tintel.eu (Postfix) with ESMTPSA id 98ADF424DC5A;
        Thu, 24 Feb 2022 16:38:18 +0100 (CET)
Message-ID: <0f1fb86b-f8df-b209-9a89-512cbc142e04@linux-ipv6.be>
Date:   Thu, 24 Feb 2022 17:38:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] libbpf: fix BPF_MAP_TYPE_PERF_EVENT_ARRAY auto-pinning
Content-Language: en-GB
From:   Stijn Tintel <stijn@linux-ipv6.be>
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
 <ac624e07-5310-438a-dce3-d2edb01e8031@linux-ipv6.be>
In-Reply-To: <ac624e07-5310-438a-dce3-d2edb01e8031@linux-ipv6.be>
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

On 24/02/2022 12:08, Stijn Tintel wrote:
> On 24/02/2022 01:15, Andrii Nakryiko wrote:
>> On Tue, Feb 22, 2022 at 6:37 PM Song Liu <song@kernel.org> wrote:
>>> On Tue, Feb 22, 2022 at 12:51 PM Stijn Tintel <stijn@linux-ipv6.be> wrote:
>>>> When a BPF map of type BPF_MAP_TYPE_PERF_EVENT_ARRAY doesn't have the
>>>> max_entries parameter set, this parameter will be set to the number of
>>>> possible CPUs. Due to this, the map_is_reuse_compat function will return
>>>> false, causing the following error when trying to reuse the map:
>>>>
>>>> libbpf: couldn't reuse pinned map at '/sys/fs/bpf/m_logging': parameter mismatch
>>>>
>>>> Fix this by checking against the number of possible CPUs if the
>>>> max_entries parameter is not set in the map definition.
>>>>
>>>> Fixes: 57a00f41644f ("libbpf: Add auto-pinning of maps when loading BPF objects")
>>>> Signed-off-by: Stijn Tintel <stijn@linux-ipv6.be>
>>> Acked-by: Song Liu <songliubraving@fb.com>
>>>
>>> I think the following fix would be more future proof, but the patch
>>> as-is is better for
>>> stable backport? How about we add a follow up patch on top of current
>>> patch to fix
>>> def->max_entries once for all?
>> Keeping special logic for PERF_EVENT_ARRAY in one place is
>> preferrable. With this, the changes in map_is_reuse_compat() shouldn't
>> be necessary at all. Stijn, can you please send v2 with Song's
>> proposed changes?
>>
> Will do!

Unfortunately that doesn't work. In bpf_object__create_maps, we call
bpf_object__reuse_map and map_is_reuse_compat before
bpf_object__create_map, so we check map_info.max_entries ==
map->def.max_entries before the latter is being overwritten.

So I propose to send a v2 based on my initial submission, but use __u32
for def_max_entries instead of int, unless someone has another suggestion?

Thanks,
Stijn

