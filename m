Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBC1B1AA07
	for <lists+netdev@lfdr.de>; Sun, 12 May 2019 04:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbfELCjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 May 2019 22:39:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:32777 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbfELCjF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 May 2019 22:39:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=aCJtuq/P6mYIusUme6l9ztDgZEanEdJposM5u/bYv6U=; b=Cqxjk/pd37PDTdPojq9hsT1ro3
        5RFFX0I1Huf7MhqHvg4gG3dm2rbSoWTU1wu38w1cXYOKr+8wbe1hvV+Xnh2z4Sv6A+I+ZKLC8vgjO
        Vxe4Tnc/IkaIvGuFuakL0PnFT8Jrn1HxYwY/l/r6cipXdedDQMpHG1btQq1m4rIgv41A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hPeOD-00005I-LX; Sun, 12 May 2019 04:39:01 +0200
Date:   Sun, 12 May 2019 04:39:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net 2/3] net: dsa: Remove dangerous DSA_SKB_CLONE() macro
Message-ID: <20190512023901.GL4889@lunn.ch>
References: <20190511201447.15662-1-olteanv@gmail.com>
 <20190511201447.15662-3-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190511201447.15662-3-olteanv@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 11, 2019 at 11:14:46PM +0300, Vladimir Oltean wrote:
> This does not cause any bug now because it has no users, but its body
> contains two pointer definitions within a code block:
> 
> 		struct sk_buff *clone = _clone;	\
> 		struct sk_buff *skb = _skb;	\
> 
> When calling the macro as DSA_SKB_CLONE(clone, skb), these variables
> would obscure the arguments that the macro was called with, and the
> initializers would be a no-op instead of doing their job (undefined
> behavior, by the way, but GCC nicely puts NULL pointers instead).
> 
> So simply remove this broken macro and leave users to simply call
> "DSA_SKB_CB(skb)->clone = clone" by hand when needed.
> 
> There is one functional difference when doing what I just suggested
> above: the control block won't be transferred from the original skb into
> the clone. Since there's no foreseen need for the control block in the
> clone ATM, this is ok.
> 
> Fixes: b68b0dd0fb2d ("net: dsa: Keep private info in the skb->cb")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

If it has no users, it should not of been merged.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
