Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E4F1EC2BE
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 21:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgFBT36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 15:29:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgFBT36 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 15:29:58 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12FA2206E2;
        Tue,  2 Jun 2020 19:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591126197;
        bh=1hBLrZg8X2acETkZYOjT00wEqCW1nenOSI1VbaWk2lI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VW+O6scbO7flZAH65Wt6O9kqkw7+wNDrxAVj03aQU00mcTXWIoOezC4Sy7nBdO+bE
         06cerlKExp/cSPfeA2b4AD0kxhNG3oj6zE73X3H2bTnPaoluy+jXmL6ZsqMtWQUUyt
         qL5VRPkJWaDFxjgFW/hu5v6/btG5z88wuQ8ICttM=
Date:   Tue, 2 Jun 2020 12:29:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Victor Julien <victor@inliniac.net>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Eric Dumazet <edumazet@google.com>,
        Mao Wenan <maowenan@huawei.com>, Arnd Bergmann <arnd@arndb.de>,
        Neil Horman <nhorman@tuxdriver.com>, linux-doc@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexander Drozdov <al.drozdov@gmail.com>,
        Tom Herbert <tom@herbertland.com>
Subject: Re: [PATCH net-next v2] af-packet: new flag to indicate all csums
 are good
Message-ID: <20200602122954.0c35072b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <6a3dcce9-4635-28e9-d78e-1c7f1f7874da@inliniac.net>
References: <20200602080535.1427-1-victor@inliniac.net>
        <CA+FuTSfD2-eF0H=Qu09=JXK6WTiWKNtcqRXqv3TfMfB-=0GiMg@mail.gmail.com>
        <b0a9d785-9d5e-9897-b051-6d9a1e8f914e@inliniac.net>
        <CA+FuTSd07inNysGhx088hq_jybrikSQdxw8HYjmP84foXhnXOA@mail.gmail.com>
        <06479df9-9da4-dbda-5bd1-f6e4d61471d0@inliniac.net>
        <CA+FuTSci29=W89CLweZcW=RTKwEXpUdPjsLGTB95iSNcnpU_Lw@mail.gmail.com>
        <6a3dcce9-4635-28e9-d78e-1c7f1f7874da@inliniac.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Jun 2020 21:22:11 +0200 Victor Julien wrote:
> - receiver uses nfp (netronome) driver: TP_STATUS_CSUM_VALID set for
> every packet, including the bad TCP ones
> - receiver uses ixgbe driver: TP_STATUS_CSUM_VALID not set for the bad
> packets.
> 
> Again purely based on 'git grep' it seems nfp does not support
> UNNECESSARY, while ixgbe does.
> 
> (my original testing was with the nfp only, so now I at least understand
> my original thinking)

FWIW nfp defaults to CHECKSUM_COMPLETE if the device supports it (see
if you have RXCSUM_COMPLETE in the probe logs). It supports UNNECESSARY
as well, but IDK if there is a way to choose  the preferred checksum
types in the stack :( You'd have to edit the driver and remove the
NFP_NET_CFG_CTRL_CSUM_COMPLETE from the NFP_NET_CFG_CTRL_RXCSUM_ANY
mask to switch to using UNNECESSARY.
