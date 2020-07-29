Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB341231CD7
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 12:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgG2Knu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 06:43:50 -0400
Received: from mga05.intel.com ([192.55.52.43]:10326 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbgG2Knu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 06:43:50 -0400
IronPort-SDR: hvndTjYz30wp/nAZJbs5qGZsiHlR4HNutc+WAAifgf3ynpHaiKaNfV9bGmcc2qdNZvvBLDBWtI
 +SiZmxPD4U6w==
X-IronPort-AV: E=McAfee;i="6000,8403,9696"; a="236257340"
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="236257340"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2020 03:43:49 -0700
IronPort-SDR: dM+SJFtb/eQqyzRb9ufHGVNJw+W4iGfiSQNjyUMupB4rNuNQoIstf8VQCf8nyZFFP+rltJFNmS
 pI2tO/CXULJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="312977789"
Received: from abrandl1-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.40.236])
  by fmsmga004.fm.intel.com with ESMTP; 29 Jul 2020 03:43:47 -0700
Subject: Re: [net-next 5/6] i40e, xsk: increase budget for AF_XDP path
To:     Jakub Kicinski <kuba@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, jeffrey.t.kirsher@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
References: <20200728190842.1284145-1-anthony.l.nguyen@intel.com>
 <20200728190842.1284145-6-anthony.l.nguyen@intel.com>
 <20200728131512.17c41621@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <0439597f-9c1f-a289-edd9-c890baa687da@intel.com>
Date:   Wed, 29 Jul 2020 12:43:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200728131512.17c41621@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-07-28 22:15, Jakub Kicinski wrote:
> On Tue, 28 Jul 2020 12:08:41 -0700 Tony Nguyen wrote:
>> diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
>> index 1f2dd591dbf1..99f4afdc403d 100644
>> --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
>> +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
>> @@ -265,6 +265,8 @@ static void i40e_inc_ntc(struct i40e_ring *rx_ring)
>>   	rx_ring->next_to_clean = ntc;
>>   }
>>   
>> +#define I40E_XSK_CLEAN_RX_BUDGET 256U
>> +
>>   /**
>>    * i40e_clean_rx_irq_zc - Consumes Rx packets from the hardware ring
>>    * @rx_ring: Rx ring
>> @@ -280,7 +282,7 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
>>   	bool failure = false;
>>   	struct sk_buff *skb;
>>   
>> -	while (likely(total_rx_packets < (unsigned int)budget)) {
>> +	while (likely(total_rx_packets < I40E_XSK_CLEAN_RX_BUDGET)) {
>>   		union i40e_rx_desc *rx_desc;
>>   		struct xdp_buff **bi;
>>   		unsigned int size;
> 
> Should this perhaps be a common things that drivers do?
> 
> Should we define a "XSK_NAPI_WEIGHT_MULT 4" instead of hard coding the
> value in a driver?
>

Yes, that's a good idea. I can generalize for the AF_XDP paths in the 
other drivers as a follow up!


Cheers,
Björn (in vacation mode)
