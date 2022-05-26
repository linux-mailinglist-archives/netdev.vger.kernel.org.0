Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD08535445
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 22:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348905AbiEZUMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 16:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348874AbiEZUMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 16:12:08 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA9EC5DB9;
        Thu, 26 May 2022 13:12:07 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id w2-20020a17090ac98200b001e0519fe5a8so2574231pjt.4;
        Thu, 26 May 2022 13:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ym1mSZ1N+gDIg7RPoqcZ6DASQgrFGhS7kPRYey05Jig=;
        b=U1xGut8jUgrl5aH8rrFlvVXLlKZ7koIFTkdaMNaSFb8co+fPLt4WOdT87pgdLm6qh/
         T5NtkOndjxddPXrFuQIIF0BxTtiH2PPpuJU4fsZpIT/NmHbDkvkP04pJxo3w8ZXXearK
         kMXiE6Hh5pvG5yBWpANTZX3wgyqrKqbM8ya8yowLKKrQOEz0A3Hd4+1yEqTStNr0ieYv
         7/baUY8jkz09C99Gw4+4utqAiIqoDRP8JanN0EoMKt1diGcDbyXxcTDIvTv9ws+1qJ31
         UQUqHbQNlGGzEId1tuQe/ERjK/CIo/eHN5u9tNsEezabBNv7BphITj4I/SyMZRUEcxlX
         /T7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ym1mSZ1N+gDIg7RPoqcZ6DASQgrFGhS7kPRYey05Jig=;
        b=twQJiG/y+MXWHGFtdSibf+/NSl3Eml3r+NyyvuL6OHZvVXz8YU7lq/v2QLdDf1ZQhe
         KhSA6Q27sXBWYBbUHBt8m9xHqmPuEIPFqyVpbXZXLslMz8ujzmUAkZ050DH8XOXSlCx0
         7+Xey39LanoU0z829boeS73yWe81STAFwZU0RpKZuM/nBFpFmQrng0XTRZ2YzFfMZck5
         qTiTKBYTYghn2MzFb0NtK7abrWjMjhdO2SEC22jchENEh7ul+N2daHJyGK7aFVP7Flj+
         i5fK0438pLDDTdSx4DlHog+fkNNAchTb2z83/tZV+LQv6QUb5Ty2y0GsZ5COWcp0668G
         pG1A==
X-Gm-Message-State: AOAM5328KOA0AblWsCLd6hLX9O1bAyGtZifFJiBNOfhOiTQsP5PeOZ9r
        vu2cfmwLagKCzw66b+3ENDC01hHK7kUOBHi1wFWCpup8
X-Google-Smtp-Source: ABdhPJxBECFKdSI1IJ8bWSn4XNDvgl0Y71qedIzUHn9db1kEWuBdaTXj/Sa82JHFeVa7k0aeyBGlKXFKI5ofxC7eGCg=
X-Received: by 2002:a17:902:d5c1:b0:162:64e:8c21 with SMTP id
 g1-20020a170902d5c100b00162064e8c21mr27987572plh.34.1653595927124; Thu, 26
 May 2022 13:12:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220526094918.482971-1-niejianglei2021@163.com> <081b216e6496e8cc2284df191dcc2d8b604d04f7.camel@redhat.com>
In-Reply-To: <081b216e6496e8cc2284df191dcc2d8b604d04f7.camel@redhat.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Thu, 26 May 2022 13:11:56 -0700
Message-ID: <CABBYNZJ+E6KMyqODib_nhGJuZzWssSrswKR9MoqPrM7tuEpDcg@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: hci_conn: fix potential double free in le_scan_cleanup()
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Jianglei Nie <niejianglei2021@163.com>, marcel@holtmann.org,
        johan.hedberg@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, May 26, 2022 at 4:24 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Thu, 2022-05-26 at 17:49 +0800, Jianglei Nie wrote:
> > When "c == conn" is true, hci_conn_cleanup() is called. The
> > hci_conn_cleanup() calls hci_dev_put() and hci_conn_put() in
> > its function implementation. hci_dev_put() and hci_conn_put()
> > will free the relevant resource if the reference count reaches
> > zero, which may lead to a double free when hci_dev_put() and
> > hci_conn_put() are called again.
> >
> > We should add a return to this function after hci_conn_cleanup()
> > is called.
> >
> > Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
> > ---
> >  net/bluetooth/hci_conn.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
> > index fe803bee419a..7b3e91eb9fa3 100644
> > --- a/net/bluetooth/hci_conn.c
> > +++ b/net/bluetooth/hci_conn.c
> > @@ -166,6 +166,7 @@ static void le_scan_cleanup(struct work_struct *work)
> >       if (c == conn) {
> >               hci_connect_le_scan_cleanup(conn);
> >               hci_conn_cleanup(conn);
> > +             return;
>
> This looks not correct. At very least you should release the
> hci_dev_lock.

Yep, it should probably use break instead of return.

> Cheers,
>
> Paolo
>


-- 
Luiz Augusto von Dentz
