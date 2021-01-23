Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5179F30126C
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 03:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbhAWCuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 21:50:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:38996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbhAWCuL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 21:50:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82CBD23B6A;
        Sat, 23 Jan 2021 02:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611370170;
        bh=IUMWyv1iSVgS8j+iVIFQH0GEincUb50BP7tb8YxP0yE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C/muT8+0QGmufd7B0gmj5WuStNwc78gzwzIfQ2czF+eUHy/oOZk1aKdphTzQIRC7A
         usHnelUYlmGAmbJ6uR+GGrCieOOBC8w4Sqhv88wFnXx4Q3GziK0beHJwyLzsHaJCvm
         K3LZF+j9SnC8t4SU+4TDfjq7Tn2j/AGCIfuLhH2S4uzq1FpTYC9UtMANX3egiooT6+
         va0GXCqjrqTEYMEaKWn2GntGwbJzVETgZBEw7w+2Atg4DI48c3yynDGN3QtH70Z3R3
         129A8NVan9U+Gw//ROOqc06a/lPBMBimM5hol5vmGRohJKw6y0VCMx07pg7l24tak4
         CtvOkNs+3owNg==
Date:   Fri, 22 Jan 2021 18:49:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     shuah@kernel.org, netdev@vger.kernel.org, linux-nfc@lists.01.org,
        linux-kselftest@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH net-next v2 1/2] nfc: Add a virtual nci device driver
Message-ID: <20210122184929.1b1a51a0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210120115645.32798-2-bongsu.jeon@samsung.com>
References: <20210120115645.32798-1-bongsu.jeon@samsung.com>
        <20210120115645.32798-2-bongsu.jeon@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jan 2021 20:56:44 +0900 Bongsu Jeon wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> A NCI virtual device can be made to simulate a NCI device in user space.
> Using the virtual NCI device, The NCI module and application can be
> validated. This driver supports to communicate between the virtual NCI
> device and NCI module.
> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>

Please CC Krzysztof on next version, maybe we'll be lucky and he finds
time to look at this :)

> diff --git a/drivers/nfc/Kconfig b/drivers/nfc/Kconfig
> index 75c65d339018..d32c3a8937ed 100644
> --- a/drivers/nfc/Kconfig
> +++ b/drivers/nfc/Kconfig
> @@ -49,6 +49,17 @@ config NFC_PORT100
>  
>  	  If unsure, say N.
>  
> +config NFC_VIRTUAL_NCI
> +	tristate "NCI device simulator driver"
> +	depends on NFC_NCI
> +	help
> +	  A NCI virtual device can be made to simulate a NCI device in user
> +	  level. Using the virtual NCI device, The NCI module and application
> +	  can be validated. This driver supports to communicate between the
> +	  virtual NCI device and NCI module.

How about:

  NCI virtual device simulates a NCI device to the user. 
  It can be used to validate the NCI module and applications. 
  This driver supports communication between the virtual NCI 
  device and NCI module.

Just trying to improve the grammar.


> +#define IOCTL_GET_NCIDEV_IDX    0
> +#define VIRTUAL_NFC_PROTOCOLS	(NFC_PROTO_JEWEL_MASK | \
> +				 NFC_PROTO_MIFARE_MASK | \
> +				 NFC_PROTO_FELICA_MASK | \
> +				 NFC_PROTO_ISO14443_MASK | \
> +				 NFC_PROTO_ISO14443_B_MASK | \
> +				 NFC_PROTO_ISO15693_MASK)
> +
> +static enum virtual_ncidev_mode state;
> +static struct mutex nci_send_mutex;
> +static struct miscdevice miscdev;
> +static struct sk_buff *send_buff;
> +static struct mutex nci_mutex;

I think if you use:

static DEFINE_MUTEX(...);

you won't have to init them in the code

