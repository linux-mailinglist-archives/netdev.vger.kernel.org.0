Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF1F5B5D58
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 17:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbiILPiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 11:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbiILPiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 11:38:05 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F7325595;
        Mon, 12 Sep 2022 08:38:03 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R251e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=chentao.kernel@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VPXqnu2_1662997076;
Received: from 30.15.230.77(mailfrom:chentao.kernel@linux.alibaba.com fp:SMTPD_---0VPXqnu2_1662997076)
          by smtp.aliyun-inc.com;
          Mon, 12 Sep 2022 23:37:57 +0800
Message-ID: <c5fe5add-8ec1-17e6-3cb3-d87a59668298@linux.alibaba.com>
Date:   Mon, 12 Sep 2022 23:37:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH] libbpf: Support raw btf placed in the default path
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1661349907-57222-1-git-send-email-chentao.kernel@linux.alibaba.com>
 <CAEf4BzZPYAZ-ZJXa0CnrpxzFrXjTScfuioF=DOAw4j1L_tMXTg@mail.gmail.com>
 <b9eef4fe-71b3-d15c-6615-282124155508@linux.alibaba.com>
 <CAEf4BzZ04=R=48NjbUdp9SmQfy6z=S+kD0eYfYbGA3zzMSWn+w@mail.gmail.com>
From:   Tao Chen <chentao.kernel@linux.alibaba.com>
In-Reply-To: <CAEf4BzZ04=R=48NjbUdp9SmQfy6z=S+kD0eYfYbGA3zzMSWn+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-12.1 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2022/9/10 上午3:00, Andrii Nakryiko 写道:
> On Sun, Aug 28, 2022 at 10:36 PM Tao Chen
> <chentao.kernel@linux.alibaba.com> wrote:
>>
>> Hi Nakryiko, thank you for your reply. Yes, i happed to put the raw
>> BTF made by myself in /boot on kernel4.19, unluckly it reported error.
>> So is it possible to allow the raw BTF in /boot directly, athough we
>> can set the specified btf location again to solve the problem with the
>> bpf_object_open_opts interface.
>>
>> As you say, maybe we can remove the locations[i].raw_btf check, just
>> use the btf__parse, It looks more concise.
> 
> Please don't top post, reply inline (that's kernel mail lists rules).
> 
> But yes, I think we can just use btf__parse and let libbpf figure out.
> Please send a patch.
> 

Thank you, i will send the patch in v2.
>>
>> 在 2022/8/26 上午4:26, Andrii Nakryiko 写道:
>>
>> On Wed, Aug 24, 2022 at 7:05 AM chentao.ct
>> <chentao.kernel@linux.alibaba.com> wrote:
>>
>> Now only elf btf can be placed in the default path, raw btf should
>> also can be there.
>>
>> It's not clear what you are trying to achieve. Do you want libbpf to
>> attempt to load /boot/vmlinux-%1$s as raw BTF as well (so you can sort
>> of sneak in pregenerated BTF), or what exactly?
>> btf__load_vmlinux_btf() code already supports loading raw BTF, it just
>> needs to be explicitly specified in locations table.
>>
>> So with your change locations[i].raw_btf check doesn't make sense and
>> we need to clean this up.
>>
>> But first, let's discuss the use case, instead of your specific solution.
>>
>>
>> Signed-off-by: chentao.ct <chentao.kernel@linux.alibaba.com>
>> ---
>>   tools/lib/bpf/btf.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
>> index bb1e06e..b22b5b3 100644
>> --- a/tools/lib/bpf/btf.c
>> +++ b/tools/lib/bpf/btf.c
>> @@ -4661,7 +4661,7 @@ struct btf *btf__load_vmlinux_btf(void)
>>          } locations[] = {
>>                  /* try canonical vmlinux BTF through sysfs first */
>>                  { "/sys/kernel/btf/vmlinux", true /* raw BTF */ },
>> -               /* fall back to trying to find vmlinux ELF on disk otherwise */
>> +               /* fall back to trying to find vmlinux RAW/ELF on disk otherwise */
>>                  { "/boot/vmlinux-%1$s" },
>>                  { "/lib/modules/%1$s/vmlinux-%1$s" },
>>                  { "/lib/modules/%1$s/build/vmlinux" },
>> @@ -4686,7 +4686,7 @@ struct btf *btf__load_vmlinux_btf(void)
>>                  if (locations[i].raw_btf)
>>                          btf = btf__parse_raw(path);
>>                  else
>> -                       btf = btf__parse_elf(path, NULL);
>> +                       btf = btf__parse(path, NULL);
>>                  err = libbpf_get_error(btf);
>>                  pr_debug("loading kernel BTF '%s': %d\n", path, err);
>>                  if (err)
>> --
>> 2.2.1
>>
