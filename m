Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABD52C7CA
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 15:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfE1NbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 09:31:13 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:42299 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfE1NbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 09:31:13 -0400
Received: by mail-yw1-f65.google.com with SMTP id s5so7885257ywd.9
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 06:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WIPBWJfuQ7QJHOeh2JjtakcHSwk/OV1epIZhfp+6REw=;
        b=sbwjTeXV3SZ3WtfXIcb+b6GWrxQ37J6aWMlAWdXA4Uj0QuFB/cWRT6mk5dQ8K3OaIu
         2rchMohiJF+cvLq4NhLQvR6/89FxBgprZAS9Tg97QYhxmB6rrkTAqv02tnvq9Xi8nx5S
         Gss52l8We4t+uWz2xyX6D1L9socom1e31t5Iw3NIJaBbrjX25msH52Oj5i9M46LJ/ZQC
         Ryn14z9mgMtCHVt65YZtjT6/xIUWuGZhRWVTujt2m9ll0P/2J9abUnA82MdtyVeJ0svH
         GI3H9KJ0j/YPWlFqduJ8xpbzMgp3sWWUc1WjcrleQ6K3Wpg1FvZubIaqR+hKgDnAhYtA
         Y92Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WIPBWJfuQ7QJHOeh2JjtakcHSwk/OV1epIZhfp+6REw=;
        b=pL/PeG2UKx0475bN73u+9L0zztBHbj+Kn5iK8LDFbVuXTcdEptsVcbRcCJYx85QyFd
         jL7QKO6wv8HaEgsdbD2d9nwoMLDEp+xuXCXdiwvYHU4CPa2o0Z5K2eSuCa5ayQjkp0bD
         xVoKX8t16AE4f0BuTx2dUNz2Yak9bh0SFS8NpvM6MppmFIolZln3wWp+QV2dZfRiiCu5
         t/z92Y1QrSkp64O1h86qU7DgP+HeGBbMLJqJqlPigqj9uGvuUHi6RyMLDbcKaU693tHx
         425AvNuw/H96LIpiEzkjowKDKpnr7dsXsgPyXvkXyD26POXDWF9geMvJj09lmWARm+c8
         6jhg==
X-Gm-Message-State: APjAAAVtnAWatm+p4V1lUk5vElSm4PvRbQC6NfsGT5JoQkJWhLqdLoTD
        DyGfrv4OfXQG0rU6eeE+yLOEFAo2kBZ7Fl4/n6h3Eg==
X-Google-Smtp-Source: APXvYqy1iE6T+E3zyTFVvFFLBR+KYySY7MCoHzVmgQaHSTrmvkgZNItjMA44wRlVluk01vmVaz8NI2/iWzJYOWM9ac4=
X-Received: by 2002:a81:5245:: with SMTP id g66mr22888633ywb.496.1559050272291;
 Tue, 28 May 2019 06:31:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190524160340.169521-12-edumazet@google.com> <20190528063403.ukfh37igryq4u2u6@gondor.apana.org.au>
In-Reply-To: <20190528063403.ukfh37igryq4u2u6@gondor.apana.org.au>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 28 May 2019 06:31:00 -0700
Message-ID: <CANn89i+NfFLHDthLC-=+vWV6fFSqddVqhnAWE_+mHRD9nQsNyw@mail.gmail.com>
Subject: Re: [PATCH net-next 11/11] inet: frags: rework rhashtable dismantle
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 27, 2019 at 11:34 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Hi Eric:
>
> Eric Dumazet <edumazet@google.com> wrote:
> >
> > +void fqdir_exit(struct fqdir *fqdir)
> > +{
> > +       fqdir->high_thresh = 0; /* prevent creation of new frags */
> > +
> > +       /* paired with READ_ONCE() in inet_frag_kill() :
> > +        * We want to prevent rhashtable_remove_fast() calls
> > +        */
> > +       smp_store_release(&fqdir->dead, true);
> > +
> > +       INIT_RCU_WORK(&fqdir->destroy_rwork, fqdir_rwork_fn);
> > +       queue_rcu_work(system_wq, &fqdir->destroy_rwork);
> > +
> > +}
>
> What is the smp_store_release supposed to protect here? If it's
> meant to separate the setting of dead and the subsequent destruction
> work then it doesn't work because the barrier only protects the code
> preceding it, not after.
>

This smp_store_release() is a left over of the first version of the patch, where
there was no rcu grace period enforcement.

I do not believe there is harm letting this, but if you disagree
please send a patch ;)

Thanks
