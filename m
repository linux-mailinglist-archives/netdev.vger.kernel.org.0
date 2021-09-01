Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B52113FE1A4
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 20:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344602AbhIASCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 14:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236877AbhIASCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 14:02:41 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E72C061764
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 11:01:44 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id v2so101799ilg.12
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 11:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j7RqTfIlND2syTvjqIu2Q5uS78m15882rXoX/dLksfk=;
        b=ncSc4RkcmzknHFOy+NFnmoCd7Jjyra6USvWhhitwHBBK6BpCBq9WjKA57EH+7SoN4X
         VWXPG2Gy8VIuV5RzMDNp/fAEijSL1eu0JEFOidC/OpCXFXMBmLYvmaGb3eiMQ6svaJMb
         4hfIlaXz/nPF+IhigO8o+/qn9ccp1QxBDLu++FmzW1vH63sand1HoP9T8qoyEHQAAwZt
         OikQFMvXS6u4io8Jz/0FczYZYKB7DKyD/PcmO3b8zhVQoWsgCDRUsJdp9I+NamHYKqs6
         8Ic99AdNfkWLJKit8vTm3x3nV66L6Nbn2sDijeici/BlOsc/z1e4m9NH42d0jZ8WPJ4E
         Ybrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j7RqTfIlND2syTvjqIu2Q5uS78m15882rXoX/dLksfk=;
        b=JUhS6bB27sL9K8TqYJ8kUoRnObdmugkIsyC3zdg+bbp77uba0vcdQ7h1tjJ54jy0H4
         zKodwS6Dl8ieyDlzXVt0WvQjBqbxj0jNG3PgqNnYzkSmeRTZgxIqyvapTh4uTb15EFlB
         SDADYVlH6mht0ToijSy5IzZ/q4AmUL3Zb0K3DH3FnyaWr6EaFJgDEE2QCvb+5fK/ijJ5
         RB3tt6s0SNw/yAgMP5j5A9Y3MEGlBnwPtLV4/H4nce3PFZNStWTiAzA3Wv1mL6bVxNvE
         L0KVBzjJDdI5PrysRMskuLI0UCnZJEcK6rEELOhGmSd71AACgdErvxyupZWC//D14y0Y
         dAzQ==
X-Gm-Message-State: AOAM530gU6WCT1gQEMrxPEakegQ2aAr6VxIfU8LNlGWRoH4uLAF/PERR
        VtatG2kqQ0Vo2qMgWnAQM8oPtCLF6gjYSVgSu787ng==
X-Google-Smtp-Source: ABdhPJxUP05LARgCz56W2isH07n1NS5yhBorGo6KWnEaSil1/HJ8UDdK5HA/ea2y0JLJfdFVjsrvVgUTotv7Pje+6WU=
X-Received: by 2002:a05:6e02:e53:: with SMTP id l19mr554302ilk.108.1630519303767;
 Wed, 01 Sep 2021 11:01:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210826194601.3509717-1-pcc@google.com> <20210831093006.6db30672@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <bf0f47974d7141358d810d512d4b9a00@AcuMS.aculab.com> <20210901070356.750ea996@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210901070356.750ea996@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Peter Collingbourne <pcc@google.com>
Date:   Wed, 1 Sep 2021 11:01:32 -0700
Message-ID: <CAMn1gO5OmHg_10s698tNqf4X-hJ_gn17D8afyRhbW1nKpvLzWQ@mail.gmail.com>
Subject: Re: [PATCH v2] net: don't unconditionally copy_from_user a struct
 ifreq for socket ioctls
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Laight <David.Laight@aculab.com>,
        "David S. Miller" <davem@davemloft.net>,
        Colin Ian King <colin.king@canonical.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 1, 2021 at 7:04 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 1 Sep 2021 08:22:42 +0000 David Laight wrote:
> > From: Jakub Kicinski
> > > Sent: 31 August 2021 17:30
> > >
> > > On Thu, 26 Aug 2021 12:46:01 -0700 Peter Collingbourne wrote:
> > > > @@ -3306,6 +3308,8 @@ static int compat_ifr_data_ioctl(struct net *net, unsigned int cmd,
> > > >   struct ifreq ifreq;
> > > >   u32 data32;
> > > >
> > > > + if (!is_socket_ioctl_cmd(cmd))
> > > > +         return -ENOTTY;
> > > >   if (copy_from_user(ifreq.ifr_name, u_ifreq32->ifr_name, IFNAMSIZ))
> > > >           return -EFAULT;
> > > >   if (get_user(data32, &u_ifreq32->ifr_data))
> > >
> > > Hi Peter, when resolving the net -> net-next merge conflict I couldn't
> > > figure out why this chunk is needed. It seems all callers of
> > > compat_ifr_data_ioctl() already made sure it's a socket IOCTL.
> > > Please double check my resolution (tip of net-next) and if this is
> > > indeed unnecessary perhaps send a cleanup? Thanks!
> >
> > To stop the copy_from_user() faulting when the user buffer
> > isn't long enough.
> > In particular for iasatty() on arm with tagged pointers.
>
> Let me rephrase. is_socket_ioctl_cmd() is always true here. There were
> only two callers, both check cmd is of specific, "sockety" type.

I see, it looks like we don't need the check on the compat path then.

I can send a followup to clean this up but given that I got a comment
from another reviewer saying that we should try to make the native and
compat paths as similar as possible, maybe it isn't too bad to leave
things as is?

Peter
