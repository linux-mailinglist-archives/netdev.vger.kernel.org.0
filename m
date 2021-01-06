Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDF72EC627
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 23:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbhAFWTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 17:19:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727823AbhAFWTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 17:19:46 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 397B4C061575
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 14:19:06 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id i18so4257746ioa.1
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 14:19:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j2XKwVvWZpv6kGVZxppTk9w07WPHo+vmrzQDBk+kdJE=;
        b=lPYsdgEmMR86DUpGuouOXKRBFKN3ZKVxBLPNSlJ8OucYgdjfN7UdIdKZqbhi5omQQN
         x4ZWMgn8RH8KOTv24yhEgdJmbp+i5orbLI6NE9Ii/Jpol/oRMi5vuxnw/3mDOEZpvN0L
         yMcBXO/d5aHwVcfe8GkruUejh0CWXrdYjTzzMd2z7e8+fP+xBc2CJ09Z8v+hZh1GduUG
         hKamx2hCaDDLWx4geFRbo0UP1zkwK4p+KxViyoMWILjSejxZePF09EsUA3ZkZIfRUahj
         mGPm+rz4SVwXfBjtiRDM5UUsilbGERgnMPsqYshi76g4Ec1znYLOkt/Vwhb4Y4zDXU/0
         OiRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j2XKwVvWZpv6kGVZxppTk9w07WPHo+vmrzQDBk+kdJE=;
        b=haHPn5IWSu+yNgQ2FJyXwfYae78M7Oaq3Sg5o9CvBMYNbeUtod76XIdBRakrDv6H1S
         KKWt1ex+dzv2oE2mvFndasMAVKZKV7DzHwOzr7bMNeFPEbZVmjAqZ0VBHstuA5RkG64g
         L/RR0ydd8POyI31cxLf+f/LsBIFqUswxJefadQiPfWOqzuwia0b+TajwJctP8qAYojh9
         3L/qmxuFx2XMdCnXuLkPG4XBIykdYxpLULV9MfBUScOb/h1UL560Q1hh4EY8Hm9rTs1f
         Avt9xVIi7xUCTJ6jKRcej+FKGjPeTgHgV5N+w4Tlby+ImJbao9yHey5WBIq7gNnhuOeA
         LUIA==
X-Gm-Message-State: AOAM531GlE0N5O3Q4/A2HG4Zr5QLgJTJ2j29WzxKXyqPEV9qQ+wFbTe9
        yab6BLjABcPwA2v2dgncRRfSgsYIjSMEulZVe/o=
X-Google-Smtp-Source: ABdhPJwI3l0rXUUHTXDU3kXGCGA6UckodPeqw5N52Lyy4xSRREAACFn44KIZmGBL9JbNEFlZ5tmkIKI0xv1nNXbA3zw=
X-Received: by 2002:a6b:8e41:: with SMTP id q62mr4454752iod.5.1609971545139;
 Wed, 06 Jan 2021 14:19:05 -0800 (PST)
MIME-Version: 1.0
References: <f89bf2f3-5324-b635-4253-8a8be316c15b@gmail.com> <619e6cc2-9253-fd1e-564a-eec944ee31e1@gmail.com>
In-Reply-To: <619e6cc2-9253-fd1e-564a-eec944ee31e1@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 6 Jan 2021 14:18:54 -0800
Message-ID: <CAKgT0UcbDT_ccC0M=hC121YZ3pVC1ht2uv9-vPDjMFtM5mKDWw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] r8169: replace BUG_ON with WARN in _rtl_eri_write
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 6, 2021 at 5:32 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> Use WARN here to avoid stopping the system. In addition print the addr
> and mask values that triggered the warning.
>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 024042f37..9af048ad0 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -763,7 +763,7 @@ static void _rtl_eri_write(struct rtl8169_private *tp, int addr, u32 mask,
>  {
>         u32 cmd = ERIAR_WRITE_CMD | type | mask | addr;
>
> -       BUG_ON((addr & 3) || (mask == 0));
> +       WARN(addr & 3 || !mask, "addr: 0x%x, mask: 0x%08x\n", addr, mask);
>         RTL_W32(tp, ERIDR, val);
>         r8168fp_adjust_ocp_cmd(tp, &cmd, type);
>         RTL_W32(tp, ERIAR, cmd);

Would it make more sense to perhaps just catch the case via an if
statement, display the warning, and then return instead of proceeding
with the write with the bad values?

I'm just wondering if this could make things worse by putting the
device in a bad state in some way resulting in either a timeout
waiting for a response or a hang.
