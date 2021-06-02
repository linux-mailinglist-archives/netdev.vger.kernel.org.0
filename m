Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72BAD399154
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 19:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbhFBRVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 13:21:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230185AbhFBRVE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 13:21:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F0AF61CBF;
        Wed,  2 Jun 2021 17:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622654361;
        bh=eJUm+eDI5irPUa4S/Ka3aCYnW3lzUUnSvMok57V7Xks=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eRIiek8cwin6KdmuBPdbVbUh2a/lSRz+HXPHaHrJMc2LvByS0G52j03Wn4q1Vi1EU
         Dg4Mm4Ouubhsln8ddb8LveITbjQVKQRPcPbPpkkbBNEyxhipbMf7t2dSecEDnjuAlD
         Vc8lSpGOgZ8B+t8qsehBKqKPZv9Wv0tMUf+QHFGCuo2ncapav1cPMpXs3T+uXxZPw1
         nzm/5lqr7C+zjX7s/fWnvslTCGh207SvXd38yjEMbm5Ma3OArtf/Mx71AmOtlwZmb0
         WXQ+dRQkkxivJRhQw1PRH8hy9gTTBOUmkSPWjiNJmwO8vo5uXEjxsRqbn+aTWwHfpm
         R75mjGaFQZeNQ==
Date:   Wed, 2 Jun 2021 10:19:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Michael Walle <michael@walle.cc>, Po Liu <po.liu@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 2/2] net: enetc: count the tc-taprio window
 drops
Message-ID: <20210602101920.3c09686a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210602122114.2082344-3-olteanv@gmail.com>
References: <20210602122114.2082344-1-olteanv@gmail.com>
        <20210602122114.2082344-3-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Jun 2021 15:21:14 +0300 Vladimir Oltean wrote:
> From: Po Liu <Po.Liu@nxp.com>
> 
> The enetc scheduler for IEEE 802.1Qbv has 2 options (depending on
> PTGCR[TG_DROP_DISABLE]) when we attempt to send an oversized packet
> which will never fit in its allotted time slot for its traffic class:
> either block the entire port due to head-of-line blocking, or drop the

the entire port or the entire queue?

> packet and set a bit in the writeback format of the transmit buffer
> descriptor, allowing other packets to be sent.
> 
> We obviously choose the second option in the driver, but we do not
> detect the drop condition, so from the perspective of the network stack,
> the packet is sent and no error counter is incremented.
> 
> This change checks the writeback of the TX BD when tc-taprio is enabled,
> and increments a specific ethtool statistics counter and a generic
> "tx_dropped" counter in ndo_get_stats64.

Any chance we should also report that back to the qdisc to have 
a standard way of querying from user space? Qdisc offload supports
stats in general, it shouldn't be an issue, and the stat seems generic
enough, no?
