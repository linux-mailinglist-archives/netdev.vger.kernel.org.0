Return-Path: <netdev+bounces-916-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EDF86FB5D8
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 19:20:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E4701C20A41
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 17:20:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76702566F;
	Mon,  8 May 2023 17:20:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0AB2100
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 17:20:37 +0000 (UTC)
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256A71A2
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 10:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1683566437; x=1715102437;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ysnBMJuln0pntuWAgqKQ0kTagyLcYLXii/ePFb4UZwo=;
  b=StIZ0+HwnY3p+wnlqlWQW9YohqPY2brWsm3GJRfUgwfJoE9bRGsUEXmG
   OklW/4FjKGdgAVCdeJOwZAn+A6aT1b2Kay64n3AMp0IaIcNzRqt7MTZdU
   wYnZ7k0XsV/xzU6Yeg/uKLgW+TFXsadARnMtT6Wh4ORe3uZgiDpfd+UFr
   E=;
X-IronPort-AV: E=Sophos;i="5.99,259,1677542400"; 
   d="scan'208";a="283140628"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-9694bb9e.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2023 17:20:31 +0000
Received: from EX19MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
	by email-inbound-relay-iad-1e-m6i4x-9694bb9e.us-east-1.amazon.com (Postfix) with ESMTPS id 587C9830E3;
	Mon,  8 May 2023 17:20:28 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 8 May 2023 17:20:27 +0000
Received: from 88665a182662.ant.amazon.com.com (10.187.170.41) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 8 May 2023 17:20:24 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <edumazet@google.com>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <kuni1840@gmail.com>,
	<kuniyu@amazon.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
	<syzkaller@googlegroups.com>
Subject: Re: [PATCH v2 net] net: Fix sk->sk_stamp race in sock_recv_cmsgs().
Date: Mon, 8 May 2023 10:20:16 -0700
Message-ID: <20230508172016.49942-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89i+JJ3747u5B89XMzxHQXgHiiXmftGZd2LV-ejJ3-g68CQ@mail.gmail.com>
References: <CANn89i+JJ3747u5B89XMzxHQXgHiiXmftGZd2LV-ejJ3-g68CQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.187.170.41]
X-ClientProxiedBy: EX19D032UWB003.ant.amazon.com (10.13.139.165) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
	T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Eric Dumazet <edumazet@google.com>
Date: Mon, 8 May 2023 19:08:58 +0200
> On Mon, May 8, 2023 at 6:58 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > KCSAN found a data race in sock_recv_cmsgs() [0] where the read access
> > to sk->sk_stamp needs READ_ONCE().
> >
> > Also, there is another race like below.  If the torn load of the high
> > 32-bits precedes WRITE_ONCE(sk, skb->tstamp) and later the written
> > lower 32-bits happens to match with SK_DEFAULT_STAMP, the final result
> > of sk->sk_stamp could be 0.
> >
> >   sock_recv_cmsgs()  ioctl(SIOCGSTAMP)      sock_recv_cmsgs()
> >   |                  |                      |
> >   |- if (sock_flag(sk, SOCK_TIMESTAMP))     |
> >   |                  |                      |
> >   |                  `- sock_set_flag(sk, SOCK_TIMESTAMP)
> >   |                                         |
> >   |                                          `- if (sock_flag(sk, SOCK_TIMESTAMP))
> >   `- if (sk->sk_stamp == SK_DEFAULT_STAMP)      `- sock_write_timestamp(sk, skb->tstamp)
> >       `- sock_write_timestamp(sk, 0)
> >
> > Even with READ_ONCE(), we could get the same result if READ_ONCE() precedes
> > WRITE_ONCE() because the SK_DEFAULT_STAMP check and WRITE_ONCE(sk_stamp, 0)
> > are not atomic.
> >
> > Let's avoid the race by cmpxchg() on 64-bits architecture or seqlock on
> > 32-bits machines.
> >
> 
> I disagree. Please use WRITE_ONCE(), even if we know it is racy on 32bit.
> 
> sock_read_timestamp() and sock_write_timestamp() already are racy, and
> we do not care.

I think it's not racy since commit 3a0ed3e96197 ("sock: Make sock->sk_stamp
thread-safe"), which introduced seqlock in sock_read_timestamp() and
sock_write_timestamp().

