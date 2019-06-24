Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A20EE51C9C
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 22:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732135AbfFXUxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 16:53:15 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43357 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729160AbfFXUxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 16:53:15 -0400
Received: by mail-pf1-f195.google.com with SMTP id i189so8173773pfg.10
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 13:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=lEGBvoXxbinEDes32hLX1SJzfq7dLjU5/c0LD1FSW0A=;
        b=sMMxWEoXwYOfW64wVipapD1E7CDtSwye0KjNibAQo8V28/NWxag66eNqAe2iIq5S6l
         93itpk2jY3AJY0mLATB4H8eeA+YiGOsOjX9cEWAE4USDgbgHhPW90loDC2E+UUZdUpDe
         qqvnSV/MEGYAUTOF6T26uQZSsX7vjItnw6s8Aag9cAvuRkK0ne03tXrJRv92SW40lGR4
         DDC4HBslzztGXgG70g4af0VeNpmIBc5NGquYHt1vHjkIO3RboUOu9ZMiccL0ovweqjuS
         ObnDcPd3LL57uex8KhFATbVzIRDu8FS41bZUexMnM2bFMchU81RsEL1FekQxlNlnXYAA
         UWvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=lEGBvoXxbinEDes32hLX1SJzfq7dLjU5/c0LD1FSW0A=;
        b=de5L/zyCRXPbFJn/9W990ceNHrH4pq7Wabrj8/7CiOoyewX9v7B2d9XVCfv57F6Tcp
         wtEMYHJuHVGO2gCTRd3COO0i2YMExw5tX4+U+hVnI4NvY2Etc39Fx5PU1sOoOImjZP5k
         943P3kqoby3grMYta/9IVlU4QNyKhJwoPVtb7T8MqENM6fl73ERbmwEFSZVx1ambxzl3
         f1cQkv6MDNNBMvsGxZLH+d72+1FN+DSZ62rhi27qkA5FEQpEH63PL7liNOayAe8wq3Jd
         lSCWAyTZOdqej9vn2EYJ55vQhkfl80W5E731eGQnkrR4vVl1f+dHtG7WvUjgf1odGnY+
         5VEQ==
X-Gm-Message-State: APjAAAXES5rYcqsgeks2H1qh+mA3+ST8+ZD3EqClYpGltW4zMojLblHF
        pTbJZN72CLOoDVNIb+YdOxfkQg==
X-Google-Smtp-Source: APXvYqwfm7TEw9eMywCLQi+uwCPc3HnJVbd/LDU9Ftag8oFDhmjNwq3lP04O2vAhGrDYBv6iAa31Lg==
X-Received: by 2002:a17:90a:d595:: with SMTP id v21mr26674916pju.34.1561409594449;
        Mon, 24 Jun 2019 13:53:14 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x65sm13856568pfd.139.2019.06.24.13.53.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 13:53:14 -0700 (PDT)
Date:   Mon, 24 Jun 2019 13:53:04 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 02/18] ionic: Add hardware init and device
 commands
Message-ID: <20190624135304.48755745@cakuba.netronome.com>
In-Reply-To: <20190620202424.23215-3-snelson@pensando.io>
References: <20190620202424.23215-1-snelson@pensando.io>
        <20190620202424.23215-3-snelson@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jun 2019 13:24:08 -0700, Shannon Nelson wrote:
> The ionic device has a small set of PCI registers, including a
> device control and data space, and a large set of message
> commands.
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

>  struct ionic {
>  	struct pci_dev *pdev;
>  	struct device *dev;
> +	struct ionic_dev idev;
> +	struct mutex dev_cmd_lock;	/* lock for dev_cmd operations */
> +	struct dentry *dentry;
> +	struct ionic_dev_bar bars[IONIC_BARS_MAX];
> +	unsigned int num_bars;
> +	struct identity ident;
> +	bool is_mgmt_nic;

What's a management NIC?

> +	ionic->is_mgmt_nic =
> +		ent->device == PCI_DEVICE_ID_PENSANDO_IONIC_ETH_MGMT;

You spent time in the docs describing how to use lspci, yet this magic
NIC is not mentioned :)

