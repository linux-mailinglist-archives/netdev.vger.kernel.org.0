Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4001D63CD07
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 02:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbiK3BuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 20:50:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiK3BuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 20:50:15 -0500
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C776C729;
        Tue, 29 Nov 2022 17:50:11 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.30.67.169])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4NMMbK5lcCz4f3k6L;
        Wed, 30 Nov 2022 09:50:05 +0800 (CST)
Received: from [10.174.176.117] (unknown [10.174.176.117])
        by APP2 (Coremail) with SMTP id Syh0CgAXerXMtoZjR757BQ--.34895S2;
        Wed, 30 Nov 2022 09:50:08 +0800 (CST)
Subject: Re: [net-next] bpf: avoid hashtab deadlock with try_lock
To:     Hao Luo <haoluo@google.com>
Cc:     Waiman Long <longman@redhat.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Jiri Olsa <jolsa@kernel.org>, bpf <bpf@vger.kernel.org>,
        "houtao1@huawei.com" <houtao1@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>
References: <41eda0ea-0ed4-1ffb-5520-06fda08e5d38@huawei.com>
 <CAMDZJNVSv3Msxw=5PRiXyO8bxNsA-4KyxU8BMCVyHxH-3iuq2Q@mail.gmail.com>
 <fdb3b69c-a29c-2d5b-a122-9d98ea387fda@huawei.com>
 <CAMDZJNWTry2eF_n41a13tKFFSSLFyp3BVKakOOWhSDApdp0f=w@mail.gmail.com>
 <CA+khW7jgsyFgBqU7hCzZiSSANE7f=A+M-0XbcKApz6Nr-ZnZDg@mail.gmail.com>
 <07a7491e-f391-a9b2-047e-cab5f23decc5@huawei.com>
 <CAMDZJNUTaiXMe460P7a7NfK1_bbaahpvi3Q9X85o=G7v9x-w=g@mail.gmail.com>
 <59fc54b7-c276-2918-6741-804634337881@huaweicloud.com>
 <541aa740-dcf3-35f5-9f9b-e411978eaa06@redhat.com>
 <Y4ZABpDSs4/uRutC@Boquns-Mac-mini.local>
 <Y4ZCKaQFqDY3aLTy@Boquns-Mac-mini.local>
 <CA+khW7hkQRFcC1QgGxEK_NeaVvCe3Hbe_mZ-_UkQKaBaqnOLEQ@mail.gmail.com>
From:   Hou Tao <houtao@huaweicloud.com>
Message-ID: <23b5de45-1a11-b5c9-d0d3-4dbca0b7661e@huaweicloud.com>
Date:   Wed, 30 Nov 2022 09:50:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CA+khW7hkQRFcC1QgGxEK_NeaVvCe3Hbe_mZ-_UkQKaBaqnOLEQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-CM-TRANSID: Syh0CgAXerXMtoZjR757BQ--.34895S2
X-Coremail-Antispam: 1UD129KBjvJXoW7KFW8ZF47ZF4Dtr4rKr1xKrg_yoW8WF1DpF
        W2g343KF4kZr1UZ3WvvF18tw4rAw12ka1jkrW5Xr1vvr45W343ZFW8K3y8ZFyjqr4fJrs0
        vrsFva48CFZ0vaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvab4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IE
        e2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxV
        Aqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a
        6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6x
        kF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv
        67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyT
        uYvjxUo0eHDUUUU
X-CM-SenderInfo: xkrx3t3r6k3tpzhluzxrxghudrp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hao,

On 11/30/2022 3:36 AM, Hao Luo wrote:
> On Tue, Nov 29, 2022 at 9:32 AM Boqun Feng <boqun.feng@gmail.com> wrote:
>> Just to be clear, I meant to refactor htab_lock_bucket() into a try
>> lock pattern. Also after a second thought, the below suggestion doesn't
>> work. I think the proper way is to make htab_lock_bucket() as a
>> raw_spin_trylock_irqsave().
>>
>> Regards,
>> Boqun
>>
> The potential deadlock happens when the lock is contended from the
> same cpu. When the lock is contended from a remote cpu, we would like
> the remote cpu to spin and wait, instead of giving up immediately. As
> this gives better throughput. So replacing the current
> raw_spin_lock_irqsave() with trylock sacrifices this performance gain.
>
> I suspect the source of the problem is the 'hash' that we used in
> htab_lock_bucket(). The 'hash' is derived from the 'key', I wonder
> whether we should use a hash derived from 'bucket' rather than from
> 'key'. For example, from the memory address of the 'bucket'. Because,
> different keys may fall into the same bucket, but yield different
> hashes. If the same bucket can never have two different 'hashes' here,
> the map_locked check should behave as intended. Also because
> ->map_locked is per-cpu, execution flows from two different cpus can
> both pass.
The warning from lockdep is due to the reason the bucket lock A is used in a
no-NMI context firstly, then the same bucke lock is used a NMI context, so
lockdep deduces that may be a dead-lock. I have already tried to use the same
map_locked for keys with the same bucket, the dead-lock is gone, but still got
lockdep warning.
>
> Hao
> .

