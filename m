Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939B62B73E6
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 02:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725814AbgKRBxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 20:53:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:38816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgKRBxq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 20:53:46 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4396241A7;
        Wed, 18 Nov 2020 01:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605664426;
        bh=dKC5x2c3MTPF/ZR2X1EPQwR1UL6FxaZ7F4Ja2sRAlD8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kmuLMR8733N0BZLAJpCXERWNq7oamiUgGc1gVns2OSg9YWg7jd+NJR59shhFg4hj0
         WEo9PWzIC3XrqizKVQtuO0uSlx3pmqL56PIBuVAMwUJsCLj4r9wSb+8n1TyYVSSR6v
         3bhoDYFEqR94SWfVq15Lo84KYs1FsdPdqFxgAbWA=
Date:   Tue, 17 Nov 2020 17:53:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>, netdev@vger.kernel.org
Subject: Re: [net] net/tls: missing received data after fast remote close
Message-ID: <20201117175344.2a29859a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <71f25f4d-a92c-8c56-da34-9d6f7f808c18@novek.ru>
References: <1605440628-1283-1-git-send-email-vfedorenko@novek.ru>
        <20201117143847.2040f609@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <71f25f4d-a92c-8c56-da34-9d6f7f808c18@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 00:50:48 +0000 Vadim Fedorenko wrote:
> On 17.11.2020 22:38, Jakub Kicinski wrote:
> > On Sun, 15 Nov 2020 14:43:48 +0300 Vadim Fedorenko wrote: =20
> >> In case when tcp socket received FIN after some data and the
> >> parser haven't started before reading data caller will receive
> >> an empty buffer. =20
> > This is pretty terse, too terse for me to understand.. =20
> The flow is simple. Server sends small amount of data right after the
> connection is configured and closes the connection. In this case
> receiver sees TLS Handshake data, configures TLS socket right after
> Change Cipher Spec record. While the configuration is in process, TCP
> socket receives small Application Data record, Encrypted Alert record
> and FIN packet. So the TCP socket changes sk_shutdown to RCV_SHUTDOWN
> and sk_flag with SK_DONE bit set.

Thanks! That's clear. This is a race, right, you can't trigger=20
it reliably?

BTW please feel free to add your cases to the tls selftest in
tools/testing/selftests.

> >> This behavior differs from plain TCP socket and
> >> leads to special treating in user-space. Patch unpauses parser
> >> directly if we have unparsed data in tcp receive queue. =20
> > Sure, but why is the parser paused? Does it pause itself on FIN? =20
> No, it doesn't start even once. The trace looks like:
>=20
> tcp_recvmsg is called
> tcp_recvmsg returns 1 (Change Cipher Spec record data)
> tls_setsockopt is called
> tls_setsockopt returns
> tls_recvmsg is called
> tls_recvmsg returns 0
> __strp_recv is called
> stack
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __strp_recv+1
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 tcp_read_sock+169
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 strp_read_sock+104
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 strp_work+68
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 process_one_work+436
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 worker_thread+80
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kthread+276
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret_from_fork+34tls_read_size=
 called
>=20
> So it looks like strp_work was scheduled after tls_recvmsg and
> nothing triggered parser because all the data was received before
> tls_setsockopt ended the configuration process.

Um. That makes me think we need to flush_work() on the strparser after
we configure rx tls, no? Or __unpause at the right time instead of
dealing with the async nature of strp_check_rcv()?
