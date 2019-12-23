Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB42E129611
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 13:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfLWMjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 07:39:42 -0500
Received: from mx1.yrkesakademin.fi ([85.134.45.194]:23192 "EHLO
        mx1.yrkesakademin.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbfLWMjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 07:39:42 -0500
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Dec 2019 07:39:40 EST
Subject: Re: [PATCH] Revert "iwlwifi: mvm: fix scan config command size"
To:     Roman Gilg <subdiff@gmail.com>,
        Mehmet Akif Tasova <makiftasova@gmail.com>
CC:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Tova Mussai <tova.mussai@intel.com>,
        Ayala Beker <ayala.beker@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20191213203512.8250-1-makiftasova@gmail.com>
 <CAJcyoyusgtw0++KsEHK-t=EFGx2v9GKv7+BSViUCaB3nyDr2Jw@mail.gmail.com>
From:   Thomas Backlund <tmb@mageia.org>
Message-ID: <946da821-9e54-4508-e3ab-f2cdc19c8084@mageia.org>
Date:   Mon, 23 Dec 2019 14:24:33 +0200
MIME-Version: 1.0
In-Reply-To: <CAJcyoyusgtw0++KsEHK-t=EFGx2v9GKv7+BSViUCaB3nyDr2Jw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-WatchGuard-Spam-ID: str=0001.0A0C0215.5E00B58D.0066,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-WatchGuard-Spam-Score: 0, clean; 0, virus threat unknown
X-WatchGuard-Mail-Client-IP: 85.134.45.194
X-WatchGuard-Mail-From: tmb@mageia.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Den 18-12-2019 kl. 21:12, skrev Roman Gilg:
> On Fri, Dec 13, 2019 at 9:36 PM Mehmet Akif Tasova
> <makiftasova@gmail.com> wrote:
>>
>> Since Linux 5.4.1 released, iwlwifi could not initialize Intel(R) Dual Band
>> Wireless AC 9462 firmware, failing with following error in dmesg:
>>
>> iwlwifi 0000:00:14.3: FW error in SYNC CMD SCAN_CFG_CMD
>>
>> whole dmesg output of error can be found at:
>> https://gist.github.com/makiftasova/354e46439338f4ab3fba0b77ad5c19ec
>>
>> also bug report from ArchLinux bug tracker (contains more info):
>> https://bugs.archlinux.org/task/64703
> 
> Since this bug report is about the Dell XPS 13 2-in1: I tested your
> revert with this device, but the issue persists at least on this
> device. So these might be two different issues, one for your device
> and another one for the XPS.


Yeah, to get iwlwifi to work somewhat nicely you need this revert, and 
also theese on top of 5.4.6:

 From db5cce1afc8d2475d2c1c37c2a8267dd0e151526 Mon Sep 17 00:00:00 2001
From: Anders Kaseorg <andersk@mit.edu>
Date: Mon, 2 Dec 2019 17:09:20 -0500
Subject: Revert "iwlwifi: assign directly to iwl_trans->cfg in QuZ 
detection"

 From 0df36b90c47d93295b7e393da2d961b2f3b6cde4 Mon Sep 17 00:00:00 2001
From: Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 5 Dec 2019 09:03:54 +0200
Subject: iwlwifi: pcie: move power gating workaround earlier in the flow

and atleast v2 of the "iwlwifi: mvm: don't send the 
IWL_MVM_RXQ_NSSN_SYNC notif to Rx queues" patch that is being debated on 
this list.

With theese in place, we seem to have it behaving properly again for 
Mageia users reporting various problems / firmware crashes / ...

Hopefully Intel guys will get this sorted soon-ish and all sent to stable@

> 
>> Reverting commit 06eb547c4ae4 ("iwlwifi: mvm: fix scan config command
>> size") seems to fix this issue  until proper solution is found.
>>
>> This reverts commit 06eb547c4ae4382e70d556ba213d13c95ca1801b.
>>
>> Signed-off-by: Mehmet Akif Tasova <makiftasova@gmail.com>
>> ---
>>   drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
>> index a046ac9fa852..a5af8f4128b1 100644
>> --- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
>> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
>> @@ -1213,7 +1213,7 @@ static int iwl_mvm_legacy_config_scan(struct iwl_mvm *mvm)
>>                  cmd_size = sizeof(struct iwl_scan_config_v2);
>>          else
>>                  cmd_size = sizeof(struct iwl_scan_config_v1);
>> -       cmd_size += num_channels;
>> +       cmd_size += mvm->fw->ucode_capa.n_scan_channels;
>>
>>          cfg = kzalloc(cmd_size, GFP_KERNEL);
>>          if (!cfg)
>> --
>> 2.24.1
>>
> 

--
Thomas
