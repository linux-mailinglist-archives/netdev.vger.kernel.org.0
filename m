Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9511848EE0D
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 17:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbiANQZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 11:25:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiANQZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 11:25:17 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B64C061574
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 08:25:17 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id c10so25318168ybb.2
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 08:25:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Uyg+gfkuSLA4/LUPP+48TR0YFiBiqvtyjtxVKo9gv/o=;
        b=aMtoa0Q5TYRR3DE3kjqQlHQxW/JrxU9VZkPIP5Wde/YcQqA6e4yxSbimUsFo3MV+du
         bymnzzUM/tkboUJdI/3nywvWfJBtk6E8sF6cQ0QMdYZtGWDLW4yncsv0gNVCgeOdAydm
         ixrWK/HDw/63E1e7KkMLDXi5f+4UafvNvE+CZbd6IT4/abVrfYZXZzVJXp3gz/+D2d7s
         +LtIa0jmJ3Ba3TJtP4hSXOnHHX9UhhyGUb8/Q4MYjm0oDrl+OBZ5M+Ar+S5tuFQFS1Tr
         Y7atlSClKFJwy/hXgyT8Il1sUjNgxf2oRQrRUVEXkHOTVoJu4yunpIyvM5xFbrljXJam
         SZCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Uyg+gfkuSLA4/LUPP+48TR0YFiBiqvtyjtxVKo9gv/o=;
        b=TMyumrgvLl1G2IF8nv1rSMnmnyHg5WFBFZAoqVBL8fxoQkl+07XWNTFebdBJCRl0KM
         34KimSmUgewwChekGUQoO8WkBeS3MIz2N1LC2U6SBbhT7o+uIXqp1hYUAmmENpnTOJWb
         wabO9SSlFFjVOhbrxLfTito2imB4A/38/TmhgWGrNhFVsK8PpJAN10cFHBmlLR5DxLzJ
         vp9ppG2upN+7mAnOkSSk4PKZ136wNhOqDhpBCc3m3pZdb3L266yEY9A9aINdv9zZoWl0
         DUwxtu/Lc75CLKCjsqocoFB+T49ELW/KaAyYIjrzXOEqp98tUKrWpfrtJ0U3+E46FPor
         tZBQ==
X-Gm-Message-State: AOAM532gr8OB26ENH0Uqy/eUAudcSlci3vPV8bxRTWpjZe/KdXbs2TS6
        b9truN6sM3jnJMPWxyB+f5hSmcvD9UW+TThalaflxg==
X-Google-Smtp-Source: ABdhPJxzEEibsJ4Fsr/EO3kETomouE8WQM566R5Yzhqm8cBT4qaKY0tWd2IZwTGUAEcO35jsCDhdLlLYI13IiU/hxGA=
X-Received: by 2002:a25:b29c:: with SMTP id k28mr14093320ybj.711.1642177515943;
 Fri, 14 Jan 2022 08:25:15 -0800 (PST)
MIME-Version: 1.0
References: <20220114153902.1989393-1-eric.dumazet@gmail.com> <2f8ea7358c17449682f7e72eaed1ce54@AcuMS.aculab.com>
In-Reply-To: <2f8ea7358c17449682f7e72eaed1ce54@AcuMS.aculab.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 14 Jan 2022 08:25:04 -0800
Message-ID: <CANn89iKA32qt8X6VzFsissZwxHpar6pDEJT_dgYhnxfROcaqRA@mail.gmail.com>
Subject: Re: [PATCH net] ipv4: make fib_info_cnt atomic
To:     David Laight <David.Laight@aculab.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 14, 2022 at 7:50 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Eric Dumazet
> > Sent: 14 January 2022 15:39
> >
> > Instead of making sure all free_fib_info() callers
> > hold rtnl, it seems better to convert fib_info_cnt
> > to an atomic_t.
>
> Since fib_info_cnt is only used to control the size of the hash table
> could it be incremented when a fid is added to the hash table and
> decremented when it is removed.
>
> This is all inside the fib_info_lock.

Sure, this will need some READ_ONCE()/WRITE_ONCE() annotations
because the resize would read fib_info_cnt without this lock held.

I am not sure this is a stable candidate though, patch looks a bit more risky.

This seems to suggest another issue...

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 828de171708f599b56f63715514c0259c7cb08a2..45619c005b8dddd7ccd5c7029efa4ed69b6ce1de
100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -249,7 +249,6 @@ void free_fib_info(struct fib_info *fi)
                pr_warn("Freeing alive fib_info %p\n", fi);
                return;
        }
-       fib_info_cnt--;

        call_rcu(&fi->rcu, free_fib_info_rcu);
 }
@@ -260,6 +259,10 @@ void fib_release_info(struct fib_info *fi)
        spin_lock_bh(&fib_info_lock);
        if (fi && refcount_dec_and_test(&fi->fib_treeref)) {
                hlist_del(&fi->fib_hash);
+
+               /* Paired with READ_ONCE() in fib_create_info(). */
+               WRITE_ONCE(fib_info_cnt, fib_info_cnt - 1);
+
                if (fi->fib_prefsrc)
                        hlist_del(&fi->fib_lhash);
                if (fi->nh) {
@@ -1430,7 +1433,9 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
 #endif

        err = -ENOBUFS;
-       if (fib_info_cnt >= fib_info_hash_size) {
+
+       /* Paired with WRITE_ONCE() in fib_release_info() */
+       if (READ_ONCE(fib_info_cnt) >= fib_info_hash_size) {
                unsigned int new_size = fib_info_hash_size << 1;
                struct hlist_head *new_info_hash;
                struct hlist_head *new_laddrhash;
@@ -1462,7 +1467,6 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
                return ERR_PTR(err);
        }

-       fib_info_cnt++;
        fi->fib_net = net;
        fi->fib_protocol = cfg->fc_protocol;
        fi->fib_scope = cfg->fc_scope;
@@ -1591,6 +1595,7 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
        refcount_set(&fi->fib_treeref, 1);
        refcount_set(&fi->fib_clntref, 1);
        spin_lock_bh(&fib_info_lock);
+       fib_info_cnt++;
        hlist_add_head(&fi->fib_hash,
                       &fib_info_hash[fib_info_hashfn(fi)]);
        if (fi->fib_prefsrc) {
