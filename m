Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 902674E60D7
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 10:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349124AbiCXJGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 05:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238929AbiCXJGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 05:06:40 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EBED9D0FF
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 02:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1648112710; x=1679648710;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lH+ZuaAqLREV/aQsdMolMgakOA8/CZzUc7xQAAdmeos=;
  b=dVieAl7betZxSpx/YAe5JB7iYVvG/xirTyDStYE3BDxV8OMFLfHRYIs0
   VrVY2iQ0MHWgRQ7x4hifLw4+lqs5FRdh9m9e0uMiFsiPkUOs1goQ/Uu66
   USwhAuYvUg60kFiuvmm2Zz2eCgudsLu44D1B7CVANs7CnaDs19MGnD8Oa
   s=;
X-IronPort-AV: E=Sophos;i="5.90,206,1643673600"; 
   d="scan'208";a="184143503"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-b69ea591.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 24 Mar 2022 09:05:09 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-b69ea591.us-east-1.amazon.com (Postfix) with ESMTPS id 1A1B6C0846;
        Thu, 24 Mar 2022 09:05:05 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Thu, 24 Mar 2022 09:05:04 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.224) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Thu, 24 Mar 2022 09:05:00 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <wanghai38@huawei.com>
CC:     <davem@davemloft.net>, <ebiederm@xmission.com>,
        <edumazet@google.com>, <eric.dumazet@gmail.com>,
        <jannh@google.com>, <kuba@kernel.org>, <luiz.von.dentz@intel.com>,
        <marcel@holtmann.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net] af_unix: fix races in sk_peer_pid and sk_peer_cred accesses
Date:   Thu, 24 Mar 2022 18:04:55 +0900
Message-ID: <20220324090455.78057-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <660fecfc-167d-ce6f-9c08-bbc37790ea81@huawei.com>
References: <660fecfc-167d-ce6f-9c08-bbc37790ea81@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.43.160.224]
X-ClientProxiedBy: EX13D28UWC004.ant.amazon.com (10.43.162.24) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   "wanghai (M)" <wanghai38@huawei.com>
Date:   Thu, 24 Mar 2022 16:03:31 +0800
> 在 2021/9/30 6:57, Eric Dumazet 写道:
>> From: Eric Dumazet <edumazet@google.com>
>>
>> Jann Horn reported that SO_PEERCRED and SO_PEERGROUPS implementations
>> are racy, as af_unix can concurrently change sk_peer_pid and sk_peer_cred.
>>
>> In order to fix this issue, this patch adds a new spinlock that needs
>> to be used whenever these fields are read or written.
>>
>> Jann also pointed out that l2cap_sock_get_peer_pid_cb() is currently
>> reading sk->sk_peer_pid which makes no sense, as this field
>> is only possibly set by AF_UNIX sockets.
>> We will have to clean this in a separate patch.
>> This could be done by reverting b48596d1dc25 "Bluetooth: L2CAP: Add get_peer_pid callback"
>> or implementing what was truly expected.
>>
>> Fixes: 109f6e39fa07 ("af_unix: Allow SO_PEERCRED to work across namespaces.")
>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>> Reported-by: Jann Horn <jannh@google.com>
>> Cc: Eric W. Biederman <ebiederm@xmission.com>
>> Cc: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>> Cc: Marcel Holtmann <marcel@holtmann.org>
>> ---
> ...
>>   static void copy_peercred(struct sock *sk, struct sock *peersk)
>>   {
>> -	put_pid(sk->sk_peer_pid);
>> -	if (sk->sk_peer_cred)
>> -		put_cred(sk->sk_peer_cred);
>> +	const struct cred *old_cred;
>> +	struct pid *old_pid;
>> +
>> +	if (sk < peersk) {
>> +		spin_lock(&sk->sk_peer_lock);
>> +		spin_lock_nested(&peersk->sk_peer_lock, SINGLE_DEPTH_NESTING);
>> +	} else {
>> +		spin_lock(&peersk->sk_peer_lock);
>> +		spin_lock_nested(&sk->sk_peer_lock, SINGLE_DEPTH_NESTING);
>> +	}
> Hi, ALL.
> I'm sorry to bother you.
> 
> This patch adds sk_peer_lock to solve the problem that af_unix may
> concurrently change sk_peer_pid and sk_peer_cred.
> 
> I am confused as to why the order of locks is needed here based on
> the address size of sk and peersk.

To simply avoid dead lock.  These locks must be acquired in the same
order.  The smaller address lock is acquired first, then larger one.

  e.g.) CPU-A calls copy_peercred(sk-A, sk-B), and
        CPU-B calls copy_peercred(sk-B, sk-A).

There are some implementations like this:

  $ grep -rn double_lock


> 
> Any feedback would be appreciated, thanks.
>> +	old_pid = sk->sk_peer_pid;
>> +	old_cred = sk->sk_peer_cred;
>>   	sk->sk_peer_pid  = get_pid(peersk->sk_peer_pid);
>>   	sk->sk_peer_cred = get_cred(peersk->sk_peer_cred);
>> +
>> +	spin_unlock(&sk->sk_peer_lock);
>> +	spin_unlock(&peersk->sk_peer_lock);
>> +
>> +	put_pid(old_pid);
>> +	put_cred(old_cred);
>>   }
>>   
>>   static int unix_listen(struct socket *sock, int backlog)
> 
> -- 
> Wang Hai
