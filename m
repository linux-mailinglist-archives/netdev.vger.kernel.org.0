Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12B0A628B90
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 22:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237813AbiKNVqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 16:46:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237735AbiKNVqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 16:46:42 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB44B193EB;
        Mon, 14 Nov 2022 13:46:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ybRBmyZ9Ux4/ZlZayQOkr0DOOOiP1ndIctY8VIKIKUE=; b=quRN4uGqrdtZlmhoTwXWBHXz1G
        ceM9rqgywMYzu1/P7gE1FjSzXgcqNQ/0L53qB6eXs7YTX3D2GSoFI4huu+MNdsa0RAvYDU6G/HVUC
        ENhd8/4iryoINocZR/d7x8LOWWX7r67EB0ZE5nqJ6r83zRDnjrKvFGH5Hu+FouONCMdg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ouhHH-002Ntk-BT; Mon, 14 Nov 2022 22:46:03 +0100
Date:   Mon, 14 Nov 2022 22:46:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Wei Fang <wei.fang@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>,
        kernel test robot <lkp@intel.com>
Subject: Re: [EXT] Re: [PATCH v3 1/1] net: fec: add xdp and page pool
 statistics
Message-ID: <Y3K3GyhBnMI4m6ic@lunn.ch>
References: <20221111153505.434398-1-shenwei.wang@nxp.com>
 <20221114134542.697174-1-alexandr.lobakin@intel.com>
 <Y3JLz1niXbdVbRH9@lunn.ch>
 <PAXPR04MB91853D935E363E8A7E3ED7BF89059@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <20221114152327.702592-1-alexandr.lobakin@intel.com>
 <PAXPR04MB918589D35F8B10307D4D430E89059@PAXPR04MB9185.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PAXPR04MB918589D35F8B10307D4D430E89059@PAXPR04MB9185.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -1764,7 +1768,13 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
>  
>         if (xdp_result & FEC_ENET_XDP_REDIR)
>                 xdp_do_flush_map();
> +#if 1
> +       if (xdp_prog) {
> +               int i;
> +               for(i = 0; i < XDP_STATS_TOTAL; i++)
> +                       atomic64_add(xdp_stats[i], &rxq->stats[i]);
> +       }
> +#endif

Atomic operations are expensive. You should not use them unless you
really do need them.

What driver are you copying here? There is nothing particularly new
here, so you should just be copying code from another driver, and hope
you picked a good example.

     Andrew
