Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5534E5F1314
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 22:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbiI3UBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 16:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbiI3UBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 16:01:48 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 284ED15C58B;
        Fri, 30 Sep 2022 13:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=aF9+uItERNccajHQE2aAtbJOSbU1gykm8UjqQQZOh3A=; b=YJ
        evxK5lECKx5gfiEC68kmrxacjP6GaJZWydtWgHksKhQlqh4N8tnvnDV8/uATPa5R0tUHaQrr9lUvn
        FLZ4LwfJXcfjTPBMSeHxPQ+Wwn02bD5o9egFJeZZ02Vh3Gs8cTpBkEqXJRYM6oovWCoztFfz5mYWa
        9YetEHWG3zeKkRw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oeMCV-000js0-RL; Fri, 30 Sep 2022 22:01:35 +0200
Date:   Fri, 30 Sep 2022 22:01:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
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
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: Re: [EXT] Re: [PATCH 1/1] net: fec: using page pool to manage RX
 buffers
Message-ID: <YzdLHx+N4SXaAkUe@lunn.ch>
References: <20220930193751.1249054-1-shenwei.wang@nxp.com>
 <YzdI4mDXCKuI/58N@lunn.ch>
 <PAXPR04MB9185E69829540686618987D289569@PAXPR04MB9185.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <PAXPR04MB9185E69829540686618987D289569@PAXPR04MB9185.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The testing above was on the imx8 platform. The following are the testing result
> On the imx6sx board:
> 
> ######### Original implementation ######
> 
> shenwei@5810:~/pktgen$ iperf -c 10.81.16.245 -w 2m -i 1
> ------------------------------------------------------------
> Client connecting to 10.81.16.245, TCP port 5001
> TCP window size:  416 KByte (WARNING: requested 1.91 MByte)
> ------------------------------------------------------------
> [  1] local 10.81.17.20 port 36486 connected with 10.81.16.245 port 5001
> [ ID] Interval       Transfer     Bandwidth
> [  1] 0.0000-1.0000 sec  70.5 MBytes   591 Mbits/sec
> [  1] 1.0000-2.0000 sec  64.5 MBytes   541 Mbits/sec
> [  1] 2.0000-3.0000 sec  73.6 MBytes   618 Mbits/sec
> [  1] 3.0000-4.0000 sec  73.6 MBytes   618 Mbits/sec
> [  1] 4.0000-5.0000 sec  72.9 MBytes   611 Mbits/sec
> [  1] 5.0000-6.0000 sec  73.4 MBytes   616 Mbits/sec
> [  1] 6.0000-7.0000 sec  73.5 MBytes   617 Mbits/sec
> [  1] 7.0000-8.0000 sec  73.4 MBytes   616 Mbits/sec
> [  1] 8.0000-9.0000 sec  73.4 MBytes   616 Mbits/sec
> [  1] 9.0000-10.0000 sec  73.9 MBytes   620 Mbits/sec
> [  1] 0.0000-10.0174 sec   723 MBytes   605 Mbits/sec
> 
> 
>  ######  Page Pool implémentation ########
> 
> shenwei@5810:~/pktgen$ iperf -c 10.81.16.245 -w 2m -i 1
> ------------------------------------------------------------
> Client connecting to 10.81.16.245, TCP port 5001
> TCP window size:  416 KByte (WARNING: requested 1.91 MByte)
> ------------------------------------------------------------
> [  1] local 10.81.17.20 port 57288 connected with 10.81.16.245 port 5001
> [ ID] Interval       Transfer     Bandwidth
> [  1] 0.0000-1.0000 sec  78.8 MBytes   661 Mbits/sec
> [  1] 1.0000-2.0000 sec  82.5 MBytes   692 Mbits/sec
> [  1] 2.0000-3.0000 sec  82.4 MBytes   691 Mbits/sec
> [  1] 3.0000-4.0000 sec  82.4 MBytes   691 Mbits/sec
> [  1] 4.0000-5.0000 sec  82.5 MBytes   692 Mbits/sec
> [  1] 5.0000-6.0000 sec  82.4 MBytes   691 Mbits/sec
> [  1] 6.0000-7.0000 sec  82.5 MBytes   692 Mbits/sec
> [  1] 7.0000-8.0000 sec  82.4 MBytes   691 Mbits/sec
> [  1] 8.0000-9.0000 sec  82.4 MBytes   691 Mbits/sec
> ^C[  1] 9.0000-9.5506 sec  45.0 MBytes   686 Mbits/sec
> [  1] 0.0000-9.5506 sec   783 MBytes   688 Mbits/sec

Cool, so it helps there as well.

But you knew i was interested in these numbers. So you should of made
them part of the commit message so i didn't have to ask...

     Andrew
