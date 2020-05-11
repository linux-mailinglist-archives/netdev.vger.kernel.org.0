Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2954F1CE71D
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 23:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbgEKVIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 17:08:42 -0400
Received: from www62.your-server.de ([213.133.104.62]:56716 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725888AbgEKVIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 17:08:41 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jYFf3-0001jd-4r; Mon, 11 May 2020 23:08:29 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jYFf2-000M2P-Ps; Mon, 11 May 2020 23:08:28 +0200
Subject: Re: [PATCH bpf-next v3] libbpf: fix probe code to return EPERM if
 encountered
To:     Yonghong Song <yhs@fb.com>, Eelco Chaudron <echaudro@redhat.com>,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, andriin@fb.com,
        toke@redhat.com
References: <158920079637.7533.5703299045869368435.stgit@ebuild>
 <7008d545-ac78-3e22-aeaa-1d6639611225@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <625c343a-6554-a6e9-fb04-ca0a80554a91@iogearbox.net>
Date:   Mon, 11 May 2020 23:08:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <7008d545-ac78-3e22-aeaa-1d6639611225@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25809/Mon May 11 14:16:55 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/11/20 10:43 PM, Yonghong Song wrote:
> On 5/11/20 5:40 AM, Eelco Chaudron wrote:
>> When the probe code was failing for any reason ENOTSUP was returned, even
>> if this was due to no having enough lock space. This patch fixes this by
>> returning EPERM to the user application, so it can respond and increase
>> the RLIMIT_MEMLOCK size.
>>
>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>> ---
>> v3: Updated error message to be more specific as suggested by Andrii
>> v2: Split bpf_object__probe_name() in two functions as suggested by Andrii
>>
>>   tools/lib/bpf/libbpf.c |   31 ++++++++++++++++++++++++++-----
>>   1 file changed, 26 insertions(+), 5 deletions(-)
>>
>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> index 8f480e29a6b0..ad3043c5db13 100644
>> --- a/tools/lib/bpf/libbpf.c
>> +++ b/tools/lib/bpf/libbpf.c
>> @@ -3149,7 +3149,7 @@ int bpf_map__resize(struct bpf_map *map, __u32 max_entries)
>>   }
>>   static int
>> -bpf_object__probe_name(struct bpf_object *obj)
>> +bpf_object__probe_loading(struct bpf_object *obj)
>>   {
>>       struct bpf_load_program_attr attr;
>>       char *cp, errmsg[STRERR_BUFSIZE];
>> @@ -3170,14 +3170,34 @@ bpf_object__probe_name(struct bpf_object *obj)
>>       ret = bpf_load_program_xattr(&attr, NULL, 0);
>>       if (ret < 0) {
>>           cp = libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
>> -        pr_warn("Error in %s():%s(%d). Couldn't load basic 'r0 = 0' BPF program.\n",
>> -            __func__, cp, errno);
>> +        pr_warn("Error in %s():%s(%d). Couldn't load trivial BPF "
>> +            "program. Make sure your kernel supports BPF "
>> +            "(CONFIG_BPF_SYSCALL=y) and/or that RLIMIT_MEMLOCK is "
>> +            "set to big enough value.\n", __func__, cp, errno);
>>           return -errno;
> 
> Just curious. Did "errno" always survive pr_warn() here? pr_warn() may call user supplied print function which it outside libbpf control.
> Maybe should cache errno before calling pr_warn()?

+1, I think right now it's a bit of a mess in libbpf. Plenty of cases where we cache errno
before pr_warn() and plenty of cases where we don't. I think we should avoid any surprises
and do cache it on these occasions everywhere. Maybe a cocci script would help to fix the
remaining sites for good.

Thanks,
Daniel
