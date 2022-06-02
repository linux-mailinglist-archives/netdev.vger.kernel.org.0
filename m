Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5183D53C012
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 22:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiFBU4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 16:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiFBU4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 16:56:06 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A1833EB4;
        Thu,  2 Jun 2022 13:56:04 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id cx11so5938980pjb.1;
        Thu, 02 Jun 2022 13:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dw6l8zIZ5qVjCuzEpteWubruDjlOh5Cx0mWoCv3VXRs=;
        b=DitXn94UgChiQHx73iW+wOBCS3ZRS2C8sTau6bp8IOuFeYK3QqLmHmk64o4S25D2yK
         2iqfThFqVg5nDlvLjxEScm4MaGpJSOljYolinO3E0rqlcPu2HdN12Ljxpt7Wk3Zi0I+f
         jRfseuMfZC7CV9PJpxzEbWXiVKXitbwpSlOiJmKcsjITWMkTM4KgbIRDv+KY9vMQKU9r
         DEeelPRFYT9hMsks/pZdh5V4PN4XCjMnAUM7BspHxrA7njoAL8bwaxQznnXyi4bfXPJy
         dzZMn3/BJXKStS1gQFEx0Aq2D3Inu7stCg3LtK26oQzCzFK1y8zzhDSwaWWfiwSRCHYN
         URnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dw6l8zIZ5qVjCuzEpteWubruDjlOh5Cx0mWoCv3VXRs=;
        b=5pLg+c5LbgMmHwk9DxhmSpYkUx9FZ7f8+Wq12w7tKqjdWcTs5z7jFogpYAJjXVdHH9
         JTbGwrOnSPDclgVWlG7ZKrfM9tQ+arWhX6m4pUkkAHSksfKlQIE7Yw/K8Np8zrwYqfx3
         f0UMhje5s5hKJGAUAVPYpXeXul24aL3gOR1xvvBK+Yk7OwGAiO+IocSLsRRxQXleRRN8
         MbeczWaNLQFOfT1vdREWgWiz1NDmnM26xKn3Vv+KCFBZ6h5v1cIqz2Z5k5zKr210P62y
         mw3pCEF7NgPFWQBXh6C6IcSYc3cQWxiiAr3I+S20A4amyYvWdONV1DIM9HyLcfnp89xN
         3/YQ==
X-Gm-Message-State: AOAM5336skOUsqAweEk9wRJ10wu+zCjKyBIfgtR0mC9r2MqUbg1Tn2yt
        inl9MqF1J9bXffSHuHatvrNOEMRfHXDDntr+Tq0=
X-Google-Smtp-Source: ABdhPJwXTEG4AY9RTeveA2AmonaIPfEMCfEchsXw+7hhOaD4a05RE9O8akifcB6h9IqG5fhRxvTFiLHVSLh3GVxbXcE=
X-Received: by 2002:a17:90a:4803:b0:1dc:b4c9:1958 with SMTP id
 a3-20020a17090a480300b001dcb4c91958mr41970103pjh.61.1654203363967; Thu, 02
 Jun 2022 13:56:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220602191949.31311-1-schspa@gmail.com>
In-Reply-To: <20220602191949.31311-1-schspa@gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Thu, 2 Jun 2022 13:55:52 -0700
Message-ID: <CABBYNZJw=bY8T_HkWF2cTbFNg=973Deu0sHPUa2R5k7T13-WKA@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: When HCI work queue is drained, only queue
 chained work
To:     Schspa Shi <schspa@gmail.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        syzbot+63bed493aebbf6872647@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Schspa,

