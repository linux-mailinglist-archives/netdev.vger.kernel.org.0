Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC5E52C9E4E
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 10:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbgLAJrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 04:47:25 -0500
Received: from mail.zx2c4.com ([192.95.5.64]:49939 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728350AbgLAJrZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 04:47:25 -0500
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id d9ff0212
        for <netdev@vger.kernel.org>;
        Tue, 1 Dec 2020 09:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=7/8vfumFiKFWEFGoluigIV+USFo=; b=AKxm+P
        bSVWivfUhCuXfodg30FC+LJXZ8A+1w13r1dTahN1mLQDBODzGi2RQIHCiRif/Glq
        wyW0zYh5L+8/kKfd5JxT4dv8dzatdAlxLwysJTia/jyx50h+sCCggnSXYdPk85Zp
        TVKCXTe5h3nuyBtHqnhbbUAatiSMHojrRUSSngzjboGw2RR1hunYW3/pDTY8o3lB
        qTEvbtF9/wycS6z0wjcpNL7yIlJZ7OdIlczT0dfLh0NXYEF5VFw9mfgXXkFAQZ11
        n0bMQ9O2bKJ1Ji0G/4lRZqXDWVXdk3lhF1Cav+D3wzJDYOu3kJiW4Nur/sF7OJ4/
        /VqsU5fRA44zKPfw==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e8453981 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Tue, 1 Dec 2020 09:41:05 +0000 (UTC)
Received: by mail-yb1-f176.google.com with SMTP id l14so1262785ybq.3
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 01:46:43 -0800 (PST)
X-Gm-Message-State: AOAM530pkHQpEiCGiXUTtn9UDTPUbGxnoKxoroJSn6aNYWaHoz4tS4hX
        h96aQ/+RVe+ynMq+9Jq+s6VIHiwhZRpyT/2agGE=
X-Google-Smtp-Source: ABdhPJx3nrS7OkOcBUPfcHvT7gk54jKmP0Ba83TWRVYWGk0uId64o2IBm5R000g48uJiRz0H7Xj53xvhbEU4cJshx80=
X-Received: by 2002:a25:bb81:: with SMTP id y1mr2259578ybg.456.1606816003001;
 Tue, 01 Dec 2020 01:46:43 -0800 (PST)
MIME-Version: 1.0
References: <20201201092903.3269202-1-yangyingliang@huawei.com>
In-Reply-To: <20201201092903.3269202-1-yangyingliang@huawei.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 1 Dec 2020 10:46:32 +0100
X-Gmail-Original-Message-ID: <CAHmME9rH7iBZN3tMuWuRU_n_dZ1An0FMLpwXWgDJFWjoUFp0fQ@mail.gmail.com>
Message-ID: <CAHmME9rH7iBZN3tMuWuRU_n_dZ1An0FMLpwXWgDJFWjoUFp0fQ@mail.gmail.com>
Subject: Re: [PATCH net v2 1/2] wireguard: device: don't call free_netdev() in priv_destructor()
To:     yangyingliang@huawei.com
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, toshiaki.makita1@gmail.com,
        rkovhaev@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yang,

On Tue, Dec 1, 2020 at 10:31 AM Yang Yingliang <yangyingliang@huawei.com> wrote:
>
> After commit cf124db566e6 ("net: Fix inconsistent teardown and..."),
> priv_destruct() doesn't call free_netdev() in driver, we use
> dev->needs_free_netdev to indicate whether free_netdev() should be
> called on release path.
> This patch remove free_netdev() from priv_destructor() and set
> dev->needs_free_netdev to true.

For now, nack.

I remember when cf124db566e6 came out and carefully looking at the
construction of device.c in WireGuard. priv_destructor is only
assigned after register_device, with the various error paths in
wg_newlink responsible for cleaning up other earlier failures, and
trying to move to needs_free_netdev would have introduced more
complexity in this particular case, if my memory serves. I do not
think there's a memory leak here, and I worry about too hastily
changing the state machine "just because".

In other words, could you point out how to generate a memory leak? If
you're correct, then we can start dissecting and refactoring this. But
off the bat, I'm not sure I'm exactly seeing whatever you're seeing.

Jason
