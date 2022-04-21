Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B414B50A5E9
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 18:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbiDUQiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 12:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiDUQiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 12:38:54 -0400
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D41E09C
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 09:36:04 -0700 (PDT)
Received: by mail-ua1-x92f.google.com with SMTP id z15so2008261uad.7
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 09:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mG8t5TTSba6762HOohVUoDOVurWwTc5PxG9Z/PvQRcA=;
        b=YSV3Oj6sVix9pm5zRATQ9rRc4R8CjFLrBJFzazGy197hNCK6Sw7P3exYKa0QO9wxzM
         ZkDFuSKrjjociyJpg1dPCceHw5KSNE6TRVDbmCs3bASts7eEIJg/bFAbDwVQsc7+VUbK
         kchVnefFfeA7nkafzDMv6rjbTyTeZ0KBhfxQL0zxcGV6W5mGKLW+2tCxKlIjJInLG+bR
         le1keomtGa/9wx/4S5tyx6o59WXKPaTpz5LnI3byHrSYcUtX0kQQ/4Sias4//0fjv/aB
         pN+Kn1KRPErerIbvTuvIJX0Kz5fxw/WQ7CXAuDklEsqvhr3V4Y97YZQe5Qnzwxt5bSrB
         w3MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mG8t5TTSba6762HOohVUoDOVurWwTc5PxG9Z/PvQRcA=;
        b=uGIbeIHV8AMDToaoUIS4YWpd2+VDb4kg8bO26ZkB7EqImkf8ZoB1JFocZy5UTzeaFh
         XO3CSNMzg+b6Hs3XmUpdxsKeVFsUkPIYvxyXC5LpbQ0/Qs6VzR6lYSQfvKoBqIK/BhXf
         aoW6YQyr6Sj1L0c8OVOBA/4ODIBjxTsC6rVjheQO5ViGsoOC8/HuhOXv0vHgBFVepd85
         825oNEY2UyIFX7I0z3n12MKBLjreAJ/fbMUPRd/5m4MWX/MNAxeH32oFE6pQrOfXT8nh
         g0Ywpvhd1B0hzMW18a/9O9oCfggArEI/SqlaNnhIem5dk7pcuStEkZD/Sb3aTXSfky2I
         EkZA==
X-Gm-Message-State: AOAM533vFE6vRp9hf+aKxLAcbsYiP8WJxWPE0yKz3EF1rUhkWtg+hhzR
        MSLY447yLjXXeG5Phx7ZCxTnaIhqLxW19jUDZwg=
X-Google-Smtp-Source: ABdhPJwpo5nMow/cCZ8R4aZjvebV0vXjbTr7jjk3IpUGhC6v6ZhDmUg/q+awQaHfqlhnVJA4zlbKYaTSAUDVyVZg0Jk=
X-Received: by 2002:ab0:7290:0:b0:34b:71ac:96c2 with SMTP id
 w16-20020ab07290000000b0034b71ac96c2mr234643uao.102.1650558963412; Thu, 21
 Apr 2022 09:36:03 -0700 (PDT)
MIME-Version: 1.0
References: <0bc6443a-dbac-70ab-bf99-9a439e35f3ef@I-love.SAKURA.ne.jp>
In-Reply-To: <0bc6443a-dbac-70ab-bf99-9a439e35f3ef@I-love.SAKURA.ne.jp>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Thu, 21 Apr 2022 19:35:52 +0300
Message-ID: <CAHNKnsR=-k4tYOYwoYymgsJrLSAW4wpVF06QxDkTsJqNbo=yYw@mail.gmail.com>
Subject: Re: [PATCH] wwan_hwsim: Avoid flush_scheduled_work() usage
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 5:22 AM Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> Flushing system-wide workqueues is dangerous and will be forbidden.
> Replace system_wq with local wwan_wq.
>
> Link: https://lkml.kernel.org/r/49925af7-78a8-a3dd-bce6-cfc02e1a9236@I-love.SAKURA.ne.jp
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

Looks good! Just a couple minor questions below.

Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>

> ---
> Note: This patch is only compile tested. By the way, don't you want to call
> debugfs_remove(wwan_hwsim_debugfs_devcreate) at err_clean_devs label in
> wwan_hwsim_init() like wwan_hwsim_exit() does, for debugfs_create_file("devcreate")
> is called before "goto err_clean_devs" happens?

As I replied in another mail. This is not strictly required, but will
not hurt anyone.

