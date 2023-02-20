Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9F069D46A
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 21:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232233AbjBTUHn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 20 Feb 2023 15:07:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbjBTUHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 15:07:42 -0500
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B73BD1E9C8;
        Mon, 20 Feb 2023 12:07:39 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id D919F6382EFD;
        Mon, 20 Feb 2023 21:07:36 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 2EaI2PLablRK; Mon, 20 Feb 2023 21:07:36 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 815956382EFF;
        Mon, 20 Feb 2023 21:07:36 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 5IW8V5AeIPvI; Mon, 20 Feb 2023 21:07:36 +0100 (CET)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id 61C896382EFD;
        Mon, 20 Feb 2023 21:07:36 +0100 (CET)
Date:   Mon, 20 Feb 2023 21:07:36 +0100 (CET)
From:   Richard Weinberger <richard@nod.at>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, pabeni@redhat.com,
        kuba@kernel.org, edumazet@google.com, davem <davem@davemloft.net>,
        linux-imx <linux-imx@nxp.com>,
        xiaoning wang <xiaoning.wang@nxp.com>,
        shenwei wang <shenwei.wang@nxp.com>,
        wei fang <wei.fang@nxp.com>
Message-ID: <1575439606.155156.1676923656294.JavaMail.zimbra@nod.at>
In-Reply-To: <Y/LIS3xd1iZRyVGe@lunn.ch>
References: <20230218214037.16977-1-richard@nod.at> <Y/LIS3xd1iZRyVGe@lunn.ch>
Subject: Re: [PATCH] [RFC] net: fec: Allow turning off IRQ coalescing
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF97 (Linux)/8.8.12_GA_3809)
Thread-Topic: Allow turning off IRQ coalescing
Thread-Index: 24/x27NspbuH3aH+Y++BvGo/nXKLNA==
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,PDS_BAD_THREAD_QP_64,
        SPF_HELO_NONE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew,

----- Ursprüngliche Mail -----
>> -	/* Must be greater than zero to avoid unpredictable behavior */
>> -	if (!fep->rx_time_itr || !fep->rx_pkts_itr ||
>> -	    !fep->tx_time_itr || !fep->tx_pkts_itr)
>> -		return;
>> +	if (!fep->rx_time_itr || !fep->rx_pkts_itr) {
>> +		if (fep->rx_time_itr || fep->rx_pkts_itr) {
>> +			dev_warn(dev, "Rx coalesced frames and usec have to be "
>> +				      "both positive or both zero to disable Rx "
>> +				      "coalescence completely\n");
>> +			return -EINVAL;
>> +		}
> 
> Hi Richard
> 
> Why do this validation here, and not in fec_enet_set_coalesce() where
> there are already checks? fec_enet_set_coalesce() also has extack, so
> you can return useful messages to user space, not just the kernel log.

Using extack is a good point, the driver does not use it at all so far.
So I'd do a second patch which cleans this up.

I did the check in fec_enet_itr_coal_set() because the check is used to
set both disable_rx_itr and disable_tx_itr.
Of course I can place the check into fec_enet_set_coalesce() and then
pass disable_rx_itr and disable_tx_itr to fec_enet_itr_coal_set().

Thanks,
//richard
