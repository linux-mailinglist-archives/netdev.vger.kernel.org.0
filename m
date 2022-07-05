Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFD65670CF
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 16:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbiGEORy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 10:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232908AbiGEORR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 10:17:17 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE319235;
        Tue,  5 Jul 2022 07:12:55 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id f39so20791615lfv.3;
        Tue, 05 Jul 2022 07:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oyeclLFZhGs7UcPSZg23Ramue8jnRUpUIOwptQLH1Io=;
        b=VGlelE8yDbqD+DKIKudaPJvE+DeQMn3wB93n5X+mEpDz6bzLthw17F18OJE7U/oP0D
         DRoOiiPWe4toIuvS5cXGksNfMOPMeb3m3HN9YDVQ1LaW1ldaIbKDOgu36tUcvUZh6/+u
         Zz1uQdHkEJIdRR0cIcYXdICuNyyrzoiytw1DBSPmhiLH8oAFJsRFceWafDEnFMZ5FOeF
         +FZF3eyFDn8ZaMg6d6f5/11gZ9/4BsJeGr9Qqc4j4GjagTVV2A9iLGOUcQ5pCyQiHVnm
         N4cDffKQlEEIu49zR31b3aA7cqRM3Z/kSZe+Q3B9kTSP+VTTvzSMe2ZbMTw0yuKN5b3Y
         7goA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oyeclLFZhGs7UcPSZg23Ramue8jnRUpUIOwptQLH1Io=;
        b=zCUGBvSvkCIYVrq63dKA+KkvgTtO1wQdNySAU0rrXmkBMoSkfFy3vk6K1T1rx9Cpf1
         jm6U7etUoY5viZFihiYOd8kw96dp3dszUH59x5it2SlUp/3yRyFj+HNzvK5f9gzAkZlh
         oVDboVvkbri0UUqYhVphCl8gnYthiSjO32y2POWlnrHtng25xVYpvLcmpsvx7NBtogTj
         dRhDVQD7nyqrpcShcPEI+YUvCify3CNcoxcstvCA0Ur1TOQsCT440PPIY/HMLg2JYpGE
         WItAkS+orYO5hICfLtC3unYXfBRld92y9DtXF6EzKrYzyNZjM+exJgT9n0i6Kh8rrx4y
         ZGHg==
X-Gm-Message-State: AJIora81HViDBEsCDu0xdNpIyKTr5BJ2FR+DVyi2PpYL9CcMQy6tK42x
        pQMTV2jypWdBRdYxsx7MeuzlAyLYqkGvhxERF0U=
X-Google-Smtp-Source: AGRyM1vH3GybcpyJQODfunZbTC1eaVMg/RZHlTCu27cJXX7YAwLol2URLo0KM+OLvegbCy4h7bRwHLhdDpR0v38M0a8=
X-Received: by 2002:a05:6512:12c9:b0:480:3b03:a0bc with SMTP id
 p9-20020a05651212c900b004803b03a0bcmr22184083lfg.381.1657030372741; Tue, 05
 Jul 2022 07:12:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220614181706.26513-1-max.oss.09@gmail.com> <20220705125931.3601-1-vasyl.vavrychuk@opensynergy.com>
In-Reply-To: <20220705125931.3601-1-vasyl.vavrychuk@opensynergy.com>
From:   Max Krummenacher <max.oss.09@gmail.com>
Date:   Tue, 5 Jul 2022 16:12:41 +0200
Message-ID: <CAEHkU3XGEgRzG8pRW30BJhw6CMTPNJX1K8bLiEkoXpp19A6FHA@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: core: Fix deadlock due to `cancel_work_sync(&hdev->power_on)`
 from hci_power_on_sync.
