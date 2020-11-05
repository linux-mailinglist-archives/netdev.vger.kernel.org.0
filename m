Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E7F2A81DA
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 16:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731006AbgKEPHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 10:07:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:56174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728371AbgKEPHN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 10:07:13 -0500
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1CE522210;
        Thu,  5 Nov 2020 15:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604588832;
        bh=iGxDjGpgZgvh1at2/59sSPdVCtzZKM9jCmS50+iMi3E=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=RL8Yxi3b4nBNd50oejfwXK6xegX1iflPA7ERuLp1Ndd/RGOer8n4zqguIpdDv7REL
         0D3kedysHHVG0MONILeThjZnfZ70toRQGAo7rzWFijqay/AGv/7vkSSoSxNO8E855z
         Ze9Tjix7M53/tgPRrifDZ7YcBCnX0e9ZHhiU88x4=
Received: by mail-wm1-f51.google.com with SMTP id h22so1941146wmb.0;
        Thu, 05 Nov 2020 07:07:11 -0800 (PST)
X-Gm-Message-State: AOAM531MS8gqn2Sc82PFxSTq9rnsoeiNip5JXCAeubGeANB2mbbl4sIl
        G1J1qKz/lKrBaIFZ5P+ak90sy/b0acmaQ0UFIgI=
X-Google-Smtp-Source: ABdhPJwFJINOEnDFfpK3PkNNsRXbOb9RCrfaMzLA61u9jqh2TFcDUA6ZjaE9FjcClJZlpFBXwreXQg11d88l56RHWWc=
X-Received: by 2002:a1c:e919:: with SMTP id q25mr3176667wmc.142.1604588830214;
 Thu, 05 Nov 2020 07:07:10 -0800 (PST)
MIME-Version: 1.0
References: <20201105073434.429307-1-xie.he.0141@gmail.com>
In-Reply-To: <20201105073434.429307-1-xie.he.0141@gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Thu, 5 Nov 2020 16:06:54 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2bk9ZpoEvmhDpSv8ByyO-LevmF-W4Or_6RPRtV6gTQ1w@mail.gmail.com>
Message-ID: <CAK8P3a2bk9ZpoEvmhDpSv8ByyO-LevmF-W4Or_6RPRtV6gTQ1w@mail.gmail.com>
Subject: Re: [PATCH net-next] net: x25_asy: Delete the x25_asy driver
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Martin Schiller <ms@dev.tdt.de>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        linux-x25@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 5, 2020 at 8:34 AM Xie He <xie.he.0141@gmail.com> wrote:
>
> This driver transports LAPB (X.25 link layer) frames over TTY links.
>
> I can safely say that this driver has no actual user because it was
> not working at all until:
> commit 8fdcabeac398 ("drivers/net/wan/x25_asy: Fix to make it work")
>
> The code in its current state still has problems:
>
> 1.
> The uses of "struct x25_asy" in x25_asy_unesc (when receiving) and in
> x25_asy_write_wakeup (when sending) are not protected by locks against
> x25_asy_change_mtu's changing of the transmitting/receiving buffers.
> Also, all "netif_running" checks in this driver are not protected by
> locks against the ndo_stop function.
>
> 2.
> The driver stops all TTY read/write when the netif is down.
> I think this is not right because this may cause the last outgoing frame
> before the netif goes down to be incompletely transmitted, and the first
> incoming frame after the netif goes up to be incompletely received.
>
> And there may also be other problems.
>
> I was planning to fix these problems but after recent discussions about
> deleting other old networking code, I think we may just delete this
> driver, too.
>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>
> ---
>  Documentation/process/magic-number.rst        |   1 -
>  .../it_IT/process/magic-number.rst            |   1 -
>  .../zh_CN/process/magic-number.rst            |   1 -
>  arch/mips/configs/gpr_defconfig               |   1 -
>  arch/mips/configs/mtx1_defconfig              |   1 -
>  drivers/net/wan/Kconfig                       |  15 -
>  drivers/net/wan/Makefile                      |   1 -
>  drivers/net/wan/x25_asy.c                     | 836 ------------------
>  drivers/net/wan/x25_asy.h                     |  46 -
>  9 files changed, 903 deletions(-)
>  delete mode 100644 drivers/net/wan/x25_asy.c
>  delete mode 100644 drivers/net/wan/x25_asy.h

Adding Martin Schiller and Andrew Hendry, plus the linux-x25 mailing
list to Cc. When I last looked at the wan drivers, I think I concluded
that this should still be kept around, but I do not remember why.
OTOH if it was broken for a long time, that is a clear indication that
it was in fact unused.

Since you did the bugfix mentioned above, do you have an idea
when it could have last worked? I see it was originally merged in
linux-2.3.21, and Stephen Hemminger did a cleanup for
linux-2.6.0-rc3 that he apparently tested but also said "Not sure
if anyone ever uses this.".

Hopefully Martin or Andrew can provide a definite Ack or Nack on this.

      Arnd
