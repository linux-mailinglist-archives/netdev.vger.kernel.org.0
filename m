Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C904C381597
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 05:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234242AbhEODtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 23:49:46 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:49126 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbhEODtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 23:49:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1621050514; x=1652586514;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sx6X6iGWIuUFegawsI8UjhCFW9TvkVrGkXDiyldSErQ=;
  b=IpmIQJsYYgTq/G/LqqWQX8RrgIFQO84NU/6WdGVq3DxYQPlrX+6gCYV3
   oU7rYQDOvYZp0qz0YQLedBOomACCS5c67Y9UviJ2QFdPC0vawgRqbOkhN
   ul9YeE10KQCM8a5zzuYmgGjfHagfFgXaWUMnU6QiqYpJsj0iiIBVpeYTH
   U=;
X-IronPort-AV: E=Sophos;i="5.82,300,1613433600"; 
   d="scan'208";a="107902101"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-397e131e.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-4101.iad4.amazon.com with ESMTP; 15 May 2021 03:48:32 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-397e131e.us-west-2.amazon.com (Postfix) with ESMTPS id CBE48A25C0;
        Sat, 15 May 2021 03:48:30 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Sat, 15 May 2021 03:48:30 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.239) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Sat, 15 May 2021 03:48:25 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kafai@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <andrii@kernel.org>, <ast@kernel.org>,
        <benh@amazon.com>, <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 bpf-next 00/11] Socket migration for SO_REUSEPORT.
Date:   Sat, 15 May 2021 12:48:21 +0900
Message-ID: <20210515034821.79264-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210514062625.5zg626xquffvmrr7@kafai-mbp>
References: <20210514062625.5zg626xquffvmrr7@kafai-mbp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.239]
X-ClientProxiedBy: EX13D07UWA004.ant.amazon.com (10.43.160.32) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Martin KaFai Lau <kafai@fb.com>
Date:   Thu, 13 May 2021 23:26:25 -0700
> On Fri, May 14, 2021 at 08:23:00AM +0900, Kuniyuki Iwashima wrote:
> > From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > Date:   Thu, 13 May 2021 14:27:13 -0700
> > > On Sun, May 9, 2021 at 8:45 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> > > >
> > > > The SO_REUSEPORT option allows sockets to listen on the same port and to
> > > > accept connections evenly. However, there is a defect in the current
> > > > implementation [1]. When a SYN packet is received, the connection is tied
> > > > to a listening socket. Accordingly, when the listener is closed, in-flight
> > > > requests during the three-way handshake and child sockets in the accept
> > > > queue are dropped even if other listeners on the same port could accept
> > > > such connections.
> > [...]
> > > 
> > > One test is failing in CI ([0]), please take a look.
> > > 
> > >   [0] https://travis-ci.com/github/kernel-patches/bpf/builds/225784969 
> > 
> > Thank you for checking.
> > 
> > The test needs to drop SYN+ACK and currently it is done by iptables or
                           ^^^^^^^
                           the final ACK of 3WHS
Sorry, this was typo.


> > ip6tables. But it seems that I should not use them. Should this be done
> > by XDP?
> or drop it at a bpf_prog@tc-egress.
> 
> I also don't have iptables in my kconfig and I had to add them
> to run this test.  None of the test_progs depends on iptables also.

I'll rewrite the dropping part with XDP or TC.
Thank you.


> 
> > 
> > ---8<---
> > iptables v1.8.5 (legacy): can't initialize iptables table `filter': Table does not exist (do you need to insmod?)
> > Perhaps iptables or your kernel needs to be upgraded.
> > ip6tables v1.8.5 (legacy): can't initialize ip6tables table `filter': Table does not exist (do you need to insmod?)
> > Perhaps ip6tables or your kernel needs to be upgraded.
> > ---8<---
