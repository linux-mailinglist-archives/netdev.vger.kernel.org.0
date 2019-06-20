Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F61C4DD1B
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 23:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbfFTVyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 17:54:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45096 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbfFTVyc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 17:54:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=20pTz6+4I9XO5f0H3mJ7QDWJ7PLU5LwVcECWpLu2z4E=; b=nv5GOuHHu1LRhVgmKPdzvk+zi6
        NYhCCWels7ZdFD/ec1qDfLRg5YdNojyylRV6e1aEZt/ibYeUAKbFdzUDrxGTI5DLEj9p8C04Nf9mr
        gqLlxneyE1tQ1a+s13LKLdSzlqkztX3c+VhQbTH2nVmRhJtPn/hQW4RMCv8hVNaHuUhw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1he50o-0002Nn-2b; Thu, 20 Jun 2019 23:54:30 +0200
Date:   Thu, 20 Jun 2019 23:54:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 02/18] ionic: Add hardware init and device
 commands
Message-ID: <20190620215430.GK31306@lunn.ch>
References: <20190620202424.23215-1-snelson@pensando.io>
 <20190620202424.23215-3-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620202424.23215-3-snelson@pensando.io>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 20, 2019 at 01:24:08PM -0700, Shannon Nelson wrote:
> +	err = ionic_debugfs_add_dev(ionic);
> +	if (err) {
> +		dev_err(dev, "Cannot add device debugfs: %d , aborting\n", err);
> +		goto err_out_clear_drvdata;
> +	}

Hi Shannon

debugfs should not fail, since it is optional. debugfs failing should
also not be considered fatal. And lastly, debugfs is not very liked by
network people, so you should avoid it as much as possible. Use
ethtool, lspci, devlink, etc.

> +
> +#ifdef CONFIG_DEBUG_FS
> +
> +static int blob_open(struct inode *inode, struct file *filp)
> +{
> +	filp->private_data = inode->i_private;
> +	return 0;
> +}
> +
> +static ssize_t blob_read(struct file *filp, char __user *buffer,
> +			 size_t count, loff_t *ppos)
> +{
> +	struct debugfs_blob_wrapper *blob = filp->private_data;
> +
> +	if (*ppos >= blob->size)
> +		return 0;
> +	if (*ppos + count > blob->size)
> +		count = blob->size - *ppos;
> +
> +	if (copy_to_user(buffer, blob->data + *ppos, count))
> +		return -EFAULT;
> +
> +	*ppos += count;
> +
> +	return count;
> +}
> +
> +static ssize_t blob_write(struct file *filp, const char __user *buffer,
> +			  size_t count, loff_t *ppos)
> +{
> +	struct debugfs_blob_wrapper *blob = filp->private_data;
> +
> +	if (*ppos >= blob->size)
> +		return 0;
> +	if (*ppos + count > blob->size)
> +		count = blob->size - *ppos;
> +
> +	if (copy_from_user(blob->data + *ppos, buffer, count))
> +		return -EFAULT;
> +
> +	*ppos += count;
> +
> +	return count;
> +}

Write is pretty much a no-no. We don't want proprietary user space
tools manipulating the hardware/driver state.

> +
> +static const struct file_operations blob_fops = {
> +	.owner = THIS_MODULE,
> +	.open = blob_open,
> +	.read = blob_read,
> +	.write = blob_write,
> +};
> +
> +struct dentry *debugfs_create_blob(const char *name, umode_t mode,
> +				   struct dentry *parent,
> +				   struct debugfs_blob_wrapper *blob)
> +{
> +	return debugfs_create_file(name, mode | 0200, parent, blob,
> +				   &blob_fops);
> +}
> +

