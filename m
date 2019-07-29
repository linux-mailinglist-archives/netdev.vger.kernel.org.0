Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0667079108
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 18:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729220AbfG2QfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 12:35:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45372 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729210AbfG2QfL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 12:35:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xO0CP8AV1H6UAZ0iA2YeRu/E0C6+LBoCdmOpD6uQBuw=; b=fLUYnMvBS4xOpFiXxiBEXt0C9k
        XRhUToIX6rC1gVoie4UGaQHmN9lGhxCpPerfuv2b7S4COFNcwL2l3KeoaoQ5DzHAN/AyM4cTV2fGd
        Zbf7Wu+nJelHm3XNhcpGWb8COKANWnTQiKQ+7eZlGoPX5eIoZKG+2/ZSkW87nFIY+oKQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hs8c6-00030c-N5; Mon, 29 Jul 2019 18:35:06 +0200
Date:   Mon, 29 Jul 2019 18:35:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com,
        jiri@mellanox.com
Subject: Re: [PATCH 0/5] staging: fsl-dpaa2/ethsw: add the .ndo_fdb_dump
 callback
Message-ID: <20190729163506.GJ4110@lunn.ch>
References: <1564416712-16946-1-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564416712-16946-1-git-send-email-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 29, 2019 at 07:11:47PM +0300, Ioana Ciornei wrote:
> This patch set adds some features and small fixes in the
> FDB table manipulation area.
> 
> First of all, we implement the .ndo_fdb_dump netdev callback so that all
> offloaded FDB entries, either static or learnt, are available to the user.
> This is necessary because the DPAA2 switch does not emit interrupts when a
> new FDB is learnt or deleted, thus we are not able to keep the software
> bridge state and the HW in sync by calling the switchdev notifiers.
> 
> The patch set also adds the .ndo_fdb_[add|del] callbacks in order to
> facilitate adding FDB entries not associated with any master device.
> 
> One interesting thing that I observed is that when adding an FDB entry
> associated with a bridge (ie using the 'master' keywork appended to the
> bridge command) and then dumping the FDB entries, there will be duplicates
> of the same entry: one listed by the bridge device and one by the
> driver's .ndo_fdb_dump).
> It raises the question whether this is the expected behavior or not.

DSA devices are the same, they don't provide an interrupt when a new
entry is added by the hardware. So we can have two entries, or just
the SW bridge entry, or just the HW entry, depending on ageing.
 
> Another concern is regarding the correct/desired machanism for drivers to
> signal errors back to switchdev on adding or deleting an FDB entry.
> In the switchdev documentation, there is a TODO in the place of this topic.

It used to be a two state prepare/commit transaction, but that was
changed a while back.

Maybe the DSA core code can give you ideas?

      Andrew
