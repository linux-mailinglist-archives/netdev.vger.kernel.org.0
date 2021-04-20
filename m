Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBB57365B98
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 16:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbhDTO6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 10:58:55 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39510 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232768AbhDTO6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 10:58:51 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id A1DC563E82;
        Tue, 20 Apr 2021 16:57:47 +0200 (CEST)
Date:   Tue, 20 Apr 2021 16:58:16 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        john@phrozen.org, nbd@nbd.name, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, dqfext@gmail.com
Subject: Re: [PATCH net-next 2/3] net: ethernet: mtk_eth_soc: missing mutex
Message-ID: <20210420145816.GA27083@salvia>
References: <20210418211145.21914-1-pablo@netfilter.org>
 <20210418211145.21914-3-pablo@netfilter.org>
 <C076C591-F541-48B3-9750-8F35B4127638@public-files.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <C076C591-F541-48B3-9750-8F35B4127638@public-files.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 01:51:07PM +0200, Frank Wunderlich wrote:
> Am 18. April 2021 23:11:44 MESZ schrieb Pablo Neira Ayuso <pablo@netfilter.org>:
> >Patch 2ed37183abb7 ("netfilter: flowtable: separate replace, destroy
> >and
> >stats to different workqueues") splits the workqueue per event type.
> >Add
> >a mutex to serialize updates.
> >
> >Fixes: 502e84e2382d ("net: ethernet: mtk_eth_soc: add flow offloading
> >support")
> >Reported-by: Frank Wunderlich <frank-w@public-files.de>
> >Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Hi Pablo,
> 
> As far we tested it, the mutex does not avoid the hang. It looks a bit better,but at the end it was fixed by this Patch
> 
> https://patchwork.kernel.org/project/linux-mediatek/patch/20210417072905.207032-1-dqfext@gmail.com/
> 
> Alex did some tests without the lock here and it still looks stable.
> So it looks like it is not needed

It might be hard to trigger the race, but it's needed. There are
several workqueues racing to add and delete entries from the driver
flowtable representation which has no locks.
