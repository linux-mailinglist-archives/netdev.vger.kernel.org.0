Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0EF5BE8E7
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 01:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728976AbfIYX1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 19:27:30 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:44463 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbfIYX13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 19:27:29 -0400
Received: by mail-lj1-f193.google.com with SMTP id m13so131861ljj.11
        for <netdev@vger.kernel.org>; Wed, 25 Sep 2019 16:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9sqCXdxl+Of7jf6rJsO8rQ0SGF0MvqeTX3//lE6sq48=;
        b=gTi2p0HMuFn+258nhleL02ZvNEY402U9LWCy+tdYU2Sk6btSfKw/0ugF12eXEQMJDD
         AiCUx2NMw7R2DUnRcunLUwriIwf9m41Jih9BtKp8M0EHefP2r6DzFrUAGM7LRzQBKG6V
         D5qHVcJgrSgHazrW0ieVDxpwzxQmX4JftqmeGr7jsTQ2Jf6wNBm8ptZr84U/ix/TNddQ
         LaFAdntoNdWv4qcPbmmGTKSyXOnItU2ydsiZdwDgwyXzcn/Du2bLeosUtPqaBdKbbdz8
         8ReWy4Tx7TCiwaWLV6F9ULLUyVDiw+SQx3kT8FV4RIWv59mFrauIHVcU5yZdQicd/cy0
         0zAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9sqCXdxl+Of7jf6rJsO8rQ0SGF0MvqeTX3//lE6sq48=;
        b=LlSDbfY7A/Ftv/wpfVtJ59XJURawIAtLm4Zy1/gLxjXBg11uMKIs5WBjtlunCm9eVc
         K9KNzB1US0RC2NxnyFYm5p6s25tQSuJWlbO8CKQlkD9HnT+oZrxxz2ZRurhm+2/4Wvpu
         +Pl+CJrc77Fd0aujFFUnotT6m5ho3CfmjijvjTuuKa2fKS7iPwoG5kiq0D4wPBTpFu3K
         Zfh5LOeYBNl9naLYzh+MumsluYsPa1as+/ARTToyDKdWijwFTjiTDdV0+xDbk/oAtjLD
         FEaMRRyUw71Y316+NyAk5Sl3kzMdTMNYRKbz6wJqZSTmYZzlANuswmug5gqqMPe19k1J
         tCsg==
X-Gm-Message-State: APjAAAXYHxseVehNFL6Ah/KwugR1drO5nf+5J1goZcv8ctB/l8SEnsdV
        1aEGO9Uw6y+A3Z3vHdGfCVkD0NQ/iTvhY4vW/4T6
X-Google-Smtp-Source: APXvYqz+rc3PxdRkC9XVh7Yo8Mkknz6GnwWo3ELRdvf9CffUm4W0C9Axdhbp4gFE431jFa9hhWXIevuLhkMI2c4paW4=
X-Received: by 2002:a2e:890c:: with SMTP id d12mr490009lji.85.1569454047520;
 Wed, 25 Sep 2019 16:27:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190925221009.15523-1-navid.emamdoost@gmail.com>
In-Reply-To: <20190925221009.15523-1-navid.emamdoost@gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 25 Sep 2019 19:27:16 -0400
Message-ID: <CAHC9VhR+4pZObDz7kG+rxnox2ph4z_wpZdyOL=WmdnRvdQNH9A@mail.gmail.com>
Subject: Re: [PATCH] genetlink: prevent memory leak in netlbl_unlabel_defconf
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, kjlu@umn.edu, smccaman@umn.edu,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 25, 2019 at 6:10 PM Navid Emamdoost
<navid.emamdoost@gmail.com> wrote:
>
> In netlbl_unlabel_defconf if netlbl_domhsh_add_default fails the
> allocated entry should be released.
>
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> ---
>  net/netlabel/netlabel_unlabeled.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

It is worth noting that netlbl_unlabel_defconf() is only called during
kernel boot by netlbl_init() and if netlbl_unlabel_defconf() returns
an error code the system panics, so this isn't currently a very
practical concern.

That said, netlbl_unlabel_defconf() *should* clean up here just on
principal if nothing else.

Acked-by: Paul Moore <paul@paul-moore.com>

> diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
> index d2e4ab8d1cb1..c63ec480ee4e 100644
> --- a/net/netlabel/netlabel_unlabeled.c
> +++ b/net/netlabel/netlabel_unlabeled.c
> @@ -1541,8 +1541,10 @@ int __init netlbl_unlabel_defconf(void)
>         entry->family = AF_UNSPEC;
>         entry->def.type = NETLBL_NLTYPE_UNLABELED;
>         ret_val = netlbl_domhsh_add_default(entry, &audit_info);
> -       if (ret_val != 0)
> +       if (ret_val != 0) {
> +               kfree(entry);
>                 return ret_val;
> +       }
>
>         netlbl_unlabel_acceptflg_set(1, &audit_info);
>
> --
> 2.17.1
>


-- 
paul moore
www.paul-moore.com
