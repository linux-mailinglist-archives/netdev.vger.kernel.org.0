Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 156CB56C9E7
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 16:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiGIOSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 10:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiGIOSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 10:18:33 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D68D96;
        Sat,  9 Jul 2022 07:18:29 -0700 (PDT)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LgByr3dNxzkWVs;
        Sat,  9 Jul 2022 22:16:20 +0800 (CST)
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 9 Jul 2022 22:18:26 +0800
Subject: Re: [RFC PATCH bpf-next 0/2] bpf: Introduce ternary search tree for
 string key
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20220331122822.14283-1-houtao1@huawei.com>
 <CAEf4Bzb7keBS8vXgV5JZzwgNGgMV0X3_guQ_m9JW3X6fJBDpPQ@mail.gmail.com>
 <5a990687-b336-6f44-589b-8bd972882beb@huawei.com>
 <CAEf4BzaUmqDUeKBjSQgLNULx=f-3ipK57Y2qEbND0XuuL9aNvw@mail.gmail.com>
 <8b4c1ad2-d6ba-a100-5438-a025ceb7f5e1@huawei.com>
 <CAEf4Bzbfct4G7AjVjbaL8LvSGy0NQWeEjoR1BCfeZzdmYx8Tpw@mail.gmail.com>
 <bcaef485-fca6-a5e3-68da-c895b802b352@huawei.com>
 <CAEf4Bzb5kiTgXwvR5DuTDJJQT=CtWhreyd=Y2eOMM19KTE_4kg@mail.gmail.com>
 <503873ca-b094-961b-0fd6-cf842b39cf84@huawei.com>
 <CAEf4BzY+HRxgW_3=-b5Brp8BrEn4ZrCEb70q5FoNVusBu+VyLA@mail.gmail.com>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <db34696a-cbfe-16e8-6dd5-8174b97dcf1d@huawei.com>
