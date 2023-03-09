Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82A7F6B2593
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 14:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjCINiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 08:38:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbjCINiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 08:38:05 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A683561325
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 05:38:03 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id h14so1900538wru.4
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 05:38:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678369082;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WFCsPlJvFiEG1gWgfxQ9irsbXI75PMhtoxZ+VCbHyYI=;
        b=SYSP+bPaSJ5yHksjPwCY9ezd0m7YqG2D8eZUmR2ZUXvumBzbgV1tpLRy1wzJsgrDHB
         u58U5+QWT2I3yui+KiWN62ycWipxOCg93vWSnxcVjd0EC55PeQvpMAUaMOs0HbjDhFWO
         EEHhyz5rLXL4JGzz60OSnwECzjw+f334AkG34nb/LMzE7mEOaw/9QrmCL8ktTpZXPLSd
         H8Z8sFRCaPfh2TVr3Ln06TzURhQVavfSlMhXYQuHSGM4y5sjbwVwxWKEwz8a0+ASkGUN
         wTJbeicvWCKcN6NuMijFHpEAmdzr5932EcG2UnZjzoGG1TWfsszdIcSNKsXjesW9TzJn
         Ex1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678369082;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WFCsPlJvFiEG1gWgfxQ9irsbXI75PMhtoxZ+VCbHyYI=;
        b=GxBEFgkVVOa5jyNULkI36d4Xf9U8b9/d6jfcW/VjbXA3Lzg5TqiPNbmghwRDR6BXFK
         xZghVqoPsIXyvFbjo0NRxXYW5hozEXegcOtGbSGwubE0hTeeCkwUai8ycxXMX9GbZzUI
         jXu/U6HIu9uuy5xKlPneDF4QTo4pDYHGcZLUuS4aso90BILJxAE0KZCYG9+zz6PlGGOl
         wRT1YgYgNRYOtjDGjKAAFNn+M0/Ik5am5peF+jsbQgRLDNMSaoGbZO1GcsFFY3i0X5cD
         ladIx87BqxROz6nisotfNxHSbIuH1yBm7knpIKD4kUbh3IW1AxzKutwEt7CbG/bwhgpQ
         f9vg==
X-Gm-Message-State: AO0yUKX3XQmxt3EZBU7LKvb4T+wKOZdkriaFXMU6q6NizCpsLFt2MZ7C
        +Ae+2TeH/S7dxvAFJ7mwZKggBSwV8J5Mp6jUDuOkfA==
X-Google-Smtp-Source: AK7set9AfC6q4Rxn0AocmDb+9VcwvGOGcz0XmdqyPZaEkjT4oOSLNBmgqqcb469eety40wCrSfD1m1Zr0CxP3jUv7IM=
X-Received: by 2002:adf:f38d:0:b0:2cb:3b68:3a88 with SMTP id
 m13-20020adff38d000000b002cb3b683a88mr4761748wro.7.1678369081978; Thu, 09 Mar
 2023 05:38:01 -0800 (PST)
MIME-Version: 1.0
References: <20230308190745.780221-1-leitao@debian.org>
In-Reply-To: <20230308190745.780221-1-leitao@debian.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 9 Mar 2023 14:37:50 +0100
Message-ID: <CANn89iLypT46pr+ShwXu+k0hYLNwoTjbHJ1eyA_fgZyS5U-1fw@mail.gmail.com>
Subject: Re: [PATCH] tcp: tcp_make_synack() can be called from process context
To:     Breno Leitao <leitao@debian.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, laurent.fasnacht@proton.ch,
        hkchu@google.com, leit@meta.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 8, 2023 at 8:07=E2=80=AFPM Breno Leitao <leitao@debian.org> wro=
te:
>
> tcp_rtx_synack() now could be called in process context as explained in
> 0a375c822497 ("tcp: tcp_rtx_synack() can be called from process
> context").
>
> tcp_rtx_synack() might call tcp_make_synack(), which will touch per-CPU
> variables with preemption enabled. This causes the following BUG:
>
>
> Avoid calling __TCP_INC_STATS() with will touch per-cpu variables. Use
> TCP_INC_STATS() which is safe to be called from context switch.
>
> Fixes: 8336886f786f ("tcp: TCP Fast Open Server - support TFO listeners")
> Signed-off-by: Breno Leitao <leitao@debian.org>
>

This looks good to me, thanks !

Reviewed-by: Eric Dumazet <edumazet@google.com>
