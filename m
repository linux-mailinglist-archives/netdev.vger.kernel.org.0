Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B657D22B84A
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 23:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgGWVDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 17:03:19 -0400
Received: from mga05.intel.com ([192.55.52.43]:29354 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726068AbgGWVDT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 17:03:19 -0400
IronPort-SDR: jjztxLyolvN963NrxLOvTQzYgy74K9wrW2CZFAfYh8YITU28fp/ERpBttCbbas1O0MMV7aNOd1
 C+oMvUAaPbUA==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="235499483"
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="235499483"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 14:03:18 -0700
IronPort-SDR: Px3eLFpmpIlqKQRmpr7v+deNNnNJqq/4r7UhAEwRZcrZSPwjyfnDPnMY3v5YQUhKTey1liR0Ks
 5zKBfwf6mqnw==
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="462995797"
Received: from ahduyck-mobl1.amr.corp.intel.com (HELO [10.254.79.109]) ([10.254.79.109])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 14:03:17 -0700
Subject: Re: [net-next 10/10] net/mlx5e: Add support for PCI relaxed ordering
To:     Aya Levin <ayal@mellanox.com>, David Miller <davem@davemloft.net>,
        helgaas@kernel.org
Cc:     kuba@kernel.org, saeedm@mellanox.com, mkubecek@suse.cz,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        tariqt@mellanox.com, Jason Gunthorpe <jgg@nvidia.com>
References: <19a722952a2b91cc3b26076b8fd74afdfbfaa7a4.camel@mellanox.com>
 <20200624133018.5a4d238b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <7b79eead-ceab-5d95-fd91-cabeeef82d6a@mellanox.com>
 <20200706.124947.1335511480336755384.davem@davemloft.net>
 <0506f0aa-f35e-09c7-5ba0-b74cd9eb1384@mellanox.com>
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
Message-ID: <8194d160-e6ed-8daf-7f68-cc57fd504d4a@linux.intel.com>
Date:   Thu, 23 Jul 2020 14:03:17 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0506f0aa-f35e-09c7-5ba0-b74cd9eb1384@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/8/2040 1:22 AM, Aya Levin wrote:
> 
> 
> On 7/6/2020 10:49 PM, David Miller wrote:
>> From: Aya Levin <ayal@mellanox.com>
>> Date: Mon, 6 Jul 2020 16:00:59 +0300
>>
>>> Assuming the discussions with Bjorn will conclude in a well-trusted
>>> API that ensures relaxed ordering in enabled, I'd still like a method
>>> to turn off relaxed ordering for performance debugging sake.
>>> Bjorn highlighted the fact that the PCIe sub system can only offer a
>>> query method. Even if theoretically a set API will be provided, this
>>> will not fit a netdev debugging - I wonder if CPU vendors even support
>>> relaxed ordering set/unset...
>>> On the driver's side relaxed ordering is an attribute of the mkey and
>>> should be available for configuration (similar to number of CPU
>>> vs. number of channels).
>>> Based on the above, and binding the driver's default relaxed ordering
>>> to the return value from pcie_relaxed_ordering_enabled(), may I
>>> continue with previous direction of a private-flag to control the
>>> client side (my driver) ?
>>
>> I don't like this situation at all.
>>
>> If RO is so dodgy that it potentially needs to be disabled, that is
>> going to be an issue not just with networking devices but also with
>> storage and other device types as well.
>>
>> Will every device type have a custom way to disable RO, thus
>> inconsistently, in order to accomodate this?
>>
>> That makes no sense and is a terrible user experience.
>>
>> That's why the knob belongs generically in PCI or similar.
>>
> Hi Bjorn,
> 
> Mellanox NIC supports relaxed ordering operation over DMA buffers. 
> However for debug prepossess we must have a chicken bit to disable 
> relaxed ordering on a specific system without effecting others in 
> run-time. In order to meet this requirement, I added a netdev 
> private-flag to ethtool for set RO API.
> 
> Dave raised a concern regarding embedding relaxed ordering set API per 
> system (networking, storage and others). We need the ability to manage 
> relaxed ordering in a unify manner. Could you please define a PCI 
> sub-system solution to meet this requirement?
> 
> Aya.

Isn't there a relaxed ordering bit in the PCIe configuration space? 
Couldn't you use that as a global indication of if you can support 
relaxed ordering or not? Reading through the spec it seems like that is 
kind of the point of the config space bit in the Device Control 
register. If the bit is not set there then you shouldn't be able to use 
relaxed ordering in the device.

Then it is just a matter of using setpci to enable/disable it.

Thanks.

- Alex
