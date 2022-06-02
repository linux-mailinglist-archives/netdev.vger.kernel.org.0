Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79AFF53BBCE
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 17:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236559AbiFBPrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 11:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236512AbiFBPry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 11:47:54 -0400
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5314B2E09B;
        Thu,  2 Jun 2022 08:47:53 -0700 (PDT)
Received: by mail-ua1-x92b.google.com with SMTP id 90so1689355uam.8;
        Thu, 02 Jun 2022 08:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bJD63HN47QX1Hjb9eL1+KF9PTGCP1kFxZZ4J2NlZtaM=;
        b=RjTSjckA5WtpPZZtcaDI0IDZqEm1SKkhZlIz3HYPOK2r0qHCElZXFXUutBc18qoebt
         N6sI7f+Mq5KWPsNl7c5Qwp8B1VIk2o7jgZc8lpz74LWPhy97zBmZ22LZBF6LkiNKtM7O
         AsAjs9Lep/5wQ2/Ys1WhGc0JO4d9wdstfE2pg5mlXOyyzFRvOZdCALbwdWD6pkhORK2o
         Bx91O2Lv0Hz+bpUlGzxKpnoHUesicl6rhGTjQcHiVmqY3b3fBb0/Sc7L6WZipWeiROvC
         jI9Ihbt14UmlsgZb7vTjtfhcOFowweTfRlSKD/5SPuCiAAlzi22nlfrYimnYXb/ET4s+
         kyfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bJD63HN47QX1Hjb9eL1+KF9PTGCP1kFxZZ4J2NlZtaM=;
        b=rJdJV/qvv/JSMlanrYQTmeoXH8xPAzfwVVCtYjF8L5dJOrkBd3oWRw6fe8XMrceCJF
         PI6/Aup3uXR0Ivu9legFDdvs4RY/owu23ArjKubPJhJj8z8bUVvsU1YiSXD0wxJdepfk
         aEr19KMb/1Ge/pMSi7J9ouBZjioc1QrENQBpHoNv2YeJcaVw73E7XA2oja5fVcaEpBqj
         q03wuHvZ1VWBNttWSnIeGFtn2SALEt29cXmGxTjclMh0JHOO4VH0moUJ1ITGPu+37XS6
         DuCccgXciDyLakUIXJm1+6k+vg/a9LcMzDBNzV+nBxsTWxxtiY8b0v5AAg7UTdOSK2m1
         9kJA==
X-Gm-Message-State: AOAM530Onzx8eCksclWVuwvkqbtr8C9HuDhI8zUkXob2UBxlKuprWhhU
        buj0P0hBJ/E/RWwmYg6+mYll1STUCvJMiejHsaKmzTR6WpTYEQ==
X-Google-Smtp-Source: ABdhPJwrXxBoDBFjDpjV/eQQDWR/OEsHBzboVHmCe7kBvbJU6RbDwYD0M+RWOOkKtnc0pfU0dGT9UG0KbQdEDfx/ET0=
X-Received: by 2002:ab0:240d:0:b0:36e:9ea:a5f3 with SMTP id
 f13-20020ab0240d000000b0036e09eaa5f3mr9299160uan.92.1654184872371; Thu, 02
 Jun 2022 08:47:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220531184124.20577-1-schspa@gmail.com> <4E08D734-E534-4EB7-A12A-7F5D232358ED@holtmann.org>
In-Reply-To: <4E08D734-E534-4EB7-A12A-7F5D232358ED@holtmann.org>
From:   Schspa Shi <schspa@gmail.com>
Date:   Thu, 2 Jun 2022 23:47:40 +0800
Message-ID: <CAMA88Tp_LUNMppsWEoqPnhp6ZeXxd4+AMVHGta16U8ApkdD-gg@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: When HCI work queue is drained, only queue
 chained work.
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, kuba@kernel.org,
        pabeni@redhat.com, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org,
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

Marcel Holtmann <marcel@holtmann.org> writes:

