Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD3DA5FE8FC
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 08:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiJNGjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 02:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiJNGjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 02:39:00 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50EBA17FD45;
        Thu, 13 Oct 2022 23:38:57 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Mpc6y0SD2zmVLG;
        Fri, 14 Oct 2022 14:34:18 +0800 (CST)
Received: from [10.174.179.191] (10.174.179.191) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 14 Oct 2022 14:38:54 +0800
Message-ID: <5691059a-b25b-deac-e813-95efc4725f92@huawei.com>
Date:   Fri, 14 Oct 2022 14:38:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [bpf-next v8 1/3] bpftool: Add autoattach for bpf prog
 load|loadall
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     <quentin@isovalent.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andrii@kernel.org>, <martin.lau@linux.dev>, <song@kernel.org>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <sdf@google.com>, <haoluo@google.com>, <jolsa@kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <hawk@kernel.org>,
        <nathan@kernel.org>, <ndesaulniers@google.com>, <trix@redhat.com>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <llvm@lists.linux.dev>
References: <1665399601-29668-1-git-send-email-wangyufen@huawei.com>
 <1665399601-29668-2-git-send-email-wangyufen@huawei.com>
 <CAEf4BzYzUKUg=V6Bir7s1AKuZF-=HFsjuWBTjTqO8fganjWVDg@mail.gmail.com>
 <fbb13238-d0e2-7b0f-8b7b-e4fb211bcaaf@huawei.com>
 <CAEf4BzaP=H_+1Yf8ou2zzmu=h2FtDQh4wSSMgabBrPr_jK7SjA@mail.gmail.com>
