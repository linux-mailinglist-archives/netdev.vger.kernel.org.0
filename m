Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90DEF3EDA2D
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 17:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237060AbhHPPuK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 16 Aug 2021 11:50:10 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:53563 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235241AbhHPPuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 11:50:02 -0400
Received: from smtpclient.apple (p5b3d23f8.dip0.t-ipconnect.de [91.61.35.248])
        by mail.holtmann.org (Postfix) with ESMTPSA id D0005CECC8;
        Mon, 16 Aug 2021 17:49:25 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [PATCH v2] Bluetooth: Move shutdown callback before flushing tx
 and rx queue
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210810045315.184383-1-kai.heng.feng@canonical.com>
Date:   Mon, 16 Aug 2021 17:49:25 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Mattijs Korpershoek <mkorpershoek@baylibre.com>,
        Hsin-Yi Wang <hsinyi@chromium.org>,
        Guenter Roeck <linux@roeck-us.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:BLUETOOTH SUBSYSTEM" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <453AB6D8-9CA8-42B8-9807-5AC249E8618B@holtmann.org>
References: <20210810045315.184383-1-kai.heng.feng@canonical.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kai-Heng,

> Commit 0ea9fd001a14 ("Bluetooth: Shutdown controller after workqueues
> are flushed or cancelled") introduced a regression that makes mtkbtsdio
> driver stops working:
> [   36.593956] Bluetooth: hci0: Firmware already downloaded
> [   46.814613] Bluetooth: hci0: Execution of wmt command timed out
> [   46.814619] Bluetooth: hci0: Failed to send wmt func ctrl (-110)
> 
> The shutdown callback depends on the result of hdev->rx_work, so we
> should call it before flushing rx_work:
> -> btmtksdio_shutdown()
> -> mtk_hci_wmt_sync()
>  -> __hci_cmd_send()
>   -> wait for BTMTKSDIO_TX_WAIT_VND_EVT gets cleared
> 
> -> btmtksdio_recv_event()
> -> hci_recv_frame()
>  -> queue_work(hdev->workqueue, &hdev->rx_work)
>   -> clears BTMTKSDIO_TX_WAIT_VND_EVT
> 
> So move the shutdown callback before flushing TX/RX queue to resolve the
> issue.
> 
> Reported-and-tested-by: Mattijs Korpershoek <mkorpershoek@baylibre.com>
> Tested-by: Hsin-Yi Wang <hsinyi@chromium.org>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Fixes: 0ea9fd001a14 ("Bluetooth: Shutdown controller after workqueues are flushed or cancelled")
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
> v2: 
> Move the shutdown callback before clearing HCI_UP, otherwise 1)
> shutdown callback won't be called and 2) other routines that depend on
> HCI_UP won't work.
> 
> net/bluetooth/hci_core.c | 16 ++++++++--------
> 1 file changed, 8 insertions(+), 8 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

