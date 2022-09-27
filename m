Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F59B5EC087
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 13:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbiI0LGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 07:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbiI0LFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 07:05:51 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C741B1D306;
        Tue, 27 Sep 2022 04:04:46 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4McGqY0D5Fz1P6vl;
        Tue, 27 Sep 2022 19:00:09 +0800 (CST)
Received: from [10.174.179.191] (10.174.179.191) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 19:04:22 +0800
Message-ID: <d4f9badc-a39d-02f2-192a-3cb07e80bbf7@huawei.com>
Date:   Tue, 27 Sep 2022 19:04:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [bpf-next v6 1/3] bpftool: Add auto_attach for bpf prog
 load|loadall
To:     Quentin Monnet <quentin@isovalent.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <hawk@kernel.org>, <nathan@kernel.org>,
        <ndesaulniers@google.com>, <trix@redhat.com>
CC:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <llvm@lists.linux.dev>
References: <1664014430-5286-1-git-send-email-wangyufen@huawei.com>
 <2f670f3f-4d91-9b74-4fbe-8ea1351444cb@isovalent.com>
From:   wangyufen <wangyufen@huawei.com>
In-Reply-To: <2f670f3f-4d91-9b74-4fbe-8ea1351444cb@isovalent.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.191]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/9/26 18:46, Quentin Monnet 写道:
> Sat Sep 24 2022 11:13:48 GMT+0100 (British Summer Time) ~ Wang Yufen
> <wangyufen@huawei.com>
>> Add auto_attach optional to support one-step load-attach-pin_link.
>>
>> For example,
>>     $ bpftool prog loadall test.o /sys/fs/bpf/test autoattach
>>
>>     $ bpftool link
>>     26: tracing  name test1  tag f0da7d0058c00236  gpl
>>     	loaded_at 2022-09-09T21:39:49+0800  uid 0
>>     	xlated 88B  jited 55B  memlock 4096B  map_ids 3
>>     	btf_id 55
>>     28: kprobe  name test3  tag 002ef1bef0723833  gpl
>>     	loaded_at 2022-09-09T21:39:49+0800  uid 0
>>     	xlated 88B  jited 56B  memlock 4096B  map_ids 3
>>     	btf_id 55
>>     57: tracepoint  name oncpu  tag 7aa55dfbdcb78941  gpl
>>     	loaded_at 2022-09-09T21:41:32+0800  uid 0
>>     	xlated 456B  jited 265B  memlock 4096B  map_ids 17,13,14,15
>>     	btf_id 82
>>
>>     $ bpftool link
>>     1: tracing  prog 26
>>     	prog_type tracing  attach_type trace_fentry
>>     3: perf_event  prog 28
>>     10: perf_event  prog 57
>>
>> The autoattach optional can support tracepoints, k(ret)probes,
>> u(ret)probes.
>>
>> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
>> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
>> ---
>> v5 -> v6: skip the programs not supporting auto-attach,
>> 	  and change optional name from "auto_attach" to "autoattach"
>> v4 -> v5: some formatting nits of doc
>> v3 -> v4: rename functions, update doc, bash and do_help()
>> v2 -> v3: switch to extend prog load command instead of extend perf
>> v2: https://patchwork.kernel.org/project/netdevbpf/patch/20220824033837.458197-1-weiyongjun1@huawei.com/
>> v1: https://patchwork.kernel.org/project/netdevbpf/patch/20220816151725.153343-1-weiyongjun1@huawei.com/
>>   tools/bpf/bpftool/prog.c | 76 ++++++++++++++++++++++++++++++++++++++--
>>   1 file changed, 74 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
>> index c81362a001ba..b1cbd06dee19 100644
>> --- a/tools/bpf/bpftool/prog.c
>> +++ b/tools/bpf/bpftool/prog.c
>> @@ -1453,6 +1453,67 @@ get_prog_type_by_name(const char *name, enum bpf_prog_type *prog_type,
>>   	return ret;
>>   }
>>   
>> +static int
>> +auto_attach_program(struct bpf_program *prog, const char *path)
>> +{
>> +	struct bpf_link *link;
>> +	int err;
>> +
>> +	link = bpf_program__attach(prog);
>> +	if (!link)
>> +		return -1;
>> +
>> +	err = bpf_link__pin(link, path);
>> +	if (err) {
>> +		bpf_link__destroy(link);
>> +		return err;
>> +	}
>> +	return 0;
>> +}
>> +
>> +static int pathname_concat(const char *path, const char *name, char *buf)
>> +{
>> +	int len;
>> +
>> +	len = snprintf(buf, PATH_MAX, "%s/%s", path, name);
>> +	if (len < 0)
>> +		return -EINVAL;
>> +	if (len >= PATH_MAX)
>> +		return -ENAMETOOLONG;
>> +
>> +	return 0;
>> +}
>> +
>> +static int
>> +auto_attach_programs(struct bpf_object *obj, const char *path)
>> +{
>> +	struct bpf_program *prog;
>> +	char buf[PATH_MAX];
>> +	int err;
>> +
>> +	bpf_object__for_each_program(prog, obj) {
>> +		err = pathname_concat(path, bpf_program__name(prog), buf);
>> +		if (err)
>> +			goto err_unpin_programs;
>> +
>> +		err = auto_attach_program(prog, buf);
>> +		if (err && errno != EOPNOTSUPP)
>> +			goto err_unpin_programs;
> If I read the above correctly, we skip entirely programs that couldn't
> be auto-attached. I'm not sure what Andrii had in mind exactly, but it
> would make sense to me to fallback to regular program pinning if the
> program couldn't be attached/linked, so we still keep it loaded in the
> kernel after bpftool exits. Probably with a p_info() message to let
> users know?

Thanks for your comment.
I agree with you.
add in v7.

>
>> +	}
>> +
>> +	return 0;
>> +
>> +err_unpin_programs:
>> +	while ((prog = bpf_object__prev_program(obj, prog))) {
>> +		if (pathname_concat(path, bpf_program__name(prog), buf))
>> +			continue;
>> +
>> +		bpf_program__unpin(prog, buf);
>> +	}
>> +
>> +	return err;
>> +}
