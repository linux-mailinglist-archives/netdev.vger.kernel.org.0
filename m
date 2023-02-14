Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0AA5695D72
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 09:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbjBNItA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 03:49:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjBNIs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 03:48:58 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB51818B0B;
        Tue, 14 Feb 2023 00:48:56 -0800 (PST)
Received: from kwepemm600001.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PGFH331M9zrRxW;
        Tue, 14 Feb 2023 16:48:31 +0800 (CST)
Received: from [10.174.176.245] (10.174.176.245) by
 kwepemm600001.china.huawei.com (7.193.23.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Tue, 14 Feb 2023 16:48:54 +0800
Message-ID: <3e5e70c5-62af-232d-c586-1705123f67bc@huawei.com>
Date:   Tue, 14 Feb 2023 16:48:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next 05/12] netfilter: conntrack: set icmpv6 redirects
 as RELATED
From:   Wang Hai <wanghai38@huawei.com>
To:     <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>,
        <netfilter-devel@vger.kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <edumazet@google.com>
References: <20221211101204.1751-1-pablo@netfilter.org>
 <20221211101204.1751-6-pablo@netfilter.org>
 <6d812cac-f603-9aa9-6f06-41535ad7cfcd@huawei.com>
In-Reply-To: <6d812cac-f603-9aa9-6f06-41535ad7cfcd@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.245]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600001.china.huawei.com (7.193.23.3)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2023/2/14 16:19, Wang Hai 写道:
>
> 在 2022/12/11 18:11, Pablo Neira Ayuso 写道:
>> From: Florian Westphal <fw@strlen.de>
>>
>> icmp conntrack will set icmp redirects as RELATED, but icmpv6 will not
>> do this.
>>
>> For icmpv6, only icmp errors (code <= 128) are examined for RELATED 
>> state.
>> ICMPV6 Redirects are part of neighbour discovery mechanism, those are
>> handled by marking a selected subset (e.g.  neighbour solicitations) as
>> UNTRACKED, but not REDIRECT -- they will thus be flagged as INVALID.
>>
>> Add minimal support for REDIRECTs.  No parsing of neighbour options is
>> added for simplicity, so this will only check that we have the embeeded
>> original header (ND_OPT_REDIRECT_HDR), and then attempt to do a flow
>> lookup for this tuple.
>>
>> Also extend the existing test case to cover redirects.
>>
>> Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
>> Reported-by: Eric Garver <eric@garver.life>
>> Link: https://github.com/firewalld/firewalld/issues/1046
>> Signed-off-by: Florian Westphal <fw@strlen.de>
>> Acked-by: Eric Garver <eric@garver.life>
>> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>> ---
>>   net/netfilter/nf_conntrack_proto_icmpv6.c     | 53 +++++++++++++++++++
>>   .../netfilter/conntrack_icmp_related.sh       | 36 ++++++++++++-
>>   2 files changed, 87 insertions(+), 2 deletions(-)
> Hi, Florian.
>
> The new ipv4 redirects test case doesn't seem to work, is there a 
> problem with my testing steps?
>
> # sh tools/testing/selftests/netfilter/conntrack_icmp_related.sh
> PASS: icmp mtu error had RELATED state
> ERROR: counter redir4 in nsclient1 has unexpected value (expected 
> packets 1 bytes 112)
> table inet filter {
>         counter redir4 {
>                 packets 0 bytes 0
>         }
> }
> ERROR: icmp redirect RELATED state test has failed.
>
> The test is based on commit f6feea56f66d ("Merge tag 
> 'mm-hotfixes-stable-2023-02-13-13-50' of 
> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm")
>
Hi, Florian.

I found the reason why it failed. This needs to be configured on the 
host with net.ipv4.conf.default.send_redirects=1.

Sorry to bother you.

-- 
Wang Hai

