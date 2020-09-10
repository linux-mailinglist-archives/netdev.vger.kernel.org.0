Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2117026486B
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 16:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730859AbgIJOwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 10:52:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:59472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730877AbgIJOuk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 10:50:40 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3218720720;
        Thu, 10 Sep 2020 14:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599748997;
        bh=4edWFmmpgQP8ByWUTXRHSfEZccqXn7R5O6PzkwF5k1A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t2sTS8e67a5MbP2FJ7G6OWUH2N4UH1HlobIuictm0oSualJxgUOxYjAZws4zyfLQg
         yYI+RcOOL618WcAIN8ARl19x9EjgBnL+CxB5F2hwcmqeS8zPnTkFBopcLGw5yfiYl+
         +tEQmRUE+bO0+Dlbbd+FTGygVvQqXCDjSBt76cJU=
Date:   Thu, 10 Sep 2020 07:43:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 5/5] dpaa2-eth: support PTP Sync packet one-step
 timestamping
Message-ID: <20200910074315.59771a9a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200910093835.24317-6-yangbo.lu@nxp.com>
References: <20200910093835.24317-1-yangbo.lu@nxp.com>
        <20200910093835.24317-6-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Sep 2020 17:38:35 +0800 Yangbo Lu wrote:
> This patch is to add PTP sync packet one-step timestamping support.
> Before egress, one-step timestamping enablement needs,
> 
> - Enabling timestamp and FAS (Frame Annotation Status) in
>   dpni buffer layout.
> 
> - Write timestamp to frame annotation and set PTP bit in
>   FAS to mark as one-step timestamping event.
> 
> - Enabling one-step timestamping by dpni_set_single_step_cfg()
>   API, with offset provided to insert correction time on frame.
>   The offset must respect all MAC headers, VLAN tags and other
>   protocol headers accordingly. The correction field update can
>   consider delays up to one second. So PTP frame needs to be
>   filtered and parsed, and written timestamp into Sync frame
>   originTimestamp field.
> 
> The operation of API dpni_set_single_step_cfg() has to be done
> when no one-step timestamping frames are in flight. So we have
> to make sure the last one-step timestamping frame has already
> been transmitted on hardware before starting to send the current
> one. The resolution is,
> 
> - Utilize skb->cb[0] to mark timestamping request per packet.
>   If it is one-step timestamping PTP sync packet, queue to skb queue.
>   If not, transmit immediately.
> 
> - Schedule a work to transmit skbs in skb queue.
> 
> - mutex lock is used to ensure the last one-step timestamping packet
>   has already been transmitted on hardware through TX confirmation queue
>   before transmitting current packet.
> 
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>

This doesn't build on 32bit:

ERROR: modpost: "__udivdi3" [drivers/net/ethernet/freescale/dpaa2/fsl-dpaa2-eth.ko] undefined!
ERROR: modpost: "__umoddi3" [drivers/net/ethernet/freescale/dpaa2/fsl-dpaa2-eth.ko] undefined!
