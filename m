Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B683C36A6EC
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 13:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbhDYLlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 07:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbhDYLlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 07:41:03 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB82C061756
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 04:40:22 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id x5so2615557wrv.13
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 04:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flodin-me.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:cc;
        bh=nlPkc3yLjB8ztnEoQxGNvyEpo51PywG0EprszA54rY4=;
        b=MIo4GLF/Lt+VvXbgjvKPsCstBqsFfHbgM2RI5jpCuT+kHcm4I1jTRoGR469nKYHZVi
         oexNfT+wawzpXjQ3PFzdytAaU4ffg/IE9FCZ8wwYlUn0RWOWt1UikLg4Z26FmORIwHii
         vG1DKNkoS0FyMYx1+KUMRdt/NZuFzxlhaRbRLc/zy8ZMUtcTcm1n9GURcgI4JBLZQDCN
         AzqeNMIX9kRP9/T6e9+opNMcatsbounh/K9ec2GkohvgpyqqxUPHOLK44b/97vptGA4i
         oKVfmfqdyCXLUVemIeAF9S1zM2iqISSBwt4sTo0Uzmys/9T4+iDxC7OEWcmjrm4fE+08
         brUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:cc;
        bh=nlPkc3yLjB8ztnEoQxGNvyEpo51PywG0EprszA54rY4=;
        b=t+1tQ3OrgWOtNMJFMwTSJr45x3HiXtCBt7VgOHQVZqVv2y8rxXqWbyiN0kYw5VP2Fr
         3OuPQKGwGhwCLXNwQQYpfbIaITdgfHcEmSpM2GHLSPBE3L8XKgA9zuVZ/yW2ZzxYnulk
         XGW3ipji3g0xmJpVbdMCsoGkj5PlhK34PLHNGmz9Jqd4Qc5AN5Vmo0noIHqDs4qgOwXH
         65rg+oUMYqAkM7DLvA240wKxIEZfYsBXJCW2/FjQc1iNOD9eWO7SY0zxhUFG4vyu8n3E
         T7rK+0oI78vDuOfen0TwkQy++qk4XTM7V+YH+cUPwUzeLalx1jsHDaK5ykdox6TBwdiQ
         A/Eg==
X-Gm-Message-State: AOAM5330b/xiTkePEfk8ykrSQKQ+P27FHS1ihpDnKKkwE8XNg4uie0dG
        9xL5f5cjYlAXRcKtu1WuDjOT8pMKYfYpE5vygP3B9Q==
X-Received: by 2002:a5d:640e:: with SMTP id z14mt11705016wru.258.1619350821152;
 Sun, 25 Apr 2021 04:40:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210425090751.2jqj4yqx5ztyqhvg@pengutronix.de> <20210425095249.177588-1-erik@flodin.me>
In-Reply-To: <20210425095249.177588-1-erik@flodin.me>
From:   Erik Flodin <erik@flodin.me>
Date:   Sun, 25 Apr 2021 13:40:10 +0200
Message-ID: <CAAMKmodFEXj69mA2nHNfdtJYBTUR+sBpPc_2krm27oKUyVtqKA@mail.gmail.com>
Subject: Re: [PATCH] can: proc: fix rcvlist_* header alignment on 64-bit system
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, mailhol.vincent@wanadoo.fr
Content-Type: text/plain; charset="UTF-8"
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, 25 Apr 2021 at 11:53, Erik Flodin <erik@flodin.me> wrote:
> -       seq_puts(m, "  device   can_id   can_mask  function"
> -                       "  userdata   matches  ident\n");
> +       seq_printf(m, "  device   can_id   can_mask  %sfunction%s  %suserdata%s   matches  ident\n",
> +                  pad, pad, pad, pad);
>  }

If a compile-time variant is better I'm happy to change this to e.g.
something like this:

seq_puts(m, "  device   can_id   can_mask  ");
if (IS_ENABLED(CONFIG_64BIT))
        seq_puts(m, "    function          userdata    ");
else
        seq_puts(m, "function  userdata");
seq_puts(m, "   matches  ident\n");

or something like what Vincent suggested:

#ifdef CONFIG_64BIT
#define PAD "    "
#else
#define PAD ""
#endif
...
seq_puts(m, "  device   can_id   can_mask  " PAD "function  " PAD
PAD "userdata   " PAD "matches  ident\n");

None of these versions are really grep friendly though. If that is
needed, a third variant with two full strings can be used instead.
Just let me know which one that's preferred.

// Erik
