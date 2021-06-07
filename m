Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD3C39E791
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 21:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhFGTj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 15:39:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:45272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230311AbhFGTj0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 15:39:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9401361002;
        Mon,  7 Jun 2021 19:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623094654;
        bh=8z0GAGomSF07idVWVZFmWXb5MzMYDYxVXjK/Xq55yi4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VdGqqBrRynz5fBNMiP/8drz9R75o27py2fVr/AG3SD77U/Dpd60b0Z9PQXTbCvA+w
         XRfCWvN7D9Dk3yJ2aKgS/Ke/7FFMJPo4UoBudApAM7DqmfH1MYjqPXJQp62WRbyEpX
         K5OxWBBcTIV2IYaS/91VMwNyflNbnU7xXuARx/s0/zKgPL4eLk3vcTo55JChV6oWI0
         NQRADMp2TFrqxCk8PovinSm+R+OoJ4z/iU1eLu7QWIYpB6E2VMNQTserA4FSDmgd6D
         Q8BbK/ds85Pw8VyxwoWhrvIe7ajBJrj2LTp+CeEtgisYqtCZG6UnN8e0JNfMD6XCBh
         CcrBAajtmOGEQ==
Date:   Mon, 7 Jun 2021 12:37:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: Re: [RFC PATCH 0/6] BOND TLS flags fixes
Message-ID: <20210607123733.16fb8317@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <fe48e571-7936-9c92-fdeb-9e83a1e27133@gmail.com>
References: <20210526095747.22446-1-tariqt@nvidia.com>
        <20210526174714.1328af13@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <8182c05b-03ab-1052-79b8-3cdf7ab467b5@gmail.com>
        <20210527105034.5e11ebef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <ee795e24-b430-a5f4-39c4-8586f2dc45a6@gmail.com>
        <fe48e571-7936-9c92-fdeb-9e83a1e27133@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 6 Jun 2021 17:02:49 +0300 Tariq Toukan wrote:
> > Regarding UPPER_DISABLES:
> > I propose using it here as an attempt to give the bond device some 
> > control over kTLS offloaded connections, to avoid cases where:
> > (*) UPPER.ktls_device_offload==OFF
> > (*) LOWER.ktls_device_offload==ON
> > (*) Newly created connections are offloaded!! Simply ignoring and 
> > bypassing the UPPER device state (this is how .ndo_sk_get_lower_dev works).
> > 
> > This is not my preferred solution though.
> > I think we should reconsider introducing bond implementation for "struct 
> > tlsdev_ops" callbacks, which gives bond interface full control and 
> > awareness to new TLS connections.  
> 
> If you're fine with the direction, I can prepare a new series that adds 
> "struct tlsdev_ops" callbacks implementation for bond, instead of the 
> "UPPER_DISABLES solution" above.
> 
> What do you think?

I think a design which requires teaching middle layer drivers about
individual hardware offloads for ULPs is poor, brittle and hard to
reason about.

But historically we seem to have acted in an ad-hoc fashion, so I 
won't hold it against you if you prefer to keep the whack-a-mole going.
