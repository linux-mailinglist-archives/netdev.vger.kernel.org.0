Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9242041AD3C
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 12:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240249AbhI1Ksk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 06:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234543AbhI1Ksj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 06:48:39 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9DBFC061575;
        Tue, 28 Sep 2021 03:46:59 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id i25so91198178lfg.6;
        Tue, 28 Sep 2021 03:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=u+2rVp9HeyOpAN4HdDwAIbJ9f2x7tP25BbeWtRbvMFE=;
        b=G9A/A32stXBxe+cXhMiVnNYfPU/msoSHBgsdeemiQiGdnbInbJQwfcM6Pg2xvC/ktf
         7yxWddK33mVVpwirj2Kf+aCWDl+76e/icTY+Ve3+81nd3vgIKfB3ih9o+PPIqnheVGUm
         n7QCidpB6v+0KJNkiWeF8jbzMGpjgXC+XGs0/5OlgYLEym9HvOIcwd5aUI0xiSkSdKQv
         Lk5eoUxYDkUluJR6w/BPtrwHi0iQPfSEGR4GbKSNCJYGhEOWNPEDqkxfPbUqJwiZ0x+M
         afpbdSeLiRxZllwYYkIs6DXZ5gnoQr2UObZhlZlekdTyge4eJdj/4QlruzKOTMQ0G/qT
         nP9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=u+2rVp9HeyOpAN4HdDwAIbJ9f2x7tP25BbeWtRbvMFE=;
        b=087jIG/cna5quZU2xi1VhIjdesUXMxhZm1t3b0UIHc+5mF8ZdoNtGJxouNL+yLDW2p
         w5JjXRlVtMLAq66WRhviEoAKZNXX44Olvnw1FzXs7AvCYLDe8dXkp60J+1f8Xw5+Ebqr
         AIxYlE/OnkYF9GCEp7K3vxPuEscFd2icRGWkiqwZsEXWOZy9KAZ6Rd5t70c+Di44LJU4
         xtV5wJipyVP9hcewYipszdit7XVvFXYBZ0raY4KCw+Kd2eo21TDsgiXfguvH8lCjgzCf
         7Y4ogDo53YW0cruA6pfrDnNhFffV8jkw2nGRrtwcQd9DvFNVnS+zsgCrEHaH2dC3E+Cb
         6NlQ==
X-Gm-Message-State: AOAM530cAgnLrbknoUz68IYrlvrkJd5aJBtMSbyEX0c/qle2D5pXmzob
        6XHi57IikFGfu3XgCsEMJl0=
X-Google-Smtp-Source: ABdhPJx3oAOzT7qu1PlKiE0mHTHD9qOJGegBN5ly3NOyz/5T9ETVUTt3ZwSEwTzbb/wSon/uRjuSJQ==
X-Received: by 2002:ac2:5e83:: with SMTP id b3mr4988178lfq.305.1632826018046;
        Tue, 28 Sep 2021 03:46:58 -0700 (PDT)
Received: from [172.28.2.233] ([46.61.204.60])
        by smtp.gmail.com with ESMTPSA id v9sm1500222lfr.148.2021.09.28.03.46.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 03:46:57 -0700 (PDT)
Message-ID: <63b18426-c39e-d898-08fb-8bfd05b7be9e@gmail.com>
Date:   Tue, 28 Sep 2021 13:46:56 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] net: mdiobus: Fix memory leak in __mdiobus_register
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Yanfei Xu <yanfei.xu@windriver.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, p.zabel@pengutronix.de,
        syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dongliang Mu <mudongliangabcd@gmail.com>
References: <20210926045313.2267655-1-yanfei.xu@windriver.com>
 <20210928085549.GA6559@kili> <20210928092657.GI2048@kadam>
 <6f90fa0f-6d3b-0ca7-e894-eb971b3b69fa@gmail.com>
 <20210928103908.GJ2048@kadam>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <20210928103908.GJ2048@kadam>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/28/21 13:39, Dan Carpenter wrote:
> No, the syzbot link was correct.
> 

Link is correct, but Yanfei's patch does not fix this bug. Syzbot 
reported leak, that you described below, not the Yanfei one.

> You gave me that link again but I think you must be complaining about
> a different bug which involves mdiobus_free().  Your bug is something
> like this:
> 
> drivers/staging/netlogic/xlr_net.c
>     838          err = mdiobus_register(priv->mii_bus);
>     839          if (err) {
>     840                  mdiobus_free(priv->mii_bus);
> 
> This error path will leak.
> 
>     841                  pr_err("mdio bus registration failed\n");
>     842                  return err;
>     843          }
> 
> Your patch is more complicated than necessary...  Just do:
> 
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index ee8313a4ac71..c380a30a77bc 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -538,6 +538,7 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
>   	bus->dev.groups = NULL;
>   	dev_set_name(&bus->dev, "%s", bus->id);
>   
> +	bus->state = MDIOBUS_UNREGISTERED;
>   	err = device_register(&bus->dev);
>   	if (err) {
>   		pr_err("mii_bus %s failed to register\n", bus->id);
> 
> 
yep, it's the same as mine, but I thought, that MDIOBUS_UNREGISTERED is 
not correct name for this state :) Anyway, thank you for suggestion



With regards,
Pavel Skripkin
