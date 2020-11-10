Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28FB52ACACA
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 02:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730087AbgKJB53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 20:57:29 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7163 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728607AbgKJB53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 20:57:29 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CVWFl1LXSz15TlK;
        Tue, 10 Nov 2020 09:57:15 +0800 (CST)
Received: from [10.174.179.81] (10.174.179.81) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Tue, 10 Nov 2020 09:57:20 +0800
Subject: Re: [PATCH bpf] tools: bpftool: Add missing close before bpftool net
 attach exit
To:     Michal Rostecki <mrostecki@opensuse.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <andrii@kernel.org>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        <toke@redhat.com>, <quentin@isovalent.com>,
        <danieltimlee@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20201109070410.65833-1-wanghai38@huawei.com>
 <3b07c1a3-d5cf-dfb4-9184-00fca6c7d3b1@opensuse.org>
From:   "wanghai (M)" <wanghai38@huawei.com>
Message-ID: <e43d28b0-f4eb-641c-2130-ea12e37b6b07@huawei.com>
Date:   Tue, 10 Nov 2020 09:57:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <3b07c1a3-d5cf-dfb4-9184-00fca6c7d3b1@opensuse.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.81]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2020/11/9 18:51, Michal Rostecki 写道:
> On 11/9/20 8:04 AM, Wang Hai wrote:
>> progfd is created by prog_parse_fd(), before 'bpftool net attach' exit,
>> it should be closed.
>>
>> Fixes: 04949ccc273e ("tools: bpftool: add net attach command to 
>> attach XDP on interface")
>> Signed-off-by: Wang Hai <wanghai38@huawei.com>
>> ---
>>   tools/bpf/bpftool/net.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
>> index 910e7bac6e9e..3e9b40e64fb0 100644
>> --- a/tools/bpf/bpftool/net.c
>> +++ b/tools/bpf/bpftool/net.c
>> @@ -600,12 +600,14 @@ static int do_attach(int argc, char **argv)
>>       if (err < 0) {
>>           p_err("interface %s attach failed: %s",
>>                 attach_type_strings[attach_type], strerror(-err));
>> +        close(progfd);
>>           return err;
>>       }
>>         if (json_output)
>>           jsonw_null(json_wtr);
>>   +    close(progfd);
>>       return 0;
>>   }
>
> Nit - wouldn't it be better to create a `cleanup`/`out` section before 
> return and use goto, to avoid copying the `close` call?
> .
>
Thanks for review. I just sent v2 patch

"[PATCH v2 bpf] tools: bpftool: Add missing close before bpftool net 
attach exit"

