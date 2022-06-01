Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F38F9539D28
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 08:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349775AbiFAGV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 02:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349771AbiFAGV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 02:21:56 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 900AB5C765;
        Tue, 31 May 2022 23:21:55 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LCfCc0wJyzjXCk;
        Wed,  1 Jun 2022 14:20:44 +0800 (CST)
Received: from [10.174.177.215] (10.174.177.215) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 1 Jun 2022 14:21:53 +0800
Subject: Re: [PATCH net-next v3] ipv6: Fix signed integer overflow in
 __ip6_append_data
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
References: <20220528022312.2827597-1-wangyufen@huawei.com>
 <20220531213500.521ef5cc@kernel.org>
From:   wangyufen <wangyufen@huawei.com>
Message-ID: <31f952a3-84e2-7512-e76f-b23b100c64b7@huawei.com>
Date:   Wed, 1 Jun 2022 14:21:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20220531213500.521ef5cc@kernel.org>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.215]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2022/6/1 12:35, Jakub Kicinski Ð´µÀ:
> On Sat, 28 May 2022 10:23:12 +0800 Wang Yufen wrote:
>> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
>> index 55afd7f39c04..91704bbc7715 100644
>> --- a/net/ipv6/udp.c
>> +++ b/net/ipv6/udp.c
>> @@ -1308,7 +1308,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
>>   	struct ipcm6_cookie ipc6;
>>   	int addr_len = msg->msg_namelen;
>>   	bool connected = false;
>> -	int ulen = len;
>> +	size_t ulen = len;
>>   	int corkreq = READ_ONCE(up->corkflag) || msg->msg_flags&MSG_MORE;
>>   	int err;
>>   	int is_udplite = IS_UDPLITE(sk);
> No need to change ulen neither, it will not overflow and will be
> promoted to size_t when passed to ip6_append_data() / ip6_make_skb().
> .
OK, thanks.
