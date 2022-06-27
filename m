Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C78F55C453
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238946AbiF0USj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 16:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238935AbiF0USi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 16:18:38 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A6C192A7
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 13:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1656361117; x=1687897117;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vlCz2dmP1ILMyJtMJozt8c1h/LSAyrxFF+ge197D+Xc=;
  b=qeEffDKLoZXd0PFyBkyO52vi5buEiDDT4QVIku+LKLD+AJRp1Yh3Yla6
   zXf3F5Fy9iCsxF5iwRMEdPHlUYJhqoiIMsTuWp+I/5Rp6Se1YWY8i/nNo
   c3x0S5Jq6VXN5daWDrLyaWwj+7l3ckAoavHdIvJTt9tWgqAxfYXwMSdSQ
   4=;
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-5c4a15b1.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 27 Jun 2022 20:18:25 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-5c4a15b1.us-west-2.amazon.com (Postfix) with ESMTPS id 16A0843533;
        Mon, 27 Jun 2022 20:18:24 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 27 Jun 2022 20:18:23 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.40) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 27 Jun 2022 20:18:18 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <ebiederm@xmission.com>,
        <herbert@gondor.apana.org.au>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>, <xemul@openvz.org>
Subject: Re: [PATCH v2 net] af_unix: Do not call kmemdup() for init_net's sysctl table.
Date:   Mon, 27 Jun 2022 13:18:10 -0700
Message-ID: <20220627201810.15642-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89i+LFrwW_oYBHdCoFf1Z+v+LMJ=AzQyh+EYyHmcRBStZfw@mail.gmail.com>
References: <CANn89i+LFrwW_oYBHdCoFf1Z+v+LMJ=AzQyh+EYyHmcRBStZfw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.40]
X-ClientProxiedBy: EX13D47UWA002.ant.amazon.com (10.43.163.30) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 27 Jun 2022 22:04:07 +0200
> On Mon, Jun 27, 2022 at 10:00 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > From:   Eric Dumazet <edumazet@google.com>
> > Date:   Mon, 27 Jun 2022 21:36:18 +0200
> > > On Mon, Jun 27, 2022 at 9:16 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > >
> > > > From:   Eric Dumazet <edumazet@google.com>
> > > > Date:   Mon, 27 Jun 2022 21:06:14 +0200
> > > > > On Mon, Jun 27, 2022 at 8:59 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > > > >
> > > > > > From:   Eric Dumazet <edumazet@google.com>
> > > > > > Date:   Mon, 27 Jun 2022 20:40:24 +0200
> > > > > > > On Mon, Jun 27, 2022 at 8:30 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > > > > > >
> > > > > > > > From:   Jakub Kicinski <kuba@kernel.org>
> > > > > > > > Date:   Mon, 27 Jun 2022 10:58:59 -0700
> > > > > > > > > On Sun, 26 Jun 2022 11:43:27 -0500 Eric W. Biederman wrote:
> > > > > > > > > > Kuniyuki Iwashima <kuniyu@amazon.com> writes:
> > > > > > > > > >
> > > > > > > > > > > While setting up init_net's sysctl table, we need not duplicate the global
> > > > > > > > > > > table and can use it directly.
> > > > > > > > > >
> > > > > > > > > > Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> > > > > > > > > >
> > > > > > > > > > I am not quite certain the savings of a single entry table justivies
> > > > > > > > > > the complexity.  But the looks correct.
> > > > > > > > >
> > > > > > > > > Yeah, the commit message is a little sparse. The "why" is not addressed.
> > > > > > > > > Could you add more details to explain the motivation?
> > > > > > > >
> > > > > > > > I was working on a series which converts UDP/TCP hash tables into per-netns
> > > > > > > > ones like AF_UNIX to speed up looking up sockets.  It will consume much
> > > > > > > > memory on a host with thousands of netns, but it can be waste if we do not
> > > > > > > > have its protocol family's sockets.
> > > > > > >
> > > > > > > For the record, I doubt we will accept such a patch (per net-ns
> > > > > > > TCP/UDP hash tables)
> > > > > >
> > > > > > Is it because it's risky?
> > > > >
> > > > > Because it will be very expensive. TCP hash tables are quite big.
> > > >
> > > > Yes, so I'm wondering if changing the size by sysctl makes sense.  If we
> > > > have per-netns hash tables, each table should have smaller amount of
> > > > sockets and smaller size should be enough, I think.
> > >
> > > How can a sysctl be safely used if two different threads call "unshare
> > > -n" at the same time ?
> >
> > I think two unshare are safe. Each of them reads its parent netns's sysctl
> > knob.  Even when the parent is the same, they can read the same value.
> 
> How can one thread create a netns with a TCP ehash table with 1024 buckets,
> and a second one create a netns with a TCP ehash table with 1 million
> buckets at the same time,
> if they share the same sysctl ???

Oh, I undertood.
In the example, I added net.unix.hash_entries so we can confirm if the size
is intended one, but yes, checking it and recreating netns is crazy...

  # sysctl -w net.unix.child_hash_entries=128
  # ip net add test  # created with the hash table size 128
  # ip net exec test sh
  # sysctl net.unix.hash_entries  # read-only
  128

Do you have good idea?


> 
> >
> > But I think we need READ_ONCE()/WRITE_ONCE() in such a sysctl.
> 
> Like all sysctls really.
> 
>   While
> > creating a child netns, another one can change the value and there can be
> > a data-race.  So we have to use custome handler and pass write/read handler
> > as conv of do_proc_douintvec(), like do_proc_douintvec_conv_lockless().
> >
> > If there are some sysctls missing READ_ONCE/WRITE_ONCE(), I will add
> > more general one, proc_douintvec_lockless().
> 
> Seriously, all sysctls can be set while being read. That is not something new.

Ok, I added that on TODO.
