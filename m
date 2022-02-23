Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 564A14C0DE0
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 08:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbiBWH5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 02:57:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238911AbiBWH5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 02:57:43 -0500
Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 469AE3AA4A;
        Tue, 22 Feb 2022 23:57:06 -0800 (PST)
Received: by mail-ua1-f54.google.com with SMTP id 102so1015840uag.6;
        Tue, 22 Feb 2022 23:57:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=unZYoRx7qy/Ff41Y26AN8cnQELm1u+SC3lxaOKhKkBM=;
        b=I/qtiyKcRj7KqKeqiPC1fv68jrUpIszeKwsAqs+jo04eBkfkRI9UbWbz8RwcLZl8nw
         BFNwDWBLlopruEWUsOPwK71ZJ9PkWUlhe00ra1tVVqKGbJSZLC00Stmzih9bDzjYI/GQ
         unUkaRce4mvOzhuWmQEHVhrFrSICItk+HlTvy5dchAnT4snMwt/W9QzFT1zG4XV7ubec
         gTGANgv/KMWY2QcgQWJWTRC6aeYb1btkk75Zvetemg9ZWDcBvXBLN1KVLNKZ0oc56zt7
         BoAvGzvVSKXpWM2/foZr+BbKeOHlscCwljHVijdflB+Q7IibmqptRXryNYwtwO/CtE3Y
         oFtA==
X-Gm-Message-State: AOAM530vZpBZ1OkWBLXQ/eTsWTHSEiUK1LosuoAuLN3DL+YWuHFUkomS
        VtPRoxXdfy2GIi7TToIQOqNQvNe0ml3b+A==
X-Google-Smtp-Source: ABdhPJyCdl+3SPqwSCjPxxbMkj0EvfP+5z/ItTyxrmnnXsO2zb7JfaP4rA/A56HTfxNH8PX8rmpP1Q==
X-Received: by 2002:ab0:48b2:0:b0:30b:883e:d88a with SMTP id x47-20020ab048b2000000b0030b883ed88amr10614192uac.87.1645603025256;
        Tue, 22 Feb 2022 23:57:05 -0800 (PST)
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com. [209.85.217.43])
        by smtp.gmail.com with ESMTPSA id g27sm586272vsp.3.2022.02.22.23.57.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Feb 2022 23:57:04 -0800 (PST)
Received: by mail-vs1-f43.google.com with SMTP id d11so2247960vsm.5;
        Tue, 22 Feb 2022 23:57:04 -0800 (PST)
X-Received: by 2002:a67:af08:0:b0:31b:9451:bc39 with SMTP id
 v8-20020a67af08000000b0031b9451bc39mr11762052vsl.68.1645603024454; Tue, 22
 Feb 2022 23:57:04 -0800 (PST)
MIME-Version: 1.0
References: <20220211233839.2280731-1-bigeasy@linutronix.de>
 <20220211233839.2280731-3-bigeasy@linutronix.de> <CGME20220216085613eucas1p1d33aca0243a3671ed0798055fc65dc54@eucas1p1.samsung.com>
 <da6abfe2-dafd-4aa1-adca-472137423ba4@samsung.com> <alpine.DEB.2.22.394.2202221622570.372449@ramsan.of.borg>
 <YhULprI8YK7YxFo9@linutronix.de>
In-Reply-To: <YhULprI8YK7YxFo9@linutronix.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 23 Feb 2022 08:56:53 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVu7S0+dH3BfaWq534FJZ6Q9Fm1NE0k8TzMDwzh6YCpGQ@mail.gmail.com>
Message-ID: <CAMuHMdVu7S0+dH3BfaWq534FJZ6Q9Fm1NE0k8TzMDwzh6YCpGQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/3] net: dev: Makes sure netif_rx() can be
 invoked in any context.
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sebastian,

On Tue, Feb 22, 2022 at 5:13 PM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> On 2022-02-22 16:30:37 [+0100], Geert Uytterhoeven wrote:
> > Similar on rbtx4927 (CONFIG_NE2000=y), where I'm getting a slightly
> > different warning:
>
> Based on the backtrace the patch in
>    https://lore.kernel.org/all/Yg05duINKBqvnxUc@linutronix.de/
>
> should fix it, right?

Indeed, R-b provided in that thread.
Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
