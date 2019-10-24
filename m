Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1681BE35BF
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 16:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502869AbfJXOmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 10:42:45 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:37436 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2502826AbfJXOmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 10:42:45 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 5BDF89C0095;
        Thu, 24 Oct 2019 14:42:37 +0000 (UTC)
Received: from cim-opti7060.uk.solarflarecom.com (10.17.20.154) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 24 Oct 2019 15:42:31 +0100
Subject: Re: [PATCH net-next 2/6] sfc: perform XDP processing on received
 packets.
To:     Edward Cree <ecree@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-net-drivers@solarflare.com>,
        <brouer@redhat.com>
References: <05b72fdb-165c-1350-787b-ca8c5261c459@solarflare.com>
 <1c193147-d94a-111f-42d3-324c3e8b0282@solarflare.com>
 <b1fc9bd7-5f8d-8bf6-1d9d-956cef0311e4@solarflare.com>
From:   Charles McLachlan <cmclachlan@solarflare.com>
Message-ID: <06bf998a-b8d0-7fe0-2350-04951d4e8070@solarflare.com>
Date:   Thu, 24 Oct 2019 15:42:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <b1fc9bd7-5f8d-8bf6-1d9d-956cef0311e4@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.154]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24998.003
X-TM-AS-Result: No-1.787900-8.000000-10
X-TMASE-MatchedRID: L8tZF6zWW2rmLzc6AOD8DfHkpkyUphL9SoCG4sefl8RBbp4JobErAlk0
        uhbVrhisnC6WBQZ60sGJSKIrZl+fQDL7uOIf7WD3uwdUMMznEA/r3E41VlKsfU+86maMM3aSV+6
        b0ch8uTB5XdruzAGlguJbyKmua0b4pUizOemgJpjJokkUx2UM1wCm784gsJu4rosiTWRhP4muBM
        75m3FVEmhzQx7lArnyy/TADJ700NnPRS6+V5+kKuLzNWBegCW2RYvisGWbbS9mIVC+RmEW7Wrz/
        G/ZSbVq+gtHj7OwNO34ZhR52Rc1astMyskrCQ3euY8DBr+jRhxAGyLyuVcU+aQ9PQHK5239SfWS
        tR2zsQ5SXhHb5+RRAfeiNzLXbE4bEFhyJB9i6DY8Y0nmLsUDlofMZMegLDIeGU0pKnas+RbnCJf
        tFZkZizYJYNFU00e7N+XOQZygrvY=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.787900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24998.003
X-MDID: 1571928160-lJxnLuS6CSq8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/10/2019 17:26, Edward Cree wrote:
>> @@ -764,6 +872,16 @@ void efx_init_rx_queue(struct efx_rx_queue *rx_queue)
>>  	rx_queue->fast_fill_trigger = trigger;
>>  	rx_queue->refill_enabled = true;
>>  
>> +	/* Initialise XDP queue information */
>> +	rc = xdp_rxq_info_reg(&rx_queue->xdp_rxq_info, efx->net_dev,
>> +			      rx_queue->core_index);
>> +
>> +	if (rc) {
>> +		netif_err(efx, rx_err, efx->net_dev,
>> +			  "Failure to initialise XDP queue information rc=%d\n",
>> +			  rc);
>> +	}
> What happens if we try to use XDP after this has failed?
> Should we set some kind of "XDP broken" flag to prevent that?
> 
> -Ed
> 

Agreed. I've added a flag to track which rx queues fail, and then a per-nic flag
to indicate that at least one rx queue has failed, and hence that we shouldn't 
allow XDP programs to bind.
