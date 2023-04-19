Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E60B6E80A9
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 19:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbjDSRxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 13:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjDSRxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 13:53:30 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C8972D56
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 10:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1681926809; x=1713462809;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gi0RC2VvChywp8mzw9/gXiXs47r0PC8MHAVmyzBBSco=;
  b=FdwgHm3gLZQc5yK1OsAWInr7935O/9DH9wpoGHvVha/DDqhJuDF5AdgF
   ZmrKKptXpwrxRbJy7PS/8jzODp30uYeIfIk+XYXULYA8RJ5FaWbI+O03U
   uq0I05vhkK4gV6yTb+roBvoQhelDd+ruM4EQn6KLfZdUD2SDiSl2wCSir
   0=;
X-IronPort-AV: E=Sophos;i="5.99,208,1677542400"; 
   d="scan'208";a="322343485"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-1box-2bm6-32cf6363.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2023 17:53:14 +0000
Received: from EX19MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-1box-2bm6-32cf6363.us-west-2.amazon.com (Postfix) with ESMTPS id 7F06481A9D;
        Wed, 19 Apr 2023 17:53:10 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Wed, 19 Apr 2023 17:53:09 +0000
Received: from 88665a182662.ant.amazon.com (10.187.170.33) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 19 Apr 2023 17:53:06 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <johannes@sipsolutions.net>
CC:     <bspencer@blackberry.com>, <christophe-h.ricard@st.com>,
        <davem@davemloft.net>, <dsahern@gmail.com>, <edumazet@google.com>,
        <kaber@trash.net>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
Subject: Re: [PATCH v1 net] netlink: Use copy_to_user() for optval in netlink_getsockopt().
Date:   Wed, 19 Apr 2023 10:52:58 -0700
Message-ID: <20230419175258.37172-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <d098026456c8393463e6cf33195edc19369c220b.camel@sipsolutions.net>
References: <d098026456c8393463e6cf33195edc19369c220b.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.170.33]
X-ClientProxiedBy: EX19D039UWA002.ant.amazon.com (10.13.139.32) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Johannes Berg <johannes@sipsolutions.net>
Date:   Wed, 19 Apr 2023 09:17:37 +0200
> On Wed, 2023-04-19 at 00:42 +0000, Kuniyuki Iwashima wrote:
> > Brad Spencer provided a detailed report that when calling getsockopt()
> > for AF_NETLINK, some SOL_NETLINK options set only 1 byte even though such
> > options require more than int as length.
> > 
> > The options return a flag value that fits into 1 byte, but such behaviour
> > confuses users who do not strictly check the value as char.
> 
> Yeah that's iffy. I guess nobody really leaves it uninitialized.
> 
> > Currently, netlink_getsockopt() uses put_user() to copy data to optlen and
> > optval, but put_user() casts the data based on the pointer, char *optval.
> > So, only 1 byte is set to optval.
> 
> Which also means it only ever sets to "1" on little endian systems, on
> big endian it would set to "0x0100'0000" (if initialized to 0 first),
> right?

Yes.


> 
> > To avoid this behaviour, we need to use copy_to_user() or cast optval for
> > put_user().
> 
> Right.
> 
> > Now getsockopt() accepts char as optval as the flags are only 1 byte.
> 
> Personally, I don't think we should allow his. We document (*) and check
> this as taking an int, and while it would _fit_, I don't really think
> it's a good idea to weaken this and allow different types.
> I don't see value in it either, certainly not now since nobody can be
> using it, and not really in the future either since you're not going to
> pack these things in memory, and having an int vs. char on the stack
> really makes basically no difference.
> And when we start seeing code that actually uses this, it'll just be
> more things to support in the userspace API, be more confusing with
> socket options that aren't just flags, etc.
> 
> IOW, I think you should keep the size checks.
> 
> 
> (*) man 7 netlink:
> "Unless otherwise noted, optval is a pointer to an int."

Oh, I didn't know it's documented.

I tried to follow other SOL_XXX handlers, for example, we can
get SO_REUSEADDR as char.  But I'm fine to keep the size check.


> 
> 
> > @@ -1754,39 +1754,17 @@ static int netlink_getsockopt(struct socket *sock, int level, int optname,
> > 
> >         switch (optname) {
> >         case NETLINK_PKTINFO:
> > -               if (len < sizeof(int))
> > -                       return -EINVAL;
> > -               len = sizeof(int);
> 
> On the other hand, this is actually accepting say a u64 now, and then
> sets only 4 bytes of it, though at least it also sets the size to what
> it wrote out.
> 
> So I guess here we can argue either
>  1) keep writing len to 4 and set 4 bytes of the output
>  2) keep the length as is and set all bytes of the output
> 
> but (2) gets confusing if you say used 6 bytes buffer as input? I mean,
> yeah, I'd really hope nobody does that.
> 
> If Jakub is feeling adventurous maybe we should attempt to see if we
> break anything by accepting only == sizeof(int) rather than >= ... :-)

Yes, this is another thing I concerned.  I thought we would have the
same report if we didn't clear the high 32 bits when a user passed u64.

If we want to avoid it, we have to use u64 as val in netlink_getsockopt().
This is even broken for a strange user who passes u128 though :P

> 
> 
> > +       if (put_user(len, optlen) ||
> 
> You never change len now, so there's no point writing it back? Or do we
> somehow need to make sure this is writable? But what for?
> 
> > +           copy_to_user(optval, &val, len))
> 
> There's some magic in copy_to_user() now, but I don't think it will save
> you here - to me this seems really wrong now because 'len' is controlled
> by the user, and sizeof(val) is only 4 bytes - so wouldn't this overrun
> even in the case I mentioned above where the user used a u64 and 'len'
> is actually 8, not 4?

You are right.  I seem to be confused to try to accept char ~ u64 :/
Yes, at least we have to set upper bound for len based on val's actual
size as we do in sk_getsockopt().


> 
> Also, as Jakub points out, even in the case where len *is* 4, you've now
> changed the behaviour on big endian.
> 
> I think that's probably *fine* since the bug meant you basically had to
> initialise to 0 and then check the entire value though, but maybe that
> warrants some discussion in the commit log.

Agreed.


> 
> So my 2 cents:
>  * I wouldn't remove the checks that the size is at least sizeof(int)
>  * I'd - even if it's not strictly backwards compatible - think about
>    restricting to *exactly* sizeof(int), which would make the issue
>    with the copy_to_user() go away as well (**)
>  * if we don't restrict the input length, then need to be much more
>    careful about the copy_to_user() I think, but then what if someone
>    specifies something really huge as the size?

I'm fine either, but I would prefer the latter using u64 for val and
set limit for len as sizeof(u64).


> 
> 
> (**) I only worry slightly that today somebody could've used an
> uninitialised value as the optlen and gotten away with it, but I hope
> that's not the case, that'd be a strange pattern, and if you ever hit 0
> it fails anyway. I'm not really worried someone explicitly wanted to use
> a bigger buffer.
> 
> 
> johannes
