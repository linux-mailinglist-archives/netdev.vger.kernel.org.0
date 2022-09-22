Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D97A95E5841
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 03:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiIVBvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 21:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiIVBvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 21:51:01 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE95AA99E2;
        Wed, 21 Sep 2022 18:50:57 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MXynM6xDyz14QPC;
        Thu, 22 Sep 2022 09:46:47 +0800 (CST)
Received: from [10.174.179.191] (10.174.179.191) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 09:50:54 +0800
Message-ID: <e5a553e3-4138-f8a0-c4d7-ec3d9d46732e@huawei.com>
Date:   Thu, 22 Sep 2022 09:50:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [bpf-next v3 1/2] libbpf: Add pathname_concat() helper
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <aou@eecs.berkeley.edu>, <davem@davemloft.net>, <kuba@kernel.org>,
        <hawk@kernel.org>, <nathan@kernel.org>, <ndesaulniers@google.com>,
        <trix@redhat.com>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <llvm@lists.linux.dev>
References: <1663555725-17016-1-git-send-email-wangyufen@huawei.com>
 <CAEf4BzbacgBeBrJcutGrpMceD2ipYyvRgrwyKdATN0K39adg5Q@mail.gmail.com>
From:   wangyufen <wangyufen@huawei.com>
In-Reply-To: <CAEf4BzbacgBeBrJcutGrpMceD2ipYyvRgrwyKdATN0K39adg5Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.191]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/9/22 8:41, Andrii Nakryiko 写道:
> On Sun, Sep 18, 2022 at 7:28 PM Wang Yufen <wangyufen@huawei.com> wrote:
>> Move snprintf and len check to common helper pathname_concat() to make the
>> code simpler.
>>
>> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
>> ---
>>   tools/lib/bpf/libbpf.c | 76 +++++++++++++++++++-------------------------------
>>   1 file changed, 29 insertions(+), 47 deletions(-)
>>
> [...]
>
>> @@ -8009,14 +8012,9 @@ int bpf_object__unpin_maps(struct bpf_object *obj, const char *path)
>>                  char buf[PATH_MAX];
>>
>>                  if (path) {
>> -                       int len;
>> -
>> -                       len = snprintf(buf, PATH_MAX, "%s/%s", path,
>> -                                      bpf_map__name(map));
>> -                       if (len < 0)
>> -                               return libbpf_err(-EINVAL);
>> -                       else if (len >= PATH_MAX)
>> -                               return libbpf_err(-ENAMETOOLONG);
>> +                       err = pathname_concat(path, bpf_map__name(map), buf, PATH_MAX);
>> +                       if (err)
>> +                               return err;
> also keep libbpf_err() as well, it sets errno properly
>
>>                          sanitize_pin_path(buf);
>>                          pin_path = buf;
>>                  } else if (!map->pin_path) {
>> @@ -8034,6 +8032,7 @@ int bpf_object__unpin_maps(struct bpf_object *obj, const char *path)
>>   int bpf_object__pin_programs(struct bpf_object *obj, const char *path)
>>   {
>>          struct bpf_program *prog;
>> +       char buf[PATH_MAX];
>>          int err;
>>
>>          if (!obj)
> [...]


Thanks for your comments， will send v4.


