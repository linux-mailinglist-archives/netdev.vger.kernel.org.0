Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC23B191290
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 15:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbgCXONy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 10:13:54 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:45821 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbgCXONx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 10:13:53 -0400
Received: by mail-ed1-f68.google.com with SMTP id u59so20796948edc.12
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 07:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PaYfAI1iFCtvNwyFF7Lig39rIP7pjEc3YqI8PXTqAic=;
        b=PRQjeg+pDtXEqJVsF1/NNQer5oGvcaU7974Cl7ImByDsAG7OUKn56QwGExW//Nwsal
         ZBrxEB4oL5zcGh6NZv436mYmvBP0pXeMZYpkp+NaUbjA5jInsAsd0NjFJ+ZKM+cKlF38
         wzTNzsn0cIX5A1jLcjnsPL0Nc6+Nu3jENRrI02U4Z418NGcdKzIajN3+TGppaU40AzMh
         UVjN64kjTfXaO6wCgarA0vBJ72FDejm2rwlWCm9xknWxqlOeV4DjWYiU8q/ZXXxwecHz
         5++rKahF71jRaJndXQh7DmP4hwrKVwhRL9nUOMjk8kEMQNaW4yUxJty3hSZEOAVR9f5/
         +clw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PaYfAI1iFCtvNwyFF7Lig39rIP7pjEc3YqI8PXTqAic=;
        b=C/x6mPu7Fu6SZo+/47H6CP/V548cWdB8yuUT/+Yp3rWz7JOtN+c3FC6n1KMo0I92kP
         zrImMznYzLhUyEdnFQwB80bms9+lCVn3Ip9PTTSAg2D5qqjcDJRnvydCOAIVkqn+d3kc
         mKHmwt7NhCJId94miH60XpA3YfNkpuYum+VR12e5fUKa+bov0oVrBFGoKzuSs9mFynQW
         URSzM5WwenF5ZanKJsxO6m5Y7xRjgzzQFWWBEWGQtR1BZWYSapNKaZ9a86K9PLAK/YZK
         lqmI1m/mLz6p3TdakfFqu9OQ+arvK6+zuep9zTOrOAO2vAghsN9lBTkpJM40oTy7d34I
         mjXg==
X-Gm-Message-State: ANhLgQ3aTq15J3HSCqXCR6cZ45JaaSq7GNDimxkZJdM8VfOMqLqUcAyv
        3kDXSmVk2WSTb7YScia9TB07N+Hv61iBCgawywI=
X-Google-Smtp-Source: ADFU+vtmDWRBm2WKHGvQuXSiJ+griMdr9XP67z1pHzAv3S77+c6ewBLyEnuuha39jhlnr1Vh+AiA60S2Jk511ptFWFE=
X-Received: by 2002:a50:aca3:: with SMTP id x32mr27233471edc.368.1585059231738;
 Tue, 24 Mar 2020 07:13:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200324124837.21556-1-olteanv@gmail.com> <20200324134047.GY3819@lunn.ch>
In-Reply-To: <20200324134047.GY3819@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 24 Mar 2020 16:13:40 +0200
Message-ID: <CA+h21hr2Mx5MpWz-ait_T1eR8GBKmH=1jVfVcsZ-Py7Hcov0ng@mail.gmail.com>
Subject: Re: [PATCH net-next] net: phy: mscc: consolidate a common RGMII delay implementation
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Mar 2020 at 15:40, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Tue, Mar 24, 2020 at 02:48:37PM +0200, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > It looks like the VSC8584 PHY driver is rolling its own RGMII delay
> > configuration code, despite the fact that the logic is mostly the same.
> >
> > In fact only the register layout and position for the RGMII controls has
> > changed. So we need to adapt and parameterize the PHY-dependent bit
> > fields when calling the new generic function.
>
> Nice.
>
> > -static void vsc8584_rgmii_set_skews(struct phy_device *phydev)
> > -{
> > -     u32 skew_rx, skew_tx;
> > -
> > -     /* We first set the Rx and Tx skews to their default value in h/w
> > -      * (0.2 ns).
> > -      */
>
> I like seeing this comment. It makes it clear that
> PHY_INTERFACE_MODE_RGMII does not actually mean 0ns, but 0.2ns.  It
> also makes it clear that if PHY_INTERFACE_MODE_RGMII_ID,
> PHY_INTERFACE_MODE_RGMII_RXID or PHY_INTERFACE_MODE_RGMII_TXID is not
> given, the delay is set to something. We have had PHY drivers which
> get this wrong and leave the bootloader/strapping value in place.
>
> So if you can keep the comment in some form, that would be good.
>
> Thanks
>         Andrew

I find the comments fairly redundant since the code that does that is
already explicit, but anyway I'll send a v2 for the 0.2 ns thing.

Thanks,
-Vladimir
