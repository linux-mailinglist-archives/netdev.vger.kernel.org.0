Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0D9B4D3E87
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 02:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234946AbiCJBCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 20:02:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiCJBCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 20:02:48 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B832911B5DE;
        Wed,  9 Mar 2022 17:01:48 -0800 (PST)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KDW2J16PdzdZk3;
        Thu, 10 Mar 2022 09:00:24 +0800 (CST)
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Mar 2022 09:01:46 +0800
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
        KP Singh <kpsingh@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20220309123321.2400262-1-houtao1@huawei.com>
 <20220309123321.2400262-4-houtao1@huawei.com>
 <20220309232253.v6oqev7jock7vm7i@ast-mbp.dhcp.thefacebook.com>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <06abdc4e-8806-10dd-c753-229d3e957add@huawei.com>
Date:   Thu, 10 Mar 2022 09:01:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20220309232253.v6oqev7jock7vm7i@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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

On 3/10/2022 7:22 AM, Alexei Starovoitov wrote:
> On Wed, Mar 09, 2022 at 08:33:20PM +0800, Hou Tao wrote:
>> It is the bpf_jit_harden counterpart to commit 60b58afc96c9 ("bpf: fix
>> net.core.bpf_jit_enable race"). bpf_jit_harden will be tested twice
>> for each subprog if there are subprogs in bpf program and constant
>> blinding may increase the length of program, so when running
>> "./test_progs -t subprogs" and toggling bpf_jit_harden between 0 and 2,
>> jit_subprogs may fail because constant blinding increases the length
>> of subprog instructions during extra passs.
>>
>> So cache the value of bpf_jit_blinding_enabled() during program
>> allocation, and use the cached value during constant blinding, subprog
>> JITing and args tracking of tail call.
> Looks like this patch alone is enough.
> With race fixed. Patches 1 and 2 are no longer necessary, right?
Yes and no. With patch 3 applied, the problems described in patch 1 and patch 2
are gone, but it may recur due to other issue in JIT. So I post these two patch
together and hope these fixes can also be merged.
> .
