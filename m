Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5655011FA41
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 19:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfLOSAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 13:00:02 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:36147 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726346AbfLOSAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 13:00:01 -0500
Received: by mail-ot1-f67.google.com with SMTP id i4so5926198otr.3;
        Sun, 15 Dec 2019 10:00:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9fJ0LWYw9AfYu5ktwDXf17s2jDM7dPBu5+xWG/aTJpg=;
        b=P8rdlsnWDUqLmIGutoirlP2ON30p/BbtEX2fsdBkAXoYUgACve5TS3RDWOsoYDbdRD
         3OZbpjZxDzr93JPik6Il3WtY2/2zoGOJgMxXcQEJnrAUIPMO6/lH/8YGmZ78i9nvdXA/
         pEJYvoooM/MVvFX2AgiAYtR2pKErXcvOgqkRM0HLadnGx/0GDUQfuDv+akaTiDH3vnik
         2WSntiMm7wjhpDFLvRGQ+VKP1ZQYu3IMcqTEm43aqzvR282Ln0KqnO8gz21dVlbWWqEt
         UTc7+t+imddDjyZ6StKYbQ2qQ5ocFL0y0EdSmPbXlCvk/FgP2N10R5AAJwGP0QK9mP71
         8ONg==
X-Gm-Message-State: APjAAAUH+rf2f04UZM1kv0qRhwXZiCOqbqSZL8ZEK6fZ1ubwIv0DQOpZ
        1LzvjXxy2FczlbaZf5dJDrC+Et2hFXWJpFn4rW8=
X-Google-Smtp-Source: APXvYqweU6+eLolGhQ1GP76ei4WBc/pILrjGMBaPf/+81RXB8SQJ9StRzVmc9XoykZ8tB9azr+V6L5oIbAyUUkLBrUo=
X-Received: by 2002:a9d:6c81:: with SMTP id c1mr27915439otr.39.1576432800843;
 Sun, 15 Dec 2019 10:00:00 -0800 (PST)
MIME-Version: 1.0
References: <20191215175132.30139-1-pakki001@umn.edu>
In-Reply-To: <20191215175132.30139-1-pakki001@umn.edu>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Sun, 15 Dec 2019 18:59:49 +0100
Message-ID: <CAMuHMdWUv+f=b4cMDX7dbK0fW=YnL=L11ODvZc9mh+L-02jo_w@mail.gmail.com>
Subject: Re: [PATCH] net: caif: replace BUG_ON with recovery code
To:     Aditya Pakki <pakki001@umn.edu>
Cc:     Kangjie Lu <kjlu@umn.edu>, "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Allison Randal <allison@lohutok.net>,
        Richard Fontana <rfontana@redhat.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yang Wei <yang.wei9@zte.com.cn>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Aditya,

On Sun, Dec 15, 2019 at 6:51 PM Aditya Pakki <pakki001@umn.edu> wrote:
> In caif_xmit, there is a crash if the ptr dev is NULL. However, by
> returning the error to the callers, the error can be handled. The
> patch fixes this issue.
>
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>

Thanks for your patch!

> --- a/drivers/net/caif/caif_serial.c
> +++ b/drivers/net/caif/caif_serial.c
> @@ -270,7 +270,9 @@ static int caif_xmit(struct sk_buff *skb, struct net_device *dev)
>  {
>         struct ser_device *ser;
>
> -       BUG_ON(dev == NULL);
> +       if (WARN_ON(!dev))

This will still crash the kernel with panic_on_warn.

> +               return -EINVAL;
> +
>         ser = netdev_priv(dev);
>
>         /* Send flow off once, on high water mark */

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
