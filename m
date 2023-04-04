Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C076D57DF
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 07:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbjDDFLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 01:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjDDFLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 01:11:19 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CDFB1BEF
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 22:11:17 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id i5-20020a05600c354500b003edd24054e0so21035545wmq.4
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 22:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680585076;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wzPOvJscc9tACXUfbSOD18zm90A8zRKWHKNSuCMhPcE=;
        b=boh8dVOww3NBPTWpNkzQoTInKuaEmhekTdncs6AO5N17qsgrUSoGrCdkpyNVv/KBRS
         x59JfNO3BQ7YWLqbryyj+2A0aw112n9VZZvB2eY9jo5p7W1/DVNK27k2RBWxhHouGhPd
         j6GyivMZjfb+Y8pS1NC27KfiuGNphmnzNIaCBlNsTWNf1YvDE2f5bFvvm/XYB9NZ/i5k
         TW0I6aqw5VodNkVdOA6Sro1U4g5sj5iKaBJormWMBlWCyHX90ThJxO/ptDl4abVVKmrd
         xpdcmBHeKjMeRgYgiLfDAvC1V/cyN1948ovh2IlFvVhdtbphnTw9Vye59r4HqhQ5+tBS
         /Ikg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680585076;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wzPOvJscc9tACXUfbSOD18zm90A8zRKWHKNSuCMhPcE=;
        b=2wZ0GRraFKhpV39xi/dzbYs7ceEEPBU4hNQckHDsIpTHGX0uCozCIyECkjXmtwx9I5
         /qSlv7EPzKGjNfNT4MHFMrQLLWEcUViHPBXq8v0MCgDlNTGR6V+xHaOBUJS/dCYAQjVa
         Rle3drlZ0vKG/HND4Y2YcrT/ajawEf+rY8PvJPGqu6TI1yrM65iE4wuGYd1FRK7TMaNs
         ipjWti8B5/KC93kPhM5e0Xf9lwx1JarQhCMYjsx+/k2aUvI7TIwbRohvtsL8+32sr7U/
         25Q88jEgOkGBO2CAV/afyh1q0MZ79AOli+tEH3smyEs9jyjXohq0Qipp3ceECHjXZ9/C
         xJ8Q==
X-Gm-Message-State: AAQBX9c0jAYGf+NdreZ+Epf+DgAY+QM+lIEcq92h+dl3B/uofYMsDSi4
        AzzSibMsD0kXX0UQD3TUKlzzAK/yHWhmlAXPH6mCQl76Ue7okCzqc+RGEA==
X-Google-Smtp-Source: AKy350a6PFmoS0+rqrTKJEgRQcr3aYA2/l4d96Gk7Aqm2Ay7p1Uao9Zn0LiJW+ASDug6H4vrQYyC22cIj/TmY9iXQGo=
X-Received: by 2002:a05:600c:da:b0:3ed:7664:6d79 with SMTP id
 u26-20020a05600c00da00b003ed76646d79mr420920wmm.0.1680585075684; Mon, 03 Apr
 2023 22:11:15 -0700 (PDT)
MIME-Version: 1.0
References: <ZCsbJ4nG+So/n9qY@shell.armlinux.org.uk>
In-Reply-To: <ZCsbJ4nG+So/n9qY@shell.armlinux.org.uk>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 4 Apr 2023 07:11:04 +0200
Message-ID: <CANn89i+GbHi9wJFjePO8bC6jyJXp0wvO5gLPmZRzE8gbrpBtEA@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 0/6] net: mvneta: reduce size of TSO header allocation
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 3, 2023 at 8:30=E2=80=AFPM Russell King (Oracle)
<linux@armlinux.org.uk> wrote:
>
> Hi,
>
> With reference to
> https://forum.turris.cz/t/random-kernel-exceptions-on-hbl-tos-7-0/18865/
>
> It appears that mvneta attempts an order-6 allocation for the TSO
> header memory. While this succeeds early on in the system's life time,
> trying order-6 allocations later can result in failure due to memory
> fragmentation.
>
> Firstly, the reason it's so large is that we take the number of
> transmit descriptors, and allocate a TSO header buffer for each, and
> each TSO header is 256 bytes. The driver uses a simple mechanism to
> determine the address - it uses the transmit descriptor index as an
> index into the TSO header memory.
>
>         (The first obvious question is: do there need to be this
>         many? Won't each TSO header always have at least one bit
>         of data to go with it? In other words, wouldn't the maximum
>         number of TSO headers that a ring could accept be the number
>         of ring entries divided by 2?)
>
> There is no real need for this memory to be an order-6 allocation,
> since nothing in hardware requires this buffer to be contiguous.
>
> Therefore, this series splits this order-6 allocation up into 32
> order-1 allocations (8k pages on 4k page platforms), each giving
> 32 TSO headers per page.
>
> In order to do this, these patches:
>
> 1) fix a horrible transmit path error-cleanup bug - the existing
>    code unmaps from the first descriptor that was allocated at
>    interface bringup, not the first descriptor that the packet
>    is using, resulting in the wrong descriptors being unmapped.
>
> 2) since xdp support was added, we now have buf->type which indicates
>    what this transmit buffer contains. Use this to mark TSO header
>    buffers.
>
> 3) get rid of IS_TSO_HEADER(), instead using buf->type to determine
>    whether this transmit buffer needs to be DMA-unmapped.
>
> 4) move tso_build_hdr() into mvneta_tso_put_hdr() to keep all the
>    TSO header building code together.
>
> 5) split the TSO header allocation into chunks of order-1 pages.
>

Series looks very good to me, thanks.

Reviewed-by: Eric Dumazet <edumazet@google.com>