>  drivers/net/wwan/wwan_hwsim.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wwan/wwan_hwsim.c b/drivers/net/wwan/wwan_hwsim.c
> index 5b62cf3b3c42..2136319f588f 100644
> --- a/drivers/net/wwan/wwan_hwsim.c
> +++ b/drivers/net/wwan/wwan_hwsim.c
> @@ -33,6 +33,7 @@ static struct dentry *wwan_hwsim_debugfs_devcreate;
>  static DEFINE_SPINLOCK(wwan_hwsim_devs_lock);
>  static LIST_HEAD(wwan_hwsim_devs);
>  static unsigned int wwan_hwsim_dev_idx;
> +static struct workqueue_struct *wwan_wq;
>
>  struct wwan_hwsim_dev {
>         struct list_head list;
> @@ -371,7 +372,7 @@ static ssize_t wwan_hwsim_debugfs_portdestroy_write(struct file *file,
>          * waiting this callback to finish in the debugfs_remove() call. So,
>          * use workqueue.
>          */
> -       schedule_work(&port->del_work);
> +       queue_work(wwan_wq, &port->del_work);
>
>         return count;
>  }
> @@ -416,7 +417,7 @@ static ssize_t wwan_hwsim_debugfs_devdestroy_write(struct file *file,
>          * waiting this callback to finish in the debugfs_remove() call. So,
>          * use workqueue.
>          */
> -       schedule_work(&dev->del_work);
> +       queue_work(wwan_wq, &dev->del_work);
>
>         return count;
>  }
> @@ -506,9 +507,15 @@ static int __init wwan_hwsim_init(void)
>         if (wwan_hwsim_devsnum < 0 || wwan_hwsim_devsnum > 128)
>                 return -EINVAL;
>
> +       wwan_wq = alloc_workqueue("wwan_wq", 0, 0);
> +       if (!wwan_wq)
> +               return -ENOMEM;
> +
>         wwan_hwsim_class = class_create(THIS_MODULE, "wwan_hwsim");
> -       if (IS_ERR(wwan_hwsim_class))
> +       if (IS_ERR(wwan_hwsim_class)) {
> +               destroy_workqueue(wwan_wq);

How about jumping to some label from here and do the workqueue
destroying there? E.g.

err = PTR_ERR(wwan_hwsim_class);
goto err_wq_destroy;

This will keep code symmetric.

>                 return PTR_ERR(wwan_hwsim_class);
> +       }
>
>         wwan_hwsim_debugfs_topdir = debugfs_create_dir("wwan_hwsim", NULL);
>         wwan_hwsim_debugfs_devcreate =
> @@ -524,6 +531,7 @@ static int __init wwan_hwsim_init(void)
>
>  err_clean_devs:
>         wwan_hwsim_free_devs();
> +       destroy_workqueue(wwan_wq);
>         debugfs_remove(wwan_hwsim_debugfs_topdir);
>         class_destroy(wwan_hwsim_class);

As you can see there are no need to wait the workqueue flushing, since
it was not used. So the queue destroying call can be moved below the
class destroying to keep cleanup symmetrical to the init sequence.
E.g.

 err_clean_devs:
        wwan_hwsim_free_devs();
        debugfs_remove(wwan_hwsim_debugfs_topdir);
        class_destroy(wwan_hwsim_class);

+err_wq_destroy:
+       destroy_workqueue(wwan_wq);
+
       return err;
}

> @@ -534,7 +542,7 @@ static void __exit wwan_hwsim_exit(void)
>  {
>         debugfs_remove(wwan_hwsim_debugfs_devcreate);   /* Avoid new devs */
>         wwan_hwsim_free_devs();
> -       flush_scheduled_work();         /* Wait deletion works completion */
> +       destroy_workqueue(wwan_wq);             /* Wait deletion works completion */
>         debugfs_remove(wwan_hwsim_debugfs_topdir);
>         class_destroy(wwan_hwsim_class);
>  }

I do not care too much, but can we explicitly call the queue flushing
to make  the exit handler as clear as possible?

 {
        debugfs_remove(wwan_hwsim_debugfs_devcreate);   /* Avoid new devs */
        wwan_hwsim_free_devs();
-       flush_scheduled_work();         /* Wait deletion works completion */
+       flush_workqueue(wwan_wq);             /* Wait deletion works
completion */
        debugfs_remove(wwan_hwsim_debugfs_topdir);
        class_destroy(wwan_hwsim_class);
+       destroy_workqueue(wwan_wq);
 }

-- 
Sergey
