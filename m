Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F76D5F1301
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 21:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbiI3Twa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 15:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbiI3Tw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 15:52:29 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0796A1A6EB2;
        Fri, 30 Sep 2022 12:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=pnHQZ9rBe55rnctqBA3woeObnRsQg9T9AOmpTNE1wGs=; b=ToODwlkniUi0GLmBg2vrxa6hQ5
        2RP3Ewop11YiW6MkKFSuV8+H8snyofHw354kmo+vI3zQQGSsENm6VwHIJwvzaQ3nbd434B2JveNdp
        M+TyZHziuptI5JTS956k/Ue00V5FoYuP7JRV+tAk3aQIZ356xdBYSFv5h2SWd5plzLEI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oeM3G-000jo6-34; Fri, 30 Sep 2022 21:52:02 +0200
Date:   Fri, 30 Sep 2022 21:52:02 +0200
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
        Wei Fang <wei.fang@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, imx@lists.linux.dev
Subject: Re: [PATCH 1/1] net: fec: using page pool to manage RX buffers
Message-ID: <YzdI4mDXCKuI/58N@lunn.ch>
References: <20220930193751.1249054-1-shenwei.wang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220930193751.1249054-1-shenwei.wang@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 30, 2022 at 02:37:51PM -0500, Shenwei Wang wrote:
> This patch optimizes the RX buffer management by using the page
> pool. The purpose for this change is to prepare for the following
> XDP support. The current driver uses one frame per page for easy
> management.
> 
> The following are the comparing result between page pool implementation
> and the original implementation (non page pool).
> 
>  --- Page Pool implementation ----
> 
> shenwei@5810:~$ iperf -c 10.81.16.245 -w 2m -i 1
> ------------------------------------------------------------
> Client connecting to 10.81.16.245, TCP port 5001
> TCP window size:  416 KByte (WARNING: requested 1.91 MByte)
> ------------------------------------------------------------
> [  1] local 10.81.17.20 port 43204 connected with 10.81.16.245 port 5001
> [ ID] Interval       Transfer     Bandwidth
> [  1] 0.0000-1.0000 sec   111 MBytes   933 Mbits/sec
> [  1] 1.0000-2.0000 sec   111 MBytes   934 Mbits/sec
> [  1] 2.0000-3.0000 sec   112 MBytes   935 Mbits/sec
> [  1] 3.0000-4.0000 sec   111 MBytes   933 Mbits/sec
> [  1] 4.0000-5.0000 sec   111 MBytes   934 Mbits/sec
> [  1] 5.0000-6.0000 sec   111 MBytes   933 Mbits/sec
> [  1] 6.0000-7.0000 sec   111 MBytes   931 Mbits/sec
> [  1] 7.0000-8.0000 sec   112 MBytes   935 Mbits/sec
> [  1] 8.0000-9.0000 sec   111 MBytes   933 Mbits/sec
> [  1] 9.0000-10.0000 sec   112 MBytes   935 Mbits/sec
> [  1] 0.0000-10.0077 sec  1.09 GBytes   933 Mbits/sec
> 
>  --- Non Page Pool implementation ----
> 
> shenwei@5810:~$ iperf -c 10.81.16.245 -w 2m -i 1
> ------------------------------------------------------------
> Client connecting to 10.81.16.245, TCP port 5001
> TCP window size:  416 KByte (WARNING: requested 1.91 MByte)
> ------------------------------------------------------------
> [  1] local 10.81.17.20 port 49154 connected with 10.81.16.245 port 5001
> [ ID] Interval       Transfer     Bandwidth
> [  1] 0.0000-1.0000 sec   104 MBytes   868 Mbits/sec
> [  1] 1.0000-2.0000 sec   105 MBytes   878 Mbits/sec
> [  1] 2.0000-3.0000 sec   105 MBytes   881 Mbits/sec
> [  1] 3.0000-4.0000 sec   105 MBytes   879 Mbits/sec
> [  1] 4.0000-5.0000 sec   105 MBytes   878 Mbits/sec
> [  1] 5.0000-6.0000 sec   105 MBytes   878 Mbits/sec
> [  1] 6.0000-7.0000 sec   104 MBytes   875 Mbits/sec
> [  1] 7.0000-8.0000 sec   104 MBytes   875 Mbits/sec
> [  1] 8.0000-9.0000 sec   104 MBytes   873 Mbits/sec
> [  1] 9.0000-10.0000 sec   104 MBytes   875 Mbits/sec
> [  1] 0.0000-10.0073 sec  1.02 GBytes   875 Mbits/sec

What SoC? As i keep saying, the FEC is used in a lot of different
SoCs, and you need to show this does not cause any regressions in the
older SoCs. There are probably a lot more imx5 and imx6 devices out in
the wild than imx8, which is what i guess you are testing on. Mainline
needs to work well on them all, even if NXP no longer cares about the
older Socs.

    Andrew
