Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12DB650B0C0
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 08:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444479AbiDVGl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 02:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444475AbiDVGlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 02:41:55 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842FE50B20
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 23:39:03 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id n8so8819449plh.1
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 23:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cNghPWCFIl5S1oIO4pKrneJMrVJFnBTUZUwsfafcstM=;
        b=lcrVgqNom++FvhFJS3YFurgMGzRxP7vZJsfL6q3mH6YRYdiZeGITx7N8uOGqvJhD1k
         m2Y9oUwpaSTp8GyDtOBtjpsNu+q39tCVgKFvPDGT4n6ZULZD3M+IeAkXglHdAiXFak00
         y9ZuWhzmhOKNplfgFoicqmxAq0vzEGlLplJH8r/F72+lgA7B4ZJ3FPQ6zu+lI/pwyyDr
         KCnM9F2l7mef3sE3rfHw+AbO8mIoHZlWsoPxfw+z6Pr+ynjlICooxaPfjTD2fnHRSzna
         0P+cyOLLxydksmGJtegFlE4G1pPbolt602c55+SmXAMvG+dKIrHHQZU1zr91FgtvEmmX
         Pi1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cNghPWCFIl5S1oIO4pKrneJMrVJFnBTUZUwsfafcstM=;
        b=F15R4+V5yJFyZ3m+nzICn9OqVPKpClFXWShFImEiHLMnLWn/ALfPc1jzY8wCpZidEw
         AKzQEQKwH8TaX5iBhGQVwn/6JF7fiA/gfV93uODklvUgozTyVfd0iUd3zmDOD6uN4jHX
         nGBng8AokJXO9nllo4kWM7irekbF8qPXJ4WLKX+PbkdaOppjp62sN+PmY4DG/demCSoh
         LWozYr1wNDmXB6NJyN5veMdj5QHREJ5zo1Z0YZQajX00W1oQ6W/JRnmw7ike/ppEyJQj
         mENo1wmF3kIqdFqN0JPMQuZxgu9KR3QKLKUBA1SefAJpvpZOMqRu8GBB4FVm+YfL0kY/
         6pMw==
X-Gm-Message-State: AOAM532mByM0IJo9UbSu99wKFfxBovI2s44Ay7KsNxCA13CItsnw298p
        CWsUbpl7o4VMfCCGhrN5hE/e/4O9getGo+7i6m/cdQ==
X-Google-Smtp-Source: ABdhPJxnQILzdCyVpR884+5nUVw3m637T2LkKQ3RgSTsU4XSQZ3/Xv7Ct3sBtJxzyrONccu81ZpJ3Vq/EZh2dxI1FU8=
X-Received: by 2002:a17:902:e881:b0:158:fd34:7b28 with SMTP id
 w1-20020a170902e88100b00158fd347b28mr2931091plg.95.1650609542934; Thu, 21 Apr
 2022 23:39:02 -0700 (PDT)
MIME-Version: 1.0
References: <7390d51f-60e2-3cee-5277-b819a55ceabe@I-love.SAKURA.ne.jp>
In-Reply-To: <7390d51f-60e2-3cee-5277-b819a55ceabe@I-love.SAKURA.ne.jp>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Fri, 22 Apr 2022 08:38:26 +0200
Message-ID: <CAMZdPi9eR_0zf02SPHC_+by4k9dJpFfZcDvk-peVBmpefQZchA@mail.gmail.com>
Subject: Re: [PATCH v2] wwan_hwsim: Avoid flush_scheduled_work() usage
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Apr 2022 at 05:01, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
>
> Flushing system-wide workqueues is dangerous and will be forbidden.
> Replace system_wq with local wwan_wq.
>
> While we are at it, make err_clean_devs: label of wwan_hwsim_init()
> behave like wwan_hwsim_exit(), for it is theoretically possible to call
> wwan_hwsim_debugfs_devcreate_write()/wwan_hwsim_debugfs_devdestroy_write()
> by the moment wwan_hwsim_init_devs() returns.
>
> Link: https://lkml.kernel.org/r/49925af7-78a8-a3dd-bce6-cfc02e1a9236@I-love.SAKURA.ne.jp
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>

Reviewed-by: Loic Poulain <loic.poulain@linaro.org>


> ---
> Changes in v2:
>   Keep flush_workqueue(wwan_wq) explicit in order to match the comment.
>   Make error path of wwan_hwsim_init() identical to wwan_hwsim_exit().
>
>  drivers/net/wwan/wwan_hwsim.c | 22 +++++++++++++++++-----
>  1 file changed, 17 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/wwan/wwan_hwsim.c b/drivers/net/wwan/wwan_hwsim.c
> index 5b62cf3b3c42..fad642f9ffd8 100644
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
> -               return PTR_ERR(wwan_hwsim_class);
> +       if (IS_ERR(wwan_hwsim_class)) {
> +               err = PTR_ERR(wwan_hwsim_class);
> +               goto err_wq_destroy;
> +       }
>
>         wwan_hwsim_debugfs_topdir = debugfs_create_dir("wwan_hwsim", NULL);
>         wwan_hwsim_debugfs_devcreate =
> @@ -523,9 +530,13 @@ static int __init wwan_hwsim_init(void)
>         return 0;
>
>  err_clean_devs:
> +       debugfs_remove(wwan_hwsim_debugfs_devcreate);   /* Avoid new devs */
>         wwan_hwsim_free_devs();
> +       flush_workqueue(wwan_wq);       /* Wait deletion works completion */
>         debugfs_remove(wwan_hwsim_debugfs_topdir);
>         class_destroy(wwan_hwsim_class);
> +err_wq_destroy:
> +       destroy_workqueue(wwan_wq);
>
>         return err;
>  }
> @@ -534,9 +545,10 @@ static void __exit wwan_hwsim_exit(void)
>  {
>         debugfs_remove(wwan_hwsim_debugfs_devcreate);   /* Avoid new devs */
>         wwan_hwsim_free_devs();
> -       flush_scheduled_work();         /* Wait deletion works completion */
> +       flush_workqueue(wwan_wq);       /* Wait deletion works completion */
>         debugfs_remove(wwan_hwsim_debugfs_topdir);
>         class_destroy(wwan_hwsim_class);
> +       destroy_workqueue(wwan_wq);
>  }
>
>  module_init(wwan_hwsim_init);
> --
> 2.32.0
>
