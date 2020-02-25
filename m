Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBFD16F089
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 21:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729140AbgBYUte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 15:49:34 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34072 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728119AbgBYUtd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 15:49:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1Jp4AsY95+F3uN+zvxx3OxTatSAeEzZsq49QkrF0bNg=; b=ENWuIsFqrSLEL5s2SyWRoPmAWC
        CxqSge1BqzF3d7vpwhaonrnVh9c3C5SJwITb+pLaSsIkKW6W06IX/bZhhw+uY2XEJ7kYyPkHWXOIT
        IZPqNlm9nFq2sZmZgPHSyk5UgGRVqw9TmbJQPWXw6KlNXQqCs4Q5VJrDvnB/8kMsb3kw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j6h8z-0001Gr-Fs; Tue, 25 Feb 2020 21:49:29 +0100
Date:   Tue, 25 Feb 2020 21:49:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Subject: Re: [RFC net-next 2/3] net: marvell: prestera: Add PCI interface
 support
Message-ID: <20200225204929.GG7663@lunn.ch>
References: <20200225163025.9430-1-vadym.kochan@plvision.eu>
 <20200225163025.9430-3-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225163025.9430-3-vadym.kochan@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 04:30:55PM +0000, Vadym Kochan wrote:
> Add PCI interface driver for Prestera Switch ASICs family devices, which
> provides:
> 
>     - Firmware loading mechanism
>     - Requests & events handling to/from the firmware
>     - Access to the firmware on the bus level
> 
> The firmware has to be loaded each time device is reset. The driver is
> loading it from:
> 
>     /lib/firmware/marvell/prestera_fw_img.bin
> 
> The firmware image version is located within internal header and consists
> of 3 numbers - MAJOR.MINOR.PATCH. Additionally, driver has hard-coded
> minimum supported firmware version which it can work with:
> 
>     MAJOR - reflects the support on ABI level between driver and loaded
>             firmware, this number should be the same for driver and loaded
>             firmware.
> 
>     MINOR - this is the minimal supported version between driver and the
>             firmware.
> 
>     PATCH - indicates only fixes, firmware ABI is not changed.
> 
> Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>

Nice to see a driver for this hardware.

> +#define mvsw_wait_timeout(cond, waitms) \
> +({ \
> +	unsigned long __wait_end = jiffies + msecs_to_jiffies(waitms); \
> +	bool __wait_ret = false; \
> +	do { \
> +		if (cond) { \
> +			__wait_ret = true; \
> +			break; \
> +		} \
> +		cond_resched(); \
> +	} while (time_before(jiffies, __wait_end)); \
> +	__wait_ret; \
> +})

Please try to use include/linux/iopoll.h

> +#define FW_VER_MIN(v) \
> +	(((v) - (FW_VER_MAJ(v) * FW_VER_MAJ_MUL)) / FW_VER_MIN_MUL)
> +
> +#define FW_VER_PATCH(v) \
> +	(v - (FW_VER_MAJ(v) * FW_VER_MAJ_MUL) - (FW_VER_MIN(v) * FW_VER_MIN_MUL))
> +
> +#define mvsw_ldr_write(fw, reg, val) \
> +	writel(val, (fw)->ldr_regs + (reg))
> +#define mvsw_ldr_read(fw, reg)	\
> +	readl((fw)->ldr_regs + (reg))

You have a lot of macro magic in this file. Please try to replace most
of it with simple functions. The compiler will inline it, giving you
the same performance, but you gain better type checking.

> +#define mvsw_fw_dev(fw)	((fw)->dev.dev)

Macros like this don't bring much value.


