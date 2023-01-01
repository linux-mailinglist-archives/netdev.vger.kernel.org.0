Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC76B65A999
	for <lists+netdev@lfdr.de>; Sun,  1 Jan 2023 11:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjAAKe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Jan 2023 05:34:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjAAKeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Jan 2023 05:34:25 -0500
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C206152;
        Sun,  1 Jan 2023 02:34:23 -0800 (PST)
Received: from [192.168.0.2] (ip5f5aefd4.dynamic.kabel-deutschland.de [95.90.239.212])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id F17AE60027FCB;
        Sun,  1 Jan 2023 11:34:21 +0100 (CET)
Message-ID: <a4216a94-72b3-4711-bc90-ad564a57b310@molgen.mpg.de>
Date:   Sun, 1 Jan 2023 11:34:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [Intel-wired-lan] [PATCH] igc: Mask replay rollover/timeout
 errors in I225_LMVP
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>,
        Rajat Khandelwal <rajat.khandelwal@linux.intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, rajat.khandelwal@intel.com,
        jesse.brandeburg@intel.com, linux-kernel@vger.kernel.org,
        edumazet@google.com, anthony.l.nguyen@intel.com,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        davem@davemloft.net, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org
References: <20221229122640.239859-1-rajat.khandelwal@linux.intel.com>
 <Y7FFESJONJqGJUkb@unreal>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <Y7FFESJONJqGJUkb@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Cc: +Bjorn, +linux-pci]

Dear Leon, dear Rajat,


Am 01.01.23 um 09:32 schrieb Leon Romanovsky:
> On Thu, Dec 29, 2022 at 05:56:40PM +0530, Rajat Khandelwal wrote:
>> The CPU logs get flooded with replay rollover/timeout AER errors in
>> the system with i225_lmvp connected, usually inside thunderbolt devices.
>>
>> One of the prominent TBT4 docks we use is HP G4 Hook2, which incorporates
>> an Intel Foxville chipset, which uses the igc driver.
>> On connecting ethernet, CPU logs get inundated with these errors. The point
>> is we shouldn't be spamming the logs with such correctible errors as it
>> confuses other kernel developers less familiar with PCI errors, support
>> staff, and users who happen to look at the logs.
>>
>> Signed-off-by: Rajat Khandelwal <rajat.khandelwal@linux.intel.com>
>> ---
>>   drivers/net/ethernet/intel/igc/igc_main.c | 28 +++++++++++++++++++++--
>>   1 file changed, 26 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
>> index ebff0e04045d..a3a6e8086c8d 100644
>> --- a/drivers/net/ethernet/intel/igc/igc_main.c
>> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
>> @@ -6201,6 +6201,26 @@ u32 igc_rd32(struct igc_hw *hw, u32 reg)
>>   	return value;
>>   }
>>   
>> +#ifdef CONFIG_PCIEAER
>> +static void igc_mask_aer_replay_correctible(struct igc_adapter *adapter)
>> +{
>> +	struct pci_dev *pdev = adapter->pdev;
>> +	u32 aer_pos, corr_mask;
>> +
>> +	if (pdev->device != IGC_DEV_ID_I225_LMVP)
>> +		return;
>> +
>> +	aer_pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ERR);
>> +	if (!aer_pos)
>> +		return;
>> +
>> +	pci_read_config_dword(pdev, aer_pos + PCI_ERR_COR_MASK, &corr_mask);
>> +
>> +	corr_mask |= PCI_ERR_COR_REP_ROLL | PCI_ERR_COR_REP_TIMER;
>> +	pci_write_config_dword(pdev, aer_pos + PCI_ERR_COR_MASK, corr_mask);
> 
> Shouldn't this igc_mask_aer_replay_correctible function be implemented
> in drivers/pci/quirks.c and not in igc_probe()?

Probably. Though I think, the PCI quirk file, is getting too big.


Kind regards,

Paul
