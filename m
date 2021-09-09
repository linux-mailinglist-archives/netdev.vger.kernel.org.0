Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE8874046DC
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 10:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbhIIIRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 04:17:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229789AbhIIIRO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 04:17:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5262960FE3;
        Thu,  9 Sep 2021 08:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631175365;
        bh=5arYVwkJzjH3qNHQAF+Jf/WKWE7U6MPjPA9FVILm2HU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HlDJ5yiKW2Sh3ET6LKP9dQYlGpaVvfy+HGqAsgIIkGEnqyBNCPNk7q0uffhlKOfNr
         yYluMjw/K/8yujZH2hcllwoAQUHLB/NoZqxH3SgUUW1x95kSKc05jeW1duHrJSvEfh
         burFJ8i2oPzmGU/eEkFUFlS/9RlvJGkf0B/n8UpLvTfu/q3pQY3SqKKZKRDoI4pOGl
         oDHpMNuFNrWdOnora/VYf/J55lc673sUOnRhlVSSpKmYpnZORgSzbOaes8lOXJDMMK
         CF0FeEznKTmSMaTiBkFQA/IAfLhit8yIRIm+rChJqOI6/pHKE3Apu8qngSvMqjPdjU
         qG7pkKlbylMSQ==
Received: by mail-wr1-f42.google.com with SMTP id u16so1262088wrn.5;
        Thu, 09 Sep 2021 01:16:05 -0700 (PDT)
X-Gm-Message-State: AOAM530VI09EMQb91sNIxkColKh78ICB9B+ktxl6Dcof5cW83nnLUKE+
        DhBTkUhMKnKeRL3YPEt7Xt+UIKZ0fx0yR4X/TCk=
X-Google-Smtp-Source: ABdhPJw7i3+0VL2UwK3fSbCX4vv+uwNopgIeq507D3S4wFPjy8MZzSlJP441rsW/9hkDihakdQBL9k5MMbkcRrIrZSY=
X-Received: by 2002:adf:914e:: with SMTP id j72mr1998903wrj.428.1631175363972;
 Thu, 09 Sep 2021 01:16:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210909044953.1564070-1-linux@roeck-us.net>
In-Reply-To: <20210909044953.1564070-1-linux@roeck-us.net>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Thu, 9 Sep 2021 10:15:48 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2AQffbiqE_HFC5rtf=smjmv2Wu0afTR733bdhRHW4FsQ@mail.gmail.com>
Message-ID: <CAK8P3a2AQffbiqE_HFC5rtf=smjmv2Wu0afTR733bdhRHW4FsQ@mail.gmail.com>
Subject: Re: [PATCH] net: ni65: Avoid typecast of pointer to u32
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 9, 2021 at 6:50 AM Guenter Roeck <linux@roeck-us.net> wrote:
>
> Building alpha:allmodconfig results in the following error.
>
> drivers/net/ethernet/amd/ni65.c: In function 'ni65_stop_start':
> drivers/net/ethernet/amd/ni65.c:751:37: error:
>         cast from pointer to integer of different size
>                 buffer[i] = (u32) isa_bus_to_virt(tmdp->u.buffer);
>
> 'buffer[]' is declared as unsigned long, so replace the typecast to u32
> with a typecast to unsigned long to fix the problem.
>
> Cc: Arnd Bergmann <arnd@kernel.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Acked-by: Arnd Bergmann <arnd@arndb.de>

> ---
>  drivers/net/ethernet/amd/ni65.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/amd/ni65.c b/drivers/net/ethernet/amd/ni65.c
> index b5df7ad5a83f..032e8922b482 100644
> --- a/drivers/net/ethernet/amd/ni65.c
> +++ b/drivers/net/ethernet/amd/ni65.c
> @@ -748,7 +748,7 @@ static void ni65_stop_start(struct net_device *dev,struct priv *p)
>  #ifdef XMT_VIA_SKB
>                         skb_save[i] = p->tmd_skb[i];
>  #endif
> -                       buffer[i] = (u32) isa_bus_to_virt(tmdp->u.buffer);
> +                       buffer[i] = (unsigned long)isa_bus_to_virt(tmdp->u.buffer);

I generally prefer uintptr_t over unsigned long for this cast because it's more
descriptive, but the effect is the same.

      Arnd
