Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E78AD32C466
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354310AbhCDANi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 3 Mar 2021 19:13:38 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:46616 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244375AbhCCPvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 10:51:03 -0500
Received: from marcel-macbook.holtmann.net (p4ff9fb90.dip0.t-ipconnect.de [79.249.251.144])
        by mail.holtmann.org (Postfix) with ESMTPSA id BE66CCED03;
        Wed,  3 Mar 2021 16:54:55 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH v2 1/1] Bluetooth: Remove unneeded commands for suspend
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210302104931.v2.1.Ifcac8bd85b5339135af8e08370bacecc518b1c35@changeid>
Date:   Wed, 3 Mar 2021 16:47:21 +0100
Cc:     CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Bluetooth Kernel Mailing List 
        <linux-bluetooth@vger.kernel.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <31B90F9D-E234-4825-A955-1CBA712E5188@holtmann.org>
References: <20210302184936.619740-1-abhishekpandit@chromium.org>
 <20210302104931.v2.1.Ifcac8bd85b5339135af8e08370bacecc518b1c35@changeid>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

> During suspend, there are a few scan enable and set event filter
> commands that don't need to be sent unless there are actual BR/EDR
> devices capable of waking the system. Check the HCI_PSCAN bit before
> writing scan enable and use a new dev flag, HCI_EVENT_FILTER_CONFIGURED
> to control whether to clear the event filter.
> 
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Reviewed-by: Archie Pusaka <apusaka@chromium.org>
> Reviewed-by: Alain Michaud <alainm@chromium.org>
> ---
> 
> Changes in v2:
> * Removed hci_dev_lock from hci_cc_set_event_filter since flags are
>  set/cleared atomically
> 
> include/net/bluetooth/hci.h |  1 +
> net/bluetooth/hci_event.c   | 24 ++++++++++++++++++++
> net/bluetooth/hci_request.c | 44 +++++++++++++++++++++++--------------
> 3 files changed, 52 insertions(+), 17 deletions(-)
> 
> diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
> index ba2f439bc04d34..ea4ae551c42687 100644
> --- a/include/net/bluetooth/hci.h
> +++ b/include/net/bluetooth/hci.h
> @@ -320,6 +320,7 @@ enum {
> 	HCI_BREDR_ENABLED,
> 	HCI_LE_SCAN_INTERRUPTED,
> 	HCI_WIDEBAND_SPEECH_ENABLED,
> +	HCI_EVENT_FILTER_CONFIGURED,
> 
> 	HCI_DUT_MODE,
> 	HCI_VENDOR_DIAG,
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index 67668be3461e93..6eadc999ea1474 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -395,6 +395,26 @@ static void hci_cc_write_scan_enable(struct hci_dev *hdev, struct sk_buff *skb)
> 	hci_dev_unlock(hdev);
> }
> 
> +static void hci_cc_set_event_filter(struct hci_dev *hdev, struct sk_buff *skb)
> +{
> +	__u8 status = *((__u8 *)skb->data);
> +	struct hci_cp_set_event_filter *cp;
> +	void *sent;
> +
> +	BT_DBG("%s status 0x%2.2x", hdev->name, status);
> +
> +	sent = hci_sent_cmd_data(hdev, HCI_OP_SET_EVENT_FLT);
> +	if (!sent || status)
> +		return;

can we do this:

	if (status)
		return;

	sent = hci_..
	if (!sent)
		return;

Regards

Marcel

