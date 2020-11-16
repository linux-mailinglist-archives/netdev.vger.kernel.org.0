Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 603F92B4340
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 13:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729153AbgKPMBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 07:01:54 -0500
Received: from mga03.intel.com ([134.134.136.65]:50464 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728829AbgKPMBy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 07:01:54 -0500
IronPort-SDR: UsI7Y7N/zWqrLH94Zy4vSGszRD6wK35x3jn5KF53XT8AWn080b3UZbbhCPXp9hWUPt585kPdFU
 ziWrow1SOVdA==
X-IronPort-AV: E=McAfee;i="6000,8403,9806"; a="170837584"
X-IronPort-AV: E=Sophos;i="5.77,482,1596524400"; 
   d="scan'208";a="170837584"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 04:01:52 -0800
IronPort-SDR: HF6lIwj5Ljczw1cQQ0gLhzVqEtLswe4P1qVPuAlfTMcb7Ax3VaRdVQKTPr7+0YprQv2g+u47Cj
 w14j+ADpJenQ==
X-IronPort-AV: E=Sophos;i="5.77,482,1596524400"; 
   d="scan'208";a="543578743"
Received: from syeghiay-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.37.125])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 04:01:44 -0800
Subject: Re: [PATCH bpf-next v2 06/10] xsk: propagate napi_id to XDP socket Rx
 path
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, jonathan.lemon@gmail.com, maximmi@nvidia.com,
        intel-wired-lan@lists.osuosl.org, netanel@amazon.com,
        akiyano@amazon.com, michael.chan@broadcom.com,
        sgoutham@marvell.com, ioana.ciornei@nxp.com,
        ruxandra.radulescu@nxp.com, thomas.petazzoni@bootlin.com,
        mcroce@microsoft.com, saeedm@nvidia.com, tariqt@nvidia.com,
        aelior@marvell.com, ecree@solarflare.com,
        ilias.apalodimas@linaro.org, grygorii.strashko@ti.com,
        sthemmin@microsoft.com, kda@linux-powerpc.org
References: <20201116110416.10719-1-bjorn.topel@gmail.com>
 <20201116110416.10719-7-bjorn.topel@gmail.com>
 <20201116064953-mutt-send-email-mst@kernel.org>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <614a7ce4-2b6b-129b-de7d-71428f7a71f6@intel.com>
Date:   Mon, 16 Nov 2020 13:01:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201116064953-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020-11-16 12:55, Michael S. Tsirkin wrote:
> On Mon, Nov 16, 2020 at 12:04:12PM +0100, BjÃ¶rn TÃ¶pel wrote:
>> From: BjÃ¶rn TÃ¶pel <bjorn.topel@intel.com>
>>
>> Add napi_id to the xdp_rxq_info structure, and make sure the XDP
>> socket pick up the napi_id in the Rx path. The napi_id is used to find
>> the corresponding NAPI structure for socket busy polling.
>>
>> Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
>> Signed-off-by: BjÃ¶rn TÃ¶pel <bjorn.topel@intel.com>
> 
> A bunch of drivers just pass in 0. could you explain when
> is that ok? how bad is it if the wrong id is used?
>

If zero is passed, which is a non-valid NAPI_ID, busy-polling will never
be performed.

Depending on the structure of the driver, napi might or might not be
initialized (napi_id != 0) or even available. When it wasn't obvious, I
simply set it to zero.

So, short; No harm if zero, but busy-polling cannot be used in an XDP
context.


[...]
>>   
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index 21b71148c532..d71fe41595b7 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -1485,7 +1485,7 @@ static int virtnet_open(struct net_device *dev)
>>   			if (!try_fill_recv(vi, &vi->rq[i], GFP_KERNEL))
>>   				schedule_delayed_work(&vi->refill, 0);
>>   
>> -		err = xdp_rxq_info_reg(&vi->rq[i].xdp_rxq, dev, i);
>> +		err = xdp_rxq_info_reg(&vi->rq[i].xdp_rxq, dev, i, 0);
>>   		if (err < 0)
>>   			return err;
>>   
> 
> Should this be rq.napi.napi_id ?
>

Yes, if rq.napi.napi_id is valid here! Is it?


Cheers,
Björn
