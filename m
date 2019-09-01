Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6AB8A4B83
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 21:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728786AbfIATwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 15:52:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47390 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728610AbfIATwj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Sep 2019 15:52:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qEALWWAujD6wqaBvBVOghtAX5ewh4+nmXuGcuVgkep8=; b=0d8ry+/fWDmU3oNYKV5G03+PHg
        53Gxfuluy4Fgu3y/mGiL00B9QW3n4ZUJYzE5I0xol0aQfusnrNtwEgxOCeMvHXHNUMvDfkIsB75fs
        04vSFHsAT7jF/DnEX3S0pJZrezlXGSO8PFZ6JPxhiWyfQSBUXsgkHHaQr5Vbom3S4C5o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i4Vtr-0007CX-Eb; Sun, 01 Sep 2019 21:52:35 +0200
Date:   Sun, 1 Sep 2019 21:52:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH v6 net-next 14/19] ionic: Add initial ethtool support
Message-ID: <20190901195235.GG24673@lunn.ch>
References: <20190829182720.68419-1-snelson@pensando.io>
 <20190829182720.68419-15-snelson@pensando.io>
 <20190829161029.0676d6f7@cakuba.netronome.com>
 <4c140c92-38b7-7c81-2a82-d23df8d16252@pensando.io>
 <20190830151641.0aec4a3e@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830151641.0aec4a3e@cakuba.netronome.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 30, 2019 at 03:16:41PM -0700, Jakub Kicinski wrote:
> On Fri, 30 Aug 2019 14:25:12 -0700, Shannon Nelson wrote:
> > On 8/29/19 4:10 PM, Jakub Kicinski wrote:
> > > On Thu, 29 Aug 2019 11:27:15 -0700, Shannon Nelson wrote:  
> > >> +static int ionic_get_module_eeprom(struct net_device *netdev,
> > >> +				   struct ethtool_eeprom *ee,
> > >> +				   u8 *data)
> > >> +{
> > >> +	struct ionic_lif *lif = netdev_priv(netdev);
> > >> +	struct ionic_dev *idev = &lif->ionic->idev;
> > >> +	struct ionic_xcvr_status *xcvr;
> > >> +	char tbuf[sizeof(xcvr->sprom)];
> > >> +	int count = 10;
> > >> +	u32 len;
> > >> +
> > >> +	/* The NIC keeps the module prom up-to-date in the DMA space
> > >> +	 * so we can simply copy the module bytes into the data buffer.
> > >> +	 */
> > >> +	xcvr = &idev->port_info->status.xcvr;
> > >> +	len = min_t(u32, sizeof(xcvr->sprom), ee->len);
> > >> +
> > >> +	do {
> > >> +		memcpy(data, xcvr->sprom, len);
> > >> +		memcpy(tbuf, xcvr->sprom, len);
> > >> +
> > >> +		/* Let's make sure we got a consistent copy */
> > >> +		if (!memcmp(data, tbuf, len))
> > >> +			break;
> > >> +
> > >> +	} while (--count);  
> > > Should this return an error if the image was never consistent?  
> > 
> > Sure, how about -EBUSY?
> 
> Or EAGAIN ? Not sure

ETIMEOUT?

EAGAIN would suggest it is a temporary problem. But if this fails
after 10 attempts, i would guess it is not a temporary problem, the
firmware is in deep trouble, or the SFP is loose in its cage, about to
fall out.

	 Andrew
