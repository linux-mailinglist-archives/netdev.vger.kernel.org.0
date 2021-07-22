Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29BBA3D266B
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 17:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbhGVOai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 10:30:38 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:4237 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232559AbhGVOaA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 10:30:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1626966636; x=1658502636;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SO+pVmb17xrM3XvsP22uN+y1O5FVOJnzeiQSmT8FMAY=;
  b=vBak6lRykiQNfqAIp2zK0hd3sVZUFbs81HfEzIZSlEF1yqfTDiKdxr4k
   AwzYY2qHI+q08RR+IBFrhZgjv5r6egXvjJ90jcrPSF6xHmACMu8ebA54+
   LzHZy34gX0IeSLxktgU2fNZRC0P3HLFc8AqsamM47cyFDr8JHmt4anDAx
   g=;
X-IronPort-AV: E=Sophos;i="5.84,261,1620691200"; 
   d="scan'208";a="147393204"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-2b-baacba05.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 22 Jul 2021 15:08:35 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-baacba05.us-west-2.amazon.com (Postfix) with ESMTPS id A2512A1E15;
        Thu, 22 Jul 2021 15:08:31 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Thu, 22 Jul 2021 15:08:31 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.66) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Thu, 22 Jul 2021 15:08:14 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kafai@fb.com>
CC:     <kuniyu@amazon.co.jp>, <ast@kernel.org>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <edumazet@google.com>,
        <kernel-team@fb.com>, <ncardwell@google.com>,
        <netdev@vger.kernel.org>, <ycheng@google.com>, <yhs@fb.com>
Subject: Re: [PATCH v2 bpf-next 1/8] tcp: seq_file: Avoid skipping sk during tcp_seek_last_pos
Date:   Fri, 23 Jul 2021 00:08:10 +0900
Message-ID: <20210722150810.74315-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210722141637.68161-1-kuniyu@amazon.co.jp>
References: <20210722141637.68161-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.66]
X-ClientProxiedBy: EX13D23UWC002.ant.amazon.com (10.43.162.22) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Date:   Thu, 22 Jul 2021 23:16:37 +0900
> From:   Martin KaFai Lau <kafai@fb.com>
> Date:   Thu, 1 Jul 2021 13:05:41 -0700
> > st->bucket stores the current bucket number.
> > st->offset stores the offset within this bucket that is the sk to be
> > seq_show().  Thus, st->offset only makes sense within the same
> > st->bucket.
> > 
> > These two variables are an optimization for the common no-lseek case.
> > When resuming the seq_file iteration (i.e. seq_start()),
> > tcp_seek_last_pos() tries to continue from the st->offset
> > at bucket st->bucket.
> > 
> > However, it is possible that the bucket pointed by st->bucket
> > has changed and st->offset may end up skipping the whole st->bucket
> > without finding a sk.  In this case, tcp_seek_last_pos() currently
> > continues to satisfy the offset condition in the next (and incorrect)
> > bucket.  Instead, regardless of the offset value, the first sk of the
> > next bucket should be returned.  Thus, "bucket == st->bucket" check is
> > added to tcp_seek_last_pos().
> > 
> > The chance of hitting this is small and the issue is a decade old,
> > so targeting for the next tree.
> 
> Multiple read()s or lseek()+read() can call tcp_seek_last_pos().
> 
> IIUC, the problem happens when the sockets placed before the last shown
> socket in the list are closed between some read()s or lseek() and read().
> 
> I think there is still a case where bucket is valid but offset is invalid:
> 
>   listening_hash[1] -> sk1 -> sk2 -> sk3 -> nulls
>   listening_hash[2] -> sk4 -> sk5 -> nulls
> 
>   read(/proc/net/tcp)
>     end up with sk2
> 
>   close(sk1)
> 
>   listening_hash[1] -> sk2 -> sk3 -> nulls
>   listening_hash[2] -> sk4 -> sk5 -> nulls
> 
>   read(/proc/net/tcp) (resume)
>     offset = 2
> 
>     listening_get_next() returns sk2
> 
>     while (offset--)
>       1st loop listening_get_next() returns sk3 (bucket == st->bucket)
>       2nd loop listening_get_next() returns sk4 (bucket != st->bucket)
> 
>     show() starts from sk4
> 
>     only is sk3 skipped, but should be shown.

Sorry, this example is wrong.
We can handle this properly by testing bucket != st->bucket.

In the case below, we cannot check if the offset is valid or not by testing
the bucket.

  listening_hash[1] -> sk1 -> sk2 -> sk3 -> sk4 -> nulls

  read(/proc/net/tcp)
    end up with sk2

  close(sk1)

  listening_hash[1] -> sk2 -> sk3 -> sk4 -> nulls

  read(/proc/net/tcp) (resume)
    offset = 2

    listening_get_first() returns sk2

    while (offset--)
      1st loop listening_get_next() returns sk3 (bucket == st->bucket)
      2nd loop listening_get_next() returns sk4 (bucket == st->bucket)

    show() starts from sk4

    only is sk3 skipped, but should be shown.


> 
> In listening_get_next(), we can check if we passed through sk2, but this
> does not work well if sk2 itself is closed... then there are no way to
> check the offset is valid or not.
> 
> Handling this may be too much though, what do you think ?
> 
