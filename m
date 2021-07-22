Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80CD3D2F7E
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 00:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbhGVV0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 17:26:05 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:45411 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbhGVV0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 17:26:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1626991599; x=1658527599;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/9PIWzOI8QOovn6TxUzvAwaFD5zwIopfMKXHGp/8x04=;
  b=aSz2zQRIchqVOZ540QPK52tDfwsc4YWTHczasYJHmvao0i1ZwEg/xuMx
   WHM6CWfn5UpLBKUtSj3SRboQGT0uO67IT3bdaT1rFmaUzuvxKFeS5HEdU
   qvGt5BEfhiJZjgHVvIp57i+8sc3uHrb6GQsCR/FhG8zcoLXOzEJaOZ7dI
   E=;
X-IronPort-AV: E=Sophos;i="5.84,262,1620691200"; 
   d="scan'208";a="945656428"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 22 Jul 2021 22:06:37 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id 64B8B2836C6;
        Thu, 22 Jul 2021 22:06:34 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Thu, 22 Jul 2021 22:06:33 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.90) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Thu, 22 Jul 2021 22:06:29 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kafai@fb.com>
CC:     <ast@kernel.org>, <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <edumazet@google.com>, <kernel-team@fb.com>, <kuniyu@amazon.co.jp>,
        <ncardwell@google.com>, <netdev@vger.kernel.org>,
        <ycheng@google.com>, <yhs@fb.com>
Subject: Re: [PATCH v2 bpf-next 1/8] tcp: seq_file: Avoid skipping sk during tcp_seek_last_pos
Date:   Fri, 23 Jul 2021 07:06:26 +0900
Message-ID: <20210722220626.15150-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210722214256.ncuz6k5bjt4vgru6@kafai-mbp.dhcp.thefacebook.com>
References: <20210722214256.ncuz6k5bjt4vgru6@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.90]
X-ClientProxiedBy: EX13D39UWB004.ant.amazon.com (10.43.161.148) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Martin KaFai Lau <kafai@fb.com>
Date:   Thu, 22 Jul 2021 14:42:56 -0700
> On Fri, Jul 23, 2021 at 12:08:10AM +0900, Kuniyuki Iwashima wrote:
> > From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > Date:   Thu, 22 Jul 2021 23:16:37 +0900
> > > From:   Martin KaFai Lau <kafai@fb.com>
> > > Date:   Thu, 1 Jul 2021 13:05:41 -0700
> > > > st->bucket stores the current bucket number.
> > > > st->offset stores the offset within this bucket that is the sk to be
> > > > seq_show().  Thus, st->offset only makes sense within the same
> > > > st->bucket.
> > > > 
> > > > These two variables are an optimization for the common no-lseek case.
> > > > When resuming the seq_file iteration (i.e. seq_start()),
> > > > tcp_seek_last_pos() tries to continue from the st->offset
> > > > at bucket st->bucket.
> > > > 
> > > > However, it is possible that the bucket pointed by st->bucket
> > > > has changed and st->offset may end up skipping the whole st->bucket
> > > > without finding a sk.  In this case, tcp_seek_last_pos() currently
> > > > continues to satisfy the offset condition in the next (and incorrect)
> > > > bucket.  Instead, regardless of the offset value, the first sk of the
> > > > next bucket should be returned.  Thus, "bucket == st->bucket" check is
> > > > added to tcp_seek_last_pos().
> > > > 
> > > > The chance of hitting this is small and the issue is a decade old,
> > > > so targeting for the next tree.
> > > 
> > > Multiple read()s or lseek()+read() can call tcp_seek_last_pos().
> > > 
> > > IIUC, the problem happens when the sockets placed before the last shown
> > > socket in the list are closed between some read()s or lseek() and read().
> > > 
> > > I think there is still a case where bucket is valid but offset is invalid:
> > > 
> > >   listening_hash[1] -> sk1 -> sk2 -> sk3 -> nulls
> > >   listening_hash[2] -> sk4 -> sk5 -> nulls
> > > 
> > >   read(/proc/net/tcp)
> > >     end up with sk2
> > > 
> > >   close(sk1)
> > > 
> > >   listening_hash[1] -> sk2 -> sk3 -> nulls
> > >   listening_hash[2] -> sk4 -> sk5 -> nulls
> > > 
> > >   read(/proc/net/tcp) (resume)
> > >     offset = 2
> > > 
> > >     listening_get_next() returns sk2
> > > 
> > >     while (offset--)
> > >       1st loop listening_get_next() returns sk3 (bucket == st->bucket)
> > >       2nd loop listening_get_next() returns sk4 (bucket != st->bucket)
> > > 
> > >     show() starts from sk4
> > > 
> > >     only is sk3 skipped, but should be shown.
> > 
> > Sorry, this example is wrong.
> > We can handle this properly by testing bucket != st->bucket.
> > 
> > In the case below, we cannot check if the offset is valid or not by testing
> > the bucket.
> > 
> >   listening_hash[1] -> sk1 -> sk2 -> sk3 -> sk4 -> nulls
> > 
> >   read(/proc/net/tcp)
> >     end up with sk2
> > 
> >   close(sk1)
> > 
> >   listening_hash[1] -> sk2 -> sk3 -> sk4 -> nulls
> > 
> >   read(/proc/net/tcp) (resume)
> >     offset = 2
> > 
> >     listening_get_first() returns sk2
> > 
> >     while (offset--)
> >       1st loop listening_get_next() returns sk3 (bucket == st->bucket)
> >       2nd loop listening_get_next() returns sk4 (bucket == st->bucket)
> > 
> >     show() starts from sk4
> > 
> >     only is sk3 skipped, but should be shown.
> > 
> > 
> > > 
> > > In listening_get_next(), we can check if we passed through sk2, but this
> > > does not work well if sk2 itself is closed... then there are no way to
> > > check the offset is valid or not.
> > > 
> > > Handling this may be too much though, what do you think ?
> There will be cases that misses sk after releasing
> the bucket lock (and then things changed).  For example,
> another case could be sk_new is added to the head of the bucket,
> although it could arguably be treated as a legit miss since
> "cat /proc/net/tcp" has already been in-progress.
> 
> The chance of hitting m->buf limit and that bucket gets changed should be slim.
> If there is use case such that lhash2 (already hashed by port+addr) is still
> having a large bucket (e.g. many SO_REUSEPORT), it will be a better problem
> to solve first.  imo, remembering sk2 to solve the "cat /proc/net/tcp" alone
> does not worth it.

That makes sense.
Thank you for explaining!


> 
> Thanks for the review!