> Hi Schspa,
>
>> The HCI command, event, and data packet processing workqueue is drained
>> to avoid deadlock in commit
>> 76727c02c1e1 ("Bluetooth: Call drain_workqueue() before resetting state").
>>
>> There is another delayed work, which will queue command to this drained
>> workqueue. Which results in the following error report:
>>
>> Bluetooth: hci2: command 0x040f tx timeout
>> WARNING: CPU: 1 PID: 18374 at kernel/workqueue.c:1438 __queue_work+0xdad/0x1140
>> Modules linked in:
>> CPU: 1 PID: 18374 Comm: kworker/1:9 Not tainted 5.18.0-rc6-next-20220516-syzkaller #0
>> Workqueue: events hci_cmd_timeout
>> RIP: 0010:__queue_work+0xdad/0x1140
>> RSP: 0000:ffffc90002cffc60 EFLAGS: 00010093
>> RAX: 0000000000000000 RBX: ffff8880b9d3ec00 RCX: 0000000000000000
>> RDX: ffff888024ba0000 RSI: ffffffff814e048d RDI: ffff8880b9d3ec08
>> RBP: 0000000000000008 R08: 0000000000000000 R09: 00000000b9d39700
>> R10: ffffffff814f73c6 R11: 0000000000000000 R12: ffff88807cce4c60
>> R13: 0000000000000000 R14: ffff8880796d8800 R15: ffff8880796d8800
>> FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 000000c0174b4000 CR3: 000000007cae9000 CR4: 00000000003506e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Call Trace:
>> <TASK>
>> ? queue_work_on+0xcb/0x110
>> ? lockdep_hardirqs_off+0x90/0xd0
>> queue_work_on+0xee/0x110
>> process_one_work+0x996/0x1610
>> ? pwq_dec_nr_in_flight+0x2a0/0x2a0
>> ? rwlock_bug.part.0+0x90/0x90
>> ? _raw_spin_lock_irq+0x41/0x50
>> worker_thread+0x665/0x1080
>> ? process_one_work+0x1610/0x1610
>> kthread+0x2e9/0x3a0
>> ? kthread_complete_and_exit+0x40/0x40
>> ret_from_fork+0x1f/0x30
>> </TASK>
>>
>> To fix this, we can add a new HCI_DRAIN_WQ flag, and don't queue the
>> timeout workqueue while command workqueue is draining.
>>
>> Fixes: 76727c02c1e1 ("Bluetooth: Call drain_workqueue() before resetting state")
>> Reported-by: syzbot+63bed493aebbf6872647@syzkaller.appspotmail.com
>> Signed-off-by: Schspa Shi <schspa@gmail.com>
>> ---
>> include/net/bluetooth/hci.h | 1 +
>> net/bluetooth/hci_core.c    | 8 +++++++-
>> net/bluetooth/hci_event.c   | 5 +++--
>> 3 files changed, 11 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
>> index fe7935be7dc4..c2cba0a621d3 100644
>> --- a/include/net/bluetooth/hci.h
>> +++ b/include/net/bluetooth/hci.h
>> @@ -291,6 +291,7 @@ enum {
>>      HCI_RAW,
>>
>>      HCI_RESET,
>> +    HCI_DRAIN_WQ,
>> };
>
> no addition to this enum please. This is ABI. Use the other one and hci_dev_{set,clear}_flag.
>
>>
>> /* HCI socket flags */
>> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
>> index 5abb2ca5b129..ef3bd543ce04 100644
>> --- a/net/bluetooth/hci_core.c
>> +++ b/net/bluetooth/hci_core.c
>> @@ -593,6 +593,10 @@ static int hci_dev_do_reset(struct hci_dev *hdev)
>>      skb_queue_purge(&hdev->rx_q);
>>      skb_queue_purge(&hdev->cmd_q);
>>
>> +    hci_dev_lock(hdev);
>> +    set_bit(HCI_DRAIN_WQ, &hdev->flags);
>> +    hci_dev_unlock(hdev);
>> +    cancel_delayed_work(&hdev->cmd_timer);
>
> Do you need to the locking here?
>

No, it seems this lock can be removed.

I can send a new patch version to remove this.

>>      /* Avoid potential lockdep warnings from the *_flush() calls by
>>       * ensuring the workqueue is empty up front.
>>       */
>> @@ -601,6 +605,7 @@ static int hci_dev_do_reset(struct hci_dev *hdev)
>>      hci_dev_lock(hdev);
>>      hci_inquiry_cache_flush(hdev);
>>      hci_conn_hash_flush(hdev);
>> +    clear_bit(HCI_DRAIN_WQ, &hdev->flags);
>>      hci_dev_unlock(hdev);
>>
>>      if (hdev->flush)
>> @@ -3861,7 +3866,8 @@ static void hci_cmd_work(struct work_struct *work)
>>                      if (res < 0)
>>                              __hci_cmd_sync_cancel(hdev, -res);
>>
>> -                    if (test_bit(HCI_RESET, &hdev->flags))
>> +                    if (test_bit(HCI_RESET, &hdev->flags) ||
>> +                        test_bit(HCI_DRAIN_WQ, &hdev->flags))
>>                              cancel_delayed_work(&hdev->cmd_timer);
>>                      else
>>                              schedule_delayed_work(&hdev->cmd_timer,
>> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
>> index af17dfb20e01..700cd01df3a1 100644
>> --- a/net/bluetooth/hci_event.c
>> +++ b/net/bluetooth/hci_event.c
>> @@ -3768,8 +3768,9 @@ static inline void handle_cmd_cnt_and_timer(struct hci_dev *hdev, u8 ncmd)
>>                      cancel_delayed_work(&hdev->ncmd_timer);
>>                      atomic_set(&hdev->cmd_cnt, 1);
>>              } else {
>> -                    schedule_delayed_work(&hdev->ncmd_timer,
>> -                                          HCI_NCMD_TIMEOUT);
>> +                    if (!test_bit(HCI_DRAIN_WQ, &hdev->flags))
>> +                            schedule_delayed_work(&hdev->ncmd_timer,
>> +                                                  HCI_NCMD_TIMEOUT);
>>              }
>>      }
>> }
>
> Regards
>
> Marcel

--
BRs

Schspa Shi
