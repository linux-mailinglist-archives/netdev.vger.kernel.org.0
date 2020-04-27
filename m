Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84951BA185
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 12:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgD0KkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 06:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726507AbgD0KkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 06:40:10 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2CBC0610D5;
        Mon, 27 Apr 2020 03:40:09 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id d17so8533650pgo.0;
        Mon, 27 Apr 2020 03:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MW2w6cYBsYnn2GfMNP4KPWcf4PUGwZkZaGYmrXU7CiE=;
        b=eOFr0yNDPSp7q7vgtgoOygCFVuXicOnsYIZSmwXP/zm9v21hH/m7B/9Hb2oMMFGHtE
         TJzrxfZ/IsHx/xL3A7nixEZzZPfnHCrnw8nzcs//XtbBamVbtFXprYWr8CdrsUEwVDnl
         m+LALk2hUIhF1UQyeYIs4ShIX/2a3QKNuQFMmlS1d6rzaU9cL0kpN6c0Y9u1hCINiwbt
         8ebIwtQZbg/wzKk8WmSyti2sXvpcZYxvGfqG62viprQM05ppWoPzP22naKqsE2zI9Nz0
         GoFYv4ueHnXM9uit745vpKHQ+DsDf0rlPt7RzendHla1sGLLQJEzc0ktoxqy/uj+e9Ds
         G/4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MW2w6cYBsYnn2GfMNP4KPWcf4PUGwZkZaGYmrXU7CiE=;
        b=QwlqhJvVweU9XCoeblLSiPVIOLRuXuwl2YKJUtLhTCYU+A2kvDcf4Lim7H7YZ/MzeT
         6qdFVrYmpiN+tdNSwyaendy5pkhrKboB+yj91YfC78CoUMqCNIfxIJJSNUdjbI37dXMb
         MifpRWQFzYqT73N/EthM4PsRHM+H5FaRKujSNj1u6G+2ow2++ZgGLA06lCsWX8bq28Sc
         01FMinam3S2kpEkM5eLvMV5cnlMp9Lq2IXqYoLBMnQj280Tj79RCWAW7EFHSffwWnqGb
         2XnHAoiSiIPSpYPGGrpjDZffZsF+nXiGFHElYLKMtTwzdE7smIWngwB13PvAIriiw1rt
         pbRA==
X-Gm-Message-State: AGi0Pub/JHAvto7oc9AOe4ho9+ov4duCWbkXk0+CEnDJ4W8y91c8Hh4F
        UC6t8jsOjj1KsRDeX2TYtDB+cE09SXC+ImgYFIY=
X-Google-Smtp-Source: APiQypK0i50BD8R4wbHRW29BsrZnhZtbNkgmmXrOJuxSXNQXSjWGpfxu1W5sqFiXTSMRmJsi/gbBjGU9S2MGMKwp1sc=
X-Received: by 2002:a63:5511:: with SMTP id j17mr21751878pgb.4.1587984008659;
 Mon, 27 Apr 2020 03:40:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200425134007.15843-1-zhengdejin5@gmail.com>
In-Reply-To: <20200425134007.15843-1-zhengdejin5@gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 27 Apr 2020 13:40:02 +0300
Message-ID: <CAHp75VeAetsZsANoHx7X-g8+LOt0+NNarXheY5AR6L+LrdHavQ@mail.gmail.com>
Subject: Re: [PATCH net v1] net: acenic: fix an issue about leak related
 system resources
To:     Dejin Zheng <zhengdejin5@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, jes@trained-monkey.org,
        linux-acenic@sunsite.dk, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 25, 2020 at 4:40 PM Dejin Zheng <zhengdejin5@gmail.com> wrote:
>
> the function ace_allocate_descriptors() and ace_init() can fail in
> the acenic_probe_one(), The related system resources were not
> released then. so change the error handling to fix it.

...

> @@ -568,7 +568,7 @@ static int acenic_probe_one(struct pci_dev *pdev,
>  #endif
>
>         if (ace_allocate_descriptors(dev))
> -               goto fail_free_netdev;
> +               goto fail_uninit;

Not sure.
The code is quite old and requires a lot of refactoring.

Briefly looking the error path there is quite twisted.

> @@ -580,7 +580,7 @@ static int acenic_probe_one(struct pci_dev *pdev,
>  #endif
>
>         if (ace_init(dev))
> -               goto fail_free_netdev;
> +               goto fail_uninit;

This change seems incorrect, the ace_init() calls ace_init_cleanup() on error.
So, your change makes it call the cleanup() twice.

-- 
With Best Regards,
Andy Shevchenko
