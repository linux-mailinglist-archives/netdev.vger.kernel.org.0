Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5591153CE
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 16:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbfLFPEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 10:04:07 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54915 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbfLFPEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 10:04:07 -0500
Received: by mail-wm1-f67.google.com with SMTP id b11so8139722wmj.4
        for <netdev@vger.kernel.org>; Fri, 06 Dec 2019 07:04:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tuvOGUuphJljqsnwDIlOzeJI6mW7RcXZeFFjeM8e4r4=;
        b=QmwNLtFATd48WBCWkzfXF2PUktVrnW2JvtHyzc/RNtl9DFNqFi4hCRG0KZ1TlnezIE
         Bqhee/Y+nuqH8Knr/vrtZ9QrOkT0kZxA9fMYm/5m0JLnhZGc+ycod3790AlCs+w2n244
         F+lA597OKPY8EtH6U670qA51RId8krDH6wykGmpGh5fTG5C5mhV7FLT8RK644aGsAxBE
         E7HqskV8fC1fuJ+nUPHKO0Qg1F62RRm1vzyfh1NcXwY8+NXeNw0NcLj5qi7GEpOniYHT
         LeLrp0Qw7v4b/9XNHJR0cBmnnSW2bPO+J1sPYWvK9D5yXC9rTeKiuZgVY+KlRzxW/vJ8
         rTEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tuvOGUuphJljqsnwDIlOzeJI6mW7RcXZeFFjeM8e4r4=;
        b=dfU0i/rPRNMxeY3uQ0C+TDFunIdQ7esGFB7U4OZ08HTPuMEACRbIBRTQ9505y5pNwE
         kSlhzfI7FrFsgjrNTaug7oqq4qiQqeQI/2LnWkfy4OyKLNNdJYjqfqMoPupqfVEyzSvp
         UZjQJFSIOiefDLPwHHKBtmhadsgZC8fMWDr9NHgPPz25US59/n6dDefWEiITx+Z2cJpx
         YzOe525tRbhGO4dQjO7Y/xSH8rVB68WqOMafVZfInOWCaq7imwnxCoVDwylvISmAczXn
         +7NCzU/Evdo8f+iG7QyyeE6UnZhaNqtqIIJxCxQj10xw/heS0a+DM+cXqG4wR+zdBz6/
         FmRQ==
X-Gm-Message-State: APjAAAXJ5jG2ct4e8q7E+47ZnGkKi9b6Tss5PzBJm9A3mnCwAswUdu51
        OFdiqmEKL3uBTy7Kc3Z8AwFqNZXHe1fmfnu+QMazJbgA
X-Google-Smtp-Source: APXvYqzyRHenQtcqmgVOdsiZMeMYc3m+ZfRoSUkn34CcLrOmFqsJ6v073EcfdvFiQPQgEL+2bk/Hk1H0lLozmaZlOAs=
X-Received: by 2002:a1c:4004:: with SMTP id n4mr10318722wma.153.1575644645067;
 Fri, 06 Dec 2019 07:04:05 -0800 (PST)
MIME-Version: 1.0
References: <20191205181015.169651-1-edumazet@google.com> <CADVnQy=xkpckodjF16YF=tZ34bMB2QLQ=BTJeGyaidcPaTiAGQ@mail.gmail.com>
In-Reply-To: <CADVnQy=xkpckodjF16YF=tZ34bMB2QLQ=BTJeGyaidcPaTiAGQ@mail.gmail.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Fri, 6 Dec 2019 10:03:27 -0500
Message-ID: <CACSApvb7Yz5xZjS=Qf8Sw1ftWGBU1Xn0+w8vrH1qjruv+PF-+Q@mail.gmail.com>
Subject: Re: [PATCH net] tcp: md5: fix potential overestimation of TCP option space
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Yuchung Cheng <ycheng@google.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 6, 2019 at 9:49 AM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Thu, Dec 5, 2019 at 1:10 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > Back in 2008, Adam Langley fixed the corner case of packets for flows
> > having all of the following options : MD5 TS SACK
> >
> > Since MD5 needs 20 bytes, and TS needs 12 bytes, no sack block
> > can be cooked from the remaining 8 bytes.
> >
> > tcp_established_options() correctly sets opts->num_sack_blocks
> > to zero, but returns 36 instead of 32.
> >
> > This means TCP cooks packets with 4 extra bytes at the end
> > of options, containing unitialized bytes.
> >
> > Fixes: 33ad798c924b ("tcp: options clean up")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Reported-by: syzbot <syzkaller@googlegroups.com>
> > ---
>
> Acked-by: Neal Cardwell <ncardwell@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Thanks for the fix!

> Thanks, Eric!
>
> neal
