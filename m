Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7B43532420
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 09:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235091AbiEXHcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 03:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234097AbiEXHcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 03:32:53 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82102532E2;
        Tue, 24 May 2022 00:32:52 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4L6m8n5Hvdz1JCBl;
        Tue, 24 May 2022 15:31:21 +0800 (CST)
Received: from [10.174.177.215] (10.174.177.215) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 24 May 2022 15:32:50 +0800
Subject: Re: [PATCH net-next] ipv6: Fix signed integer overflow in
 __ip6_append_data
To:     Eric Dumazet <edumazet@google.com>
CC:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
References: <20220524034629.395939-1-wangyufen@huawei.com>
 <CANn89iK25tMWxyLYhFK8oMx9zJeQAntbiK1J=8hpeMg51GSKhA@mail.gmail.com>
From:   wangyufen <wangyufen@huawei.com>
Message-ID: <5f814822-53e5-2d15-894b-073a31378bfe@huawei.com>
Date:   Tue, 24 May 2022 15:32:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CANn89iK25tMWxyLYhFK8oMx9zJeQAntbiK1J=8hpeMg51GSKhA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.215]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/5/24 11:54, Eric Dumazet 写道:
> On Mon, May 23, 2022 at 8:29 PM Wang Yufen <wangyufen@huawei.com> wrote:
>> Resurrect ubsan overflow checks and ubsan report this warning,
>> fix it by change len check from INT_MAX to IPV6_MAXPLEN.
>>
>> UBSAN: signed-integer-overflow in net/ipv6/ip6_output.c:1489:19
>> 2147479552 + 8567 cannot be represented in type 'int'
> OK, so why not fix this point, instead of UDP, which is only one of
> the possible callers ?
>
> It seems the check in __ip6_append_data() should be unsigned.
> .
I modified it based on the IPv4 process:
     udp_sendmsg->ip_append_data->__ip_append_data
The other callers may have the same issue, it would be
more appropriate to change the variable [length]

to size_t in the entire process. I'll try to change it.

Thanks.