Date:   Sat, 9 Jul 2022 22:18:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzY+HRxgW_3=-b5Brp8BrEn4ZrCEb70q5FoNVusBu+VyLA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 7/6/2022 6:37 AM, Andrii Nakryiko wrote:
> On Wed, Jun 8, 2022 at 2:00 AM Hou Tao <houtao1@huawei.com> wrote:
>> Hi,
>>
>> On 4/27/2022 11:57 AM, Andrii Nakryiko wrote:
>>> On Tue, Apr 26, 2022 at 1:03 AM Hou Tao <houtao1@huawei.com> wrote:
>> snip
>>>>> I'm biased :) But I like the idea of qp-trie as a general purpose
>>>>> ordered and dynamically sized BPF map. It makes no assumption about
>>>>> data being string-like and sharing common prefixes. It can be made to
>>>>> work just as fine with any array of bytes, making it very suitable as
>>>>> a generic lookup table map. Note that upstream implementation does
>>>>> assume zero-terminated strings and no key being a prefix of another
>>>>> key. But all that can be removed. For fixed-length keys this can never
>>>>> happen by construction, for variable-length keys (and we'll be able to
>>>>> support this finally with bpf_dynptr's help very soon), we can record
>>>>> length of the key in each leaf and use that during comparisons.
>>>> Using the trailing zero byte to make sure no key will be a prefix of another is
>>>> simple, but I will check whether or not there is other way to make the bytes
>>>> array key work out. Alexei had suggest me to use the length of key as part of
>>>> key just like bpf_lpm_trie_key does, maybe i can try it first.
>>> Yeah, using key length as part of the key during comparison is what I
>>> meant as well. I didn't mean to aritificially add trailing zero (this
>>> idea doesn't work for arbitrary binary data).
>>>
>>>>> Also note that qp-trie can be internally used by BPF_MAP_TYPE_LPM_TRIE
>>>>> very efficiently and speed it up considerable in the process (and
>>>>> especially to get rid of the global lock).
>>>>>
>>>>> So if you were to invest in a proper full-featured production
>>>>> implementation of a BPF map, I'd start with qp-trie. From available
>>>>> benchmarks it's both faster and more memory efficient than Red-Black
>>>>> trees, which could be an alternative underlying implementation of such
>>>>> ordered and "resizable" map.
>> Recently I tried to add concurrent update and deletion support for qp-trie, and
>> found out that hand-over-hand lock scheme may don't work for qp-trie update. The
>> short explanation is that update procedure needs traverse qp-trie twice and the
>> position tuple got in the first pass may be stale due to concurrent updates
>> occurred in the second pass. The detailed explanation is shown below.
>>
>> To reduce space usage for qp-trie, there is no common prefix saved in branch
>> node, so the update of qp-trie needs to traversing qp-trie to find the most
>> similar key firstly, comparing with it to get a (index, flag,) tuple for the
>> leaf key, then traversing qp-trie again to find the insert position by using the
>> tuple. The problem is that, the position tuple may be stale due to concurrent
>> updates occurred in different branch. Considering the following case:
>>
>> When inserting "aa_bind_mount" and "aa_buffers_lock" concurrently into the
>> following qp-trie. The most similar key for "aa_bind_mount" is leaf X, and for
>> "aa_buffers_lock" it is leaf Y. The calculated index tuple for both new keys are
>> the same: (index=3, flag=2). Assuming "aa_bind_mount" is inserted firstly, so
>> when inserting "aa_buffers_lock", the correct index will be (index=4, flag=1)
>> instead of (index=3, flag=2) and the result will be incorrect.
>>
>> branch: index  1 flags 1 bitmap 0x00088
>> * leaf: a.81577 0
>> * branch: index  4 flags 1 bitmap 0x00180
>> * * branch: index  4 flags 2 bitmap 0x02080
>> * * * leaf: aa_af_perm 1 (leaf X, for aa_bind_mount)
>> * * branch: index  4 flags 2 bitmap 0x00052
>> * * * leaf: aa_apply_modes_to_perms 6
>> * * * leaf: aa_asprint_hashstr 7 (leaf Y, for aa_buffers_lock)
>>
>> In order to get a correct position tuple, the intuitive solution is adding
>> common prefix in branch node and letting update procedure to find the insertion
>> position by comparing with the prefix, so it only needs to traverse qp-trie once
>> and hand-over-hand locking scheme can work. I plan to work on qp-trie with
>> common prefix and will update its memory usage and concurrent update/insert
>> speed in this thread once the demo is ready.  So any more suggestions ?
>>
> Yeah, that sucks. I'm not sure I completely understand the common prefix
> solution and whether it will still be qp-trie after that, but if you try that,
> it would be interesting to learn about the results you get!
The code for bpf-qp-trie is mostly ready, and will show some benchmark numbers
for prefixed qp-trie and 256-locks qp-trie.

For the common prefix solution, the branch node will save the common prefix for
its children node just like the following diagram shows:

     branch node A (prefix: a)
            |
            |
   *--------*--------*
   |                 |
leaf X (ab)          |
                 branch node (prefix: d)
              *------*--------*
              |               |
         leaf Y (adc)     leaf Z (admin)

The newly-add prefix is only used by update procedure and is updated by both
update and delete procedure due to the prefix splitting and merging. After
adding the common prefix, the hand-over-hand lock scheme works, but the memory
usage is bad compared with 256-lock qp-trie and hash table. For the strings in
BTF, memory usage of qp-trie with prefix is bigger than hash table as shown below.

* Notation (All below tests are conducted by creating and manipulating bpf maps
in kernel through libbpf)

tree-lock: prefixed qp-trie uses hand-over-hand lock scheme
256-lock: qp-trie ues 256 global locks for 256 sub-trees
htab: hashtab

data set                | kallsyms | btf      | knl      | top_1m   |
tree-lock memory  (MB)  | 32.6     | 20.5     | 15.4     | 158.1    |
256-lock memory   (MB)  | 19.1     | 12.0     | 9.9      | 90.6     |
htab memory       (MB)  | 36.7     | 17.1     | 16.2     | 206.8    |

The lookup performance of prefixed qp-trie is nearly the same with 256-lock
qp-trie, but is still bad then 256-lock qp-trie when thread number is 1 or 2.
From the below table, it seems lookup procedure don't scale very well, because
there are not too much differences between the result of number thread 6 and 8.
After a quick perf report, it seems the overhead comes from copy_to_user() and
fget().

* all unique symbols in /proc/kallsyms
        thread number                   | 1      | 2      | 3      | 4      |
5      | 6      | 7      | 8      |
        tree-lock lookup time    (ms)   | 144.8  | 92.5   | 71.7   | 59.9   |
52.9   | 49.1   | 45.8   | 44.3   |
        256-lock lookup time     (ms)   | 136.7  | 91.1   | 69.9   | 58.1   |
51.5   | 47.6   | 44.9   | 44.3   |
        htab lookup time         (ms)   | 118.8  | 81.7   | 59.9   | 47.2   |
44.0   | 41.7   | 40.3   | 40.9   |

* all strings in BTF string area
        thread number                   | 1      | 2      | 3      | 4      |
5      | 6      | 7      | 8      |
        tree-lock lookup time    (ms)   | 109.7  | 71.7   | 54.4   | 44.2   |
38.6   | 34.7   | 33.6   | 32.1   |
        256-lock lookup time     (ms)   | 101.3  | 69.0   | 51.5   | 41.2   |
36.0   | 32.8   | 32.3   | 30.4   |
        htab lookup time         (ms)   | 83.2   | 59.3   | 42.7   | 30.7   |
28.7   | 27.8   | 27.4   | 31.7   |

* all files under Linux kernel without prefix generated by find
        thread number                   | 1      | 2      | 3      | 4      |
5      | 6      | 7      | 8      |
        tree-lock lookup time    (ms)   | 73.8   | 47.7   | 36.7   | 29.9   |
26.5   | 22.9   | 20.9   | 20.4   |
        256-lock lookup time     (ms)   | 67.9   | 39.0   | 36.2   | 28.1   |
23.1   | 21.4   | 19.6   | 20.1   |
        htab lookup time         (ms)   | 53.9   | 39.0   | 33.2   | 25.8   |
21.1   | 21.9   | 20.9   | 20.5   |

* domain name for the top 1-million sites
        thread number                   | 1      | 2      | 3      | 4      |
5      | 6      | 7      | 8      |
        tree-lock lookup time    (ms)   | 1032.6 | 660.8  | 473.8  | 383.0  |
333.4  | 293.2  | 259.0  | 241.2  |
        256-lock lookup time     (ms)   | 972.1  | 607.3  | 435.6  | 348.7  |
298.0  | 264.8  | 240.5  | 222.5  |
        htab lookup time         (ms)   | 590.6  | 435.2  | 341.2  | 268.4  |
229.2  | 206.0  | 197.9  | 194.8  |

For update procedure, performance of hand-over-hand lock will be much better
than 256-locks when number of threads is greater than 4. But it doesn't have too
much win against 256-locks for delete procedure. The main reason may be now
3-locks are taken for delete procedure (2 locks for update procedure) because
now qp_trie_node instead of its pointer is saved in qp trie twigs and it can
improve the lookup performance by ~30% by decreasing one pointer de-reference.

* all unique symbols in /proc/kallsyms
        thread number               | 1      | 2      | 3      | 4      | 5     
| 6      | 7      | 8      |
        tree-lock update time (ms)  | 305.4  | 243.2  | 199.9  | 189.6  | 188.1 
| 191.5  | 185.5  | 191.2  |
        256-lock update time  (ms)  | 251.6  | 209.7  | 202.6  | 202.2  | 216.5 
| 250.0  | 209.8  | 236.2  |
        htab update time      (ms)  | 173.6  | 124.1  | 95.3   | 96.9   | 84.8  
| 78.2   | 75.8   | 74.4   |
        tree-lock delete time (ms)  | 267.4  | 231.1  | 199.7  | 194.8  | 189.4 
| 190.0  | 190.6  | 191.0  |
        256-lock delete time  (ms)  | 209.2  | 161.8  | 166.0  | 164.2  | 162.1 
| 161.8  | 160.7  | 163.3  |
        htab delete time      (ms)  | 114.7  | 84.3   | 65.9   | 56.9   | 53.7  
| 52.4   | 52.5   | 53.6   |

* all strings in BTF string area
        thread number               | 1      | 2      | 3      | 4      | 5     
| 6      | 7      | 8      |
        tree-lock update time (ms)  | 215.9  | 184.1  | 146.7  | 127.6  | 93.3  
| 86.9   | 81.3   | 77.9   |
        256-lock update time  (ms)  | 173.7  | 130.9  | 116.4  | 107.9  | 101.3 
| 98.1   | 95.7   | 91.6   |
        htab update time      (ms)  | 113.1  | 84.5   | 76.8   | 63.3   | 55.1  
| 45.5   | 40.7   | 40.5   |
        tree-lock delete time (ms)  | 187.5  | 144.2  | 116.8  | 106.6  | 111.3 
| 90.1   | 83.5   | 82.0   |
        256-lock delete time  (ms)  | 148.4  | 117.2  | 120.5  | 104.8  | 94.3  
| 88.7   | 95.3   | 90.8   |
        htab delete time      (ms)  | 84.1   | 73.3   | 47.8   | 41.2   | 40.0  
| 37.3   | 37.8   | 38.0   |

* all files under Linux kernel without prefix generated by find
        thread number               | 1      | 2      | 3      | 4      | 5     
| 6      | 7      | 8      |
        tree-lock update time (ms)  | 143.1  | 112.1  | 87.9   | 94.8   | 91.4  
| 89.7   | 87.9   | 86.9   |
        256-lock update time  (ms)  | 121.8  | 113.2  | 117.9  | 117.6  | 118.3 
| 120.7  | 119.8  | 120.5  |
        htab update time      (ms)  | 85.4   | 66.7   | 52.9   | 44.6   | 39.2  
| 37.8   | 36.1   | 34.8   |
        tree-lock delete time (ms)  | 126.1  | 110.1  | 86.4   | 77.7   | 74.4  
| 81.8   | 88.3   | 91.7   |
        256-lock delete time  (ms)  | 100.0  | 88.7   | 95.9   | 93.5   | 77.1  
| 88.1   | 76.7   | 85.5   |
        htab delete time      (ms)  | 59.0   | 50.0   | 31.7   | 32.5   | 31.4  
| 31.1   | 27.1   | 29.6   |

* domain name for the top sites
        thread number               | 1      | 2      | 3      | 4      | 5     
| 6      | 7      | 8      |
        tree-lock update time (ms)  | 1890.2 | 1289.4 | 949.8  | 790.0  | 677.6 
| 614.2  | 567.6  | 536.2  |
        256-lock update time  (ms)  | 1521.4 | 1173.1 | 1136.2 | 1075.2 | 1059.3
| 1043.6 | 1022.2 | 988.1  |
        htab update time      (ms)  | 896.5  | 618.5  | 474.1  | 396.2  | 357.0 
| 319.3  | 297.1  | 288.2  |
        tree-lock delete time (ms)  | 1856.3 | 1290.1 | 1007.1 | 881.5  | 804.7 
| 755.7  | 725.9  | 700.2  |
        256-lock delete time  (ms)  | 1429.3 | 1066.3 | 1018.1 | 955.2  | 923.4 
| 889.3  | 870.3  | 836.6  |
        htab delete time      (ms)  | 648.8  | 480.8  | 377.6  | 313.7  | 284.1 
| 280.4  | 273.9  | 269.9  |

But if the input data set is inserted or deleted in sorted order, hand-over-hand
lock scheme don't work well as show below:

* all sorted strings in BTF string area

        thread number               | 1      | 2      | 3      | 4      | 5     
| 6      | 7      | 8      |
        tree-lock update time (ms)  | 201.2  | 185.1  | 156.6  | 131.6  | 151.3 
| 134.2  | 144.7  | 130.6  |
        256-lock update time  (ms)  | 162.7  | 132.6  | 135.6  | 136.8  | 138.9 
| 137.8  | 149.4  | 161.0  |
        htab update time      (ms)  | 114.5  | 89.3   | 75.1   | 55.1   | 48.2  
| 52.5   | 53.7   | 52.5   |
        tree-lock delete time (ms)  | 176.7  | 172.1  | 163.7  | 154.3  | 134.1 
| 133.6  | 133.3  | 133.0  |
        256-lock delete time  (ms)  | 139.4  | 128.2  | 138.8  | 131.1  | 112.2 
| 107.1  | 128.8  | 130.9  |
        htab delete time      (ms)  | 81.1   | 67.1   | 44.7   | 38.3   | 37.5  
| 41.1   | 44.3   | 43.3   | 
> I think in the worst case we'll have to do tree-wide lock, perhaps
> maybe having an initial 256-way root node for first byte, and each of
> 256 subtrees could have their own lock.
Yes, I think 256-way root node and 256 locks is not so bad choice for us as we
can see from the test results above. And for prefixed qp-trie its memory usage
is too bad, so I prefer 256 subtree locks for now.
> Alternatively we can do optimistic lockless lookup (in the hope to
> find a match), but if that fails - take tree-wide lock, and perform
> the search and insertion again. This will favor lookup hits,
> obviously, but hopefully that's going to be a common use case where
> keys are mostly matching.
Lockless programming is hard, but I think we can try these optimization after
supporting the basic operations for qp-trie.

Regards,
Tao
>
> WDYT?
>
>
>> Regards,
>> Tao
>>
>>>> Thanks for your suggestions. I will give it a try.
>>> Awesome!
>>>
>>>> Regards,
>>>> Tao
>>>>
>>>>>> Regards,
>>>>>> Tao
>>>>>>>>> This prefix sharing is nice when you have a lot of long common
>>>>>>>>> prefixes, but I'm a bit skeptical that as a general-purpose BPF data
>>>>>>>>> structure it's going to be that beneficial. 192 bytes of common
>>>>>>>>> prefixes seems like a very unusual dataset :)
>>>>>>>> Yes. The case with common prefix I known is full file path.
>>>>>>>>> More specifically about TST implementation in your paches. One global
>>>>>>>>> per-map lock I think is a very big downside. We have LPM trie which is
>>>>>>>>> very slow in big part due to global lock. It might be possible to
>>>>>>>>> design more granular schema for TST, but this whole in-place splitting
>>>>>>>>> logic makes this harder. I think qp-trie can be locked in a granular
>>>>>>>>> fashion much more easily by having a "hand over hand" locking: lock
>>>>>>>>> parent, find child, lock child, unlock parent, move into child node.
>>>>>>>>> Something like that would be more scalable overall, especially if the
>>>>>>>>> access pattern is not focused on a narrow set of nodes.
>>>>>>>> Yes. The global lock is a problem but the splitting is not in-place. I will try
>>>>>>>> to figure out whether the lock can be more scalable after the benchmark test
>>>>>>>> between qp-trie and tst.
>>>>>>> Great, looking forward!
>>>>>>>
>>>>>>>> Regards,
>>>>>>>> Tao
>>>>>>>>
>>>>>>>> [0]: https://github.com/Tessil/hat-trie
>>>>>>>>> Anyways, I love data structures and this one is an interesting idea.
>>>>>>>>> But just my few cents of "production-readiness" for general-purpose
>>>>>>>>> data structures for BPF.
>>>>>>>>>
>>>>>>>>>   [0] https://dotat.at/prog/qp/README.html
>>>>>>>>>
>>>>>>>>>> Regards,
>>>>>>>>>> Tao
>>>>>>>>>>
>>>>>>>>>> [1]: https://lore.kernel.org/bpf/CAADnVQJUJp3YBcpESwR3Q1U6GS1mBM=Vp-qYuQX7eZOaoLjdUA@mail.gmail.com/
>>>>>>>>>>
>>>>>>>>>> Hou Tao (2):
>>>>>>>>>>   bpf: Introduce ternary search tree for string key
>>>>>>>>>>   selftests/bpf: add benchmark for ternary search tree map
>>>>>>>>>>
>>>>>>>>>>  include/linux/bpf_types.h                     |   1 +
>>>>>>>>>>  include/uapi/linux/bpf.h                      |   1 +
>>>>>>>>>>  kernel/bpf/Makefile                           |   1 +
>>>>>>>>>>  kernel/bpf/bpf_tst.c                          | 411 +++++++++++++++++
>>>>>>>>>>  tools/include/uapi/linux/bpf.h                |   1 +
>>>>>>>>>>  tools/testing/selftests/bpf/Makefile          |   5 +-
>>>>>>>>>>  tools/testing/selftests/bpf/bench.c           |   6 +
>>>>>>>>>>  .../selftests/bpf/benchs/bench_tst_map.c      | 415 ++++++++++++++++++
>>>>>>>>>>  .../selftests/bpf/benchs/run_bench_tst.sh     |  54 +++
>>>>>>>>>>  tools/testing/selftests/bpf/progs/tst_bench.c |  70 +++
>>>>>>>>>>  10 files changed, 964 insertions(+), 1 deletion(-)
>>>>>>>>>>  create mode 100644 kernel/bpf/bpf_tst.c
>>>>>>>>>>  create mode 100644 tools/testing/selftests/bpf/benchs/bench_tst_map.c
>>>>>>>>>>  create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_tst.sh
>>>>>>>>>>  create mode 100644 tools/testing/selftests/bpf/progs/tst_bench.c
>>>>>>>>>>
>>>>>>>>>> --
>>>>>>>>>> 2.31.1
>>>>>>>>>>
>>>>>>>>> .
>>>>>>> .
>>>>> .
>>> .
> .

