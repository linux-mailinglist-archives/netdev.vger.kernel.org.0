Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA699695273
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 21:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjBMU72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 15:59:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBMU71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 15:59:27 -0500
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC50B26AE;
        Mon, 13 Feb 2023 12:59:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1676321966; x=1707857966;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7GGo37vfeM/q0M9f7i5/owHCwmTU2ilbzg1WlYDczYA=;
  b=CnRwUqOJL3WW/dVH9GWnfmhEPlnv3iBCcLpqWtrqJmKQzFxlXTrR6/fX
   Sm1N54sTJRPTLlzvdg85ftEWrQJbCGoEoDiYFfR5SHCHHTiMAlDSzmRHe
   VNXKr1KUNuTmv6sd8An4KocLdQ9jh7e4VOd807xwvfgRCzN5eHpECHiX1
   M=;
X-IronPort-AV: E=Sophos;i="5.97,294,1669075200"; 
   d="scan'208";a="292449900"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-94edd59b.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 20:59:01 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-m6i4x-94edd59b.us-west-2.amazon.com (Postfix) with ESMTPS id DDBB3414BA;
        Mon, 13 Feb 2023 20:59:00 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Mon, 13 Feb 2023 20:59:00 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.56) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.24;
 Mon, 13 Feb 2023 20:58:57 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <gregkh@linuxfoundation.org>
CC:     <kuniyu@amazon.com>, <netdev@vger.kernel.org>,
        <regressions@lists.linux.dev>, <stable@vger.kernel.org>,
        <w@1wt.eu>, <winter@winter.cafe>
Subject: Re: [REGRESSION] 5.15.88 and onwards no longer return EADDRINUSE from bind
Date:   Mon, 13 Feb 2023 12:58:35 -0800
Message-ID: <20230213205835.56151-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <Y+p4AJHkP8JUf4KB@kroah.com>
References: <Y+p4AJHkP8JUf4KB@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.56]
X-ClientProxiedBy: EX13D44UWB004.ant.amazon.com (10.43.161.205) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SORTED_RECIPS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Greg KH <gregkh@linuxfoundation.org>
Date:   Mon, 13 Feb 2023 18:48:48 +0100
> On Mon, Feb 13, 2023 at 08:44:55AM -0800, Kuniyuki Iwashima wrote:
> > From:   Willy Tarreau <w@1wt.eu>
> > Date:   Mon, 13 Feb 2023 08:52:34 +0100
> > > Hi Greg,
> > > 
> > > On Mon, Feb 13, 2023 at 08:25:34AM +0100, Greg KH wrote:
> > > > On Mon, Feb 13, 2023 at 05:27:03AM +0100, Willy Tarreau wrote:
> > > > > Hi,
> > > > > 
> > > > > [CCed netdev]
> > > > > 
> > > > > On Sun, Feb 12, 2023 at 10:38:40PM -0500, Winter wrote:
> > > > > > Hi all,
> > > > > > 
> > > > > > I'm facing the same issue as
> > > > > > https://lore.kernel.org/stable/CAFsF8vL4CGFzWMb38_XviiEgxoKX0GYup=JiUFXUOmagdk9CRg@mail.gmail.com/,
> > > > > > but on 5.15. I've bisected it across releases to 5.15.88, and can reproduce
> > > > > > on 5.15.93.
> > > > > > 
> > > > > > However, I cannot seem to find the identified problematic commit in the 5.15
> > > > > > branch, so I'm unsure if this is a different issue or not.
> > > > > > 
> > > > > > There's a few ways to reproduce this issue, but the one I've been using is
> > > > > > running libuv's (https://github.com/libuv/libuv) tests, specifically tests
> > > > > > 271 and 277.
> > > > > 
> > > > > >From the linked patch:
> > > > > 
> > > > >   https://lore.kernel.org/stable/20221228144337.512799851@linuxfoundation.org/
> > > > 
> > > > But that commit only ended up in 6.0.y, not 5.15, so how is this an
> > > > issue in 5.15.y?
> > > 
> > > Hmmm I plead -ENOCOFFEE on my side, I hadn't notice the "can't find the
> > > problematic commit", you're right indeed.
> > > 
> > > However if the issue happened in 5.15.88, the only part touching the
> > > network listening area is this one which may introduce an EINVAL on
> > > one listening path, but that seems unrelated to me given that it's
> > > only for ULP that libuv doesn't seem to be using:
> > > 
> > >   dadd0dcaa67d ("net/ulp: prevent ULP without clone op from entering the LISTEN status")
> > 
> > This commit accidentally backports a part of 7a7160edf1bf ("net: Return
> > errno in sk->sk_prot->get_port().") and removed err = -EADDRINUSE in
> > inet_csk_listen_start().  Then, listen() will return 0 even if ->get_port()
> > actually fails and returns 1.
> > 
> > I can send a small revert or a whole backport, but which is preferable ?
> > The original patch is not for stable, but it will make future backports
> > easy.
> 
> A whole revert is probably best, if it's not needed.  But if it is, a
> fix up would be fine to get as well.

dadd0dcaa67d is needed to fix potential double-free, so could you queue
this fixup for 5.15. ?

---8<---
From ad319ace8b5c1dd5105b7263b7ccfd0ba0926551 Mon Sep 17 00:00:00 2001
From: Kuniyuki Iwashima <kuniyu@amazon.com>
Date: Mon, 13 Feb 2023 20:45:48 +0000
Subject: [PATCH] tcp: Fix listen() regression in 5.15.88.

When we backport dadd0dcaa67d ("net/ulp: prevent ULP without clone op from
entering the LISTEN status"), we have accidentally backported a part of
7a7160edf1bf ("net: Return errno in sk->sk_prot->get_port().") and removed
err = -EADDRINUSE in inet_csk_listen_start().

Thus, listen() no longer returns -EADDRINUSE even if ->get_port() failed
as reported in [0].

We set -EADDRINUSE to err just before ->get_port() to fix the regression.

[0]: https://lore.kernel.org/stable/EF8A45D0-768A-4CD5-9A8A-0FA6E610ABF7@winter.cafe/

Reported-by: Winter <winter@winter.cafe>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/inet_connection_sock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index a86140ff093c..29ec42c1f5d0 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1070,6 +1070,7 @@ int inet_csk_listen_start(struct sock *sk, int backlog)
 	 * It is OK, because this socket enters to hash table only
 	 * after validation is complete.
 	 */
+	err = -EADDRINUSE;
 	inet_sk_state_store(sk, TCP_LISTEN);
 	if (!sk->sk_prot->get_port(sk, inet->inet_num)) {
 		inet->inet_sport = htons(inet->inet_num);
-- 
2.38.1
---8<---

Thanks,
Kuniyuki
