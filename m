Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 761824CCDFA
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 07:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238479AbiCDGqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 01:46:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbiCDGqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 01:46:49 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B6F18CC0C;
        Thu,  3 Mar 2022 22:46:01 -0800 (PST)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4K8yyJ736QzdZdk;
        Fri,  4 Mar 2022 14:44:40 +0800 (CST)
Received: from [10.174.177.215] (10.174.177.215) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 4 Mar 2022 14:45:58 +0800
Subject: Re: [PATCH bpf-next v2 1/4] bpf, sockmap: Fix memleak in
 sk_psock_queue_msg
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     <john.fastabend@gmail.com>, <daniel@iogearbox.net>,
        <jakub@cloudflare.com>, <lmb@cloudflare.com>,
        <davem@davemloft.net>, <edumazet@google.com>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <ast@kernel.org>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <kpsingh@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
References: <20220302022755.3876705-1-wangyufen@huawei.com>
 <20220302022755.3876705-2-wangyufen@huawei.com>
 <YiAOxRWZBHWDTpAs@pop-os.localdomain>
From:   wangyufen <wangyufen@huawei.com>
Message-ID: <2ebeeba1-f06d-9ebf-b59c-b0289ad89885@huawei.com>
Date:   Fri, 4 Mar 2022 14:45:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <YiAOxRWZBHWDTpAs@pop-os.localdomain>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.215]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500010.china.huawei.com (7.192.105.118)
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


ÔÚ 2022/3/3 8:41, Cong Wang Ð´µÀ:
> On Wed, Mar 02, 2022 at 10:27:52AM +0800, Wang Yufen wrote:
>> diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
>> index fdb5375f0562..c5a2d6f50f25 100644
>> --- a/include/linux/skmsg.h
>> +++ b/include/linux/skmsg.h
>> @@ -304,21 +304,16 @@ static inline void sock_drop(struct sock *sk, struct sk_buff *skb)
>>   	kfree_skb(skb);
>>   }
>>   
>> -static inline void drop_sk_msg(struct sk_psock *psock, struct sk_msg *msg)
>> -{
>> -	if (msg->skb)
>> -		sock_drop(psock->sk, msg->skb);
>> -	kfree(msg);
>> -}
>> -
>>   static inline void sk_psock_queue_msg(struct sk_psock *psock,
>>   				      struct sk_msg *msg)
>>   {
>>   	spin_lock_bh(&psock->ingress_lock);
>>   	if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED))
>>   		list_add_tail(&msg->list, &psock->ingress_msg);
>> -	else
>> -		drop_sk_msg(psock, msg);
>> +	else {
>> +		sk_msg_free(psock->sk, msg);
> __sk_msg_free() calls sk_msg_init() at the end.
>
>> +		kfree(msg);
> Now you free it, hence the above sk_msg_init() is completely
> unnecessary.

Invoking of sk_msg_free() does not always follow kfree().

That is, sk_msg needs to be reused in some cases.

We can implement sk_msg_free_xx() without sk_msg_init(),

but I don't think it is necessary.


Thanks

>
> Thanks.
> .
