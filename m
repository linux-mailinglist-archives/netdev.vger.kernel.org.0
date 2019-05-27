Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 756442AF8C
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 09:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbfE0Hso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 03:48:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:53221 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbfE0Hsn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 May 2019 03:48:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 May 2019 00:48:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,518,1549958400"; 
   d="scan'208";a="178782694"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.198]) ([10.237.72.198])
  by fmsmga002.fm.intel.com with ESMTP; 27 May 2019 00:48:39 -0700
Subject: Re: Issue with Broadcom wireless in 5.2rc1 (was Re: [PATCH] mmc:
 sdhci: queue work after sdhci_defer_done())
To:     Brian Masney <masneyb@onstation.org>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>, ulf.hansson@linaro.org,
        faiz_abbas@ti.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
References: <20190524111053.12228-1-masneyb@onstation.org>
 <70782901-a9ac-5647-1abe-89c86a44a01b@intel.com>
 <20190524154958.GB16322@basecamp> <20190526122136.GA26456@basecamp>
 <e8c049ce-07e1-8b34-678d-41b3d6d41983@broadcom.com>
 <20190526195819.GA29665@basecamp>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <e7818bf9-a1d1-24b8-360d-62d7493afa91@intel.com>
Date:   Mon, 27 May 2019 10:48:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190526195819.GA29665@basecamp>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/05/19 10:58 PM, Brian Masney wrote:
> On Sun, May 26, 2019 at 08:42:21PM +0200, Arend Van Spriel wrote:
>> On 5/26/2019 2:21 PM, Brian Masney wrote:
>>> + Broadcom wireless maintainers
>>>
>>> On Fri, May 24, 2019 at 11:49:58AM -0400, Brian Masney wrote:
>>>> On Fri, May 24, 2019 at 03:17:13PM +0300, Adrian Hunter wrote:
>>>>> On 24/05/19 2:10 PM, Brian Masney wrote:
>>>>>> WiFi stopped working on the LG Nexus 5 phone and the issue was bisected
>>>>>> to the commit c07a48c26519 ("mmc: sdhci: Remove finish_tasklet") that
>>>>>> moved from using a tasklet to a work queue. That patch also changed
>>>>>> sdhci_irq() to return IRQ_WAKE_THREAD instead of finishing the work when
>>>>>> sdhci_defer_done() is true. Change it to queue work to the complete work
>>>>>> queue if sdhci_defer_done() is true so that the functionality is
>>>>>> equilivent to what was there when the finish_tasklet was present. This
>>>>>> corrects the WiFi breakage on the Nexus 5 phone.
>>>>>>
>>>>>> Signed-off-by: Brian Masney <masneyb@onstation.org>
>>>>>> Fixes: c07a48c26519 ("mmc: sdhci: Remove finish_tasklet")
>>>>>> ---
>>>>>> [ ... ]
>>>>>>
>>>>>>   drivers/mmc/host/sdhci.c | 2 +-
>>>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
>>>>>> index 97158344b862..3563c3bc57c9 100644
>>>>>> --- a/drivers/mmc/host/sdhci.c
>>>>>> +++ b/drivers/mmc/host/sdhci.c
>>>>>> @@ -3115,7 +3115,7 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
>>>>>>   			continue;
>>>>>>   		if (sdhci_defer_done(host, mrq)) {
>>>>>> -			result = IRQ_WAKE_THREAD;
>>>>>> +			queue_work(host->complete_wq, &host->complete_work);
>>>>>
>>>>> The IRQ thread has a lot less latency than the work queue, which is why it
>>>>> is done that way.
>>>>>
>>>>> I am not sure why you say this change is equivalent to what was there
>>>>> before, nor why it fixes your problem.
>>>>>
>>>>> Can you explain some more?
>>>>
>>>> [ ... ]
>>>>
>>>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c calls
>>>> sdio_claim_host() and it appears to never return.

This is because SDHCI is using the IRQ thread to process the SDIO card
interrupt (sdio_run_irqs()).  When the card driver tries to use the card, it
causes interrupts which deadlocks since c07a48c26519 ("mmc: sdhci: Remove
finish_tasklet") has moved the tasklet processing to the IRQ thread.

I would expect to be able to use the IRQ thread to complete requests, and it
is desirable to do so because it is lower latency.

Probably, SDHCI should use sdio_signal_irq() which queues a work item, and
is what other drivers are doing.

I will investigate some more and send a patch.
