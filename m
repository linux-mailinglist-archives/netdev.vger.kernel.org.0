Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2BB3E927C
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 15:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbhHKNYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 09:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbhHKNYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 09:24:11 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5532AC06179F
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 06:23:37 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id p38so5833294lfa.0
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 06:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G1DS3dhDnQ4urDmNfj/USqiCFClTi+Z5dRNYG0dYe2E=;
        b=NChTj9NxKFObAclXn2BntB3aw+Vd0IDfRn7Dvu3PGrTC8DEKz5eBR6UJ/LdvBm55ZX
         NlYb/Up9TurVBBTwJ3jC1OjeOfZ7fHVLoxd0OXcA0p1zrytca8apsPvlZxjnfkNXqa8O
         o9PBGGgPC4SAuYxiAfWzybxgwYUhUpb62FRnnagJ5uFhODDmQiQ5X7b9sPaGPKoormtt
         XhSr4UIPjO0iUgierg6TBTiHqQortcyJHfP0fvYMDXSlz41oXgdsgZi5PgEGaM9e1GQl
         U9sCNMpacMUXW4q6L7+mXu1kX5Pyom/75OtpDHsQN1erGp5QCi89SJ3pSbWJjUU9/m1Z
         C2QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G1DS3dhDnQ4urDmNfj/USqiCFClTi+Z5dRNYG0dYe2E=;
        b=n+QW0zWgkKEPgD8p1XRdMjstOzKV3lrMvjyKn4TgUFQosam1GbiZvwBZhkuWX0vDnO
         0a5yV12sykWKdjyX3UjFhYezQHL0azOPov1ZvSQcN0kiNkCs7VDwJMMIRXga4AimpwX4
         bPM06JBO24+iJtbh07SUuvatC3kyzJYgWbltRv9sskCywH3jCGREbrMg4SPWTPLDph1X
         Mmyy/4TLqDtzrfQBotiZ2VXkSHAiGWmM/klOCGNGgaeTQbPQT4vy9jillQJIfoik2NFH
         z4p9O2EDtKWuxOhinvUTC2eZNSuooRVDcfkw7DEgqTMdtRYAIqDNNDTKOkM3ThpS9GgE
         cuUQ==
X-Gm-Message-State: AOAM531NtFRdjJNcX8Cw636AxHTgJpfiJXKV8HPL85xd0xUkPxLhU5c8
        wufQ/mwA0u8Ruwqhhi43AhokAJBN4B6hzDidAkYJeQ==
X-Google-Smtp-Source: ABdhPJwWpOc+d0W3TyHMjyV5Kph+JZTz5Jpkx4yqIwZ8hoblgm4D3kS4sVUrpfWLOjpOX17ADZ4iXbTCSx9iVp3Tpsc=
X-Received: by 2002:a05:6512:1084:: with SMTP id j4mr26289074lfg.586.1628688215624;
 Wed, 11 Aug 2021 06:23:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210809115722.351383-1-vladimir.oltean@nxp.com> <20210809115722.351383-2-vladimir.oltean@nxp.com>
In-Reply-To: <20210809115722.351383-2-vladimir.oltean@nxp.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 11 Aug 2021 15:23:24 +0200
Message-ID: <CACRpkda5tpUgfJbTzgugC=Mmfsjfj1VM29-vLCW0-fnS4R6=YQ@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 1/4] net: dsa: create a helper that strips
 EtherType DSA headers on RX
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 9, 2021 at 1:57 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> All header taggers open-code a memmove that is fairly not all that
> obvious, and we can hide the details behind a helper function, since the
> only thing specific to the driver is the length of the header tag.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

yours,
Linus Walleij
