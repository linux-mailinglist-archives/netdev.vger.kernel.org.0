Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44713E08BE
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 18:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731802AbfJVQ0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 12:26:21 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:56036 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731518AbfJVQ0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 12:26:21 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 9CC6F140061;
        Tue, 22 Oct 2019 16:26:19 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 22 Oct
 2019 09:26:05 -0700
Subject: Re: [PATCH net-next 2/6] sfc: perform XDP processing on received
 packets.
To:     Charles McLachlan <cmclachlan@solarflare.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-net-drivers@solarflare.com>,
        <brouer@redhat.com>
References: <05b72fdb-165c-1350-787b-ca8c5261c459@solarflare.com>
 <1c193147-d94a-111f-42d3-324c3e8b0282@solarflare.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <b1fc9bd7-5f8d-8bf6-1d9d-956cef0311e4@solarflare.com>
Date:   Tue, 22 Oct 2019 17:26:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1c193147-d94a-111f-42d3-324c3e8b0282@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24994.005
X-TM-AS-Result: No-2.509700-4.000000-10
X-TMASE-MatchedRID: VPleTT1nwdTmLzc6AOD8DfHkpkyUphL9a2pCAnJvQFGZHfpKN1YMZXv6
        cG7t9uXqyRoqwKpOKcJ6MMS//CmLem8BU9XGR8QhsFSKfGPIprVc1jwHBugxQOjnKWtZ9LTLS71
        7hL/58vY0lP87HDyGK0zuDWPQC4cRPB7z3tT8+MJcVlrN0VHFaw73P4/aDCIFHVYuuUDsN/yjxY
        yRBa/qJQPTK4qtAgwIIC0OoeD/hCbQLWxBF9DMQcRB0bsfrpPInxMyeYT53Rn7W0ZY0KV4OEgmg
        XGkMc2ugNePUnH2yaj5JSIT5+8NvSyV+bXlxZEwTi8FpJTd0jWXDzwpmj/EZT+xw/v/58/kI0Nk
        rl5EM8fUNewp4E2/TgSpmVYGQlZ3sxk1kV1Ja8cbbCVMcs1jUlZca9RSYo/b
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.509700-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24994.005
X-MDID: 1571761580-C4r9DRFd0pmy
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/10/2019 16:38, Charles McLachlan wrote:
> Adds a field to hold an attached xdp_prog, but never populates it (see
> following patch).  Also, XDP_TX support is deferred to a later patch
> in the series.
>
> Signed-off-by: Charles McLachlan <cmclachlan@solarflare.com>
> ---
<snip>
> @@ -764,6 +872,16 @@ void efx_init_rx_queue(struct efx_rx_queue *rx_queue)
>  	rx_queue->fast_fill_trigger = trigger;
>  	rx_queue->refill_enabled = true;
>  
> +	/* Initialise XDP queue information */
> +	rc = xdp_rxq_info_reg(&rx_queue->xdp_rxq_info, efx->net_dev,
> +			      rx_queue->core_index);
> +
> +	if (rc) {
> +		netif_err(efx, rx_err, efx->net_dev,
> +			  "Failure to initialise XDP queue information rc=%d\n",
> +			  rc);
> +	}
What happens if we try to use XDP after this has failed?
Should we set some kind of "XDP broken" flag to prevent that?

-Ed
