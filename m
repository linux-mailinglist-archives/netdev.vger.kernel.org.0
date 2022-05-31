Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E749253969F
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 20:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347198AbiEaS66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 14:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238284AbiEaS65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 14:58:57 -0400
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8FA939B4;
        Tue, 31 May 2022 11:58:56 -0700 (PDT)
Received: by mail-ua1-x92b.google.com with SMTP id z15so5091885uad.7;
        Tue, 31 May 2022 11:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D/yb4PwIyATnxy75saF4gdHVaGiRN37ZclVT8MwwmFA=;
        b=Ocuo50atZbRokWbAVeDG1vzTltS5141dPXkDFbEUfPANcSdSl+gmHbucjHAzyUCDo9
         D6FxfDecSczExkbsniwdbmmcrEturrwopg9Ga/JFW9Y3XYkztFhHr/+hRSi9Bvl5QO16
         EcSzvcgP0PgXenYcmdednkI6h2oks4q/VV2Z6mu+1V2VD4wgmBoV8Tw9UcJjJNwJ8gS8
         f8DSJGWLoeZSg5maP6eVE9DG4kFFBLoH204ArZJZDbDIxOujdac2YRWKVQ2vTy93FE3O
         xu9alF3MbV5isJv9xgM05qs8KrMBsPiVu9/eP3AYee9hdkqpjWGLF8ERicSiiGKQ/8xF
         O5yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D/yb4PwIyATnxy75saF4gdHVaGiRN37ZclVT8MwwmFA=;
        b=RTE6QU3y6VJ6XgxLSlexhy+hUMm5AdJdKOgiIVfHkiBAsutl7jmm1QRAf52k4EkRdX
         9IO38SBjPBSmd7trvuRHK/Tz8ZI33Ba6mrA5N3gRozV5sm//yp/LrsAH4Cb5apWBelUs
         V9DVOvz+OheXcME+6Mp0C9G/32gxZt0IDhmdpISrTmRMLjVebM2/DcnPZcIiWFo9gbAB
         7T4QZ9CXlAZCgdxfX1ZHKI7i72JjKYFlHhiRaZF3eGzA3ytEQ72NPz29Kk3K8aJVn3ky
         4MgdaGFWl6cc1GMxa/sGOYTzS9Rajw7qxwXpgd53uM7h8sETy0WE+synteVgq+g+sMlu
         6DMQ==
X-Gm-Message-State: AOAM5322WKtexMzNc7aVdjqgB4pSeC1yARQdWUNu420+WIeLcczfMYtz
        t/xWigj/SpTA3ILexv0xgAjQkEava86LBH8D+jQ=
X-Google-Smtp-Source: ABdhPJysd+8YHhBlmYtD+Cq2pGCtGPwVWxtjUyxm8342ezWGhFsBF+GIzRfIXgXcbTsQwqGTCgNwX3Ky/d9lu92CJtw=
X-Received: by 2002:ab0:614c:0:b0:369:27cf:e7c8 with SMTP id
 w12-20020ab0614c000000b0036927cfe7c8mr11190869uan.111.1654023535874; Tue, 31
 May 2022 11:58:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220531184124.20577-1-schspa@gmail.com>
In-Reply-To: <20220531184124.20577-1-schspa@gmail.com>
From:   Schspa Shi <schspa@gmail.com>
Date:   Wed, 1 Jun 2022 02:58:44 +0800
Message-ID: <CAMA88TqRsDFYcEKtFW_hPtD_TLuaeOWY3qi=ZrvNmybutn-BNA@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: When HCI work queue is drained, only queue
 chained work.
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, Eric Dumazet <edumazet@google.com>,
        kuba@kernel.org, pabeni@redhat.com
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Schspa Shi <schspa@gmail.com>,
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

Schspa Shi <schspa@gmail.com> writes:

> The HCI command, event, and data packet processing workqueue is drained
> to avoid deadlock in commit
> 76727c02c1e1 ("Bluetooth: Call drain_workqueue() before resetting state").
>
> There is another delayed work, which will queue command to this drained
> workqueue. Which results in the following error report:
>
> Bluetooth: hci2: command 0x040f tx timeout
> WARNING: CPU: 1 PID: 18374 at kernel/workqueue.c:1438 __queue_work+0xdad/0x1140
> Modules linked in:
> CPU: 1 PID: 18374 Comm: kworker/1:9 Not tainted 5.18.0-rc6-next-20220516-syzkaller #0
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
> ---
>  include/net/bluetooth/hci.h | 1 +
>  net/bluetooth/hci_core.c    | 8 +++++++-
>  net/bluetooth/hci_event.c   | 5 +++--
>  3 files changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
> index fe7935be7dc4..c2cba0a621d3 100644
> --- a/include/net/bluetooth/hci.h
> +++ b/include/net/bluetooth/hci.h
> @@ -291,6 +291,7 @@ enum {
>       HCI_RAW,
>
>       HCI_RESET,
> +     HCI_DRAIN_WQ,
>  };
>
>  /* HCI socket flags */
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index 5abb2ca5b129..ef3bd543ce04 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -593,6 +593,10 @@ static int hci_dev_do_reset(struct hci_dev *hdev)
>       skb_queue_purge(&hdev->rx_q);
>       skb_queue_purge(&hdev->cmd_q);
>
> +     hci_dev_lock(hdev);
> +     set_bit(HCI_DRAIN_WQ, &hdev->flags);
> +     hci_dev_unlock(hdev);
> +     cancel_delayed_work(&hdev->cmd_timer);

Need to add cancel_delayed_work(&hdev->ncmd_timer);
I'll make a new patch after the rest of this patch has been reviewed.

>       /* Avoid potential lockdep warnings from the *_flush() calls by
>        * ensuring the workqueue is empty up front.
>        */
> @@ -601,6 +605,7 @@ static int hci_dev_do_reset(struct hci_dev *hdev)
>       hci_dev_lock(hdev);
>       hci_inquiry_cache_flush(hdev);
>       hci_conn_hash_flush(hdev);
> +     clear_bit(HCI_DRAIN_WQ, &hdev->flags);
>       hci_dev_unlock(hdev);
>
>       if (hdev->flush)
> @@ -3861,7 +3866,8 @@ static void hci_cmd_work(struct work_struct *work)
>                       if (res < 0)
>                               __hci_cmd_sync_cancel(hdev, -res);
>
> -                     if (test_bit(HCI_RESET, &hdev->flags))
> +                     if (test_bit(HCI_RESET, &hdev->flags) ||
> +                         test_bit(HCI_DRAIN_WQ, &hdev->flags))
>                               cancel_delayed_work(&hdev->cmd_timer);
>                       else
>                               schedule_delayed_work(&hdev->cmd_timer,
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index af17dfb20e01..700cd01df3a1 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -3768,8 +3768,9 @@ static inline void handle_cmd_cnt_and_timer(struct hci_dev *hdev, u8 ncmd)
>                       cancel_delayed_work(&hdev->ncmd_timer);
>                       atomic_set(&hdev->cmd_cnt, 1);
>               } else {
> -                     schedule_delayed_work(&hdev->ncmd_timer,
> -                                           HCI_NCMD_TIMEOUT);
> +                     if (!test_bit(HCI_DRAIN_WQ, &hdev->flags))
> +                             schedule_delayed_work(&hdev->ncmd_timer,
> +                                                   HCI_NCMD_TIMEOUT);
>               }
>       }
>  }

---
BRs

Schspa Shi
