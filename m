Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B95F9260A30
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 07:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbgIHFil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 01:38:41 -0400
Received: from mga12.intel.com ([192.55.52.136]:11446 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728712AbgIHFij (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 01:38:39 -0400
IronPort-SDR: OFIJU24GyUJ6tV9r1AIe1KSvypytrk92txw4y0BMy+2Req22gW3CKdZ05WrYbu6mAMBhKCAqia
 K/tus6eoi8hw==
X-IronPort-AV: E=McAfee;i="6000,8403,9737"; a="137592596"
X-IronPort-AV: E=Sophos;i="5.76,404,1592895600"; 
   d="scan'208";a="137592596"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2020 22:38:39 -0700
IronPort-SDR: /VDwcnpzM+ij/iCxij7/hOHyzBuMA1Pi+N1riBWyfTPyBI3gPsfs7AEjj3CQX0kU82u1JQ9yA1
 yr2ZR3TyxZag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,404,1592895600"; 
   d="scan'208";a="284393907"
Received: from pgierasi-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.39.2])
  by fmsmga007.fm.intel.com with ESMTP; 07 Sep 2020 22:38:37 -0700
Subject: Re: [PATCH bpf-next 4/4] ixgbe, xsk: use XSK_NAPI_WEIGHT as NAPI poll
 budget
To:     Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, magnus.karlsson@intel.com,
        intel-wired-lan@lists.osuosl.org
References: <20200907150217.30888-1-bjorn.topel@gmail.com>
 <20200907150217.30888-5-bjorn.topel@gmail.com>
 <20200907123241.447371e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <c8ce6b24-bded-5ed1-bf5c-6d2409972e57@intel.com>
Date:   Tue, 8 Sep 2020 07:38:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200907123241.447371e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-09-07 21:32, Jakub Kicinski wrote:
> On Mon,  7 Sep 2020 17:02:17 +0200 Björn Töpel wrote:
>> From: Björn Töpel <bjorn.topel@intel.com>
>>
>> Start using XSK_NAPI_WEIGHT as NAPI poll budget for the AF_XDP Rx
>> zero-copy path.
>>
>> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
>> ---
>>   drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
>> index 3771857cf887..f32c1ba0d237 100644
>> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
>> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
>> @@ -239,7 +239,7 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
>>   	bool failure = false;
>>   	struct sk_buff *skb;
>>   
>> -	while (likely(total_rx_packets < budget)) {
>> +	while (likely(total_rx_packets < XSK_NAPI_WEIGHT)) {
> 
> I was thinking that we'd multiply 'budget' here, not replace it with a
> constant. Looks like ixgbe dutifully passes 'per_ring_budget' into the
> clean_rx functions, not a complete NAPI budget.
>

Correct, and i40e/ice does the same ("per_ring_budget").

As for budget << XSK_NAPI_MULT vs replacing; Replacing the budget is 
more in line with what the drivers do for the Tx cleanup 
(xxx_clean_tx_irq), where the napi budget is discarded completely; 
Again, with the idea that "this is much cheaper than a "per-packet 
through the stack".

Do you prefer the multiplier way that you describe?


Cheers,
Björn


>>   		union ixgbe_adv_rx_desc *rx_desc;
>>   		struct ixgbe_rx_buffer *bi;
>>   		unsigned int size;
> 
