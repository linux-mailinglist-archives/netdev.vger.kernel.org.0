Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 868E45FABB7
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 06:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiJKEoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 00:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiJKEoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 00:44:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E3B3740C;
        Mon, 10 Oct 2022 21:44:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 248AB61055;
        Tue, 11 Oct 2022 04:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858DDC433C1;
        Tue, 11 Oct 2022 04:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665463456;
        bh=7TqsL4hnKmjV7++OVS50pm4RzZd1na3jTJfA3fxJHjI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Rm2S/KmMXj702Hrka5YmeTlQFUlrJ98+bIYCztj35ROZdsxZT7ueKK7jPLrAzVPIH
         ePfoC5rA6lql5mUaQvhbk/QVANzSWHsvN2S7erbeb8q/WyOc6cuo2gvFced4mcBog/
         EPdPnhxIk6U8OCweBO7GhUaIkXArcm0yEtA4fPuZera4iSm8V/tT2QX9B1xhXzxC70
         Y+RIXiFWSFPVFBkgq27VOSgNRlA6cPGNh5rF0JpQUdRnwpTuvH2TTuq5rbcoAKs/oz
         KLEUZWNY9zvN6Rp9zvB25qFKM6HzVbVBZ3q0lYW+HmgqXwQB4ryzoPbteA9cTyEqvs
         aNaBn+2tLHhag==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5] ath9k: verify the expected usb_endpoints are present
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221008211532.74583-1-pchelkin@ispras.ru>
References: <20221008211532.74583-1-pchelkin@ispras.ru>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Fedor Pchelkin <pchelkin@ispras.ru>,
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
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166546344936.5539.12313131081543335412.kvalo@kernel.org>
Date:   Tue, 11 Oct 2022 04:44:13 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fedor Pchelkin <pchelkin@ispras.ru> wrote:

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
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

16ef02bad239 wifi: ath9k: verify the expected usb_endpoints are present

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221008211532.74583-1-pchelkin@ispras.ru/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

