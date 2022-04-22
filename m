Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C577550AE3B
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 04:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443621AbiDVC55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 22:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbiDVC54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 22:57:56 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E912229E;
        Thu, 21 Apr 2022 19:55:03 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KkzXZ0ZspzhXkY;
        Fri, 22 Apr 2022 10:54:54 +0800 (CST)
Received: from [10.67.110.176] (10.67.110.176) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 22 Apr 2022 10:55:01 +0800
Subject: Re: [PATCH -next] libbpf: Add additional null-pointer checking in
 make_parent_dir
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        <gongruiqi1@huawei.com>, <wangweiyang2@huawei.com>
References: <20220421130056.2510372-1-cuigaosheng1@huawei.com>
 <CAEf4Bza3inoAHsS0w=nKXNgxyFqzPXJVyDHq03Foody6Vgp7=Q@mail.gmail.com>
From:   cuigaosheng <cuigaosheng1@huawei.com>
Message-ID: <60b4e208-efed-c2fb-d1e0-125e5409c861@huawei.com>
Date:   Fri, 22 Apr 2022 10:55:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAEf4Bza3inoAHsS0w=nKXNgxyFqzPXJVyDHq03Foody6Vgp7=Q@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.110.176]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This email adjusts the code format.

I don't understand why we don't check path for NULL, bpf_link__pin is an 
external
interface, It will be called by external functions and provide input 
parameters,
for example in samples/bpf/hbm.c:

> 201         link = bpf_program__attach_cgroup(bpf_prog, cg1);
> 202         if (libbpf_get_error(link)) {
> 203                 fprintf(stderr, "ERROR: bpf_program__attach_cgroup 
> failed\n");
> 204                 goto err;
> 205         }
> 206
> 207         sprintf(cg_pin_path, "/sys/fs/bpf/hbm%d", cg_id);
> 208         rc = bpf_link__pin(link, cg_pin_path);
> 209         if (rc < 0) {
> 210                 printf("ERROR: bpf_link__pin failed: %d\n", rc);
> 211                 goto err;
> 212         }

if cg_pin_path is NULL, strdup(NULL) will trigger a segmentation fault in
make_parent_dir, I think we should avoid this and add null-pointer checking
for path, just like check_path:
>  7673 static int check_path(const char *path)
>  7674 {
>  7675         char *cp, errmsg[STRERR_BUFSIZE];
>  7676         struct statfs st_fs;
>  7677         char *dname, *dir;
>  7678         int err = 0;
>  7679
>  7680         if (path == NULL)
>  7681                 return -EINVAL;
>  7682
>  7683         dname = strdup(path);
>  7684         if (dname == NULL)
>  7685                 return -ENOMEM;
>  7686
>  7687         dir = dirname(dname);
>  7688         if (statfs(dir, &st_fs)) {
>  7689                 cp = libbpf_strerror_r(errno, errmsg, 
> sizeof(errmsg));
>  7690                 pr_warn("failed to statfs %s: %s\n", dir, cp);
>  7691                 err = -errno;
>  7692         }
>  7693         free(dname);
>  7694
>  7695         if (!err && st_fs.f_type != BPF_FS_MAGIC) {
>  7696                 pr_warn("specified path %s is not on BPF FS\n", 
> path);
>  7697                 err = -EINVAL;
>  7698         }
>  7699
>  7700         return err;
>  7701 }

Thanks.


在 2022/4/22 0:55, Andrii Nakryiko 写道:
> On Thu, Apr 21, 2022 at 6:01 AM Gaosheng Cui <cuigaosheng1@huawei.com> wrote:
>> The make_parent_dir is called without null-pointer checking for path,
>> such as bpf_link__pin. To ensure there is no null-pointer dereference
>> in make_parent_dir, so make_parent_dir requires additional null-pointer
>> checking for path.
>>
>> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
>> ---
>>   tools/lib/bpf/libbpf.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> index b53e51884f9e..5786e6184bf5 100644
>> --- a/tools/lib/bpf/libbpf.c
>> +++ b/tools/lib/bpf/libbpf.c
>> @@ -7634,6 +7634,9 @@ static int make_parent_dir(const char *path)
>>          char *dname, *dir;
>>          int err = 0;
>>
>> +       if (path == NULL)
>> +               return -EINVAL;
>> +
> API contract is that path shouldn't be NULL. Just like we don't check
> link, obj, prog for NULL in every single API, I don't think we need to
> do it here, unless I'm missing something?
>
>>          dname = strdup(path);
>>          if (dname == NULL)
>>                  return -ENOMEM;
>> --
>> 2.25.1
>>
> .
