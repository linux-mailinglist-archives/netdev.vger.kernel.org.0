Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE61156363
	for <lists+netdev@lfdr.de>; Sat,  8 Feb 2020 09:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgBHIVQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 8 Feb 2020 03:21:16 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:34360 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbgBHIVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Feb 2020 03:21:15 -0500
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 0A1D9CECEF;
        Sat,  8 Feb 2020 09:30:36 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [Bluez PATCH v2] bluetooth: secure bluetooth stack from bluedump
 attack
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200207180348.Bluez.v2.1.Ia71869d2f3e19a76a6a352c61088a085a1d41ba6@changeid>
Date:   Sat, 8 Feb 2020 09:21:13 +0100
Cc:     Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <736C3B5C-627C-4BBD-BA9C-63F4A3D18C5F@holtmann.org>
References: <20200207180348.Bluez.v2.1.Ia71869d2f3e19a76a6a352c61088a085a1d41ba6@changeid>
To:     Howard Chung <howardchung@google.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Howard,

> Attack scenario:
> 1. A Chromebook (let's call this device A) is paired to a legitimate
>   Bluetooth classic device (e.g. a speaker) (let's call this device
>   B).
> 2. A malicious device (let's call this device C) pretends to be the
>   Bluetooth speaker by using the same BT address.
> 3. If device A is not currently connected to device B, device A will
>   be ready to accept connection from device B in the background
>   (technically, doing Page Scan).
> 4. Therefore, device C can initiate connection to device A
>   (because device A is doing Page Scan) and device A will accept the
>   connection because device A trusts device C's address which is the
>   same as device B's address.
> 5. Device C won't be able to communicate at any high level Bluetooth
>   profile with device A because device A enforces that device C is
>   encrypted with their common Link Key, which device C doesn't have.
>   But device C can initiate pairing with device A with just-works
>   model without requiring user interaction (there is only pairing
>   notification). After pairing, device A now trusts device C with a
>   new different link key, common between device A and C.
> 6. From now on, device A trusts device C, so device C can at anytime
>   connect to device A to do any kind of high-level hijacking, e.g.
>   speaker hijack or mouse/keyboard hijack.
> 
> Since we don't know whether the repairing is legitimate or not,
> leave the decision to user space if all the conditions below are met.
> - the pairing is initialized by peer
> - the authorization method is just-work
> - host already had the link key to the peer
> 
> Signed-off-by: Howard Chung <howardchung@google.com>
> ---
> 
> Changes in v2:
> - Remove the HCI_PERMIT_JUST_WORK_REPAIR debugfs option
> - Fix the added code in classic
> - Add a similar fix for LE
> 
> net/bluetooth/hci_event.c | 10 ++++++++++
> net/bluetooth/smp.c       | 18 ++++++++++++++++++
> 2 files changed, 28 insertions(+)
> 
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index 6ddc4a74a5e4..334d7ccd8d6e 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -4557,6 +4557,16 @@ static void hci_user_confirm_request_evt(struct hci_dev *hdev,
> 			goto confirm;
> 		}
> 
> +		/* If there already exists link key in local host, leave the
> +		 * decision to user space since the remote device could be
> +		 * legitimate or malicious.
> +		 */
> +		if (hci_find_link_key(hdev, &ev->bdaddr)) {
> +			bt_dev_warn(hdev, "Local host already has link key");
> +			confirm_hint = 2;
> +			goto confirm;
> +		}
> +

we need to document the meaning and handling of confirm_hint 2 in doc/mgmt-api.txt.

Maybe it is better to introduce a new mgmt event for this. Otherwise this looks like a nice and simple approach to put the actual policy into the daemon.

> 		BT_DBG("Auto-accept of user confirmation with %ums delay",
> 		       hdev->auto_accept_delay);
> 
> diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
> index 83449a88a182..f58426dea4de 100644
> --- a/net/bluetooth/smp.c
> +++ b/net/bluetooth/smp.c
> @@ -2118,6 +2118,7 @@ static u8 smp_cmd_pairing_random(struct l2cap_conn *conn, struct sk_buff *skb)
> 	u8 *pkax, *pkbx, *na, *nb;
> 	u32 passkey;
> 	int err;
> +	struct smp_ltk *key;

This is tiny style thing, but generally, we put the structs earlier and let the int err be the last.

> 
> 	BT_DBG("conn %p", conn);
> 
> @@ -2168,6 +2169,23 @@ static u8 smp_cmd_pairing_random(struct l2cap_conn *conn, struct sk_buff *skb)
> 		smp_send_cmd(conn, SMP_CMD_PAIRING_RANDOM, sizeof(smp->prnd),
> 			     smp->prnd);
> 		SMP_ALLOW_CMD(smp, SMP_CMD_DHKEY_CHECK);
> +
> +		key = hci_find_ltk(hcon->hdev, &hcon->dst, hcon->dst_type,
> +				   hcon->role);
> +
> +		/* If there already exists link key in local host, leave the
> +		 * decision to user space since the remote device could be
> +		 * legitimate or malicious.
> +		 */
> +		if (smp->method == JUST_WORKS && key) {
> +			err = mgmt_user_confirm_request(hcon->hdev, &hcon->dst,
> +							hcon->type,
> +							hcon->dst_type, passkey,
> +							2);
> +			if (err)
> +				return SMP_UNSPECIFIED;
> +			set_bit(SMP_FLAG_WAIT_USER, &smp->flags);
> +		}
> 	}

This limits this to outgoing connections. Is this intentional?

Regards

Marcel

