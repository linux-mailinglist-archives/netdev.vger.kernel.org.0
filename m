Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB43513A89
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 18:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350407AbiD1RBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 13:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235928AbiD1RBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 13:01:11 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7208BB6D27;
        Thu, 28 Apr 2022 09:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1651164963;
        bh=DUb16bHT8ZVVcSBzzE8lnieko2RHZpG2zbwsEWdWo2c=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=TrwFfhoA2P1jqiZSh6qbThQbWQ3kajZ2U+JQrRL/jSZxckwFV1BopRKv6DRaeQSKC
         DM8QpY2fv9fsoSq055uYb4MCMz8e9HvG+guo2m9xr29cJoYbxYguo2PwZIKFp/JXdB
         qy9XbYXMKcmj9vbKxczpPpGqEow6LzKi+qj1B+ao=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.20.60] ([92.116.133.159]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MzyuS-1o6TNU3b1S-00x2R3; Thu, 28
 Apr 2022 18:56:03 +0200
Message-ID: <6a7c924a-54a9-c5ea-8a9d-3ea92987b436@gmx.de>
Date:   Thu, 28 Apr 2022 18:55:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 12/30] parisc: Replace regular spinlock with spin_trylock
 on panic path
Content-Language: en-US
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
        kexec@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, coresight@lists.linaro.org,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-um@lists.infradead.org, linux-xtensa@linux-xtensa.org,
        netdev@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
        rcu@vger.kernel.org, sparclinux@vger.kernel.org,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        kernel-dev@igalia.com, kernel@gpiccoli.net, halves@canonical.com,
        fabiomirmar@gmail.com, alejandro.j.jimenez@oracle.com,
        andriy.shevchenko@linux.intel.com, arnd@arndb.de, bp@alien8.de,
        corbet@lwn.net, d.hatayama@jp.fujitsu.com,
        dave.hansen@linux.intel.com, dyoung@redhat.com,
        feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-13-gpiccoli@igalia.com>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <20220427224924.592546-13-gpiccoli@igalia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:5vdTXh07+igNuefls5XBW8Vnc+iEgtAi7WYk6EGDKuqY95FwGMe
 QwcWZKzUaEoh4UB+55vjZve/tYEaItgGsgQfOqHuHHkvtwYyxsf6YShgZsftQKYSmO6WQ+T
 ZC1GiQE33MbntUGomNddrKZxDF5sJxGJRqGlvPVNWYXBnGaRnQV/WvjdEKXY9QfAk5iDfpf
 2SF7pYcym4psStLDUUMNQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:seIPaj7dpZM=:yycTg0fvdDhrITiv3IZXzI
 e4yFHTYHbrGUy0XcNvNSnWURkRH0CwdNhQ3CWNfifJgMcKrsF971kE1ZPU9NMQWdlbTy3YHHQ
 kdbLaclaoLvW+e4KLLE5yocf48/EeAYglXhY84PxWcp1QGdF7y7nXLElZka6kp2R0F8+61JyB
 loph7JvlvHMoA0h4saDhDgOi28CBTeWf2mZxC+/EkMY8v85s5wN3/znVOlOIi2kLzQZEdEUxg
 qZqRAEH0zpZWVc5jenddLnwtNUslbH1ysbnT6Jz+8m3SINHv4Rwqo8qzXPYlIEhtABEOB2CCo
 zGH68oxcPKpqrqbFPSUrvmevYIsFthSN4Qa4ESwcyflnmJb/H2yYOm3idKBPcHZoAc7MXpKFp
 RR3P6Q1355mAy9N9Htg1IQRALV21oxx1PunXwbHOYiOH77jvrab76cf+pliKkaIi4EdHQpQqw
 9mxPXAGH7PZiMiQ7xVCBiONFGbdiXxNWW9WgP8A6pz6E89Sx90IwrTRc9D73bLfwpGwDmjWxi
 fFfVa4k8dmCqUPhBM1VhxPpxNRnj9QzEWrSQ0xThSfPtnfKEaiZ6CAhESljw6d2UOOHcDSLiC
 pYk2Il0xe7DktL7r83T2I0B8fYcU06QnK7MXlbmtGkMbQFBGucQc+IB7UEgTcN0uT8ZaS6/FI
 jkfGMBIY2eSkyrlErzq+vnajUsa0b9zENmsHS55RE7h43gLxmwE2UNFRUH8bWmdFhfJcUWhCo
 0TAcvRyne9VEKfs0HrQjTEdgbmSa875UQ1egzran3Xhi4XGH8Atz9id4q//uvXHDPEYGUcpM1
 1jCttDZecf4rq/B12RMkoMxP6zY3FZKwK7quDBpUSTid+jJEDxaXtx0XaeJ0Hg0rDMgviRyZ9
 HzUcPocKiz/LqCSxQKJ+5LacyVgyzC2Eg/QV5UE+RmBe/a0+mK1ccbKXN/YmWVo5xcoOe11r/
 LQC+womcGp8ubOddU8soGYLdecjhj+rpnt5TdzsPY9fawi7HlwarnA+ConVoG4a/SWDHYon/e
 QtxJhYG5A/NQ3aDfGGrPKFQkR4D9mAqQmSL7oHO9wv65NzEickiapaFqe4ZYqD4oBbohP/rOw
 OHyJm5CjSYyJJQ=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/28/22 00:49, Guilherme G. Piccoli wrote:
