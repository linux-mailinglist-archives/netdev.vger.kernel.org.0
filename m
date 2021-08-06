Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A77FF3E1FF1
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 02:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240606AbhHFAWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 20:22:25 -0400
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:50966 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238757AbhHFAWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 20:22:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1628209327; x=1659745327;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uJuIXj/lwZ9S5dnXjWu54ZDuIjhbraez6ckXcvhlYCg=;
  b=Th3xFzezcUyu7S4HNlkgVmkvyQX6nrH448GDqY/CFThL3RheIFf1hqxh
   nr+iuktgH7NnLQ158C7ffZreTv6XXB0+m3Huabcjfs+X//2rBKOpphbjn
   +fuZgdOiubhwq6m2j9jU2nTb1Nfij2fjCqjQJHU38B18NNMua/qqNbn1J
   8=;
X-IronPort-AV: E=Sophos;i="5.84,299,1620691200"; 
   d="scan'208";a="17391139"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 06 Aug 2021 00:22:07 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com (Postfix) with ESMTPS id 9EFA0A1EE6;
        Fri,  6 Aug 2021 00:22:06 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Fri, 6 Aug 2021 00:22:05 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.75) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Fri, 6 Aug 2021 00:22:00 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <yhs@fb.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <john.fastabend@gmail.com>, <kafai@fb.com>,
        <kpsingh@kernel.org>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.co.jp>, <netdev@vger.kernel.org>,
        <songliubraving@fb.com>
Subject: Re: [PATCH v3 bpf-next 1/2] bpf: af_unix: Implement BPF iterator for UNIX domain socket.
Date:   Fri, 6 Aug 2021 09:21:56 +0900
Message-ID: <20210806002156.12075-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <442b59b1-f7db-6bce-8fd8-d411ddec0956@fb.com>
References: <442b59b1-f7db-6bce-8fd8-d411ddec0956@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.75]
X-ClientProxiedBy: EX13D31UWA002.ant.amazon.com (10.43.160.82) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Yonghong Song <yhs@fb.com>
Date:   Thu, 5 Aug 2021 09:53:40 -0700
> On 8/4/21 12:08 AM, Kuniyuki Iwashima wrote:
> > This patch implements the BPF iterator for the UNIX domain socket and
> > exports some functions under GPL for the CONFIG_UNIX=m case.
> > 
> > Currently, the batch optimization introduced for the TCP iterator in the
> > commit 04c7820b776f ("bpf: tcp: Bpf iter batching and lock_sock") is not
> > applied.  It will require replacing the big lock for the hash table with
> > small locks for each hash list not to block other processes.
> > 
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > ---
> >   fs/proc/proc_net.c      |  2 +
> >   include/linux/btf_ids.h |  3 +-
> >   kernel/bpf/bpf_iter.c   |  3 ++
> >   net/core/filter.c       |  1 +
> >   net/unix/af_unix.c      | 93 +++++++++++++++++++++++++++++++++++++++++
> >   5 files changed, 101 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
> > index 15c2e55d2ed2..887a8102da9f 100644
> > --- a/fs/proc/proc_net.c
> > +++ b/fs/proc/proc_net.c
> > @@ -91,6 +91,7 @@ int bpf_iter_init_seq_net(void *priv_data, struct bpf_iter_aux_info *aux)
> >   #endif
> >   	return 0;
> >   }
> > +EXPORT_SYMBOL_GPL(bpf_iter_init_seq_net);
> 
> bpf_iter does not support modules for now as it is implemented before 
> module btf support. It needs some changes.
> For example, currently bpf_iter only caches/uses the vmlinux btf_id
> and module obj_id and module btf_id is not used.
> One example is ipv6 and bpf_iter is guarded with IS_BUILTIN(CONFIG_IPV6).
> 
> So you could (1) add btf_iter support module btf in this patch set, or
> (2). check IS_BUILTIN(CONFIG_UNIX). (2) might be easier and you can have
> a subsequent patch set to add module support for bpf_iter. But it is
> up to you.

I'll add IS_BUILTIN() check in the next spin and give a try to (1).
Thanks for review!
