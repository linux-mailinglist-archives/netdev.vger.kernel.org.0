Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA6125C769
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 18:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbgICQs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 12:48:59 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:51390 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726025AbgICQsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 12:48:55 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.143])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B986620062;
        Thu,  3 Sep 2020 16:48:54 +0000 (UTC)
Received: from us4-mdac16-41.at1.mdlocal (unknown [10.110.48.12])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B7BC0800A4;
        Thu,  3 Sep 2020 16:48:54 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.103])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4A16940058;
        Thu,  3 Sep 2020 16:48:54 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 13DA6980073;
        Thu,  3 Sep 2020 16:48:53 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Sep 2020
 17:48:49 +0100
Subject: Re: [PATCH net-next 1/5] sfc: add and use efx_tx_send_pending in tx.c
To:     David Miller <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <netdev@vger.kernel.org>
References: <d3c81ab7-6d2e-326f-e25e-e42095ce9e66@solarflare.com>
 <1edd44e5-a73a-149f-fe0c-96969627d211@solarflare.com>
 <20200902.155513.2158302550582662254.davem@davemloft.net>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <b9567189-c9f6-67b7-028a-3ba576fe2f18@solarflare.com>
Date:   Thu, 3 Sep 2020 17:48:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200902.155513.2158302550582662254.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25642.007
X-TM-AS-Result: No-8.562800-8.000000-10
X-TMASE-MatchedRID: L8tZF6zWW2ozkUg+npt39/ZvT2zYoYOwC/ExpXrHizz0Li0ScYqKCVNp
        x0NRruuf3jlEkfTvBl1fL846nDpxby4YlXCNHMx/naJwCyoIjbypvf+jmz45w+ZMicrOlIVJiCc
        t0dTuiI5Gty7akqMDFtlYmtBNW3IbOpPA8Ci9bQSEv01fZOqaQDg6RKCx6bV17L2+zGEubN4jCD
        dV372aMN+JJIA0cQZR2/Vc0kgrzVpiLjTDQZLAr02rn9j60W9b3vjS0O+N37WphB7VVHq6DKPFj
        JEFr+olA9Mriq0CDAg9wJeM2pSaRXnN0DN7HnFmJEUehQrz9AsLIFA8+/2k1vriXzsom/sE4dBO
        D/FsHgPJ4+FH8gjZipRMZUCEHkRt
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.562800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25642.007
X-MDID: 1599151734-u4JWwW1pZw4k
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/09/2020 23:55, David Miller wrote:
> From: Edward Cree <ecree@solarflare.com>
> Date: Wed, 2 Sep 2020 15:35:53 +0100
> 
>> +	tx_queue->xmit_more_available = true;
> 
> I don't understand why you're setting xmit_more_available
> unconditionally to true now instead of setting it to 'xmit_more' as
> seen by this transmit attempt.  Why would you want to signal
> that xmit_more handling might be necessary when you haven't been
> given an xmit_more tx request?

After this patch xmit_more_available is something of a misnomer and
 really means "xmit pending" (I'll rename it in v2).  We unconditionally
 set it to true here so that efx_tx_send_pending() knows there is
 something to do on this queue; but then we only call efx_tx_send_pending
 if !xmit_more (per the __netdev_tx_sent_queue() call).  Then
 efx_tx_send_pending, via the efx->type->tx_write methods, sets
 xmit_more_available to false.
Thus xmit_more_available is only true on return from __efx_enqueue_skb()
 if we had xmit_more (and __netdev_tx_sent_queue didn't say "ring it
 anyway").

> If this change is in fact correct, it's something you need to explain
> in the commit message.
Will do so for v2, as it is indeed far from obvious.

-ed
