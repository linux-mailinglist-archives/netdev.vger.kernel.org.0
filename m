Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA3059C942
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 21:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237319AbiHVTtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 15:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235986AbiHVTts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 15:49:48 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598CCDDC
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 12:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661197788; x=1692733788;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NDutWsbdZd6JQRGpcjq8EJdcJyMoKGWwggRpLeVrr9Q=;
  b=fVtaxkvGgvxza9GHVH53As5PRA7y9lkB55Kxbn7RP34/FU0a8nfsnGG3
   wUo8GamDa26NU1BbGq6CQOpDltKwFmbjT8ETwJOG4hLsX5tNnYaZU7YQK
   yUfuRo6X65OzlsHPNiGNTI94GF5k2FIt6TMe4BPqYRAqgWFYkKBGOhxoP
   k=;
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-54c9d11f.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2022 19:49:37 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-54c9d11f.us-east-1.amazon.com (Postfix) with ESMTPS id 5DC71C042B;
        Mon, 22 Aug 2022 19:49:35 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Mon, 22 Aug 2022 19:49:34 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.158) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Mon, 22 Aug 2022 19:49:32 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH v3 net 05/17] ratelimit: Fix data-races in ___ratelimit().
Date:   Mon, 22 Aug 2022 12:49:24 -0700
Message-ID: <20220822194924.23501-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iJfWanX5xA3Qhp2LF0UJAU20WBbVjj2oMcbu2e43OXWcw@mail.gmail.com>
References: <CANn89iJfWanX5xA3Qhp2LF0UJAU20WBbVjj2oMcbu2e43OXWcw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.158]
X-ClientProxiedBy: EX13D24UWB001.ant.amazon.com (10.43.161.93) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 22 Aug 2022 12:22:35 -0700
> On Mon, Aug 22, 2022 at 12:15 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > From:   Eric Dumazet <edumazet@google.com>
> > Date:   Mon, 22 Aug 2022 12:00:11 -0700
> > > On Thu, Aug 18, 2022 at 11:29 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > >
> > > > While reading rs->interval and rs->burst, they can be changed
> > > > concurrently.  Thus, we need to add READ_ONCE() to their readers.
> > > >
> > > > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > > ---
> > > >  lib/ratelimit.c | 8 +++++---
> > > >  1 file changed, 5 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/lib/ratelimit.c b/lib/ratelimit.c
> > > > index e01a93f46f83..b59a1d3d0cc3 100644
> > > > --- a/lib/ratelimit.c
> > > > +++ b/lib/ratelimit.c
> > > > @@ -26,10 +26,12 @@
> > > >   */
> > > >  int ___ratelimit(struct ratelimit_state *rs, const char *func)
> > > >  {
> > > > +       int interval = READ_ONCE(rs->interval);
> > > > +       int burst = READ_ONCE(rs->burst);
> > >
> > > I thought rs->interval and rs->burst were constants...
> > >
> > > Can you point to the part where they are changed ?
> > >
> > > Ideally such a patch should also add corresponding WRITE_ONCE(), and
> > > comments to pair them,
> > >  this would really help reviewing it.
> >
> > In this case, &net_ratelimit_state.(burst|interval) are directly
> > passed to proc_handlers, and exactly the relation is unclear.
> >
> > As Jakub pointed out, two reads can be inconsistent, so I'll add
> > a spin lock in struct ratelimit_state and two dedicated proc
> > handlers for each member.
> 
> This seems overkill to me... Adding a comment explaining why a race
> (or inconsistency) is acceptable is enough I think.

Ok, I'll add a comment like this.

/* Paired with WRITE_ONCE() in .proc_handler(). (see: net_ratelimit_state)
 * Changing two values seperately could be inconsistent and some message
 * could be lost.
 */


> 
> Otherwise, we will have to review all other 'struct ratelimit_state'
> which expose
> in r/w mode their @interval or @burst field.
> 
> 
> >  Then, I'll add few more comments to
> > make that relation clear.
> >
> > Thanks for feedback!
> >
> >
> > > >         unsigned long flags;
> > > >         int ret;
> > > >
> > > > -       if (!rs->interval)
> > > > +       if (!interval)
> > > >                 return 1;
> > > >
> > > >         /*
> > > > @@ -44,7 +46,7 @@ int ___ratelimit(struct ratelimit_state *rs, const char *func)
> > > >         if (!rs->begin)
> > > >                 rs->begin = jiffies;
> > > >
> > > > -       if (time_is_before_jiffies(rs->begin + rs->interval)) {
> > > > +       if (time_is_before_jiffies(rs->begin + interval)) {
> > > >                 if (rs->missed) {
> > > >                         if (!(rs->flags & RATELIMIT_MSG_ON_RELEASE)) {
> > > >                                 printk_deferred(KERN_WARNING
> > > > @@ -56,7 +58,7 @@ int ___ratelimit(struct ratelimit_state *rs, const char *func)
> > > >                 rs->begin   = jiffies;
> > > >                 rs->printed = 0;
> > > >         }
> > > > -       if (rs->burst && rs->burst > rs->printed) {
> > > > +       if (burst && burst > rs->printed) {
> > > >                 rs->printed++;
> > > >                 ret = 1;
> > > >         } else {
> > > > --
> > > > 2.30.2

