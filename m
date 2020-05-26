Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15BAB1E1D70
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 10:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731555AbgEZIhu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 26 May 2020 04:37:50 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:40832 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbgEZIhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 04:37:50 -0400
Received: by mail-ot1-f66.google.com with SMTP id d26so15621702otc.7;
        Tue, 26 May 2020 01:37:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RHXgtuB1SAqLX2SMugvAUZcluD7absnJHKc68BKyHlE=;
        b=grQNmI1zEy6kOUUZz44tbb6NYebIAISHtLfet0b4vGMCVvnMvTbW5e77TrO7nj4fLT
         GogvpCZGKgeLJ6nysmy+WSAb8Zrs3FyDhoRMkgxQZU1yOJXiNfQenT/jvBoqP32AYYEJ
         Bf981m424nyI+Sv250UGR8ebTASlZMxr3C6Xnyy31Zexgs4lwgmOlu3WmenOkCn4bUss
         u68GlsRFVaX6OPnQrh839fK4NNIqUYA9fgmLNUW3uxklVZ03mpPGokC0oMD24MDobKUK
         8oY79o9WA3UPx94WK0tMFjpxe1irKep2U3n7msCY2yJuY7n/js1HfXOl3m8O0uEYpS9F
         xB2A==
X-Gm-Message-State: AOAM5336/KsSkYIg+O+RdGS2ZYanxKjcW81AIF9xEXnvI9/qW11nD8cA
        PahwVdEqx+/SMcr2gxORyTl/yiv6PKFsarBBQls=
X-Google-Smtp-Source: ABdhPJy0XoZJ2esVX8+4wcFLlF6um9NLvGAJ5fc2t1hUUEHZCOGJRTRLWSbAKm+GZYwEumVFNBb3ARUgbj71FBUSPrI=
X-Received: by 2002:a9d:6c0f:: with SMTP id f15mr92375otq.118.1590482268905;
 Tue, 26 May 2020 01:37:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200525182608.1823735-1-kw@linux.com> <20200525182608.1823735-3-kw@linux.com>
In-Reply-To: <20200525182608.1823735-3-kw@linux.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 26 May 2020 10:37:36 +0200
Message-ID: <CAJZ5v0jQUmdDYmJsP43Ja3urpVLUxe-yD_Hm_Jd2LtCoPiXsrQ@mail.gmail.com>
Subject: Re: [PATCH 2/8] ACPI: PM: Use the new device_to_pm() helper to access
 struct dev_pm_ops
To:     =?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kw@linux.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hovold <johan@kernel.org>, Alex Elder <elder@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Felipe Balbi <balbi@kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        greybus-dev@lists.linaro.org, netdev <netdev@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        linux-s390@vger.kernel.org,
        "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>,
        "open list:ULTRA-WIDEBAND (UWB) SUBSYSTEM:" 
        <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 25, 2020 at 8:26 PM Krzysztof Wilczyński <kw@linux.com> wrote:
>
> Use the new device_to_pm() helper to access Power Management callbacs
> (struct dev_pm_ops) for a particular device (struct device_driver).
>
> No functional change intended.
>
> Signed-off-by: Krzysztof Wilczyński <kw@linux.com>
> ---
>  drivers/acpi/device_pm.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/acpi/device_pm.c b/drivers/acpi/device_pm.c
> index 5832bc10aca8..b98a32c48fbe 100644
> --- a/drivers/acpi/device_pm.c
> +++ b/drivers/acpi/device_pm.c
> @@ -1022,9 +1022,10 @@ static bool acpi_dev_needs_resume(struct device *dev, struct acpi_device *adev)
>  int acpi_subsys_prepare(struct device *dev)
>  {
>         struct acpi_device *adev = ACPI_COMPANION(dev);
> +       const struct dev_pm_ops *pm = driver_to_pm(dev->driver);

I don't really see a reason for this change.

What's wrong with the check below?

>
> -       if (dev->driver && dev->driver->pm && dev->driver->pm->prepare) {
> -               int ret = dev->driver->pm->prepare(dev);
> +       if (pm && pm->prepare) {
> +               int ret = pm->prepare(dev);
>
>                 if (ret < 0)
>                         return ret;
> --
> 2.26.2
>
