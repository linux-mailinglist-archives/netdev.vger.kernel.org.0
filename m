Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1555713272E
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 14:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbgAGNJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 08:09:53 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50550 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727834AbgAGNJw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 08:09:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+qA8LILyDAM20NHU3SG+A3d1urHh/KISnnbovWuY9Mo=; b=V3lZ/cElmbnfxymFt9382OONTb
        zRto8bri6BnDXJsM1BXlaclAigb/RRX5nnbuS9NlnNdK0R7GDLRODa7gySsq4osvD5HbovAsms9MA
        fPq3qCqiYbr74LKyUGLPDoMOtoUjrcdl0bWRAQcJW7KWIqgFnh6xERw+IdFKZJvtcD3E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ioocI-0007l5-01; Tue, 07 Jan 2020 14:09:50 +0100
Date:   Tue, 7 Jan 2020 14:09:49 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v2 net-next 3/4] ionic: restrict received packets to mtu
 size
Message-ID: <20200107130949.GA23819@lunn.ch>
References: <20200107034349.59268-1-snelson@pensando.io>
 <20200107034349.59268-4-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200107034349.59268-4-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 06, 2020 at 07:43:48PM -0800, Shannon Nelson wrote:
> Make sure the NIC drops packets that are larger than the
> specified MTU.
> 
> The front end of the NIC will accept packets larger than MTU and
> will copy all the data it can to fill up the driver's posted
> buffers - if the buffers are not long enough the packet will
> then get dropped.  With the Rx SG buffers allocagted as full
> pages, we are currently setting up more space than MTU size
> available and end up receiving some packets that are larger
> than MTU, up to the size of buffers posted.  To be sure the
> NIC doesn't waste our time with oversized packets we need to
> lie a little in the SG descriptor about how long is the last
> SG element.

Hi Shannon

Does the stack really drop them later? With DSA, the frame has an
additional header, making it longer than the MTU. Most of the NICs
i've used are happy to receive such frames. So it does seem common
practice to not implement a 'MRU' in the MAC.

If the stack really does drop them, this is a reasonable optimisation.

Thanks

	Andrew
