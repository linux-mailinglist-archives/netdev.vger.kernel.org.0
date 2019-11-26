Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2EE110A747
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 00:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfKZX5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 18:57:48 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44282 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbfKZX5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 18:57:48 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7F33914DDDEC8;
        Tue, 26 Nov 2019 15:57:46 -0800 (PST)
Date:   Tue, 26 Nov 2019 15:57:46 -0800 (PST)
Message-Id: <20191126.155746.627765091618337419.davem@davemloft.net>
To:     alobakin@dlink.ru
Cc:     pabeni@redhat.com, johannes@sipsolutions.net, ecree@solarflare.com,
        nicholas.johnson-opensource@outlook.com.au, jiri@mellanox.com,
        edumazet@google.com, idosch@mellanox.com, petrm@mellanox.com,
        sd@queasysnail.net, f.fainelli@gmail.com,
        jaswinder.singh@linaro.org, ilias.apalodimas@linaro.org,
        linux-kernel@vger.kernel.org, emmanuel.grumbach@intel.com,
        luciano.coelho@intel.com, linuxwifi@intel.com,
        kvalo@codeaurora.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: core: use listified Rx for GRO_NORMAL
 in napi_gro_receive()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <d535d5142e42b8c550f0220200e3779d@dlink.ru>
References: <414288fcac2ba4fcee48a63bdbf28f7b9a5037c6.camel@sipsolutions.net>
        <b4b92c4d066007d9cb77e1645e667715c17834fb.camel@redhat.com>
        <d535d5142e42b8c550f0220200e3779d@dlink.ru>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 Nov 2019 15:57:47 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alobakin@dlink.ru>
Date: Mon, 25 Nov 2019 15:02:24 +0300

> Paolo Abeni wrote 25.11.2019 14:42:
>> For -net, I *think* something as dumb and hacky as the following could
>> possibly work:
>> ----
>> diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
>> b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
>> index 4bba6b8a863c..df82fad96cbb 100644
>> --- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
>> +++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
>> @@ -1527,7 +1527,7 @@ static void iwl_pcie_rx_handle(struct iwl_trans
>> *trans, int queue)
>>                 iwl_pcie_rxq_alloc_rbs(trans, GFP_ATOMIC, rxq);
>>         if (rxq->napi.poll)
>> -               napi_gro_flush(&rxq->napi, false);
>> +               napi_complete_done(&rxq->napi, 0);
>>         iwl_pcie_rxq_restock(trans, rxq);
>>  }
>> ---
> 
> napi_complete_done(napi, 0) has an equivalent static inline
> napi_complete(napi). I'm not sure it will work without any issues
> as iwlwifi doesn't _really_ turn NAPI into scheduling state.
> 
> I'm not very familiar with iwlwifi, but as a work around manual
> napi_gro_flush() you can also manually flush napi->rx_list to
> prevent packets from stalling:
> 
> diff -Naur a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
> b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
> --- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c 2019-11-25
> --- 14:55:03.610355230 +0300
> +++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c 2019-11-25
> 14:57:29.399556868 +0300
 ...

Thanks to everyone for looking into this.

Can I get some kind of fix in the next 24 hours?  I want to send a quick
follow-on pull request to Linus to deal with all of the fallout, and in
particular fix this regression.

Thanks!
