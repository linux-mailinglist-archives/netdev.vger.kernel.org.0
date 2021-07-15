Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F0C3CA01A
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 15:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238083AbhGONxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 09:53:45 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:36211 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229832AbhGONxo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Jul 2021 09:53:44 -0400
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 7641061E5FE00;
        Thu, 15 Jul 2021 15:50:49 +0200 (CEST)
Subject: Re: [RFC][PATCH] PCI: Reserve address space for powered-off devices
 behind PCIe bridges
From:   Paul Menzel <pmenzel@molgen.mpg.de>
To:     Bjorn Helgaas <bhelgaas@google.com>
Cc:     Guohan Lu <lguohan@gmail.com>, Billie Alsup <balsup@cisco.com>,
        Madhava Reddy Siddareddygari <msiddare@cisco.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20210713073124.177027-1-pmenzel@molgen.mpg.de>
Message-ID: <49cb0be4-d2ac-2fbd-9327-fa7341a014e2@molgen.mpg.de>
Date:   Thu, 15 Jul 2021 15:50:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210713073124.177027-1-pmenzel@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Add Billie’s correct address.]

Am 13.07.21 um 09:31 schrieb Paul Menzel:
> From: balsup <balsup@contoso.com>

Billie Alsup <balsup@cisco.com>

> Data path devices are powered off by default, they will not be visible at
> BIOS stage and memory for these devices is not reserved.
> 
> By default, no address space would be reserved on the bridges for these
> unpowered devices. When they were powered up, they could fail to initialize
> because there was no appropriately aligned window available for a given
> BAR.
> 
> This patch will reserve address space for data path devices that are behind
> PCIe bridge, so that when devices are available PCIe subsystem will be
> assign the address within the specified range.
> 
> Signed-off-by: Madhava Reddy Siddareddygari <msiddare@cisco.com>
> ---
> This patch was submitted to the SONiC project for a Cisco device [1].
> It’s better to have it reviewed and committed upstream though.
> 
>   drivers/pci/setup-bus.c | 159 ++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 159 insertions(+)
> 
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index 2ce636937c6e..266097984e19 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -967,6 +967,148 @@ static inline resource_size_t calculate_mem_align(resource_size_t *aligns,
>   	return min_align;
>   }
>   
> +#define PLX_RES_MAGIC_VALUE            0xABBA
> +#define PLX_RES_DS_PORT_REG0           0xC6C
> +#define PLX_RES_DS_PORT_REG1           0xC70
> +#define PLX_RES_MAGIC_OFFSET           0xC76
> +#define PLX_RES_NP_MASK                0x1
> +#define PLX_RES_P_MASK                 0x1F
> +
> +static struct pci_dev *
> +plx_find_nt_device(struct pci_bus *bus, unsigned short brg_dev_id)
> +{
> +	struct pci_dev *dev, *nt_virt_dev = NULL;
> +	struct pci_bus *child_bus;
> +	unsigned short vendor, devid, class;
> +
> +	if (!bus)
> +		return NULL;
> +
> +	list_for_each_entry(child_bus, &bus->children, node) {
> +		list_for_each_entry(dev, &child_bus->devices, bus_list) {
> +			vendor = dev->vendor;
> +			devid = dev->device;
> +			class = dev->class >> 8;
> +
> +			if ((vendor == PCI_VENDOR_ID_PLX) &&
> +					(brg_dev_id == devid) &&
> +					(class == PCI_CLASS_BRIDGE_OTHER)) {
> +				dev_dbg(&dev->dev, "Found NT device 0x%x\n",
> +						devid);
> +				nt_virt_dev = dev;
> +				break;
> +			}
> +		}
> +
> +		if (nt_virt_dev)
> +			break;
> +	}
> +	return nt_virt_dev;
> +}
> +
> +static resource_size_t
> +pci_get_plx_downstream_res_size(struct pci_bus *bus, unsigned long res_type)
> +{
> +	int depth = 0;
> +	resource_size_t size = 0;
> +	struct pci_dev *dev = bus->self;
> +	struct pci_bus *tmp_bus;
> +	struct pci_dev *nt_virt_dev;
> +	u16 res_magic = 0;
> +
> +	/*
> +	 * 32 bits to store the memory requirement for PLX ports.
> +	 * Following is the layout:
> +	 * np32_0:1;  --> non-prefetchable port 0
> +	 * p64_0:5;   --> prefetchable port 0
> +	 * np32_1:1;  --> non-prefetchable port 1
> +	 * p64_1:5;   --> prefetchable port 1
> +	 * np32_2:1;  --> non-prefetchable port 2
> +	 * p64_2:5;   --> prefetchable port 2
> +	 * np32_3:1;  --> non-prefetchable port 3
> +	 * p64_3:5;   --> prefetchable port 3
> +	 * np32_4:1;  --> non-prefetchable port 4
> +	 * p64_4:5;   --> prefetchable port 4
> +	 * reserved:2;
> +	 */
> +	unsigned int port_bitmap;
> +
> +	u32 mem_res_bitmap = 0;
> +	unsigned int ds_port_offset = 0;
> +	unsigned short multiplier = 0;
> +	unsigned short np_size = 0;
> +
> +	/*
> +	 * PLX8713 used on FC4 and FC8
> +	 * PLX8725 used on FC12 and FC18
> +	 */
> +	if (!dev || dev->vendor != PCI_VENDOR_ID_PLX ||
> +			((dev->device & 0xFF00) != 0x8700))
> +		return size;
> +
> +	tmp_bus = bus;
> +	while (tmp_bus->parent) {
> +		tmp_bus = tmp_bus->parent;
> +		depth++;
> +	}
> +
> +	/* Only for Second level bridges */
> +	if (depth != 5)
> +		return size;
> +
> +	nt_virt_dev = plx_find_nt_device(bus->parent, 0x87b0);
> +	if (nt_virt_dev) {
> +		pci_read_config_word(nt_virt_dev, PLX_RES_MAGIC_OFFSET,
> +				&res_magic);
> +		dev_dbg(&nt_virt_dev->dev,
> +				"Magic offset of 0x%x found in NT device\n", res_magic);
> +	}
> +
> +	if (res_magic == PLX_RES_MAGIC_VALUE) {
> +		/*
> +		 * The pacifics are connected on PLX ports:
> +		 *  FC4 and FC8: #3, #4
> +		 *  FC12       : #3, #4, #5
> +		 *  FC18       : #3, #4, #5, #11
> +		 */
> +
> +		/* Calculate resource based on EEPROM values */
> +		ds_port_offset = (bus->number - bus->parent->number) - 1;
> +		if (ds_port_offset < 5) {
> +			pci_read_config_dword(nt_virt_dev, PLX_RES_DS_PORT_REG0,
> +					&mem_res_bitmap);
> +		} else {
> +			ds_port_offset -= 5;
> +			pci_read_config_dword(nt_virt_dev, PLX_RES_DS_PORT_REG1,
> +					&mem_res_bitmap);
> +		}
> +		port_bitmap = mem_res_bitmap;
> +		dev_dbg(&bus->dev, "Port offset: 0x%x, res bitmap 0x%x\n",
> +				ds_port_offset, mem_res_bitmap);
> +
> +		if (ds_port_offset < 5) {
> +			u8 m[] = { 26, 20, 14, 8, 2 };
> +			u8 s[] = { 31, 25, 19, 13, 7 };
> +
> +			multiplier = (port_bitmap >> m[ds_port_offset]) & PLX_RES_P_MASK;
> +			np_size = (port_bitmap >> s[ds_port_offset]) & PLX_RES_NP_MASK;
> +
> +			dev_dbg(&bus->dev, "Multiplier: %d, np_size: %d\n",
> +					multiplier, np_size);
> +
> +			if (res_type & IORESOURCE_PREFETCH) {
> +				size = 0x100000 << (multiplier - 1);
> +				dev_dbg(&bus->dev, "Pref Multiplier %d, Size 0x%llx\n",
> +						multiplier, (long long) size);
> +			} else if (np_size) {
> +				size = 0x100000;
> +				dev_dbg(&bus->dev, "NP Size 0x%llx\n", (long long) size);
> +			}
> +		}
> +	}
> +	return size;
> +}
> +
>   /**
>    * pbus_size_mem() - Size the memory window of a given bus
>    *
> @@ -1001,6 +1143,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
>   	resource_size_t children_add_size = 0;
>   	resource_size_t children_add_align = 0;
>   	resource_size_t add_align = 0;
> +	unsigned int dev_count = 0;
>   
>   	if (!b_res)
>   		return -ENOSPC;
> @@ -1016,6 +1159,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
>   	list_for_each_entry(dev, &bus->devices, bus_list) {
>   		int i;
>   
> +		dev_count++;
>   		for (i = 0; i < PCI_NUM_RESOURCES; i++) {
>   			struct resource *r = &dev->resource[i];
>   			resource_size_t r_size;
> @@ -1071,6 +1215,21 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
>   		}
>   	}
>   
> +	/* Static allocation for FC pacific */
> +	if (!size && !dev_count) {
> +		size = pci_get_plx_downstream_res_size(bus, type);
> +		if (size) {
> +			order = __ffs(size);
> +			dev_dbg(&bus->self->dev, "order for %llx is %u\n", (long long) size, order);
> +			if ((order >= 20) &&
> +					((order -= 20) < ARRAY_SIZE(aligns)) &&
> +					(order > max_order)) {
> +				max_order = order;
> +				dev_dbg(&bus->self->dev, "max_order reset to %d; size %zx\n", max_order, (size_t)size);
> +			}
> +		}
> +	}
> +
>   	min_align = calculate_mem_align(aligns, max_order);
>   	min_align = max(min_align, window_alignment(bus, b_res->flags));
>   	size0 = calculate_memsize(size, min_size, 0, 0, resource_size(b_res), min_align);

This is basically a request for comments, how to deal with such 
hardware, which is going to run Linux based network operating systems 
(NOS) like SONiC.

Would hotplugging be an option, and could you give pointers?


Kind regards,

Paul
