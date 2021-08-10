Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 706B33E85E9
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 00:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235171AbhHJWHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 18:07:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:58368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235154AbhHJWHB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 18:07:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14F8761008;
        Tue, 10 Aug 2021 22:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628633198;
        bh=gott3olodkVlzExdBmlgFU5DnnBh6u7FkTe05MmXE98=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QjN5sMbeakIhXv3u+bulnY3O/MsbTUbOXRWGBVlotDfjPhoBegTGSb2K4iCNOuzhB
         eAWFVnLFuSK5EsXtggzwSmzJFJzUaRjtAHvFiQd7vexsXuUnfpQMUCnvqR4dBeYxOE
         ieZkMCCH6OeD9Mu/kR4/LND4wJQ7pLmb7rFoGoSUVS7f1CZtpOtRIHYSmR9NcqIroR
         /zNNvAGLCBK2QL9BDWgdpVaRi3OAxPL8Ku2JIigaOgH1LQ1tQWRPuUF4oFIzaG4P1M
         JK01TmTVZdZHtWVbYZlAWuAqdahn6scmnXr9zlu8zGBGIzKlRUT78nBbe7/zXGrBiG
         VZyfHMPSTDJNQ==
Date:   Tue, 10 Aug 2021 15:06:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Ido Schimmel <idosch@idosch.org>, Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "pali@kernel.org" <pali@kernel.org>,
        "vadimp@nvidia.com" <vadimp@nvidia.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 1/8] ethtool: Add ability to control
 transceiver modules' low power mode
Message-ID: <20210810150636.26c17a8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <71a5bd72-2154-a796-37b7-f39afdf2e34d@intel.com>
References: <20210809102152.719961-1-idosch@idosch.org>
        <20210809102152.719961-2-idosch@idosch.org>
        <YRE7kNndxlGQr+Hw@lunn.ch>
        <YRIqOZrrjS0HOppg@shredder>
        <YRKElHYChti9EeHo@lunn.ch>
        <20210810065954.68036568@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YRLlpCutXmthqtOg@shredder>
        <71a5bd72-2154-a796-37b7-f39afdf2e34d@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Aug 2021 22:00:51 +0000 Keller, Jacob E wrote:
> >> Jake do you know what the use cases for Intel are? Are they SFP, MAC,
> >> or NC-SI related?  
> > 
> > I went through all the Intel drivers that implement these operations and
> > I believe you are talking about these commits:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c3880bd159d431d06b687b0b5ab22e24e6ef0070
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d5ec9e2ce41ac198de2ee18e0e529b7ebbc67408
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ab4ab73fc1ec6dec548fa36c5e383ef5faa7b4c1
> > 
> > There isn't too much information about the motivation, but maybe it has
> > something to do with multi-host controllers where you want to prevent
> > one host from taking the physical link down for all the other hosts
> > sharing it? I remember such issues with mlx5.
> >   
> 
> Ok, I found some more information here. The primary motivation of the
> changes in the i40e and ice drivers is from customer requests asking to
> have the link go down when the port is administratively disabled. This
> is because if the link is down then the switch on the other side will
> see the port not having link and will stop trying to send traffic to it.
> 
> As far as I can tell, the reason its a flag is because some users wanted
> the behavior the other way.
> 
> I'm not sure it's really related to the behavior here.
> 
> For what it's worth, I'm in favor of containing things like this into
> ethtool as well.

I think the question was the inverse - why not always shut down the
port if the interface is brought down?
