Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9590768B756
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 09:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjBFI3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 03:29:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjBFI3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 03:29:03 -0500
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039E71A49F
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 00:29:03 -0800 (PST)
Received: by mail-vs1-xe33.google.com with SMTP id g3so487243vsr.10
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 00:29:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=k5Jhh41xh/9s5BwvKBlJB3IcR8X3N5w01ZV/SyRF93Y=;
        b=mUdCCUlpPs82UcEc0LcK949hJZbEhSEsEoO0gQzwORczBdfIMisDTm3iOD+2YFyHOe
         i8DA234roBj+toW/VaCdnVMDOVZdjzCn/6TyaB0NXymNskkiEp3I7riVVScbV2R9jk26
         IwuzYOWbvh+D7Ow70WhzXuOH65mjkEmWgh0tJrwjEcCsWq9qfguMXRRLUGPIyOuqH/PC
         TmnXNDtyjRM9KiOjezNCpakSrpb6maWVRruJ0LrJdY0jVscGHRd+QfxVSVJtnyuyMAkj
         Jlt3cEi2LCuFwgzTVHXdwvN3CW1IP+RjZr68zU5OHhJem8/Pz58s5yBEoVePPwwTl0d7
         mndQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k5Jhh41xh/9s5BwvKBlJB3IcR8X3N5w01ZV/SyRF93Y=;
        b=nqXL+hTHyYmgTTJI+2DvqvJLaFRJujuLmR7An/9WqiDjVLMJ5CK+C6kiwkWbOoCZZ9
         6rGllnTTKtFt7p7TkoB8G1i2vb70hPWY1vV71JAWS3Hlxzxq9JJ6d9V9VGU/18Ox3E7v
         uCXGAQmr4wCt/o76LI5nZDo4Tl6sRyYEK9bJlejRBaEbkpjzKcPQycymahSE9/4NelPw
         wokTCaLCTA/ayAdDOwJnkbvuQQLFznF01Dg2p0P7XhSLdClGrfAny1tc8xqyDRZl6rQa
         45okpvNeWXAf75Hxrpy1xDJXR1gsQms1x6RX+QsNpeHln3bDbBU0/w4IdN3TLcVLJ3NR
         QbOQ==
X-Gm-Message-State: AO0yUKULr/xFDE0LZkCgU76wn380fYVLyvRx4WsJjpKS1quyU6Oum3Oi
        UWjB82WDBaHTwPKgQyAZxZ9QfcwQcp9NR8rbgmu7cw==
X-Google-Smtp-Source: AK7set9w9u0DXxvImFRGg0tVcUV0hVq9vnItrG+34sfMND2qX8rbkTt3fj6KChTTnBtx8wRJ9uYoYRir8X9+6ho+sdQ=
X-Received: by 2002:a05:6102:2e1:b0:3f1:6692:f144 with SMTP id
 j1-20020a05610202e100b003f16692f144mr3162124vsj.67.1675672141917; Mon, 06 Feb
 2023 00:29:01 -0800 (PST)
MIME-Version: 1.0
References: <20230131-tuntap-sk-uid-v3-0-81188b909685@diag.uniroma1.it> <20230131-tuntap-sk-uid-v3-1-81188b909685@diag.uniroma1.it>
In-Reply-To: <20230131-tuntap-sk-uid-v3-1-81188b909685@diag.uniroma1.it>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 6 Feb 2023 09:28:50 +0100
Message-ID: <CANn89i+BHx22sc3oxDtn-hSDYEHvqyGuQJm94m_s7VsKaY0XKA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 1/3] net: add sock_init_data_uid()
To:     Pietro Borrello <borrello@diag.uniroma1.it>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jkl820.git@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Sat, Feb 4, 2023 at 6:39 PM Pietro Borrello
<borrello@diag.uniroma1.it> wrote:
>
> Add sock_init_data_uid() to explicitly initialize the socket uid.
> To initialise the socket uid, sock_init_data() assumes a the struct
> socket* sock is always embedded in a struct socket_alloc, used to
> access the corresponding inode uid. This may not be true.
> Examples are sockets created in tun_chr_open() and tap_open().
>
> Fixes: 86741ec25462 ("net: core: Add a UID field to struct sock.")
> Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>
