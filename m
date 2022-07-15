Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 128A257593D
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 03:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232378AbiGOBxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 21:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233000AbiGOBxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 21:53:39 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 525C66154
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 18:53:38 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-31cf1adbf92so34374617b3.4
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 18:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WKLgWdb1A0BY8vfnYr9iLY1/WBSN3aYAOzehuXk5bLI=;
        b=V/LrUoCM7VJKdTixmnLvRIGjvUmmlVYcKYR+a1xko5r98dsZvb4KHs37iucpLfFHsc
         tfvIq0Z+NF+wDl7JE0rMIH6vk7bt/7eHC/Lwx40724DvCM2HKodCHhOruOHqHqiSHPzV
         MeY+49Hrh7lo0wQpVo5RO7blmqvDNI2GN1NoI7mO6So9nG0TZLX6Gb8u4jF8FP5MLnIk
         pSBALN1+wEkZa5X2NPDUYklx1ntpxfR2HXMyID2ONI8CgSc8TTWke2CWKFmBroU68yBB
         uqOJn3917vGSiEzHTSN0mfNYyjqpy2l2cFwtp6jBI5NkOsDqOK9nk1zF9uJj5ccEcNGd
         wqMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WKLgWdb1A0BY8vfnYr9iLY1/WBSN3aYAOzehuXk5bLI=;
        b=mtQAi+f5/iAE4kh0bV0YMIhZW7ZdIaqZ3z/ZJnNLyFqse9h2zrGWKkZMmM6VOPUrN4
         ChR6i/nvlXYZ0Q65L5SrtBtImXIxIHTt0I4/Y2UB7Qy262UAAIY4HzoEB7o2jtL9KiY3
         ZKn+P2VMldSEE1MPwcF9WgMqnpA4YRMARsqFdBAfWHQ7TUz667JldyEgKJoKd/I0/psg
         jI0jDOb6XJ7U08Dugl4aBoWzMc4e1i5t5y88rjCZtliZpxxMfliABUPfUAqfkKfZFY/E
         /x0ENPyTMD0yHizGVkihN6uRBuwg6aPsETUTc0awUFX0NGHHNA543XedWU2oxCHTip3Y
         tPmg==
X-Gm-Message-State: AJIora/XaZUpo82COQQtVjDsuJXwXiqVAp2iidjiXMUVnouaf6UeuVdG
        CGMwS/lRrhQrRFyQ7S26aCxQ8NNGLdNmn1jTDlGYuw==
X-Google-Smtp-Source: AGRyM1sZdUQMInjZaI7jwccHge2i5THdJbHxNFnwrCwkEFsbH5qHx+wffQ/5/nVtfq+1G591dpuCjj6B3cwkpq3Qz9c=
X-Received: by 2002:a81:12d8:0:b0:31c:ab66:4693 with SMTP id
 207-20020a8112d8000000b0031cab664693mr13431044yws.452.1657850017353; Thu, 14
 Jul 2022 18:53:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220704084354.3556326-1-jeongik@google.com> <20220715001625.GA594816@roeck-us.net>
In-Reply-To: <20220715001625.GA594816@roeck-us.net>
From:   Jeongik Cha <jeongik@google.com>
Date:   Fri, 15 Jul 2022 10:53:26 +0900
Message-ID: <CAE7E4g=TyS97hQi6Tjc_OSV29Loz_5pBhqxQbwMQAsskfYi_iw@mail.gmail.com>
Subject: Re: [PATCH v1] wifi: mac80211_hwsim: fix race condition in pending packet
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, adelva@google.com,
        kernel-team@android.com, jaeman@google.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 9:16 AM Guenter Roeck <linux@roeck-us.net> wrote:
