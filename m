Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAEF521DB5
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 17:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244228AbiEJPOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 11:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345358AbiEJPNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 11:13:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250F7E15DA;
        Tue, 10 May 2022 07:48:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB8AFB81DC2;
        Tue, 10 May 2022 14:48:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469F0C385C2;
        Tue, 10 May 2022 14:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652194116;
        bh=c72iSkrAht/54lLLKTIxiRoey/GUJUzE+v+TIYu3Wck=;
        h=In-Reply-To:References:From:To:Subject:Date:From;
        b=b12edvEC6Cd9+lzThv0TF16/SG5tD+l/8mvTxGiKtAdTgm8szgIO5yF+vn/5U+T55
         3+808qHZKr/ypcSlwIzOJtTEN6tPN/wOi7v67RFWNrnC70RE21Bhz3G8EgKHVCffHR
         ndllQ5LFfqR+hgtg8ou3g9b3gTpAt9ZcSpgec6U/u4GgHep4cX7Lx4TgyPDzZWGqqo
         v/2uqch5DV62WaiZmff7MpPnEKIUITh0ZgObNK8EAwkyjRDy89w8N/C5gVV7j96lCJ
         wzoRuQFvv2GQLenULmCWJJyP3T6yDoz2aWxaJ8OoYLmi8I5hDVeANbdYCGQqluhDMJ
         FzkbaDlhUmkew==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220510142247.16071-1-wanjiabing@vivo.com>
References: <20220510142247.16071-1-wanjiabing@vivo.com>
From:   Antoine Tenart <atenart@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net] net: phy: mscc: Add error check when __phy_read() failed
Message-ID: <165219411356.3924.11722336879963021691@kwain>
Date:   Tue, 10 May 2022 16:48:33 +0200
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Quoting Wan Jiabing (2022-05-10 16:22:45)
> Calling __phy_read() might return a negative error code. Use 'int'
> to declare variables which call __phy_read() and also add error check
> for them.
>=20
> The numerous callers of vsc8584_macsec_phy_read() don't expect it to
> fail. So don't return the error code from __phy_read(), but also don't
> return random values if it does fail.
>=20
> Fixes: fa164e40c53b ("net: phy: mscc: split the driver into separate file=
s")

Does this fix an actual issue or was this found by code inspection? If
that is not fixing a real issue I don't think it should go to stable
trees.

Also this is not the right commit, the __phy_read call was introduced
before splitting the file.

>  static u32 vsc8584_macsec_phy_read(struct phy_device *phydev,
>                                    enum macsec_bank bank, u32 reg)
>  {
> -       u32 val, val_l =3D 0, val_h =3D 0;
> +       int rc, val, val_l, val_h;
>         unsigned long deadline;
> -       int rc;
> +       u32 ret =3D 0;
> =20
>         rc =3D phy_select_page(phydev, MSCC_PHY_PAGE_MACSEC);
>         if (rc < 0)
> @@ -47,15 +47,20 @@ static u32 vsc8584_macsec_phy_read(struct phy_device =
*phydev,
>         deadline =3D jiffies + msecs_to_jiffies(PROC_CMD_NCOMPLETED_TIMEO=
UT_MS);
>         do {
>                 val =3D __phy_read(phydev, MSCC_EXT_PAGE_MACSEC_19);
> +               if (val < 0)
> +                       goto failed;
>         } while (time_before(jiffies, deadline) && !(val & MSCC_PHY_MACSE=
C_19_CMD));
> =20
>         val_l =3D __phy_read(phydev, MSCC_EXT_PAGE_MACSEC_17);
>         val_h =3D __phy_read(phydev, MSCC_EXT_PAGE_MACSEC_18);
> =20
> +       if (val_l > 0 && val_h > 0)
> +               ret =3D (val_h << 16) | val_l;

Both values have to be non-0 for the function to return a value? I
haven't checked but I would assume it is valid to have one of the two
being 0.

>  failed:
>         phy_restore_page(phydev, rc, rc);
> =20
> -       return (val_h << 16) | val_l;
> +       return ret;
>  }

Thanks,
Antoine
