Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 703705F7C46
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 19:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiJGRdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 13:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiJGRdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 13:33:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA4BC8208;
        Fri,  7 Oct 2022 10:33:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BAD4CB81B7A;
        Fri,  7 Oct 2022 17:33:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9E5C433C1;
        Fri,  7 Oct 2022 17:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665164026;
        bh=ai9geBM+T5deXh+kErG0TBEXlcftmuotZdSBMdiAKbU=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=TzyhOXvjHjPHKRHaLYB+yr62DgkQYCbfuXHbseePRo+pvFQXt9QziOkBWGxX920Xi
         26dHnUHq0vpBbuAi/CGZMw4SYFjkwsiJoaDX4RiQptXl6fMaJWhoyCuvR+dW9Dm1Tt
         zP8z/E0U1bhYjEk38iLd2ldrzVOUeIxNGuf+qNMqpN1wMCg4Tc7Cnp7R78Q+6VuCHg
         AQB8ztD4TVJ9kuGUU5maoA+I1HuzGxsl7QYQ1eZS7smZDAZENRxFNEdbuKgpOTDKpf
         5mKsY4Jm/qVMc1D1RJQCrSCQ7aBhKRtCzfm3wc+7rCKXCyL8z5BEYjQ7/XEozdPHeq
         gHuPUDmzPFe5w==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id F012664EF21; Fri,  7 Oct 2022 19:33:43 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     Fedor Pchelkin <pchelkin@ispras.ru>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        ldv-project@linuxtesting.org,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] ath9k: verify the expected usb_endpoints are present
In-Reply-To: <20220903120424.12472-1-pchelkin@ispras.ru>
References: <20220903120424.12472-1-pchelkin@ispras.ru>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 07 Oct 2022 19:33:43 +0200
Message-ID: <87o7unczd4.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fedor Pchelkin <pchelkin@ispras.ru> writes:

> The bug arises when a USB device claims to be an ATH9K but doesn't
> have the expected endpoints. (In this case there was an interrupt
> endpoint where the driver expected a bulk endpoint.) The kernel
> needs to be able to handle such devices without getting an internal error.
>
> usb 1-1: BOGUS urb xfer, pipe 3 != type 1
> WARNING: CPU: 3 PID: 500 at drivers/usb/core/urb.c:493 usb_submit_urb+0xce2/0x1430 drivers/usb/core/urb.c:493
> Modules linked in:
> CPU: 3 PID: 500 Comm: kworker/3:2 Not tainted 5.10.135-syzkaller #0
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
> Workqueue: events request_firmware_work_func
> RIP: 0010:usb_submit_urb+0xce2/0x1430 drivers/usb/core/urb.c:493
> Call Trace:
>  ath9k_hif_usb_alloc_rx_urbs drivers/net/wireless/ath/ath9k/hif_usb.c:908 [inline]
>  ath9k_hif_usb_alloc_urbs+0x75e/0x1010 drivers/net/wireless/ath/ath9k/hif_usb.c:1019
>  ath9k_hif_usb_dev_init drivers/net/wireless/ath/ath9k/hif_usb.c:1109 [inline]
>  ath9k_hif_usb_firmware_cb+0x142/0x530 drivers/net/wireless/ath/ath9k/hif_usb.c:1242
>  request_firmware_work_func+0x12e/0x240 drivers/base/firmware_loader/main.c:1097
>  process_one_work+0x9af/0x1600 kernel/workqueue.c:2279
>  worker_thread+0x61d/0x12f0 kernel/workqueue.c:2425
>  kthread+0x3b4/0x4a0 kernel/kthread.c:313
>  ret_from_fork+0x22/0x30 arch/x86/entry/entry_64.S:299
>
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
>
> Suggested-by: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/net/wireless/ath/ath9k/hif_usb.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
> index 4d9002a9d082..2b26acf409fc 100644
> --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
> @@ -1332,6 +1332,20 @@ static int ath9k_hif_usb_probe(struct usb_interface *interface,
>  	struct usb_device *udev = interface_to_usbdev(interface);
>  	struct hif_device_usb *hif_dev;
>  	int ret = 0;
> +	struct usb_host_interface *alt;
> +	struct usb_endpoint_descriptor *bulk_in, *bulk_out, *int_in, *int_out;

Please maintain the reverse x-mas tree ordering of the variable
definitions. See:
https://docs.kernel.org/process/maintainer-netdev.html#what-is-reverse-xmas-tree

Also, please make sure to add me directly to the Cc list when
resubmitting. Thanks!

-Toke
