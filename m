Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5214E24C440
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 19:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730529AbgHTRL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 13:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730522AbgHTRL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 13:11:26 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4CF3C061386
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 10:11:25 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id u189so2969477ybg.17
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 10:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=Ugou+I4rzj+9uQFCuzQnBcn1RiOI69RVVmOwp83QRW0=;
        b=p+PeHxk33ogmlP3/o0eJgU6tzzESrQYmNZzWZ0XdCnuNfjKboWxXWZNF+A3/PYq26Z
         fQEmPfossD2U3n154N7g+jaAosT0BoTNCY5Q3cQk33Tx7CIf6YZV+YPujZgctFYvGTof
         N+8JT2IoKYEDbpilRFySGWUZ3iZWXAaPgzAbras1xvtjvRwj4OZhTTU2n/DE8U4GagK/
         JMu45UeNnuYEhXWdkZNLkfZwl6xIW1mJeSQA/4nJ6AEbmcOgt69dgosSXZg0b7pqJEOI
         XEdcmiW9dcbTOtyR8yJkrCqBEqNHjov+/HJlQm7HuKcaURqTVFmBvnRC1nQRZbQwUAzw
         Uhcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Ugou+I4rzj+9uQFCuzQnBcn1RiOI69RVVmOwp83QRW0=;
        b=k36n4tVH3uSoXaLMjqd1R1m+fl8FQJ9r9wTlNRhT3I40NaYgt9VSfk4Qo2MZGERI2v
         Bh6rGcamtU5Yp3Pmg3mZZwa+5MkdL93elxLUAz6Gd6ep43Cli78xnKfzCUjj0ElNcehA
         rFQNcLCv4ZTCswimU1QJ8qJxW5R3+q6oXbtA6UjkNUy/EoAup4S0p6AMRO1vvVMv3YVo
         H1wSTujQSYK2jBHMOjCzCEMowB+274K5GTi4KcCuv2isf4fpyrpKjgWpyaVc2DIFfbzF
         +I6+PGdK7azELCI3r1Q04XLvyz0ddP/fhApHnSIMUNzcaHJHTckPA+EeUBUrpy5or2AH
         XAHA==
X-Gm-Message-State: AOAM532X3q1S4Amhg784m/x7BMwhA4neuj+adwiaA8sKZPOum88NGwjJ
        uIJnENTPdSAJZwYqevVxEToZdJVaBS98yw==
X-Google-Smtp-Source: ABdhPJypOk5W8XY+5MFI60/xJPaMgdgI7Y1Va5AQCiU/aTEAroRxrkavqKfpJ9QBhY0lPvmb1LwKi5TaJp8m4g==
X-Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
 (user=edumazet job=sendgmr) by 2002:a25:846:: with SMTP id
 67mr6122655ybi.474.1597943485019; Thu, 20 Aug 2020 10:11:25 -0700 (PDT)
Date:   Thu, 20 Aug 2020 10:11:16 -0700
In-Reply-To: <20200820171118.1822853-1-edumazet@google.com>
Message-Id: <20200820171118.1822853-2-edumazet@google.com>
Mime-Version: 1.0
References: <20200820171118.1822853-1-edumazet@google.com>
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
Subject: [PATCH net-next 1/3] selftests: net: tcp_mmap: use madvise(MADV_DONTNEED)
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Arjun Roy <arjunroy@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When TCP_ZEROCOPY_RECEIVE operation has been added,
I made the mistake of automatically un-mapping prior
content before mapping new pages.

This has the unfortunate effect of adding potentially long
MMU operations (like TLB flushes) while socket lock is held.

Using madvise(MADV_DONTNEED) right after pages has been used
has two benefits :

1) This releases pages sooner, allowing pages to be recycled
if they were part of a page pool in a NIC driver.

2) No more long unmap operations while preventing immediate
processing of incoming packets.

The cost of the added system call is small enough.

Arjun will submit a kernel patch allowing to opt out from
the unmap attempt in tcp_zerocopy_receive()

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Arjun Roy <arjunroy@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
---
 tools/testing/selftests/net/tcp_mmap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/net/tcp_mmap.c b/tools/testing/selftests/net/tcp_mmap.c
index a61b7b3da5496285876b0e16b18a3060850b0803..59ec0b59f7b76ff75685bd96901d8237e0665b2b 100644
--- a/tools/testing/selftests/net/tcp_mmap.c
+++ b/tools/testing/selftests/net/tcp_mmap.c
@@ -179,6 +179,10 @@ void *child_thread(void *arg)
 				total_mmap += zc.length;
 				if (xflg)
 					hash_zone(addr, zc.length);
+				/* It is more efficient to unmap the pages right now,
+				 * instead of doing this in next TCP_ZEROCOPY_RECEIVE.
+				 */
+				madvise(addr, zc.length, MADV_DONTNEED);
 				total += zc.length;
 			}
 			if (zc.recv_skip_hint) {
-- 
2.28.0.297.g1956fa8f8d-goog

