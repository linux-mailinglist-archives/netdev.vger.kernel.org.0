Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB5FDA4FE
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 07:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732174AbfJQFJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 01:09:48 -0400
Received: from mga14.intel.com ([192.55.52.115]:19219 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726441AbfJQFJs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 01:09:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 22:09:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,306,1566889200"; 
   d="scan'208";a="396136357"
Received: from aeliyaho-mobl2.ger.corp.intel.com (HELO [10.254.155.121]) ([10.254.155.121])
  by fmsmga005.fm.intel.com with ESMTP; 16 Oct 2019 22:09:45 -0700
Subject: Re: [net-next 4/7] e1000e: Add support for S0ix
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Vitaly Lifshits <vitaly.lifshits@intel.com>,
        Rajneesh Bhardwaj <rajneesh.bhardwaj@linux.intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>
References: <20191016234711.21823-1-jeffrey.t.kirsher@intel.com>
 <20191016234711.21823-5-jeffrey.t.kirsher@intel.com>
 <20191016170231.4ac6a021@cakuba.netronome.com>
From:   "Neftin, Sasha" <sasha.neftin@intel.com>
Message-ID: <4b3c828c-4aaa-0fe1-028f-c84742a529f7@intel.com>
Date:   Thu, 17 Oct 2019 08:09:44 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191016170231.4ac6a021@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/17/2019 03:02, Jakub Kicinski wrote:
> On Wed, 16 Oct 2019 16:47:08 -0700, Jeff Kirsher wrote:
>>   static int e1000e_pm_freeze(struct device *dev)
>>   {
>>   	struct net_device *netdev = dev_get_drvdata(dev);
>> @@ -6650,6 +6822,9 @@ static int e1000e_pm_thaw(struct device *dev)
>>   static int e1000e_pm_suspend(struct device *dev)
>>   {
>>   	struct pci_dev *pdev = to_pci_dev(dev);
>> +	struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
>> +	struct e1000_adapter *adapter = netdev_priv(netdev);
>> +	struct e1000_hw *hw = &adapter->hw;
>>   	int rc;
> 
> reverse xmas tree?
> 
What do you suggest, move the 'struct pci_dev *pdev' two lines below?
>>   
>>   	e1000e_flush_lpic(pdev);
>> @@ -6660,14 +6835,25 @@ static int e1000e_pm_suspend(struct device *dev)
>>   	if (rc)
>>   		e1000e_pm_thaw(dev);
>>   
>> +	/* Introduce S0ix implementation */
>> +	if (hw->mac.type >= e1000_pch_cnp)
>> +		e1000e_s0ix_entry_flow(adapter);
> 
> the entry/exit functions never fail, you can make them return void
> 
Thanks Jakub for yor comment.This is only initial flow. We continue 
development S0ix support for next product and I consider add error code 
if it will required.
>>   	return rc;
>>   }
>>   
>>   static int e1000e_pm_resume(struct device *dev)
>>   {
>>   	struct pci_dev *pdev = to_pci_dev(dev);
>> +	struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
>> +	struct e1000_adapter *adapter = netdev_priv(netdev);
>> +	struct e1000_hw *hw = &adapter->hw;
>>   	int rc;
>>   
>> +	/* Introduce S0ix implementation */
>> +	if (hw->mac.type >= e1000_pch_cnp)
>> +		e1000e_s0ix_exit_flow(adapter);
>> +
>>   	rc = __e1000_resume(pdev);
>>   	if (rc)
>>   		return rc;

