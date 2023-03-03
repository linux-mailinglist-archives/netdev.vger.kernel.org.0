Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1B236A9E2D
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 19:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbjCCSJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 13:09:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbjCCSJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 13:09:49 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6810113CB;
        Fri,  3 Mar 2023 10:09:47 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id z5so3206956ljc.8;
        Fri, 03 Mar 2023 10:09:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=muWkEi5u2VnAabnAUnAlA8tSUUjR0VEb8VOPXBIRzPU=;
        b=Ndx/h2RNlXnSmoZYQoGL6rjkIA3L7MgEqcnH71W3Nd+UA5RyL3pH9UwiWObbbSoDux
         nwgGIhidXikvLk3c0nfEOSYh62zZmp+64UBxoisq8XFeMoo6ywTQOxjD0HLQpOmnISAz
         gGeFY0vmNq0FFItdA2TooX56/XiVoAO+0ETcGxz904hIHgXdGfrpjL3liKHf5wxBIRye
         ShQBMlOJspg16EUjJgkpHdhtmvyzhvyj1IGJM+X8CQsypi5GdBnwUoPOXiM2SbL5cDOV
         b36JtrN6aumRpeOFLWOyMQ4FGconGnq//FoOEY0DNLmAvRqX1eGTZ75sOHa+Jv2gdcmm
         yfQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=muWkEi5u2VnAabnAUnAlA8tSUUjR0VEb8VOPXBIRzPU=;
        b=HAgD+YWmpRp7NGtBCXOB3uDGD3xY0w7isYySXK38B7Pc0JmGp5aoKCkSdYg+d357X1
         wiPlzR/mHfM1Un0sOYzGZWbfiCqeUowOhTqMU/elZZcEBcePXLo+b8Ti7im/U5TJjWoc
         ntgu5aubb3w4QwKnx0uI5+PYMlaXXzTXOlzdV1vZbrKThpr2roAJj4k9NJFAjailH8WE
         Zfi0+NgiCQJDLTC9hhF7ZRxvQsMfCYO5NOYTQRnHcaYrzJjooDfvU6RJ5rDfCfsVIrVB
         RLMUCGtuQQdr9eNQK9bVx2Lo0urh9ajjqPOdFb0FlvXhV/J7jmJEOxc+5PC2wfOWtcdn
         SrNg==
X-Gm-Message-State: AO0yUKUmshRcI9Lm2uQCOEnLQQ/xt3t4r3DxWSnjpvfZgXNCbwSVnpQZ
        X2VovnTXEyTmnzwCLu7jWgGt59WDuJHwXR9ICIM5VdlbKYE=
X-Google-Smtp-Source: AK7set8xB7tGrYd3rXu04H2i2pi2t9cn6Ua/3ksF/RwTa1KprzXDfd1Lr/5riBAsF6n5C0wdoVEmo+CGyhiFr0d2cmk=
X-Received: by 2002:a2e:a4c8:0:b0:28b:e4ac:fea0 with SMTP id
 p8-20020a2ea4c8000000b0028be4acfea0mr861907ljm.9.1677866986071; Fri, 03 Mar
 2023 10:09:46 -0800 (PST)
MIME-Version: 1.0
References: <CAAgLYK7qZAotVT5mQ_FjaO+RvG_z8HGezKbjeRrd_03ekyrjFA@mail.gmail.com>
In-Reply-To: <CAAgLYK7qZAotVT5mQ_FjaO+RvG_z8HGezKbjeRrd_03ekyrjFA@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Fri, 3 Mar 2023 10:09:34 -0800
Message-ID: <CABBYNZKr=TdMkEyqvaJ2pJaFtS+4unwVY7QotiJdWtZ5-8Es5w@mail.gmail.com>
Subject: Re: [PATCH 1/1] Bluetooth: fix race condition in hci_cmd_sync_clear
To:     lm0963 <lm0963hack@gmail.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>, davem@davemloft.net,
        edumazet@google.com, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, jkosina@suse.cz,
        hdegoede@redhat.com, david.rheinsberg@gmail.com,
        wsa+renesas@sang-engineering.com, linux@weissschuh.net,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Min,

