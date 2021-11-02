Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0740F442FAA
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 15:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbhKBOD0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 2 Nov 2021 10:03:26 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:47184 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbhKBOD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 10:03:26 -0400
Received: from smtpclient.apple (p4fefc15c.dip0.t-ipconnect.de [79.239.193.92])
        by mail.holtmann.org (Postfix) with ESMTPSA id 67872CECF0;
        Tue,  2 Nov 2021 15:00:47 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.20.0.1.32\))
Subject: Re: [PATCH] Bluetooth: Fix receiving
 HCI_LE_Advertising_Set_Terminated event
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20211102192742.1.I3ba1a76d72da5a813cf6e6f219838c9ef28c5eaa@changeid>
Date:   Tue, 2 Nov 2021 15:00:46 +0100
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <4049F5B5-D5A7-4F60-A33D-F22B601E7064@holtmann.org>
References: <20211102192742.1.I3ba1a76d72da5a813cf6e6f219838c9ef28c5eaa@changeid>
To:     Archie Pusaka <apusaka@google.com>
X-Mailer: Apple Mail (2.3693.20.0.1.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

> This event is received when the controller stops advertising,
> specifically for these three reasons:
> (a) Connection is successfully created (success).
> (b) Timeout is reached (error).
> (c) Number of advertising events is reached (error).
> (*) This event is NOT generated when the host stops the advertisement.
> Refer to the BT spec ver 5.3 vol 4 part E sec 7.7.65.18. Note that the
> section was revised from BT spec ver 5.0 vol 2 part E sec 7.7.65.18
> which was ambiguous about (*).
> 
> Some chips (e.g. RTL8822CE) send this event when the host stops the
> advertisement with status = HCI_ERROR_CANCELLED_BY_HOST (due to (*)
> above). This is treated as an error and the advertisement will be
> removed and userspace will be informed via MGMT event.
> 
> On suspend, we are supposed to temporarily disable advertisements,
> and continue advertising on resume. However, due to the behavior
> above, the advertisements are removed instead.
> 
> This patch returns early if HCI_ERROR_CANCELLED_BY_HOST is received.

lets include a btmon snippet here to show the faulty behavior.

> 
> Additionally, this patch also clear HCI_LE_ADV if there are no more
> advertising instances after receiving other errors.

Does this really belong in this patch? I think it warrants a separate patch with an appropriate Fixes: tag. Especially in the case we are working around a firmware bug, this should be separate. It gives us a better chance to bisect anything if we ever have to.

> 
> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> Reviewed-by: Alain Michaud <alainm@chromium.org>
> 
> ---
> 
> include/net/bluetooth/hci.h |  1 +
> net/bluetooth/hci_event.c   | 12 ++++++++++++
> 2 files changed, 13 insertions(+)
> 
> diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
> index 63065bc01b76..84db6b275231 100644
> --- a/include/net/bluetooth/hci.h
> +++ b/include/net/bluetooth/hci.h
> @@ -566,6 +566,7 @@ enum {
> #define HCI_ERROR_INVALID_LL_PARAMS	0x1e
> #define HCI_ERROR_UNSPECIFIED		0x1f
> #define HCI_ERROR_ADVERTISING_TIMEOUT	0x3c
> +#define HCI_ERROR_CANCELLED_BY_HOST	0x44
> 
> /* Flow control modes */
> #define HCI_FLOW_CTL_MODE_PACKET_BASED	0x00
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index d4b75a6cfeee..150b50677790 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -5538,6 +5538,14 @@ static void hci_le_ext_adv_term_evt(struct hci_dev *hdev, struct sk_buff *skb)
> 
> 	adv = hci_find_adv_instance(hdev, ev->handle);
> 
> +	/* Some chips (e.g. RTL8822CE) emit HCI_ERROR_CANCELLED_BY_HOST. This
> +	 * event is being fired as a result of a hci_cp_le_set_ext_adv_enable
> +	 * disable request, which will have its own callback and cleanup via
> +	 * the hci_cc_le_set_ext_adv_enable path.
> +	 */

I am not in favor of pointing fingers at bad hardware in the source code of core (that belongs in a commit message). Blaming hardware is really up to the drivers. So I would rather phrase it like this:

	/* The Bluetooth Core 5.3 specification clearly states that this event
	 * shall not be sent when the Host disables the advertising set. So in
	 * case of HCI_ERROR_CANCELLED_BY_HOST, just ignore the event.
	 *
	 * When the Host disables an advertising set, all cleanup is done via
	 * its command callback and not needed to be duplicated here.
	 */

> +	if (ev->status == HCI_ERROR_CANCELLED_BY_HOST)
> +		return;
> +

And since this is clearly an implementation issue, the manufactures can issue a firmware fix for this. So lets be verbose and complain about it.

	if (ev->status == HCI_ERRROR..) {
		bt_dev_warn_ratelimited(hdev, “Unexpected advertising set terminated event”);
		return;
	}

> 	if (ev->status) {
> 		if (!adv)
> 			return;
> @@ -5546,6 +5554,10 @@ static void hci_le_ext_adv_term_evt(struct hci_dev *hdev, struct sk_buff *skb)
> 		hci_remove_adv_instance(hdev, ev->handle);
> 		mgmt_advertising_removed(NULL, hdev, ev->handle);
> 
> +		/* If we are no longer advertising, clear HCI_LE_ADV */
> +		if (list_empty(&hdev->adv_instances))
> +			hci_dev_clear_flag(hdev, HCI_LE_ADV);
> +

See comment above why this might be better suited for a separate patch.

Regards

Marcel

