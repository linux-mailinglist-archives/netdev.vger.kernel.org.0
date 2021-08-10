Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C662E3E8358
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 20:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbhHJS6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 14:58:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43384 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhHJS6n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 14:58:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=zrDmownRqedhK9FalGqTapgSEMhaysIVywDskPQS7vs=; b=rxlWxL6vUHxBVabSKz5hly3BZh
        MSlPKD3FuoXr3iBssla4rcfDzKmrNi7TeFQ8se/QJ3iWG0Y0trGL9X/GVQjOGz1pKrq15GmEuB4g7
        7j4309a/8+1977lp22zKn0uJ3ESC9dsqeLvXX80XYNuDXSYfl4zGlCxh4uBaEwFfA2zM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mDWx8-00GxgF-Du; Tue, 10 Aug 2021 20:58:18 +0200
Date:   Tue, 10 Aug 2021 20:58:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, mkubecek@suse.cz, pali@kernel.org,
        vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 2/8] ethtool: Add ability to reset
 transceiver modules
Message-ID: <YRLMSt2JAqXr8zko@lunn.ch>
References: <20210809102152.719961-1-idosch@idosch.org>
 <20210809102152.719961-3-idosch@idosch.org>
 <YRF+a6C/wHa7+2Gs@lunn.ch>
 <YRJ5g/W11V0mjKHs@shredder>
 <20210810065423.076e3b0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRLCUc8NZnRZFUFs@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRLCUc8NZnRZFUFs@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I thought there are already RTNL-lock-less ethtool ops, but maybe I
> imagined it. Given that we also want to support firmware update on
> modules and that user space might want to update several modules
> simultaneously, do you have a suggestion on how to handle it from
> locking perspective?

I had a similar problem for Ethernet cable testing. It takes a few
seconds to perform a cable test, and you don't want to hold the RTNL
for that, if you can help it. I made changes to the PHY state machine,
so it has an additional state, indicating a cable test is in
operation. The ethtool netlink op simply starts the cable test and
then returns. Once the cable test is complete, it async reports the
results to user space.

So for module upgrade, you probably need to add a per module state
machine. Changes to the state need to hold RTNL, but you can release
it between state changes.

   Andrew
