Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7A966DB0A
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 11:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236715AbjAQK1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 05:27:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236504AbjAQK1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 05:27:31 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9E727988
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 02:27:30 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id o75so33438477yba.2
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 02:27:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gd57rGEcdWWuRwQ3UNFckqiK6zpPBQSmZrDNmjzfeP0=;
        b=E9CH+PaXQAWy1e2XEFmqO4KgSBiAufMVvqRHual7m82yHlgT0ThZ4ZCwrXOE4X9PG5
         Arx9a8j4E8YsWGWspx7PEIc2fOA97IbXW1DXkm6sWqdjVPD7DLc1RXhQklFz1TaKHXL8
         2/gR1xMb9yN3kYg8S6mPxvHkgpoEUrgfufNAN7s+OGPCs4Ef4Bk+WWORj5tHoAuPKaqG
         UCZ9/UFFHkG90j3YPFUhZD4ovZLvxL5nwIw7Q3fCPjUO4OmyOtfg7VUtrFNhDZHYDqRq
         UH9IQryl2vXqEd+mCuN4GzCIuLxebmh7eni0srrkRy2YgEmZx+m+lV6+S5imDVLbcEyB
         g/MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gd57rGEcdWWuRwQ3UNFckqiK6zpPBQSmZrDNmjzfeP0=;
        b=WA5d5hsAj8rFJSzPK8o7PEOmHyWwH2BoF2eMUbYYD7lIvkBs6CkL69ZZEKcJeAcoTL
         rrQyntiDz+SYbHuQBd3IhtmR/agui/L0y/GnZsehsKF0KuqB7Dq1szKvZeYTldCe56ca
         QqfXS098Az1GlPixcQKr54mVFtK31NRtmHc0kBfDGJdEeQwnAeCIKLYnqzYI+pfu/kqu
         1nH8H3vuzaONkd/J9jmx25fAcS6izW8TJ6nWxTnOGrRkekgVgsQ0bAtcrhvYOjZc3B6T
         rjlA5ToJjbwweb/JwULCyrbKeQmJ0TtADBqbc6JQPHRX1VYCoiWOz1SA+xxg12/rN+q7
         Aehw==
X-Gm-Message-State: AFqh2kphtMIQPo1ePooCVdKjQOso197J+ZYbY0eScITeB4ey16jCsU3n
        iqJG9VCBkTRShSr55dglCJoXGsZGKtMDH9ISzvCruA==
X-Google-Smtp-Source: AMrXdXuYtT7gaArygUAJde2Wh4lhKMLjkMrIS6eVRynv7GFbOJ15EoODCuPsRKtOEk9pEw5EBBCciioZmXoi6L2wD8c=
X-Received: by 2002:a25:c543:0:b0:7d5:dc31:81ed with SMTP id
 v64-20020a25c543000000b007d5dc3181edmr401047ybe.407.1673951249934; Tue, 17
 Jan 2023 02:27:29 -0800 (PST)
MIME-Version: 1.0
References: <20230112-inet_hash_connect_bind_head-v3-1-b591fd212b93@diag.uniroma1.it>
 <cf3c7895be29d46e814d356bb5afad1203815253.camel@redhat.com>
In-Reply-To: <cf3c7895be29d46e814d356bb5afad1203815253.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 17 Jan 2023 11:27:18 +0100
Message-ID: <CANn89iK6Bq4SrGf0yKOXN3tffrX2gfoL=y+C91EuQGcT_2Ya2Q@mail.gmail.com>
Subject: Re: [PATCH net-next v3] inet: fix fast path in __inet_hash_connect()
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Pietro Borrello <borrello@diag.uniroma1.it>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jkl820.git@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 11:21 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Sat, 2023-01-14 at 13:11 +0000, Pietro Borrello wrote:
> > __inet_hash_connect() has a fast path taken if sk_head(&tb->owners) is
> > equal to the sk parameter.
> > sk_head() returns the hlist_entry() with respect to the sk_node field.
> > However entries in the tb->owners list are inserted with respect to the
> > sk_bind_node field with sk_add_bind_node().
> > Thus the check would never pass and the fast path never execute.
> >
> > This fast path has never been executed or tested as this bug seems
> > to be present since commit 1da177e4c3f4 ("Linux-2.6.12-rc2"), thus
> > remove it to reduce code complexity.
> >
> > Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
> > ---
> > Changes in v3:
> > - remove the fast path to reduce code complexity
> > - Link to v2: https://lore.kernel.org/r/20230112-inet_hash_connect_bind_head-v2-1-5ec926ddd985@diag.uniroma1.it
> >
> > Changes in v2:
> > - nit: s/list_entry/hlist_entry/
> > - Link to v1: https://lore.kernel.org/r/20230112-inet_hash_connect_bind_head-v1-1-7e3c770157c8@diag.uniroma1.it
> > ---
> >  net/ipv4/inet_hashtables.c | 12 +-----------
> >  1 file changed, 1 insertion(+), 11 deletions(-)
> >
> > diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> > index d039b4e732a3..b832e7a545d4 100644
> > --- a/net/ipv4/inet_hashtables.c
> > +++ b/net/ipv4/inet_hashtables.c
> > @@ -994,17 +994,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
> >       u32 index;
> >
> >       if (port) {
> > -             head = &hinfo->bhash[inet_bhashfn(net, port,
> > -                                               hinfo->bhash_size)];
> > -             tb = inet_csk(sk)->icsk_bind_hash;
> > -             spin_lock_bh(&head->lock);
> > -             if (sk_head(&tb->owners) == sk && !sk->sk_bind_node.next) {
> > -                     inet_ehash_nolisten(sk, NULL, NULL);
> > -                     spin_unlock_bh(&head->lock);
> > -                     return 0;
> > -             }
> > -             spin_unlock(&head->lock);
> > -             /* No definite answer... Walk to established hash table */
> > +             local_bh_disable();
> >               ret = check_established(death_row, sk, port, NULL);
> >               local_bh_enable();
> >               return ret;
>
> LGTM, thanks!
>
> Eric, do you have any additional comment?

Oh right, I have missed this version.

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks !
