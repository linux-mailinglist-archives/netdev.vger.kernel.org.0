Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 833F3417C38
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 22:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348391AbhIXUQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 16:16:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:50042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347121AbhIXUQQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 16:16:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD2AC61038;
        Fri, 24 Sep 2021 20:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632514482;
        bh=RfOq/uRmKEudceSfMEIFKjCXwyHbqJJ+oZLIM7/SLxo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nyTLVn3RvNUQmmx5v0g5UYdTSu0wV1A63CLEB41lwZnxBIESCumsq3c33TpW1hl7J
         CcjrCwrYo8iM0B4Tuo175SGqACuk9W44yEdV6EvyKxsnheOO62jHuD/XXqf3XWXxvH
         DLnYKVPShh9ojvtFvFDOn6I2MxpDu/xfSaEb+QIVeNBuuCtzSSvHOXQICzEd8kt6mk
         7ypg0O5owk203/CSPezrLfw59aqIOFz9K2tjPrBgPiD6svldP80RngmrKQWegrT9WW
         Ezq4J/gdSsd68FA6GgoJypI0pUA29UjghELapbd9FwHwLVvJJ2tO8JQFo6sOfo4fSx
         4DACDrchEL27w==
Date:   Fri, 24 Sep 2021 13:14:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] nfc: avoid potential race condition
Message-ID: <20210924131441.6598ba3a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <47358bea-e761-b823-dfbd-cd8e0a2a69a6@canonical.com>
References: <20210923065051.GA25122@kili>
        <3760c70c-299c-89bf-5a4a-22e8d564ef92@canonical.com>
        <20210923122220.GB2083@kadam>
        <47358bea-e761-b823-dfbd-cd8e0a2a69a6@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Sep 2021 10:21:33 +0200 Krzysztof Kozlowski wrote:
> On 23/09/2021 14:22, Dan Carpenter wrote:
> > On Thu, Sep 23, 2021 at 09:26:51AM +0200, Krzysztof Kozlowski wrote:  
> >> On 23/09/2021 08:50, Dan Carpenter wrote:  
>  [...]  
> >>
> >> I think the difference between this llcp_sock code and above transport,
> >> is lack of writer to llcp_sock->local with whom you could race.
> >>
> >> Commits c0cfa2d8a788fcf4 and 6a2c0962105ae8ce causing the
> >> multi-transport race show nicely assigns to vsk->transport when module
> >> is unloaded.
> >>
> >> Here however there is no writer to llcp_sock->local, except bind and
> >> connect and their error paths. The readers which you modify here, have
> >> to happen after bind/connect. You cannot have getsockopt() or release()
> >> before bind/connect, can you? Unless you mean here the bind error path,
> >> where someone calls getsockopt() in the middle of bind()? Is it even
> >> possible?
> >>  
> > 
> > I don't know if this is a real issue either.
> > 
> > Racing with bind would be harmless.  The local pointer would be NULL and
> > it would return harmlessly.  You would have to race with release and
> > have a third trying to release local devices.  (Again that might be
> > wild imagination.  It may not be possible).  
> 
> Indeed. The code looks reasonable, though, so even if race is not really
> reproducible:
> 
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

Would you mind making a call if this is net (which will mean stable) or
net-next material (without the Fixes tags) and reposting? Thanks! :)
