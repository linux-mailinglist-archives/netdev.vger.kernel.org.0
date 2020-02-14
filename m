Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8379915D319
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 08:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbgBNHqC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 14 Feb 2020 02:46:02 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:40094 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbgBNHqC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 02:46:02 -0500
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id CDD81CECE1;
        Fri, 14 Feb 2020 08:55:23 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [Bluez PATCH v4] bluetooth: secure bluetooth stack from bluedump
 attack
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200214134922.Bluez.v4.1.Ia71869d2f3e19a76a6a352c61088a085a1d41ba6@changeid>
Date:   Fri, 14 Feb 2020 08:45:59 +0100
Cc:     Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        chromeos-bluetooth-upstreaming@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <54398306-13C8-47C2-A37D-946C757A0C3D@holtmann.org>
References: <20200214134922.Bluez.v4.1.Ia71869d2f3e19a76a6a352c61088a085a1d41ba6@changeid>
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
> Changes in v4:
> - optimise the check in smp.c.
> 
> Changes in v3:
> - Change confirm_hint from 2 to 1
> - Fix coding style (declaration order)
> 
> Changes in v2:
> - Remove the HCI_PERMIT_JUST_WORK_REPAIR debugfs option
> - Fix the added code in classic
> - Add a similar fix for LE
> 
> net/bluetooth/hci_event.c | 10 ++++++++++
> net/bluetooth/smp.c       | 19 +++++++++++++++++++
> 2 files changed, 29 insertions(+)
> 
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index 2c833dae9366..e6982f4f51ea 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -4571,6 +4571,16 @@ static void hci_user_confirm_request_evt(struct hci_dev *hdev,
> 			goto confirm;
> 		}
> 
> +		/* If there already exists link key in local host, leave the
> +		 * decision to user space since the remote device could be
> +		 * legitimate or malicious.
> +		 */
> +		if (hci_find_link_key(hdev, &ev->bdaddr)) {
> +			bt_dev_warn(hdev, "Local host already has link key");

I would turn this into bt_dev_dbg actually.

> +			confirm_hint = 1;
> +			goto confirm;
> +		}
> +
> 		BT_DBG("Auto-accept of user confirmation with %ums delay",
> 		       hdev->auto_accept_delay);
> 
> diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
> index 2cba6e07c02b..bea64071bdd1 100644
> --- a/net/bluetooth/smp.c
> +++ b/net/bluetooth/smp.c
> @@ -2192,6 +2192,25 @@ static u8 smp_cmd_pairing_random(struct l2cap_conn *conn, struct sk_buff *skb)
> 		smp_send_cmd(conn, SMP_CMD_PAIRING_RANDOM, sizeof(smp->prnd),
> 			     smp->prnd);
> 		SMP_ALLOW_CMD(smp, SMP_CMD_DHKEY_CHECK);
> +
> +		/* May need further confirmation for Just-Works pairing  */

This comment is misleading and has two spaces at the end. My proposal would be this:

		/* Only Just-Works pairing requires extra checks */
> +		if (smp->method != JUST_WORKS)
> +			goto mackey_and_ltk;
> +

> +		/* If there already exists link key in local host, leave the
> +		 * decision to user space since the remote device could be
> +		 * legitimate or malicious.
> +		 */
> +		if (hci_find_ltk(hcon->hdev, &hcon->dst, hcon->dst_type,
> +				 hcon->role)) {
> +			err = mgmt_user_confirm_request(hcon->hdev, &hcon->dst,
> +							hcon->type,
> +							hcon->dst_type, passkey,
> +							1);
> +			if (err)
> +				return SMP_UNSPECIFIED;
> +			set_bit(SMP_FLAG_WAIT_USER, &smp->flags);
> +		}
> 	}

Rest looks good. Either you send me a v5 or tell me to fix it up before applying the patch.

Regards

Marcel

