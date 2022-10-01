Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3FCB5F2061
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 00:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiJAWiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 18:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiJAWiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 18:38:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8E932AB8
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 15:38:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA95BB80880
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 22:37:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5D0C433B5
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 22:37:58 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="M1OCdAvX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1664663875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aDvOD1PoPBTBA+edmFupyLKm4OemxM1tEQEEItn8MuY=;
        b=M1OCdAvXVGGm9399L1m5HZciyMCdl4SdNGimjCvSpirikQ6t0CVdd8mEJ/PnbUoopNRWAh
        MOdGflly7gP/tNGPJmbQrRu1XZbMucWCpjwmfzKclSmxxUFIB8E/FDjaHiIEHbkWFp67Lj
        GwKoNjFPCEL7CwMO2lUEl6t4TMcqJTU=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 1be529d2 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Sat, 1 Oct 2022 22:37:54 +0000 (UTC)
Received: by mail-vs1-f46.google.com with SMTP id 63so8174254vse.2
        for <netdev@vger.kernel.org>; Sat, 01 Oct 2022 15:37:54 -0700 (PDT)
X-Gm-Message-State: ACrzQf0PVnCxkwI5kGsPmi3xp9cshKBG1GzUdV9eBTTMPJ9dHqW8kktX
        h/wQzXZSspl+bBIIvxEAujpIN3l6zuIJtn6ic1g=
X-Google-Smtp-Source: AMsMyM51szqVIOfL6MXarysQZJBF8/yf65JIeoLQCr5x9299z1fLGRCHtegMQ49+DrHocRaUV1s5K0+5pjM/S8Kd2jw=
X-Received: by 2002:a67:c28e:0:b0:3a6:3134:b310 with SMTP id
 k14-20020a67c28e000000b003a63134b310mr2669495vsj.76.1664663873523; Sat, 01
 Oct 2022 15:37:53 -0700 (PDT)
MIME-Version: 1.0
References: <03a06114-bc63-bc01-be38-535bcc394612@csgroup.eu>
 <CANn89iKzfzOUPc+g0Brfzyi2efnXE0jLUebBz5fQMWVt9UCtfA@mail.gmail.com>
 <CANn89iLAEYBaoYajy0Y9UmGFff5GPxDUoG-ErVB2jDdRNQ5Tug@mail.gmail.com>
 <Yzi8Md2tkSYDnF1B@zx2c4.com> <CANn89iK3maLVo_G7MGswuXV0Og9tEFJxMZt+34ZKTo4zUNoLRw@mail.gmail.com>
In-Reply-To: <CANn89iK3maLVo_G7MGswuXV0Og9tEFJxMZt+34ZKTo4zUNoLRw@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sun, 2 Oct 2022 00:37:42 +0200
X-Gmail-Original-Message-ID: <CAHmME9oBKXWWcLyeqN4HELdU1sJCa0JmUxO11fQASQ_JTTHe+A@mail.gmail.com>
Message-ID: <CAHmME9oBKXWWcLyeqN4HELdU1sJCa0JmUxO11fQASQ_JTTHe+A@mail.gmail.com>
Subject: Re: 126 ms irqsoff Latency - Possibly due to commit 190cc82489f4
 ("tcp: change source port randomizarion at connect() time")
To:     Eric Dumazet <edumazet@google.com>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Dworken <ddworken@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On Sun, Oct 2, 2022 at 12:31 AM Eric Dumazet <edumazet@google.com> wrote:
> Sorry Jason, it seems I forgot to CC you on the tentative patch I sent
> earlier today
>
> https://patchwork.kernel.org/project/netdevbpf/patch/20221001205102.2319658-1-eric.dumazet@gmail.com/

Oh, pfiew! I just came to basically the same conclusion as you were
typing that to me:
https://lore.kernel.org/netdev/YzjAfdip8giWBF4+@zx2c4.com/

Your patch seems like a good approach.

Jason