On Wed, Mar 1, 2023 at 11:21=E2=80=AFPM lm0963 <lm0963hack@gmail.com> wrote=
:
>
> There is a potential race condition in hci_cmd_sync_work and
> hci_cmd_sync_clear, and could lead to use-after-free. For instance,
> hci_cmd_sync_work is added to the 'req_workqueue' after cancel_work_sync
> The entry of 'cmd_sync_work_list' may be freed in hci_cmd_sync_clear, and
> causing kernel panic when it is used in hci_cmd_sync_work.
>
> Here's the call trace:
>
> dump_stack_lvl+0x49/0x63
> print_report.cold+0x5e/0x5d3
> ? hci_cmd_sync_work+0x282/0x320
> kasan_report+0xaa/0x120
> ? hci_cmd_sync_work+0x282/0x320
> __asan_report_load8_noabort+0x14/0x20
> hci_cmd_sync_work+0x282/0x320
> process_one_work+0x77b/0x11c0
> ? _raw_spin_lock_irq+0x8e/0xf0
> worker_thread+0x544/0x1180
> ? poll_idle+0x1e0/0x1e0
> kthread+0x285/0x320
> ? process_one_work+0x11c0/0x11c0
> ? kthread_complete_and_exit+0x30/0x30
> ret_from_fork+0x22/0x30
> </TASK>
>
> Allocated by task 266:
> kasan_save_stack+0x26/0x50
> __kasan_kmalloc+0xae/0xe0
> kmem_cache_alloc_trace+0x191/0x350
> hci_cmd_sync_queue+0x97/0x2b0
> hci_update_passive_scan+0x176/0x1d0
> le_conn_complete_evt+0x1b5/0x1a00
> hci_le_conn_complete_evt+0x234/0x340
> hci_le_meta_evt+0x231/0x4e0
> hci_event_packet+0x4c5/0xf00
> hci_rx_work+0x37d/0x880
> process_one_work+0x77b/0x11c0
> worker_thread+0x544/0x1180
> kthread+0x285/0x320
> ret_from_fork+0x22/0x30
>
> Freed by task 269:
> kasan_save_stack+0x26/0x50
> kasan_set_track+0x25/0x40
> kasan_set_free_info+0x24/0x40
> ____kasan_slab_free+0x176/0x1c0
> __kasan_slab_free+0x12/0x20
> slab_free_freelist_hook+0x95/0x1a0
> kfree+0xba/0x2f0
> hci_cmd_sync_clear+0x14c/0x210
> hci_unregister_dev+0xff/0x440
> vhci_release+0x7b/0xf0
> __fput+0x1f3/0x970
> ____fput+0xe/0x20
> task_work_run+0xd4/0x160
> do_exit+0x8b0/0x22a0
> do_group_exit+0xba/0x2a0
> get_signal+0x1e4a/0x25b0
> arch_do_signal_or_restart+0x93/0x1f80
> exit_to_user_mode_prepare+0xf5/0x1a0
> syscall_exit_to_user_mode+0x26/0x50
> ret_from_fork+0x15/0x30
>
> Signed-off-by: Min Li <lm0963hack@gmail.com>
> ---
>  net/bluetooth/hci_sync.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
> index 117eedb6f709..3103daf49d63 100644
> --- a/net/bluetooth/hci_sync.c
> +++ b/net/bluetooth/hci_sync.c
> @@ -643,6 +643,7 @@ void hci_cmd_sync_clear(struct hci_dev *hdev)
>   cancel_work_sync(&hdev->cmd_sync_work);
>   cancel_work_sync(&hdev->reenable_adv_work);
>
> + mutex_lock(&hdev->cmd_sync_work_lock);
>   list_for_each_entry_safe(entry, tmp, &hdev->cmd_sync_work_list, list) {
>   if (entry->destroy)
>   entry->destroy(hdev, entry->data, -ECANCELED);
> @@ -650,6 +651,7 @@ void hci_cmd_sync_clear(struct hci_dev *hdev)
>   list_del(&entry->list);
>   kfree(entry);
>   }
> + mutex_unlock(&hdev->cmd_sync_work_lock);
>  }

The code style of this one seems broken, did you generate it using git
format-patch?

>  void __hci_cmd_sync_cancel(struct hci_dev *hdev, int err)
> --
> 2.25.1



--=20
Luiz Augusto von Dentz
