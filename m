Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCD41EE2C1
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 12:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbgFDKq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 06:46:26 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:32879 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgFDKq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 06:46:26 -0400
Received: by mail-oi1-f193.google.com with SMTP id i74so4679280oib.0;
        Thu, 04 Jun 2020 03:46:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wapTXlNyzxQxPAMAYQm5d6AJvGc7ALvZ5d5MGvh545A=;
        b=Jyl1oNuC+bkxtq1gHg/rwsDmgdli1tTgjWvzrPiTJ94sQzXuweLxRFkrJg+NcEHWTe
         tL+y39bJtb6Y5QUZuug+1rZoRdaLqz7cvavZxUN/eLZHiavKMp+m3Xqb65K8c9sYQN6D
         2aiWxd9QJjbPUWiQq+rRzAbIeWOdF2st7YFvLfL8z14Bnpsq+/hAHmrpvXyo8gTtBIpH
         k2zDamF/blUZR1JDexzNSKAuvXKh3bzMR8FGRsTC2MQFpjaVjKiZm7sSM158hWXZDjTE
         Buos6J36uiU3d6IXknTMti+yJjbWYF01EyEipzaRbRn5Lowb/ahiyipTRSBDao/bzouk
         xrNA==
X-Gm-Message-State: AOAM530+a2N5AbP5j/9Da95J1yYJgxkVGs7fFxVxJvGqD7e4ZoLnjosD
        OnHEG1VgpUr/MuCzBF6FttacXGAKjj5rxg5iw+I=
X-Google-Smtp-Source: ABdhPJwle7qDpHwAQGYs18DADpyiV5rAllbgOwetFP249ew3PEFnme9pErN/3fR2nq7VUIrGp3DlgUqNT6UxDMa5ALY=
X-Received: by 2002:aca:eb56:: with SMTP id j83mr2762270oih.110.1591267584968;
 Thu, 04 Jun 2020 03:46:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200603132148.1.I0ec31d716619532fc007eac081e827a204ba03de@changeid>
In-Reply-To: <20200603132148.1.I0ec31d716619532fc007eac081e827a204ba03de@changeid>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 4 Jun 2020 12:46:13 +0200
Message-ID: <CAJZ5v0i5VPk+HUb6P43Apb=MwanTkeWqjBMEemDo+fiBTM+eOg@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Allow suspend even when preparation has failed
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Len Brown <len.brown@intel.com>,
        Todd Brandt <todd.e.brandt@linux.intel.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        chromeos-bluetooth-upstreaming@chromium.org,
        Linux PM <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 3, 2020 at 10:22 PM Abhishek Pandit-Subedi
<abhishekpandit@chromium.org> wrote:
>
> It is preferable to allow suspend even when Bluetooth has problems
> preparing for sleep. When Bluetooth fails to finish preparing for
> suspend, log the error and allow the suspend notifier to continue
> instead.
>
> To also make it clearer why suspend failed, change bt_dev_dbg to
> bt_dev_err when handling the suspend timeout.
>
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>

Thanks for the patch, it looks reasonable to me.

It would be good to add a Fixes tag to it to indicate that it works
around an issue introduced by an earlier commit.

Len, Todd, would it be possible to test this one on the affected machines?

> ---
> To verify this is properly working, I added an additional change to
> hci_suspend_wait_event to always return -16. This validates that suspend
> continues even when an error has occurred during the suspend
> preparation.
>
> Example on Chromebook:
> [   55.834524] PM: Syncing filesystems ... done.
> [   55.841930] PM: Preparing system for sleep (s2idle)
> [   55.940492] Bluetooth: hci_core.c:hci_suspend_notifier() hci0: Suspend notifier action (3) failed: -16
> [   55.940497] Freezing user space processes ... (elapsed 0.001 seconds) done.
> [   55.941692] OOM killer disabled.
> [   55.941693] Freezing remaining freezable tasks ... (elapsed 0.000 seconds) done.
> [   55.942632] PM: Suspending system (s2idle)
>
> I ran this through a suspend_stress_test in the following scenarios:
> * Peer classic device connected: 50+ suspends
> * No devices connected: 100 suspends
> * With the above test case returning -EBUSY: 50 suspends
>
> I also ran this through our automated testing for suspend and wake on
> BT from suspend continues to work.
>
>
>  net/bluetooth/hci_core.c | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
>
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index dbe2d79f233fba..54da48441423e0 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -3289,10 +3289,10 @@ static int hci_suspend_wait_event(struct hci_dev *hdev)
>                                      WAKE_COND, SUSPEND_NOTIFIER_TIMEOUT);
>
>         if (ret == 0) {
> -               bt_dev_dbg(hdev, "Timed out waiting for suspend");
> +               bt_dev_err(hdev, "Timed out waiting for suspend events");
>                 for (i = 0; i < __SUSPEND_NUM_TASKS; ++i) {
>                         if (test_bit(i, hdev->suspend_tasks))
> -                               bt_dev_dbg(hdev, "Bit %d is set", i);
> +                               bt_dev_err(hdev, "Suspend timeout bit: %d", i);
>                         clear_bit(i, hdev->suspend_tasks);
>                 }
>
> @@ -3360,12 +3360,15 @@ static int hci_suspend_notifier(struct notifier_block *nb, unsigned long action,
>                 ret = hci_change_suspend_state(hdev, BT_RUNNING);
>         }
>
> -       /* If suspend failed, restore it to running */
> -       if (ret && action == PM_SUSPEND_PREPARE)
> -               hci_change_suspend_state(hdev, BT_RUNNING);
> -
>  done:
> -       return ret ? notifier_from_errno(-EBUSY) : NOTIFY_STOP;
> +       /* We always allow suspend even if suspend preparation failed and
> +        * attempt to recover in resume.
> +        */
> +       if (ret)
> +               bt_dev_err(hdev, "Suspend notifier action (%x) failed: %d",
> +                          action, ret);
> +
> +       return NOTIFY_STOP;
>  }
>
>  /* Alloc HCI device */
> --
> 2.27.0.rc2.251.g90737beb825-goog
>
