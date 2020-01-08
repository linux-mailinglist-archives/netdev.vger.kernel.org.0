Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F272134E53
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 22:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbgAHVCX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 8 Jan 2020 16:02:23 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:37457 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgAHVCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 16:02:23 -0500
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 6B43BCECFA;
        Wed,  8 Jan 2020 22:11:37 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.40.2.2.4\))
Subject: Re: [Bluez PATCH v1] bluetooth: secure bluetooth stack from bluedump
 attack
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200106181425.Bluez.v1.1.I5ee1ea8e19d41c5bdffb4211aeb9cd9efa5e0a4a@changeid>
Date:   Wed, 8 Jan 2020 22:02:20 +0100
Cc:     BlueZ devel list <linux-bluetooth@vger.kernel.org>,
        chromeos-bluetooth-upstreaming@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <CD07E771-6F40-4158-A0F9-03FC128CDCD3@holtmann.org>
References: <20200106181425.Bluez.v1.1.I5ee1ea8e19d41c5bdffb4211aeb9cd9efa5e0a4a@changeid>
To:     howardchung@google.com
X-Mailer: Apple Mail (2.3608.40.2.2.4)
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
> To fix this, reject the pairing if all the conditions below are met.
> - the pairing is initialized by peer
> - the authorization method is just-work
> - host already had the link key to the peer
> 
> Also create a debugfs option to permit the pairing even the
> conditions above are met.
> 
> Signed-off-by: howardchung <howardchung@google.com>

we prefer full name signed-off-by signatures.

> ---
> 
> include/net/bluetooth/hci.h |  1 +
> net/bluetooth/hci_core.c    | 47 +++++++++++++++++++++++++++++++++++++
> net/bluetooth/hci_event.c   | 12 ++++++++++
> 3 files changed, 60 insertions(+)
> 
> diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
> index 07b6ecedc6ce..4918b79baa41 100644
> --- a/include/net/bluetooth/hci.h
> +++ b/include/net/bluetooth/hci.h
> @@ -283,6 +283,7 @@ enum {
> 	HCI_FORCE_STATIC_ADDR,
> 	HCI_LL_RPA_RESOLUTION,
> 	HCI_CMD_PENDING,
> +	HCI_PERMIT_JUST_WORK_REPAIR,
> 
> 	__HCI_NUM_FLAGS,
> };
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index 9e19d5a3aac8..9014aa567e7b 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -172,10 +172,57 @@ static const struct file_operations vendor_diag_fops = {
> 	.llseek		= default_llseek,
> };
> 
> +static ssize_t permit_just_work_repair_read(struct file *file,
> +					    char __user *user_buf,
> +					    size_t count, loff_t *ppos)
> +{
> +	struct hci_dev *hdev = file->private_data;
> +	char buf[3];
> +
> +	buf[0] = hci_dev_test_flag(hdev, HCI_PERMIT_JUST_WORK_REPAIR) ? 'Y'
> +								      : 'N';
> +	buf[1] = '\n';
> +	buf[2] = '\0';
> +	return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
> +}
> +
> +static ssize_t permit_just_work_repair_write(struct file *file,
> +					     const char __user *user_buf,
> +					     size_t count, loff_t *ppos)
> +{
> +	struct hci_dev *hdev = file->private_data;
> +	char buf[32];
> +	size_t buf_size = min(count, (sizeof(buf) - 1));
> +	bool enable;
> +
> +	if (copy_from_user(buf, user_buf, buf_size))
> +		return -EFAULT;
> +
> +	buf[buf_size] = '\0';
> +	if (strtobool(buf, &enable))
> +		return -EINVAL;
> +
> +	if (enable)
> +		hci_dev_set_flag(hdev, HCI_PERMIT_JUST_WORK_REPAIR);
> +	else
> +		hci_dev_clear_flag(hdev, HCI_PERMIT_JUST_WORK_REPAIR);
> +
> +	return count;
> +}
> +
> +static const struct file_operations permit_just_work_repair_fops = {
> +	.open		= simple_open,
> +	.read		= permit_just_work_repair_read,
> +	.write		= permit_just_work_repair_write,
> +	.llseek		= default_llseek,
> +};
> +
> static void hci_debugfs_create_basic(struct hci_dev *hdev)
> {
> 	debugfs_create_file("dut_mode", 0644, hdev->debugfs, hdev,
> 			    &dut_mode_fops);
> +	debugfs_create_file("permit_just_work_repair", 0644, hdev->debugfs,
> +			    hdev, &permit_just_work_repair_fops);
> 
> 	if (hdev->set_diag)
> 		debugfs_create_file("vendor_diag", 0644, hdev->debugfs, hdev,
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index 6ddc4a74a5e4..898e347e19e0 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -4539,6 +4539,18 @@ static void hci_user_confirm_request_evt(struct hci_dev *hdev,
> 		goto unlock;
> 	}
> 
> +	/* If there already exists link key in local host, terminate the
> +	 * connection by default since the remote device could be malicious.
> +	 * Permit the connection if permit_just_work_repair is enabled.
> +	 */
> +	if (!hci_dev_test_flag(hdev, HCI_PERMIT_JUST_WORK_REPAIR) &&
> +	    hci_find_link_key(hdev, &ev->bdaddr)) {
> +		BT_DBG("Rejecting request: local host already have link key");

Can we use bt_dev_warn() here.

> +		hci_send_cmd(hdev, HCI_OP_USER_CONFIRM_NEG_REPLY,
> +			     sizeof(ev->bdaddr), &ev->bdaddr);
> +		goto unlock;
> +	}
> +
> 	/* If no side requires MITM protection; auto-accept */
> 	if ((!loc_mitm || conn->remote_cap == HCI_IO_NO_INPUT_OUTPUT) &&
> 	    (!rem_mitm || conn->io_capability == HCI_IO_NO_INPUT_OUTPUT)) {

What about the LE cases?

In addition, I like to get a pair of second eyes from Johan and Luiz on this one.

Regards

Marcel

