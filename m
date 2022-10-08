Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9065F84E4
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 13:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiJHLJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 07:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiJHLJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 07:09:30 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D05481FE;
        Sat,  8 Oct 2022 04:09:28 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1665227367; bh=lJSY4J+C5oo5opE5ORO0r3nywmHEQiHiYcIaI/WpDGQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=S8OT1XLTp0+3zOP/XglmVMZRl7xsVIqBbSO/U+15RUSN3POlJPbTyfiajSLpGRvYM
         Y4yf0WZCI+CA5HhE6PQDSkq2e0TI1YKWkARInRrkzmhnWFxp677xlapvCmflwD8ap/
         GbJ+jq8C73j30nVep2IUjiNM1mkcRb3zVZX4EpR4/Skif/5uXKBsDN58/ve6a5IT/t
         Fsafk/m/F1ldrPZoucarFMhQfIHwtdYHHQb0FAzmsxf5gCKJDwEPtIJGN4g0vxpxyq
         Ta8LVd6XysP63q+4n+NeO8Zr0CLlHpAn/1Qdk0TyRrDfHOtRsiUoSTlOVNPnXiPMKV
         0pcPYi3lYwbsQ==
To:     Fedor Pchelkin <pchelkin@ispras.ru>, Kalle Valo <kvalo@kernel.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v3] ath9k: verify the expected usb_endpoints are present
In-Reply-To: <20221007212916.267004-1-pchelkin@ispras.ru>
References: <20221007212916.267004-1-pchelkin@ispras.ru>
Date:   Sat, 08 Oct 2022 13:09:26 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87v8oushax.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
> v1->v2: use reverse x-mas tree ordering of the variable definitions
> v2->v3: fix tab
>
>  drivers/net/wireless/ath/ath9k/hif_usb.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
> index 4d9002a9d082..7bbbeb411056 100644
> --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
> @@ -1329,10 +1329,24 @@ static int send_eject_command(struct usb_interface *interface)
>  static int ath9k_hif_usb_probe(struct usb_interface *interface,
>  			       const struct usb_device_id *id)
>  {
> +	struct usb_endpoint_descriptor *bulk_in, *bulk_out, *int_in, *int_out;
>  	struct usb_device *udev = interface_to_usbdev(interface);
> +	struct usb_host_interface *alt;
>  	struct hif_device_usb *hif_dev;
>  	int ret = 0;
>     

Hmm, so your patch has spaces in this empty line which are not in the
actual source file, which causes 'git am' to choke on the patch... :(

Not sure what is causing this, but could you please see if you can fix
it and resend?

-Toke
