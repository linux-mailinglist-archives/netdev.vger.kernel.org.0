Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5654E108F0D
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 14:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbfKYNkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 08:40:09 -0500
Received: from mail.dlink.ru ([178.170.168.18]:40630 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbfKYNkJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Nov 2019 08:40:09 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id A43BC1B20153; Mon, 25 Nov 2019 16:40:06 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru A43BC1B20153
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1574689206; bh=mUx+/0bX0CiB4xSiEyVtzLFAJqKDHPBseAUT4sDjloA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=D2hCanD0o5oUPnfhsQ3ZHwy0xXwoz5aiGYNnjjXtNWlahFdhyRsW9wl7cjlV1T0pK
         5Fzg9etkRMRJ/zWlGSMFIgUgUCXEpJLBpX46OIqqmilwhIbaU1hZpoWb4oFcuW1dtc
         GdUX53MVAuqlVoLIIiWZnpKLGZDgBaI1gICUk7fo=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,USER_IN_WHITELIST
        autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id D57261B207E1;
        Mon, 25 Nov 2019 16:39:55 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru D57261B207E1
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 8D89F1B22662;
        Mon, 25 Nov 2019 16:39:55 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Mon, 25 Nov 2019 16:39:55 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 25 Nov 2019 16:39:55 +0300
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>,
        David Miller <davem@davemloft.net>, jiri@mellanox.com,
        edumazet@google.com, idosch@mellanox.com, petrm@mellanox.com,
        sd@queasysnail.net, f.fainelli@gmail.com,
        jaswinder.singh@linaro.org, ilias.apalodimas@linaro.org,
        linux-kernel@vger.kernel.org, emmanuel.grumbach@intel.com,
        luciano.coelho@intel.com, linuxwifi@intel.com,
        kvalo@codeaurora.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: core: use listified Rx for GRO_NORMAL in
 napi_gro_receive()
In-Reply-To: <e437dc2d-aff3-2893-8d80-6abae4fcb84a@solarflare.com>
References: <20191014080033.12407-1-alobakin@dlink.ru>
 <20191015.181649.949805234862708186.davem@davemloft.net>
 <7e68da00d7c129a8ce290229743beb3d@dlink.ru>
 <PSXP216MB04388962C411CD0B17A86F47804A0@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
 <c762f5eee08a8f2d0d6cb927d7fa3848@dlink.ru>
 <746f768684f266e5a5db1faf8314cd77@dlink.ru>
 <PSXP216MB0438267E8191486435445DA6804A0@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
 <cc08834c-ccb3-263a-2967-f72a9d72535a@solarflare.com>
 <3147bff57d58fce651fe2d3ca53983be@dlink.ru>
 <414288fcac2ba4fcee48a63bdbf28f7b9a5037c6.camel@sipsolutions.net>
 <b4b92c4d066007d9cb77e1645e667715c17834fb.camel@redhat.com>
 <d535d5142e42b8c550f0220200e3779d@dlink.ru>
 <e437dc2d-aff3-2893-8d80-6abae4fcb84a@solarflare.com>
User-Agent: Roundcube Webmail/1.4.0
Message-ID: <6ff190a3b00aae0a9b9388f60791528a@dlink.ru>
X-Sender: alobakin@dlink.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Edward Cree wrote 25.11.2019 16:21:
> On 25/11/2019 12:02, Alexander Lobakin wrote:
>> I'm not very familiar with iwlwifi, but as a work around manual
>> napi_gro_flush() you can also manually flush napi->rx_list to
>> prevent packets from stalling:
>> 
>> diff -Naur a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c 
>> b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
>> --- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c    2019-11-25 
>> 14:55:03.610355230 +0300
>> +++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c    2019-11-25 
>> 14:57:29.399556868 +0300
>> @@ -1526,8 +1526,16 @@
>>      if (unlikely(emergency && count))
>>          iwl_pcie_rxq_alloc_rbs(trans, GFP_ATOMIC, rxq);
>> 
>> -    if (rxq->napi.poll)
>> +    if (rxq->napi.poll) {
>> +        if (rxq->napi.rx_count) {
>> +            netif_receive_skb_list(&rxq->napi.rx_list);
>> +
>> +            INIT_LIST_HEAD(&rxq->napi.rx_list);
>> +            rxq->napi.rx_count = 0;
>> +        }
>> +
>>          napi_gro_flush(&rxq->napi, false);
>> +    }
>> 
>>      iwl_pcie_rxq_restock(trans, rxq);
>>  }
> ... or we could export gro_normal_list(), instead of open-coding it
>  in the driver?

I thought about this too, but don't like it. This patch is proposed as
a *very* temporary solution until iwlwifi will get more straightforward
logic. I wish we could make napi_gro_flush() static in the future and
keep gro_normal_list() private to:

- prevent them from using in any new drivers;
- give more opportunity to CC to optimize the core code.

> 
> -Ed

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