> +static const struct debugfs_reg32 dev_cmd_regs[] = {
> +	{ .name = "db", .offset = 0, },
> +	{ .name = "done", .offset = 4, },
> +	{ .name = "cmd.word[0]", .offset = 8, },
> +	{ .name = "cmd.word[1]", .offset = 12, },
> +	{ .name = "cmd.word[2]", .offset = 16, },
> +	{ .name = "cmd.word[3]", .offset = 20, },
> +	{ .name = "cmd.word[4]", .offset = 24, },
> +	{ .name = "cmd.word[5]", .offset = 28, },
> +	{ .name = "cmd.word[6]", .offset = 32, },
> +	{ .name = "cmd.word[7]", .offset = 36, },
> +	{ .name = "cmd.word[8]", .offset = 40, },
> +	{ .name = "cmd.word[9]", .offset = 44, },
> +	{ .name = "cmd.word[10]", .offset = 48, },
> +	{ .name = "cmd.word[11]", .offset = 52, },
> +	{ .name = "cmd.word[12]", .offset = 56, },
> +	{ .name = "cmd.word[13]", .offset = 60, },
> +	{ .name = "cmd.word[14]", .offset = 64, },
> +	{ .name = "cmd.word[15]", .offset = 68, },
> +	{ .name = "comp.word[0]", .offset = 72, },
> +	{ .name = "comp.word[1]", .offset = 76, },
> +	{ .name = "comp.word[2]", .offset = 80, },
> +	{ .name = "comp.word[3]", .offset = 84, },
> +};
> +
> +int ionic_debugfs_add_dev_cmd(struct ionic *ionic)
> +{
> +	struct debugfs_regset32 *dev_cmd_regset;
> +	struct device *dev = ionic->dev;
> +	struct dentry *dentry;
> +
> +	dev_cmd_regset = devm_kzalloc(dev, sizeof(*dev_cmd_regset),
> +				      GFP_KERNEL);
> +	if (!dev_cmd_regset)
> +		return -ENOMEM;
> +	dev_cmd_regset->regs = dev_cmd_regs;
> +	dev_cmd_regset->nregs = ARRAY_SIZE(dev_cmd_regs);
> +	dev_cmd_regset->base = ionic->idev.dev_cmd_regs;
> +
> +	dentry = debugfs_create_regset32("dev_cmd", 0400,
> +					 ionic->dentry, dev_cmd_regset);
> +	if (IS_ERR_OR_NULL(dentry))
> +		return PTR_ERR(dentry);

ethtool -d seems like a more acceptable method for exporting
registers.

> +static int identity_show(struct seq_file *seq, void *v)
> +{
> +	struct ionic *ionic = seq->private;
> +	struct identity *ident = &ionic->ident;
> +	struct ionic_dev *idev = &ionic->idev;
> +
> +	seq_printf(seq, "asic_type:        0x%x\n", idev->dev_info.asic_type);
> +	seq_printf(seq, "asic_rev:         0x%x\n", idev->dev_info.asic_rev);
> +	seq_printf(seq, "serial_num:       %s\n", idev->dev_info.serial_num);
> +	seq_printf(seq, "fw_version:       %s\n", idev->dev_info.fw_version);
> +	seq_printf(seq, "fw_status:        0x%x\n",
> +		   ioread8(&idev->dev_info_regs->fw_status));
> +	seq_printf(seq, "fw_heartbeat:     0x%x\n",
> +		   ioread32(&idev->dev_info_regs->fw_heartbeat));

devlink just gained a much more flexible version of ethtool -i. Please
remove all this and use that.

> +int ionic_dev_setup(struct ionic *ionic)
> +{
> +	struct ionic_dev_bar *bar = ionic->bars;
> +	unsigned int num_bars = ionic->num_bars;
> +	struct ionic_dev *idev = &ionic->idev;
> +	struct device *dev = ionic->dev;
> +	u32 sig;
> +
> +	/* BAR0: dev_cmd and interrupts */
> +	if (num_bars < 1) {
> +		dev_info(dev, "No bars found, aborting\n");

dev_err(), since this is fatal. The same for most of these dev_info()
calls.

> +enum os_type {
> +	IONIC_OS_TYPE_LINUX   = 1,
> +	IONIC_OS_TYPE_WIN     = 2,
> +	IONIC_OS_TYPE_DPDK    = 3,
> +	IONIC_OS_TYPE_FREEBSD = 4,
> +	IONIC_OS_TYPE_IPXE    = 5,
> +	IONIC_OS_TYPE_ESXI    = 6,
> +};
> +
> +/**
> + * union drv_identity - driver identity information
> + * @os_type:          OS type (see enum os_type)
> + * @os_dist:          OS distribution, numeric format
> + * @os_dist_str:      OS distribution, string format
> + * @kernel_ver:       Kernel version, numeric format
> + * @kernel_ver_str:   Kernel version, string format
> + * @driver_ver_str:   Driver version, string format
> + */
> +union drv_identity {
> +	struct {
> +		__le32 os_type;
> +		__le32 os_dist;
> +		char   os_dist_str[128];
> +		__le32 kernel_ver;
> +		char   kernel_ver_str[32];
> +		char   driver_ver_str[32];
> +	};
> +	__le32 words[512];
> +};

> +int ionic_identify(struct ionic *ionic)
> +{
> +	struct identity *ident = &ionic->ident;
> +	struct ionic_dev *idev = &ionic->idev;
> +	size_t sz;
> +	int err;
> +
> +	memset(ident, 0, sizeof(*ident));
> +
> +	ident->drv.os_type = cpu_to_le32(IONIC_OS_TYPE_LINUX);
> +	ident->drv.os_dist = 0;
> +	strncpy(ident->drv.os_dist_str, utsname()->release,
> +		sizeof(ident->drv.os_dist_str) - 1);
> +	ident->drv.kernel_ver = cpu_to_le32(LINUX_VERSION_CODE);
> +	strncpy(ident->drv.kernel_ver_str, utsname()->version,
> +		sizeof(ident->drv.kernel_ver_str) - 1);
> +	strncpy(ident->drv.driver_ver_str, DRV_VERSION,
> +		sizeof(ident->drv.driver_ver_str) - 1);

Creepy.

	Andrew
