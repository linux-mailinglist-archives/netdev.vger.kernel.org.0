Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46D0346E747
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 12:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235557AbhLILLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 06:11:30 -0500
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:30594 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235371AbhLILL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 06:11:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1639048077; x=1670584077;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=st+S/deejGTLY336oH4hka4K31eE8P3Hn27e1WQ7K5w=;
  b=VmpMcVkJiIGWGTdMSNfXcyyxxUB3AQBKP8p8j7/dQsDSpRyy1/bMdeOb
   JlkUQ3Ck09QJN/55cVkYBXD2xz18kl4i/dBzIB17HL+ncUKeEMa+mBR3C
   i9q/EmTsBToBtchITy/6W9+Cr7tZvLYSGhbYIZRc7q911W2vNKEyIM3Ln
   U=;
X-IronPort-AV: E=Sophos;i="5.88,192,1635206400"; 
   d="scan'208";a="47304549"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-31df91b1.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 09 Dec 2021 11:07:57 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-31df91b1.us-west-2.amazon.com (Postfix) with ESMTPS id 4776C42202;
        Thu,  9 Dec 2021 11:07:55 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Thu, 9 Dec 2021 11:07:53 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.57) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Thu, 9 Dec 2021 11:07:49 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <edumazet@google.com>
CC:     <benh@amazon.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next] tcp: Warn if sock_owned_by_user() is true in tcp_child_process().
Date:   Thu, 9 Dec 2021 20:07:46 +0900
Message-ID: <20211209110746.91987-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iJ12OugQTv4JHwVWKtZp88sbQKXD61PvnQWOo3009tTKQ@mail.gmail.com>
References: <CANn89iJ12OugQTv4JHwVWKtZp88sbQKXD61PvnQWOo3009tTKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.57]
X-ClientProxiedBy: EX13D45UWA001.ant.amazon.com (10.43.160.91) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 9 Dec 2021 00:00:35 -0800
> On Wed, Dec 8, 2021 at 5:33 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>>
>> While creating a child socket from ACK (not TCP Fast Open case), before
>> v2.3.41, we used to call bh_lock_sock() later than now; it was called just
>> before tcp_rcv_state_process().  The full socket was put into an accept
>> queue and exposed to other CPUs before bh_lock_sock() so that process
>> context might have acquired the lock by then.  Thus, we had to check if any
>> process context was accessing the socket before tcp_rcv_state_process().
>>
> 
> I think you misunderstood me.
> 
> I think this code is not dead yet, so I would :
> 
> Not include a Fixes: tag to avoid unnecessary backports (of a patch
> and its revert)
> 
> If you want to get syzbot coverage for few releases, especially with
> MPTCP and synflood,
> you  can then submit a patch like the following.

Sorry, I got on the same page.
Let me take a look at MPTCP, then if I still think it is dead code, I will
submit the patch.

Thank you.


> 
> diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
> index cf913a66df17..19da6e442fca 100644
> --- a/net/ipv4/tcp_minisocks.c
> +++ b/net/ipv4/tcp_minisocks.c
> @@ -843,6 +843,9 @@ int tcp_child_process(struct sock *parent, struct
> sock *child,
>                  * in main socket hash table and lock on listening
>                  * socket does not protect us more.
>                  */
> +
> +               /* Check if this code path is obsolete ? */
> +               WARN_ON_ONCE(1);
>                 __sk_add_backlog(child, skb);
>         }
