Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20001144244
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 17:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729165AbgAUQfy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 Jan 2020 11:35:54 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:58810 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbgAUQfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 11:35:54 -0500
Received: from marcel-macpro.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 00A92CECE3;
        Tue, 21 Jan 2020 17:45:10 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.40.2.2.4\))
Subject: Re: [RFC PATCH 1/2] Bluetooth: Add mgmt op set_wake_capable
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200117132623.RFC.1.I797e2f4cb824299043e771f3ab9cef86ee09f4db@changeid>
Date:   Tue, 21 Jan 2020 17:35:51 +0100
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>, alainm@chromium.org,
        linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <ACAE240C-345B-43F9-B6C8-8967AF436CE9@holtmann.org>
References: <20200117212705.57436-1-abhishekpandit@chromium.org>
 <20200117132623.RFC.1.I797e2f4cb824299043e771f3ab9cef86ee09f4db@changeid>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
X-Mailer: Apple Mail (2.3608.40.2.2.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

> When the system is suspended, only some connected Bluetooth devices
> cause user input that should wake the system (mostly HID devices). Add
> a list to keep track of devices that can wake the system and add
> a management API to let userspace tell the kernel whether a device is
> wake capable or not.
> 
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> ---
> 
> include/net/bluetooth/hci_core.h |  1 +
> include/net/bluetooth/mgmt.h     |  7 ++++++
> net/bluetooth/hci_core.c         |  1 +
> net/bluetooth/mgmt.c             | 42 ++++++++++++++++++++++++++++++++
> 4 files changed, 51 insertions(+)
> 
> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> index 89ecf0a80aa1..ce4bebcb0265 100644
> --- a/include/net/bluetooth/hci_core.h
> +++ b/include/net/bluetooth/hci_core.h
> @@ -394,6 +394,7 @@ struct hci_dev {
> 	struct list_head	mgmt_pending;
> 	struct list_head	blacklist;
> 	struct list_head	whitelist;
> +	struct list_head	wakeable;
> 	struct list_head	uuids;
> 	struct list_head	link_keys;
> 	struct list_head	long_term_keys;
> diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
> index a90666af05bd..283ba5320bdb 100644
> --- a/include/net/bluetooth/mgmt.h
> +++ b/include/net/bluetooth/mgmt.h
> @@ -671,6 +671,13 @@ struct mgmt_cp_set_blocked_keys {
> } __packed;
> #define MGMT_OP_SET_BLOCKED_KEYS_SIZE 2
> 
> +#define MGMT_OP_SET_WAKE_CAPABLE	0x0047
> +#define MGMT_SET_WAKE_CAPABLE_SIZE	8
> +struct mgmt_cp_set_wake_capable {
> +	struct mgmt_addr_info addr;
> +	u8 wake_capable;
> +} __packed;
> +

please also send a patch for doc/mgmt-api.txt describing these opcodes. I would also like to have the discussion if it might be better to add an extra Action parameter to Add Device. We want to differentiate between allow incoming connection that allows to wakeup and the one that doesn’t.

Another option is to create an Add Extended Device command. Main reason here is that I don’t want to end up in the situation where you have to add a device and then send another 10 commands to set its features.

> #define MGMT_EV_CMD_COMPLETE		0x0001
> struct mgmt_ev_cmd_complete {
> 	__le16	opcode;
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index 1ca7508b6ca7..7057b9b65173 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -3299,6 +3299,7 @@ struct hci_dev *hci_alloc_dev(void)
> 	INIT_LIST_HEAD(&hdev->mgmt_pending);
> 	INIT_LIST_HEAD(&hdev->blacklist);
> 	INIT_LIST_HEAD(&hdev->whitelist);
> +	INIT_LIST_HEAD(&hdev->wakeable);
> 	INIT_LIST_HEAD(&hdev->uuids);
> 	INIT_LIST_HEAD(&hdev->link_keys);
> 	INIT_LIST_HEAD(&hdev->long_term_keys);
> diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
> index 0dc610faab70..95092130f16c 100644
> --- a/net/bluetooth/mgmt.c
> +++ b/net/bluetooth/mgmt.c
> @@ -106,7 +106,10 @@ static const u16 mgmt_commands[] = {
> 	MGMT_OP_START_LIMITED_DISCOVERY,
> 	MGMT_OP_READ_EXT_INFO,
> 	MGMT_OP_SET_APPEARANCE,
> +	MGMT_OP_GET_PHY_CONFIGURATION,
> +	MGMT_OP_SET_PHY_CONFIGURATION,

These are unrelated to this patch.

> 	MGMT_OP_SET_BLOCKED_KEYS,
> +	MGMT_OP_SET_WAKE_CAPABLE,
> };
> 
> static const u16 mgmt_events[] = {
> @@ -4663,6 +4666,37 @@ static int set_fast_connectable(struct sock *sk, struct hci_dev *hdev,
> 	return err;
> }
> 
> +static int set_wake_capable(struct sock *sk, struct hci_dev *hdev, void *data,
> +			    u16 len)
> +{
> +	int err;
> +	u8 status;
> +	struct mgmt_cp_set_wake_capable *cp = data;
> +	u8 addr_type = cp->addr.type == BDADDR_BREDR ?
> +			       cp->addr.type :
> +			       le_addr_type(cp->addr.type);
> +
> +	BT_DBG("Set wake capable %pMR (type 0x%x) = 0x%x\n", &cp->addr.bdaddr,
> +	       addr_type, cp->wake_capable);
> +
> +	if (cp->wake_capable)
> +		err = hci_bdaddr_list_add(&hdev->wakeable, &cp->addr.bdaddr,
> +					  addr_type);
> +	else
> +		err = hci_bdaddr_list_del(&hdev->wakeable, &cp->addr.bdaddr,
> +					  addr_type);
> +
> +	if (!err || err == -EEXIST || err == -ENOENT)
> +		status = MGMT_STATUS_SUCCESS;
> +	else
> +		status = MGMT_STATUS_FAILED;
> +
> +	err = mgmt_cmd_complete(sk, hdev->id, MGMT_OP_SET_WAKE_CAPABLE, status,
> +				cp, sizeof(*cp));
> +
> +	return err;
> +}
> +
> static void set_bredr_complete(struct hci_dev *hdev, u8 status, u16 opcode)
> {
> 	struct mgmt_pending_cmd *cmd;
> @@ -5791,6 +5825,13 @@ static int remove_device(struct sock *sk, struct hci_dev *hdev,
> 			err = hci_bdaddr_list_del(&hdev->whitelist,
> 						  &cp->addr.bdaddr,
> 						  cp->addr.type);
> +
> +			/* Don't check result since it either succeeds or device
> +			 * wasn't there (not wakeable or invalid params as
> +			 * covered by deleting from whitelist).
> +			 */
> +			hci_bdaddr_list_del(&hdev->wakeable, &cp->addr.bdaddr,
> +					    cp->addr.type);
> 			if (err) {
> 				err = mgmt_cmd_complete(sk, hdev->id,
> 							MGMT_OP_REMOVE_DEVICE,
> @@ -6990,6 +7031,7 @@ static const struct hci_mgmt_handler mgmt_handlers[] = {
> 	{ set_phy_configuration,   MGMT_SET_PHY_CONFIGURATION_SIZE },
> 	{ set_blocked_keys,	   MGMT_OP_SET_BLOCKED_KEYS_SIZE,
> 						HCI_MGMT_VAR_LEN },
> +	{ set_wake_capable,	   MGMT_SET_WAKE_CAPABLE_SIZE },
> };
> 

Regards

Marcel

