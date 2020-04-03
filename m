Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A481719D728
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 15:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403784AbgDCNGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 09:06:07 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:37527 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390770AbgDCNGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 09:06:06 -0400
Received: by mail-oi1-f193.google.com with SMTP id u20so6008118oic.4;
        Fri, 03 Apr 2020 06:06:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OqCaoyULkRti7vSZNQ9Yg7YDSRokCroTLEsyV92N24k=;
        b=OmbUxeIhGY4opoqn9d9LWfXToCy+ltbUdYO0sVVfaSeUwJIJuOzt2diGU761XLuxb0
         dZGyhoU88hzLYkcFt4Eio5fbuSdcJ1Dshn5UzKojF7e9YYwxDyjl5NtWh4iNPDVE6SQA
         0w8C606Joa/UTGbUm2n4PgCGn6jmfSy0IArVvx12wqjRMvfSAprtVVjTcp/Z3Bsp2NWq
         F7XH+VGHt92D7W28qFML7SryeNI73CdEsr4EyTEN1B+tgEgwdv3Rk5GM7ZPtrO6E98Wy
         3HBUiP/05DJ5sTtdJhnGYjO+P98nOvWf7gpsWJdPKoh4qkKn7og2SMAboe2kkUqgnNna
         2ocA==
X-Gm-Message-State: AGi0PubVoXxlHnNkddumsv+OgfpZ+28n2QcgM84c3lMlMYkRdWJ4jc1y
        dIwSGZ8/Xi6donLWn8CEZ4rlBfZqmQfZwKzLURvcikYl
X-Google-Smtp-Source: APiQypLi6mhOGXOuNWGE5LKpAmZQ+POe3LwGn5mnAx7luDfu0zthSY9F3kKpkDv+5OX3zFZqkIIqtWChzdEZhSWTxfY=
X-Received: by 2002:aca:ad93:: with SMTP id w141mr2963325oie.54.1585919165884;
 Fri, 03 Apr 2020 06:06:05 -0700 (PDT)
MIME-Version: 1.0
References: <TYAPR01MB45443DF63B9EF29054F7C41FD8C60@TYAPR01MB4544.jpnprd01.prod.outlook.com>
 <CALAqxLWopjCkiM=NR868DTcX-apPc1MPnONJMppm1jzCboAheg@mail.gmail.com> <CAMuHMdVtHhq9Nef1pBtBUKfRU2L-KgDffiOv28VqhrewR_j1Dw@mail.gmail.com>
In-Reply-To: <CAMuHMdVtHhq9Nef1pBtBUKfRU2L-KgDffiOv28VqhrewR_j1Dw@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 3 Apr 2020 15:05:54 +0200
Message-ID: <CAMuHMdXotufr5Hq39O2MsLtwAHK0v34OYbaxYOV21rYrdBD=kw@mail.gmail.com>
Subject: Re: How to fix WARN from drivers/base/dd.c in next-20200401 if CONFIG_MODULES=y?
To:     John Stultz <john.stultz@linaro.org>
Cc:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi John,

On Fri, Apr 3, 2020 at 1:47 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Thu, Apr 2, 2020 at 7:27 PM John Stultz <john.stultz@linaro.org> wrote:
> > On Thu, Apr 2, 2020 at 3:17 AM Yoshihiro Shimoda
> > <yoshihiro.shimoda.uh@renesas.com> wrote:
> > >
> > > I found an issue after applied the following patches:
> > > ---
> > > 64c775f driver core: Rename deferred_probe_timeout and make it global
> > > 0e9f8d0 driver core: Remove driver_deferred_probe_check_state_continue()
> > > bec6c0e pinctrl: Remove use of driver_deferred_probe_check_state_continue()
> > > e2cec7d driver core: Set deferred_probe_timeout to a longer default if CONFIG_MODULES is set
>
> Note that just setting deferred_probe_timeout = -1 like for the
> CONFIG_MODULES=n case doesn't help.
>
> > > c8c43ce driver core: Fix driver_deferred_probe_check_state() logic
> > > ---
> > >
> > > Before these patches, on my environment [1], some device drivers
> > > which has iommus property output the following message when probing:
> > >
> > > [    3.222205] ravb e6800000.ethernet: ignoring dependency for device, assuming no driver
> > > [    3.257174] ravb e6800000.ethernet eth0: Base address at 0xe6800000, 2e:09:0a:02:eb:2d, IRQ 117.
> > >
> > > So, since ravb driver is probed within 4 seconds, we can use NFS rootfs correctly.
> > >
> > > However, after these patches are applied, since the patches are always waiting for 30 seconds
> > > for of_iommu_configure() when IOMMU hardware is disabled, drivers/base/dd.c output WARN.
> > > Also, since ravb cannot be probed for 30 seconds, we cannot use NFS rootfs anymore.
> > > JFYI, I copied the kernel log to the end of this email.
> >
> > Hey,
> >   Terribly sorry for the trouble. So as Robin mentioned I have a patch
> > to remove the WARN messages, but I'm a bit more concerned about why
> > after the 30 second delay, the ethernet driver loads:
> >   [   36.218666] ravb e6800000.ethernet eth0: Base address at
> > 0xe6800000, 2e:09:0a:02:eb:2d, IRQ 117.
> > but NFS fails.
> >
> > Is it just that the 30 second delay is too long and NFS gives up?
>
> I added some debug code to mount_nfs_root(), which shows that the first
> 3 tries happen before ravb is instantiated, and the last 3 tries happen
> after.  So NFS root should work, if the network works.
>
> However, it seems the Ethernet PHY is never initialized, hence the link
> never becomes ready.

So the issue is not nfsroot in-se, but the ip-config that needs to
happen before that.

The call to wait_for_devices() in ip_auto_config() (which is a
late_initcall()) returns -ENODEV, as the network device hasn't probed
successfully yet, so ip-config is aborted.

The (whitespace-damaged) patch below fixes that, but may have unintended
side-effects.

--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -1469,7 +1469,11 @@ static int __init ip_auto_config(void)
        /* Wait for devices to appear */
        err = wait_for_devices();
        if (err)
+#ifdef IPCONFIG_DYNAMIC
+               goto try_try_again;
+#else
                return err;
+#endif

        /* Setup all network devices */
        err = ic_open_devs();

Probably we want at least some CONFIG_ROOT_NFS || CONFIG_CIFS_ROOT,
and ROOT_DEV == Root_NFS || ROOT_DEV == Root_CIFS checks.

Thanks for your comments!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
