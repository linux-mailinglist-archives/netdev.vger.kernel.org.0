Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BED8196D8F
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 14:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbgC2M4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 08:56:33 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:33811 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727951AbgC2M4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 08:56:33 -0400
Received: by mail-ed1-f65.google.com with SMTP id i24so17525945eds.1
        for <netdev@vger.kernel.org>; Sun, 29 Mar 2020 05:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7Y00zfd8DDbnoqXnEtT/BAmJCh4hqgczSvdhA8/Nj/w=;
        b=uf7zgEGG1qU5KMzcmjxUJyO6Go8sZTyMdCvGiN7k/BejN1/2uYlRQVPXcaBCLUNhMB
         j8ZUB1Llw7U1i1O5BuLlOlhW1JfZMizY0G9RjxCsqbU+AjbpJkcZuEHnAAWyRkvP4HSI
         ZZQUFF025J9+gy5CtpGlH7j6Vib6Kr8mtSQpqXNVSbMVYHxIq4Im00jN6dglIs7u58gs
         +vwdJ8oTjsCEqPkuF+Z+9gYUsqoy4fv3cSbsA5B14QoJxXPvtl9y/x5LKblmoKXmTkUf
         riX0+kCTb9+B38qUN1rxIq/OREPPgcHloxlpCryxCJhUyj4inQJ6bZwuj6kMoY6eTB4z
         G+nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7Y00zfd8DDbnoqXnEtT/BAmJCh4hqgczSvdhA8/Nj/w=;
        b=gzTuGT50tZl1Yr25X4I1mPnsktLgHwlAsDOlC2wwTWKJoO6OWhx66NHvThr81c7Eqy
         yxXH+4XGEhxqVIEg5GDDxLMQh+kijecdBmOJHrGrVLbIkAw29WyzuIeH8Pu3Dk9Rv47A
         Ll6g882ESwXqLXOsZsOHkTIkXy4rPz4H/LdwB2eVd2paSZVQLckb4IGGa+atZciMfuIH
         CETI1pwXAyEhW5KMjz8upGXI7aKkPo6F96gQprXXO4NnUy9cY9COhLg47YekD7jl+pOa
         s6NvUDephHWsz02eITvpC/4mXprlamgfxRW4+YH/enTs7WKrn9gMx5QfCNLpy2KhE8HK
         baTw==
X-Gm-Message-State: ANhLgQ2Y+pwSgFTklWitzZS877ItX0jltPFoLBJoQ+Fhs0/uRXpi4onq
        Pxd7XF1YKdkcz5oUbwltZ09w4vNbVJ1Xppc/4ME=
X-Google-Smtp-Source: ADFU+vtQRf3C+fdMJf47yy7sqdjeyckxhzZiwfrKW65e6ATktdGWdQ/w6Dg+S0trpmrJHjrIlYjSBQct1SBCIRtQoBY=
X-Received: by 2002:a50:d5da:: with SMTP id g26mr7474061edj.179.1585486589915;
 Sun, 29 Mar 2020 05:56:29 -0700 (PDT)
MIME-Version: 1.0
References: <2f3ba828505cb3e8f9dc8a7b6c5a58a51a80cd90.1585445576.git.richardcochran@gmail.com>
In-Reply-To: <2f3ba828505cb3e8f9dc8a7b6c5a58a51a80cd90.1585445576.git.richardcochran@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 29 Mar 2020 15:56:18 +0300
Message-ID: <CA+h21hoXhGLE9vsTAqgv8+1UCa_yXsJ5OTGKTR5dOAj_RNFF1w@mail.gmail.com>
Subject: Re: [PATCH net-next 1/1] ptp: Avoid deadlocks in the programmable pin code.
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Yangbo Lu <yangbo.lu@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard,

On Sun, 29 Mar 2020 at 04:40, Richard Cochran <richardcochran@gmail.com> wrote:
>
> The PTP Hardware Clock (PHC) subsystem offers an API for configuring
> programmable pins.  User space sets or gets the settings using ioctls,
> and drivers verify dialed settings via a callback.  Drivers may also
> query pin settings by calling the ptp_find_pin() method.
>
> Although the core subsystem protects concurrent access to the pin
> settings, the implementation places illogical restrictions on how
> drivers may call ptp_find_pin().  When enabling an auxiliary function
> via the .enable(on=1) callback, drivers may invoke the pin finding
> method, but when disabling with .enable(on=0) drivers are not
> permitted to do so.  With the exception of the mv88e6xxx, all of the
> PHC drivers do respect this restriction, but still the locking pattern
> is both confusing and unnecessary.
>
> This patch changes the locking implementation to allow PHC drivers to
> freely call ptp_find_pin() from their .enable() and .verify()
> callbacks.
>
> Signed-off-by: Richard Cochran <richardcochran@gmail.com>
> Reported-by: Yangbo Lu <yangbo.lu@nxp.com>
> ---

I've tested this on top of Yangbo's patch, using this diff:

 drivers/ptp/ptp_ocelot.c | 49 +++++++++++++++++-----------------------
 1 file changed, 21 insertions(+), 28 deletions(-)