>  static struct pci_driver ionic_driver = {
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
> new file mode 100644
> index 000000000000..e5e45e6bec9d
> --- /dev/null
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
> @@ -0,0 +1,239 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
> +
> +#include <linux/netdevice.h>
> +
> +#include "ionic.h"
> +#include "ionic_bus.h"
> +#include "ionic_debugfs.h"
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

Why would you ever have to write to a debugfs blob?  Red flag.

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
> +static struct dentry *ionic_dir;
> +
> +#define single(name) \
> +static int name##_open(struct inode *inode, struct file *f)	\
> +{								\
> +	return single_open(f, name##_show, inode->i_private);	\
> +}								\
> +								\
> +static const struct file_operations name##_fops = {		\
> +	.owner = THIS_MODULE,					\
> +	.open = name##_open,					\
> +	.read = seq_read,					\
> +	.llseek = seq_lseek,					\
> +	.release = single_release,				\
> +}

DEFINE_SHOW_ATTRIBUTE() and friends.

> +static int bars_show(struct seq_file *seq, void *v)
> +{
> +	struct ionic *ionic = seq->private;
> +	struct ionic_dev_bar *bars = ionic->bars;
> +	unsigned int i;
> +
> +	for (i = 0; i < IONIC_BARS_MAX; i++)
> +		if (bars[i].vaddr)
> +			seq_printf(seq, "BAR%d: len 0x%lx vaddr %pK bus_addr %pad\n",
> +				   i, bars[i].len, bars[i].vaddr,
> +				   &bars[i].bus_addr);

Why? What's the value of this print beyond what's already visible from
PCI subsystem? :S

> +static inline u64 encode_txq_desc_cmd(u8 opcode, u8 flags,
> +				      u8 nsge, u64 addr)
> +{
> +	u64 cmd;
> +
> +	cmd = (opcode & IONIC_TXQ_DESC_OPCODE_MASK) << IONIC_TXQ_DESC_OPCODE_SHIFT;

IIRC you're not a fan of the FIELD_* macros, but let me suggest them
again :)

> +	cmd |= (flags & IONIC_TXQ_DESC_FLAGS_MASK) << IONIC_TXQ_DESC_FLAGS_SHIFT;
> +	cmd |= (nsge & IONIC_TXQ_DESC_NSGE_MASK) << IONIC_TXQ_DESC_NSGE_SHIFT;
> +	cmd |= (addr & IONIC_TXQ_DESC_ADDR_MASK) << IONIC_TXQ_DESC_ADDR_SHIFT;
> +
> +	return cmd;
> +};
> +
> +static inline void decode_txq_desc_cmd(u64 cmd, u8 *opcode, u8 *flags,
> +				       u8 *nsge, u64 *addr)
> +{
> +	*opcode = (cmd >> IONIC_TXQ_DESC_OPCODE_SHIFT) & IONIC_TXQ_DESC_OPCODE_MASK;
> +	*flags = (cmd >> IONIC_TXQ_DESC_FLAGS_SHIFT) & IONIC_TXQ_DESC_FLAGS_MASK;
> +	*nsge = (cmd >> IONIC_TXQ_DESC_NSGE_SHIFT) & IONIC_TXQ_DESC_NSGE_MASK;
> +	*addr = (cmd >> IONIC_TXQ_DESC_ADDR_SHIFT) & IONIC_TXQ_DESC_ADDR_MASK;
> +};
> +
> +#define IONIC_TX_MAX_SG_ELEMS	8
> +#define IONIC_RX_MAX_SG_ELEMS	8

> +/**
> + * struct dev_setattr_cmd - Set Device attributes on the NIC
> + * @opcode:     Opcode
> + * @attr:       Attribute type (enum dev_attr)
> + * @state:      Device state (enum dev_state)
> + * @name:       The bus info, e.g. PCI slot-device-function, 0 terminated

Interesting, why would this be of interest to the device?

> + * @features:   Device features
> + */
> +struct dev_setattr_cmd {
> +	u8     opcode;
> +	u8     attr;
> +	__le16 rsvd;
> +	union {
> +		u8      state;
> +		char    name[IONIC_IFNAMSIZ];
> +		__le64  features;
> +		u8      rsvd2[60];
> +	};
> +};

> +/**
> + * struct lif_getattr_comp - LIF get attr command completion
> + * @status:     The status of the command (enum status_code)
> + * @comp_index: The index in the descriptor ring for which this
> + *              is the completion.
> + * @state:      lif state (enum lif_state)
> + * @name:       The netdev name string, 0 terminated
> + * @mtu:        Mtu
> + * @mac:        Station mac
> + * @features:   Features (enum eth_hw_features)
> + * @color:      Color bit
> + */
> +struct lif_getattr_comp {
> +	u8     status;
> +	u8     rsvd;
> +	__le16 comp_index;
> +	union {
> +		u8      state;
> +		//char    name[IONIC_IFNAMSIZ];

Hi!!

> +		__le32  mtu;
> +		u8      mac[6];
> +		__le64  features;
> +		u8      rsvd2[11];
> +	};
> +	u8     color;
> +};
