Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8176220EF5B
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 09:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731019AbgF3HcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 03:32:19 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:53666 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730089AbgF3HcT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 03:32:19 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D375CF28A4BA8919D1DB;
        Tue, 30 Jun 2020 15:32:16 +0800 (CST)
Received: from [127.0.0.1] (10.174.178.46) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Tue, 30 Jun 2020
 15:32:13 +0800
Subject: Re: [net-next 10/10] net/mlx5e: Add support for PCI relaxed ordering
To:     "Raj, Ashok" <ashok.raj@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>
CC:     Aya Levin <ayal@mellanox.com>, Jakub Kicinski <kuba@kernel.org>,
        "Saeed Mahameed" <saeedm@mellanox.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        <linux-pci@vger.kernel.org>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Casey Leedom <leedom@chelsio.com>
References: <ca121a18-8c11-5830-9840-51f353c3ddd2@mellanox.com>
 <20200629193316.GA3283437@bjorn-Precision-5520>
 <20200629195759.GA255688@otc-nc-03>
From:   Ding Tianhong <dingtianhong@huawei.com>
Message-ID: <edad6af6-c7b9-c6ae-9002-71a92bcd81ee@huawei.com>
Date:   Tue, 30 Jun 2020 15:32:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200629195759.GA255688@otc-nc-03>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.46]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



ÔÚ 2020/6/30 3:57, Raj, Ashok Ð´µÀ:
> Hi Bjorn
> 
> 
> On Mon, Jun 29, 2020 at 02:33:16PM -0500, Bjorn Helgaas wrote:
>> [+cc Ashok, Ding, Casey]
>>
>> On Mon, Jun 29, 2020 at 12:32:44PM +0300, Aya Levin wrote:
>>> I wanted to turn on RO on the ETH driver based on
>>> pcie_relaxed_ordering_enabled().
>>> From my experiments I see that pcie_relaxed_ordering_enabled() return true
>>> on Intel(R) Xeon(R) CPU E5-2650 v3 @ 2.30GHz. This CPU is from Haswell
>>> series which is known to have bug in RO implementation. In this case, I
>>> expected pcie_relaxed_ordering_enabled() to return false, shouldn't it?
>>
>> Is there an erratum for this?  How do we know this device has a bug
>> in relaxed ordering?
> 
> https://software.intel.com/content/www/us/en/develop/download/intel-64-and-ia-32-architectures-optimization-reference-manual.html
> 
> For some reason they weren't documented in the errata, but under
> Optimization manual :-)
> 
> Table 3-7. Intel Processor CPU RP Device IDs for Processors Optimizing PCIe
> Performance
> Processor CPU RP Device IDs
> Intel Xeon processors based on Broadwell microarchitecture 6F01H-6F0EH
> Intel Xeon processors based on Haswell microarchitecture 2F01H-2F0EH
> 
> These are the two that were listed in the manual. drivers/pci/quirks.c also
> has an eloborate list of root ports where relaxed_ordering is disabled. Did
> you check if its not already covered here?
> 
> Send lspci if its not already covered by this table.
> 

Looks like the chip series is not in the errta list, but it is really difficult to distinguish and test.

> 
>>
>>> In addition, we are worried about future bugs in new CPUs which may result
>>> in performance degradation while using RO, as long as the function
>>> pcie_relaxed_ordering_enabled() will return true for these CPUs. 
>>
>> I'm worried about this too.  I do not want to add a Device ID to the
>> quirk_relaxedordering_disable() list for every new Intel CPU.  That's
>> a huge hassle and creates a real problem for old kernels running on
>> those new CPUs, because things might work "most of the time" but not
>> always.
> 
> I'll check when this is fixed, i was told newer ones should work properly.
> But I'll confirm.
> 

Maybe prevent the Relax Ordering for all Intel CPUs is a better soluton, looks like
it will not break anything.

Ding
> 
> .
> 

