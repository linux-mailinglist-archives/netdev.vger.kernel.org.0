Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F229D26F8D0
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 11:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgIRJAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 05:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbgIRJAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 05:00:15 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BA41C061756
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 02:00:15 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id y13so6041188iow.4
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 02:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VEcVIKjTQPRY5wW56LKl3iYYM2PdJSTYEi/Boje3RWY=;
        b=o5rqldtqmWX5hCHBkiWtR7T+Po97/Yz7dFzA/+1Q8xsypztn8I8v61yQKg/7dQXrSK
         dtBxitR/JDxyy8NAEptSAKDM/g4IFEIX4CDt87Y/mkxGEH9GJ0nQ+cTc4PYy0XcAsk7/
         S6YAtP7Bl5RsOPZn+dj7q9JjZU7SPOqUxnuUue8HD4STKthWXqZgHgUut3tXa1UrMSsP
         Ce2GyXlk10zYIc3fthiuoSYWW2Vfl9HIfCy+A/GQ2JH8Ijz1R+5I1+Pyht/DxGya8DuU
         q1FDJLNPpO4ZUGNao14bhYzDkNJIKNnBq2klmN7ks7K3ikLyGiKghJQTHt0/jD4VedQu
         EjPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VEcVIKjTQPRY5wW56LKl3iYYM2PdJSTYEi/Boje3RWY=;
        b=arTo9VF6DTPGxZatp3CBx3ENoU2wHq5ubJQOoHBCSblqreEXn459EGlZQJrqFGYRS5
         SMbOFnhL9E3vWbX7TWMB95HEav1nwOT7I7cR6SaRmXMWrKcvhhTihF5meq/xpNjKvmwL
         IYCoxfPQySsHYb88zofMvfzmeUbxwW8C+1BMdh0OX59bk/ixeIwEOeZf41iuGcWk1N77
         U2cppTAGouw2O8lNI4gDEKIvotMVUINHVmphWbIFkq4j/A9HGT0xzAwWpy0Vls6fE16u
         XRAQMvk/xQ5NHM8sE6Lfee3UlQJGW/DTVzp40ieBnzVNNqOP+ZC4OsDTE9IZWl7JYlNd
         o05Q==
X-Gm-Message-State: AOAM532xEbW+uHK8AvpEvSDVWv7oXmVrVmkGxkMyxLb28OXx69u5rUCZ
        BovdW8kQgU5GPxsYMz1afW6sgQZgrnaTrCVNjnmiIg==
X-Google-Smtp-Source: ABdhPJzkK+EPRu3kdIVWMuEjPkQl1ime8bozG9h4Q4OhKWNA3NvfYW2gOtBAS2uk7zvVsM3ZfMR9LpJGguUfIS6qo8c=
X-Received: by 2002:a6b:3bd3:: with SMTP id i202mr26666506ioa.145.1600419614392;
 Fri, 18 Sep 2020 02:00:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200917234953.CB1D295C0A69@us180.sjc.aristanetworks.com> <CANn89iJCm9Rw2U1bK9hAQAzdwebggsWh0DFkHpJF=4OZ2JiSOw@mail.gmail.com>
In-Reply-To: <CANn89iJCm9Rw2U1bK9hAQAzdwebggsWh0DFkHpJF=4OZ2JiSOw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 18 Sep 2020 11:00:02 +0200
Message-ID: <CANn89iJebrj+cE1iVFbFQH0Bso3EFw8Bw0Ep8ozikS_5Ldu2oA@mail.gmail.com>
Subject: Re: [PATCH v3] net: use exponential backoff in netdev_wait_allrefs
To:     Francesco Ruggeri <fruggeri@arista.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 10:48 AM Eric Dumazet <edumazet@google.com> wrote:

>
>
> Also, I would try using synchronize_rcu() instead of the first

s/synchronize_rcu/rcu_barrier/  of course :/

> msleep(), this might avoid all msleep() calls in your case.
>
> Patch without the macros to see the general idea :
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 266073e300b5fc21440ea8f8ffc9306a1fc9f370..2d3b65034bc0dd99017dea846e6c0a966f1207ee
> 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -9989,7 +9989,7 @@ EXPORT_SYMBOL(netdev_refcnt_read);
>  static void netdev_wait_allrefs(struct net_device *dev)
>  {
>         unsigned long rebroadcast_time, warning_time;
> -       int refcnt;
> +       int wait = 0, refcnt;
>
>         linkwatch_forget_dev(dev);
>
> @@ -10023,8 +10023,13 @@ static void netdev_wait_allrefs(struct net_device *dev)
>                         rebroadcast_time = jiffies;
>                 }
>
> -               msleep(250);
> -
> +               if (!wait) {
> +                       synchronize_rcu();

rcu_barrier();

> +                       wait = 1;
> +               } else {
> +                       msleep(wait);
> +                       wait = min(wait << 1, 250);
> +               }
>                 refcnt = netdev_refcnt_read(dev);
>
>                 if (refcnt && time_after(jiffies, warning_time + 10 * HZ)) {
