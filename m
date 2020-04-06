Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D78019F503
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 13:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727752AbgDFLq2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 6 Apr 2020 07:46:28 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:47057 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727476AbgDFLq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 07:46:28 -0400
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 0E3E1CECC3;
        Mon,  6 Apr 2020 13:56:01 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH v1] Bluetooth: debugfs option to unset MITM flag
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200406165542.v1.1.Ibfc500cbf0bf2dc8429b17f064e960e95bb228e9@changeid>
Date:   Mon, 6 Apr 2020 13:46:26 +0200
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <9673F164-A14E-4DD6-88FB-277694C50328@holtmann.org>
References: <20200406165542.v1.1.Ibfc500cbf0bf2dc8429b17f064e960e95bb228e9@changeid>
To:     Archie Pusaka <apusaka@google.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

> The BT qualification test SM/MAS/PKE/BV-01-C needs us to turn off
> the MITM flag when pairing, and at the same time also set the io
> capability to something other than no input no output.
> 
> Currently the MITM flag is only unset when the io capability is set
> to no input no output, therefore the test cannot be executed.
> 
> This patch introduces a debugfs option for controlling whether MITM
> flag should be set based on io capability.
> 
> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> ---
> 
> include/net/bluetooth/hci.h |  1 +
> net/bluetooth/smp.c         | 52 ++++++++++++++++++++++++++++++++++++-
> 2 files changed, 52 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
> index 79de2a659dd69..5e183487c7479 100644
> --- a/include/net/bluetooth/hci.h
> +++ b/include/net/bluetooth/hci.h
> @@ -298,6 +298,7 @@ enum {
> 	HCI_FORCE_STATIC_ADDR,
> 	HCI_LL_RPA_RESOLUTION,
> 	HCI_CMD_PENDING,
> +	HCI_ENFORCE_MITM_SMP,

actually don’t you mean HCI_FORCE_NO_MITM? From your description, you want a toggle that disables MITM no matter what.

> 	__HCI_NUM_FLAGS,
> };
> diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
> index d0b695ee49f63..4fa8b112fb607 100644
> --- a/net/bluetooth/smp.c
> +++ b/net/bluetooth/smp.c
> @@ -2396,7 +2396,8 @@ int smp_conn_security(struct hci_conn *hcon, __u8 sec_level)
> 	/* Require MITM if IO Capability allows or the security level
> 	 * requires it.
> 	 */
> -	if (hcon->io_capability != HCI_IO_NO_INPUT_OUTPUT ||
> +	if ((hci_dev_test_flag(hcon->hdev, HCI_ENFORCE_MITM_SMP) &&
> +	     hcon->io_capability != HCI_IO_NO_INPUT_OUTPUT) ||
> 	    hcon->pending_sec_level > BT_SECURITY_MEDIUM)
> 		authreq |= SMP_AUTH_MITM;

	/* New comment for this case ..
	if (!hci_dev_test_flag(hcon->hdev, HCI_FORCE_NO_MITM)) {
		/* Move comment here ..
		if (hcon->io_capability != HCI_IO_NO_INPUT_OUTPUT ||
		    hcon->pending_sec_level > BT_SECURITY_MEDIUM)
			authreq |= SMP_AUTH_MITM;
	}

> 
> @@ -3402,6 +3403,50 @@ static const struct file_operations force_bredr_smp_fops = {
> 	.llseek		= default_llseek,
> };
> 
> +static ssize_t enforce_mitm_smp_read(struct file *file,
> +				     char __user *user_buf,
> +				     size_t count, loff_t *ppos)
> +{
> +	struct hci_dev *hdev = file->private_data;
> +	char buf[3];
> +
> +	buf[0] = hci_dev_test_flag(hdev, HCI_ENFORCE_MITM_SMP) ? 'Y' : 'N';
> +	buf[1] = '\n';
> +	buf[2] = '\0';
> +	return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
> +}
> +
> +static ssize_t enforce_mitm_smp_write(struct file *file,
> +				      const char __user *user_buf,
> +				      size_t count, loff_t *ppos)
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
> +	if (enable == hci_dev_test_flag(hdev, HCI_ENFORCE_MITM_SMP))
> +		return -EALREADY;
> +
> +	hci_dev_change_flag(hdev, HCI_ENFORCE_MITM_SMP);
> +
> +	return count;
> +}
> +
> +static const struct file_operations enforce_mitm_smp_fops = {
> +	.open		= simple_open,
> +	.read		= enforce_mitm_smp_read,
> +	.write		= enforce_mitm_smp_write,
> +	.llseek		= default_llseek,
> +};
> +
> int smp_register(struct hci_dev *hdev)
> {
> 	struct l2cap_chan *chan;
> @@ -3426,6 +3471,11 @@ int smp_register(struct hci_dev *hdev)
> 
> 	hdev->smp_data = chan;
> 
> +	/* Enforce the policy of determining MITM flag by io capabilities. */
> +	hci_dev_set_flag(hdev, HCI_ENFORCE_MITM_SMP);

No. Lets keep the current behavior the default.

> +	debugfs_create_file("enforce_mitm_smp", 0644, hdev->debugfs, hdev,
> +			    &enforce_mitm_smp_fops);
> +

And this needs to move into hci_debugfs.c.

Regards

Marcel

