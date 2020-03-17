Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD96318788F
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 05:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbgCQEoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 00:44:23 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:39555 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbgCQEoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 00:44:22 -0400
Received: by mail-io1-f67.google.com with SMTP id c19so18546586ioo.6;
        Mon, 16 Mar 2020 21:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LLh9WEkB9hCvNCPoVrwAAYggf2WFsHcOiqOg9CycRzk=;
        b=AK6tEpD+luiz5pKN/vp4AchiO1ciwHPnVwAYZBNXvLtBr2NhUCzLZ86fj19Ocx869y
         khKh2G6PLuehKagz6NeSHeohensCduAB/1vUaS06oQ9zUnbwKnj10DIG9yQK2b/uqBOi
         mNMNoMNZefrukNCgWPYBru+1b3f9MOJLm/OB3L8dOPsrGyqEbZI5ixn8Pb0YT0YBKJoL
         T2f8KEK4LpIJTzrQETT/pLuiUDMLfoXWAKfCnMTNFIai4cEQ5PfVqzydjcDd8A47/h7Q
         sm7kVJwqCSkUlWFZaokIsrxeULrzjspKzvfN3p03tvM6sAn668mfGt/Jg9BXT1KAwGtv
         vAaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LLh9WEkB9hCvNCPoVrwAAYggf2WFsHcOiqOg9CycRzk=;
        b=ZdqdlJQUMXhPD6+UDcRiiByCkDdDVY5U4zHC23uqVZME+vHqKN1Q8FfLZfFx5pOnbI
         PuSYnam+BKc5H5jSjBObzm9ZyBDVm+7hSGTEeJnmKO7y6xLB/EzfvC9dXF8XBjP3EOTv
         uBOmcNGKI++IIBuIcujCwsTS7vSrr3y+wOLNr7tY8FlDJK0k6UZjTVuMn0h13o5RIsQ6
         6+6iRRpiMlQmu3I5o97xg8PFL6eP9Wgruyb1htg9VXCKmqzeyXrPR65TqKz6kvd3eCbk
         Komq3rBp6bagBMPlVZsxSHj5bCXfRRO9efDpI05tZxlxAhtig8MC7h9bCSztIrObADgj
         8guQ==
X-Gm-Message-State: ANhLgQ0hkEWafqlj4dyz0SjIdtcZKHwPMhzTUGgkrr1m+dPxIB3OgqzQ
        F9gWA909Z/4HYgxWKAzCM5byl55R71eqpJeHbAc=
X-Google-Smtp-Source: ADFU+vtSOxQ5/szRxmQfsje34YMe9w6YBped55Rfvr7ivgI4Jat5cM4nBsBKqEFHpf43rWklHGFbSzlm4Io6jIIgKOM=
X-Received: by 2002:a6b:f404:: with SMTP id i4mr2243728iog.175.1584420259614;
 Mon, 16 Mar 2020 21:44:19 -0700 (PDT)
MIME-Version: 1.0
References: <1584330804-18477-1-git-send-email-hqjagain@gmail.com> <20200317041523.GB3756@localhost.localdomain>
In-Reply-To: <20200317041523.GB3756@localhost.localdomain>
From:   Qiujun Huang <hqjagain@gmail.com>
Date:   Tue, 17 Mar 2020 12:44:10 +0800
Message-ID: <CAJRQjodkqMM8Sap50UaDr5fXD+30+5tgpj4-CdEt9fM2WVjm7w@mail.gmail.com>
Subject: Re: [PATCH] sctp: fix refcount bug in sctp_wfree
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 12:15 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Mon, Mar 16, 2020 at 11:53:24AM +0800, Qiujun Huang wrote:
> > Do accounting for skb's real sk.
> > In some case skb->sk != asoc->base.sk.
>
> This is a too simple description.  Please elaborate how this can
> happen in sctp_wfree. Especially considering the construct for
> migrating the tx queue on sctp_sock_migrate(), as both sockets are
> locked while moving the chunks around and the asoc itself is only
> moved in between decrementing and incrementing the refcount:
>
>         lock_sock_nested(newsk, SINGLE_DEPTH_NESTING);
>         sctp_for_each_tx_datachunk(assoc, sctp_clear_owner_w);
>         sctp_assoc_migrate(assoc, newsk);
>         sctp_for_each_tx_datachunk(assoc, sctp_set_owner_w);
>         ...

Yeah, the description is too simple. I'll send v2.

>
> >
> > Reported-and-tested-by: syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com
>
> I can't see a positive test result, though. If I didn't loose any
> email, your last test with a patch similar to this one actually
> failed.
> I'm talking about syzbot test result at Message-ID: <000000000000e7736205a0e041f5@google.com>

I told with syzbot privately avoiding noise :p
Thanks!
