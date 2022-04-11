Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C38A4FBFAC
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 16:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347550AbiDKO6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 10:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347584AbiDKO5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 10:57:44 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76AF6165AF;
        Mon, 11 Apr 2022 07:55:30 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id g18so6485785ejc.10;
        Mon, 11 Apr 2022 07:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cPfG2H4mLBr47cKqUjnT59BLkTDD6UWYrmsvL4zHnIo=;
        b=Uy/bxAAuqZ9K+qdIhOn4QdDjCdOvTzCsHVj/zq6n0YUDbneYUdT+7RlMaHSomvuQBW
         jnPhQ5/JaFf4xtfN5tM4IyAoqhfaLouNXd7dXmpnztTU72lhDYzFr8hDDjv8Pb+DpZlb
         FSu3lcBq+HgrMUa98apFMFNJ5PZO5z/GTYiBrofm/5UWcfRyPey30K1PAwzH988nLf/9
         5JLsBUgJuuz2UH2fYpob+Sun8G6kQ+vLRfdUxMt5GsLmO0I0C2Rnvnz+QfSa6JPUkDOo
         geSMpMAgN7mkvqTBVmKBo7WsyMsML6XOICzNloiJUGd6T3JtzpA2777VMAGBITmPiDr8
         9yTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cPfG2H4mLBr47cKqUjnT59BLkTDD6UWYrmsvL4zHnIo=;
        b=RaMJFWDIa+6StXUjguJFvN8X+PQepFeZRjXgayrN9f4LCCoLejjY+9uZ4R1iB45MfB
         8KcS8yovWlasTtWcYL/tZidksoGDn3UUJShAw3qEqt1l+G2IJyoQGwskinfBUk+ezHYh
         ummOPnxW0xUM6rFFboufPYhb0bEJG7dvpU8EVIR52LvrYTqeZSMMUC7MH1aJs5uHCI9o
         2Kkqzu3yW4NMJwIPELAo1pdUKYx6X4hNufoEj4O+uZObBchbuWvR6tcrZq3/sp9lgN49
         i/Qn3GkEg+VjmIBnYSwYgnt+2dDmqutciKBOvDLsk7iWD4Phcm9f3+5Yofkvij5+gIu7
         P/yg==
X-Gm-Message-State: AOAM530Yn3vWBh7SjDph0z2XB73RSMWruSnR7eCJ/mlqvbZdAUlG+Y/G
        7acPfd3QjoMg4VVCo91UMUFP3sKlMwsW85D6CMw=
X-Google-Smtp-Source: ABdhPJzGTXwGzpSVprY55wJWpFpj9QAGpv0s5vrLkI3vsCX5pfLKwotr0Y91k+A4dhX3GnpI5z8u5+zDGqDzXjfVGC0=
X-Received: by 2002:a17:907:628e:b0:6d9:c6fa:6168 with SMTP id
 nd14-20020a170907628e00b006d9c6fa6168mr30299560ejc.132.1649688928772; Mon, 11
 Apr 2022 07:55:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220409120901.267526-1-dzm91@hust.edu.cn>
In-Reply-To: <20220409120901.267526-1-dzm91@hust.edu.cn>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 11 Apr 2022 17:51:15 +0300
Message-ID: <CAHp75Vc4hGOJ8gr9R5WqgZ1QkC-uEeQ7WXAqO0YjynDx9jOvnw@mail.gmail.com>
Subject: Re: [PATCH] driver: usb: nullify dangling pointer in cdc_ncm_free
To:     Dongliang Mu <dzm91@hust.edu.cn>
Cc:     Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        syzbot+eabbf2aaa999cc507108@syzkaller.appspotmail.com,
        USB <linux-usb@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 10, 2022 at 5:14 AM Dongliang Mu <dzm91@hust.edu.cn> wrote:
>
> From: Dongliang Mu <mudongliangabcd@gmail.com>
>
> cdc_ncm_bind calls cdc_ncm_bind_common and sets dev->data[0]
> with ctx. However, in the unbind function - cdc_ncm_unbind,
> it calls cdc_ncm_free and frees ctx, leaving dev->data[0] as
> a dangling pointer. The following ioctl operation will trigger
> the UAF in the function cdc_ncm_set_dgram_size.

First of all, please use the standard form of referring to the func()
as in this sentence.

> Fix this by setting dev->data[0] as zero.
>
> ==================================================================
> BUG: KASAN: use-after-free in cdc_ncm_set_dgram_size+0xc91/0xde0
> Read of size 8 at addr ffff8880755210b0 by task dhcpcd/3174
>

Please, avoid SO noisy commit messages. Find the core part of the
traceback(s) which should be rarely more than 5-10 lines.

...

The code seems fine.

-- 
With Best Regards,
Andy Shevchenko
