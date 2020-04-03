Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0CCF19D606
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 13:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390835AbgDCLr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 07:47:59 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:39785 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728012AbgDCLr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 07:47:58 -0400
Received: by mail-ot1-f68.google.com with SMTP id x11so6929514otp.6;
        Fri, 03 Apr 2020 04:47:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WLQ125LqNkhbday+yt6StLeA1O5IE8GF+ApE3jgSAcg=;
        b=rQs0NV8OTSUXb96TmIvFGL+/+NqlS/rrWZsYgECNM/41R1XtWV97jCwDR1QzOppTAz
         p44La1xeHWKbI02xOWOsUDQKikHzlfw6sQo7Vwl6YptAmZ/ZDtIb3falhBRRi1YDuglP
         ImbzgP/vryARF8i77i0sCqdS1C9SrfR9cq93iGemuTDJkE7TsVWS5mFU8UBrU6TieBVU
         5dtx/N7MzDJrubCfdA9roI9EZecGiMkOhNGDnTJ+8D8Gr+8DgZvpfPWGQ8//O1xc7uUG
         5NVHOXka+OAVONRRdTwzN9ZXtd3AvfLiFas1ZsMif9vnp4RjFprcsJWHmuJyvinRXEGW
         bBEw==
X-Gm-Message-State: AGi0PubT7+YkNOobNGoBZBNf2jqf3cnCTUYi62ZygZpzcsjJHXdPCQIi
        9NTg041Czyh2g9ghk+zMvdffFx8obtrpBRs2PA4=
X-Google-Smtp-Source: APiQypIQnT36feP1REJN0BpBj//TWYHjNINlgwaxwuafaHrbCiASiBVronQFLnu7NrC4WBQhkb3N9W8X9h1DOwvWbJ4=
X-Received: by 2002:a4a:a442:: with SMTP id w2mr6218727ool.90.1585914478184;
 Fri, 03 Apr 2020 04:47:58 -0700 (PDT)
MIME-Version: 1.0
References: <TYAPR01MB45443DF63B9EF29054F7C41FD8C60@TYAPR01MB4544.jpnprd01.prod.outlook.com>
 <CALAqxLWopjCkiM=NR868DTcX-apPc1MPnONJMppm1jzCboAheg@mail.gmail.com>
In-Reply-To: <CALAqxLWopjCkiM=NR868DTcX-apPc1MPnONJMppm1jzCboAheg@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 3 Apr 2020 13:47:46 +0200
Message-ID: <CAMuHMdVtHhq9Nef1pBtBUKfRU2L-KgDffiOv28VqhrewR_j1Dw@mail.gmail.com>
Subject: Re: How to fix WARN from drivers/base/dd.c in next-20200401 if CONFIG_MODULES=y?
To:     John Stultz <john.stultz@linaro.org>
Cc:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi John,

On Thu, Apr 2, 2020 at 7:27 PM John Stultz <john.stultz@linaro.org> wrote:
> On Thu, Apr 2, 2020 at 3:17 AM Yoshihiro Shimoda
> <yoshihiro.shimoda.uh@renesas.com> wrote:
> >
> > I found an issue after applied the following patches:
> > ---
> > 64c775f driver core: Rename deferred_probe_timeout and make it global
> > 0e9f8d0 driver core: Remove driver_deferred_probe_check_state_continue()
> > bec6c0e pinctrl: Remove use of driver_deferred_probe_check_state_continue()
> > e2cec7d driver core: Set deferred_probe_timeout to a longer default if CONFIG_MODULES is set

Note that just setting deferred_probe_timeout = -1 like for the
CONFIG_MODULES=n case doesn't help.

> > c8c43ce driver core: Fix driver_deferred_probe_check_state() logic
> > ---
> >
> > Before these patches, on my environment [1], some device drivers
> > which has iommus property output the following message when probing:
> >
> > [    3.222205] ravb e6800000.ethernet: ignoring dependency for device, assuming no driver
> > [    3.257174] ravb e6800000.ethernet eth0: Base address at 0xe6800000, 2e:09:0a:02:eb:2d, IRQ 117.
> >
> > So, since ravb driver is probed within 4 seconds, we can use NFS rootfs correctly.
> >
> > However, after these patches are applied, since the patches are always waiting for 30 seconds
> > for of_iommu_configure() when IOMMU hardware is disabled, drivers/base/dd.c output WARN.
> > Also, since ravb cannot be probed for 30 seconds, we cannot use NFS rootfs anymore.
> > JFYI, I copied the kernel log to the end of this email.
>
> Hey,
>   Terribly sorry for the trouble. So as Robin mentioned I have a patch
> to remove the WARN messages, but I'm a bit more concerned about why
> after the 30 second delay, the ethernet driver loads:
>   [   36.218666] ravb e6800000.ethernet eth0: Base address at
> 0xe6800000, 2e:09:0a:02:eb:2d, IRQ 117.
> but NFS fails.
>
> Is it just that the 30 second delay is too long and NFS gives up?

I added some debug code to mount_nfs_root(), which shows that the first
3 tries happen before ravb is instantiated, and the last 3 tries happen
after.  So NFS root should work, if the network works.

However, it seems the Ethernet PHY is never initialized, hence the link
never becomes ready.  Dmesg before/after:

     ravb e6800000.ethernet eth0: Base address at 0xe6800000,
2e:09:0a:02:ea:ff, IRQ 108.

Good.

     ...
    -gpio_rcar e6052000.gpio: sense irq = 11, type = 8

This is the GPIO the PHY IRQ is connected to.
Note that that GPIO controller has been instantiated before.

     ...
    -Micrel KSZ9031 Gigabit PHY e6800000.ethernet-ffffffff:00:
attached PHY driver [Micrel KSZ9031 Gigabit PHY]
(mii_bus:phy_addr=e6800000.ethernet-ffffffff:00, irq=197)
     ...
    -ravb e6800000.ethernet eth0: Link is Up - 1Gbps/Full - flow control off

Oops.

    -Sending DHCP requests .., OK
    -IP-Config: Got DHCP answer from ...
     ...
    +VFS: Unable to mount root fs via NFS, trying floppy.
    +VFS: Cannot open root device "nfs" or unknown-block(2,0): error -6

> Does booting with deferred_probe_timeout=0 work?

It does, as now everything using optional links (DMA and IOMMU) is now
instantiated on first try.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
