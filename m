Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA9AFD016F
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 21:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730382AbfJHTsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 15:48:11 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:35992 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729385AbfJHTsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 15:48:10 -0400
Received: by mail-yb1-f194.google.com with SMTP id r2so6339758ybg.3
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 12:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q+3LW3cIWaoR6kfiohJ1zjDBDBCysO0yguAwmdYbwXM=;
        b=eOKKofFCFLwHEMB8d7RNOZO/c7VPp3ckjxgyFlWIlAhMQCQhsjmPcYbyOxfUhhWLlc
         COIyysdzx4Y8gquNhApxRrwYylv0WmzNWq6k+YXEo500d7AYGy+kEuoQ5tr338ROrHlI
         zgr6R/RB+AdGwBsDXIXDIzca9KAf8dIV0/hfxMhIHJLmg0NoPFGq6oiKY5UDUOoyjzFo
         HQXbAyJfu/e3epRAoASpUD0qZhslrlgGCfKo1taNYsPffKIiiYtKdcWTCy1KzhwJD/dZ
         zZFXHdcrgFpmgXoEAcDGYL/uWpQFX5QOgdIMkSj46aAB/uKGm7IO1Gh+XUEPczaH3Bn5
         ycog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q+3LW3cIWaoR6kfiohJ1zjDBDBCysO0yguAwmdYbwXM=;
        b=cgDlCZJ7oXKouP0WH2oY0GLsKXJm0EOSdaq71+Z0iW+mO35dHLrhSDhhkXvlaukPQG
         1aw07jKTjq3XLlILj0gTFHa49ta7ioUZ4hqcAtJYGIahETaesGBAy32wTnq4PpjJ2z91
         C2TyJZ9EjAxZKZ68ykwtq7v4neJcHS6RMyQsPnqNhKx5dpmtsfmrtiPwZVwD1UmUrQom
         6XmZQEJwqm/FRst5d50xbFSD3LLn9zVh9HzNd7NOv5JTZ9svIF0CHFiWD0vcVKzQB1nK
         7rXZ2q4vfloGB6qCvD5VN0Jaza3aCoUf9Bjymx859Z1+gw9hEboN4XHR1dlKXAsNTbR+
         KEOQ==
X-Gm-Message-State: APjAAAWQhuCxI86YJqenf1ovJv4u2QjRhwfybx7MIFNfcJLcFOo3TlZj
        JoptT5j8JBU0m/KSbBug/8+AL4rZSxVbbNwtVlN18w==
X-Google-Smtp-Source: APXvYqz3h9IBmEuSjI22v6G1isEXwrj7PjjuhJ/W3kpG3EIdlA4awRUJSwF0v2RwaJr0pAYBOElOjCDfwVoFvwx7eTg=
X-Received: by 2002:a25:720a:: with SMTP id n10mr15619697ybc.380.1570564087997;
 Tue, 08 Oct 2019 12:48:07 -0700 (PDT)
MIME-Version: 1.0
References: <20191007192105.147659-1-edumazet@google.com> <20191008123137.23c2c954@cakuba.netronome.com>
In-Reply-To: <20191008123137.23c2c954@cakuba.netronome.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 8 Oct 2019 12:47:56 -0700
Message-ID: <CANn89iKvs06pp-WR7KfUVF2mdnAyyXybfxZL5_RBKG25B6rzjw@mail.gmail.com>
Subject: Re: [PATCH net-next] tun: fix memory leak in error path
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 8, 2019 at 12:31 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Mon,  7 Oct 2019 12:21:05 -0700, Eric Dumazet wrote:
> > syzbot reported a warning [1] that triggered after recent Jiri patch.
> >
> > This exposes a bug that we hit already in the past (see commit
> > ff244c6b29b1 ("tun: handle register_netdevice() failures properly")
> > for details)
> >
> > tun uses priv->destructor without an ndo_init() method.
> >
> > register_netdevice() can return an error, but will
> > not call priv->destructor() in some cases. Jiri recent
> > patch added one more.
> >
> > A long term fix would be to transfer the initialization
> > of what we destroy in ->destructor() in the ndo_init()
> >
> > This looks a bit risky given the complexity of tun driver.
> >
> > A simpler fix is to detect after the failed register_netdevice()
> > if the tun_free_netdev() function was called already.
> >
> > [...]
> >
> > Fixes: ff92741270bf ("net: introduce name_node struct to be used in hashlist")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Jiri Pirko <jiri@mellanox.com>
> > Reported-by: syzbot <syzkaller@googlegroups.com>
>
> Looks good, obviously. Presumably we could remove the workaround added
> by commit 0ad646c81b21 ("tun: call dev_get_valid_name() before
> register_netdevice()") at this point? What are your thoughts on that?

This is indeed something that could be done now, maybe by an independent revert.
