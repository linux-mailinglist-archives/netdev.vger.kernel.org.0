Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 336BE4F984
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 04:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbfFWCWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 22:22:10 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:35573 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfFWCWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 22:22:10 -0400
Received: by mail-ed1-f66.google.com with SMTP id w20so8339089edd.2
        for <netdev@vger.kernel.org>; Sat, 22 Jun 2019 19:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2bkND5CX4fUw2JTUwUwoEaeJFs9pwbtaG1Omsp3mEJs=;
        b=N+3DUQeaShYlq6sbBkifpUjfYcmUm8tANwoOLZ7UZVshK6ICNXwlUN0n4ut0klNviI
         u+EMnLqWP496Jmz/xOxjc2l2GFXVk/EhCbZ4yy7zquhU0OAz02giHEZdiuKEA+XVa1p1
         bkdEQRMb5bubDo2QYVkpbbKahECuJMzKSKeKt65GThMUUgHwmDFGyiSYe2+D66i/sS14
         ga8XoaTshqjL4ihTo68+eswv0geXeog298Fpo/e2HlzZyTddRDg5O23l+1q6dLL+ruYn
         fYVJq/FTW5HrYT+CTWx/nPcmC0UWkoLdBb4D8fstK2eAxwfmVmg7CJJ96gy7flKFvQOK
         I7qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2bkND5CX4fUw2JTUwUwoEaeJFs9pwbtaG1Omsp3mEJs=;
        b=nZjbS2bm2RJqTBhMe1b3We1mgQdV5JIlTtkx9RmuXWF9jI2xqEPiYPfaYn9MBaNdsp
         bavsVmkUcAVQcXFL9NbzqrXjvJc1rCVGuzsdYBKW/e1ZIQwCuMYV8iwXKMq1NXMQnNc9
         iDuhkviDwkTI+aR3wxMpaOjQl+ZNbP1/jy24vM6jSmKZ5ANsEe+mswLM0+IHJ+B/HJUq
         e4Qzg/PwZgnVwYhnhzWJMkqCuDfdEt+QH/ZU82Rp0aWzXow+UPaGMLRgdb/A1Fhd+0wZ
         NrjKe69V9nXjrmU4/Ed8vHAwsWBBjBBmoHrWsioUu3yAoEHqMk6fsuGHrdR6YoVCzVr5
         4UZg==
X-Gm-Message-State: APjAAAXrcomo2F2KGn1FipBNKGG9OfYUwDVaGsMyFXmumvOSz7KCMAm9
        9tAG91RqgZVXF04ZKaoKwVIodmLl1Z9K734oVkI=
X-Google-Smtp-Source: APXvYqxg/v+RKHxPXoUykx/mTvnScw1oPDCD1wId4FmvtPafYZUMHqiLZLXUYoigkv/mM3GaD9s70uZrTge7epoiUzE=
X-Received: by 2002:a17:906:1108:: with SMTP id h8mr1736219eja.229.1561256528581;
 Sat, 22 Jun 2019 19:22:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190619202533.4856-1-nhorman@tuxdriver.com> <20190622174154.14473-1-nhorman@tuxdriver.com>
 <CAF=yD-JC_r1vjitN1ccyvQ3DXiP9BNCwq9iiWU11cXznmhAY8Q@mail.gmail.com>
In-Reply-To: <CAF=yD-JC_r1vjitN1ccyvQ3DXiP9BNCwq9iiWU11cXznmhAY8Q@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 22 Jun 2019 22:21:31 -0400
Message-ID: <CAF=yD-+8NDiL0dxM+eOFyiwi1ZhCW29dW--+VeEkssUaJqedWg@mail.gmail.com>
Subject: Re: [PATCH v2 net] af_packet: Block execution of tasks waiting for
 transmit to complete in AF_PACKET
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Matteo Croce <mcroce@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > -static void __packet_set_status(struct packet_sock *po, void *frame, int status)
> > +static void __packet_set_status(struct packet_sock *po, void *frame, int status,
> > +                               bool call_complete)
> >  {
> >         union tpacket_uhdr h;
> >
> > @@ -381,6 +382,8 @@ static void __packet_set_status(struct packet_sock *po, void *frame, int status)
> >                 BUG();
> >         }
> >
> > +       if (po->wait_on_complete && call_complete)
> > +               complete(&po->skb_completion);
>
> This wake need not happen before the barrier. Only one caller of
> __packet_set_status passes call_complete (tpacket_destruct_skb).
> Moving this branch to the caller avoids a lot of code churn.
>
> Also, multiple packets may be released before the process is awoken.
> The process will block until packet_read_pending drops to zero. Can
> defer the wait_on_complete to that one instance.

Eh no. The point of having this sleep in the send loop is that
additional slots may be released for transmission (flipped to
TP_STATUS_SEND_REQUEST) from another thread while this thread is
waiting.

Else, it would have been much simpler to move the wait below the send
loop: send as many packets as possible, then wait for all of them
having been released. Much clearer control flow.

Where to set and clear the wait_on_complete boolean remains. Integer
assignment is fragile, as the compiler and processor may optimize or
move simple seemingly independent operations. As complete() takes a
spinlock, avoiding that in the DONTWAIT case is worthwhile. But probably
still preferable to set when beginning waiting and clear when calling
complete.
