Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2394026676F
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 19:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbgIKRnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 13:43:10 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:56722 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725985AbgIKRm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 13:42:59 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 9DACC600D9;
        Fri, 11 Sep 2020 17:42:59 +0000 (UTC)
Received: from us4-mdac16-13.ut7.mdlocal (unknown [10.7.65.237])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 9C4142009A;
        Fri, 11 Sep 2020 17:42:59 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.35])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 160FF1C0053;
        Fri, 11 Sep 2020 17:42:56 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A4F614800A2;
        Fri, 11 Sep 2020 17:42:55 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 11 Sep
 2020 18:42:38 +0100
Subject: Re: [PATCH net-next 5/7] sfc: de-indirect TSO handling
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
References: <6fbc3a86-0afd-6e6d-099b-fca9af48d019@solarflare.com>
 <96677549-bc70-9785-aab5-b55dd15ecef6@solarflare.com>
 <20200911090146.61eb66f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <e6009413-aba0-b0de-ba66-71d64bd4b86b@solarflare.com>
Date:   Fri, 11 Sep 2020 18:42:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200911090146.61eb66f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25660.000
X-TM-AS-Result: No-10.944300-8.000000-10
X-TMASE-MatchedRID: csPTYAMX1+HmLzc6AOD8DfHkpkyUphL9S1zwNuiBtITfUZT83lbkEMiT
        Wug2C4DNl1M7KT9/aqDnIakAFP3RaCY3KbvVmCqgZacDbE73ZSmpXdWa4gU0S0dmDSBYfnJRg7l
        N9LOvFDuyxc1VprO+AtPzWwTEpBnXRZJ90/Q8SpniHyvyXeXh5g8hjyL1cWZwHDQcqEqNN+mMZ0
        pFOVP2QvCiDJF/LpLwSjLlYugtawq/WXZS/HqJ2lZ0V5tYhzdWxEHRux+uk8h+ICquNi0WJKyEs
        EbIIdHe7gQdG2JCJpH1p3Fzoo/Zd3Xi0J6i1Nd1ftwZ3X11IV0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--10.944300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25660.000
X-MDID: 1599846176-s-s9ESTrTn-6
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/09/2020 17:01, Jakub Kicinski wrote:
> On Thu, 10 Sep 2020 21:33:11 +0100 Edward Cree wrote:
>> index 078c7ec2a70e..272eb5ecb7e7 100644
>> --- a/drivers/net/ethernet/sfc/ef100_tx.c
>> +++ b/drivers/net/ethernet/sfc/ef100_tx.c
>> @@ -38,7 +38,8 @@ void ef100_tx_init(struct efx_tx_queue *tx_queue)
>>  				    tx_queue->channel->channel -
>>  				    tx_queue->efx->tx_channel_offset);
>>  
>> -	if (efx_mcdi_tx_init(tx_queue, false))
>> +	tx_queue->tso_version = 3;
>> +	if (efx_mcdi_tx_init(tx_queue))
>>  		netdev_WARN(tx_queue->efx->net_dev,
>>  			    "failed to initialise TXQ %d\n", tx_queue->queue);
>>  }
>> --- a/drivers/net/ethernet/sfc/tx.c
>> +++ b/drivers/net/ethernet/sfc/tx.c
>> @@ -338,8 +338,18 @@ netdev_tx_t __efx_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb
>>  	 * size limit.
>>  	 */
>>  	if (segments) {
>> -		EFX_WARN_ON_ONCE_PARANOID(!tx_queue->handle_tso);
>> -		rc = tx_queue->handle_tso(tx_queue, skb, &data_mapped);
>> +		switch (tx_queue->tso_version) {
>> +		case 1:
>> +			rc = efx_enqueue_skb_tso(tx_queue, skb, &data_mapped);
>> +			break;
>> +		case 2:
>> +			rc = efx_ef10_tx_tso_desc(tx_queue, skb, &data_mapped);
>> +			break;
>> +		case 0: /* No TSO on this queue, SW fallback needed */
>> +		default:
>> +			rc = -EINVAL;
>> +			break;
>> +		}
> Should tso_version 3 be handled in this switch?
No, because this switch is in the EF10/Siena datapath and is neverrun for
 EF100.  Setting tx_queue->tso_version = 3 for EF100 is really just there
 as documentation — EF100 has a completely different TX path, in
 ef100_enqueue_skb(), which never looks at tx_queue->tso_version because
 currently there's only one version of EF100 TSO descriptor.  From a
 functional perspective everything would still work if it were set to 0,
 but that would be kinda misleading.
Should I explain this in the commit message, or in a comment (and if the
 latter, where should it go?)

-ed