diff --git a/drivers/ptp/ptp_ocelot.c b/drivers/ptp/ptp_ocelot.c
index 299928e8691d..7d35ba262278 100644
--- a/drivers/ptp/ptp_ocelot.c
+++ b/drivers/ptp/ptp_ocelot.c
@@ -183,11 +183,9 @@ static int ocelot_ptp_enable(struct ptp_clock_info *ptp,
 {
     struct ocelot *ocelot = container_of(ptp, struct ocelot, ptp_info);
     enum ocelot_ptp_pins ptp_pin;
-    struct timespec64 ts;
     unsigned long flags;
     int pin = -1;
     u32 val;
-    s64 ns;

     switch (rq->type) {
     case PTP_CLK_REQ_PEROUT:
@@ -195,18 +193,6 @@ static int ocelot_ptp_enable(struct ptp_clock_info *ptp,
         if (rq->perout.flags)
             return -EOPNOTSUPP;

-        /*
-         * TODO: support disabling function
-         * When ptp_disable_pinfunc() is to disable function,
-         * it has already held pincfg_mux.
-         * However ptp_find_pin() in .enable() called also needs
-         * to hold pincfg_mux.
-         * This causes dead lock. So, just return for function
-         * disabling, and this needs fix-up.
-         */
-        if (!on)
-            break;
-
         pin = ptp_find_pin(ocelot->ptp_clock, PTP_PF_PEROUT,
                    rq->perout.index);
         if (pin == 0)
@@ -220,22 +206,29 @@ static int ocelot_ptp_enable(struct ptp_clock_info *ptp,
         else
             return -EINVAL;

-        ts.tv_sec = rq->perout.period.sec;
-        ts.tv_nsec = rq->perout.period.nsec;
-        ns = timespec64_to_ns(&ts);
-        ns = ns >> 1;
-        if (ns > 0x3fffffff || ns <= 0x6)
-            return -EINVAL;
-
         spin_lock_irqsave(&ocelot->ptp_clock_lock, flags);
-        ocelot_write_rix(ocelot, ns, PTP_PIN_WF_LOW_PERIOD, ptp_pin);
-        ocelot_write_rix(ocelot, ns, PTP_PIN_WF_HIGH_PERIOD, ptp_pin);
-
-        val = PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_CLOCK);
-        ocelot_write_rix(ocelot, val, PTP_PIN_CFG, ptp_pin);
+        if (on) {
+            struct timespec64 ts = {
+                .tv_sec = rq->perout.period.sec,
+                .tv_nsec = rq->perout.period.nsec,
+            };
+            s64 ns = timespec64_to_ns(&ts) >> 1;
+
+            if (ns > 0x3fffffff || ns <= 0x6)
+                return -EINVAL;
+
+            ocelot_write_rix(ocelot, ns, PTP_PIN_WF_LOW_PERIOD,
+                     ptp_pin);
+            ocelot_write_rix(ocelot, ns, PTP_PIN_WF_HIGH_PERIOD,
+                     ptp_pin);
+
+            val = PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_CLOCK);
+            ocelot_write_rix(ocelot, val, PTP_PIN_CFG, ptp_pin);
+        } else {
+            val = PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_IDLE);
+            ocelot_write_rix(ocelot, val, PTP_PIN_CFG, ptp_pin);
+        }
         spin_unlock_irqrestore(&ocelot->ptp_clock_lock, flags);
-        dev_warn(ocelot->dev,
-             "Starting periodic signal now! (absolute start time not
supported)\n");
         break;
     default:
         return -EOPNOTSUPP;
-- 
2.17.1

So you can add my

Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

A few comments below, you may feel free to ignore them.

>  drivers/net/phy/dp83640.c        |  2 +-
>  drivers/ptp/ptp_chardev.c        |  9 +++++++++
>  drivers/ptp/ptp_clock.c          | 17 +++++++++++++++--
>  include/linux/ptp_clock_kernel.h | 19 +++++++++++++++++++
>  4 files changed, 44 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
> index ac72a324fcd1..415c27310982 100644
> --- a/drivers/net/phy/dp83640.c
> +++ b/drivers/net/phy/dp83640.c
> @@ -628,7 +628,7 @@ static void recalibrate(struct dp83640_clock *clock)
>         u16 cal_gpio, cfg0, evnt, ptp_trig, trigger, val;
>
>         trigger = CAL_TRIGGER;
> -       cal_gpio = 1 + ptp_find_pin(clock->ptp_clock, PTP_PF_PHYSYNC, 0);
> +       cal_gpio = 1 + ptp_find_pin_unlocked(clock->ptp_clock, PTP_PF_PHYSYNC, 0);
>         if (cal_gpio < 1) {
>                 pr_err("PHY calibration pin not available - PHY is not calibrated.");
>                 return;
> diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
> index 9d72ab593f13..93d574faf1fe 100644
> --- a/drivers/ptp/ptp_chardev.c
> +++ b/drivers/ptp/ptp_chardev.c
> @@ -175,7 +175,10 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
>                 }
>                 req.type = PTP_CLK_REQ_EXTTS;
>                 enable = req.extts.flags & PTP_ENABLE_FEATURE ? 1 : 0;
> +               if (mutex_lock_interruptible(&ptp->pincfg_mux))
> +                       return -ERESTARTSYS;

Is there any reason why you're not just propagating the return value
of mutex_lock_interruptible?

>                 err = ops->enable(ops, &req, enable);
> +               mutex_unlock(&ptp->pincfg_mux);
>                 break;
>
>         case PTP_PEROUT_REQUEST:
> @@ -206,7 +209,10 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
>                 }
>                 req.type = PTP_CLK_REQ_PEROUT;
>                 enable = req.perout.period.sec || req.perout.period.nsec;
> +               if (mutex_lock_interruptible(&ptp->pincfg_mux))
> +                       return -ERESTARTSYS;
>                 err = ops->enable(ops, &req, enable);
> +               mutex_unlock(&ptp->pincfg_mux);
>                 break;
>
>         case PTP_ENABLE_PPS:
> @@ -217,7 +223,10 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
>                         return -EPERM;
>                 req.type = PTP_CLK_REQ_PPS;
>                 enable = arg ? 1 : 0;
> +               if (mutex_lock_interruptible(&ptp->pincfg_mux))
> +                       return -ERESTARTSYS;
>                 err = ops->enable(ops, &req, enable);
> +               mutex_unlock(&ptp->pincfg_mux);
>                 break;
>
>         case PTP_SYS_OFFSET_PRECISE:
> diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
> index ac1f2bf9e888..acabbe72e55e 100644
> --- a/drivers/ptp/ptp_clock.c
> +++ b/drivers/ptp/ptp_clock.c
> @@ -348,7 +348,6 @@ int ptp_find_pin(struct ptp_clock *ptp,
>         struct ptp_pin_desc *pin = NULL;
>         int i;
>
> -       mutex_lock(&ptp->pincfg_mux);
>         for (i = 0; i < ptp->info->n_pins; i++) {
>                 if (ptp->info->pin_config[i].func == func &&
>                     ptp->info->pin_config[i].chan == chan) {
> @@ -356,12 +355,26 @@ int ptp_find_pin(struct ptp_clock *ptp,
>                         break;
>                 }
>         }
> -       mutex_unlock(&ptp->pincfg_mux);
>
>         return pin ? i : -1;
>  }
>  EXPORT_SYMBOL(ptp_find_pin);
>
> +int ptp_find_pin_unlocked(struct ptp_clock *ptp,
> +                         enum ptp_pin_function func, unsigned int chan)
> +{
> +       int result;
> +
> +       mutex_lock(&ptp->pincfg_mux);
> +
> +       result = ptp_find_pin(ptp, func, chan);
> +
> +       mutex_unlock(&ptp->pincfg_mux);
> +
> +       return result;
> +}
> +EXPORT_SYMBOL(ptp_find_pin_unlocked);
> +
>  int ptp_schedule_worker(struct ptp_clock *ptp, unsigned long delay)
>  {
>         return kthread_mod_delayed_work(ptp->kworker, &ptp->aux_work, delay);
> diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
> index c64a1ef87240..114807e7abdd 100644
> --- a/include/linux/ptp_clock_kernel.h
> +++ b/include/linux/ptp_clock_kernel.h
> @@ -223,6 +223,12 @@ extern s32 scaled_ppm_to_ppb(long ppm);
>  /**
>   * ptp_find_pin() - obtain the pin index of a given auxiliary function
>   *
> + * The caller must hold ptp_clock::pincfg_mux.  Drivers do not have
> + * access to that mutex as ptp_clock is an opaque type.  However, the
> + * core code acquires the mutex before invoking the driver's
> + * ptp_clock_info::enable() callback, and so drivers may call this
> + * function from that context.
> + *
>   * @ptp:    The clock obtained from ptp_clock_register().
>   * @func:   One of the ptp_pin_function enumerated values.
>   * @chan:   The particular functional channel to find.
> @@ -233,6 +239,19 @@ extern s32 scaled_ppm_to_ppb(long ppm);
>  int ptp_find_pin(struct ptp_clock *ptp,
>                  enum ptp_pin_function func, unsigned int chan);
>
> +/**
> + * ptp_find_pin_unlocked() - wrapper for ptp_find_pin()
> + *
> + * This function aquires the ptp_clock::pincfg_mux mutex before

nit: acquires


> + * invoking ptp_find_pin().  Instead of using this function, drivers
> + * should most likely call ptp_find_pin() directly from their
> + * ptp_clock_info::enable() method.
> + *
> + */
> +
> +int ptp_find_pin_unlocked(struct ptp_clock *ptp,
> +                         enum ptp_pin_function func, unsigned int chan);
> +
>  /**
>   * ptp_schedule_worker() - schedule ptp auxiliary work
>   *
> --
> 2.20.1
>

Regards,
-Vladimir
