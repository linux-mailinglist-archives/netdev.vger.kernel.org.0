Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1397364D41
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 23:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbhDSVoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 17:44:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230362AbhDSVoN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 17:44:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DAF1613B2;
        Mon, 19 Apr 2021 21:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618868623;
        bh=cA2r2+oUFkfY0flZtBSjhJXEiabSzAMtsLWLuBWeEt0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GiJypv8wXSd5PclJWFSw0HclSfhkCJ+ORSMcgDeI6a+wWt/Dd/otQdG5niqVXYCqS
         UljGDgQduoBYO/lPSHyEf1s+tjewfsEHJEbxWR74RIEi3fylWeuUnyXmVwgqnWtVsP
         WtZjlM1dAdvPD3Yw/qFjJAoXa5mmL5Uky2V0FTRTW8jHblw6FzX6TNyf0py27kCvFY
         N/SCcgAbEnm5L8sO2aJXsSylbfXZdVAJGedLwVxffdPl3RjSVpW89YE8QSAdQktBDm
         JAo8LVxAWo+crd+ujeocY5TEIAIruLtYyuDzRnCN/lA2CbY0su5HYAC0kSV3CKs3wh
         DANanPqnE45bQ==
Date:   Mon, 19 Apr 2021 14:43:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, john@phrozen.org,
        nbd@nbd.name, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        dqfext@gmail.com, frank-w@public-files.de
Subject: Re: [PATCH net-next 2/3] net: ethernet: mtk_eth_soc: missing mutex
Message-ID: <20210419144341.159bde8a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210419214019.GA8535@salvia>
References: <20210418211145.21914-1-pablo@netfilter.org>
        <20210418211145.21914-3-pablo@netfilter.org>
        <20210419141601.531b2efd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210419214019.GA8535@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Apr 2021 23:40:19 +0200 Pablo Neira Ayuso wrote:
> On Mon, Apr 19, 2021 at 02:16:01PM -0700, Jakub Kicinski wrote:
> > On Sun, 18 Apr 2021 23:11:44 +0200 Pablo Neira Ayuso wrote:  
> > > Patch 2ed37183abb7 ("netfilter: flowtable: separate replace, destroy and
> > > stats to different workqueues") splits the workqueue per event type. Add
> > > a mutex to serialize updates.
> > > 
> > > Fixes: 502e84e2382d ("net: ethernet: mtk_eth_soc: add flow offloading support")
> > > Reported-by: Frank Wunderlich <frank-w@public-files.de>
> > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>  
> > 
> > This driver doesn't set unlocked_driver_cb, why is it expected to take
> > any locks? I thought the contract is that caller should hold rtnl.  
> 
> No rtnl lock is held from the netfilter side, see:
> 
> 42f1c2712090 ("netfilter: nftables: comment indirect serialization of
> commit_mutex with rtnl_mutex")

All the tc-centric drivers but mlx5 depend on rtnl_lock, is there
something preventing them from binding to netfilter blocks?
