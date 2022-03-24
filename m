Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 657CA4E623B
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 12:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343837AbiCXLR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 07:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236311AbiCXLRZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 07:17:25 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9061BA66CF
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 04:15:53 -0700 (PDT)
Received: from kwepemi500009.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KPMzW0VW7zCrCJ;
        Thu, 24 Mar 2022 19:13:43 +0800 (CST)
Received: from kwepemm600001.china.huawei.com (7.193.23.3) by
 kwepemi500009.china.huawei.com (7.221.188.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 24 Mar 2022 19:15:50 +0800
Received: from [10.174.176.245] (10.174.176.245) by
 kwepemm600001.china.huawei.com (7.193.23.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 24 Mar 2022 19:15:50 +0800
Subject: Re: [PATCH net] af_unix: fix races in sk_peer_pid and sk_peer_cred
 accesses
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     <davem@davemloft.net>, <ebiederm@xmission.com>,
        <edumazet@google.com>, <eric.dumazet@gmail.com>,
        <jannh@google.com>, <kuba@kernel.org>, <luiz.von.dentz@intel.com>,
        <marcel@holtmann.org>, <netdev@vger.kernel.org>
References: <660fecfc-167d-ce6f-9c08-bbc37790ea81@huawei.com>
 <20220324090455.78057-1-kuniyu@amazon.co.jp>
From:   "wanghai (M)" <wanghai38@huawei.com>
Message-ID: <a01e603b-cc95-19d2-c506-29466c9b8358@huawei.com>
Date:   Thu, 24 Mar 2022 19:15:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20220324090455.78057-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.245]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600001.china.huawei.com (7.193.23.3)
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


在 2022/3/24 17:04, Kuniyuki Iwashima 写道:
> From:   "wanghai (M)" <wanghai38@huawei.com>
> Date:   Thu, 24 Mar 2022 16:03:31 +0800
>> 在 2021/9/30 6:57, Eric Dumazet 写道:
>>> From: Eric Dumazet <edumazet@google.com>
>>>
>>> Jann Horn reported that SO_PEERCRED and SO_PEERGROUPS implementations
>>> are racy, as af_unix can concurrently change sk_peer_pid and sk_peer_cred.
>>>
>>> In order to fix this issue, this patch adds a new spinlock that needs
>>> to be used whenever these fields are read or written.
>>>
>>> Jann also pointed out that l2cap_sock_get_peer_pid_cb() is currently
>>> reading sk->sk_peer_pid which makes no sense, as this field
>>> is only possibly set by AF_UNIX sockets.
>>> We will have to clean this in a separate patch.
>>> This could be done by reverting b48596d1dc25 "Bluetooth: L2CAP: Add get_peer_pid callback"
>>> or implementing what was truly expected.
>>>
>>> Fixes: 109f6e39fa07 ("af_unix: Allow SO_PEERCRED to work across namespaces.")
>>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>>> Reported-by: Jann Horn <jannh@google.com>
>>> Cc: Eric W. Biederman <ebiederm@xmission.com>
>>> Cc: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>>> Cc: Marcel Holtmann <marcel@holtmann.org>
>>> ---
>> ...
>>>    static void copy_peercred(struct sock *sk, struct sock *peersk)
>>>    {
>>> -	put_pid(sk->sk_peer_pid);
>>> -	if (sk->sk_peer_cred)
>>> -		put_cred(sk->sk_peer_cred);
>>> +	const struct cred *old_cred;
>>> +	struct pid *old_pid;
>>> +
>>> +	if (sk < peersk) {
>>> +		spin_lock(&sk->sk_peer_lock);
>>> +		spin_lock_nested(&peersk->sk_peer_lock, SINGLE_DEPTH_NESTING);
>>> +	} else {
>>> +		spin_lock(&peersk->sk_peer_lock);
>>> +		spin_lock_nested(&sk->sk_peer_lock, SINGLE_DEPTH_NESTING);
>>> +	}
>> Hi, ALL.
>> I'm sorry to bother you.
>>
>> This patch adds sk_peer_lock to solve the problem that af_unix may
>> concurrently change sk_peer_pid and sk_peer_cred.
>>
>> I am confused as to why the order of locks is needed here based on
>> the address size of sk and peersk.
> To simply avoid dead lock.  These locks must be acquired in the same
> order.  The smaller address lock is acquired first, then larger one.
>
>    e.g.) CPU-A calls copy_peercred(sk-A, sk-B), and
>          CPU-B calls copy_peercred(sk-B, sk-A).
>
> There are some implementations like this:
>
>    $ grep -rn double_lock
I got it, thank you for your patient explanation.
>
>
>> Any feedback would be appreciated, thanks.
>>> +	old_pid = sk->sk_peer_pid;
>>> +	old_cred = sk->sk_peer_cred;
>>>    	sk->sk_peer_pid  = get_pid(peersk->sk_peer_pid);
>>>    	sk->sk_peer_cred = get_cred(peersk->sk_peer_cred);
>>> +
>>> +	spin_unlock(&sk->sk_peer_lock);
>>> +	spin_unlock(&peersk->sk_peer_lock);
>>> +
>>> +	put_pid(old_pid);
>>> +	put_cred(old_cred);
>>>    }
>>>    
>>>    static int unix_listen(struct socket *sock, int backlog)
>> -- 
>> Wang Hai
> .
>
-- 
Wang Hai

