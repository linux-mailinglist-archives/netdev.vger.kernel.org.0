Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2C3600F61
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 14:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbiJQMpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 08:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiJQMpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 08:45:10 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58394BD0D;
        Mon, 17 Oct 2022 05:45:09 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id k2so24644966ejr.2;
        Mon, 17 Oct 2022 05:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HWmxqGF/038fMoL0OujOGP+aUEXKzs6WrKb2H91XwNw=;
        b=EFPUYe56DLRb3jgtTvrgrWMjZcb2OFrMZW/fKGOSYVmpPLtM+MB1FhSMEMTC+mmOpM
         oZKQzByoqLHCiacPyzOg15lHZW25asKMonWrwGf9xFik0n3XFA4GipB9Skv3lYTtGBrw
         2HAIRwA+aw3ygewkI9Au7Hn1qKd8Z1s4qsnLPkAC691hzgDKgJojC8AiH1QvzC7MhkCp
         lD9qpS45onpnbXrBuxbQtCy56E+lWY8x76Tio4rOVKtGK3ixVkOlyDVP00rppM5U+bS6
         cLTUGnW3R3KVOrSo9uh+EWC2TYXEIJfMFLK8cwKb8pF3BqOztV6yiV0Z+WISL50PNpYq
         AbDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HWmxqGF/038fMoL0OujOGP+aUEXKzs6WrKb2H91XwNw=;
        b=s8zwTNyxsfCNg3mSBI+oHde07233lkT/sNI76etkfmOzjlpjSPTdz684AbuFHHImck
         u/HLB0rCtmpLmvqmzzFqAREETx1SsD8Rxi1o5h7EDYjBJRN6TMQWzKl62RwBT7qSo3lZ
         +qDZ73Azz/e4E4Kf7wmx9Jb02/nZHa0dDzYtNqEAfr+1PtZezwSLzbnBEbutTdWhDtTr
         FvLL3VOYTHolT46C+wZHPcy9n3ZHKw30qg46BCIsedY+E2vK8CqsESXCjTkTQ4I4JRjW
         U/ZHfwUHfJzd8Y3IIqyIdGw4ljnDPl+4iGukOGY07ulloXtwR1f0g+5g1Nbe1ahJGRsX
         fzTQ==
X-Gm-Message-State: ACrzQf0nPtjX4dEepyUOKaVFLP6ip8KSZ3RTv6ObBxbovBbYSQ/MQmJD
        4KLphvEHfc6uHsoJq1PUCKg=
X-Google-Smtp-Source: AMsMyM7mhW15Nb2oDKxIsTla97uYTBzTlYARXy6rnD14TSiS80WugSwHh2x9mLvRwyzeCzQXuBw9mw==
X-Received: by 2002:a17:906:5d04:b0:722:f46c:b891 with SMTP id g4-20020a1709065d0400b00722f46cb891mr8593565ejt.4.1666010708172;
        Mon, 17 Oct 2022 05:45:08 -0700 (PDT)
Received: from orome (p200300e41f201d00f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f20:1d00:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id p6-20020a05640243c600b0045b4b67156fsm7294536edc.45.2022.10.17.05.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 05:45:06 -0700 (PDT)
Date:   Mon, 17 Oct 2022 14:45:04 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Cosmin Tanislav <cosmin.tanislav@analog.com>,
        Jonathan Cameron <jic23@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Nandhini Srikandan <nandhini.srikandan@intel.com>,
        Rashmi A <rashmi.a@intel.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Sumit Gupta <sumitg@nvidia.com>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-iio@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-phy@lists.infradead.org
Subject: Re: [PATCH] dt-bindings: Remove "status" from schema examples, again
Message-ID: <Y01OUPVLczqzuj3b@orome>
References: <20221014205104.2822159-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ENKGIPZJ+FvcFLFo"
Content-Disposition: inline
In-Reply-To: <20221014205104.2822159-1-robh@kernel.org>
User-Agent: Mutt/2.2.7 (2022-08-07)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ENKGIPZJ+FvcFLFo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 14, 2022 at 03:51:04PM -0500, Rob Herring wrote:
> There's no reason to have "status" properties in examples. "okay" is the
> default, and "disabled" turns off some schema checks ('required'
> specifically).
>=20
> A meta-schema check for this is pending, so hopefully the last time to
> fix these.
>=20
> Fix the indentation in intel,phy-thunderbay-emmc while we're here.
>=20
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  .../arm/tegra/nvidia,tegra-ccplex-cluster.yaml    |  1 -
>  .../display/tegra/nvidia,tegra124-dpaux.yaml      |  1 -
>  .../display/tegra/nvidia,tegra186-display.yaml    |  2 --
>  .../bindings/iio/addac/adi,ad74413r.yaml          |  1 -
>  .../devicetree/bindings/net/cdns,macb.yaml        |  1 -
>  .../devicetree/bindings/net/nxp,dwmac-imx.yaml    |  1 -
>  .../bindings/phy/intel,phy-thunderbay-emmc.yaml   | 15 +++++++--------
>  7 files changed, 7 insertions(+), 15 deletions(-)

Acked-by: Thierry Reding <treding@nvidia.com>

--ENKGIPZJ+FvcFLFo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmNNTlAACgkQ3SOs138+
s6FjaRAAjTcwhjc2StE06L8/1hqmMcPI/MCBfZcFFcC+zH7z+tLcW29ZRegOLWAo
Rnix/qmiwHYlde5STzozQYYbrLGPN7rBoJKd5uDXwWc0fYOxosOHHDv3q/shRLO4
EpOLNfcMImYQPOV3ni8nH8mNdR62bloiyCz/qG6ASKu2x22ZmHpqYv1TC7H4WNgM
He1HB8XDWbgXdtsXDbKEEDN9gXaFTYCkPH3G5tRq7aWl6bIakBQRzPLjCnaUnznw
NgP7GbBHYIigaGGPAzSBjUHQuJ2zLithJGZ2ISxqGUrtI1dvw9N3oaFGyTUBOdej
sU1+ml7aIYT9bi2ES6xiDuNaVOclaefRw6GxwoRUGlcCa81/N+3zf3RlD6fZ0JxN
B3zvkKn0c7KoZ8MgpouBFNeC4aIO2VOB8FH5eGSnNwz5Sh1+MgIBMKlu1Hq/6zu5
Ih7hVnpzzLirkDdr1mOcnw/4Ok/z92c7UajhH2kv1iK0Z85NitRcCfvdexGoOsQ/
0lwQ4iZ5sMZu++FcGxPdMBiL0ehEbfhPKNjzS+44rbN6xldqYfyiTs0F+s8tZ4VR
Ak8u7RQJ/3zdYi4KH9BgyUeHh7AjyyeYcNAsk7DkuBFtu9GIm50vMSP4oMWShsZv
4omD7j8WnVAveBPTXeKD+1jQztY1gjGbHFSxdgZyKUpkgxb2/Jk=
=QfTP
-----END PGP SIGNATURE-----

--ENKGIPZJ+FvcFLFo--
