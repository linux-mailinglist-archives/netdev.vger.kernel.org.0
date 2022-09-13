Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58C15B65D8
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 04:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiIMCzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 22:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiIMCzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 22:55:47 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9804F655;
        Mon, 12 Sep 2022 19:55:45 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MRSfm39Q4zmVNj;
        Tue, 13 Sep 2022 10:52:00 +0800 (CST)
Received: from [10.174.179.191] (10.174.179.191) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 13 Sep 2022 10:55:42 +0800
Message-ID: <6e010796-5f5b-0930-44dc-df1792f98eb9@huawei.com>
Date:   Tue, 13 Sep 2022 10:55:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [bpf-next 2/2] libbpf: Add pathname_concat() helper
To:     <sdf@google.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <haoluo@google.com>, <jolsa@kernel.org>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <aou@eecs.berkeley.edu>, <davem@davemloft.net>, <kuba@kernel.org>,
        <hawk@kernel.org>, <nathan@kernel.org>, <ndesaulniers@google.com>,
        <trix@redhat.com>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <llvm@lists.linux.dev>
References: <1662702346-29665-1-git-send-email-wangyufen@huawei.com>
 <1662702346-29665-2-git-send-email-wangyufen@huawei.com>
 <Yxt07BE7TOX6dGh2@google.com>
From:   wangyufen <wangyufen@huawei.com>
In-Reply-To: <Yxt07BE7TOX6dGh2@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.191]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/9/10 1:16, sdf@google.com 写道:
> On 09/09, Wang Yufen wrote:
>> Move snprintf and len check to common helper pathname_concat() to 
>> make the
>> code simpler.
>
>> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
>> ---
>>   tools/lib/bpf/libbpf.c | 74 
>> ++++++++++++++++++--------------------------------
>>   1 file changed, 27 insertions(+), 47 deletions(-)
>
>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> index 5854b92..238a03e 100644
>> --- a/tools/lib/bpf/libbpf.c
>> +++ b/tools/lib/bpf/libbpf.c
>> @@ -2096,20 +2096,31 @@ static bool get_map_field_int(const char 
>> *map_name, const struct btf *btf,
>>       return true;
>>   }
>
>> -static int build_map_pin_path(struct bpf_map *map, const char *path)
>> +static int pathname_concat(const char *path, const char *name, char 
>> *buf)
>>   {
>> -    char buf[PATH_MAX];
>>       int len;
>
>> -    if (!path)
>> -        path = "/sys/fs/bpf";
>> -
>> -    len = snprintf(buf, PATH_MAX, "%s/%s", path, bpf_map__name(map));
>> +    len = snprintf(buf, PATH_MAX, "%s/%s", path, name);
>>       if (len < 0)
>>           return -EINVAL;
>>       else if (len >= PATH_MAX)
>>           return -ENAMETOOLONG;
>
>> +    return 0;
>> +}
>> +
>> +static int build_map_pin_path(struct bpf_map *map, const char *path)
>> +{
>> +    char buf[PATH_MAX];
>> +    int err;
>> +
>> +    if (!path)
>> +        path = "/sys/fs/bpf";
>> +
>> +    err = pathname_concat(path, bpf_map__name(map), buf);
>> +    if (err)
>> +        return err;
>> +
>>       return bpf_map__set_pin_path(map, buf);
>>   }
>
>> @@ -7959,17 +7970,8 @@ int bpf_object__pin_maps(struct bpf_object 
>> *obj, const char *path)
>>               continue;
>
>>           if (path) {
>> -            int len;
>> -
>> -            len = snprintf(buf, PATH_MAX, "%s/%s", path,
>> -                       bpf_map__name(map));
>> -            if (len < 0) {
>> -                err = -EINVAL;
>> -                goto err_unpin_maps;
>> -            } else if (len >= PATH_MAX) {
>> -                err = -ENAMETOOLONG;
>
> [..]
>
>> +            if (pathname_concat(path, bpf_map__name(map), buf))
>>                   goto err_unpin_maps;
>> -            }
>
> You're breaking error reporting here and in a bunch of other places.
> Should be:
>
> err = pathname_concat();
> if (err)
>     goto err_unpin_maps;
>
Thanks for your comments.

Sure, my bad.

> I have the same attitude towards this patch as the first one in the
> series: not worth it. Nothing is currently broken, the code as is 
> relatively
> readable, this version is not much simpler, it just looks slightly 
> different
> taste-wise..
>
> How about this: if you really want to push this kind of cleanup, send
> selftests that exercise all these error cases? :-)

