Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83BA610ACCE
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 10:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbfK0Jra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 04:47:30 -0500
Received: from mail.dlink.ru ([178.170.168.18]:45696 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbfK0Jra (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 04:47:30 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 774D41B21308; Wed, 27 Nov 2019 12:47:27 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 774D41B21308
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1574848047; bh=jsmsLyZC85bwwRh9nTRZB17m6X2+Kg7Y8UTp79ZBK2g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=Zbrl2dBP4M0S6FvqNY2EPIxsAPsEae+RA1ovQJo7lac7voVbmckMrCEeCE+sglKI1
         0kyzHaGf/djEW3YkNmc7LB+itXdMgXAvchZ65e8/QkWp95nQ3XWbWhzAZndLuDThrA
         cUDsKVAQer2jld+I72s+6oc0pePtLKoDExfvZUnk=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 24BFF1B2089D;
        Wed, 27 Nov 2019 12:47:17 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 24BFF1B2089D
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id A7E6F1B22678;
        Wed, 27 Nov 2019 12:47:16 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Wed, 27 Nov 2019 12:47:16 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 27 Nov 2019 12:47:16 +0300
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     David Miller <davem@davemloft.net>
Cc:     pabeni@redhat.com, johannes@sipsolutions.net, ecree@solarflare.com,
        nicholas.johnson-opensource@outlook.com.au, jiri@mellanox.com,
        edumazet@google.com, idosch@mellanox.com, petrm@mellanox.com,
        sd@queasysnail.net, f.fainelli@gmail.com,
        jaswinder.singh@linaro.org, ilias.apalodimas@linaro.org,
        linux-kernel@vger.kernel.org, emmanuel.grumbach@intel.com,
        luciano.coelho@intel.com, linuxwifi@intel.com,
        kvalo@codeaurora.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: core: use listified Rx for GRO_NORMAL in
 napi_gro_receive()
In-Reply-To: <20191126.155746.627765091618337419.davem@davemloft.net>
References: <414288fcac2ba4fcee48a63bdbf28f7b9a5037c6.camel@sipsolutions.net>
 <b4b92c4d066007d9cb77e1645e667715c17834fb.camel@redhat.com>
 <d535d5142e42b8c550f0220200e3779d@dlink.ru>
 <20191126.155746.627765091618337419.davem@davemloft.net>
User-Agent: Roundcube Webmail/1.4.0
Message-ID: <eb1b40cb25eb9808bb54f33913f5fdb4@dlink.ru>
X-Sender: alobakin@dlink.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller wrote 27.11.2019 02:57:
> From: Alexander Lobakin <alobakin@dlink.ru>
> Date: Mon, 25 Nov 2019 15:02:24 +0300
> 
>> Paolo Abeni wrote 25.11.2019 14:42:
>>> For -net, I *think* something as dumb and hacky as the following 
>>> could
>>> possibly work:
>>> ----
>>> diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
>>> b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
>>> index 4bba6b8a863c..df82fad96cbb 100644
>>> --- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
>>> +++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
>>> @@ -1527,7 +1527,7 @@ static void iwl_pcie_rx_handle(struct iwl_trans
>>> *trans, int queue)
>>>                 iwl_pcie_rxq_alloc_rbs(trans, GFP_ATOMIC, rxq);
>>>         if (rxq->napi.poll)
>>> -               napi_gro_flush(&rxq->napi, false);
>>> +               napi_complete_done(&rxq->napi, 0);
>>>         iwl_pcie_rxq_restock(trans, rxq);
>>>  }
>>> ---
>> 
>> napi_complete_done(napi, 0) has an equivalent static inline
>> napi_complete(napi). I'm not sure it will work without any issues
>> as iwlwifi doesn't _really_ turn NAPI into scheduling state.
>> 
>> I'm not very familiar with iwlwifi, but as a work around manual
>> napi_gro_flush() you can also manually flush napi->rx_list to
>> prevent packets from stalling:
>> 
>> diff -Naur a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
>> b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
>> --- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c 2019-11-25
>> --- 14:55:03.610355230 +0300
>> +++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c 2019-11-25
>> 14:57:29.399556868 +0300
>  ...
> 
> Thanks to everyone for looking into this.
> 
> Can I get some kind of fix in the next 24 hours?  I want to send a 
> quick
> follow-on pull request to Linus to deal with all of the fallout, and in
> particular fix this regression.

The fix is here: [1]
It's pretty straightforward, but needs a minimal testing anyways.
If any changes are needed, please let me know.

> Thanks!

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ

[1] 
https://lore.kernel.org/netdev/20191127094123.18161-1-alobakin@dlink.ru