To:     Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        =?UTF-8?Q?Mateusz_Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Max Krummenacher <max.krummenacher@toradex.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 5, 2022 at 3:00 PM Vasyl Vavrychuk
<vasyl.vavrychuk@opensynergy.com> wrote:
>
> `cancel_work_sync(&hdev->power_on)` was moved to hci_dev_close_sync in
> commit [1] to ensure that power_on work is canceled after HCI interface
> down.
>
> But, in certain cases power_on work function may call hci_dev_close_sync
> itself: hci_power_on -> hci_dev_do_close -> hci_dev_close_sync ->
> cancel_work_sync(&hdev->power_on), causing deadlock. In particular, this
> happens when device is rfkilled on boot. To avoid deadlock, move
> power_on work canceling out of hci_dev_do_close/hci_dev_close_sync.
>
> Deadlock introduced by commit [1] was reported in [2,3] as broken
> suspend. Suspend did not work because `hdev->req_lock` held as result of
> `power_on` work deadlock. In fact, other BT features were not working.
> It was not observed when testing [1] since it was verified without
> rfkill in place.
>
> NOTE: It is not needed to cancel power_on work from other places where
> hci_dev_do_close/hci_dev_close_sync is called in case:
> * Requests were serialized due to `hdev->req_workqueue`. The power_on
> work is first in that workqueue.
> * hci_rfkill_set_block which won't close device anyway until HCI_SETUP
> is on.
> * hci_sock_release which runs after hci_sock_bind which ensures
> HCI_SETUP was cleared.
>
> As result, behaviour is the same as in pre-dd06ed7 commit, except
> power_on work cancel added to hci_dev_close.
>
> [1]: commit dd06ed7ad057 ("Bluetooth: core: Fix missing power_on work cancel on HCI close")
> [2]: https://lore.kernel.org/lkml/20220614181706.26513-1-max.oss.09@gmail.com/
> [2]: https://lore.kernel.org/lkml/1236061d-95dd-c3ad-a38f-2dae7aae51ef@o2.pl/
>
> Fixes: commit dd06ed7ad057 ("Bluetooth: core: Fix missing power_on work cancel on HCI close")
> Signed-off-by: Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>
> Reported-by: Max Krummenacher <max.krummenacher@toradex.com>
> Reported-by: Mateusz Jonczyk <mat.jonczyk@o2.pl>
> ---
>  net/bluetooth/hci_core.c | 3 +++
>  net/bluetooth/hci_sync.c | 1 -
>  2 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index 59a5c1341c26..a0f99baafd35 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -571,6 +571,7 @@ int hci_dev_close(__u16 dev)
>                 goto done;
>         }
>
> +       cancel_work_sync(&hdev->power_on);
>         if (hci_dev_test_and_clear_flag(hdev, HCI_AUTO_OFF))
>                 cancel_delayed_work(&hdev->power_off);
>
> @@ -2675,6 +2676,8 @@ void hci_unregister_dev(struct hci_dev *hdev)
>         list_del(&hdev->list);
>         write_unlock(&hci_dev_list_lock);
>
> +       cancel_work_sync(&hdev->power_on);
> +
>         hci_cmd_sync_clear(hdev);
>
>         if (!test_bit(HCI_QUIRK_NO_SUSPEND_NOTIFIER, &hdev->quirks))
> diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
> index 286d6767f017..1739e8cb3291 100644
> --- a/net/bluetooth/hci_sync.c
> +++ b/net/bluetooth/hci_sync.c
> @@ -4088,7 +4088,6 @@ int hci_dev_close_sync(struct hci_dev *hdev)
>
>         bt_dev_dbg(hdev, "");
>
> -       cancel_work_sync(&hdev->power_on);
>         cancel_delayed_work(&hdev->power_off);
>         cancel_delayed_work(&hdev->ncmd_timer);
>
> --
> 2.30.2
>

This fixes the issue I described in [1]. I.e. The kernel no longer
freezes while going to suspend.
Tested-by: Max Krummenacher <max.krummenacher@toradex.com>

Thanks!
Max
