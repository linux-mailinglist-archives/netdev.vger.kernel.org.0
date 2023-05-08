Return-Path: <netdev+bounces-918-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0CC26FB60A
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 19:40:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7177D28100F
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 17:40:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59BD26106;
	Mon,  8 May 2023 17:40:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A24E17D1
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 17:40:15 +0000 (UTC)
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DFE170A
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 10:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1683567614; x=1715103614;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DY59QGvi1GR9vN1CqdXWK2b96bzuKQCOLlvijX8bkNY=;
  b=rzsauI0HRNbuVttAwIVQ+ixcgxvSPC+ev70Q0qGruq/4qxbLsu+a528/
   eLCo+nJz6gSNr9yc9G+e47Guv0KmZn/618ipBFsCyChA5lFQzK/4AMyJp
   ZgFpSyvZRYVicKVjE44bHdGfLMgSzylD/FZNTYjPpa4lF/fE/Hp/m/qSr
   M=;
X-IronPort-AV: E=Sophos;i="5.99,259,1677542400"; 
   d="scan'208";a="212248388"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-189d700f.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2023 17:40:11 +0000
Received: from EX19MTAUWA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
	by email-inbound-relay-pdx-2b-m6i4x-189d700f.us-west-2.amazon.com (Postfix) with ESMTPS id 6907E41485;
	Mon,  8 May 2023 17:40:10 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 8 May 2023 17:40:10 +0000
Received: from 88665a182662.ant.amazon.com.com (10.187.170.41) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 8 May 2023 17:40:07 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <edumazet@google.com>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <kuni1840@gmail.com>,
	<kuniyu@amazon.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
	<syzkaller@googlegroups.com>
Subject: Re: [PATCH v2 net] net: Fix sk->sk_stamp race in sock_recv_cmsgs().
Date: Mon, 8 May 2023 10:39:59 -0700
Message-ID: <20230508173959.52607-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iJAZ+OYVebm-x4pJgjYTdj8RiXc8iLnQC8X6JC3RUywuA@mail.gmail.com>
References: <CANn89iJAZ+OYVebm-x4pJgjYTdj8RiXc8iLnQC8X6JC3RUywuA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.187.170.41]
X-ClientProxiedBy: EX19D041UWA004.ant.amazon.com (10.13.139.9) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
	T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Eric Dumazet <edumazet@google.com>
Date: Mon, 8 May 2023 19:31:12 +0200
> On Mon, May 8, 2023 at 7:20 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > From: Eric Dumazet <edumazet@google.com>
> > Date: Mon, 8 May 2023 19:08:58 +0200
> > > On Mon, May 8, 2023 at 6:58 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > >
> > > > KCSAN found a data race in sock_recv_cmsgs() [0] where the read access
> > > > to sk->sk_stamp needs READ_ONCE().
> > > >
> > > > Also, there is another race like below.  If the torn load of the high
> > > > 32-bits precedes WRITE_ONCE(sk, skb->tstamp) and later the written
> > > > lower 32-bits happens to match with SK_DEFAULT_STAMP, the final result
> > > > of sk->sk_stamp could be 0.
> > > >
> > > >   sock_recv_cmsgs()  ioctl(SIOCGSTAMP)      sock_recv_cmsgs()
> > > >   |                  |                      |
> > > >   |- if (sock_flag(sk, SOCK_TIMESTAMP))     |
> > > >   |                  |                      |
> > > >   |                  `- sock_set_flag(sk, SOCK_TIMESTAMP)
> > > >   |                                         |
> > > >   |                                          `- if (sock_flag(sk, SOCK_TIMESTAMP))
> > > >   `- if (sk->sk_stamp == SK_DEFAULT_STAMP)      `- sock_write_timestamp(sk, skb->tstamp)
> > > >       `- sock_write_timestamp(sk, 0)
> > > >
> > > > Even with READ_ONCE(), we could get the same result if READ_ONCE() precedes
> > > > WRITE_ONCE() because the SK_DEFAULT_STAMP check and WRITE_ONCE(sk_stamp, 0)
> > > > are not atomic.
> > > >
> > > > Let's avoid the race by cmpxchg() on 64-bits architecture or seqlock on
> > > > 32-bits machines.
> > > >
> > >
> > > I disagree. Please use WRITE_ONCE(), even if we know it is racy on 32bit.
> > >
> > > sock_read_timestamp() and sock_write_timestamp() already are racy, and
> > > we do not care.
> >
> > I think it's not racy since commit 3a0ed3e96197 ("sock: Make sock->sk_stamp
> > thread-safe"), which introduced seqlock in sock_read_timestamp() and
> > sock_write_timestamp().
> 
> Please note I do not care of 32bit.
> 
> It is definitely racy on 64bit.
> 
> Please look at
> 
> commit f75359f3ac855940c5718af10ba089b8977bf339
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Mon Nov 4 21:38:43 2019 -0800
> 
>     net: prevent load/store tearing on sk->sk_stamp
> 
> 
> We can not use cmpxchg() only in one place and not the others.

Ah, I understand.  I'll post v3 with this diff to silence KCSAN.

---8<---
diff --git a/include/net/sock.h b/include/net/sock.h
index 8b7ed7167243..656ea89f60ff 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2718,7 +2718,7 @@ static inline void sock_recv_cmsgs(struct msghdr *msg, struct sock *sk,
 		__sock_recv_cmsgs(msg, sk, skb);
 	else if (unlikely(sock_flag(sk, SOCK_TIMESTAMP)))
 		sock_write_timestamp(sk, skb->tstamp);
-	else if (unlikely(sk->sk_stamp == SK_DEFAULT_STAMP))
+	else if (unlikely(sock_read_timestamp(sk) == SK_DEFAULT_STAMP))
 		sock_write_timestamp(sk, 0);
 }
 
---8<---

Thank you!


> 
> cmpxchg() is expensive, we do not want it here on our fast path.
>
> Thanks.

