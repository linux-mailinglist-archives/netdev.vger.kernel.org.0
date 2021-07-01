Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08873B8D6B
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 07:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbhGAFcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 01:32:48 -0400
Received: from mga04.intel.com ([192.55.52.120]:11105 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231704AbhGAFcs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 01:32:48 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10031"; a="206651781"
X-IronPort-AV: E=Sophos;i="5.83,313,1616482800"; 
   d="scan'208";a="206651781"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2021 22:30:18 -0700
X-IronPort-AV: E=Sophos;i="5.83,313,1616482800"; 
   d="scan'208";a="644328962"
Received: from mckumar-mobl.gar.corp.intel.com (HELO [10.213.117.43]) ([10.213.117.43])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2021 22:30:16 -0700
Subject: Re: [PATCH 4/5] net: wwan: iosm: fix netdev tx stats
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        krishna.c.sudi@intel.com, linuxwwan@intel.com
References: <20210630182748.3481-1-m.chetan.kumar@linux.intel.com>
 <dbef867f-6333-d1f7-0f33-98582af7bdf8@gmail.com>
From:   "Kumar, M Chetan" <m.chetan.kumar@intel.com>
Message-ID: <98a85462-85ca-d289-854d-aa7b11614fae@intel.com>
Date:   Thu, 1 Jul 2021 11:00:13 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <dbef867f-6333-d1f7-0f33-98582af7bdf8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/1/2021 2:06 AM, Eric Dumazet wrote:
> 
> 
> On 6/30/21 8:27 PM, M Chetan Kumar wrote:
>> Update tx stats on successful packet consume, drop.
>>
>> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
>> ---
>>  drivers/net/wwan/iosm/iosm_ipc_wwan.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
>> index 84e37c4b0f74..561944a33725 100644
>> --- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
>> +++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
>> @@ -123,6 +123,8 @@ static int ipc_wwan_link_transmit(struct sk_buff *skb,
>>  
>>  	/* Return code of zero is success */
>>  	if (ret == 0) {
>> +		netdev->stats.tx_packets++;
>> +		netdev->stats.tx_bytes += skb->len;
> 
> What makes you think skb has not been consumed already ?
> It seems clear it has been given, this thread can not expect skb has not been mangled/freed.
> skb->len might now contain garbage, or even crash the kernel under appropriate debug features.

Ya. there could be a possibility skb might have been dequeued from ul_list and
UL task is already processing it. We can't rule out.

Will backup skb->len to local var and use it for tx_bytes update.

Regards,
Chetan
