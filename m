Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B663050E8
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238987AbhA0EaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:30:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:49248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392546AbhA0BnV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 20:43:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB5B1206A4;
        Wed, 27 Jan 2021 01:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611711760;
        bh=oZMJJcJ0nMRqlk9Me0tYJaKWhDt6yRiNOVPiEcNIk2g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=D7nJ9ALmlwk+oJIflEiPfap4ULEIMpsxE3DQ35mvKJimAzZIOL56iNrPSerk/b054
         g2jQ2r4HjB+r+vd2vP2bZWll9NTXvAxag8vFWz/97X4v3zYvZ1cJDcCH64w7tZRG3g
         bLGIJWeU5wEKMSFMemf4ovpZFziHZXvylO+Ortej4mCEmuBB+7qxFa2AUsTIbDAJTY
         nAjDTyqRoH7xFBrozPVcgku25mF/objiS0IOa6tDZJC/y5Ag1XvbleJ+aZ497Z+DtW
         SUm3uuGI+ij2D+9Ct8tmEvRTMapG621P63R5SAY81yMTGa1IVv/PUjby0AMcGjR3RS
         Hdhpdu2X4dGrg==
Date:   Tue, 26 Jan 2021 17:42:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     shuah@kernel.org, krzk@kernel.org, netdev@vger.kernel.org,
        linux-nfc@lists.01.org, linux-kselftest@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [PATCH net-next v3 1/2] nfc: Add a virtual nci device driver
Message-ID: <20210126174238.16d9691a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210123092425.11434-2-bongsu.jeon@samsung.com>
References: <20210123092425.11434-1-bongsu.jeon@samsung.com>
        <20210123092425.11434-2-bongsu.jeon@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Jan 2021 18:24:24 +0900 Bongsu Jeon wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> NCI virtual device simulates a NCI device to the user. It can be used to
> validate the NCI module and applications. This driver supports
> communication between the virtual NCI device and NCI module.
> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>

> +static bool virtual_ncidev_check_enabled(void)
> +{
> +	bool ret = true;
> +
> +	mutex_lock(&nci_mutex);
> +	if (state != virtual_ncidev_enabled)
> +		ret = false;
> +	mutex_unlock(&nci_mutex);
> +
> +	return ret;


This can be simplified like:

	bool ret;

	mutex_lock()
	ret = state == virtual_ncidev_enabled;
	mutex_unlock()

	return ret;


> +}
> +
> +static int virtual_nci_open(struct nci_dev *ndev)
> +{
> +	return 0;
> +}
> +
> +static int virtual_nci_close(struct nci_dev *ndev)
> +{
> +	mutex_lock(&nci_mutex);
> +	if (send_buff)
> +		kfree_skb(send_buff);

kfree_skb() handles NULL, no need for the if, you can always call
kfree_skb() here

> +	send_buff = NULL;
> +	mutex_unlock(&nci_mutex);
> +
> +	return 0;
> +}
> +
> +static int virtual_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
> +{
> +	if (virtual_ncidev_check_enabled() == false)
> +		return 0;

Shouldn't you check this _under_ the lock below? 

Otherwise there is a small window between check and use of send_buff

> +	mutex_lock(&nci_mutex);
> +	if (send_buff) {
> +		mutex_unlock(&nci_mutex);
> +		return -1;
> +	}
> +	send_buff = skb_copy(skb, GFP_KERNEL);
> +	mutex_unlock(&nci_mutex);
> +
> +	return 0;
> +}
> +
> +static struct nci_ops virtual_nci_ops = {
> +	.open = virtual_nci_open,
> +	.close = virtual_nci_close,
> +	.send = virtual_nci_send
> +};
> +
> +static ssize_t virtual_ncidev_read(struct file *file, char __user *buf,
> +				   size_t count, loff_t *ppos)
> +{
> +	size_t actual_len;
> +
> +	mutex_lock(&nci_mutex);
> +	if (!send_buff) {
> +		mutex_unlock(&nci_mutex);
> +		return 0;
> +	}
> +
> +	actual_len = min_t(size_t, count, send_buff->len);
> +
> +	if (copy_to_user(buf, send_buff->data, actual_len)) {
> +		mutex_unlock(&nci_mutex);
> +		return -EFAULT;
> +	}
> +
> +	skb_pull(send_buff, actual_len);
> +	if (send_buff->len == 0) {
> +		consume_skb(send_buff);
> +		send_buff = NULL;
> +	}
> +	mutex_unlock(&nci_mutex);
> +
> +	return actual_len;
> +}
> +
> +static ssize_t virtual_ncidev_write(struct file *file,
> +				    const char __user *buf,
> +				    size_t count, loff_t *ppos)
> +{
> +	struct sk_buff *skb;
> +
> +	skb = alloc_skb(count, GFP_KERNEL);
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	if (copy_from_user(skb_put(skb, count), buf, count)) {
> +		kfree_skb(skb);
> +		return -EFAULT;
> +	}
> +
> +	nci_recv_frame(ndev, skb);
> +	return count;
> +}
> +
> +static int virtual_ncidev_open(struct inode *inode, struct file *file)
> +{
> +	int ret = 0;
> +
> +	mutex_lock(&nci_mutex);
> +	if (state != virtual_ncidev_disabled) {
> +		mutex_unlock(&nci_mutex);
> +		return -EBUSY;
> +	}
> +
> +	ndev = nci_allocate_device(&virtual_nci_ops, VIRTUAL_NFC_PROTOCOLS,
> +				   0, 0);
> +	if (!ndev) {
> +		mutex_unlock(&nci_mutex);
> +		return -ENOMEM;
> +	}
> +
> +	ret = nci_register_device(ndev);
> +	if (ret < 0) {
> +		nci_free_device(ndev);
> +		mutex_unlock(&nci_mutex);
> +		return ret;
> +	}
> +	state = virtual_ncidev_enabled;
> +	mutex_unlock(&nci_mutex);
> +
> +	return 0;
> +}
> +
> +static int virtual_ncidev_close(struct inode *inode, struct file *file)
> +{
> +	mutex_lock(&nci_mutex);
> +
> +	if (state == virtual_ncidev_enabled) {
> +		state = virtual_ncidev_disabling;
> +		mutex_unlock(&nci_mutex);
> +
> +		nci_unregister_device(ndev);
> +		nci_free_device(ndev);
> +
> +		mutex_lock(&nci_mutex);
> +	}
> +
> +	state = virtual_ncidev_disabled;
> +	mutex_unlock(&nci_mutex);
> +
> +	return 0;
> +}
> +
> +static long virtual_ncidev_ioctl(struct file *flip, unsigned int cmd,
> +				 unsigned long arg)
> +{
> +	if (cmd == IOCTL_GET_NCIDEV_IDX) {
> +		struct nfc_dev *nfc_dev = ndev->nfc_dev;
> +		void __user *p = (void __user *)arg;
> +
> +		if (copy_to_user(p, &nfc_dev->idx, sizeof(nfc_dev->idx)))
> +			return -EFAULT;
> +	} else {
> +		return -ENOTTY;
> +	}
> +
> +	return 0;

Please flip the condition and return early. I think I suggested this
already:

{
	struct nfc_dev *nfc_dev = ndev->nfc_dev;
	void __user *p = (void __user *)arg;		

	if (cmd != IOCTL_GET_NCIDEV_IDX)
		return -ENOTTY;

	if (copy_to_user(p, &nfc_dev->idx, sizeof(nfc_dev->idx)))
		return -EFAULT;

	return 0;
