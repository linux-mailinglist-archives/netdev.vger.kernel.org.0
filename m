Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11AB453E37F
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 10:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiFFGMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 02:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiFFGMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 02:12:34 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2768BAE7A
        for <netdev@vger.kernel.org>; Sun,  5 Jun 2022 23:12:30 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 123so1756664pgb.5
        for <netdev@vger.kernel.org>; Sun, 05 Jun 2022 23:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=I35U8IHwcGdbtuU8lL8a+fUizJTm97HsipGrlcfOkcs=;
        b=lR6RkHqNoa9D3MbxwZhoP83tgZYi189zO6RSTfCijp++GA+cLfIHdYsxxYEDk1M4nv
         1kH22kDUrdwheC7fuwd3dlo0/2a4kM7uqlk3SunaapMQqOn5y2cXAlEprryEpJsb9pp9
         Ov9iDcyZRNFpepV7UOnBbo3rTKe9aVjJ2uCu97M+cJysi+PJdS9TL7OZ/gY+Kqk6c/ov
         sx8bsqkWWZHCNX3jpxxzTScYeT+uAYa+UWwSKLfhqG2tdWI7uBqxTi70oR9Uk54PFCGx
         yspBpPWPzZW0tZy/pbm90YXKah9JqQLj+I6H0j1bOqUoVCdVSnsAC6hSk8WAX9y2ocQC
         U03A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=I35U8IHwcGdbtuU8lL8a+fUizJTm97HsipGrlcfOkcs=;
        b=Js0tGUAdbg3rqp6TWFNh+vc2tGarACHwwL+3Zp0KN+f0HlYAMTGtlvqp3g8Zbwr9JC
         i501k6odwzBCzGl8mRP2fEezqgQm3UTx0dbpVlRrgfASeWu/BYjA+dunTDtzB0Yp6Scv
         d7PMna6B2EEYS99RHsif9MhS0Ywcm/HWFLnqYi0QnGZMcxL3r+WtXJmFZyi8Y9pK3zrD
         t8v/aBk5Ei4dv8PbwE2dd/ixGBfui9oB3jgQEXUofZQjkAPFw4qM4wPVtpJJqCJVBpma
         AYFZYRff9JeFWRd+XaE6Xaj6bncqRZhZwWzGMptNCeYQz95usiHk3NjVdTgNWdmnlFWV
         Yttw==
X-Gm-Message-State: AOAM531dRF1VGHF2SHtsfirvYGXuqv3qGzAODJPAqRbg5am2OpY6xDG4
        cqd0H5x0vG5B1F4qYf0KhXI9mw==
X-Google-Smtp-Source: ABdhPJz5RmLQYLqzuaZtAtT5+rSs0hJtCHFTxV0RlOEQoCDagqY2ps+e6cljdFJVm+i2yZCctyltIg==
X-Received: by 2002:aa7:85d1:0:b0:51b:f4b5:db7b with SMTP id z17-20020aa785d1000000b0051bf4b5db7bmr10688026pfn.41.1654495949649;
        Sun, 05 Jun 2022 23:12:29 -0700 (PDT)
Received: from [10.71.57.194] ([139.177.225.241])
        by smtp.gmail.com with ESMTPSA id u188-20020a6279c5000000b0050dc76281aasm9887525pfc.132.2022.06.05.23.12.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jun 2022 23:12:29 -0700 (PDT)
Message-ID: <e0baaba8-9e7a-fc4e-c05b-56d552905127@bytedance.com>
Date:   Mon, 6 Jun 2022 14:12:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: Re: [PATCH v4 1/2] bpf: avoid grabbing spin_locks of all cpus
 when no free elems
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Chengming Zhou <zhouchengming@bytedance.com>
References: <20220601084149.13097-1-zhoufeng.zf@bytedance.com>
 <20220601084149.13097-2-zhoufeng.zf@bytedance.com>
 <CAADnVQJcbDXtQsYNn=j0NzKx3SFSPE1YTwbmtkxkpzmFt-zh9Q@mail.gmail.com>
 <21ec90e3-2e89-09c1-fd22-de76e6794d68@bytedance.com>
 <CAADnVQKdU-3uBE9tKifChUunmr=c=32M4GwP8qG1-S=Atf7fvw@mail.gmail.com>
