Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA32434AD0
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 14:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhJTMIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 08:08:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48516 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230111AbhJTMI3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 08:08:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=khHKq/hpyIkq75CXxFNA6EgYxRX4fAEUeTeFeev128Y=; b=VK
        p+igOruiAOaFhT7YQtbGqaQblELZCyWjIYqwG24+Xwo0+cZwg7DXgGorFC1Ae5tWMEvOLkDbrACkL
        IXQ5E/GNhce68GOYgQszqHi13SbX2drp52eKuYTZAHaBt28houXdHiJ0ryLLma+Mqbk/IzhJqBSva
        USU2ydao4bCu250=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mdAMI-00BBHg-65; Wed, 20 Oct 2021 14:06:14 +0200
Date:   Wed, 20 Oct 2021 14:06:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     R W van Schagen <vschagen@cs.com>
Cc:     netdev@vger.kernel.org
Subject: Re: DSA slaves not inheriting hw_enc_features and xfrmdev_ops?
Message-ID: <YXAGNmH+GsI5e9ly@lunn.ch>
References: <CDEC9628-69B6-4A83-81CF-34407070214F.ref@cs.com>
 <CDEC9628-69B6-4A83-81CF-34407070214F@cs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CDEC9628-69B6-4A83-81CF-34407070214F@cs.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 09:28:40AM +0800, R W van Schagen wrote:
> Hi all,
> 
> When I register a master device (eth0) with ESP hardware offload:
> 
> 	netdev->xfrmdev_ops = &mtk_xfrmdev_ops;
> 	netdev->features |= NETIF_F_HW_ESP;
> 	netdev->hw_enc_features |= NETIF_F_HW_ESP;
> 
> Only the “features” are inherited by the DSA slaves. When those
> get registered without the xfrmdev_ops the HW_ESP feature is
> dropped again.
> 
> Is this a “bug” and should I make a patch to fix this or is this actually
> a design feature?

Design feature.

The problem is, for most MAC devices, the additional DSA
header/trailer messes up all acceleration. The HW does not understand
the header/trailer, don't know they have to skip it, have trouble
finding the IP header, etc. So in general, we turn off all
acceleration features.

If you pair a Marvell MAC with a Marvell Switch, there is a good
chance it understands the Marvell DSA header and some forms of
acceleration work. Same goes for a Broadcom MAC with a Broadcom
switch. But pair a Freescale MAC with a Marvell Switch and even basic
IP checksumming does not work, the FEC HW cannot find the IP header.

> As a work-around I am using a notifier call and add those features but
> I don’t think this is the proper way to do this in a production driver.

It is not a simple problem to solve in a generic way. You end up with
an M by S matrices for HW features which work, where M is the MAC and
S is the switch.

So for you board, with your specific pairing of MAC and Switch, which
i assume is a mediatek MAC connected to a mediatek switch, using a
notifier call is not too unreasonable.

We could also consider DT properties, indicating which features work
for this board. That should be a reasonably generic solution, which
you can implement in the DSA core.

	    Andrew
