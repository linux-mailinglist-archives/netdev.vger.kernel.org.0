Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04423669CD1
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 16:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbjAMPs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 10:48:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbjAMPsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 10:48:12 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B49CFB29
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 07:40:07 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id o7-20020a17090a0a0700b00226c9b82c3aso24735311pjo.3
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 07:40:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=J4jw2nlUJcrE6QNcWjKai8VoSq9gL3X/61zH8OqTq/Q=;
        b=L5COuCBe8O8BHkWFMD1dcDFY7Op0/jN8409Um3ypboUO0gP4j9DqdgC6rLUdSsOKCe
         TAa5AcUwVKh7RG/dKSLwb+2JgjkJ0AQDQGVeIE7etdob+APTNGB1QMh9ndg/SG+wJ/X6
         6zQGq/TKt9R2Vx7CxiT+fFUVnmfaaonOVi20qndZggt2eNS54+OBhaeHBHLIdObeCCjk
         /5s/zwj66q5Ga4NolNDvnXENo6pp8uqA3kvlis154HYRs3YK3d4lU2gprXPpJdh+4LXN
         WaE6QlI1lI5xLswxe/J4u/KGp1mR6S+/dCFbFPZyRaW+LnPONAhElVuRaX69po15a9z8
         if1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J4jw2nlUJcrE6QNcWjKai8VoSq9gL3X/61zH8OqTq/Q=;
        b=ME2KGdqyKmWOOr34JJtJ864xKSEMrVpv431l9TEg+t1BVyLkK+ab9Qi2CcrocCRvzT
         /VjsD7kqEvaA2yRxWPAv6tSJRl4/CcQB8Y1SUzsYyq6ZXpimmNuh122K3d0ss4Jmz3Ce
         A7qAQdOogkKBFnSYFx67OfriD2rX9ei7955jsh7d43Z2rIwZskSbih4/cn3PlW1uUQVP
         hxN4hnacTICAk+zJb0Mmsq3E0R4+DWJ6/q3Zx+6wweIRZb6DVJPUSZ8kl8D9gJzD86LX
         a/wYv34waR3HN9a3MpcayOkO5VfsM1oAo5oIEJ/kEm3pMbfePsODjY6UYxSzXPDNi82z
         CfnQ==
X-Gm-Message-State: AFqh2krYjj1RncdJSwPKByKl1wKx9+Nmrrxk1KnKqrkRNTnaWN4v5sjx
        DNODnH+pRKnn1x+L4LdIwRPYZzUgqJjCSHlWh8g=
X-Google-Smtp-Source: AMrXdXs15ZctUVk/wOz0O2jlBQ44WVFiueVjzYiCVHUsHLLdlZYyHGhvP1KYNvJgpGIcurk9kqINd6I4HpHphLC6u1w=
X-Received: by 2002:a17:90a:5882:b0:229:32d7:c69 with SMTP id
 j2-20020a17090a588200b0022932d70c69mr165602pji.178.1673624407067; Fri, 13 Jan
 2023 07:40:07 -0800 (PST)
MIME-Version: 1.0
References: <85f2b5e5-ea85-3a84-1a5e-c4f84897ac04@gmail.com>
In-Reply-To: <85f2b5e5-ea85-3a84-1a5e-c4f84897ac04@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 13 Jan 2023 07:39:55 -0800
Message-ID: <CAKgT0UdvFiid24zWqR_Z_fj_oYH_ByHJfWVRKL1CmrppMZ8LQw@mail.gmail.com>
Subject: Re: [PATCH net-next] r8169: reset bus if NIC isn't accessible after
 tx timeout
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

On Thu, Jan 12, 2023 at 10:32 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> ASPM issues may result in the NIC not being accessible any longer.
> In this case disabling ASPM may not work. Therefore detect this case
> by checking whether register reads return ~0, and try to make the
> NIC accessible again by resetting the secondary bus.
>
> Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 49c124d8e..b79ccde70 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -4535,6 +4535,10 @@ static void rtl_task(struct work_struct *work)
>                 goto out_unlock;
>
>         if (test_and_clear_bit(RTL_FLAG_TASK_TX_TIMEOUT, tp->wk.flags)) {
> +               /* if NIC isn't accessible, reset secondary bus to revive it */
> +               if (RTL_R32(tp, TxConfig) == ~0)
> +                       pci_reset_bus(tp->pci_dev);
> +
>                 /* ASPM compatibility issues are a typical reason for tx timeouts */
>                 ret = pci_disable_link_state(tp->pci_dev, PCIE_LINK_STATE_L1 |
>                                                           PCIE_LINK_STATE_L0S);

So this is headed in the right direction, but you should probably have
some exception handling in place for the pci_reset_bus in the event
that it fails. It is possible that the device is just gone and that in
turn is triggering this. If I recall correctly, when the device
doesn't come back the pci_reset_bus should return -ENOTTY. In such a
case you can probably report that the device has failed and wait for
the PCIe subsystem to notice and notify you that the device is gone
and remove it.
