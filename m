Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E06222B81B9
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 17:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbgKRQXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 11:23:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:55718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726094AbgKRQXi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 11:23:38 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6247C247E0;
        Wed, 18 Nov 2020 16:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605716617;
        bh=B2MIhpN62+faAbFM1MCOo9a+SrIu7L6XJFci0rtAaw0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KGMM8FanuqLi0xx0wNJa/kULBupHA7JhUKyQRtduo807wHQydkUPB/lRQ2e5JHtQS
         Dl8I0XXRnnD3vfrAc9deYZUkn8M9J9Bip9ts1qjczygiDhS0zN7wa4cHKw/Lnk/Sy7
         FnAr//aOqltqY4PqeRLIbmLoggQVKtOQ1Am2wnDg=
Date:   Wed, 18 Nov 2020 08:23:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>, netdev@vger.kernel.org
Subject: Re: [net] net/tls: missing received data after fast remote close
Message-ID: <20201118082336.6513c6c0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <33ede124-583b-4bdd-621b-638bbca1a6c8@novek.ru>
References: <1605440628-1283-1-git-send-email-vfedorenko@novek.ru>
        <20201117143847.2040f609@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <71f25f4d-a92c-8c56-da34-9d6f7f808c18@novek.ru>
        <20201117175344.2a29859a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <33ede124-583b-4bdd-621b-638bbca1a6c8@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 02:47:24 +0000 Vadim Fedorenko wrote:
> >>>> This behavior differs from plain TCP socket and
> >>>> leads to special treating in user-space. Patch unpauses parser
> >>>> directly if we have unparsed data in tcp receive queue. =20
> >>> Sure, but why is the parser paused? Does it pause itself on FIN? =20
> >> No, it doesn't start even once. The trace looks like:
> >>
> >> tcp_recvmsg is called
> >> tcp_recvmsg returns 1 (Change Cipher Spec record data)
> >> tls_setsockopt is called
> >> tls_setsockopt returns
> >> tls_recvmsg is called
> >> tls_recvmsg returns 0
> >> __strp_recv is called
> >> stack
> >>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __strp_recv+1
> >>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 tcp_read_sock+169
> >>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 strp_read_sock+104
> >>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 strp_work+68
> >>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 process_one_work+436
> >>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 worker_thread+80
> >>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kthread+276
> >>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret_from_fork+34tls_read_=
size called
> >>
> >> So it looks like strp_work was scheduled after tls_recvmsg and
> >> nothing triggered parser because all the data was received before
> >> tls_setsockopt ended the configuration process. =20
> > Um. That makes me think we need to flush_work() on the strparser after
> > we configure rx tls, no? Or __unpause at the right time instead of
> > dealing with the async nature of strp_check_rcv()? =20
> I'm not sure that flush_work() will do right way in this case. Because:
> 1. The work is idle after tls_sw_strparser_arm()

Not sure what you mean by idle, it queues the work via strp_check_rcv().

> 2. The strparser needs socket lock to do it's work - that could be a
> deadlock because setsockopt_conf already holds socket lock. I'm not
> sure that it's a good idea to unlock socket just to wait the strparser.

Ack, I meant in do_tls_setsockopt() after the lock is released.

> The async nature of parser is OK for classic HTTPS server/client case
> because it's very good to have parsed record before actual call to recvmsg
> or splice_read is done. The code inside the loop in tls_wait_data is slow
> path - maybe just move the check and the __unpause in this slow path?

Yeah, looking closer this problem can arise after we start as well :/

How about we move the __unparse code into the loop tho? Seems like this
could help with latency. Right now AFAICT we get a TCP socket ready
notification, which wakes the waiter for no good reason and makes
strparser queue its work, the work then will call tls_queue() ->
data_ready waking the waiting thread second time this time with the
record actually parsed.

Did I get that right? Should the waiter not cancel the work on the
first wake up and just kick of the parsing itself?
