Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A191CF105
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 11:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729328AbgELJG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 05:06:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35885 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729274AbgELJG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 05:06:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589274415;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BJliPFhZAL/akqMw0l+s3CPSC2GuB2Wpj8gA4x6beco=;
        b=L5Cosmd6Y1uAKFDs3AU2gClWkB8B/LOOXinMk8fRzKnhXFGjQPTE710pZDHfrVEryvsn8q
        /vDWa0pu0IR4iwIRKxY9xgUs+MGepjhga+JhXmakaNkS40u36646syhl8roT4Mbq7g8bM+
        meV3tx0enxhuR0BlGtJ+5qa2Ai2LI2c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-fYDG6fcXNeCy4iZ1h3XXvQ-1; Tue, 12 May 2020 05:06:53 -0400
X-MC-Unique: fYDG6fcXNeCy4iZ1h3XXvQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2D565846379;
        Tue, 12 May 2020 09:06:52 +0000 (UTC)
Received: from [10.36.114.16] (ovpn-114-16.ams2.redhat.com [10.36.114.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2AE1D5C1D6;
        Tue, 12 May 2020 09:06:45 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Yonghong Song" <yhs@fb.com>
Cc:     bpf@vger.kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, andriin@fb.com, toke@redhat.com
Subject: Re: [PATCH bpf-next v3] libbpf: fix probe code to return EPERM if
 encountered
Date:   Tue, 12 May 2020 11:06:43 +0200
Message-ID: <C6DEFAAB-C77F-435C-A5ED-56F16BC5AF4D@redhat.com>
In-Reply-To: <7008d545-ac78-3e22-aeaa-1d6639611225@fb.com>
References: <158920079637.7533.5703299045869368435.stgit@ebuild>
 <7008d545-ac78-3e22-aeaa-1d6639611225@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11 May 2020, at 22:43, Yonghong Song wrote:

> On 5/11/20 5:40 AM, Eelco Chaudron wrote:
>> When the probe code was failing for any reason ENOTSUP was returned, 
>> even
>> if this was due to no having enough lock space. This patch fixes this 
>> by
>> returning EPERM to the user application, so it can respond and 
>> increase
>> the RLIMIT_MEMLOCK size.
>>
>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>> ---
>> v3: Updated error message to be more specific as suggested by Andrii
>> v2: Split bpf_object__probe_name() in two functions as suggested by 
>> Andrii
>>
>>   tools/lib/bpf/libbpf.c |   31 ++++++++++++++++++++++++++-----
>>   1 file changed, 26 insertions(+), 5 deletions(-)
>>
>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> index 8f480e29a6b0..ad3043c5db13 100644
>> --- a/tools/lib/bpf/libbpf.c
>> +++ b/tools/lib/bpf/libbpf.c
>> @@ -3149,7 +3149,7 @@ int bpf_map__resize(struct bpf_map *map, __u32 
>> max_entries)
>>   }
>>    static int
>> -bpf_object__probe_name(struct bpf_object *obj)
>> +bpf_object__probe_loading(struct bpf_object *obj)
>>   {
>>   	struct bpf_load_program_attr attr;
>>   	char *cp, errmsg[STRERR_BUFSIZE];
>> @@ -3170,14 +3170,34 @@ bpf_object__probe_name(struct bpf_object 
>> *obj)
>>   	ret = bpf_load_program_xattr(&attr, NULL, 0);
>>   	if (ret < 0) {
>>   		cp = libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
>> -		pr_warn("Error in %s():%s(%d). Couldn't load basic 'r0 = 0' BPF 
>> program.\n",
>> -			__func__, cp, errno);
>> +		pr_warn("Error in %s():%s(%d). Couldn't load trivial BPF "
>> +			"program. Make sure your kernel supports BPF "
>> +			"(CONFIG_BPF_SYSCALL=y) and/or that RLIMIT_MEMLOCK is "
>> +			"set to big enough value.\n", __func__, cp, errno);
>>   		return -errno;
>
> Just curious. Did "errno" always survive pr_warn() here? pr_warn() may 
> call user supplied print function which it outside libbpf control.
> Maybe should cache errno before calling pr_warn()?

I guess this issue has always been there, however, I sent out a v4 
fixing this case.

>>   	}
>>   	close(ret);
>>  -	/* now try the same program, but with the name */
>> +	return 0;
>> +}
>> +
>> +static int
>> +bpf_object__probe_name(struct bpf_object *obj)
>> +{
>> +	struct bpf_load_program_attr attr;
>> +	struct bpf_insn insns[] = {
>> +		BPF_MOV64_IMM(BPF_REG_0, 0),
>> +		BPF_EXIT_INSN(),
>> +	};
>> +	int ret;
>> +
>> +	/* make sure loading with name works */
>>  +	memset(&attr, 0, sizeof(attr));
>> +	attr.prog_type = BPF_PROG_TYPE_SOCKET_FILTER;
>> +	attr.insns = insns;
>> +	attr.insns_cnt = ARRAY_SIZE(insns);
>> +	attr.license = "GPL";
>>   	attr.name = "test";
>>   	ret = bpf_load_program_xattr(&attr, NULL, 0);
>>   	if (ret >= 0) {
>> @@ -5386,7 +5406,8 @@ int bpf_object__load_xattr(struct 
>> bpf_object_load_attr *attr)
>>    	obj->loaded = true;
>>  -	err = bpf_object__probe_caps(obj);
>> +	err = bpf_object__probe_loading(obj);
>> +	err = err ? : bpf_object__probe_caps(obj);
>>   	err = err ? : bpf_object__resolve_externs(obj, obj->kconfig);
>>   	err = err ? : bpf_object__sanitize_and_load_btf(obj);
>>   	err = err ? : bpf_object__sanitize_maps(obj);
>>

