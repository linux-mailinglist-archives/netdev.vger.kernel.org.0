Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56C91666C53
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 09:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239706AbjALIXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 03:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239601AbjALIWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 03:22:44 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42243FC9D;
        Thu, 12 Jan 2023 00:20:49 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NsyBP67fCznVKx;
        Thu, 12 Jan 2023 16:19:09 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Thu, 12 Jan 2023 16:20:45 +0800
Subject: Re: [PATCH bpf-next v2 2/2] selftests/bpf: add ipip6 and ip6ip decap
 to test_tc_tunnel
To:     Willem de Bruijn <willemb@google.com>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <martin.lau@linux.dev>,
        <song@kernel.org>, <yhs@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <sdf@google.com>, <haoluo@google.com>,
        <jolsa@kernel.org>
References: <cover.1673423199.git.william.xuanziyang@huawei.com>
 <ec692898c848256540d146b76a3e239914453293.1673423199.git.william.xuanziyang@huawei.com>
 <CA+FuTSe+YJcyDV8S-PAzceLe4kNe-ZTZ+JpqpFkSmYfASv27Ug@mail.gmail.com>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <d15e7f66-0fa1-af9e-e9c6-8c0ac47096a9@huawei.com>
Date:   Thu, 12 Jan 2023 16:20:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSe+YJcyDV8S-PAzceLe4kNe-ZTZ+JpqpFkSmYfASv27Ug@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Wed, Jan 11, 2023 at 3:02 AM Ziyang Xuan
> <william.xuanziyang@huawei.com> wrote:
>>
>> Add ipip6 and ip6ip decap testcases. Verify that bpf_skb_adjust_room()
>> correctly decapsulate ipip6 and ip6ip tunnel packets.
>>
>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
>> ---
>>  .../selftests/bpf/progs/test_tc_tunnel.c      | 91 ++++++++++++++++++-
>>  tools/testing/selftests/bpf/test_tc_tunnel.sh | 15 +--
>>  2 files changed, 98 insertions(+), 8 deletions(-)
>>
>> diff --git a/tools/testing/selftests/bpf/progs/test_tc_tunnel.c b/tools/testing/selftests/bpf/progs/test_tc_tunnel.c
>> index a0e7762b1e5a..e6e678aa9874 100644
>> --- a/tools/testing/selftests/bpf/progs/test_tc_tunnel.c
>> +++ b/tools/testing/selftests/bpf/progs/test_tc_tunnel.c
>> @@ -38,6 +38,10 @@ static const int cfg_udp_src = 20000;
>>  #define        VXLAN_FLAGS     0x8
>>  #define        VXLAN_VNI       1
>>
>> +#ifndef NEXTHDR_DEST
>> +#define NEXTHDR_DEST   60
>> +#endif
> 
> Should not be needed if including the right header? include/net/ipv6.h
> 
> Otherwise very nice extension. Thanks for expanding the test.

"net/ipv6.h" do not under /usr/include/ and can not be included in bpf programs.

> .
> 