> +static int mvsw_pr_fw_hdr_parse(struct mvsw_pr_fw *fw,
> +				const struct firmware *img)
> +{
> +	struct mvsw_pr_fw_header *hdr = (struct mvsw_pr_fw_header *)img->data;
> +	struct mvsw_fw_rev *rev = &fw->dev.fw_rev;
> +	u32 magic;
> +
> +	magic = be32_to_cpu(hdr->magic_number);
> +	if (magic != MVSW_FW_HDR_MAGIC) {
> +		dev_err(mvsw_fw_dev(fw), "FW img type is invalid");
> +		return -EINVAL;
> +	}
> +
> +	mvsw_pr_fw_rev_parse(hdr, rev);
> +
> +	dev_info(mvsw_fw_dev(fw), "FW version '%u.%u.%u'\n",
> +		 rev->maj, rev->min, rev->sub);

ethtool can return this. Don't spam the kernel log.

> +
> +	return mvsw_pr_fw_rev_check(fw);
> +}
> +
> +static int mvsw_pr_fw_load(struct mvsw_pr_fw *fw)
> +{
> +	size_t hlen = sizeof(struct mvsw_pr_fw_header);
> +	const struct firmware *f;
> +	bool has_ldr;
> +	int err;
> +
> +	has_ldr = mvsw_wait_timeout(mvsw_pr_ldr_is_ready(fw), 1000);
> +	if (!has_ldr) {
> +		dev_err(mvsw_fw_dev(fw), "waiting for FW loader is timed out");
> +		return -ETIMEDOUT;
> +	}
> +
> +	fw->ldr_ring_buf = fw->ldr_regs +
> +		mvsw_ldr_read(fw, MVSW_LDR_BUF_OFFS_REG);
> +
> +	fw->ldr_buf_len =
> +		mvsw_ldr_read(fw, MVSW_LDR_BUF_SIZE_REG);
> +
> +	fw->ldr_wr_idx = 0;
> +
> +	err = request_firmware_direct(&f, MVSW_FW_FILENAME, &fw->pci_dev->dev);
> +	if (err) {
> +		dev_err(mvsw_fw_dev(fw), "failed to request firmware file\n");
> +		return err;
> +	}
> +
> +	if (!IS_ALIGNED(f->size, 4)) {
> +		dev_err(mvsw_fw_dev(fw), "FW image file is not aligned");
> +		release_firmware(f);
> +		return -EINVAL;
> +	}

This is size, so has nothing to do with alignment. Do you mean truncated?


> +
> +	err = mvsw_pr_fw_hdr_parse(fw, f);
> +	if (err) {
> +		dev_err(mvsw_fw_dev(fw), "FW image header is invalid\n");
> +		release_firmware(f);
> +		return err;
> +	}
> +
> +	mvsw_ldr_write(fw, MVSW_LDR_IMG_SIZE_REG, f->size - hlen);
> +	mvsw_ldr_write(fw, MVSW_LDR_CTL_REG, MVSW_LDR_CTL_DL_START);
> +
> +	dev_info(mvsw_fw_dev(fw), "Loading prestera FW image ...");

How slow is this? If the machine is blocked for 10 minutes, doing
nothing than load firmware, maybe it would be good to spam the
console, but otherwise....

> +
> +	err = mvsw_pr_ldr_send(fw, f->data + hlen, f->size - hlen);
> +
> +	release_firmware(f);
> +	return err;
> +}
> +
> +static int mvsw_pr_pci_probe(struct pci_dev *pdev,
> +			     const struct pci_device_id *id)
> +{
> +	const char *driver_name = pdev->driver->name;
> +	struct mvsw_pr_fw *fw;
> +	u8 __iomem *mem_addr;
> +	int err;
> +
> +	err = pci_enable_device(pdev);
> +	if (err) {
> +		dev_err(&pdev->dev, "pci_enable_device failed\n");
> +		goto err_pci_enable_device;
> +	}
> +
> +	err = pci_request_regions(pdev, driver_name);
> +	if (err) {
> +		dev_err(&pdev->dev, "pci_request_regions failed\n");
> +		goto err_pci_request_regions;
> +	}
> +
> +	mem_addr = pci_ioremap_bar(pdev, 2);
> +	if (!mem_addr) {
> +		dev_err(&pdev->dev, "ioremap failed\n");
> +		err = -EIO;
> +		goto err_ioremap;
> +	}
> +
> +	pci_set_master(pdev);
> +
> +	fw = kzalloc(sizeof(*fw), GFP_KERNEL);
> +	if (!fw) {
> +		err = -ENOMEM;
> +		goto err_pci_dev_alloc;
> +	}
> +
> +	fw->pci_dev = pdev;
> +	fw->dev.dev = &pdev->dev;
> +	fw->dev.send_req = mvsw_pr_fw_send_req;
> +	fw->mem_addr = mem_addr;
> +	fw->ldr_regs = mem_addr;
> +	fw->hw_regs = mem_addr;
> +
> +	fw->wq = alloc_workqueue("mvsw_fw_wq", WQ_HIGHPRI, 1);
> +	if (!fw->wq)
> +		goto err_wq_alloc;
> +
> +	INIT_WORK(&fw->evt_work, mvsw_pr_fw_evt_work_fn);
> +
> +	err = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_MSI);
> +	if (err < 0) {
> +		dev_err(&pdev->dev, "MSI IRQ init failed\n");
> +		goto err_irq_alloc;
> +	}
> +
> +	err = request_irq(pci_irq_vector(pdev, 0), mvsw_pci_irq_handler,
> +			  0, driver_name, fw);
> +	if (err) {
> +		dev_err(&pdev->dev, "fail to request IRQ\n");
> +		goto err_request_irq;
> +	}
> +
> +	pci_set_drvdata(pdev, fw);
> +
> +	err = mvsw_pr_fw_init(fw);
> +	if (err)
> +		goto err_mvsw_fw_init;
> +
> +	dev_info(mvsw_fw_dev(fw), "Prestera Switch FW is ready\n");
> +
> +	err = mvsw_pr_device_register(&fw->dev);
> +	if (err)
> +		goto err_mvsw_dev_register;
> +
> +	return 0;
> +
> +err_mvsw_dev_register:
> +	mvsw_pr_fw_uninit(fw);
> +err_mvsw_fw_init:
> +	free_irq(pci_irq_vector(pdev, 0), fw);
> +err_request_irq:
> +	pci_free_irq_vectors(pdev);
> +err_irq_alloc:
> +	destroy_workqueue(fw->wq);
> +err_wq_alloc:
> +	kfree(fw);
> +err_pci_dev_alloc:
> +	iounmap(mem_addr);
> +err_ioremap:
> +	pci_release_regions(pdev);
> +err_pci_request_regions:
> +	pci_disable_device(pdev);
> +err_pci_enable_device:
> +	return err;
> +}
> +
> +static void mvsw_pr_pci_remove(struct pci_dev *pdev)
> +{
> +	struct mvsw_pr_fw *fw = pci_get_drvdata(pdev);
> +
> +	free_irq(pci_irq_vector(pdev, 0), fw);
> +	pci_free_irq_vectors(pdev);
> +	mvsw_pr_device_unregister(&fw->dev);
> +	flush_workqueue(fw->wq);
> +	destroy_workqueue(fw->wq);
> +	mvsw_pr_fw_uninit(fw);
> +	iounmap(fw->mem_addr);
> +	pci_release_regions(pdev);
> +	pci_disable_device(pdev);
> +	kfree(fw);
> +}
> +


