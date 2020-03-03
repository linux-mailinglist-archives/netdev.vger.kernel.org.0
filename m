Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF7E7177D9F
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 18:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730492AbgCCRgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 12:36:54 -0500
Received: from mga17.intel.com ([192.55.52.151]:47673 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727993AbgCCRgx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 12:36:53 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 09:36:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,511,1574150400"; 
   d="scan'208";a="229000291"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.106]) ([134.134.177.106])
  by orsmga007.jf.intel.com with ESMTP; 03 Mar 2020 09:36:47 -0800
Subject: Re: [PATCH v2 6/6] nfp: Use pci_get_dsn()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        David Miller <davem@davemloft.net>
References: <CABhMZUXJ_Omt-+fwa4Oz-Ly=J+NM8+8Ryv-Ad1u_bgEpDRH7RQ@mail.gmail.com>
 <20200303022506.1792776-1-jacob.e.keller@intel.com>
 <20200303022506.1792776-7-jacob.e.keller@intel.com>
 <20200302194044.27eb9e5a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <fe15eb21-76c8-643d-9561-d3d2e12670f8@intel.com>
Date:   Tue, 3 Mar 2020 09:36:47 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200302194044.27eb9e5a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/2/2020 7:40 PM, Jakub Kicinski wrote:
> On Mon,  2 Mar 2020 18:25:05 -0800 Jacob Keller wrote:
>> Use the newly added pci_get_dsn() function for obtaining the 64-bit
>> Device Serial Number in the nfp6000_read_serial and
>> nfp_6000_get_interface functions.
>>
>> pci_get_dsn() reports the Device Serial number as a u64 value created by
>> combining two pci_read_config_dword functions. The lower 16 bits
>> represent the device interface value, and the next 48 bits represent the
>> serial value. Use put_unaligned_be32 and put_unaligned_be16 to convert
>> the serial value portion into a Big Endian formatted serial u8 array.
>>
>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>> Cc: Jakub Kicinski <kuba@kernel.org>
> 
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>
> 
> Thanks!
> 
>> -	pci_read_config_dword(pdev, pos + 4, &reg);
>> -	put_unaligned_be16(reg >> 16, serial + 4);
>> -	pci_read_config_dword(pdev, pos + 8, &reg);
>> -	put_unaligned_be32(reg, serial);
>> +	put_unaligned_be32((u32)(dsn >> 32), serial);
>> +	put_unaligned_be16((u16)(dsn >> 16), serial + 4);
> 
> nit: the casts and extra brackets should be unnecessary, in case
>      you're respinning..
> 

Ah, yea because the argument will get converted properly by the
function. It's a bit of a habit since we use one of the -W warnings that
warns about implicit conversions that use truncation. I can remove them
if I need to respin.

It looks like this got picked up by one of the kbuild bots but got
applied without the main PCI patch that implemented pci_get_dsn.

Thanks,
Jake
