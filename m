Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3C0933FCE
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 09:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfFDHRi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 4 Jun 2019 03:17:38 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42079 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbfFDHRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 03:17:38 -0400
Received: by mail-lj1-f196.google.com with SMTP id t28so7510789lje.9;
        Tue, 04 Jun 2019 00:17:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uXFhS7Fhht2cVxXQgdevMCQkg9IO5A4+7VWwz6q4IHQ=;
        b=lhbcO5W86Xa6YxcXHXHNr3pV01dr02t+x3pwppEu10N2usOSKTzCfs15SvnkGbcq8K
         N+HFL6ul3fD7EqTzn1XziT/A5TM4eMUve4ZN6RlcDdskVnzOT7V2JFzlRfRK/EfkH+WE
         hE3eRAt1m6uwVscouaQi95NsUz8HQsOebHi+NIPiMttr3nstkwyJ2/XinpkqaUdAWM2g
         qaOQ4JLAwfx89v5p5ZDPq/Lbq0rvkzDgIHaQ13JJf0RUpwAhac1GDUBRgRCBl6ysyk8G
         klg2BeHdlgoyfhS8+3CyVJQfy0R1Soco7Yn+blLgbz6okw1aHON5HQlshxXGOJgSWE+D
         us4Q==
X-Gm-Message-State: APjAAAVLqXdhXgvu49Gj7TaghPEYq8z4euoQemHTtVGy2YXFlHyndPaK
        6WBMke1YnZ3g2d4gBTZ5hbNUZ3qCbUtHvGD0p+VnMyPv
X-Google-Smtp-Source: APXvYqyyZ2LjfsWzKbQvADxUxY+XiY/8hXkqr4Kstn7jTiKw8xfdZP/KjDVpKZALARnI7yGQkBB7ySKrnAGa0wizxpk=
X-Received: by 2002:a2e:91c5:: with SMTP id u5mr4591585ljg.65.1559632655971;
 Tue, 04 Jun 2019 00:17:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190528142424.19626-1-geert@linux-m68k.org> <20190528142424.19626-3-geert@linux-m68k.org>
 <15499.1559298884@warthog.procyon.org.uk>
In-Reply-To: <15499.1559298884@warthog.procyon.org.uk>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 4 Jun 2019 09:17:23 +0200
Message-ID: <CAMuHMdX57DKCMpLXdtZPE-w0esUNVv9-SwYjmT5=m+u9ryAiHQ@mail.gmail.com>
Subject: Re: [PATCH] rxrpc: Fix uninitialized error code in rxrpc_send_data_packet()
To:     David Howells <dhowells@redhat.com>
Cc:     Igor Konopko <igor.j.konopko@intel.com>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Matias Bjorling <mb@lightnvm.io>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Clemens Ladisch <clemens@ladisch.de>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, Joe Perches <joe@perches.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-block@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        linux-afs@lists.infradead.org,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Fri, May 31, 2019 at 12:35 PM David Howells <dhowells@redhat.com> wrote:
> Here's my take on the patch.
>
> David
> ---
> rxrpc: Fix uninitialized error code in rxrpc_send_data_packet()
>
> With gcc 4.1:
>
>     net/rxrpc/output.c: In function ‘rxrpc_send_data_packet’:
>     net/rxrpc/output.c:338: warning: ‘ret’ may be used uninitialized in this function
>
> Indeed, if the first jump to the send_fragmentable label is made, and
> the address family is not handled in the switch() statement, ret will be
> used uninitialized.
>
> Fix this by BUG()'ing as is done in other places in rxrpc where internal
> support for future address families will need adding.  It should not be
> possible to reach this normally as the address families are checked
> up-front.
>
> Fixes: 5a924b8951f835b5 ("rxrpc: Don't store the rxrpc header in the Tx queue sk_buffs")
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: David Howells <dhowells@redhat.com>

I'm not such a big fan of BUG(), so I'd go for ret = -EAFNOSUPPORT, but given
rxrpc is already full of BUG() calls, I guess it is an acceptable solution.

> ---
> diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
> index 004c762c2e8d..6f2b4fb4b0aa 100644
> --- a/net/rxrpc/output.c
> +++ b/net/rxrpc/output.c
> @@ -523,6 +523,9 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
>                 }
>                 break;
>  #endif
> +
> +       default:
> +               BUG();
>         }
>
>         if (ret < 0)

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
