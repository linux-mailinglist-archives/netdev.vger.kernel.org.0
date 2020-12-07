Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F61D2D1947
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 20:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgLGTRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 14:17:41 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:52738 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbgLGTRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 14:17:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607368660; x=1638904660;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=Uzq171hkTc0ePbSHLkxyxyxS5W+LggInvZADUWiWT6s=;
  b=Sc2mWDEJO5vb/5I1vnC2wV7OTK6xmC5hfGqvGcrBp2QeMW486XDOfS9V
   VUmP5HaNrcO0EZ94/qRo7OFTDFF5MS5xt5//pgFxerBg0tBRIkZj39S74
   d/xIgwkfoH/OowdU2+fJKm6KKbm0CUTytDUQ1gcPWCj0ctsKRW1H3Nh0t
   g=;
X-IronPort-AV: E=Sophos;i="5.78,400,1599523200"; 
   d="scan'208";a="901215036"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 07 Dec 2020 19:16:52 +0000
Received: from EX13D28EUC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id A298B2413A5;
        Mon,  7 Dec 2020 19:16:51 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com.amazon.com (10.43.160.66) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 19:16:42 +0000
References: <1607083875-32134-1-git-send-email-akiyano@amazon.com>
 <1607083875-32134-7-git-send-email-akiyano@amazon.com>
 <20201206201031.GC23696@ranger.igk.intel.com>
User-agent: mu4e 1.4.12; emacs 27.1
From:   Shay Agroskin <shayagr@amazon.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC:     <akiyano@amazon.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <dwmw@amazon.com>, <zorik@amazon.com>,
        <matua@amazon.com>, <saeedb@amazon.com>, <msw@amazon.com>,
        <aliguori@amazon.com>, <nafea@amazon.com>, <gtzalik@amazon.com>,
        <netanel@amazon.com>, <alisaidi@amazon.com>, <benh@amazon.com>,
        <ndagan@amazon.com>, <sameehj@amazon.com>
Subject: Re: [PATCH V4 net-next 6/9] net: ena: use xdp_frame in XDP TX flow
In-Reply-To: <20201206201031.GC23696@ranger.igk.intel.com>
Date:   Mon, 7 Dec 2020 21:16:17 +0200
Message-ID: <pj41zl5z5dzata.fsf@u68c7b5b1d2d758.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.160.66]
X-ClientProxiedBy: EX13P01UWB004.ant.amazon.com (10.43.161.213) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:

> On Fri, Dec 04, 2020 at 02:11:12PM +0200, akiyano@amazon.com 
> wrote:
>> From: Arthur Kiyanovski <akiyano@amazon.com>
>> 
>> Rename the ena_xdp_xmit_buff() function to ena_xdp_xmit_frame() 
>> and pass
>> it an xdp_frame struct instead of xdp_buff.
>> This change lays the ground for XDP redirect implementation 
>> which uses
>> xdp_frames when 'xmit'ing packets.
>> 
>> Signed-off-by: Shay Agroskin <shayagr@amazon.com>
>> Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
>> ---
>>  drivers/net/ethernet/amazon/ena/ena_netdev.c | 46 
>>  ++++++++++----------
>>  1 file changed, 23 insertions(+), 23 deletions(-)
>> 
>> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c 
>> b/drivers/net/ethernet/amazon/ena/ena_netdev.c
>> index 222bb576e30e..cbb07548409a 100644
>> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
>> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
>> @@ -233,18 +233,18 @@ static int ena_xdp_io_poll(struct 
>> napi_struct *napi, int budget)
>>  	return ret;
>>  }
>>  
>>  ...
>>  	if (verdict == XDP_TX) {
>> -		ena_xdp_xmit_buff(rx_ring->netdev,
>> -				  xdp,
>> -				  rx_ring->qid + 
>> rx_ring->adapter->num_io_queues,
>> -				  rx_info);
>> +		xdpf = xdp_convert_buff_to_frame(xdp);
>
> Similar to Jakub's comment on another patch, 
> xdp_convert_buff_to_frame can
> return NULL and from what I can tell you never check that in
> ena_xdp_xmit_frame.
>

Hi, thanks for reviewing the code (:

Going over xdp_convert_buff_to_frame() it seems (to me) that the 
function fails either
- we're using an AF XDP socket
- the driver failed to leave enough room for xdp_frame and 
  skb_shared_info structs

the first isn't supported by ENA, and the second doesn't seem to 
be possible since the driver leaves enough space on the RX page 
and bpf_xdp_adjust_head()/bpf_xdp_adjust_tail() seem
to make sure enough space is left on the page for the structs.

Nevertheless, the correct approach is to check the return value of 
the function. I'll add it in the next patchset. Thanks

>> +		ena_xdp_xmit_frame(rx_ring->netdev, xdpf,
>> +				   rx_ring->qid + 
>> rx_ring->adapter->num_io_queues);
>>  
>>  		xdp_stat = &rx_ring->rx_stats.xdp_tx;
>>  	} else if (unlikely(verdict == XDP_ABORTED)) {
>> @@ -1521,7 +1521,7 @@ static int ena_xdp_handle_buff(struct 
>> ena_ring *rx_ring, struct xdp_buff *xdp)
>>  	if (unlikely(rx_ring->ena_bufs[0].len > ENA_XDP_MAX_MTU))
>>  		return XDP_DROP;
>>  
>> -	ret = ena_xdp_execute(rx_ring, xdp, rx_info);
>> +	ret = ena_xdp_execute(rx_ring, xdp);
>>  
>>  	/* The xdp program might expand the headers */
>> ...
>>  			 */
>>  			if (xdp_verdict == XDP_TX)
>> -- 
>> 2.23.3
>> 

