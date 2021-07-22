Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A103D275E
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 18:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbhGVPeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 11:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbhGVPd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 11:33:59 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80781C061575;
        Thu, 22 Jul 2021 09:14:33 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id h24-20020a9d64180000b029036edcf8f9a6so5783045otl.3;
        Thu, 22 Jul 2021 09:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZwLf1u7jaPUywG1DGreYaTwnNe8RYIVmsCj8nQ93Ka8=;
        b=EAsTk0sYzIEjozbdleJkxA/qLi7rafzfT9wAv/xQzDXVEhSdIws+dn50PffBVZTkM/
         uVYtTl2ZYWxLhpoG8YQqVKKoRdTLLjjjKwcOE0zYM8b+atEDY48LalE+j63FpV2KJUjN
         DFmiBCy8LKPPH5MmMJv85O8ksjX+cO3hL5lo5mTJEffKseiMSwyL8UgPWUYV9KJawDKG
         p+FxQJeDLWiJi0CW/AHtHlJmnpkHreQvlW9F475PditiljxPmij7EnFWNFo9ap/R3jQE
         9n7yWNL84mcIKEb594O4NiH/2hyIPWBBs8ZRZol8AFn/fNtSmYQmdM0gJK6S9oO6bvr8
         aB/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZwLf1u7jaPUywG1DGreYaTwnNe8RYIVmsCj8nQ93Ka8=;
        b=VYBYHVX8ZFGCEOS4HdxCi4eZOU7FmKZvryhxx3x/tKdwYMkdztI4rmOrMoWH6kMYKj
         TaEUNdFBwR1W8uwXdb2l12YcPyIDPGBSh17EJA14YH+x96PboRE4kHbbECyJxXZEant8
         IkwsMNU0nnLIgYgc4nPmSiPX3u3wapT3+FDBVGUJyC4RIut5fN0S3M50F4nKXLsZir7p
         oW3VYUNC537DIKg8+6kWk9E9ov28kuoNQLEtAmT5878SVN5A3B+ixVvD7trVSOndkYHd
         e5BmXSD463dwDcRTetlm1Jp+57wvj/It9s1qexqI1+Zo0K7isipwVFf284IoFBGXiVWz
         1SqQ==
X-Gm-Message-State: AOAM533BAhlov8+CBD6fhbydndCb63HwetzQWmtlJas9AUhSLRxsQ6Qy
        g63riIblD91f1dedN5VVUQk2OggdA0b/1fUN26QK8DbhYQk=
X-Google-Smtp-Source: ABdhPJyrNAA7rdeydAkILSSSOZN9/8qtF7X891q4xLnu8Rhgb1CtxM7zlVM8jzlKnGaC4UezCXP0yCYgMeG/MiV5buY=
X-Received: by 2002:a9d:7c8d:: with SMTP id q13mr334865otn.181.1626970472936;
 Thu, 22 Jul 2021 09:14:32 -0700 (PDT)
MIME-Version: 1.0
References: <1626968964-17249-1-git-send-email-loic.poulain@linaro.org>
In-Reply-To: <1626968964-17249-1-git-send-email-loic.poulain@linaro.org>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Thu, 22 Jul 2021 19:14:21 +0300
Message-ID: <CAHNKnsS1yQq9vbuLaa0XuKQ2PEmsw--tx-Fb8sEpzUmiybzuRA@mail.gmail.com>
Subject: Re: [PATCH] wwan: core: Fix missing RTM_NEWLINK event
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Loic,

On Thu, Jul 22, 2021 at 6:39 PM Loic Poulain <loic.poulain@linaro.org> wrote:
> By default there is no rtnetlink event generated when registering a
> netdev with rtnl_link_ops until its rtnl_link_state is switched to
> initialized (RTNL_LINK_INITIALIZED). This causes issues with user
> tools like NetworkManager which relies on such event to manage links.
>
> Fix that by setting link to initialized (via rtnl_configure_link).

Shouldn't the __rtnl_newlink() function call rtnl_configure_link()
just after the newlink() callback invocation? Or I missed something?

-- 
Sergey