>
> On Mon, Jul 04, 2022 at 05:43:54PM +0900, Jeongik Cha wrote:
> > A pending packet uses a cookie as an unique key, but it can be duplicated
> > because it didn't use atomic operators.
> >
> > And also, a pending packet can be null in hwsim_tx_info_frame_received_nl
> > due to race condition with mac80211_hwsim_stop.
> >
> > For this,
> >  * Use an atomic type and operator for a cookie
> >  * Add a lock around the loop for pending packets
> >
> > Signed-off-by: Jeongik Cha <jeongik@google.com>
>
> Building i386:allyesconfig ... failed
> --------------
> Error log:
>
> drivers/net/wireless/mac80211_hwsim.c: In function 'mac80211_hwsim_tx_frame_nl':
> drivers/net/wireless/mac80211_hwsim.c:1431:37: error: cast to pointer from integer of different size
>
> Also seen in other 32-bit builds.
>
> Bisect log attached.
>
> Guenter
>
> ---
> # bad: [37b355fdaf31ee18bda9a93c2a438dc1cbf57ec9] Add linux-next specific files for 20220714
> # good: [32346491ddf24599decca06190ebca03ff9de7f8] Linux 5.19-rc6
> git bisect start 'HEAD' 'v5.19-rc6'
> # bad: [6d30dd0872599b7004e26330fc2e476ad900e7f6] Merge branch 'drm-next' of git://git.freedesktop.org/git/drm/drm.git
> git bisect bad 6d30dd0872599b7004e26330fc2e476ad900e7f6
> # good: [6134a5c4db991084f2f7c2da6c6cf400e42e3a99] Merge branch 'docs-next' of git://git.lwn.net/linux.git
> git bisect good 6134a5c4db991084f2f7c2da6c6cf400e42e3a99
> # bad: [f6268862d21dc3233ced91b848a55b6dfa8d438b] Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
> git bisect bad f6268862d21dc3233ced91b848a55b6dfa8d438b
> # good: [6d1ce9c03880c28a4a48f94d4a2dcb2e57c1b88e] net: phylink: fix SGMII inband autoneg enable
> git bisect good 6d1ce9c03880c28a4a48f94d4a2dcb2e57c1b88e
> # good: [480e10a33cdb7282f9ec91065fb624c0cd2f758f] Merge branch 'devfreq-next' of git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/linux.git
> git bisect good 480e10a33cdb7282f9ec91065fb624c0cd2f758f
> # good: [cfc6c2fcb686afdaea5bbca6f3dbb27815a23878] Merge branch 'phy-mxl-gpy-version-fix-and-improvements'
> git bisect good cfc6c2fcb686afdaea5bbca6f3dbb27815a23878
> # good: [8bc65d38ee466897a264c9e336fe21058818b1b1] wifi: nl80211: retrieve EHT related elements in AP mode
> git bisect good 8bc65d38ee466897a264c9e336fe21058818b1b1
> # good: [8f8df82f9cc2e76b48ba7cec3d08f4295e8f6ebb] Merge branch 'thermal/linux-next' of git://git.kernel.org/pub/scm/linux/kernel/git/thermal/linux.git
> git bisect good 8f8df82f9cc2e76b48ba7cec3d08f4295e8f6ebb
> # good: [2635d2a8d4664b665bc12e15eee88e9b1b40ae7b] IB: Fix spelling of 'writable'
> git bisect good 2635d2a8d4664b665bc12e15eee88e9b1b40ae7b
> # good: [c18bd03474a070e80fee20f0628fd0a6728c2475] Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm.git
> git bisect good c18bd03474a070e80fee20f0628fd0a6728c2475
> # good: [3c512307de4097aaaab3f4741c7a98fe88afa469] wifi: nl80211: fix sending link ID info of associated BSS
> git bisect good 3c512307de4097aaaab3f4741c7a98fe88afa469
> # bad: [736002fb6a09861c2663596011371884a8b7c0dd] Merge tag 'wireless-next-2022-07-13' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next
> git bisect bad 736002fb6a09861c2663596011371884a8b7c0dd
> # good: [37babce9127f3145366a8f36334f24afa9a5d196] wifi: mac80211: Use the bitmap API to allocate bitmaps
> git bisect good 37babce9127f3145366a8f36334f24afa9a5d196
> # bad: [58b6259d820d63c2adf1c7541b54cce5a2ae6073] wifi: mac80211_hwsim: add back erroneously removed cast
> git bisect bad 58b6259d820d63c2adf1c7541b54cce5a2ae6073
> # bad: [4ee186fa7e40ae06ebbfbad77e249e3746e14114] wifi: mac80211_hwsim: fix race condition in pending packet
> git bisect bad 4ee186fa7e40ae06ebbfbad77e249e3746e14114
> # first bad commit: [4ee186fa7e40ae06ebbfbad77e249e3746e14114] wifi: mac80211_hwsim: fix race condition in pending packet

I think https://patchwork.kernel.org/project/linux-wireless/patch/20220713211645.0d320e00e5b6.Ida11d2308dbf999d8bb9b1c49aa6e73af8fd3d33@changeid/
is the fix for this.

Thanks,
Jeongik
