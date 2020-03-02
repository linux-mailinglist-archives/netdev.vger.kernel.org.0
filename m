Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22E6D176766
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 23:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgCBWdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 17:33:14 -0500
Received: from mga05.intel.com ([192.55.52.43]:41130 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726752AbgCBWdN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 17:33:13 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 14:33:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,508,1574150400"; 
   d="scan'208";a="258122045"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.106]) ([134.134.177.106])
  by orsmga002.jf.intel.com with ESMTP; 02 Mar 2020 14:33:12 -0800
Subject: Re: [PATCH 1/5] pci: introduce pci_get_dsn
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        QLogic-Storage-Upstream@cavium.com,
        Michael Chan <michael.chan@broadcom.com>
References: <20200302222510.GA172509@google.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <ccec830f-b932-366a-de61-46159a99b5c9@intel.com>
Date:   Mon, 2 Mar 2020 14:33:12 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200302222510.GA172509@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/2/2020 2:25 PM, Bjorn Helgaas wrote:
>   PCI: Introduce pci_get_dsn()
> 
> I learned this from "git log --oneline drivers/pci/pci.c".  It looks
> like the other patches could benefit from this as well.
> 

Sure, will follow that precedent.

> On Thu, Feb 27, 2020 at 02:36:31PM -0800, Jacob Keller wrote:
>> Several device drivers read their Device Serial Number from the PCIe
>> extended config space.
>>
>> Introduce a new helper function, pci_get_dsn, which will read the
>> eight bytes of the DSN into the provided buffer.
> 
> "pci_get_dsn()"
> 
>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>> Cc: Bjorn Helgaas <bhelgaas@google.com>
>> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>> Cc: QLogic-Storage-Upstream@cavium.com
>> Cc: Michael Chan <michael.chan@broadcom.com>
>> ---
>>  drivers/pci/pci.c   | 33 +++++++++++++++++++++++++++++++++
>>  include/linux/pci.h |  5 +++++
>>  2 files changed, 38 insertions(+)
>>
>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>> index d828ca835a98..12d8101724d7 100644
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -33,6 +33,7 @@
>>  #include <linux/pci-ats.h>
>>  #include <asm/setup.h>
>>  #include <asm/dma.h>
>> +#include <asm/unaligned.h>
>>  #include <linux/aer.h>
>>  #include "pci.h"
>>  
>> @@ -557,6 +558,38 @@ int pci_find_ext_capability(struct pci_dev *dev, int cap)
>>  }
>>  EXPORT_SYMBOL_GPL(pci_find_ext_capability);
>>  
>> +/**
>> + * pci_get_dsn - Read the 8-byte Device Serial Number
>> + * @dev: PCI device to query
>> + * @dsn: storage for the DSN. Must be at least 8 bytes
>> + *
>> + * Looks up the PCI_EXT_CAP_ID_DSN and reads the 8 bytes into the dsn storage.
>> + * Returns -EOPNOTSUPP if the device does not have the capability.
>> + */
>> +int pci_get_dsn(struct pci_dev *dev, u8 dsn[])
>> +{
>> +	u32 dword;
>> +	int pos;
>> +
>> +
>> +	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_DSN);
>> +	if (!pos)
>> +		return -EOPNOTSUPP;
>> +
>> +	/*
>> +	 * The Device Serial Number is two dwords offset 4 bytes from the
>> +	 * capability position.
>> +	 */
>> +	pos += 4;
>> +	pci_read_config_dword(dev, pos, &dword);
>> +	put_unaligned_le32(dword, &dsn[0]);
>> +	pci_read_config_dword(dev, pos + 4, &dword);
>> +	put_unaligned_le32(dword, &dsn[4]);
> 
> Since the serial number is a 64-bit value, can we just return a u64
> and let the caller worry about any alignment and byte-order issues?
> 
> This would be the only use of asm/unaligned.h in driver/pci, and I
> don't think DSN should be that special.

I suppose that's fair, but it ends up leaving most callers having to fix
this immediately after calling this function.

> 
> I think it's OK if we return 0 if the device doesn't have a DSN
> capability.  A DSN that actually contains a zero serial number would
> be dubious at best.

Hmm. I was trying to match how pre-existing code behaved, based on the
ice and bnxt drivers.

By returning 0s, we'd have to then perform a memcmp or something to
catch it.

> 
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(pci_get_dsn);
>> +
>>  static int __pci_find_next_ht_cap(struct pci_dev *dev, int pos, int ht_cap)
>>  {
>>  	int rc, ttl = PCI_FIND_CAP_TTL;
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index 3840a541a9de..883562323df3 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -1045,6 +1045,8 @@ int pci_find_ht_capability(struct pci_dev *dev, int ht_cap);
>>  int pci_find_next_ht_capability(struct pci_dev *dev, int pos, int ht_cap);
>>  struct pci_bus *pci_find_next_bus(const struct pci_bus *from);
>>  
>> +int pci_get_dsn(struct pci_dev *dev, u8 dsn[]);
>> +
>>  struct pci_dev *pci_get_device(unsigned int vendor, unsigned int device,
>>  			       struct pci_dev *from);
>>  struct pci_dev *pci_get_subsys(unsigned int vendor, unsigned int device,
>> @@ -1699,6 +1701,9 @@ static inline int pci_find_next_capability(struct pci_dev *dev, u8 post,
>>  static inline int pci_find_ext_capability(struct pci_dev *dev, int cap)
>>  { return 0; }
>>  
>> +static inline int pci_get_dsn(struct pci_dev *dev, u8 dsn[])
>> +{ return -EOPNOTSUPP; }
>> +
>>  /* Power management related routines */
>>  static inline int pci_save_state(struct pci_dev *dev) { return 0; }
>>  static inline void pci_restore_state(struct pci_dev *dev) { }
>> -- 
>> 2.25.0.368.g28a2d05eebfb
>>
