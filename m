Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B621BFE1C
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 16:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgD3OZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 10:25:49 -0400
Received: from www62.your-server.de ([213.133.104.62]:45722 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbgD3OZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 10:25:49 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jUA8I-0008KP-7o; Thu, 30 Apr 2020 16:25:46 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jUA8H-000UAf-V8; Thu, 30 Apr 2020 16:25:45 +0200
Subject: Re: [PATCH v2 bpf-next] libbpf: fix false uninitialized variable
 warning
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200430021436.1522502-1-andriin@fb.com>
 <87imhhv1av.fsf@cloudflare.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <327815ee-9a10-cab3-c8f8-8ceeafa0877f@iogearbox.net>
Date:   Thu, 30 Apr 2020 16:25:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87imhhv1av.fsf@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25798/Thu Apr 30 14:03:33 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/30/20 10:13 AM, Jakub Sitnicki wrote:
> On Thu, Apr 30, 2020 at 04:14 AM CEST, Andrii Nakryiko wrote:
>> Some versions of GCC falsely detect that vi might not be initialized. That's
>> not true, but let's silence it with NULL initialization.
>>
>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>> ---
>>   tools/lib/bpf/libbpf.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> index d86ff8214b96..977add1b73e2 100644
>> --- a/tools/lib/bpf/libbpf.c
>> +++ b/tools/lib/bpf/libbpf.c
>> @@ -5003,8 +5003,8 @@ static int bpf_object__collect_map_relos(struct bpf_object *obj,
>>   					 GElf_Shdr *shdr, Elf_Data *data)
>>   {
>>   	int i, j, nrels, new_sz, ptr_sz = sizeof(void *);
>> +	const struct btf_var_secinfo *vi = NULL;
>>   	const struct btf_type *sec, *var, *def;
>> -	const struct btf_var_secinfo *vi;
>>   	const struct btf_member *member;
>>   	struct bpf_map *map, *targ_map;
>>   	const char *name, *mname;
> 
> Alternatively we could borrow the kernel uninitialized_var macro:
> 
> include/linux/compiler-clang.h:#define uninitialized_var(x) x = *(&(x))
> include/linux/compiler-gcc.h:#define uninitialized_var(x) x = x

We could do that potentially, at least to mark such locations explicitly,
although I wonder if it's not more churn than anything else adding the
infra for it. But generally no objections from my side.

Anyway, applied this one, thanks!
