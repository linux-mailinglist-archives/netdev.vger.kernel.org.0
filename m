Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBBB413784
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 18:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233796AbhIUQYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 12:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233587AbhIUQYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 12:24:42 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4F7C061574
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 09:23:13 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id x27so83553957lfu.5
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 09:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uGB3KIWuUU5+UMhmxjUiQs+FGymSex7dUZpVcp4T9dw=;
        b=Bm1nRp21JyJReP1yYlxUgMG25ALeM66YI75gB0J79CC1/LkBaEYPn5GboYdTp2+8O6
         l3V+kkTUQ++qJPJx+n418dXu/OyorhyEGaTAIt0J3e7hk+q7gnVz3HA8Dr5OuOjgQWc2
         cx073pHVSY+BSKqpb/ytvZQRPksBCgnpeRRojL8Yq9aA3EroFA9nj966+8FoJo+mcffI
         ZsNKlICnlaA9wwmcBxxzX7+rMmooJoggwzu90+NA+pYEfjxGy0JO2MycIpzqiHm37uht
         CN4bX0alHqojNa+kKMDloU8pPe2HtmuFZRuJbOpjcal88HwJ5+RImVWr5IGteHJNL2wx
         ab9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uGB3KIWuUU5+UMhmxjUiQs+FGymSex7dUZpVcp4T9dw=;
        b=zeMD3nCarR6/SP6jYzDQAED+i/ohFhtlIg0CAMcbO0YlLHDAAGiZFkKpjmu6t3Hq5y
         GJqG4xLJY8Fv7pqbB0oDShRmvzQ4LLI4cCCrua7nnHaT8Qengwjo+rEC3GhYQvSezqwy
         8Zw6XYcgmuJloKLZrfjqGKov3ucr6V9+bkloiJSWVCxe0Y8KvB7wK4tnjv82XT/QdJlV
         AiVzlvGhNnPMCxg9JyMmFJ7dwGsUrZLehF09lGnrw5tsYlv8MNR+VPgpya1z2X7VNtsS
         VSwZMe9qpwWEzB5clgJvylyDQ5Cof5AiDiN5UEAOoVwuJYmYpmszoCWk3HDppAjkUxL0
         KnWw==
X-Gm-Message-State: AOAM532aHnSL9ycNPyKwP8GAn7jEZNTrsd6fLGDqNAsVaQfXPu1ZZd0J
        gMw2R/QI+XL0h8a0U//Spbn1NXUW9JpISr6bOGI23Q==
X-Google-Smtp-Source: ABdhPJzKaepZfzeZo+OmR86T4T1kRGRS8Fl4K7TWvr5VSuyb/bkqERay8zcuxyXKtRA4wwTwhqTm3YxYntrkQhU0Z/4=
X-Received: by 2002:a2e:4c19:: with SMTP id z25mr22499331lja.145.1632241388707;
 Tue, 21 Sep 2021 09:23:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210920214209.1733768-1-vladimir.oltean@nxp.com> <20210920214209.1733768-3-vladimir.oltean@nxp.com>
In-Reply-To: <20210920214209.1733768-3-vladimir.oltean@nxp.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 21 Sep 2021 18:22:57 +0200
Message-ID: <CACRpkdZ085p_qUOXUGiA5jru8fsj-ZqbEFtANGvaO-=FevktDA@mail.gmail.com>
Subject: Re: [PATCH net 2/2] net: dsa: realtek: register the MDIO bus under devres
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Wolfram Sang <wsa@kernel.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 11:42 PM Vladimir Oltean
<vladimir.oltean@nxp.com> wrote:

> Fixes: ac3a68d56651 ("net: phy: don't abuse devres in devm_mdiobus_regist=
er()")
> Reported-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> Reported-by: Alvin =C5=A0ipraga <alsi@bang-olufsen.dk>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
