Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D62F469D48C
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 21:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232549AbjBTUPT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 20 Feb 2023 15:15:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232447AbjBTUPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 15:15:18 -0500
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB80D1EBE8;
        Mon, 20 Feb 2023 12:15:17 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 8192E6382EE5;
        Mon, 20 Feb 2023 21:15:16 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id nCMa2EWiTZK8; Mon, 20 Feb 2023 21:15:15 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 991D16382EFF;
        Mon, 20 Feb 2023 21:15:15 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id YFeslGAXLKQb; Mon, 20 Feb 2023 21:15:15 +0100 (CET)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id 768396382EE5;
        Mon, 20 Feb 2023 21:15:15 +0100 (CET)
Date:   Mon, 20 Feb 2023 21:15:15 +0100 (CET)
From:   Richard Weinberger <richard@nod.at>
To:     wei fang <wei.fang@nxp.com>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        pabeni <pabeni@redhat.com>, kuba <kuba@kernel.org>,
        edumazet <edumazet@google.com>, davem <davem@davemloft.net>,
        linux-imx <linux-imx@nxp.com>,
        xiaoning wang <xiaoning.wang@nxp.com>,
        shenwei wang <shenwei.wang@nxp.com>
Message-ID: <1448370281.155186.1676924115387.JavaMail.zimbra@nod.at>
In-Reply-To: <PAXPR04MB81093DB4BF1F6A6B3F8F895088A49@PAXPR04MB8109.eurprd04.prod.outlook.com>
References: <20230218214037.16977-1-richard@nod.at> <PAXPR04MB81093DB4BF1F6A6B3F8F895088A49@PAXPR04MB8109.eurprd04.prod.outlook.com>
Subject: Re: [PATCH] [RFC] net: fec: Allow turning off IRQ coalescing
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF97 (Linux)/8.8.12_GA_3809)
Thread-Topic: Allow turning off IRQ coalescing
Thread-Index: AQHZQ+Gy2VXqw+BDuEeU3ZeJCH1tfq7XFCgQXmSDC7w=
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,PDS_BAD_THREAD_QP_64,
        SPF_HELO_NONE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wei Fang,

----- Ursprüngliche Mail -----
> Von: "wei fang" <wei.fang@nxp.com>
>>  /* Set threshold for interrupt coalescing */
>> -static void fec_enet_itr_coal_set(struct net_device *ndev)
>> +static int fec_enet_itr_coal_set(struct net_device *ndev)
>>  {
>> +	bool disable_rx_itr = false, disable_tx_itr = false;
>>  	struct fec_enet_private *fep = netdev_priv(ndev);
> disable_rx_itr should be defined below fep to follow the style of the reverse
> Christmas tree.

Of course, will fix in v2.
 
>> -	int rx_itr, tx_itr;
>> +	struct device *dev = &fep->pdev->dev;
>> +	int rx_itr = 0, tx_itr = 0;
>> 
>> -	/* Must be greater than zero to avoid unpredictable behavior */
>> -	if (!fep->rx_time_itr || !fep->rx_pkts_itr ||
>> -	    !fep->tx_time_itr || !fep->tx_pkts_itr)
>> -		return;
>> +	if (!fep->rx_time_itr || !fep->rx_pkts_itr) {
>> +		if (fep->rx_time_itr || fep->rx_pkts_itr) {
> 
> I think the below should be better:
> if (!!fep->rx_time_itr == ! fep->rx_pkts_itr)

At least it's shorter. :-)
I'm not sure which variant is easier to understand, though.

But in general you are fine with returning -EINVAL in this case?
I'm asking because that a userspace visible change.

Thanks,
//richard
