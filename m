Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4BA55E050
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240282AbiF0TG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 15:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240241AbiF0TG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 15:06:27 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA90C2627
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 12:06:26 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-317710edb9dso95550957b3.0
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 12:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pbehbmmlHsYtBtTnTOfHS3Ep4Z1j/QnetEeOBI9rZtw=;
        b=kFRYJeubDDRRVg9M/mN0FQE+5ssHWwkiYltdmCvIHLtgkb7ZEQ1z1rwn75rnx6MMhg
         1dDU90Pm19UvvqUjPgUp2HRE17pJ/24gwE7l1ZK2sfq4QqZDD4Fz7OOBvjnLsEgfMsRP
         qN3ZqCB5THVTkuHgNQEXA/jyCReyfyiXddqOSBcKSXZnpbWIvvOiMdlndyHfP00D5gpq
         A8RLDZEGhJnkPTWbZV1yN9sNdgZAayu3SjT6TtwBOMH78b+rDtyU4+k1VDoj1UsEbEoj
         ZBsXVbDt6HFDXa3LXKJd+4isWtbnZbwzWomZdWj5FmOMAPEnHk/b14TUmgfsXeTxvuI1
         it/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pbehbmmlHsYtBtTnTOfHS3Ep4Z1j/QnetEeOBI9rZtw=;
        b=gM4Hx0eItMuBy6VKDXcArXAlsSqii2/af568g7EJirZlxucLNK7bg0o85+DeGClop+
         sF9p8d1PTPMfDPpCxZMBQqBXgFC/ADBs2eTlqPiNqExF593BHtuZgjfpUiFV+TvOCPiT
         Oll7LU9bN4PDn1pSuJAn4P0a8N/XwNq+ZiS8JJV0ba32u8dYzXaaO5nVw4mV4tGtBPmF
         YWAA3hX0fZX7Ol8/m7mDKotr9asuxSqkO5OC0uE08F8CP11oLUlh0paqsqY+fITqi58K
         CmLzzDxLdeTQZoAjsuVpVsoy5GkO4h3DAJ0DZ8T9WAPGU3F2muvJQ7TnmkP3ZySPTkxj
         n89w==
X-Gm-Message-State: AJIora8aolQaeSV+ARMf4kQ/6F0YiosUhUQiaZILFBg0FWhMg2l2BjVj
        nt3x87CdeMnG9jiwz5FEJS4pAooht8zM3Mq/03g5i7PT9tQN1Q==
X-Google-Smtp-Source: AGRyM1uaQcVbfazBZpZ4J3MVj5N5qlfwiEwj2Q/238W7iZlvOH5Xn7gB+bRUjbHtwuaHB0jnxQgQ8azyYUPKPz02mrU=
X-Received: by 2002:a81:5c9:0:b0:317:b1a5:bf8b with SMTP id
 192-20020a8105c9000000b00317b1a5bf8bmr16317882ywf.489.1656356785574; Mon, 27
 Jun 2022 12:06:25 -0700 (PDT)
MIME-Version: 1.0
References: <CANn89i+QSfFpwkmHhrH3qkpFTK2XEO1OTdgfSSbQFNGGu2WT_A@mail.gmail.com>
 <20220627185857.1272-1-kuniyu@amazon.com>
In-Reply-To: <20220627185857.1272-1-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 27 Jun 2022 21:06:14 +0200
Message-ID: <CANn89iJJu2ZEu2X+AdfUKrBVj5N5h2bSDE73fwNcVmOm-JSVwA@mail.gmail.com>
Subject: Re: [PATCH v2 net] af_unix: Do not call kmemdup() for init_net's
 sysctl table.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     David Miller <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Pavel Emelyanov <xemul@openvz.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 27, 2022 at 8:59 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> From:   Eric Dumazet <edumazet@google.com>
> Date:   Mon, 27 Jun 2022 20:40:24 +0200
> > On Mon, Jun 27, 2022 at 8:30 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > >
> > > From:   Jakub Kicinski <kuba@kernel.org>
> > > Date:   Mon, 27 Jun 2022 10:58:59 -0700
> > > > On Sun, 26 Jun 2022 11:43:27 -0500 Eric W. Biederman wrote:
> > > > > Kuniyuki Iwashima <kuniyu@amazon.com> writes:
> > > > >
> > > > > > While setting up init_net's sysctl table, we need not duplicate the global
> > > > > > table and can use it directly.
> > > > >
> > > > > Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> > > > >
> > > > > I am not quite certain the savings of a single entry table justivies
> > > > > the complexity.  But the looks correct.
> > > >
> > > > Yeah, the commit message is a little sparse. The "why" is not addressed.
> > > > Could you add more details to explain the motivation?
> > >
> > > I was working on a series which converts UDP/TCP hash tables into per-netns
> > > ones like AF_UNIX to speed up looking up sockets.  It will consume much
> > > memory on a host with thousands of netns, but it can be waste if we do not
> > > have its protocol family's sockets.
> >
> > For the record, I doubt we will accept such a patch (per net-ns
> > TCP/UDP hash tables)
>
> Is it because it's risky?

Because it will be very expensive. TCP hash tables are quite big.

[    4.917080] tcp_listen_portaddr_hash hash table entries: 65536
(order: 8, 1048576 bytes, vmalloc)
[    4.917260] TCP established hash table entries: 524288 (order: 10,
4194304 bytes, vmalloc hugepage)
[    4.917760] TCP bind hash table entries: 65536 (order: 8, 1048576
bytes, vmalloc)
[    4.917881] TCP: Hash tables configured (established 524288 bind 65536)



> IIRC, you said we need per netns table for TCP in the future.

Which ones exactly ? I guess you misunderstood.

>
>
> > > So, I'm now working on a follow-up series for AF_UNIX per-netns hash table
> > > so that we can change the size for a child netns by a sysctl knob:
> > >
> > >   # sysctl -w net.unix.child_hash_entries=128
> > >   # ip net add test  # created with the hash table size 128
> > >   # ip net exec test sh
> > >   # sysctl net.unix.hash_entries  # read-only
> > >   128
> > >
> > >   (The size for init_net can be changed via a new boot parameter
> > >    xhash_entries like uhash_entries/thash_entries.)
> > >
> > > While implementing that, I found that kmemdup() is called for init_net but
> > > TCP/UDP does not (See: ipv4_sysctl_init_net()).  Unlike IPv4, AF_UNIX does
> > > not have a huge sysctl table, so it cannot be a problem though, this patch
> > > is for consuming less memory and kind of consistency.  The reason I submit
> > > this seperately is that it might be better to have a Fixes tag.
> >
> > I think that af_unix module can be unloaded.
> >
> > Your patch will break the module unload operation.
>
> Thank you!
> I had to take of kfree() in unix_sysctl_unregister().
