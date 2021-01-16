Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667C42F8EE1
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 20:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbhAPT1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 14:27:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:37558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725979AbhAPT1U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Jan 2021 14:27:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96E6D23117
        for <netdev@vger.kernel.org>; Sat, 16 Jan 2021 19:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610825199;
        bh=nwZgsIwiQ3Bh2JMPc852BCxV2RwVJWZLd5IOB5wtvSk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Phv9slg/5SSRFRj/PpVpWx5TUgcqtDkTHA6YEdh1SZLd94/af2nN48E6QznGL59Dx
         Z2Qvah0xfnP1vFNWiuPuImDHWTDQdGvincqfPk0bdydz3497Im/10t/d4omLBnGphO
         yaLB8K4RT3CLYrc53qbH7+a4xBRpsj4EtI+L5VqaydSmgUPqFO9kiJUgemO35mWMR9
         nn/7QB83wrRGfKmeVj6fkuKge7TqdL0unYX5cpBgtO/Q9Z+qBm+Z2sL3e66VCGzI9n
         95dK0JLSD6UuAsXrzpANZ1TBsfybLWyaX5sEEytibzyoHRFn52KvNh3Dt/s19+uNmJ
         c4R5fIoylxsCw==
Received: by mail-oi1-f171.google.com with SMTP id f132so13343335oib.12
        for <netdev@vger.kernel.org>; Sat, 16 Jan 2021 11:26:39 -0800 (PST)
X-Gm-Message-State: AOAM532wQAVElUlohv6uXOE9baiOebADlSSvWWI4HbG71X5HUyBk6P//
        IdjM2r3VhfNiiA2YjRElky8PO5OFHe3s/yV3y6k=
X-Google-Smtp-Source: ABdhPJy2yWmQsThkgFJ46WST/2NDFnPg0ht4fZO6LsqFIgOkLy9gUU4zqLbpLhsYuwog41P7uq74Pq2dajHXFLut1Ew=
X-Received: by 2002:aca:44d:: with SMTP id 74mr9446154oie.4.1610825198979;
 Sat, 16 Jan 2021 11:26:38 -0800 (PST)
MIME-Version: 1.0
References: <20210116164828.40545-1-marex@denx.de> <CAK8P3a1iqXjsYERVh+nQs9Xz4x7FreW3aS7OQPSB8CWcntnL4A@mail.gmail.com>
 <a660f328-19d9-1e97-3f83-533c1245622e@denx.de>
In-Reply-To: <a660f328-19d9-1e97-3f83-533c1245622e@denx.de>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Sat, 16 Jan 2021 20:26:22 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3qtrmxMg+uva-s18f_zj7aNXJXcJCzorr2d-XxnqV1Hw@mail.gmail.com>
Message-ID: <CAK8P3a3qtrmxMg+uva-s18f_zj7aNXJXcJCzorr2d-XxnqV1Hw@mail.gmail.com>
Subject: Re: [PATCH net-next V2] net: ks8851: Fix mixed module/builtin build
To:     Marek Vasut <marex@denx.de>
Cc:     Networking <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Arnd Bergmann <arnd@arndb.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Lukas Wunner <lukas@wunner.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 16, 2021 at 6:56 PM Marek Vasut <marex@denx.de> wrote:
> On 1/16/21 6:04 PM, Arnd Bergmann wrote:
> > On Sat, Jan 16, 2021 at 5:48 PM Marek Vasut <marex@denx.de> wrote:
>
> > I don't really like this version, as it does not actually solve the problem of
> > linking the same object file into both vmlinux and a loadable module, which
> > can have all kinds of side-effects besides that link failure you saw.
> >
> > If you want to avoid exporting all those symbols, a simpler hack would
> > be to '#include "ks8851_common.c" from each of the two files, which
> > then always duplicates the contents (even when both are built-in), but
> > at least builds the file the correct way.
>
> That's the same as V1, isn't it ?

Ah, I had not actually looked at the original submission, but yes, that
was slightly better than v2, provided you make all symbols static to
avoid the new link error.

I still think that having three modules and exporting the symbols from
the common part as Heiner Kallweit suggested would be the best
way to do it.

        Arnd
