Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50E505EF94A
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 17:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236035AbiI2Pli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 11:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236013AbiI2Pkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 11:40:46 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31CE38442;
        Thu, 29 Sep 2022 08:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=gihPt2bKu+pozhoRu7JQZyvc66MP3qC1ZK9A68zwRwM=; b=1wW7lP2TaDcg9AXO2Kk7JN4pM6
        jlDCOUAAun4zRV8fj8m0ZNgD8QauQO8aR/FcAX9UATuNp31jlKfcsweulrmO+AFYbGT6dKvwxPumA
        GVqkn8lIruIaHI7Z1iK+np15l27nHFGf/kZ4mALioayC3Ro4mQlWtwFb++KVM6p3YHhE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1odvdk-000d5U-OT; Thu, 29 Sep 2022 17:39:56 +0200
Date:   Thu, 29 Sep 2022 17:39:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Shenwei Wang <shenwei.wang@nxp.com>, brouer@redhat.com,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: Re: [EXT] Re: [PATCH 1/1] net: fec: add initial XDP support
Message-ID: <YzW8TBUufx5jM9bT@lunn.ch>
References: <20220928152509.141490-1-shenwei.wang@nxp.com>
 <YzT2An2J5afN1w3L@lunn.ch>
 <PAXPR04MB9185141B58499FD00C43BB6889579@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <YzWcI+U1WYJuZIdk@lunn.ch>
 <PAXPR04MB918545B92E493CB57CDE612B89579@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <ae658987-8763-c6de-7198-1a418e4728b4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae658987-8763-c6de-7198-1a418e4728b4@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 05:28:43PM +0200, Jesper Dangaard Brouer wrote:
> 
> 
> On 29/09/2022 15.26, Shenwei Wang wrote:
> > 
> > > From: Andrew Lunn <andrew@lunn.ch>
> > > Sent: Thursday, September 29, 2022 8:23 AM
> [...]
> > > 
> > > > I actually did some compare testing regarding the page pool for normal
> > > > traffic.  So far I don't see significant improvement in the current
> > > > implementation. The performance for large packets improves a little,
> > > > and the performance for small packets get a little worse.
> > > 
> > > What hardware was this for? imx51? imx6? imx7 Vybrid? These all use the FEC.
> > 
> > I tested on imx8qxp platform. It is ARM64.
> 
> On mvneta driver/platform we saw huge speedup replacing:
> 
>   page_pool_release_page(rxq->page_pool, page);
> with
>   skb_mark_for_recycle(skb);
> 
> As I mentioned: Today page_pool have SKB recycle support (you might have
> looked at drivers that didn't utilize this yet), thus you don't need to
> release the page (page_pool_release_page) here.  Instead you could simply
> mark the SKB for recycling, unless driver does some page refcnt tricks I
> didn't notice.
> 
> On the mvneta driver/platform the DMA unmap (in page_pool_release_page) was
> very expensive. This imx8qxp platform might have faster DMA unmap in case is
> it cache-coherent.

I don't know about imx8qxp, but i've played with imx6 and Vybrid, and
cache flush and invalidate are very expensive.

      Andrew

