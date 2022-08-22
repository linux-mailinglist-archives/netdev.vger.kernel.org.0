Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03A5A59C859
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 21:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237808AbiHVTQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 15:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238617AbiHVTPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 15:15:45 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4EA933A0D
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 12:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661195720; x=1692731720;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yqmTh0yOzKJNzpsluSAe28pISuUW/tylnBtaOGH6xq4=;
  b=mRjor89Dqf+9SASGPA77SithAfn75rBHydIKUzATAWHlt7BHkeifMDgt
   xQYLMbWqgmOuQssqmgHeDjtP3DyxAjyGashzRe1+qf31vrnbsyc3ks4ik
   CuejGKRncM2K6zRGOMN/NJhTsCvUHgGtO9bVohetcCrIa6pZVa96bODrl
   U=;
X-IronPort-AV: E=Sophos;i="5.93,255,1654560000"; 
   d="scan'208";a="251756483"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-87b71607.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2022 19:14:59 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-87b71607.us-east-1.amazon.com (Postfix) with ESMTPS id 5FA34142CDA;
        Mon, 22 Aug 2022 19:14:56 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Mon, 22 Aug 2022 19:14:55 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.158) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Mon, 22 Aug 2022 19:14:53 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH v3 net 05/17] ratelimit: Fix data-races in ___ratelimit().
Date:   Mon, 22 Aug 2022 12:14:45 -0700
Message-ID: <20220822191445.21807-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89i+amoiCtNuGO6e1dx=9vfdfQSe09MZ7iRKQ+sdo6K=uzA@mail.gmail.com>
References: <CANn89i+amoiCtNuGO6e1dx=9vfdfQSe09MZ7iRKQ+sdo6K=uzA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.158]
X-ClientProxiedBy: EX13D17UWC003.ant.amazon.com (10.43.162.206) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 22 Aug 2022 12:00:11 -0700
> On Thu, Aug 18, 2022 at 11:29 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > While reading rs->interval and rs->burst, they can be changed
> > concurrently.  Thus, we need to add READ_ONCE() to their readers.
> >
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > ---
> >  lib/ratelimit.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/lib/ratelimit.c b/lib/ratelimit.c
> > index e01a93f46f83..b59a1d3d0cc3 100644
> > --- a/lib/ratelimit.c
> > +++ b/lib/ratelimit.c
> > @@ -26,10 +26,12 @@
> >   */
> >  int ___ratelimit(struct ratelimit_state *rs, const char *func)
> >  {
> > +       int interval = READ_ONCE(rs->interval);
> > +       int burst = READ_ONCE(rs->burst);
> 
> I thought rs->interval and rs->burst were constants...
> 
> Can you point to the part where they are changed ?
> 
> Ideally such a patch should also add corresponding WRITE_ONCE(), and
> comments to pair them,
>  this would really help reviewing it.

In this case, &net_ratelimit_state.(burst|interval) are directly
passed to proc_handlers, and exactly the relation is unclear.

As Jakub pointed out, two reads can be inconsistent, so I'll add
a spin lock in struct ratelimit_state and two dedicated proc
handlers for each member.  Then, I'll add few more comments to
make that relation clear.

Thanks for feedback!


> >         unsigned long flags;
> >         int ret;
> >
> > -       if (!rs->interval)
> > +       if (!interval)
> >                 return 1;
> >
> >         /*
> > @@ -44,7 +46,7 @@ int ___ratelimit(struct ratelimit_state *rs, const char *func)
> >         if (!rs->begin)
> >                 rs->begin = jiffies;
> >
> > -       if (time_is_before_jiffies(rs->begin + rs->interval)) {
> > +       if (time_is_before_jiffies(rs->begin + interval)) {
> >                 if (rs->missed) {
> >                         if (!(rs->flags & RATELIMIT_MSG_ON_RELEASE)) {
> >                                 printk_deferred(KERN_WARNING
> > @@ -56,7 +58,7 @@ int ___ratelimit(struct ratelimit_state *rs, const char *func)
> >                 rs->begin   = jiffies;
> >                 rs->printed = 0;
> >         }
> > -       if (rs->burst && rs->burst > rs->printed) {
> > +       if (burst && burst > rs->printed) {
> >                 rs->printed++;
> >                 ret = 1;
> >         } else {
> > --
> > 2.30.2
> >