On Thu, Jun 2, 2022 at 12:20 PM Schspa Shi <schspa@gmail.com> wrote:
>
> The HCI command, event, and data packet processing workqueue is drained
> to avoid deadlock in commit
> 76727c02c1e1 ("Bluetooth: Call drain_workqueue() before resetting state").
>
> There is another delayed work, which will queue command to this drained
> workqueue. Which results in the following error report:
>
> Bluetooth: hci2: command 0x040f tx timeout
> WARNING: CPU: 1 PID: 18374 at kernel/workqueue.c:1438 __queue_work+0xdad/0x1140
> Workqueue: events hci_cmd_timeout
> RIP: 0010:__queue_work+0xdad/0x1140
> RSP: 0000:ffffc90002cffc60 EFLAGS: 00010093
> RAX: 0000000000000000 RBX: ffff8880b9d3ec00 RCX: 0000000000000000
> RDX: ffff888024ba0000 RSI: ffffffff814e048d RDI: ffff8880b9d3ec08
> RBP: 0000000000000008 R08: 0000000000000000 R09: 00000000b9d39700
> R10: ffffffff814f73c6 R11: 0000000000000000 R12: ffff88807cce4c60
> R13: 0000000000000000 R14: ffff8880796d8800 R15: ffff8880796d8800
> FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000c0174b4000 CR3: 000000007cae9000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  ? queue_work_on+0xcb/0x110
>  ? lockdep_hardirqs_off+0x90/0xd0
>  queue_work_on+0xee/0x110
>  process_one_work+0x996/0x1610
>  ? pwq_dec_nr_in_flight+0x2a0/0x2a0
>  ? rwlock_bug.part.0+0x90/0x90
>  ? _raw_spin_lock_irq+0x41/0x50
>  worker_thread+0x665/0x1080
>  ? process_one_work+0x1610/0x1610
>  kthread+0x2e9/0x3a0
>  ? kthread_complete_and_exit+0x40/0x40
>  ret_from_fork+0x1f/0x30
>  </TASK>
>
> To fix this, we can add a new HCI_DRAIN_WQ flag, and don't queue the
> timeout workqueue while command workqueue is draining.
>
> Fixes: 76727c02c1e1 ("Bluetooth: Call drain_workqueue() before resetting state")
> Reported-by: syzbot+63bed493aebbf6872647@syzkaller.appspotmail.com
> Signed-off-by: Schspa Shi <schspa@gmail.com>
>
> Changelog:
> v1 -> v2:
>         - Move the workqueue drain flag to controller flags, and use hci_dev_*_flag.
>         - Add missing ncmd_timer cancel.
>         - Clear DRAIN_WORKQUEUE flag after device command flushed.
> ---
>  include/net/bluetooth/hci.h |  1 +
>  net/bluetooth/hci_core.c    | 10 +++++++++-
>  net/bluetooth/hci_event.c   |  5 +++--
>  3 files changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
> index fe7935be7dc4..4a45c48eb0d2 100644
> --- a/include/net/bluetooth/hci.h
> +++ b/include/net/bluetooth/hci.h
> @@ -361,6 +361,7 @@ enum {
>         HCI_QUALITY_REPORT,
>         HCI_OFFLOAD_CODECS_ENABLED,
>         HCI_LE_SIMULTANEOUS_ROLES,
> +       HCI_CMD_DRAIN_WORKQUEUE,
>
>         __HCI_NUM_FLAGS,
>  };
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index 5abb2ca5b129..e908fdc4625c 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -593,6 +593,11 @@ static int hci_dev_do_reset(struct hci_dev *hdev)
>         skb_queue_purge(&hdev->rx_q);
>         skb_queue_purge(&hdev->cmd_q);
>
> +       /* Cancel these not cahined pending work */
> +       hci_dev_set_flag(hdev, HCI_CMD_DRAIN_WORKQUEUE);

There seems to be a typo on the comment line 'cahined', also perhaps
you test it before setting it so we don't risk flushing multiple
times?

> +       cancel_delayed_work(&hdev->cmd_timer);
> +       cancel_delayed_work(&hdev->ncmd_timer);
> +
>         /* Avoid potential lockdep warnings from the *_flush() calls by
>          * ensuring the workqueue is empty up front.
>          */
> @@ -606,6 +611,8 @@ static int hci_dev_do_reset(struct hci_dev *hdev)
>         if (hdev->flush)
>                 hdev->flush(hdev);
>
> +       hci_dev_clear_flag(hdev, HCI_CMD_DRAIN_WORKQUEUE);
> +
>         atomic_set(&hdev->cmd_cnt, 1);
>         hdev->acl_cnt = 0; hdev->sco_cnt = 0; hdev->le_cnt = 0;
>
> @@ -3861,7 +3868,8 @@ static void hci_cmd_work(struct work_struct *work)
>                         if (res < 0)
>                                 __hci_cmd_sync_cancel(hdev, -res);
>
> -                       if (test_bit(HCI_RESET, &hdev->flags))
> +                       if (test_bit(HCI_RESET, &hdev->flags) ||
> +                           hci_dev_test_flag(hdev, HCI_CMD_DRAIN_WORKQUEUE))
>                                 cancel_delayed_work(&hdev->cmd_timer);
>                         else
>                                 schedule_delayed_work(&hdev->cmd_timer,
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index af17dfb20e01..7cb956d3abb2 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -3768,8 +3768,9 @@ static inline void handle_cmd_cnt_and_timer(struct hci_dev *hdev, u8 ncmd)
>                         cancel_delayed_work(&hdev->ncmd_timer);
>                         atomic_set(&hdev->cmd_cnt, 1);
>                 } else {
> -                       schedule_delayed_work(&hdev->ncmd_timer,
> -                                             HCI_NCMD_TIMEOUT);
> +                       if (!hci_dev_test_flag(hdev, HCI_CMD_DRAIN_WORKQUEUE))
> +                               schedule_delayed_work(&hdev->ncmd_timer,
> +                                                     HCI_NCMD_TIMEOUT);
>                 }
>         }
>  }
> --
> 2.24.3 (Apple Git-128)
>


-- 
Luiz Augusto von Dentz
