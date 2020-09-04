Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886C725DE9B
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 17:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgIDPyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 11:54:47 -0400
Received: from mga06.intel.com ([134.134.136.31]:27577 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726047AbgIDPyr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 11:54:47 -0400
IronPort-SDR: 4Qcq/TZcZuHLZmj0lbvBu/SNWnQES5OzlIx6aZKM3f2oV4ZlguniIdJmNQyOczcLgFS6OLuf4B
 YJm/DuHg+wCw==
X-IronPort-AV: E=McAfee;i="6000,8403,9734"; a="219322041"
X-IronPort-AV: E=Sophos;i="5.76,390,1592895600"; 
   d="scan'208";a="219322041"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 08:54:46 -0700
IronPort-SDR: y75BemvQevIk+U3GMZ8DouALxCXc9okBtC2DyBIEp6SCCZRwrNARqnDlaS0cZGD+j+rhfAmAdX
 dyYGTgYPAXHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,390,1592895600"; 
   d="scan'208";a="332204909"
Received: from andreyfe-mobl2.ccr.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.37.82])
  by orsmga008.jf.intel.com with ESMTP; 04 Sep 2020 08:54:43 -0700
Subject: Re: [PATCH bpf-next 6/6] ixgbe, xsk: finish napi loop if AF_XDP Rx
 queue is full
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, magnus.karlsson@intel.com,
        davem@davemloft.net, kuba@kernel.org, john.fastabend@gmail.com,
        intel-wired-lan@lists.osuosl.org
References: <20200904135332.60259-1-bjorn.topel@gmail.com>
 <20200904135332.60259-7-bjorn.topel@gmail.com>
 <20200904173540.3a617eee@carbon>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <59da4aa6-dbc5-b366-e84e-0030f6010e55@intel.com>
Date:   Fri, 4 Sep 2020 17:54:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200904173540.3a617eee@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-09-04 17:35, Jesper Dangaard Brouer wrote:
> On Fri,  4 Sep 2020 15:53:31 +0200
> Björn Töpel <bjorn.topel@gmail.com> wrote:
> 
>> From: Björn Töpel <bjorn.topel@intel.com>
>>
>> Make the AF_XDP zero-copy path aware that the reason for redirect
>> failure was due to full Rx queue. If so, exit the napi loop as soon as
>> possible (exit the softirq processing), so that the userspace AF_XDP
>> process can hopefully empty the Rx queue. This mainly helps the "one
>> core scenario", where the userland process and Rx softirq processing
>> is on the same core.
>>
>> Note that the early exit can only be performed if the "need wakeup"
>> feature is enabled, because otherwise there is no notification
>> mechanism available from the kernel side.
>>
>> This requires that the driver starts using the newly introduced
>> xdp_do_redirect_ext() and xsk_do_redirect_rx_full() functions.
>>
>> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
>> ---
>>   drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 23 ++++++++++++++------
>>   1 file changed, 16 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
>> index 3771857cf887..a4aebfd986b3 100644
>> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
>> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
>> @@ -93,9 +93,11 @@ int ixgbe_xsk_pool_setup(struct ixgbe_adapter *adapter,
>>   
>>   static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
>>   			    struct ixgbe_ring *rx_ring,
>> -			    struct xdp_buff *xdp)
>> +			    struct xdp_buff *xdp,
>> +			    bool *early_exit)
>>   {
>>   	int err, result = IXGBE_XDP_PASS;
>> +	enum bpf_map_type map_type;
>>   	struct bpf_prog *xdp_prog;
>>   	struct xdp_frame *xdpf;
>>   	u32 act;
>> @@ -116,8 +118,13 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
>>   		result = ixgbe_xmit_xdp_ring(adapter, xdpf);
>>   		break;
>>   	case XDP_REDIRECT:
>> -		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
>> -		result = !err ? IXGBE_XDP_REDIR : IXGBE_XDP_CONSUMED;
>> +		err = xdp_do_redirect_ext(rx_ring->netdev, xdp, xdp_prog, &map_type);
>> +		if (err) {
>> +			*early_exit = xsk_do_redirect_rx_full(err, map_type);
> 
> Have you tried calling xdp_do_flush (that calls __xsk_map_flush()) and
> (I guess) xsk_set_rx_need_wakeup() here, instead of stopping the loop?
> (Or doing this in xsk core).
>

Moving the need_wake logic to the xsk core/flush would be a very nice
cleanup. The driver would still need to pass information from the driver
though. Still, much cleaner. I'll take a stab at that. Thanks!


> Looking at the code, the AF_XDP frames are "published" in the queue
> rather late for AF_XDP.  Maybe in an orthogonal optimization, have you
> considered "publishing" the ring producer when e.g. the queue is
> half-full?
>

Hmm, I haven't. You mean instead of yielding, you publish/submit? I
*think* I still prefer stopping the processing.

I'll play with this a bit!

Very nice suggestions, Jesper! Thanks!


Björn
