Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC59266706
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 19:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726493AbgIKRgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 13:36:45 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:41398 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726460AbgIKRga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 13:36:30 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.144])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 77817200F0;
        Fri, 11 Sep 2020 17:36:28 +0000 (UTC)
Received: from us4-mdac16-14.at1.mdlocal (unknown [10.110.49.196])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 6AEB4800AD;
        Fri, 11 Sep 2020 17:36:28 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.109])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 7790040075;
        Fri, 11 Sep 2020 17:36:19 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 36187B40076;
        Fri, 11 Sep 2020 17:36:19 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 11 Sep
 2020 18:36:07 +0100
Subject: Re: [PATCH net-next 1/7] sfc: decouple TXQ type from label
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
References: <6fbc3a86-0afd-6e6d-099b-fca9af48d019@solarflare.com>
 <6fc83ee8-6b6c-c2ea-ca81-659b6ef25569@solarflare.com>
 <20200911085358.5fdd3f23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <81283b4d-8176-3db2-dc95-87a37c06b7c0@solarflare.com>
Date:   Fri, 11 Sep 2020 18:36:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200911085358.5fdd3f23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25660.000
X-TM-AS-Result: No-6.692400-8.000000-10
X-TMASE-MatchedRID: 9zTThWtzImvmLzc6AOD8DfHkpkyUphL9eouvej40T4gd0WOKRkwsh3lo
        OvA4aBJJrdoLblq9S5oO8oAkUYa35LCgZ24avLuJUlu/qwZkdio9KBt6tnyFckTqq9Xa45y5qU7
        Z6SqUMjo8n3Pe7xkxtSlfiqmET+QOHOFKIqcfIugolijkrg/WpLqGBW9J0Yqjfpb+IhzBvBm+yL
        aMyxoBpbF9uGobEuT7X7bicKxRIU2No+PRbWqfRLI7zVffJqTzEx95sWxd73bvDW3mRGLGT+yjP
        ey1LCcut90qdH9R3wQc1oX5QUTzGX7cGd19dSFd
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.692400-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25660.000
X-MDID: 1599845779-hqsAciuWl-xw
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/09/2020 16:53, Jakub Kicinski wrote:
> On Thu, 10 Sep 2020 21:31:29 +0100 Edward Cree wrote:
>> diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
>> index 48d91b26f1a2..b0a08d9f4773 100644
>> --- a/drivers/net/ethernet/sfc/tx.c
>> +++ b/drivers/net/ethernet/sfc/tx.c
>> @@ -527,6 +527,12 @@ netdev_tx_t efx_hard_start_xmit(struct sk_buff *skb,
>>  	}
>>  
>>  	tx_queue = efx_get_tx_queue(efx, index, type);
>> +	if (WARN_ON(!tx_queue))
> _ONCE
Good catch.
>> +		/* We don't have a TXQ of the right type.
>> +		 * This should never happen, as we don't advertise offload
>> +		 * features unless we can support them.
>> +		 */
>> +		return NETDEV_TX_BUSY;
> You should probably drop this packet, right? Next time qdisc calls the
> driver it's unlikely to find a queue it needs.
Hmm, the comment at the top of efx_hard_start_xmit() claims that
 "returning anything other than NETDEV_TX_OK will cause the OS to free
 the skb".  Is that not in fact true?
Should I instead do what the error path of __efx_enqueue_skb() does -
 free the skb, kick pending TX, and return NETDEV_TX_OK?  I have to
 admit I've never 100% understood the netdev_tx_t semantics.
