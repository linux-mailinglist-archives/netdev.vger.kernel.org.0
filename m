Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26DF05843C3
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 18:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiG1QBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 12:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiG1QBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 12:01:38 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C7415C968
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 09:01:38 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id 123so3952332ybv.7
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 09:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u9hpw4itczxPiWpadnVxkydzkGN8p2qR9PSTtIx0ISA=;
        b=OyaAWjDkYb3cIQSd9TC1e+CPrIXfcUjaxo0H4ul8CSWxdJt898ri7+QtqrYHYA2CbX
         ac2PL5StS1ERP98Z42cuD8uNg1tkPREJWf2VzbwGwU0q4k/nPVbCz81xYn8VEuFWObLK
         vehUsZlMVLefkPetXej8SgyBST3+wRm4dGBLxuv52MmCOjF3SPETkAWrAbery+f674tF
         69szcsvWD5Oo7Kle9PpSXgl9lh0/GgOrMgaBJ+RjSDpoRE3VahcE8oQcfEIWW/8aT/s3
         TqJJbBl53d2iBJUFbEhpf2qATaDw4jFBd4FbDz88w3vuv4Tcar7tz65ULdeafiotNdFW
         KHTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u9hpw4itczxPiWpadnVxkydzkGN8p2qR9PSTtIx0ISA=;
        b=WsqTYc0yjkTEjZsD/vU38PBQq9KbtCDaOv/4ZhoZmoDEPvmGCkh3MPeGuFyXyuVp8/
         AapZ55PyzCQEL20B9in44zxzjfFCCnXgaOiwhIaak9p+7o1lukTFwKvma5GKYT9lUtDQ
         w5cFdA9kEbSDLxXqT7PkeiHFpZl+qg0TzDb5emtafFT2W3Pp2FkqX31KfgU5pf/Rgtsf
         X3+0x6tVWNKmQ5QXtP0NO2aAB7wVg1sUO4vuXYzLH/b0zmh2i24CkZ+kegG21kbRX0dG
         E4bJqotZsK8tHrVrLkUCNx16nEgnc6JoncJW2ggjtMp0+xNs6ban74r9U78WEFOAE5sJ
         dyYg==
X-Gm-Message-State: AJIora+L8thEuKgkQf491JewdWnbZ5dQBtkKeSCFaCvTwhi78FKNVvsE
        T887sGKJmFhqZOq89puYdIbhc4llH4wO3bYjh55Sd/KLtoYI8A==
X-Google-Smtp-Source: AGRyM1uTLB3f1a8jXrsUjID3Yi8mCJt/Yc1/x0x/GXa3n2FO29rxo+FBZM8wA6WUtUa6fUlG6/N5oZa3TMkWDj3gG8A=
X-Received: by 2002:a25:ab84:0:b0:671:748b:ffab with SMTP id
 v4-20020a25ab84000000b00671748bffabmr9904023ybi.427.1659024096964; Thu, 28
 Jul 2022 09:01:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220728113844.GA53749@debian>
In-Reply-To: <20220728113844.GA53749@debian>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 28 Jul 2022 18:01:26 +0200
Message-ID: <CANn89iL4a-r1LuPGu19rBgwbV3-8Wco5UdYN-tgoNKoKZ9mUJg@mail.gmail.com>
Subject: Re: [PATCH] net: gro: skb_gro_header_try_fast helper function
To:     Richard Gobert <richardbgobert@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Dmitry Kozlov <xeb@mail.ru>,
        iwienand@redhat.com, Arnd Bergmann <arnd@arndb.de>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 1:40 PM Richard Gobert <richardbgobert@gmail.com> wrote:
>
> Introduce a simple helper function to replace a common pattern.
> When accessing the GRO header, we fetch the pointer from frag0,
> then test its validity and fetch it from the skb when necessary.
>
> This leads to the pattern
> skb_gro_header_fast -> skb_gro_header_hard -> skb_gro_header_slow
> recurring many times throughout the GRO code.
>
> This patch replaces these patterns with a single inlined function
> call, improving code readability.
>
> Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
> ---
>  include/net/gro.h      | 33 ++++++++++++++++++---------------
>  net/ethernet/eth.c     |  9 +++------
>  net/ipv4/af_inet.c     |  9 +++------
>  net/ipv4/gre_offload.c |  9 +++------
>  net/ipv4/tcp_offload.c |  9 +++------

It seems there are other places this helper could be used ?

drivers/net/geneve.c
drivers/net/vxlan/vxlan_core.c
net/8021q/vlan_core.c
net/ipv4/fou.c
