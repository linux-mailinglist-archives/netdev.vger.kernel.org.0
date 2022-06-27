Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51D8E55D099
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239147AbiF0S7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 14:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237262AbiF0S7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 14:59:31 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244DB10DE
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 11:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1656356370; x=1687892370;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lvNw/P7qM5QCfdssWxmMogElVd1RUtk20y5SfXAxbvc=;
  b=rf+BSBBqsfTYK6L1HYuTnG6Fo4VfZNlcJGYzPp8H/8DjkvIhKDJWLYyd
   KW8oFRMF+ZQwrEw0cUn8plmIJlgrfOExR8ESctsPQJqlTnIIX/KdfuoxT
   jBqiJmOB5MR7oXPCbLWEbltobkw7iRpAlsPqMh5ZVL1MI2SuAnlfp1pac
   E=;
X-IronPort-AV: E=Sophos;i="5.92,227,1650931200"; 
   d="scan'208";a="205524144"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-d9fba5dd.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 27 Jun 2022 18:59:09 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-d9fba5dd.us-west-2.amazon.com (Postfix) with ESMTPS id AE65E434F0;
        Mon, 27 Jun 2022 18:59:08 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 27 Jun 2022 18:59:08 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.124) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 27 Jun 2022 18:59:05 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <ebiederm@xmission.com>,
        <herbert@gondor.apana.org.au>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>, <xemul@openvz.org>
Subject: Re: [PATCH v2 net] af_unix: Do not call kmemdup() for init_net's sysctl table.
Date:   Mon, 27 Jun 2022 11:58:57 -0700
Message-ID: <20220627185857.1272-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89i+QSfFpwkmHhrH3qkpFTK2XEO1OTdgfSSbQFNGGu2WT_A@mail.gmail.com>
References: <CANn89i+QSfFpwkmHhrH3qkpFTK2XEO1OTdgfSSbQFNGGu2WT_A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.124]
X-ClientProxiedBy: EX13D23UWA001.ant.amazon.com (10.43.160.68) To
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
Date:   Mon, 27 Jun 2022 20:40:24 +0200
> On Mon, Jun 27, 2022 at 8:30 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > From:   Jakub Kicinski <kuba@kernel.org>
> > Date:   Mon, 27 Jun 2022 10:58:59 -0700
> > > On Sun, 26 Jun 2022 11:43:27 -0500 Eric W. Biederman wrote:
> > > > Kuniyuki Iwashima <kuniyu@amazon.com> writes:
> > > >
> > > > > While setting up init_net's sysctl table, we need not duplicate the global
> > > > > table and can use it directly.
> > > >
> > > > Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> > > >
> > > > I am not quite certain the savings of a single entry table justivies
> > > > the complexity.  But the looks correct.
> > >
> > > Yeah, the commit message is a little sparse. The "why" is not addressed.
> > > Could you add more details to explain the motivation?
> >
> > I was working on a series which converts UDP/TCP hash tables into per-netns
> > ones like AF_UNIX to speed up looking up sockets.  It will consume much
> > memory on a host with thousands of netns, but it can be waste if we do not
> > have its protocol family's sockets.
> 
> For the record, I doubt we will accept such a patch (per net-ns
> TCP/UDP hash tables)

Is it because it's risky?
IIRC, you said we need per netns table for TCP in the future.


> > So, I'm now working on a follow-up series for AF_UNIX per-netns hash table
> > so that we can change the size for a child netns by a sysctl knob:
> >
> >   # sysctl -w net.unix.child_hash_entries=128
> >   # ip net add test  # created with the hash table size 128
> >   # ip net exec test sh
> >   # sysctl net.unix.hash_entries  # read-only
> >   128
> >
> >   (The size for init_net can be changed via a new boot parameter
> >    xhash_entries like uhash_entries/thash_entries.)
> >
> > While implementing that, I found that kmemdup() is called for init_net but
> > TCP/UDP does not (See: ipv4_sysctl_init_net()).  Unlike IPv4, AF_UNIX does
> > not have a huge sysctl table, so it cannot be a problem though, this patch
> > is for consuming less memory and kind of consistency.  The reason I submit
> > this seperately is that it might be better to have a Fixes tag.
> 
> I think that af_unix module can be unloaded.
> 
> Your patch will break the module unload operation.

Thank you!
I had to take of kfree() in unix_sysctl_unregister().
