Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4643A6678
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 14:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233600AbhFNM0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 08:26:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35470 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233071AbhFNM0F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 08:26:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=oiBH2JKjoAAJbc4R4FuVxQ59nQgyPuSoFXb64F6CMmU=; b=slkrvpp+tamTu2ZaMxFaIDixL+
        oRV4DLfpYHor4zMd8HmORon+sEyP1ls3SpDmlnryret0sFXgIl9coS0dPWcz1G3peItdGfT1zXsnN
        KykDF2++tlhKywwJkY07Aq+yKSK8hMPX+nfPt3jU2eLC+rCRErQAzTKFwfBdxBIrqlnY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lsldB-009JmZ-8C; Mon, 14 Jun 2021 14:23:53 +0200
Date:   Mon, 14 Jun 2021 14:23:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jonathan Davies <jonathan.davies@nutanix.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: usbnet: allow overriding of default USB interface
 naming
Message-ID: <YMdKWSjiXeiDESKR@lunn.ch>
References: <20210611152339.182710-1-jonathan.davies@nutanix.com>
 <YMRbt+or+QTlqqP9@kroah.com>
 <469dd530-ebd2-37a4-9c6a-9de86e7a38dc@nutanix.com>
 <YMckz2Yu8L3IQNX9@kroah.com>
 <a620bc87-5ee7-6132-6aa0-6b99e1052960@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a620bc87-5ee7-6132-6aa0-6b99e1052960@nutanix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > Userspace solutions include:
> > >   1. udev backing off and retrying in the event of a collision; or
> > >   2. avoiding ever renaming a device to a name in the "eth%d" namespace.
> > 
> > Picking a different namespace does not cause a lack of collisions to
> > happen, you could have multiple usb network devices being found at the
> > same time, right?
> > 
> > So no matter what, 1) has to happen.
> 
> Within a namespace, the "%d" in "eth%d" means __dev_alloc_name finds a name
> that's not taken. I didn't check the locking but assume that can only happen
> serially, in which case two devices probed in parallel would not mutually
> collide.
> 
> So I don't think it's necessarily true that 1) has to happen.

Say you changed the namespace to usb%d. And you want the device in USB
port 1.4 to be usb1 and the device in USB port 1.3 to be usb0. They
probe the other way around. You have the same problem, you need to
handle the race condition in udev, back off an try again.

As GregKH said, 1) has to happen.

   Andrew
