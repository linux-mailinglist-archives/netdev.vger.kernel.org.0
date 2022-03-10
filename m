Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 156664D3FD4
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 04:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239306AbiCJDtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 22:49:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbiCJDtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 22:49:50 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D3D12A761;
        Wed,  9 Mar 2022 19:48:49 -0800 (PST)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KDZkL4Q8wzBrg3;
        Thu, 10 Mar 2022 11:46:50 +0800 (CST)
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Mar 2022 11:48:46 +0800
Subject: Re: [PATCH bpf-next 3/4] bpf: Fix net.core.bpf_jit_harden race
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
References: <20220309123321.2400262-1-houtao1@huawei.com>
 <20220309123321.2400262-4-houtao1@huawei.com>
 <20220309232253.v6oqev7jock7vm7i@ast-mbp.dhcp.thefacebook.com>
 <06abdc4e-8806-10dd-c753-229d3e957add@huawei.com>
 <CAADnVQKr12ZRLroU85YC2GvA+WQoFm0On-5yaLE43hy4p8PRJw@mail.gmail.com>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <60bfb6b5-5d2e-cfc2-cc68-2e016ed06918@huawei.com>
Date:   Thu, 10 Mar 2022 11:48:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CAADnVQKr12ZRLroU85YC2GvA+WQoFm0On-5yaLE43hy4p8PRJw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 3/10/2022 11:29 AM, Alexei Starovoitov wrote:
> On Wed, Mar 9, 2022 at 5:01 PM Hou Tao <houtao1@huawei.com> wrote:
>> Hi,
>>
>> On 3/10/2022 7:22 AM, Alexei Starovoitov wrote:
>>> On Wed, Mar 09, 2022 at 08:33:20PM +0800, Hou Tao wrote:
>>>> It is the bpf_jit_harden counterpart to commit 60b58afc96c9 ("bpf: fix
>>>> net.core.bpf_jit_enable race"). bpf_jit_harden will be tested twice
>>>> for each subprog if there are subprogs in bpf program and constant
>>>> blinding may increase the length of program, so when running
>>>> "./test_progs -t subprogs" and toggling bpf_jit_harden between 0 and 2,
>>>> jit_subprogs may fail because constant blinding increases the length
>>>> of subprog instructions during extra passs.
>>>>
>>>> So cache the value of bpf_jit_blinding_enabled() during program
>>>> allocation, and use the cached value during constant blinding, subprog
>>>> JITing and args tracking of tail call.
>>> Looks like this patch alone is enough.
>>> With race fixed. Patches 1 and 2 are no longer necessary, right?
>> Yes and no. With patch 3 applied, the problems described in patch 1 and patch 2
>> are gone, but it may recur due to other issue in JIT. So I post these two patch
>> together and hope these fixes can also be merged.
> What kind of 'issues in JIT'?
> I'd rather fix them than do defensive programming.
Understand. For "issues in JIT" I just mean all kinds of error path handling in
jit, not a real problem.
> patch 2 is a hack that should not happen in a correct JIT.
> .
And "the hack" is partially due to the introduction of an extra pass in JIT. So
I am fine to drop it.

Regards,
Tao


