Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABACF10DF48
	for <lists+netdev@lfdr.de>; Sat, 30 Nov 2019 21:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbfK3Umo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Nov 2019 15:42:44 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39137 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726981AbfK3Umo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Nov 2019 15:42:44 -0500
Received: by mail-pg1-f195.google.com with SMTP id b137so13821022pga.6
        for <netdev@vger.kernel.org>; Sat, 30 Nov 2019 12:42:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FOAlU1gIQPlHC6E3vbW/pxv92C3qOOMP4/rsEii5xus=;
        b=fiHP/W0A0et9Z45ZVSWTuwpyFLLoqzqGdkldgNmA5uyBREPKnPDhZKWQQyMQzROB3x
         /plOdLTOFPf08u8eTsCblGhUD9cKFHa5IotCfeCUpM4gHGTD0/V6RNyybacXlbwc3ysb
         bE3vs+/DMdmHYbg8XArpD/hUk1mrjHsRUHtnfRr7P182irYiZN54SdokTnxEB/i04b0k
         bwZ0Zr8Ffahjcge2EQubgkw2+gCFkuopQYINfMwRthN6lj9NKwGR3beFAqxaPgYz8Ve8
         2MJguuSPDL4v2iuTyCXMOgVnh97lS8VyKyaLI7bzoq+A54yenIZX1YZc04x1E/6/hEdt
         2+Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FOAlU1gIQPlHC6E3vbW/pxv92C3qOOMP4/rsEii5xus=;
        b=J5VLKALCpgmqHSbGyckYZ4hG9FkfdoVEAUV8+PA4T201mdGJEMBnA4USgVqmNBNN6L
         d2In+QqxZGVFinpGNx0V2t0XksClg9J7/nzY6VLf+J4L3elS7Wjx7DemjlaKjBJ59sD9
         KgUjcLsUgPh4e8wKY/0H21s05oy/7BIUV4yDS2ky3RrAioxw7LJ/jNmbgM7vmnK+5USP
         lT0OK8oIAjebzcL1ZtWyiz/lEehUHv9RpZY0o+SGA7A+77nqqsYO6cQpM53TcQL9tcaM
         3nwgKgi9kJ3bwpJ0bd4DiFeZ53Mgd4JWBvIvyPUTA7XFhYpt6YtREsYTjXFbR+guOHfd
         5EgQ==
X-Gm-Message-State: APjAAAUVQ6uFDDweCsRf4I4dcNZ1TI2YTzoei6OWKMWFvYT0ZGedK7JA
        88aX7/0ASROxtMVWzp7vqB9dgm/wkUVu42s5d+n8qI67hzQ=
X-Google-Smtp-Source: APXvYqyP7GR9nsNEH7s7xe5YTLYRN0T1u3CjOjJb92saCx0+QnrtJ51FnTDlC+zpMVnJ+V4eJdzSPC+YqP68PjU61IE=
X-Received: by 2002:a63:e4e:: with SMTP id 14mr23562720pgo.237.1575146561997;
 Sat, 30 Nov 2019 12:42:41 -0800 (PST)
MIME-Version: 1.0
References: <20191130200540.2461-1-xiyou.wangcong@gmail.com> <20191130.123135.109392310105227339.davem@davemloft.net>
In-Reply-To: <20191130.123135.109392310105227339.davem@davemloft.net>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 30 Nov 2019 12:42:30 -0800
Message-ID: <CAM_iQpUH-ZS2SCYzffg-vhq3EHD0SeHY0vf2beLUpVFtwW66EQ@mail.gmail.com>
Subject: Re: [Patch net] netrom: fix a potential NULL pointer dereference
To:     David Miller <davem@davemloft.net>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzbot+9fe8e3f6c64aa5e5d82c@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 30, 2019 at 12:31 PM David Miller <davem@davemloft.net> wrote:
>
> From: Cong Wang <xiyou.wangcong@gmail.com>
> Date: Sat, 30 Nov 2019 12:05:40 -0800
>
> > It is possible that the skb gets removed between skb_peek() and
> > skb_dequeue(). So we should just check the return value of
> > skb_dequeue().  Otherwise, skb_clone() may get a NULL pointer.
> >
> > Technically, this should be protected by sock lock, but netrom
> > doesn't use it correctly. It is harder to fix sock lock than just
> > fixing this.
> >
> > Reported-by: syzbot+9fe8e3f6c64aa5e5d82c@syzkaller.appspotmail.com
> > Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
>
> This is really bogus because it also means that all of the other
> state such as the ack_queue, nr->va, nr->vs, nr->window can also
> change meanwhile.
>
> And these determine whether a dequeue should be done at all, and
> I'm sure some range violations are possible as a result as well.
>
> This code is really terminally broken and just adding this check
> will leave many other other obvious bugs here that syzbot will
> trigger eventually.

Yes, this is what I meant by mentioning sock lock above, it is
more broken than this NULL-deref as I said. It is not worth time
to audit sock lock for netrom, so I decided to just fix this single
crash.

Thanks.
