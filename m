Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55CB855C855
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237945AbiF0TQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 15:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235557AbiF0TP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 15:15:59 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2183B640B
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 12:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1656357360; x=1687893360;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U2wBDf4++/Qp42mMVvdoXxwuHtURlZJaaxIQcdapnDk=;
  b=dmAPIRKR0JcwY0KpbUUDLti2iIcE/tQiHu7p0ePtx5RlFqojremvh+HY
   jgQPOEJkCrxsiQcVmc7CACA1kHWJwpbzRdMIySpWMSHmKLVE2EOllcYLD
   eih9epxrIcYPzsM9uoKR8AcrVSIuqGnYty3wbyVxdSGGJdVSZ4cdgI0Be
   M=;
X-IronPort-AV: E=Sophos;i="5.92,227,1650931200"; 
   d="scan'208";a="205528420"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-f771ae83.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 27 Jun 2022 19:15:58 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-f771ae83.us-east-1.amazon.com (Postfix) with ESMTPS id 8BBA712168B;
        Mon, 27 Jun 2022 19:15:55 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 27 Jun 2022 19:15:54 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.183) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 27 Jun 2022 19:15:52 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <ebiederm@xmission.com>,
        <herbert@gondor.apana.org.au>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>, <xemul@openvz.org>
Subject: Re: [PATCH v2 net] af_unix: Do not call kmemdup() for init_net's sysctl table.
Date:   Mon, 27 Jun 2022 12:15:44 -0700
Message-ID: <20220627191544.4266-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iJJu2ZEu2X+AdfUKrBVj5N5h2bSDE73fwNcVmOm-JSVwA@mail.gmail.com>
References: <CANn89iJJu2ZEu2X+AdfUKrBVj5N5h2bSDE73fwNcVmOm-JSVwA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.183]
X-ClientProxiedBy: EX13D25UWC003.ant.amazon.com (10.43.162.129) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 27 Jun 2022 21:06:14 +0200
> On Mon, Jun 27, 2022 at 8:59 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > From:   Eric Dumazet <edumazet@google.com>
> > Date:   Mon, 27 Jun 2022 20:40:24 +0200
> > > On Mon, Jun 27, 2022 at 8:30 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > >
> > > > From:   Jakub Kicinski <kuba@kernel.org>
> > > > Date:   Mon, 27 Jun 2022 10:58:59 -0700
> > > > > On Sun, 26 Jun 2022 11:43:27 -0500 Eric W. Biederman wrote:
> > > > > > Kuniyuki Iwashima <kuniyu@amazon.com> writes:
> > > > > >
> > > > > > > While setting up init_net's sysctl table, we need not duplicate the global
> > > > > > > table and can use it directly.
> > > > > >
> > > > > > Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> > > > > >
> > > > > > I am not quite certain the savings of a single entry table justivies
> > > > > > the complexity.  But the looks correct.
> > > > >
> > > > > Yeah, the commit message is a little sparse. The "why" is not addressed.
> > > > > Could you add more details to explain the motivation?
> > > >
> > > > I was working on a series which converts UDP/TCP hash tables into per-netns
> > > > ones like AF_UNIX to speed up looking up sockets.  It will consume much
> > > > memory on a host with thousands of netns, but it can be waste if we do not
> > > > have its protocol family's sockets.
> > >
> > > For the record, I doubt we will accept such a patch (per net-ns
> > > TCP/UDP hash tables)
> >
> > Is it because it's risky?
> 
> Because it will be very expensive. TCP hash tables are quite big.

Yes, so I'm wondering if changing the size by sysctl makes sense.  If we
have per-netns hash tables, each table should have smaller amount of
sockets and smaller size should be enough, I think.

> 
> [    4.917080] tcp_listen_portaddr_hash hash table entries: 65536
> (order: 8, 1048576 bytes, vmalloc)
> [    4.917260] TCP established hash table entries: 524288 (order: 10,
> 4194304 bytes, vmalloc hugepage)
> [    4.917760] TCP bind hash table entries: 65536 (order: 8, 1048576
> bytes, vmalloc)
> [    4.917881] TCP: Hash tables configured (established 524288 bind 65536)
> 
> 
> 
> > IIRC, you said we need per netns table for TCP in the future.
> 
> Which ones exactly ? I guess you misunderstood.

I think this.
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=04c494e68a13
