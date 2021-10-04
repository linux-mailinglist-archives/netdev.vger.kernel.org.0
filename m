Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 077B34219D9
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 00:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235039AbhJDWUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 18:20:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48520 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233722AbhJDWUi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 18:20:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=fXIKy2k/vY3L/PyqPe8UAMoaAxM3IxyNnwmA2Xa99ys=; b=KUVYB8sVuttuhrvNzHhLtkXOHj
        YOw+/LRFdO2sOcOtwgNkFLyvsrg8zBV74XvFfKhOajXSuU4Ri3qYlgV2UpOwN4j0+pOU6LtidaDdT
        r6pUPHUCnmbwGTRA+x8KF9gBQs5PeV5upI6QNGurwUi2sjFP1He8g57vgLCMsTGSVzrA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mXWIH-009bsQ-Qo; Tue, 05 Oct 2021 00:18:45 +0200
Date:   Tue, 5 Oct 2021 00:18:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] ethernet: use eth_hw_addr_set() for
 dev->addr_len cases
Message-ID: <YVt9xbVVoNb3p9ro@lunn.ch>
References: <20211004160522.1974052-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004160522.1974052-1-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 09:05:21AM -0700, Jakub Kicinski wrote:
> Convert all Ethernet drivers from memcpy(... dev->addr_len)
> to eth_hw_addr_set():
> 
>   @@
>   expression dev, np;
>   @@
>   - memcpy(dev->dev_addr, np, dev->addr_len)
>   + eth_hw_addr_set(dev, np)

eth_hw_addr_set() uses ether_addr_copy(), which says:

Please note: dst & src must both be aligned to u16.

memcpy() does not have this restriction. If the source is something
funky, like an EEPROM, it could be oddly aligned.

If you are going to do this, i think the assumption needs removing, a
test added for unaligned addresses and fall back to memcpy().

    Andrew
