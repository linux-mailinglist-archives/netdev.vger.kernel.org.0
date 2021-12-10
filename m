Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC447470583
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 17:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240957AbhLJQYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 11:24:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240860AbhLJQYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 11:24:50 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5D44C0617A1
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 08:21:15 -0800 (PST)
Date:   Fri, 10 Dec 2021 17:21:13 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639153274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v2xHwH30XiHU8RISXICjMVmCz5MMM/FnpvpoghexuD0=;
        b=gcw02KXui6Vx50UKBFgruDc6RPtS3OYYXQDEhK+jYcS6wI9Vk/Tss6u4T5ADAXbgt/O2xG
        XmZg4pOHePq6agGkA4XFFiHqI7OrivPYK2GBStzzDk9PE870dmvPRoJwFhtoa8E4dSh7eK
        lJo+jNVVyC9npItyqpQdJ+tSefGhtDMBOCw8UkB3vOEE0HrnyQkEuI4tRvHo7udMPJHOcD
        iDrhy7f+QjYWXfwihVekhmBTu+TY9UPclffdTUlO82FlJyzwRLmDovq3YWba6R96J0ksC7
        D/2FE7+yX0ru+P1lgWMEkA1231QcjbZ3c+qBewgHq6MLhoRB7IpwOUEiJD844A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639153274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v2xHwH30XiHU8RISXICjMVmCz5MMM/FnpvpoghexuD0=;
        b=AuPuSAwUMc+rwrtr0OwcwaHdVsa4kDS1U/lvDxKf/3wKQqzBbAuH2DQ2yXbSSFanFWPQox
        Xtol6ihCqzqMsqAA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        eric.dumazet@gmail.com, davem@davemloft.net, dsahern@kernel.org,
        efault@gmx.de, netdev@vger.kernel.org, tglx@linutronix.de,
        yoshfuji@linux-ipv6.org
Subject: Re: [PATCH net v2] tcp: Don't acquire inet_listen_hashbucket::lock
 with disabled BH.
Message-ID: <YbN+edCO3DGMDPmj@linutronix.de>
References: <20211206120216.mgo6qibl5fmzdcrp@linutronix.de>
 <20211209200632.wpusjdlad5hyaal6@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20211209200632.wpusjdlad5hyaal6@kafai-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-09 12:06:32 [-0800], Martin KaFai Lau wrote:
> > local_bh_disable() + spin_lock(&ilb->lock):
> >   inet_listen()
> >     inet_csk_listen_start()
> >       sk->sk_prot->hash() :=3D inet_hash()
> > 	local_bh_disable()
> > 	__inet_hash()
> > 	  spin_lock(&ilb->lock);
> > 	    acquire(&ilb->lock);
> >=20
> > Reverse order: spin_lock(&ilb->lock) + local_bh_disable():
> >   tcp_seq_next()
> >     listening_get_next()
> >       spin_lock(&ilb->lock);
> The net tree has already been using ilb2 instead of ilb.
> It does not change the problem though but updating
> the commit log will be useful to avoid future confusion.

You think so? But having ilb2 and ilb might suggest that these two are
different locks while they are the same. I could repost it early next
week if you this actually confuses more=E2=80=A6

> iiuc, established_get_next() does not hit this because
> it calls spin_lock_bh() which then keeps the
> local_bh_disable() =3D> spin_lock() ordering?

Yes. BH was disabled before the spin_lock was acquired so it is the same
ordering. The important part is not to disable BH after the spin_lock
was acquired and in the reverse order.

> The patch lgtm.
> Acked-by: Martin KaFai Lau <kafai@fb.com>

Sebastian
