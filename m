Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265BC257DF1
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 17:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbgHaPt7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 31 Aug 2020 11:49:59 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:46162 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728251AbgHaPt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 11:49:58 -0400
Received: from marcel-macbook.fritz.box (p4ff9f430.dip0.t-ipconnect.de [79.249.244.48])
        by mail.holtmann.org (Postfix) with ESMTPSA id 8FED0CECCD;
        Mon, 31 Aug 2020 18:00:04 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH] Bluetooth: Clear suspend tasks on unregister
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200826154719.1.I24fb6cc377d03d64d74f83cec748afd12ee33e37@changeid>
Date:   Mon, 31 Aug 2020 17:49:54 +0200
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Miao-chen Chou <mcchou@chromium.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <A69701BE-FBB3-4053-8187-618C0BD4B380@holtmann.org>
References: <20200826154719.1.I24fb6cc377d03d64d74f83cec748afd12ee33e37@changeid>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

> While unregistering, make sure to clear the suspend tasks before
> cancelling the work. If the unregister is called during resume from
> suspend, this will unnecessarily add 2s to the resume time otherwise.
> 
> Fixes: 4e8c36c3b0d73d (Bluetooth: Fix suspend notifier race)
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> ---
> This was discovered with RT8822CE using the btusb driver. This chipset
> will reset on resume during system suspend and was unnecessarily adding
> 2s to every resume. Since we're unregistering anyway, there's no harm in
> just clearing the pending events.
> 
> net/bluetooth/hci_core.c | 11 +++++++++++
> 1 file changed, 11 insertions(+)
> 
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index 68bfe57b66250f..ed4cb3479433c0 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -3442,6 +3442,16 @@ void hci_copy_identity_address(struct hci_dev *hdev, bdaddr_t *bdaddr,
> 	}
> }
> 
> +static void hci_suspend_clear_tasks(struct hci_dev *hdev)
> +{
> +	int i;
> +
> +	for (i = 0; i < __SUSPEND_NUM_TASKS; ++i)
> +		clear_bit(i, hdev->suspend_tasks);

I prefer i++ instead of ++i.

Regards

Marcel

