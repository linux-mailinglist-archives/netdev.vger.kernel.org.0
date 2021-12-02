Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABDBE465CCE
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 04:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351574AbhLBDp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 22:45:57 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:29143 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355275AbhLBDpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 22:45:25 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4J4MCj47tmzQjJN;
        Thu,  2 Dec 2021 11:40:01 +0800 (CST)
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 2 Dec 2021 11:42:00 +0800
Subject: Re: [PATCH bpf-next v4 2/2] bpf: disallow BPF_LOG_KERNEL log level
 for bpf(BPF_BTF_LOAD)
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
References: <20211201073458.2731595-1-houtao1@huawei.com>
 <20211201073458.2731595-3-houtao1@huawei.com>
 <CAADnVQ+LDW+K_3czmiTcU4CtONxM+eTkyuwwra5hGTqAXTCcZw@mail.gmail.com>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <d8328f48-bce7-b19b-53db-ccee3cc3322a@huawei.com>
Date:   Thu, 2 Dec 2021 11:42:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CAADnVQ+LDW+K_3czmiTcU4CtONxM+eTkyuwwra5hGTqAXTCcZw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 12/2/2021 1:42 AM, Alexei Starovoitov wrote:
> On Tue, Nov 30, 2021 at 11:19 PM Hou Tao <houtao1@huawei.com> wrote:
>> BPF_LOG_KERNEL is only used internally, so disallow bpf_btf_load()
>> to set log level as BPF_LOG_KERNEL. The same checking has already
>> been done in bpf_check(), so factor out a helper to check the
>> validity of log attributes and use it in both places.
>>
>>
snip
>> -               ret = -EINVAL;
>>                 /* log attributes have to be sane */
>> -               if (log->len_total < 128 || log->len_total > UINT_MAX >> 2 ||
>> -                   !log->level || !log->ubuf || log->level & ~BPF_LOG_MASK)
>> +               if (!bpf_verifier_log_attr_valid(log, UINT_MAX >> 2)) {
>> +                       ret = -EINVAL;
> It's actually quite bad that we have this discrepancy in limits.
> I've already sent a patch to make them the same.
> It was a pain to debug.
> https://lore.kernel.org/bpf/20211124060209.493-7-alexei.starovoitov@gmail.com/
> "
> Otherwise tools that progressively increase log size and use the same log
> for BTF loading and program loading will be hitting hard to debug EINVAL.
> "
OK. Will send a single patch to handle that based on your patch set.

Regards,
Tao

