Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9FDF1E8262
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 17:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgE2Ppx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 11:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726970AbgE2Ppw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 11:45:52 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240DCC03E969;
        Fri, 29 May 2020 08:45:51 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id c71so3870798wmd.5;
        Fri, 29 May 2020 08:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UwYuAQiiOYSS1ZCD4ApJMsk64sL+9SZ8EMbwtrkEjrw=;
        b=mNswK2oz+zwk+AmONzw2iyfj5PTQNSbsZq9wIdNB8D5p8izLuqJN6LYXIDAiINhHep
         Laa/2OEQewhvVZ76EutNUlw4MDy5QX8V8RgCpw3S2h4dw6yx+7RIt65jT8z8f7JRNVJJ
         Osx2zqzhyKUiHrEnpVT9VrcMDRgFTTyfytCjKXmFvu15ZIhlgcGlNpKJh9w4Z8Qc5sEY
         o1vjQPQXUs+IcqBcV4PQjJN3DjOJX9rg06F1+pUfQ50BunOXn/4iE0tCXfxdeXAz4gUp
         lkRoo1I9D0rgNb+4BJjVWCiMw6uTOAh02mVSHEF+tCNe6zvARIFoJLJfd6bsZLqWYZzP
         aaJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UwYuAQiiOYSS1ZCD4ApJMsk64sL+9SZ8EMbwtrkEjrw=;
        b=nuSq0XxosDIkYPuttuaikxKmBUo/acwUsms4utT6pfX63+wMLyB0jWMFm/+foFAJma
         HuAH8RRSQuChpRVulpnAt2V3ZqigIX7RhRqCVgDHSgKw+kiwHpBSmuwpVtLJzHouDfh/
         bMJjlDJoiQzpPa1HV+BoqBEqymDqBHEI7r+JthXUAfgqAPyz0NIG9lEP1sBbV2K89d4g
         CzYKxjUEMLfjIdLlClJ6I3OCQYT1Dzc3RxAyJ3O/ROdAKlfKQK/a8dr5g2LzLmAE3JNF
         wuSg51UDqyf31F4+mpxIxl5rFRdTLFfWCJerRT474i62bQWU3N2cGnKPRTgRFurHvDjj
         FosA==
X-Gm-Message-State: AOAM533zS+xGLmEgo2kdsWHBGfpxLx/c5j1KqjFuLOQ9GLMdFLScyR0/
        6QY6uEE1Bvn699gA76I7GRgUllS9
X-Google-Smtp-Source: ABdhPJxA8jvRT0wgdeqCpmga/iRVT1LlupPDtzeY5/dIujU5T9ZBRGG3rPia6avS4FmdOCLUp9WKPg==
X-Received: by 2002:a1c:2d14:: with SMTP id t20mr9379349wmt.28.1590767148255;
        Fri, 29 May 2020 08:45:48 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id l17sm11167695wmi.3.2020.05.29.08.45.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 08:45:47 -0700 (PDT)
Subject: Re: [PATCH RFT] ravb: Mask PHY mode to avoid inserting delays twice
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200529122540.31368-1-geert+renesas@glider.be>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ad6027ac-4e59-08c7-ec27-ea7ce674cf18@gmail.com>
Date:   Fri, 29 May 2020 08:45:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200529122540.31368-1-geert+renesas@glider.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/29/2020 5:25 AM, Geert Uytterhoeven wrote:
> Until recently, the Micrel KSZ9031 PHY driver ignored any PHY mode
> ("RGMII-*ID") settings, but used the hardware defaults, augmented by
> explicit configuration of individual skew values using the "*-skew-ps"
> DT properties.  The lack of PHY mode support was compensated by the
> EtherAVB MAC driver, which configures TX and/or RX internal delay
> itself, based on the PHY mode.
> 
> However, now the KSZ9031 driver has gained PHY mode support, delays may
> be configured twice, causing regressions.  E.g. on the Renesas
> Salvator-X board with R-Car M3-W ES1.0, TX performance dropped from ca.
> 400 Mbps to 0.1-0.3 Mbps, as measured by nuttcp.
> 
> As internal delay configuration supported by the KSZ9031 PHY is too
> limited for some use cases, the ability to configure MAC internal delay
> is deemed useful and necessary.  Hence a proper fix would involve
> splitting internal delay configuration in two parts, one for the PHY,
> and one for the MAC.  However, this would require adding new DT
> properties, thus breaking DTB backwards-compatibility.
> 
> Hence fix the regression in a backwards-compatibility way, by letting
> the EtherAVB driver mask the PHY mode when it has inserted a delay, to
> avoid the PHY driver adding a second delay.  This also fixes messages
> like:
> 
>     Micrel KSZ9031 Gigabit PHY e6800000.ethernet-ffffffff:00: *-skew-ps values should be used only with phy-mode = "rgmii"
> 
> as the PHY no longer sees the original RGMII-*ID mode.
> 
> Solving the issue by splitting configuration in two parts can be handled
> in future patches, and would require retaining a backwards-compatibility
> mode anyway.
> 
> Fixes: bcf3440c6dd78bfe ("net: phy: micrel: add phy-mode support for the KSZ9031 PHY")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
