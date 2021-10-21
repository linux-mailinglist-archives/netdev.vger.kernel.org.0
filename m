Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35895436273
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 15:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbhJUNNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 09:13:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50548 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230190AbhJUNNt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 09:13:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ZS2BKWKxWDvBf/K0rbJ3g0MkLzVvuskgDJd+t6tRQgE=; b=k3nfYSEJLQKmQYgxBfm02bOy+q
        mERjDCCERiUdHGZQ9iTkXrNZOsXJQI52BQD9wWrgFArch3OTd2QxM2w8rcZas/ee4IGmmVjkypVfG
        JRtGLq5xr+rV88u7rG+ME1xny2dVUWopdw38cPjzuZ3mliPn1y0O5gkaYNxcnWevzLj8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mdXr2-00BHtk-Vz; Thu, 21 Oct 2021 15:11:32 +0200
Date:   Thu, 21 Oct 2021 15:11:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     R W van Schagen <vschagen@cs.com>
Cc:     netdev@vger.kernel.org
Subject: Re: DSA slaves not inheriting hw_enc_features and xfrmdev_ops?
Message-ID: <YXFnBHFlOt8AvcLe@lunn.ch>
References: <CDEC9628-69B6-4A83-81CF-34407070214F.ref@cs.com>
 <CDEC9628-69B6-4A83-81CF-34407070214F@cs.com>
 <YXAGNmH+GsI5e9ly@lunn.ch>
 <A08F0571-5705-4FD6-9C5D-55B4C0734712@cs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A08F0571-5705-4FD6-9C5D-55B4C0734712@cs.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Thanks for the explanation. For now I will proceed using notifier callbacks.
> 
> One more strange thing I am noticing: Even if I set NETIF_F_GSO_ESP
> I am still not getting any GSO packets (skb_is_gso is always false) so my
> transmit speeds are like 2/3 of the receive speeds. Hardware Decryption vs
> Encryption is not 100% the same, but it is close.
> 
> I am getting the esp_gro_receive callbacks, but not the esp_gso_segment,
> BUT: for some reason my packets still get TCP GSO.

I'm not too familiar with GSO. But my understanding is that you create
a template set of headers which need to be placed onto each frame when
the segmentation actually happens. For DSA, that template would need
to include the DSA header. As far as i understand, there is nothing in
the DSA core that allows for adding the DSA headers into the template.
So you might be able to do GSO at the slave interface, but when the
slave passes frames to the master, you then require segmentation to
happen, so the tag driver can add the DSA header.

	Andrew

