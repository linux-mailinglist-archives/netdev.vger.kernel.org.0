Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFB65B6D7
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 10:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbfGAI2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 04:28:10 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:39682 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728101AbfGAI2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 04:28:08 -0400
Received: by mail-qt1-f194.google.com with SMTP id i34so13723734qta.6
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 01:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QasTTaprmLYP8lu+OAIAZ4qDWXTMLVjKiiW3eSvYcPg=;
        b=DElwOE2FVy8WGouInPBiLUdX//ZPDkOt68rwSbXsDRXYvjYCDDwuSl9qtiBJsOMo3u
         BnaD5RHWgFidR4gNfrTI8pbPKRUPKE/VkHqVuUybCONlNhmNrcPD02Bg1aSVy07qQAiG
         GeK/a425RkCz+UaDwTzANbF6XxooFBQfoti8ZY8QD6BTglcBxv0Zw/40genT/VOYp/dP
         XQ8xeLoUQeYCxNcNSrRSpWnPL6iuc88I5qg8xu22qM/pMh5f+7h+M4bBTFOeSU0H0AZX
         N2AjJdGg/iZLXL1c5ePvTo8T04aSB17EBDPd7/z5YMhvdOxV6FCb+2IG1fsUVwGIWdiW
         IIaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QasTTaprmLYP8lu+OAIAZ4qDWXTMLVjKiiW3eSvYcPg=;
        b=nGXKJdup03JZdlgtH0fsLw8gM1TT/AlBgWbVC94pJk7ascY/+R4OpD7W1O5H7MJrEG
         P9MzoCgpWqBM03aGLfkfJb3rBNoSOnYyR+1ZQXQOU75vzjf1HI3yF7wpxRPTwWrJXgCs
         P/yRs89rm7LPErWwy1XWLtIJqr+kWPe0df5Q7cNrfdTNYpYqF9zNU5PqW1X2FKQXVpvb
         GSsttCZhpG0GE29PQbI+G2IlHPqXBCEKrszixEYPTtmna7HaHe2KYyyUXNO7wHQlzx9f
         Xxi3UC4DWMV/ZnIv3xyJ88BiVQpwXjI7fyRp90o1VWsSy2eTHbqZQGULYCT9+WAawVj6
         t0VA==
X-Gm-Message-State: APjAAAWWMLsZsGnSSF6R3KMp0ZWabWZYCeZnyEzOGZkNOsMNyKsJI/u4
        55Xl0UpbRIxzS+hb7ulN6fKXsYYfaucjY/e9Nj8IHQ==
X-Google-Smtp-Source: APXvYqzVHPWiWEbrcd2gL7Cn7r79vE5x4Z5GHfD3ruh9NhVQD6G+qgPXkeuauOxShyujHZfTdjwHnpMYUVZe7DLcBaE=
X-Received: by 2002:aed:36c5:: with SMTP id f63mr19693568qtb.239.1561969687300;
 Mon, 01 Jul 2019 01:28:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190627095247.8792-1-chiu@endlessm.com>
In-Reply-To: <20190627095247.8792-1-chiu@endlessm.com>
From:   Daniel Drake <drake@endlessm.com>
Date:   Mon, 1 Jul 2019 16:27:56 +0800
Message-ID: <CAD8Lp44R0a1=fVi=fGv69w1ppdcaFV01opkdkhaX-eJ=K=tYeA@mail.gmail.com>
Subject: Re: [PATCH] rtl8xxxu: Fix wifi low signal strength issue of RTL8723BU
To:     Chris Chiu <chiu@endlessm.com>
Cc:     Jes Sorensen <jes.sorensen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chris,

On Thu, Jun 27, 2019 at 5:53 PM Chris Chiu <chiu@endlessm.com> wrote:
> The WiFi tx power of RTL8723BU is extremely low after booting. So
> the WiFi scan gives very limited AP list and it always fails to
> connect to the selected AP. This module only supports 1x1 antenna
> and the antenna is switched to bluetooth due to some incorrect
> register settings.
>
> This commit hand over the antenna control to PTA, the wifi signal
> will be back to normal and the bluetooth scan can also work at the
> same time. However, the btcoexist still needs to be handled under
> different circumstances. If there's a BT connection established,
> the wifi still fails to connect until disconneting the BT.
>
> Signed-off-by: Chris Chiu <chiu@endlessm.com>

Really nice work finding this!

I know that after this change, you plan to bring over the btcoexist
code from the vendor driver (or at least the minimum required code)
for a more complete fix, but I'm curious how you found these magic
register values and how they compare to the values used by the vendor
driver with btcoexist?

What's PTA? A type of firmware-implemented btcoexist that works for
scanning but doesn't work when a BT connection is actually
established?

> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
> index 3adb1d3d47ac..6c3c70d93ac1 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
> @@ -1525,7 +1525,7 @@ static void rtl8723b_enable_rf(struct rtl8xxxu_priv *priv)
>         /*
>          * WLAN action by PTA
>          */
> -       rtl8xxxu_write8(priv, REG_WLAN_ACT_CONTROL_8723B, 0x04);
> +       rtl8xxxu_write8(priv, REG_WLAN_ACT_CONTROL_8723B, 0x0c);

The comment above this still says "WLAN action by PTA" and the vendor
driver has:
        //set wlan_act control by PTA
        pBtCoexist->fBtcWrite1Byte(pBtCoexist, 0x76e, 0x4);

but then also:
            //set wlan_act control by PTA
            pBtCoexist->fBtcWrite1Byte(pBtCoexist, 0x76e, 0xc);

So this change seems to be at least consistent with ambiguity of the
vendor driver, do you have any understanding of the extra bit that is
now set here?

It's not easy to follow the code flow of the vendor driver to see what
actually happens, have you checked that, does it end up using the 0xc
value?

> -        * 0x280, 0x00, 0x200, 0x80 - not clear
> +        * Different settings per different antenna position.
> +        * Antenna switch to BT: 0x280, 0x00 (inverse)
> +        * Antenna switch to WiFi: 0x0, 0x280 (inverse)
> +        * Antenna controlled by PTA: 0x200, 0x80 (inverse)
>          */
> -       rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x00);
> +       rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x80);

I don't quite follow the comment here. Why are there 2 values listed
for each possibility, what do you mean by inverse? You say the
register settings were incorrect, but the previous value was 0x00
which you now document as "antenna switch to wifi" which sounds like
it was already correct?

Which value does the vendor driver use?

>         /*
>          * Software control, antenna at WiFi side
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> index 8136e268b4e6..87b2179a769e 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> @@ -3891,12 +3891,13 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
>
>         /* Check if MAC is already powered on */
>         val8 = rtl8xxxu_read8(priv, REG_CR);
> +       val16 = rtl8xxxu_read16(priv, REG_SYS_CLKR);
>
>         /*
>          * Fix 92DU-VC S3 hang with the reason is that secondary mac is not
>          * initialized. First MAC returns 0xea, second MAC returns 0x00
>          */
> -       if (val8 == 0xea)
> +       if (val8 == 0xea || !(val16 & BIT(11)))
>                 macpower = false;
>         else
>                 macpower = true;

At a glance I can't see which code this corresponds to in the vendor
driver, can you point that out?

Thanks
Daniel
