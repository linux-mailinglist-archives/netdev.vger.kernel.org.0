Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9260861EE6D
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 10:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231642AbiKGJMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 04:12:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231816AbiKGJMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 04:12:15 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A64A167E7;
        Mon,  7 Nov 2022 01:12:14 -0800 (PST)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N5QTd2hFSzHvk0;
        Mon,  7 Nov 2022 17:11:49 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 17:12:11 +0800
Received: from [10.67.111.205] (10.67.111.205) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 17:12:10 +0800
Subject: Re: [PATCH bpf RESEND 2/4] bpf: Remove size check for sk in
 bpf_skb_is_valid_access for 32-bit architecture
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>,
        <illusionist.neo@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <mykolal@fb.com>, <shuah@kernel.org>,
        <benjamin.tissoires@redhat.com>, <memxor@gmail.com>,
        <delyank@fb.com>, <asavkov@redhat.com>, <bpf@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>
References: <20221103092118.248600-1-yangjihong1@huawei.com>
 <20221103092118.248600-3-yangjihong1@huawei.com>
 <Y2OknBtLgqTHSrvy@shell.armlinux.org.uk>
From:   Yang Jihong <yangjihong1@huawei.com>
Message-ID: <342e1213-7ca8-5e6b-1c6c-a3e7dfbfeed6@huawei.com>
Date:   Mon, 7 Nov 2022 17:12:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <Y2OknBtLgqTHSrvy@shell.armlinux.org.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.205]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600003.china.huawei.com (7.193.23.202)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On 2022/11/3 19:23, Russell King (Oracle) wrote:
> On Thu, Nov 03, 2022 at 05:21:16PM +0800, Yang Jihong wrote:
>> The error code -EACCES is returned when bpf prog is tested in 32-bit environment,
>> This is because bpf_object__relocate modifies the instruction to change memory
>> size to 4 bytes, as shown in the following messages:
>>
>> libbpf: prog 'kfunc_call_test1': relo #2: matching candidate #0 <byte_off> [18342] struct __sk_buff.sk (0:30:0 @ offset 168)
>> libbpf: prog 'kfunc_call_test1': relo #2: patched insn #1 (LDX/ST/STX) off 168 -> 168
>> libbpf: prog 'kfunc_call_test1': relo #2: patched insn #1 (LDX/ST/STX) mem_sz 8 -> 4
>>
>> As a result, the bpf_skb_is_valid_access check fails. For 32-bit architecture,
>> unnecessary checks need to be deleted.
> 
> Isn't the purpose of this check to ensure that the entire pointer is
> written, and BPF can't write half of it?
> 
> 
>>   	case offsetof(struct __sk_buff, sk):
>> -		if (type == BPF_WRITE || size != sizeof(__u64))
>> -			return false;
> 
> Wouldn't "(size != sizeof(struct bpf_sock *) && size != sizeof(__u64))"
> be more appropriate here, so 32-bit can only write the 32-bit pointer
> or the full 64-bit value, and 64-bit can only write the 64-bit pointer?
> Or is there a reason not to? bpf folk?
> 
Thanks for the detailed proposals, will fix it in next version.

Thanks,
Yang
