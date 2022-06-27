Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E30C55E2F5
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238686AbiF0Ski (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 14:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbiF0Skh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 14:40:37 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C65AB87
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 11:40:37 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id v185so8694837ybe.8
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 11:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VpRNeDbsDFiYrGHhF1QfWytJCUSNoYeP5jB3fkaj0pk=;
        b=ZO+bjULozpe9hAZrFDDu8j3mkI01AlThEbsBBlziWupYxlNjXROkkSCNBDcUbocrRz
         ojfmYpZtV3YUT31zrg4b8asz5p+TygmiUrGzifuX0dpFu4Rz1WP0v+yVDZcLs5KcUQSG
         iavwBjjMJ0DFwfO20Q3TxTXudXs6QUHVfVsFKi2oWOE2uXMl4ibZ0Na6tZzqviS50QC7
         iXOVQuampb9jLM1asITsdy7KNaEUlzL9pVvaBaZtn8VCiKb+5t2bCMlAU5fXYvlVmL7O
         VlgariPGlMPXNWEYgxM3NqiG16CXRhQe/13EVv0yhnjkTtR91KAHeO+uJeNLL9f+aCbj
         iRIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VpRNeDbsDFiYrGHhF1QfWytJCUSNoYeP5jB3fkaj0pk=;
        b=xUddY8lqFShAaxc6SlEdxZ8PR00JmGOnUTc6RxouuFwtM/DT2VsHZuij5I75JhFPt7
         tbdB4IEJUHS1x7eAcW+/9jFps9srzYslWQyZa+6a1/OKa4+/eNksPiooONeHF4Jn64ZX
         uYk6KI3iUlcmBWAfsziXoHrlEb8lKBIUBs9ni9eKtPApP1BSq9eDtij25QJUExmN9cdW
         VhLLgqXKHyrrUATowhadW6hVWpzcXjwLiLjbK90or4Ox8Vrtacv1rWtcQPXMVczU4uVY
         90OB4ZPEdT2MVExi2qGItPEvRpB7fkbtKAaocVPCuuJXss+Z5gTR/lfLy+QqLmqO7Yh7
         NL5g==
X-Gm-Message-State: AJIora/03nD4raEpFo+IjL0XHpbYUK4LL8LpIDQ3HnVeJgLKf+w9eywq
        Io8drhtdjU/eW1qE5M0hdZ0woWOkPEq8p6DCxobSTw==
X-Google-Smtp-Source: AGRyM1vwI0uzRPwpdLZTpjAJ6lySz6HQDd4ImWG1qv8Uk/RAlxGR0adOV2lOYTU1sTkae9dxS+M/EPWDKtidEOaYW3Y=
X-Received: by 2002:a25:e211:0:b0:669:9cf9:bac7 with SMTP id
 h17-20020a25e211000000b006699cf9bac7mr14284670ybe.407.1656355235984; Mon, 27
 Jun 2022 11:40:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220627105859.3ffec11a@kernel.org> <20220627183009.94599-1-kuniyu@amazon.com>
In-Reply-To: <20220627183009.94599-1-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 27 Jun 2022 20:40:24 +0200
Message-ID: <CANn89i+QSfFpwkmHhrH3qkpFTK2XEO1OTdgfSSbQFNGGu2WT_A@mail.gmail.com>
Subject: Re: [PATCH v2 net] af_unix: Do not call kmemdup() for init_net's
 sysctl table.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
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

On Mon, Jun 27, 2022 at 8:30 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> From:   Jakub Kicinski <kuba@kernel.org>
> Date:   Mon, 27 Jun 2022 10:58:59 -0700
> > On Sun, 26 Jun 2022 11:43:27 -0500 Eric W. Biederman wrote:
> > > Kuniyuki Iwashima <kuniyu@amazon.com> writes:
> > >
> > > > While setting up init_net's sysctl table, we need not duplicate the global
> > > > table and can use it directly.
> > >
> > > Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> > >
> > > I am not quite certain the savings of a single entry table justivies
> > > the complexity.  But the looks correct.
> >
> > Yeah, the commit message is a little sparse. The "why" is not addressed.
> > Could you add more details to explain the motivation?
>
> I was working on a series which converts UDP/TCP hash tables into per-netns
> ones like AF_UNIX to speed up looking up sockets.  It will consume much
> memory on a host with thousands of netns, but it can be waste if we do not
> have its protocol family's sockets.

For the record, I doubt we will accept such a patch (per net-ns
TCP/UDP hash tables)

>
> So, I'm now working on a follow-up series for AF_UNIX per-netns hash table
> so that we can change the size for a child netns by a sysctl knob:
>
>   # sysctl -w net.unix.child_hash_entries=128
>   # ip net add test  # created with the hash table size 128
>   # ip net exec test sh
>   # sysctl net.unix.hash_entries  # read-only
>   128
>
>   (The size for init_net can be changed via a new boot parameter
>    xhash_entries like uhash_entries/thash_entries.)
>
> While implementing that, I found that kmemdup() is called for init_net but
> TCP/UDP does not (See: ipv4_sysctl_init_net()).  Unlike IPv4, AF_UNIX does
> not have a huge sysctl table, so it cannot be a problem though, this patch
> is for consuming less memory and kind of consistency.  The reason I submit
> this seperately is that it might be better to have a Fixes tag.

I think that af_unix module can be unloaded.

Your patch will break the module unload operation.
