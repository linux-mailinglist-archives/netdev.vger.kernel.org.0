Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBAE06BB43D
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 14:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbjCONPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 09:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231974AbjCONPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 09:15:41 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36579A21B2
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 06:15:26 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-544787916d9so40088187b3.13
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 06:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678886125;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qKgeEmw/6W0SWieMcWQ02VSSFIpAhVBllMmTeozBA90=;
        b=vnKbivHAWG4rRuutoxN8eNw484KPYMNhikRTBCt8G/nWJuT69AWcQiGAq8f69sOa6u
         z0xnNp6NlQJ+5qJQ5XNP1rwgAEwQkJaWScn+EXWKbsPqx/VDj2x3Kbs8usgF/oxIIyOD
         thzxE07NGt8bNJsMIpQ8TDvtzffeR47nm0n70N2+rpwrjyhwSUgxwNU/liuL8+3UFEi2
         2vok6HunFiuEViEPIohmbPY9mVjHqCY+tN6e9Z2EZiHfhgwo5xor2AemgU0zrwpVzlKu
         iVMffQO0GexUOU7LAIn9v/lVZ2wreHQyVOCiGbXnQzCpAqN05aJAo7UxjcUWuqY+CC45
         8NAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678886125;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qKgeEmw/6W0SWieMcWQ02VSSFIpAhVBllMmTeozBA90=;
        b=CQWES4Hh+8uGrJtTNbuZNdHJmOzhZrS4tJfVlXGtFbii72RsRPyLyJQ1hLRhdyTZgP
         wT0He3p0KhUiart6h1Vq3w8Q6L/ARKM8dApDRqdoh/8AqD9GSWl4EqYAiReyNP5SPymy
         S+zDj6tDloeAjQ7CVfeoHxF9KKAvmnTcEFCpff/k/A5NGbx5caYOrKpYghn6gE+JT93x
         rhOMQL8lit8roCf8krxjqfOKo6T92oMN3k8ff2dEZKWTiyISnLgL0NxUON6K4BTT48Gk
         a08Pd/ELwExmWtPFnQZtO0Ilh8FXSEjGRzRZjYhITdJwi6mINgIdxfayOaBc6Dx6Txok
         SBfw==
X-Gm-Message-State: AO0yUKUfyvjZ+kS7Jrifu1DzERnfHQ/LK9vjZnpym1WX4GzMbgMHuSQb
        NiUgAoohEEw72Yt7ZQE3SBiiPokVAgdTRpfVTAt8GQ==
X-Google-Smtp-Source: AK7set8wwlb4JftADZ2nivxvmDTdDwmo8imStsXd2xZrBkPcNMUIXCXOSzOGwgYGRe3Ii1cmgJgP/sIa1U6H5U0/7wQ=
X-Received: by 2002:a05:690c:445:b0:53d:2dcf:890d with SMTP id
 bj5-20020a05690c044500b0053d2dcf890dmr13772804ywb.4.1678886125155; Wed, 15
 Mar 2023 06:15:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230315130917.3633491-1-a.fatoum@pengutronix.de>
In-Reply-To: <20230315130917.3633491-1-a.fatoum@pengutronix.de>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 15 Mar 2023 14:15:13 +0100
Message-ID: <CACRpkdbowrfYZpNKA32S8GT=8x_h+ZW4gd2Kj6FZkP1SZmDEPw@mail.gmail.com>
Subject: Re: [PATCH net 1/2] net: dsa: realtek: fix out-of-bounds access
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 2:09=E2=80=AFPM Ahmad Fatoum <a.fatoum@pengutronix.=
de> wrote:

> The probe function sets priv->chip_data to (void *)priv + sizeof(*priv)
> with the expectation that priv has enough trailing space.
>
> However, only realtek-smi actually allocated this chip_data space.
> Do likewise in realtek-mdio to fix out-of-bounds accesses.
>
> Fixes: aac94001067d ("net: dsa: realtek: add new mdio interface for drive=
rs")
> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

That this worked for so long is kind of scary, and the reason why we run Ka=
san
over so much code, I don't know if Kasan would have found this one.

Rewriting the whole world in Rust will fix this problem, but it will
take a while...

Yours,
Linus Walleij
