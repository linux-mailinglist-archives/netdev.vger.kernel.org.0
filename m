Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19A4A16025
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 11:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbfEGJHv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 7 May 2019 05:07:51 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:38890 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbfEGJHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 05:07:50 -0400
Received: by mail-vs1-f66.google.com with SMTP id v9so2115025vse.5;
        Tue, 07 May 2019 02:07:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8lThRAo28vQwCl4DV4/hRXs4pusVcLZ06vXVXU+ReNg=;
        b=UApIQqVvCdCdwez208QOX/KvpZdg45Aw0SyxZfCSaIKvmTC3Ti92Vq/UATMBa5SBu0
         aVW7JcE570usIfzi+EPhs6sES83dCX9JdSYqlMIgYmEWEZsWJ5pXlpBz2amqrOqKmn2S
         HRCKgtsXudML+kN1HaP80O+jVUcisFVihF4Tm7kZvmSNHnEV8YqrMFa7sW69rmvFKXxq
         I6WGi8bLazGmTgL0CMoJdGpH8sZWKbkugn22iU/ZleACG/dEdE/qGqK5ddMFUT3oZCSU
         00uw5rwkoi8GboV2rX2qPUyuKgB9cOnkl4Jm3FRCvyDKwxinyWXBlvF4/wBgIMqscTxB
         kBTg==
X-Gm-Message-State: APjAAAUheCQC4ZgSDlgnc5srBkUJAB+BMsNuBYUBsDbZ7vV/0EFOmtcR
        g+RR9/U/tsRKERARt6wI2blc7Fgu1o84vm3y1KY=
X-Google-Smtp-Source: APXvYqyd0GOgX82w7/Ps0Lm4sBbfBrQV34Mg2L46fkooG6+5Z29jjbCP+ChBPEI7uLyAXz7jM3WBzg+6K0S1grth8pg=
X-Received: by 2002:a67:8e03:: with SMTP id q3mr15845324vsd.152.1557220063399;
 Tue, 07 May 2019 02:07:43 -0700 (PDT)
MIME-Version: 1.0
References: <1557177887-30446-1-git-send-email-ynezz@true.cz>
In-Reply-To: <1557177887-30446-1-git-send-email-ynezz@true.cz>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 7 May 2019 11:07:31 +0200
Message-ID: <CAMuHMdVra2h00OUCxZ1s=ExpkgkN_SGZdUtdohBapjNHf6hesQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/4] of_get_mac_address ERR_PTR fixes
To:     =?UTF-8?Q?Petr_=C5=A0tetiar?= <ynezz@true.cz>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        driverdevel <devel@driverdev.osuosl.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mediatek@lists.infradead.org,
        Frank Rowand <frowand.list@gmail.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Petr,

On Mon, May 6, 2019 at 11:25 PM Petr Štetiar <ynezz@true.cz> wrote:
> this patch series is an attempt to fix the mess, I've somehow managed to
> introduce.
>
> First patch in this series is defacto v5 of the previous 05/10 patch in the
> series, but since the v4 of this 05/10 patch wasn't picked up by the
> patchwork for some unknown reason, this patch wasn't applied with the other
> 9 patches in the series, so I'm resending it as a separate patch of this
> fixup series again.
>
> Second patch is a result of this rebase against net-next tree, where I was
> checking again all current users of of_get_mac_address and found out, that
> there's new one in DSA, so I've converted this user to the new ERR_PTR
> encoded error value as well.
>
> Third patch which was sent as v5 wasn't considered for merge, but I still
> think, that we need to check for possible NULL value, thus current IS_ERR
> check isn't sufficient and we need to use IS_ERR_OR_NULL instead.
>
> Fourth patch fixes warning reported by kbuild test robot.
>
> Cheers,
>
> Petr
>
> Petr Štetiar (4):
>   net: ethernet: support of_get_mac_address new ERR_PTR error

I didn't receive the patch through email, but patchwork does have it:
https://patchwork.ozlabs.org/patch/1096054/

This fixes the crash ("Unable to handle kernel paging request atvirtual
address fffffffe") I'm seeing with sh_eth on r8a7791/koelsch, so

Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