Ok. I will try.  :-)

>
>
>>               sanitize_pin_path(buf);
>>               pin_path = buf;
>>           } else if (!map->pin_path) {
>> @@ -8007,14 +8009,9 @@ int bpf_object__unpin_maps(struct bpf_object 
>> *obj, const char *path)
>>           char buf[PATH_MAX];
>
>>           if (path) {
>> -            int len;
>> -
>> -            len = snprintf(buf, PATH_MAX, "%s/%s", path,
>> -                       bpf_map__name(map));
>> -            if (len < 0)
>> -                return libbpf_err(-EINVAL);
>> -            else if (len >= PATH_MAX)
>> -                return libbpf_err(-ENAMETOOLONG);
>> +            err = pathname_concat(path, bpf_map__name(map), buf);
>> +            if (err)
>> +                return err;
>>               sanitize_pin_path(buf);
>>               pin_path = buf;
>>           } else if (!map->pin_path) {
>> @@ -8032,6 +8029,7 @@ int bpf_object__unpin_maps(struct bpf_object 
>> *obj, const char *path)
>>   int bpf_object__pin_programs(struct bpf_object *obj, const char *path)
>>   {
>>       struct bpf_program *prog;
>> +    char buf[PATH_MAX];
>>       int err;
>
>>       if (!obj)
>> @@ -8043,17 +8041,8 @@ int bpf_object__pin_programs(struct bpf_object 
>> *obj, const char *path)
>>       }
>
>>       bpf_object__for_each_program(prog, obj) {
>> -        char buf[PATH_MAX];
>> -        int len;
>> -
>> -        len = snprintf(buf, PATH_MAX, "%s/%s", path, prog->name);
>> -        if (len < 0) {
>> -            err = -EINVAL;
>> +        if (pathname_concat(path, prog->name, buf))
>>               goto err_unpin_programs;
>> -        } else if (len >= PATH_MAX) {
>> -            err = -ENAMETOOLONG;
>> -            goto err_unpin_programs;
>> -        }
>
>>           err = bpf_program__pin(prog, buf);
>>           if (err)
>> @@ -8064,13 +8053,7 @@ int bpf_object__pin_programs(struct bpf_object 
>> *obj, const char *path)
>
>>   err_unpin_programs:
>>       while ((prog = bpf_object__prev_program(obj, prog))) {
>> -        char buf[PATH_MAX];
>> -        int len;
>> -
>> -        len = snprintf(buf, PATH_MAX, "%s/%s", path, prog->name);
>> -        if (len < 0)
>> -            continue;
>> -        else if (len >= PATH_MAX)
>> +        if (pathname_concat(path, prog->name, buf))
>>               continue;
>
>>           bpf_program__unpin(prog, buf);
>> @@ -8089,13 +8072,10 @@ int bpf_object__unpin_programs(struct 
>> bpf_object *obj, const char *path)
>
>>       bpf_object__for_each_program(prog, obj) {
>>           char buf[PATH_MAX];
>> -        int len;
>
>> -        len = snprintf(buf, PATH_MAX, "%s/%s", path, prog->name);
>> -        if (len < 0)
>> -            return libbpf_err(-EINVAL);
>> -        else if (len >= PATH_MAX)
>> -            return libbpf_err(-ENAMETOOLONG);
>> +        err = pathname_concat(path, prog->name, buf);
>> +        if (err)
>> +            return libbpf_err(err);
>
>>           err = bpf_program__unpin(prog, buf);
>>           if (err)
>> -- 
>> 1.8.3.1
>