> +static struct nci_dev *ndev;
> +static bool full_txbuff;
> +
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
> +}
> +
> +static int virtual_nci_open(struct nci_dev *ndev)
> +{
> +	return 0;
> +}
> +
> +static int virtual_nci_close(struct nci_dev *ndev)
> +{
> +	mutex_lock(&nci_send_mutex);
> +	if (full_txbuff)
> +		kfree_skb(send_buff);
> +	full_txbuff = false;
> +	mutex_unlock(&nci_send_mutex);
> +
> +	return 0;
> +}
> +
> +static int virtual_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
> +{
> +	if (virtual_ncidev_check_enabled() == false)
> +		return 0;
> +
> +	mutex_lock(&nci_send_mutex);
> +	if (full_txbuff) {
> +		mutex_unlock(&nci_send_mutex);
> +		return -1;
> +	}
> +	send_buff = skb_copy(skb, GFP_KERNEL);
> +	full_txbuff = true;

Do you need this variable? looks like you can just set send_buff to NULL

> +	mutex_unlock(&nci_send_mutex);
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
> +	mutex_lock(&nci_send_mutex);
> +	if (!full_txbuff) {
> +		mutex_unlock(&nci_send_mutex);
> +		return 0;
> +	}
> +
> +	actual_len = count > send_buff->len ? send_buff->len : count;

min_t()

> +	if (copy_to_user(buf, send_buff->data, actual_len)) {
> +		mutex_unlock(&nci_send_mutex);
> +		return -EFAULT;
> +	}
> +
> +	skb_pull(send_buff, actual_len);
> +	if (send_buff->len == 0) {
> +		kfree_skb(send_buff);

consume_skb()

> +		full_txbuff = false;
> +	}
> +	mutex_unlock(&nci_send_mutex);
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
> +	if (copy_from_user(skb_put(skb, count), buf, count))

leaks skb

> +		return -EFAULT;
> +
> +	nci_recv_frame(ndev, skb);
> +	return count;
> +}

> +static long virtual_ncidev_ioctl(struct file *flip, unsigned int cmd,
> +				 unsigned long arg)
> +{
> +	long res = -ENOTTY;
> +
> +	if (cmd == IOCTL_GET_NCIDEV_IDX) {
> +		struct nfc_dev *nfc_dev = ndev->nfc_dev;
> +		void __user *p = (void __user *)arg;
> +
> +		if (copy_to_user(p, &nfc_dev->idx, sizeof(nfc_dev->idx)))
> +			return -EFAULT;
> +		res = 0;
> +	}
> +
> +	return res;

The condition can be flipped to save the indentation and local variable:

if (cmd != ...)
	return -ENOTTY;

....
return 0;

> +}
> +
> +static const struct file_operations virtual_ncidev_fops = {
> +	.owner = THIS_MODULE,
> +	.read = virtual_ncidev_read,
> +	.write = virtual_ncidev_write,
> +	.open = virtual_ncidev_open,
> +	.release = virtual_ncidev_close,
> +	.unlocked_ioctl = virtual_ncidev_ioctl
> +};
> +
> +static int __init virtual_ncidev_init(void)
> +{
> +	int ret;
> +
> +	mutex_init(&nci_mutex);
> +	state = virtual_ncidev_disabled;
> +	miscdev.minor = MISC_DYNAMIC_MINOR;
> +	miscdev.name = "virtual_nci";
> +	miscdev.fops = &virtual_ncidev_fops;
> +	miscdev.mode = S_IALLUGO;
> +	ret = misc_register(&miscdev);
> +
> +	return ret;

no need for the local variable here, just 

	return misc_register()

> +}
> +
> +static void __exit virtual_ncidev_exit(void)
> +{
> +	misc_deregister(&miscdev);
> +}
> +
> +module_init(virtual_ncidev_init);
> +module_exit(virtual_ncidev_exit);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("Virtual NCI device simulation driver");
> +MODULE_AUTHOR("Bongsu Jeon <bongsu.jeon@samsung.com>");

