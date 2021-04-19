Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C066364D36
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 23:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241227AbhDSVlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 17:41:00 -0400
Received: from mail.netfilter.org ([217.70.188.207]:37350 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241175AbhDSVkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 17:40:55 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 5491163E56;
        Mon, 19 Apr 2021 23:39:51 +0200 (CEST)
Date:   Mon, 19 Apr 2021 23:40:19 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, john@phrozen.org,
        nbd@nbd.name, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        dqfext@gmail.com, frank-w@public-files.de
Subject: Re: [PATCH net-next 2/3] net: ethernet: mtk_eth_soc: missing mutex
Message-ID: <20210419214019.GA8535@salvia>
References: <20210418211145.21914-1-pablo@netfilter.org>
 <20210418211145.21914-3-pablo@netfilter.org>
 <20210419141601.531b2efd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210419141601.531b2efd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 19, 2021 at 02:16:01PM -0700, Jakub Kicinski wrote:
> On Sun, 18 Apr 2021 23:11:44 +0200 Pablo Neira Ayuso wrote:
> > Patch 2ed37183abb7 ("netfilter: flowtable: separate replace, destroy and
> > stats to different workqueues") splits the workqueue per event type. Add
> > a mutex to serialize updates.
> > 
> > Fixes: 502e84e2382d ("net: ethernet: mtk_eth_soc: add flow offloading support")
> > Reported-by: Frank Wunderlich <frank-w@public-files.de>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> This driver doesn't set unlocked_driver_cb, why is it expected to take
> any locks? I thought the contract is that caller should hold rtnl.

No rtnl lock is held from the netfilter side, see:

42f1c2712090 ("netfilter: nftables: comment indirect serialization of
commit_mutex with rtnl_mutex")
