Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 627BD466CF6
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 23:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377247AbhLBWiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 17:38:02 -0500
Received: from mga07.intel.com ([134.134.136.100]:40876 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1377426AbhLBWhq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 17:37:46 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10186"; a="300245957"
X-IronPort-AV: E=Sophos;i="5.87,282,1631602800"; 
   d="scan'208";a="300245957"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2021 14:34:22 -0800
X-IronPort-AV: E=Sophos;i="5.87,282,1631602800"; 
   d="scan'208";a="746314689"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.10])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2021 14:34:21 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Stefan Dietrich <roots@gmx.de>
Cc:     kuba@kernel.org, greg@kroah.com, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, regressions@lists.linux.dev
Subject: Re: [PATCH] igc: Avoid possible deadlock during suspend/resume
In-Reply-To: <5a4b31d43d9bf32e518188f3ef84c433df3a18b1.camel@gmx.de>
References: <87r1awtdx3.fsf@intel.com>
 <20211201185731.236130-1-vinicius.gomes@intel.com>
 <5a4b31d43d9bf32e518188f3ef84c433df3a18b1.camel@gmx.de>
Date:   Thu, 02 Dec 2021 14:34:21 -0800
Message-ID: <87o85yljpu.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,

Stefan Dietrich <roots@gmx.de> writes:

> Hi Vinicius,
>
> thanks for the patch - unfortunately it did not solve the issue and I
> am still getting reboots/lockups.
>

Thanks for the test. We learned something, not a lot, but something: the
problem you are facing is PTM related and it's not the same bug as that
PM deadlock.

I am still trying to understand what's going on.

Are you able to send me the 'dmesg' output for the two kernel configs
(CONFIG_PCIE_PTM enabled and disabled)? (no need to bring the network
interface up or down). Your kernel .config would be useful as well.

>
> Cheers,
> Stefan
>
> On Wed, 2021-12-01 at 10:57 -0800, Vinicius Costa Gomes wrote:
>> Inspired by:
>> https://bugzilla.kernel.org/show_bug.cgi?id=215129
>>
>> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>> ---
>> Just to see if it's indeed the same problem as the bug report above.
>>
>>  drivers/net/ethernet/intel/igc/igc_main.c | 19 +++++++++++++------
>>  1 file changed, 13 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c
>> b/drivers/net/ethernet/intel/igc/igc_main.c
>> index 0e19b4d02e62..c58bf557a2a1 100644
>> --- a/drivers/net/ethernet/intel/igc/igc_main.c
>> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
>> @@ -6619,7 +6619,7 @@ static void igc_deliver_wake_packet(struct
>> net_device *netdev)
>>  	netif_rx(skb);
>>  }
>>
>> -static int __maybe_unused igc_resume(struct device *dev)
>> +static int __maybe_unused __igc_resume(struct device *dev, bool rpm)
>>  {
>>  	struct pci_dev *pdev = to_pci_dev(dev);
>>  	struct net_device *netdev = pci_get_drvdata(pdev);
>> @@ -6661,20 +6661,27 @@ static int __maybe_unused igc_resume(struct
>> device *dev)
>>
>>  	wr32(IGC_WUS, ~0);
>>
>> -	rtnl_lock();
>> +	if (!rpm)
>> +		rtnl_lock();
>>  	if (!err && netif_running(netdev))
>>  		err = __igc_open(netdev, true);
>>
>>  	if (!err)
>>  		netif_device_attach(netdev);
>> -	rtnl_unlock();
>> +	if (!rpm)
>> +		rtnl_unlock();
>>
>>  	return err;
>>  }
>>
>>  static int __maybe_unused igc_runtime_resume(struct device *dev)
>>  {
>> -	return igc_resume(dev);
>> +	return __igc_resume(dev, true);
>> +}
>> +
>> +static int __maybe_unused igc_resume(struct device *dev)
>> +{
>> +	return __igc_resume(dev, false);
>>  }
>>
>>  static int __maybe_unused igc_suspend(struct device *dev)
>> @@ -6738,7 +6745,7 @@ static pci_ers_result_t
>> igc_io_error_detected(struct pci_dev *pdev,
>>   *  @pdev: Pointer to PCI device
>>   *
>>   *  Restart the card from scratch, as if from a cold-boot.
>> Implementation
>> - *  resembles the first-half of the igc_resume routine.
>> + *  resembles the first-half of the __igc_resume routine.
>>   **/
>>  static pci_ers_result_t igc_io_slot_reset(struct pci_dev *pdev)
>>  {
>> @@ -6777,7 +6784,7 @@ static pci_ers_result_t
>> igc_io_slot_reset(struct pci_dev *pdev)
>>   *
>>   *  This callback is called when the error recovery driver tells us
>> that
>>   *  its OK to resume normal operation. Implementation resembles the
>> - *  second-half of the igc_resume routine.
>> + *  second-half of the __igc_resume routine.
>>   */
>>  static void igc_io_resume(struct pci_dev *pdev)
>>  {
>


Cheers,
-- 
Vinicius
