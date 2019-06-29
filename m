Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 656355A7EF
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 02:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbfF2A7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 20:59:31 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38631 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbfF2A7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 20:59:30 -0400
Received: by mail-qt1-f195.google.com with SMTP id n11so8407177qtl.5
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 17:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=zjhYcZSY1mARYBIzX7XVwQ/EibLPCVp5puzDjQbjh6k=;
        b=m2cb3a8l4H1IwwUH123y/lPF2DQgJXES87c1+xghQkr2wsG0oTAnveOB5DVP/RLZ2X
         l136+AcUcwUolCl6wxPV471D1uLzTDgTwA9mBeDpn6F/ClS4JusxgnLrIyJ76XpNB0H+
         zjS88q8i107MTfm1avvCEyxowoTHFrVbUxS0WNGxS9RTNunbDAxvnCfT2yAc97BjI0xb
         ZaHVTfYVdDzVINUDqap2R2m/+6/VqjWDoXSQshT3NZP8zytuMg2JzojAvzXFdsjNmBYi
         UOnJtJiHWANwMhaPsYox6kfbLtt3LtkIFQ2Qt9nSD+EaaYw5R4YnwzebwYk/QpiMaBr+
         JrTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=zjhYcZSY1mARYBIzX7XVwQ/EibLPCVp5puzDjQbjh6k=;
        b=j7zK9pVoAvdbHfevgR7eLOjWlwtoE5Lxe/2sVktGgRmIVvDRDQRdJu0/yXqVvQHalj
         8qHIDrfcSnsVoCmr+NOyiSj477HP/kj7ZN7nKqUWsTWuqtxy2F5bXrm2U9XjkkTX8/pW
         8/KO5/WvFZ7QBsFfeoA0J3CQajK6nDPfXAn+ZFjJJ44NtXOceTQ4VOdhfmWMu4VWFQSO
         k6Jzu/uL7nGhvbjpCDmJoWsYi8IzqpTItmGvtQ9PBEW1DR71T8YiSpi/yEIQlFOt1R9x
         ody/WMWkVg289qzK+rzwW2netKmrr5ntFcpFW5IMdNL3PTm9c8/Eaxnww05mtKruy95m
         fPSA==
X-Gm-Message-State: APjAAAXz2186v/kzaDrKzjnVxSTwCwr4Yf/rjM9Q7FFHFg9WoeIIUB9g
        Thyk7ieKETUqaxiUHRz8vszS+w==
X-Google-Smtp-Source: APXvYqxkoi+dubFnlzWyNZfZbFl+q2aTvbNwmrU7cVn+CRhZTnrCv7S/Ckgj42DntQLSoCETwmVWhQ==
X-Received: by 2002:ac8:25b1:: with SMTP id e46mr10746988qte.36.1561769969941;
        Fri, 28 Jun 2019 17:59:29 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id d23sm1678467qkk.46.2019.06.28.17.59.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 17:59:29 -0700 (PDT)
Date:   Fri, 28 Jun 2019 17:59:25 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, bpf@vger.kernel.org
Subject: Re: [PATCH 1/2] tls: remove close callback sock unlock/lock and
 flush_sync
Message-ID: <20190628175925.79a763f5@cakuba.netronome.com>
In-Reply-To: <5d16aec74b6cd_35a32adaec47c5c457@john-XPS-13-9370.notmuch>
References: <156165697019.32598.7171757081688035707.stgit@john-XPS-13-9370>
        <156165700197.32598.17496423044615153967.stgit@john-XPS-13-9370>
        <20190627164402.31cbd466@cakuba.netronome.com>
        <5d1620374694e_26962b1f6a4fa5c4f2@john-XPS-13-9370.notmuch>
        <20190628113100.597bfbe6@cakuba.netronome.com>
        <5d166d2deacfe_10452ad82c16e5c0a5@john-XPS-13-9370.notmuch>
        <20190628154841.32b96fb1@cakuba.netronome.com>
        <5d16aec74b6cd_35a32adaec47c5c457@john-XPS-13-9370.notmuch>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jun 2019 17:20:23 -0700, John Fastabend wrote:
> > Why can't tls sockets exist outside of established state?  If shutdown
> > doesn't call close, perhaps we can add a shutdown callback?  It doesn't
> > seem to be called from BH?
> > =20
>=20
> Because the ulp would be shared in this case,
>=20
> 	/* The TLS ulp is currently supported only for TCP sockets
> 	 * in ESTABLISHED state.
> 	 * Supporting sockets in LISTEN state will require us
> 	 * to modify the accept implementation to clone rather then
> 	 * share the ulp context.
> 	 */
> 	if (sk->sk_state !=3D TCP_ESTABLISHED)
> 		return -ENOTSUPP;
>=20
> In general I was trying to avoid modifying core TCP layer to fix
> this corner case in tls.

I see, thanks for clarifying! I was wondering if there's anything wrong
in being in CLOSE/SYN/FIN states.

> > Sorry for all the questions, I'm not really able to fully wrap my head
> > around this. I also feel like I'm missing the sockmap piece that may
> > be why you prefer unhash over disconnect. =20
>=20
> Yep, if we try to support listening sockets we need a some more
> core infrastructure to push around ulp and user_data portions of
> sockets. Its not going to be nice for stable. Also at least in TLS
> and sockmap case its not really needed for any use case I know
> of.

IIUC we can't go from ESTABLISHED to LISTEN without calling close()=20
or disconnect() so I'm not clear on why are we hooking into unhash() =F0=9F=
=98=95
