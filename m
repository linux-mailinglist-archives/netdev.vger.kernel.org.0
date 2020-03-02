Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA4B017680E
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 00:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgCBXYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 18:24:30 -0500
Received: from mga18.intel.com ([134.134.136.126]:14826 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726728AbgCBXYa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 18:24:30 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:24:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="258143105"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.106]) ([134.134.177.106])
  by orsmga002.jf.intel.com with ESMTP; 02 Mar 2020 15:24:29 -0800
Subject: Re: [PATCH 1/5] pci: introduce pci_get_dsn
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        QLogic-Storage-Upstream@cavium.com,
        Michael Chan <michael.chan@broadcom.com>
References: <20200302232057.GA182308@google.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <2fa00fef-7d11-d0b6-49a0-85a2b08a144d@intel.com>
Date:   Mon, 2 Mar 2020 15:24:29 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200302232057.GA182308@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/2/2020 3:20 PM, Bjorn Helgaas wrote:
> On Mon, Mar 02, 2020 at 02:33:12PM -0800, Jacob Keller wrote:
>> On 3/2/2020 2:25 PM, Bjorn Helgaas wrote:
> 
>>>> +int pci_get_dsn(struct pci_dev *dev, u8 dsn[])
>>>> +{
>>>> +	u32 dword;
>>>> +	int pos;
>>>> +
>>>> +
>>>> +	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_DSN);
>>>> +	if (!pos)
>>>> +		return -EOPNOTSUPP;
>>>> +
>>>> +	/*
>>>> +	 * The Device Serial Number is two dwords offset 4 bytes from the
>>>> +	 * capability position.
>>>> +	 */
>>>> +	pos += 4;
>>>> +	pci_read_config_dword(dev, pos, &dword);
>>>> +	put_unaligned_le32(dword, &dsn[0]);
>>>> +	pci_read_config_dword(dev, pos + 4, &dword);
>>>> +	put_unaligned_le32(dword, &dsn[4]);
>>>
>>> Since the serial number is a 64-bit value, can we just return a u64
>>> and let the caller worry about any alignment and byte-order issues?
>>>
>>> This would be the only use of asm/unaligned.h in driver/pci, and I
>>> don't think DSN should be that special.
>>
>> I suppose that's fair, but it ends up leaving most callers having to fix
>> this immediately after calling this function.
> 
> PCIe doesn't impose any structure on the value; it just says the first
> dword is the lower DW and the second is the upper DW.  As long as we
> put that together correctly into a u64, I think further interpretation
> is caller-specific.
> 

Makes sense. So basically, convert pci_get_dsn to a simply return a u64
instead of copying to an array, and then make callers assume that a
value of 0 is invalid?

Thanks,
Jake
