Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D553866A778
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 01:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbjANAYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 19:24:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbjANAYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 19:24:47 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052867C3BC
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 16:24:47 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id 207so1235102pfv.5
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 16:24:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TLlVaJPEEG+7nh0Va/VhNILtQbO38J62N7iJlOugI4o=;
        b=Y8tOsIfopZhDL/8bNIqYH9HPq3zJaRPVm2vMIXUI5kzmqUqOMfkXRlwcsMMPy2k40I
         cTtSp7aiszaen4KZ/s41qktQfREtFm7ZUa0JLI8ayEdze0OcZbTUg35ZSBKmuRrN/8se
         H+c0Ed51I+IrYkB69L/aTigCkt5tn3c1r6vHW0AQPxaW61RoK48ypOJZfXOWS/j/ViFt
         GoVSVTc66tXFP/jnrQ+4cTmjDelgH6bkgBKU9461s1ttFJfpRgERc790Qoo5DCLewcpA
         8p8H3Sm+EcrgAp8oSyrMaPFyP+KFIvrRETGwRB0+xGTBymDyWZD0FpU4vRLmbf0MUWwb
         q4vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TLlVaJPEEG+7nh0Va/VhNILtQbO38J62N7iJlOugI4o=;
        b=PKTe1jxkv2hIguAaujHlcYAOAeA+hj2y5dkNQLHj5mXUJnTGF2uT+K3Lv6CM5Ep6DD
         RdLncfHyrfx9pkXolbEPKL/WvTRSK3fkatKoulARbg2L+7ta4/G332Ssiq7Nf2ic++s+
         0bqMi8eTxFG4TVaS6IcCbOIxKtMrZGnr0+XBBvya8oaDuju5BMKmN91dQVUYNW/1Yl8n
         8QRZOeVvP4q18IpXWV/A2EGBUPGHAIES+wZMw7Z7McPZiLmgdAdmEZEWOnZtPweF8jK3
         6qQe8D/jNPrTm+OrbKcEbOWz1jefG7wnzRc2feDWFFXF56/3sKZVpikRYEcUJfH7DYdG
         M+KA==
X-Gm-Message-State: AFqh2koIRpz2nndPodzHOIRC1t47TFe/KJVuNfTqFUwU1UoujrtmgrAf
        Fq9FFMoNX7m4+3WD9LsNvlf9NDlnHpn0zxVTJ70=
X-Google-Smtp-Source: AMrXdXueges3fDUfH2McFfdthavjr60uc9LcUv11fMZPhcv1UhkrDonjuUIeWYokHDebvonJFa/35GvmJjpYAoS16Gk=
X-Received: by 2002:a62:2945:0:b0:582:4d0c:6f5c with SMTP id
 p66-20020a622945000000b005824d0c6f5cmr3760369pfp.44.1673655886484; Fri, 13
 Jan 2023 16:24:46 -0800 (PST)
MIME-Version: 1.0
References: <4534318d-b679-9399-e410-8aee2a9cbf58@gmail.com>
In-Reply-To: <4534318d-b679-9399-e410-8aee2a9cbf58@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 13 Jan 2023 16:24:35 -0800
Message-ID: <CAKgT0UeHf4yzbzNrT5A0EYbVyHZQoaO9VpeCjeN6MkFMnMRU8Q@mail.gmail.com>
Subject: Re: [PATCH net-next v2] r8169: reset bus if NIC isn't accessible
 after tx timeout
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 2:46 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> ASPM issues may result in the NIC not being accessible any longer.
> In this case disabling ASPM may not work. Therefore detect this case
> by checking whether register reads return ~0, and try to make the
> NIC accessible again by resetting the secondary bus.
>
> v2:
> - add exception handling for the case that pci_reset_bus() fails
>
> Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 49c124d8e..02ef98a95 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -4535,6 +4535,16 @@ static void rtl_task(struct work_struct *work)
>                 goto out_unlock;
>
>         if (test_and_clear_bit(RTL_FLAG_TASK_TX_TIMEOUT, tp->wk.flags)) {
> +               /* if chip isn't accessible, reset bus to revive it */
> +               if (RTL_R32(tp, TxConfig) == ~0) {
> +                       ret = pci_reset_bus(tp->pci_dev);
> +                       if (ret < 0) {
> +                               netdev_err(tp->dev, "Can't reset secondary PCI bus, detach NIC\n");
> +                               netif_device_detach(tp->dev);
> +                               goto out_unlock;
> +                       }
> +               }
> +
>                 /* ASPM compatibility issues are a typical reason for tx timeouts */
>                 ret = pci_disable_link_state(tp->pci_dev, PCIE_LINK_STATE_L1 |
>                                                           PCIE_LINK_STATE_L0S);

Looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