> The panic notifiers' callbacks execute in an atomic context, with
> interrupts/preemption disabled, and all CPUs not running the panic
> function are off, so it's very dangerous to wait on a regular
> spinlock, there's a risk of deadlock.
>
> This patch refactors the panic notifier of parisc/power driver
> to make use of spin_trylock - for that, we've added a second
> version of the soft-power function. Also, some comments were
> reorganized and trailing white spaces, useless header inclusion
> and blank lines were removed.
>
> Cc: Helge Deller <deller@gmx.de>
> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>

You may add:
Acked-by: Helge Deller <deller@gmx.de> # parisc

Helge


> ---
>  arch/parisc/include/asm/pdc.h |  1 +
>  arch/parisc/kernel/firmware.c | 27 +++++++++++++++++++++++----
>  drivers/parisc/power.c        | 17 ++++++++++-------
>  3 files changed, 34 insertions(+), 11 deletions(-)
>
> diff --git a/arch/parisc/include/asm/pdc.h b/arch/parisc/include/asm/pdc=
.h
> index b643092d4b98..7a106008e258 100644
> --- a/arch/parisc/include/asm/pdc.h
> +++ b/arch/parisc/include/asm/pdc.h
> @@ -83,6 +83,7 @@ int pdc_do_firm_test_reset(unsigned long ftc_bitmap);
>  int pdc_do_reset(void);
>  int pdc_soft_power_info(unsigned long *power_reg);
>  int pdc_soft_power_button(int sw_control);
> +int pdc_soft_power_button_panic(int sw_control);
>  void pdc_io_reset(void);
>  void pdc_io_reset_devices(void);
>  int pdc_iodc_getc(void);
> diff --git a/arch/parisc/kernel/firmware.c b/arch/parisc/kernel/firmware=
.c
> index 6a7e315bcc2e..0e2f70b592f4 100644
> --- a/arch/parisc/kernel/firmware.c
> +++ b/arch/parisc/kernel/firmware.c
> @@ -1232,15 +1232,18 @@ int __init pdc_soft_power_info(unsigned long *po=
wer_reg)
>  }
>
>  /*
> - * pdc_soft_power_button - Control the soft power button behaviour
> - * @sw_control: 0 for hardware control, 1 for software control
> + * pdc_soft_power_button{_panic} - Control the soft power button behavi=
our
> + * @sw_control: 0 for hardware control, 1 for software control
>   *
>   *
>   * This PDC function places the soft power button under software or
>   * hardware control.
> - * Under software control the OS may control to when to allow to shut
> - * down the system. Under hardware control pressing the power button
> + * Under software control the OS may control to when to allow to shut
> + * down the system. Under hardware control pressing the power button
>   * powers off the system immediately.
> + *
> + * The _panic version relies in spin_trylock to prevent deadlock
> + * on panic path.
>   */
>  int pdc_soft_power_button(int sw_control)
>  {
> @@ -1254,6 +1257,22 @@ int pdc_soft_power_button(int sw_control)
>  	return retval;
>  }
>
> +int pdc_soft_power_button_panic(int sw_control)
> +{
> +	int retval;
> +	unsigned long flags;
> +
> +	if (!spin_trylock_irqsave(&pdc_lock, flags)) {
> +		pr_emerg("Couldn't enable soft power button\n");
> +		return -EBUSY; /* ignored by the panic notifier */
> +	}
> +
> +	retval =3D mem_pdc_call(PDC_SOFT_POWER, PDC_SOFT_POWER_ENABLE, __pa(pd=
c_result), sw_control);
> +	spin_unlock_irqrestore(&pdc_lock, flags);
> +
> +	return retval;
> +}
> +
>  /*
>   * pdc_io_reset - Hack to avoid overlapping range registers of Bridges =
devices.
>   * Primarily a problem on T600 (which parisc-linux doesn't support) but
> diff --git a/drivers/parisc/power.c b/drivers/parisc/power.c
> index 456776bd8ee6..8512884de2cf 100644
> --- a/drivers/parisc/power.c
> +++ b/drivers/parisc/power.c
> @@ -37,7 +37,6 @@
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/kernel.h>
> -#include <linux/notifier.h>
>  #include <linux/panic_notifier.h>
>  #include <linux/reboot.h>
>  #include <linux/sched/signal.h>
> @@ -175,16 +174,21 @@ static void powerfail_interrupt(int code, void *x)
>
>
>
> -/* parisc_panic_event() is called by the panic handler.
> - * As soon as a panic occurs, our tasklets above will not be
> - * executed any longer. This function then re-enables the
> - * soft-power switch and allows the user to switch off the system
> +/*
> + * parisc_panic_event() is called by the panic handler.
> + *
> + * As soon as a panic occurs, our tasklets above will not
> + * be executed any longer. This function then re-enables
> + * the soft-power switch and allows the user to switch off
> + * the system. We rely in pdc_soft_power_button_panic()
> + * since this version spin_trylocks (instead of regular
> + * spinlock), preventing deadlocks on panic path.
>   */
>  static int parisc_panic_event(struct notifier_block *this,
>  		unsigned long event, void *ptr)
>  {
>  	/* re-enable the soft-power switch */
> -	pdc_soft_power_button(0);
> +	pdc_soft_power_button_panic(0);
>  	return NOTIFY_DONE;
>  }
>
> @@ -193,7 +197,6 @@ static struct notifier_block parisc_panic_block =3D =
{
>  	.priority	=3D INT_MAX,
>  };
>
> -
>  static int __init power_init(void)
>  {
>  	unsigned long ret;

