Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 623901BA160
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 12:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgD0Kdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 06:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726504AbgD0Kdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 06:33:49 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED004C0610D5;
        Mon, 27 Apr 2020 03:33:48 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id z1so7129950pfn.3;
        Mon, 27 Apr 2020 03:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/yQSlVE7PnqopQQf8iulieHvAebBl49JpRFSg6plQOM=;
        b=svEuRkyXeWE3IGEar5EHdocILyDaW+N13jTvaXBDoiDY7QzRabNPcqPxk2izwFfPrS
         jvDbUeVC5CoKypPJaGwxGalr9dnagxExe7bIiHksHfBch3vtRWBCIEYTgyBM83QqYkz5
         YxeEJh/bzDTpa02BND1fjJLof2J+ssnoQaXbNs732qWb1yyOPp1QbwGEv/SFEq+tUmuJ
         VywvW5hrMuOdMz27XswGzFq7FO48vtQ7AkbuOn9dm5p6ATj1UH0ErQ/pU3bWM5YogOfU
         fwyve8vTb692wz5hPxqwJiMgWLcz+2rUjmamPzMNrc5j0uGbaf1e6ngiPzMwAdV8NLwN
         IthA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/yQSlVE7PnqopQQf8iulieHvAebBl49JpRFSg6plQOM=;
        b=sia8Kndqs18gloYktSSudrjF8kBjU07sudqIfba25fJNsTVmtdzZXB4MJccS9vU8Eh
         no4VPtWPrAKO96UkUnbLgqyfWln9vfD03Yacwz5WpD2IejJTLk1BUfMEAxVX1U1+d/LR
         EmrihH8oI7TUSyutjEstVtJHwwwMn5Ot85LGmMJAGBWC/rNkTEkOJRaXbmIza+70YTh6
         PY5m9Oyq/WIRWlUI9APswT3tf+Ud9NI8r9P/8V/c1BMb1K3QnvaH9PRuQ77exiqXqF9M
         w+pa8puTPWybjlXJbRo3khRtE+RiZbogD5UkvrTsJDeI1/P56P/TRVSXweBU3JKuHAtu
         dLYQ==
X-Gm-Message-State: AGi0PuYMmNnHva3RtLdFwTVzI12TFs5iUSp2b222nK81oZ9JjFOt/cvA
        e9V41FOdYwWpQnKTed/5FsX67s2Yz7lrNd6j/LE=
X-Google-Smtp-Source: APiQypKwFdPTEoWxkFdp7BjvZptGlC1JmP+zurw7A4cawLsmuik55JaoNHk55SZ8V/uC/2uAPJ5DV7eEk98vKKYHIXU=
X-Received: by 2002:a63:1c1:: with SMTP id 184mr23267416pgb.203.1587983628496;
 Mon, 27 Apr 2020 03:33:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200425125737.5245-1-zhengdejin5@gmail.com>
In-Reply-To: <20200425125737.5245-1-zhengdejin5@gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 27 Apr 2020 13:33:41 +0300
Message-ID: <CAHp75VceH08X5oWSCXhx8O0Bsx9u=Tm+DVQowG+mC3Vs2=ruVQ@mail.gmail.com>
Subject: Re: [PATCH net v1] net: macb: fix an issue about leak related system resources
To:     Dejin Zheng <zhengdejin5@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        yash.shah@sifive.com, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 25, 2020 at 3:57 PM Dejin Zheng <zhengdejin5@gmail.com> wrote:
>
> A call of the function macb_init() can fail in the function
> fu540_c000_init. The related system resources were not released
> then. use devm_ioremap() to replace ioremap() for fix it.
>

Why not to go further and convert to use devm_platform_ioremap_resource()?

> Fixes: c218ad559020ff9 ("macb: Add support for SiFive FU540-C000")
> Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
> Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
> ---
>  drivers/net/ethernet/cadence/macb_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index a0e8c5bbabc0..edba2eb56231 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -4178,7 +4178,7 @@ static int fu540_c000_init(struct platform_device *pdev)
>         if (!res)
>                 return -ENODEV;
>
> -       mgmt->reg = ioremap(res->start, resource_size(res));
> +       mgmt->reg = devm_ioremap(&pdev->dev, res->start, resource_size(res));
>         if (!mgmt->reg)
>                 return -ENOMEM;
>
> --
> 2.25.0
>


-- 
With Best Regards,
Andy Shevchenko