> +static int __init mvsw_pr_pci_init(void)
> +{
> +	struct mvsw_pr_pci_match *match;
> +	int err;
> +
> +	for (match = mvsw_pci_devices; match->driver.name; match++) {
> +		match->driver.probe = mvsw_pr_pci_probe;
> +		match->driver.remove = mvsw_pr_pci_remove;
> +		match->driver.id_table = &match->id;
> +
> +		err = pci_register_driver(&match->driver);
> +		if (err) {
> +			pr_err("prestera_pci: failed to register %s\n",
> +			       match->driver.name);
> +			break;
> +		}
> +
> +		match->registered = true;
> +	}

Please don't reinvent the wheel. You should just do something like:

static const struct pci_device_id ilo_devices[] = {
        { PCI_DEVICE(PCI_VENDOR_ID_COMPAQ, 0xB204) },
        { PCI_DEVICE(PCI_VENDOR_ID_HP, 0x3307) },
        { }
};
MODULE_DEVICE_TABLE(pci, ilo_devices);

static struct pci_driver ilo_driver = {
        .name     = ILO_NAME,
        .id_table = ilo_devices,
        .probe    = ilo_probe,
        .remove   = ilo_remove,
};

        error = pci_register_driver(&ilo_driver);

If you need extra information, you can make use of pci_device_id:driver_data.

> +	if (err) {
> +		for (match = mvsw_pci_devices; match->driver.name; match++) {
> +			if (!match->registered)
> +				break;
> +
> +			pci_unregister_driver(&match->driver);
> +		}
> +
> +		return err;
> +	}
> +
> +	pr_info("prestera_pci: Registered Marvell Prestera PCI driver\n");

Don't spam the kernel log.

> +static void __exit mvsw_pr_pci_exit(void)
> +{
> +	struct mvsw_pr_pci_match *match;
> +
> +	for (match = mvsw_pci_devices; match->driver.name; match++) {
> +		if (!match->registered)
> +			break;
> +
> +		pci_unregister_driver(&match->driver);
> +	}
> +
> +	pr_info("prestera_pci: Unregistered Marvell Prestera PCI driver\n");

More spamming of the kernel log.

     Andrew
