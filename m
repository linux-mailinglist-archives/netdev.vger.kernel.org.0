Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD83568F20
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 18:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233823AbiGFQ22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 12:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233514AbiGFQ20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 12:28:26 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCBBDB7;
        Wed,  6 Jul 2022 09:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657124907; x=1688660907;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PhXxi/XavP96zC3WSzhoIHhyWbZryHgf8iD5yTBli5s=;
  b=GrB9ND2Yc/sW0G50m9daBrFDbpOlCTKvB/on26lznszvlKN5AWilGxTq
   93IGEQjyBax8iNzNvD8mCSQieKb1oCvnPzUWnlOxyu8ub+BbSy7AH6Ki2
   xa7tUO+cq+RJlOSH57vExR+0SbVcQSkTNOhOFXlaJHmZDuY3dft/kBsjX
   A=;
X-IronPort-AV: E=Sophos;i="5.92,250,1650931200"; 
   d="scan'208";a="218701716"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-7a21ed79.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 06 Jul 2022 16:28:15 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-7a21ed79.us-east-1.amazon.com (Postfix) with ESMTPS id ACBBE22006A;
        Wed,  6 Jul 2022 16:28:10 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 6 Jul 2022 16:28:04 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.106) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 6 Jul 2022 16:28:01 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <rostedt@goodmis.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>,
        <keescook@chromium.org>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.com>, <linux-kernel@vger.kernel.org>,
        <mcgrof@kernel.org>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <satoru.moriya@hds.com>, <yzaikin@google.com>
Subject: Re: [PATCH v1 net 11/16] net: Fix a data-race around sysctl_mem.
Date:   Wed, 6 Jul 2022 09:27:53 -0700
Message-ID: <20220706162753.47894-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220706092711.28ce57e6@gandalf.local.home>
References: <20220706092711.28ce57e6@gandalf.local.home>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.106]
X-ClientProxiedBy: EX13D19UWC001.ant.amazon.com (10.43.162.64) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Steven Rostedt <rostedt@goodmis.org>
Date:   Wed, 6 Jul 2022 09:27:11 -0400
> On Wed, 6 Jul 2022 09:17:07 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Tue, 5 Jul 2022 22:21:25 -0700
> > Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > 
> > > --- a/include/trace/events/sock.h
> > > +++ b/include/trace/events/sock.h
> > > @@ -122,9 +122,9 @@ TRACE_EVENT(sock_exceed_buf_limit,
> > >  
> > >  	TP_printk("proto:%s sysctl_mem=%ld,%ld,%ld allocated=%ld sysctl_rmem=%d rmem_alloc=%d sysctl_wmem=%d wmem_alloc=%d wmem_queued=%d kind=%s",
> > >  		__entry->name,
> > > -		__entry->sysctl_mem[0],
> > > -		__entry->sysctl_mem[1],
> > > -		__entry->sysctl_mem[2],
> > > +		READ_ONCE(__entry->sysctl_mem[0]),
> > > +		READ_ONCE(__entry->sysctl_mem[1]),
> > > +		READ_ONCE(__entry->sysctl_mem[2]),  
> > 
> > This is not reading anything to do with sysctl. It's reading the content of
> > what was recorded in the ring buffer.
> > 
> > That is, the READ_ONCE() here is not necessary, and if anything will break
> > user space parsing, as this is exported to user space to tell it how to
> > read the binary format in the ring buffer.
> 
> I take that back. Looking at the actual trace event, it is pointing to
> sysctl memory, which is a major bug.
> 
> TRACE_EVENT(sock_exceed_buf_limit,
> 
>         TP_PROTO(struct sock *sk, struct proto *prot, long allocated, int kind),
> 
>         TP_ARGS(sk, prot, allocated, kind),
> 
>         TP_STRUCT__entry(
>                 __array(char, name, 32)
>                 __field(long *, sysctl_mem)
> 
> sysctl_mem is a pointer.
> 
>                 __field(long, allocated)
>                 __field(int, sysctl_rmem)
>                 __field(int, rmem_alloc)
>                 __field(int, sysctl_wmem)
>                 __field(int, wmem_alloc)
>                 __field(int, wmem_queued)
>                 __field(int, kind)
>         ),
> 
>         TP_fast_assign(
>                 strncpy(__entry->name, prot->name, 32);
> 
>                 __entry->sysctl_mem = prot->sysctl_mem;
> 
> 
> They save the pointer **IN THE RING BUFFER**!!!
> 
>                 __entry->allocated = allocated;
>                 __entry->sysctl_rmem = sk_get_rmem0(sk, prot);
>                 __entry->rmem_alloc = atomic_read(&sk->sk_rmem_alloc);
>                 __entry->sysctl_wmem = sk_get_wmem0(sk, prot);
>                 __entry->wmem_alloc = refcount_read(&sk->sk_wmem_alloc);
>                 __entry->wmem_queued = READ_ONCE(sk->sk_wmem_queued);
>                 __entry->kind = kind;
>         ),
> 
>         TP_printk("proto:%s sysctl_mem=%ld,%ld,%ld allocated=%ld sysctl_rmem=%d rmem_alloc=%d sysctl_wmem=%d wmem_alloc=%d wmem_queued=%d kind=%s",
>                 __entry->name,
>                 __entry->sysctl_mem[0],
>                 __entry->sysctl_mem[1],
>                 __entry->sysctl_mem[2],
> 
> They are now reading a stale pointer, which can be read at any time. That
> is, you get the information of what is in sysctl_mem at the time the ring
> buffer is read (which is useless from user space), and not at the time of
> the event.
> 
> Thanks for pointing this out. This needs to be fixed.

For the record, Steve fixed this properly here, so I'll drop the tracing
part in v2.
https://lore.kernel.org/netdev/20220706105040.54fc03b0@gandalf.local.home/
