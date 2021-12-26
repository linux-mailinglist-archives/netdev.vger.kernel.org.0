Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BADAE47F962
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 23:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234749AbhLZWfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 17:35:51 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:42180 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229792AbhLZWfv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Dec 2021 17:35:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=EYEfWSOxjEQsctTy+DTqVGmo79pAz+gWiP7UIaIjswQ=; b=ndALQLoqXD/NCjvgb3K/mWQv08
        flD0WfvvrB4AtrWeARuJgcHtRibCIFa7pkydvqpcLIyO35XdZQRMx/hYJwM0EV1U58U5ofPYKMGf6
        HpP7cIw3F65FeYqFU9pcWlZCvxU6xPPvzs5DsMAJ1KQ/Xd9H+fcDTTNQpFb4zyAD0Kf8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n1c7I-00HX4W-WC; Sun, 26 Dec 2021 23:35:49 +0100
Date:   Sun, 26 Dec 2021 23:35:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Matthias-Christian Ott <ott@mirix.org>
Cc:     Petko Manolov <petkan@nucleusys.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v2] net: usb: pegasus: Do not drop long Ethernet
 frames
Message-ID: <YcjuRJ5H+RzUDteL@lunn.ch>
References: <20211226221208.2583-1-ott@mirix.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211226221208.2583-1-ott@mirix.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 26, 2021 at 11:12:08PM +0100, Matthias-Christian Ott wrote:
> The D-Link DSB-650TX (2001:4002) is unable to receive Ethernet frames
> that are longer than 1518 octets, for example, Ethernet frames that
> contain 802.1Q VLAN tags.
> 
> The frames are sent to the pegasus driver via USB but the driver
> discards them because they have the Long_pkt field set to 1 in the
> received status report. The function read_bulk_callback of the pegasus
> driver treats such received "packets" (in the terminology of the
> hardware) as errors but the field simply does just indicate that the
> Ethernet frame (MAC destination to FCS) is longer than 1518 octets.
> 
> It seems that in the 1990s there was a distinction between
> "giant" (> 1518) and "runt" (< 64) frames and the hardware includes
> flags to indicate this distinction. It seems that the purpose of the
> distinction "giant" frames was to not allow infinitely long frames due
> to transmission errors and to allow hardware to have an upper limit of
> the frame size. However, the hardware already has such limit with its
> 2048 octet receive buffer and, therefore, Long_pkt is merely a
> convention and should not be treated as a receive error.
> 
> Actually, the hardware is even able to receive Ethernet frames with 2048
> octets which exceeds the claimed limit frame size limit of the driver of
> 1536 octets (PEGASUS_MTU).
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Matthias-Christian Ott <ott@mirix.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
