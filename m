Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5643546E83C
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 13:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237278AbhLIMU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 07:20:28 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:6971 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237258AbhLIMU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 07:20:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1639052216; x=1670588216;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RWlbifQ9a9AiycMGPMulphDDQPX16BnMiBreU0jK2tU=;
  b=c48OOC3Qdh5JoU9fjEa02xyaEBXzN9OGSCjvJqVHbiWuVxRixNoTgvb1
   isVg93co0kO5t7/LHVgh1ZEz/khX6wnyYXDBo+Un7vCcO4PWPOXBLHuhL
   v3d0Om2Lrs5xHs3hVDw45MXz6YjzTqkE+YwwM8MuKqupaeX7Rw7lM9xBJ
   A=;
X-IronPort-AV: E=Sophos;i="5.88,192,1635206400"; 
   d="scan'208";a="179641552"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-8691d7ea.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 09 Dec 2021 12:16:54 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-8691d7ea.us-east-1.amazon.com (Postfix) with ESMTPS id 620F3C0971;
        Thu,  9 Dec 2021 12:16:52 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Thu, 9 Dec 2021 12:16:51 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.223) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Thu, 9 Dec 2021 12:16:48 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <pabeni@redhat.com>
CC:     <benh@amazon.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next] tcp: Warn if sock_owned_by_user() is true in tcp_child_process().
Date:   Thu, 9 Dec 2021 21:16:44 +0900
Message-ID: <20211209121644.96758-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <bd537766c4b70da71153a9972e6f6ee12e92ff92.camel@redhat.com>
References: <bd537766c4b70da71153a9972e6f6ee12e92ff92.camel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.223]
X-ClientProxiedBy: EX13D02UWC001.ant.amazon.com (10.43.162.243) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Paolo Abeni <pabeni@redhat.com>
Date:   Thu, 09 Dec 2021 12:59:21 +0100
> On Thu, 2021-12-09 at 20:07 +0900, Kuniyuki Iwashima wrote:
>> From:   Eric Dumazet <edumazet@google.com>
>> Date:   Thu, 9 Dec 2021 00:00:35 -0800
>>> On Wed, Dec 8, 2021 at 5:33 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>>>> 
>>>> While creating a child socket from ACK (not TCP Fast Open case), before
>>>> v2.3.41, we used to call bh_lock_sock() later than now; it was called just
>>>> before tcp_rcv_state_process().  The full socket was put into an accept
>>>> queue and exposed to other CPUs before bh_lock_sock() so that process
>>>> context might have acquired the lock by then.  Thus, we had to check if any
>>>> process context was accessing the socket before tcp_rcv_state_process().
>>>> 
>>> 
>>> I think you misunderstood me.
>>> 
>>> I think this code is not dead yet, so I would :
>>> 
>>> Not include a Fixes: tag to avoid unnecessary backports (of a patch
>>> and its revert)
>>> 
>>> If you want to get syzbot coverage for few releases, especially with
>>> MPTCP and synflood,
>>> you  can then submit a patch like the following.
>> 
>> Sorry, I got on the same page.
>> Let me take a look at MPTCP, then if I still think it is dead code, I will
>> submit the patch.
> 
> For the records, I think the 'else' branch should be reachble with
> MPTCP in some non trivial scenario, e.g. MPJ subflows 3WHS racing with
> setsockopt on the main MPTCP socket. I'm unsure if syzbot could catch
> that, as it needs mptcp endpoints configuration.

Ah, I was wrong.
Thanks for explaining!


> 
> Cheers,
> 
> Paolo
