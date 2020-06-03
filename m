Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 271B81ED910
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 01:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgFCX3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 19:29:40 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:15373 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbgFCX3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 19:29:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1591226978; x=1622762978;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=cMxPpty/f+7mKCtNnGJbHXmL0UHrWLElwVaGJTK71ho=;
  b=LSELDQELWYLwfcMxw7FAVehq90P2fOeC8fFJtY8DZzDkdU3RVQIR9KmD
   frPibMH7p8IzMT6G7Hq22BlXiWudKhce5KA+COkZlGIjldftleqDQhvXU
   Kt0360IR4lWXX+eO1vzo9iSN0UXPnXLNjxIzmBJtxZatk440aRQdMzC79
   zGSIcecaAzvzA3H4DdcLSGjDbg/3u/Fqv49RkCbv73EziRm9CbYw6jH4g
   oR4h8QEAz3d8zE5r59LPpYpNHReQo3d5dQFwT+gcGnz4ncJL7TE40xeSF
   n+byCm7qVdlw+jD4Fl0Ubfzp7tdfHW2Tn9LCJJT9gjnKJLwU9UQSGV9dv
   Q==;
IronPort-SDR: 51QxAxWLfsJoow5fKnrAxyHoWch43oVxuoOn3ctKK5hS22I+TaO7sLyiSW7EBY90kpz303XJun
 tIz/ZR1WRWjRHNEMUTuL90HeS4nN7f3GwdBbeLE2WrP/hB/DZ+96dPJLoHKS8JCtqFeTQlN0Me
 D2JvS/OB9f6IGPeBNHwe0UMqV1N8q/oIgHuFh810sp6uqL3tkth+eN7SFB6lt8dyzn3mSlpoT7
 SGZ0wQEuLsD3ZxoQkq6qdq+Mmj2VTaEsTy2UHb/krirUAQ/iCZUW6uht0aor4DTO1KXGtjn9y+
 hqU=
X-IronPort-AV: E=Sophos;i="5.73,470,1583164800"; 
   d="scan'208";a="139145877"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jun 2020 07:29:38 +0800
IronPort-SDR: 6GNAzKFMX1kTjzc9RJMiWLDNPmfwSBaCBdNIuiBNY1DXRgyAv9SQIWKDGo0guWd56VZ2hpoAM+
 f4Zo55K7zBOl/WWYm2CF+v9ZavdwOt7l8=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2020 16:19:16 -0700
IronPort-SDR: OPaEIMDLV/N14uVtNi+pX9CW5k2fCELm1fwG8St+idNyx9m3nVCb/wIeZpB3okdFvNOM8tOZxQ
 LDTSaa81zlcw==
WDCIronportException: Internal
Received: from unknown (HELO redsun52) ([10.149.66.28])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2020 16:29:37 -0700
Date:   Thu, 4 Jun 2020 00:29:35 +0100 (BST)
From:   "Maciej W. Rozycki" <macro@wdc.com>
To:     Andrew Lunn <andrew@lunn.ch>
cc:     Armin Wolf <W_Armin@gmx.de>, netdev@vger.kernel.org,
        "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: Usage of mdelay() inside Interrupt
In-Reply-To: <20200528222447.GB853774@lunn.ch>
Message-ID: <alpine.LFD.2.21.2006032358160.3052124@eddie.linux-mips.org>
References: <20200528211518.GA15665@localhost> <20200528222447.GB853774@lunn.ch>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 May 2020, Andrew Lunn wrote:

> > while browsing the sourcefile of lib8390.c in
> > drivers/net/ethernet/8390/, i noticed that inside
> > of ei_rx_overrun(), which is called from inside
> > a Interrupt handler, mdelay() is being used.
> > So i wonder if the usage of mdelay() inside the
> > Interrupt handler may cause problems since waiting
> > ~10ms in Interrupt context seems a bit odd.
[...]
> It is legal. But it is not ideal. But reading the comments around it
> suggests the hardware is very particular about how you recover from an
> overrun, and maybe this is the most robust solution?

 This code is very old and dates back to 1996.  At that time it was 
busy-looping inline even:

    /*
     * Wait a full Tx time (1.2ms) + some guard time, NS says 1.6ms total.
     * Early datasheets said to poll the reset bit, but now they say that
     * it "is not a reliable indicator and subsequently should be ignored."
     * We wait at least 10ms.
     */
    wait_start_time = jiffies;
    while (jiffies - wait_start_time <= 1*HZ/100)
	barrier();

Previously it had:

    /* Wait for the reset to complete. This should happen almost instantly,
	   but could take up to 1.5msec in certain rare instances.  There is no
	   easy way of timing something in that range, so we use 'jiffies' as
	   a sanity check. */
    while ((inb_p(e8390_base+EN0_ISR) & ENISR_RESET) == 0)
		if (jiffies - reset_start_time > 1) {
			printk("%s: reset did not complete at ei_rx_overrun.\n",
				   dev->name);
			NS8390_init(dev, 1);
			return;
		}

going back to 1.1.x days.  I don't have older history to hand.  Nowadays I 
think it would make sense to rewrite it to use a timer or suchlike so that 
the post-reset part runs asynchronously, but such hardware is not exactly 
common anymore I'd imagine (I should have an ISA NE2000 clone somewhere 
IIRC, which I haven't used in like 20 years) and clearly nobody bothered.

  Maciej