From:   wangyufen <wangyufen@huawei.com>
In-Reply-To: <CAEf4BzaP=H_+1Yf8ou2zzmu=h2FtDQh4wSSMgabBrPr_jK7SjA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.191]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/10/14 11:43, Andrii Nakryiko 写道:
> On Thu, Oct 13, 2022 at 7:24 PM wangyufen <wangyufen@huawei.com> wrote:
>>
>> 在 2022/10/14 3:47, Andrii Nakryiko 写道:
>>> On Mon, Oct 10, 2022 at 3:40 AM Wang Yufen <wangyufen@huawei.com> wrote:
>>>> Add autoattach optional to support one-step load-attach-pin_link.
>>>>
>>>> For example,
>>>>      $ bpftool prog loadall test.o /sys/fs/bpf/test autoattach
>>>>
>>>>      $ bpftool link
>>>>      26: tracing  name test1  tag f0da7d0058c00236  gpl
>>>>           loaded_at 2022-09-09T21:39:49+0800  uid 0
>>>>           xlated 88B  jited 55B  memlock 4096B  map_ids 3
>>>>           btf_id 55
>>>>      28: kprobe  name test3  tag 002ef1bef0723833  gpl
>>>>           loaded_at 2022-09-09T21:39:49+0800  uid 0
>>>>           xlated 88B  jited 56B  memlock 4096B  map_ids 3
>>>>           btf_id 55
>>>>      57: tracepoint  name oncpu  tag 7aa55dfbdcb78941  gpl
>>>>           loaded_at 2022-09-09T21:41:32+0800  uid 0
>>>>           xlated 456B  jited 265B  memlock 4096B  map_ids 17,13,14,15
>>>>           btf_id 82
>>>>
>>>>      $ bpftool link
>>>>      1: tracing  prog 26
>>>>           prog_type tracing  attach_type trace_fentry
>>>>      3: perf_event  prog 28
>>>>      10: perf_event  prog 57
>>>>
>>>> The autoattach optional can support tracepoints, k(ret)probes,
>>>> u(ret)probes.
>>>>
>>>> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
>>>> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
>>>> ---
>>>>    tools/bpf/bpftool/prog.c | 78 ++++++++++++++++++++++++++++++++++++++++++++++--
>>>>    1 file changed, 76 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
>>>> index c81362a..8f3afce 100644
>>>> --- a/tools/bpf/bpftool/prog.c
>>>> +++ b/tools/bpf/bpftool/prog.c
>>>> @@ -1453,6 +1453,69 @@ static int do_run(int argc, char **argv)
>>>>           return ret;
>>>>    }
>>>>
>>>> +static int
>>>> +auto_attach_program(struct bpf_program *prog, const char *path)
>>>> +{
>>>> +       struct bpf_link *link;
>>>> +       int err;
>>>> +
>>>> +       link = bpf_program__attach(prog);
>>>> +       if (!link) {
>>>> +               p_info("Program %s does not support autoattach, falling back to pinning",
>>>> +                      bpf_program__name(prog));
>>>> +               return bpf_obj_pin(bpf_program__fd(prog), path);
>>>> +       }
>>>> +       err = bpf_link__pin(link, path);
>>>> +       if (err) {
>>>> +               bpf_link__destroy(link);
>>>> +               return err;
>>>> +       }
>>> leaking link here, destroy it unconditionally. If pinning succeeded,
>>> you don't need to hold link's FD open anymore.
>> I got it, will change. Thanks！
>>
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +static int pathname_concat(const char *path, const char *name, char *buf)
>>> why you didn't do the same as in libbpf? Pass buffer size explicitly
>>> instead of assuming PATH_MAX
>> The pathname_concat function is invoked only in one place and is not a
>> general function here. So, not modified. Or, can I change the "pathname_concat"
>> of libbpf to "LIBBPF_API int libbpf_pathname_concat" and use the
>> libbpf_pathname_concat directly?
> no need to reuse libbpf's helper, but I do think it's cleaner to
> specify not just buffer pointer, but also it's size, just like you do
> with any other string buffer API (like snprintf)

OK, will change in v9 too. Thanks！

>
>>
>>>> +{
>>>> +       int len;
>>>> +
>>>> +       len = snprintf(buf, PATH_MAX, "%s/%s", path, name);
>>>> +       if (len < 0)
>>>> +               return -EINVAL;
>>>> +       if (len >= PATH_MAX)
>>>> +               return -ENAMETOOLONG;
>>>> +
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +static int
>>>> +auto_attach_programs(struct bpf_object *obj, const char *path)
>>>> +{
>>>> +       struct bpf_program *prog;
>>>> +       char buf[PATH_MAX];
>>>> +       int err;
>>>> +
>>>> +       bpf_object__for_each_program(prog, obj) {
>>>> +               err = pathname_concat(path, bpf_program__name(prog), buf);
>>>> +               if (err)
>>>> +                       goto err_unpin_programs;
>>>> +
>>>> +               err = auto_attach_program(prog, buf);
>>>> +               if (err)
>>>> +                       goto err_unpin_programs;
>>>> +       }
>>>> +
>>>> +       return 0;
>>>> +
>>>> +err_unpin_programs:
>>>> +       while ((prog = bpf_object__prev_program(obj, prog))) {
>>>> +               if (pathname_concat(path, bpf_program__name(prog), buf))
>>>> +                       continue;
>>>> +
>>>> +               bpf_program__unpin(prog, buf);
>>>> +       }
>>>> +
>>>> +       return err;
>>>> +}
>>>> +
>>>>    static int load_with_options(int argc, char **argv, bool first_prog_only)
>>>>    {
>>>>           enum bpf_prog_type common_prog_type = BPF_PROG_TYPE_UNSPEC;
>>>> @@ -1464,6 +1527,7 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
>>>>           struct bpf_program *prog = NULL, *pos;
>>>>           unsigned int old_map_fds = 0;
>>>>           const char *pinmaps = NULL;
>>>> +       bool auto_attach = false;
>>>>           struct bpf_object *obj;
>>>>           struct bpf_map *map;
>>>>           const char *pinfile;
>>>> @@ -1583,6 +1647,9 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
>>>>                                   goto err_free_reuse_maps;
>>>>
>>>>                           pinmaps = GET_ARG();
>>>> +               } else if (is_prefix(*argv, "autoattach")) {
>>>> +                       auto_attach = true;
>>>> +                       NEXT_ARG();
>>>>                   } else {
>>>>                           p_err("expected no more arguments, 'type', 'map' or 'dev', got: '%s'?",
>>>>                                 *argv);
>>>> @@ -1692,14 +1759,20 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
>>>>                           goto err_close_obj;
>>>>                   }
>>>>
>>>> -               err = bpf_obj_pin(bpf_program__fd(prog), pinfile);
>>>> +               if (auto_attach)
>>>> +                       err = auto_attach_program(prog, pinfile);
>>>> +               else
>>>> +                       err = bpf_obj_pin(bpf_program__fd(prog), pinfile);
>>>>                   if (err) {
>>>>                           p_err("failed to pin program %s",
>>>>                                 bpf_program__section_name(prog));
>>>>                           goto err_close_obj;
>>>>                   }
>>>>           } else {
>>>> -               err = bpf_object__pin_programs(obj, pinfile);
>>>> +               if (auto_attach)
>>>> +                       err = auto_attach_programs(obj, pinfile);
>>>> +               else
>>>> +                       err = bpf_object__pin_programs(obj, pinfile);
>>>>                   if (err) {
>>>>                           p_err("failed to pin all programs");
>>>>                           goto err_close_obj;
>>>> @@ -2338,6 +2411,7 @@ static int do_help(int argc, char **argv)
>>>>                   "                         [type TYPE] [dev NAME] \\\n"
>>>>                   "                         [map { idx IDX | name NAME } MAP]\\\n"
>>>>                   "                         [pinmaps MAP_DIR]\n"
>>>> +               "                         [autoattach]\n"
>>>>                   "       %1$s %2$s attach PROG ATTACH_TYPE [MAP]\n"
>>>>                   "       %1$s %2$s detach PROG ATTACH_TYPE [MAP]\n"
>>>>                   "       %1$s %2$s run PROG \\\n"
>>>> --
>>>> 1.8.3.1
>>>>