From:   Feng Zhou <zhoufeng.zf@bytedance.com>
In-Reply-To: <CAADnVQKdU-3uBE9tKifChUunmr=c=32M4GwP8qG1-S=Atf7fvw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2022/6/1 下午7:35, Alexei Starovoitov 写道:
> On Wed, Jun 1, 2022 at 1:11 PM Feng Zhou <zhoufeng.zf@bytedance.com> wrote:
>> 在 2022/6/1 下午5:50, Alexei Starovoitov 写道:
>>> On Wed, Jun 1, 2022 at 10:42 AM Feng zhou <zhoufeng.zf@bytedance.com> wrote:
>>>>    static inline void ___pcpu_freelist_push(struct pcpu_freelist_head *head,
>>>> @@ -130,14 +134,19 @@ static struct pcpu_freelist_node *___pcpu_freelist_pop(struct pcpu_freelist *s)
>>>>           orig_cpu = cpu = raw_smp_processor_id();
>>>>           while (1) {
>>>>                   head = per_cpu_ptr(s->freelist, cpu);
>>>> +               if (READ_ONCE(head->is_empty))
>>>> +                       goto next_cpu;
>>>>                   raw_spin_lock(&head->lock);
>>>>                   node = head->first;
>>>>                   if (node) {
>>> extra bool is unnecessary.
>>> just READ_ONCE(head->first)
>> As for why to add is_empty instead of directly judging head->first, my
>> understanding is this, head->first is frequently modified during updating
>> map, which will lead to invalid other cpus's cache, and is_empty is after
>> freelist having no free elems will be changed, the performance will be
>> better.
> maybe. pls benchmark it.
> imo wasting a bool for the corner case is not a good trade off.

before patch
./map_perf_test 1
35:hash_map_perf pre-alloc 1224983 events per sec
38:hash_map_perf pre-alloc 1113232 events per sec
27:hash_map_perf pre-alloc 1097989 events per sec
19:hash_map_perf pre-alloc 1092061 events per sec
21:hash_map_perf pre-alloc 1084639 events per sec
29:hash_map_perf pre-alloc 1077162 events per sec
4:hash_map_perf pre-alloc 1067511 events per sec
9:hash_map_perf pre-alloc 1063166 events per sec
33:hash_map_perf pre-alloc 1064487 events per sec
8:hash_map_perf pre-alloc 1059271 events per sec
32:hash_map_perf pre-alloc 1061351 events per sec
1:hash_map_perf pre-alloc 1055527 events per sec
15:hash_map_perf pre-alloc 1056587 events per sec
2:hash_map_perf pre-alloc 1054106 events per sec
13:hash_map_perf pre-alloc 1053028 events per sec
25:hash_map_perf pre-alloc 1053575 events per sec
26:hash_map_perf pre-alloc 1052503 events per sec
7:hash_map_perf pre-alloc 1049950 events per sec
39:hash_map_perf pre-alloc 1054421 events per sec
28:hash_map_perf pre-alloc 1050109 events per sec
6:hash_map_perf pre-alloc 1046496 events per sec
44:hash_map_perf pre-alloc 1054757 events per sec
34:hash_map_perf pre-alloc 1048549 events per sec
31:hash_map_perf pre-alloc 1047911 events per sec
18:hash_map_perf pre-alloc 1046435 events per sec
41:hash_map_perf pre-alloc 1051626 events per sec
0:hash_map_perf pre-alloc 1043397 events per sec
10:hash_map_perf pre-alloc 1043903 events per sec
20:hash_map_perf pre-alloc 1044380 events per sec
24:hash_map_perf pre-alloc 1042957 events per sec
47:hash_map_perf pre-alloc 1049337 events per sec
17:hash_map_perf pre-alloc 1038108 events per sec
42:hash_map_perf pre-alloc 1044159 events per sec
45:hash_map_perf pre-alloc 1044698 events per sec
37:hash_map_perf pre-alloc 1038156 events per sec
46:hash_map_perf pre-alloc 1039755 events per sec
22:hash_map_perf pre-alloc 1032287 events per sec
14:hash_map_perf pre-alloc 1019353 events per sec
30:hash_map_perf pre-alloc 1019358 events per sec
43:hash_map_perf pre-alloc 1015956 events per sec
36:hash_map_perf pre-alloc 997864 events per sec
40:hash_map_perf pre-alloc 972771 events per sec
12:hash_map_perf pre-alloc 891118 events per sec
16:hash_map_perf pre-alloc 882166 events per sec
23:hash_map_perf pre-alloc 882177 events per sec
11:hash_map_perf pre-alloc 880153 events per sec
3:hash_map_perf pre-alloc 843192 events per sec
5:hash_map_perf pre-alloc 826944 events per sec

./run_bench_bpf_hashmap_full_update.sh
Setting up benchmark 'bpf-hashmap-ful-update'...
Benchmark 'bpf-hashmap-ful-update' started.
1:hash_map_full_perf 15687 events per sec
2:hash_map_full_perf 15760 events per sec
3:hash_map_full_perf 15699 events per sec
4:hash_map_full_perf 15732 events per sec
5:hash_map_full_perf 15633 events per sec
6:hash_map_full_perf 15623 events per sec
7:hash_map_full_perf 15678 events per sec
8:hash_map_full_perf 15661 events per sec
9:hash_map_full_perf 15659 events per sec
10:hash_map_full_perf 15653 events per sec
11:hash_map_full_perf 15632 events per sec
12:hash_map_full_perf 16059 events per sec
13:hash_map_full_perf 16055 events per sec
14:hash_map_full_perf 16093 events per sec
15:hash_map_full_perf 16053 events per sec
16:hash_map_full_perf 16096 events per sec
17:hash_map_full_perf 15977 events per sec
18:hash_map_full_perf 15986 events per sec
19:hash_map_full_perf 16109 events per sec
20:hash_map_full_perf 16025 events per sec
21:hash_map_full_perf 16052 events per sec
22:hash_map_full_perf 16023 events per sec
23:hash_map_full_perf 16008 events per sec
24:hash_map_full_perf 16484 events per sec
25:hash_map_full_perf 15684 events per sec
26:hash_map_full_perf 15749 events per sec
27:hash_map_full_perf 15677 events per sec
28:hash_map_full_perf 15699 events per sec
29:hash_map_full_perf 15630 events per sec
30:hash_map_full_perf 15603 events per sec
31:hash_map_full_perf 15664 events per sec
32:hash_map_full_perf 15645 events per sec
33:hash_map_full_perf 15682 events per sec
34:hash_map_full_perf 15636 events per sec
35:hash_map_full_perf 15628 events per sec
36:hash_map_full_perf 16068 events per sec
37:hash_map_full_perf 16056 events per sec
38:hash_map_full_perf 16105 events per sec
39:hash_map_full_perf 16077 events per sec
40:hash_map_full_perf 16060 events per sec
41:hash_map_full_perf 15986 events per sec
42:hash_map_full_perf 15962 events per sec
43:hash_map_full_perf 16074 events per sec
44:hash_map_full_perf 16040 events per sec
45:hash_map_full_perf 16035 events per sec
46:hash_map_full_perf 16017 events per sec
47:hash_map_full_perf 15957 events per sec

after patch, use head->is_empty
./map_perf_test 1
6:hash_map_perf pre-alloc 1126051 events per sec
34:hash_map_perf pre-alloc 1122413 events per sec
42:hash_map_perf pre-alloc 1088827 events per sec
39:hash_map_perf pre-alloc 1089041 events per sec
2:hash_map_perf pre-alloc 1062943 events per sec
33:hash_map_perf pre-alloc 1065414 events per sec
4:hash_map_perf pre-alloc 1057170 events per sec
3:hash_map_perf pre-alloc 1056752 events per sec
7:hash_map_perf pre-alloc 1055573 events per sec
1:hash_map_perf pre-alloc 1054998 events per sec
27:hash_map_perf pre-alloc 1056539 events per sec
28:hash_map_perf pre-alloc 1055846 events per sec
14:hash_map_perf pre-alloc 1053706 events per sec
25:hash_map_perf pre-alloc 1054690 events per sec
31:hash_map_perf pre-alloc 1055151 events per sec
13:hash_map_perf pre-alloc 1050262 events per sec
38:hash_map_perf pre-alloc 1051390 events per sec
37:hash_map_perf pre-alloc 1050348 events per sec
44:hash_map_perf pre-alloc 1049442 events per sec
45:hash_map_perf pre-alloc 1049346 events per sec
5:hash_map_perf pre-alloc 1041591 events per sec
16:hash_map_perf pre-alloc 1041668 events per sec
22:hash_map_perf pre-alloc 1041963 events per sec
23:hash_map_perf pre-alloc 1040848 events per sec
11:hash_map_perf pre-alloc 1038474 events per sec
0:hash_map_perf pre-alloc 1037474 events per sec
29:hash_map_perf pre-alloc 1040162 events per sec
12:hash_map_perf pre-alloc 1038138 events per sec
24:hash_map_perf pre-alloc 1036339 events per sec
36:hash_map_perf pre-alloc 1036703 events per sec
35:hash_map_perf pre-alloc 1035780 events per sec
46:hash_map_perf pre-alloc 1035651 events per sec
47:hash_map_perf pre-alloc 1031633 events per sec
26:hash_map_perf pre-alloc 1022568 events per sec
9:hash_map_perf pre-alloc 1020232 events per sec
21:hash_map_perf pre-alloc 1012416 events per sec
20:hash_map_perf pre-alloc 1010835 events per sec
15:hash_map_perf pre-alloc 998342 events per sec
17:hash_map_perf pre-alloc 994979 events per sec
43:hash_map_perf pre-alloc 995927 events per sec
30:hash_map_perf pre-alloc 890710 events per sec
10:hash_map_perf pre-alloc 886156 events per sec
40:hash_map_perf pre-alloc 835611 events per sec
18:hash_map_perf pre-alloc 826670 events per sec
8:hash_map_perf pre-alloc 784346 events per sec
41:hash_map_perf pre-alloc 781841 events per sec
32:hash_map_perf pre-alloc 775770 events per sec
19:hash_map_perf pre-alloc 774079 events per sec

./run_bench_bpf_hashmap_full_update.sh
Setting up benchmark 'bpf-hashmap-ful-update'...
Benchmark 'bpf-hashmap-ful-update' started.
1:hash_map_full_perf 607964 events per sec
2:hash_map_full_perf 580060 events per sec
3:hash_map_full_perf 617285 events per sec
4:hash_map_full_perf 647106 events per sec
5:hash_map_full_perf 578899 events per sec
6:hash_map_full_perf 620514 events per sec
7:hash_map_full_perf 601275 events per sec
8:hash_map_full_perf 638629 events per sec
9:hash_map_full_perf 587900 events per sec
10:hash_map_full_perf 574542 events per sec
11:hash_map_full_perf 575143 events per sec
12:hash_map_full_perf 594191 events per sec
13:hash_map_full_perf 587638 events per sec
14:hash_map_full_perf 543425 events per sec
15:hash_map_full_perf 566564 events per sec
16:hash_map_full_perf 603950 events per sec
17:hash_map_full_perf 567153 events per sec
18:hash_map_full_perf 604260 events per sec
19:hash_map_full_perf 581898 events per sec
20:hash_map_full_perf 569864 events per sec
21:hash_map_full_perf 307428 events per sec
22:hash_map_full_perf 621568 events per sec
23:hash_map_full_perf 568043 events per sec
24:hash_map_full_perf 714765 events per sec
25:hash_map_full_perf 613165 events per sec
26:hash_map_full_perf 647286 events per sec
27:hash_map_full_perf 610911 events per sec
28:hash_map_full_perf 590805 events per sec
29:hash_map_full_perf 621013 events per sec
30:hash_map_full_perf 614053 events per sec
31:hash_map_full_perf 618858 events per sec
32:hash_map_full_perf 593847 events per sec
33:hash_map_full_perf 648223 events per sec
34:hash_map_full_perf 649868 events per sec
35:hash_map_full_perf 657349 events per sec
36:hash_map_full_perf 595112 events per sec
37:hash_map_full_perf 595443 events per sec
38:hash_map_full_perf 557591 events per sec
39:hash_map_full_perf 591079 events per sec
40:hash_map_full_perf 558251 events per sec
41:hash_map_full_perf 572870 events per sec
42:hash_map_full_perf 567184 events per sec
43:hash_map_full_perf 604783 events per sec
44:hash_map_full_perf 632444 events per sec
45:hash_map_full_perf 307268 events per sec
46:hash_map_full_perf 566827 events per sec
47:hash_map_full_perf 626162 events per sec

after patch, use head->first
./map_perf_test 1
45:hash_map_perf pre-alloc 1263804 events per sec
4:hash_map_perf pre-alloc 1234841 events per sec
6:hash_map_perf pre-alloc 1231915 events per sec
11:hash_map_perf pre-alloc 1206927 events per sec
20:hash_map_perf pre-alloc 1179066 events per sec
32:hash_map_perf pre-alloc 1177190 events per sec
23:hash_map_perf pre-alloc 1170498 events per sec
12:hash_map_perf pre-alloc 1140194 events per sec
37:hash_map_perf pre-alloc 1136824 events per sec
9:hash_map_perf pre-alloc 1118735 events per sec
39:hash_map_perf pre-alloc 1113166 events per sec
3:hash_map_perf pre-alloc 1096464 events per sec
19:hash_map_perf pre-alloc 1084696 events per sec
43:hash_map_perf pre-alloc 1087715 events per sec
14:hash_map_perf pre-alloc 1074943 events per sec
38:hash_map_perf pre-alloc 1073905 events per sec
2:hash_map_perf pre-alloc 1067794 events per sec
17:hash_map_perf pre-alloc 1067320 events per sec
26:hash_map_perf pre-alloc 1067185 events per sec
41:hash_map_perf pre-alloc 1066780 events per sec
15:hash_map_perf pre-alloc 1057620 events per sec
0:hash_map_perf pre-alloc 1053298 events per sec
10:hash_map_perf pre-alloc 1053699 events per sec
24:hash_map_perf pre-alloc 1053075 events per sec
34:hash_map_perf pre-alloc 1053347 events per sec
18:hash_map_perf pre-alloc 1050559 events per sec
42:hash_map_perf pre-alloc 1050033 events per sec
33:hash_map_perf pre-alloc 1025317 events per sec
29:hash_map_perf pre-alloc 1000465 events per sec
28:hash_map_perf pre-alloc 975533 events per sec
35:hash_map_perf pre-alloc 974307 events per sec
44:hash_map_perf pre-alloc 966598 events per sec
27:hash_map_perf pre-alloc 962746 events per sec
36:hash_map_perf pre-alloc 945986 events per sec
22:hash_map_perf pre-alloc 914717 events per sec
13:hash_map_perf pre-alloc 901797 events per sec
30:hash_map_perf pre-alloc 849463 events per sec
5:hash_map_perf pre-alloc 842851 events per sec
16:hash_map_perf pre-alloc 814149 events per sec
1:hash_map_perf pre-alloc 798610 events per sec
46:hash_map_perf pre-alloc 793487 events per sec
40:hash_map_perf pre-alloc 772092 events per sec
7:hash_map_perf pre-alloc 742190 events per sec
21:hash_map_perf pre-alloc 714585 events per sec
8:hash_map_perf pre-alloc 702297 events per sec
31:hash_map_perf pre-alloc 700180 events per sec
47:hash_map_perf pre-alloc 686786 events per sec
25:hash_map_perf pre-alloc 655706 events per sec

./run_bench_bpf_hashmap_full_update.sh
Setting up benchmark 'bpf-hashmap-ful-update'...
Benchmark 'bpf-hashmap-ful-update' started.
1:hash_map_full_perf 555830 events per sec
2:hash_map_full_perf 591009 events per sec
3:hash_map_full_perf 585934 events per sec
4:hash_map_full_perf 573066 events per sec
5:hash_map_full_perf 586800 events per sec
6:hash_map_full_perf 587997 events per sec
7:hash_map_full_perf 610463 events per sec
8:hash_map_full_perf 560239 events per sec
9:hash_map_full_perf 612683 events per sec
10:hash_map_full_perf 617636 events per sec
11:hash_map_full_perf 558120 events per sec
12:hash_map_full_perf 505507 events per sec
13:hash_map_full_perf 509096 events per sec
14:hash_map_full_perf 500372 events per sec
15:hash_map_full_perf 495395 events per sec
16:hash_map_full_perf 510147 events per sec
17:hash_map_full_perf 511348 events per sec
18:hash_map_full_perf 523750 events per sec
19:hash_map_full_perf 508013 events per sec
20:hash_map_full_perf 528064 events per sec
21:hash_map_full_perf 543195 events per sec
22:hash_map_full_perf 541737 events per sec
23:hash_map_full_perf 528646 events per sec
24:hash_map_full_perf 683963 events per sec
25:hash_map_full_perf 598496 events per sec
26:hash_map_full_perf 528436 events per sec
27:hash_map_full_perf 576641 events per sec
28:hash_map_full_perf 599424 events per sec
29:hash_map_full_perf 575479 events per sec
30:hash_map_full_perf 580070 events per sec
31:hash_map_full_perf 563594 events per sec
32:hash_map_full_perf 601996 events per sec
33:hash_map_full_perf 548413 events per sec
34:hash_map_full_perf 551068 events per sec
35:hash_map_full_perf 605726 events per sec
36:hash_map_full_perf 505460 events per sec
37:hash_map_full_perf 519113 events per sec
38:hash_map_full_perf 547602 events per sec
39:hash_map_full_perf 547053 events per sec
40:hash_map_full_perf 516993 events per sec
41:hash_map_full_perf 506970 events per sec
42:hash_map_full_perf 500630 events per sec
43:hash_map_full_perf 553099 events per sec
44:hash_map_full_perf 528657 events per sec
45:hash_map_full_perf 517173 events per sec
46:hash_map_full_perf 503649 events per sec
47:hash_map_full_perf 527035 events per sec

 From the point of view of normal performance test, using head->first 
and head->is_empty, compared
with before patch, there is not much performance drop. In the worst 
case, the comparison between
head->first and head->is_empty is not much different as a whole.

