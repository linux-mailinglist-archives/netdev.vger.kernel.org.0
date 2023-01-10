Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11375663633
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 01:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234690AbjAJA2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 19:28:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234752AbjAJA2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 19:28:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1833C3BB
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 16:28:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01DA0B807E9
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 00:28:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 314EDC433EF;
        Tue, 10 Jan 2023 00:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673310481;
        bh=XsegpVwuThZ/N5R6rfhV7JqohJrCe4fSkDj2jvdiusY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pMT+9ovZX6S8VV+wmRcJa8KAmk6Fm0sXy2rpdHg/5iQVh+EggwL+/Q+8P5Zu48W/g
         ll1qC7Saz9vZGU1UnrO5i5DZOxbYzjRVa2Z/c1pOi8OmNWgYEfTHvE1uOGh+/0gxE7
         CjHKZ3LEOYgjKoVS9M4RDQaMb45tKgHtBdkfHLRDxFgIpZhcIEb9nsAOzpGNQlsxo3
         P3CWuhfnFFUr5fwBRoTRJHlnz+b/9vrdOTeuaTzvq7jXphHWCnWx/WEfpOlQ2Rz88Z
         5v7ktNPZoblydWG9tZKGebbqFKq1UCLIVgkzDHJXeCqMczPyvJnfqYGJ6/FFNg7wUt
         I6tiCln7ko0Dg==
Date:   Mon, 9 Jan 2023 16:28:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        lorenzo.bianconi@redhat.com, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        sujuan.chen@mediatek.com, daniel@makrotopia.org
Subject: Re: [PATCH v3 net-next 3/5] net: ethernet: mtk_eth_soc: align reset
 procedure to vendor sdk
Message-ID: <20230109162800.391f7ec8@kernel.org>
In-Reply-To: <Y7rIqUhWdX1yoaKO@unreal>
References: <cover.1673102767.git.lorenzo@kernel.org>
        <af8547b94b6cad76f17c1c467b507bd915a0e2c0.1673102767.git.lorenzo@kernel.org>
        <Y7rIqUhWdX1yoaKO@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 8 Jan 2023 15:44:09 +0200 Leon Romanovsky wrote:
> On Sat, Jan 07, 2023 at 03:50:52PM +0100, Lorenzo Bianconi wrote:
> > Avoid to power-down the ethernet chip during hw reset and align reset
> > procedure to vendor sdk.
> > 
> > Tested-by: Daniel Golle <daniel@makrotopia.org>
> > Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
> > Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  drivers/net/ethernet/mediatek/mtk_eth_soc.c  | 94 +++++++++++++++-----
> >  drivers/net/ethernet/mediatek/mtk_eth_soc.h  | 12 +++
> >  drivers/net/ethernet/mediatek/mtk_ppe.c      | 27 ++++++
> >  drivers/net/ethernet/mediatek/mtk_ppe.h      |  1 +
> >  drivers/net/ethernet/mediatek/mtk_ppe_regs.h |  6 ++
> >  5 files changed, 116 insertions(+), 24 deletions(-)  
> 
> mdelay is macro wrapper around udelay, to account for possible overflow when
> passing large arguments to udelay. In general, use of mdelay is discouraged
> and code should be refactored to allow for the use of msleep.
> 
> https://www.kernel.org/doc/html/latest/timers/timers-howto.html#delays-information-on-the-various-kern
> 
> It is not your case as you are passing small numbers and can use udelay instead.

Good point, there's one:

	mdelay(100)

in the series which is a lot of time to be spinning blocking a core :S

In this particular patch you basically:

	rtnl_lock();
	mdelay(10);
	..
	mdelay(15);

which seems odd. If you can take rtnl you can sleep, so perhaps this is
trying to be competence-compatible with the vendor driver unnecessarily?
