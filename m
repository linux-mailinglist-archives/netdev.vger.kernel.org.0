Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE235F885D
	for <lists+netdev@lfdr.de>; Sun,  9 Oct 2022 00:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbiJHWns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 18:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiJHWnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 18:43:47 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9882D1D0DE;
        Sat,  8 Oct 2022 15:43:46 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1665269024; bh=QhPBEsxjlXKa98NCQhGojdwNDJyOZ1xIqlZEGWTt4jQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=ru2QbgSCAOgWwNHYV+mCYGsCa+EXvU+TJ+rqtewktKM+1fHSwV9zwWMQC0LzEESMD
         J91kZqKup20HblJ0VcJKOt32ak9mimQCGezLN6fq6xkRAMxpAAROD5bl2P7cF2uAo6
         +7Dpne9t81YeZK/clA78yHVwT+QWaMX7jehjqO7HH/H2JohIvlVqXOzGmSAifN2bbt
         y8Xfo9y1c+sPi27v9jouyGvwLoEvy4q3QqMfSCEw5OUeeMo49ROMPNHWOeEArNjLNh
         xMoEE2LnQxjfPqAIFCUOscbGNIj76EJ09ERctIM7t9SCFahtVCdl3X1mt+AApJzY5M
         ygGRrMXuXt4bQ==
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
        Johannes Berg <johannes@sipsolutions.net>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v5] ath9k: verify the expected usb_endpoints are present
In-Reply-To: <20221008211532.74583-1-pchelkin@ispras.ru>
References: <20221008211532.74583-1-pchelkin@ispras.ru>
Date:   Sun, 09 Oct 2022 00:43:43 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87mta6rl5s.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
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
> usb 1-1: BOGUS urb xfer, pipe 3 !=3D type 1
> WARNING: CPU: 3 PID: 500 at drivers/usb/core/urb.c:493 usb_submit_urb+0xc=
e2/0x1430 drivers/usb/core/urb.c:493
> Modules linked in:
> CPU: 3 PID: 500 Comm: kworker/3:2 Not tainted 5.10.135-syzkaller #0
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/0=
1/2014
> Workqueue: events request_firmware_work_func
> RIP: 0010:usb_submit_urb+0xce2/0x1430 drivers/usb/core/urb.c:493
> Call Trace:
>  ath9k_hif_usb_alloc_rx_urbs drivers/net/wireless/ath/ath9k/hif_usb.c:908=
 [inline]
>  ath9k_hif_usb_alloc_urbs+0x75e/0x1010 drivers/net/wireless/ath/ath9k/hif=
_usb.c:1019
>  ath9k_hif_usb_dev_init drivers/net/wireless/ath/ath9k/hif_usb.c:1109 [in=
line]
>  ath9k_hif_usb_firmware_cb+0x142/0x530 drivers/net/wireless/ath/ath9k/hif=
_usb.c:1242
>  request_firmware_work_func+0x12e/0x240 drivers/base/firmware_loader/main=
.c:1097
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

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
