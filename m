Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A67EA253A5B
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 00:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgHZWsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 18:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbgHZWsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 18:48:20 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C96A2C061757
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 15:48:19 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id i129so1843829vsi.3
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 15:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i1qY92/PwTT0Gk/j2QImlQ1lTtyrii53vnwrnB6jcwg=;
        b=Kr78kDPV8rShI6VR1rKATyA8p91nltiq2JBgff3egxahVAx6vOdWahUWS7PaMDogy/
         U11DctEM0UVzdLpxGP31NOt+20skpFztsz7sBCX9vRNcPO+pIcgjNKmGR5S6Y4xHdRnI
         jpW1+OvpxWraR3wlY+RVYtZkR4YJCAeaW/7Ok=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i1qY92/PwTT0Gk/j2QImlQ1lTtyrii53vnwrnB6jcwg=;
        b=O8yQV1cXIYq5U9X96PE7RIe2Fl0fTPhSzKHyZUYFTmQr09c8QbKdAIX9NEUYjAxCvi
         crDp8Kg/EDIS4u3XeXFgjIzaCYXSr4s30Og8mHG6rdsPuQsYWWb4ILNntpdd/hg/6E5L
         I/O7QX93j/hDvu52RWr6OkMrkrryTM0o8j42BiD3LNGqjnK+IHUUwLuJsZ8oEa120XjS
         dzzBA/iqJHJsTP0KXfU/z4JnmnZgwowEtAyAxRnfjmkJ0uqcKmo4S1pkGEVgI7NXPsE1
         sGvCYKx89oYJjpU8pO4E32axMFP05raF3d3I+5+9SWuf1tYs0NlSaJfXR8xv7kgzy92j
         cIGg==
X-Gm-Message-State: AOAM532pEzZnb8i69f8525TWawi1Cm1f5fQqRsF8o6IP+SERvnESvNFn
        w37PF2HLX6EQkPEcbKGaI1q5QWWzSH7pm0WrPRnJSw==
X-Google-Smtp-Source: ABdhPJxdEd1ugfMHWrcNXgWBRatmklOZ31zN9s8sOVMobrAoeawvvRQ8HIDcXT6WLyulfcLzFc+J1AjPuMxMw3XLbS0=
X-Received: by 2002:a05:6102:2042:: with SMTP id q2mr7894641vsr.209.1598482099029;
 Wed, 26 Aug 2020 15:48:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200826152623.1.I24fb6cc377d03d64d74f83cec748afd12ee33e37@changeid>
In-Reply-To: <20200826152623.1.I24fb6cc377d03d64d74f83cec748afd12ee33e37@changeid>
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Date:   Wed, 26 Aug 2020 15:48:05 -0700
Message-ID: <CANFp7mVR5mWpTNOCzVqma5dL26nWLFCYRL9xBpE72ywpj8yo1Q@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Clear suspend tasks on unregister
To:     Marcel Holtmann <marcel@holtmann.org>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>
Cc:     ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please disregard this earlier email without the Fixes tag.

On Wed, Aug 26, 2020 at 3:26 PM Abhishek Pandit-Subedi
<abhishekpandit@chromium.org> wrote:
>
> While unregistering, make sure to clear the suspend tasks before
> cancelling the work. If the unregister is called during resume from
> suspend, this will unnecessarily add 2s to the resume time otherwise.
>
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> ---
> This was discovered with RT8822CE using the btusb driver. This chipset
> will reset on resume during system suspend and was unnecessarily adding
> 2s to every resume. Since we're unregistering anyway, there's no harm in
> just clearing the pending events.
>
>  net/bluetooth/hci_core.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index 68bfe57b66250f..ed4cb3479433c0 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -3442,6 +3442,16 @@ void hci_copy_identity_address(struct hci_dev *hdev, bdaddr_t *bdaddr,
>         }
>  }
>
> +static void hci_suspend_clear_tasks(struct hci_dev *hdev)
> +{
> +       int i;
> +
> +       for (i = 0; i < __SUSPEND_NUM_TASKS; ++i)
> +               clear_bit(i, hdev->suspend_tasks);
> +
> +       wake_up(&hdev->suspend_wait_q);
> +}
> +
>  static int hci_suspend_wait_event(struct hci_dev *hdev)
>  {
>  #define WAKE_COND                                                              \
> @@ -3785,6 +3795,7 @@ void hci_unregister_dev(struct hci_dev *hdev)
>         cancel_work_sync(&hdev->power_on);
>
>         unregister_pm_notifier(&hdev->suspend_notifier);
> +       hci_suspend_clear_tasks(hdev);
>         cancel_work_sync(&hdev->suspend_prepare);
>
>         hci_dev_do_close(hdev);
> --
> 2.28.0.297.g1956fa8f8d-goog
>
