Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC5C2A0AC7
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 21:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbfH1TzE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 28 Aug 2019 15:55:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:44184 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726591AbfH1TzE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 15:55:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2080DAD45;
        Wed, 28 Aug 2019 19:55:02 +0000 (UTC)
Date:   Wed, 28 Aug 2019 21:55:01 +0200
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Joe Perches <joe@perches.com>
Cc:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 03/15] net: sgi: ioc3-eth: remove checkpatch
 errors/warning
Message-Id: <20190828215501.e3a9f2fdf7235f8a7d1b0e7c@suse.de>
In-Reply-To: <d0fd02c3634d187dcfe5487917099bc1905e3789.camel@perches.com>
References: <20190828140315.17048-1-tbogendoerfer@suse.de>
        <20190828140315.17048-4-tbogendoerfer@suse.de>
        <d0fd02c3634d187dcfe5487917099bc1905e3789.camel@perches.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Aug 2019 10:10:18 -0700
Joe Perches <joe@perches.com> wrote:

> On Wed, 2019-08-28 at 16:03 +0200, Thomas Bogendoerfer wrote:
> > Before massaging the driver further fix oddities found by checkpatch like
> > - wrong indention
> > - comment formatting
> > - use of printk instead or netdev_xxx/pr_xxx
> 
> trivial notes:
> 
> Please try to make the code better rather than merely
> shutting up checkpatch.

that's the overall goal.

> 
> > diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
> []
> > @@ -209,8 +201,7 @@ static inline void nic_write_bit(u32 __iomem *mcr, int bit)
> >  	nic_wait(mcr);
> >  }
> >  
> > -/*
> > - * Read a byte from an iButton device
> > +/* Read a byte from an iButton device
> >   */
> 
> These comment styles would be simpler on a single line
> 
> /* Read a byte from an iButton device */
> 
> >  static u32 nic_read_byte(u32 __iomem *mcr)
> >  {
> > @@ -223,8 +214,7 @@ static u32 nic_read_byte(u32 __iomem *mcr)
> >  	return result;
> >  }
> >  
> > -/*
> > - * Write a byte to an iButton device
> > +/* Write a byte to an iButton device
> >   */
> 
> /* Write a byte to an iButton device */
> 
> etc...
> 
> []
> > @@ -323,16 +315,15 @@ static int nic_init(u32 __iomem *mcr)
> >  		break;
> >  	}
> >  
> > -	printk("Found %s NIC", type);
> > +	pr_info("Found %s NIC", type);
> >  	if (type != unknown)
> > -		printk (" registration number %pM, CRC %02x", serial, crc);
> > -	printk(".\n");
> > +		pr_cont(" registration number %pM, CRC %02x", serial, crc);
> > +	pr_cont(".\n");
> 
> This code would be more sensible as
> 
> 	if (type != unknown)
> 		pr_info("Found %s NIC registration number %pM, CRC %02x\n",
> 			type, serial, crc);
> 	else
> 		pr_info("Found %s NIC\n", type); 
> 
> Though I don't know if registration number is actually a MAC
> address or something else.  If it's just a 6 byte identifier
> that uses colon separation it should probably use "%6phC"
> instead of "%pM"

all of the code above will entirely go away with the conversion to MFD.

> > @@ -645,22 +636,21 @@ static inline void ioc3_tx(struct net_device *dev)
> >  static void ioc3_error(struct net_device *dev, u32 eisr)
> >  {
> >  	struct ioc3_private *ip = netdev_priv(dev);
> > -	unsigned char *iface = dev->name;
> >  
> >  	spin_lock(&ip->ioc3_lock);
> >  
> >  	if (eisr & EISR_RXOFLO)
> > -		printk(KERN_ERR "%s: RX overflow.\n", iface);
> > +		netdev_err(dev, "RX overflow.\n");
> >  	if (eisr & EISR_RXBUFOFLO)
> > -		printk(KERN_ERR "%s: RX buffer overflow.\n", iface);
> > +		netdev_err(dev, "RX buffer overflow.\n");
> >  	if (eisr & EISR_RXMEMERR)
> > -		printk(KERN_ERR "%s: RX PCI error.\n", iface);
> > +		netdev_err(dev, "RX PCI error.\n");
> >  	if (eisr & EISR_RXPARERR)
> > -		printk(KERN_ERR "%s: RX SSRAM parity error.\n", iface);
> > +		netdev_err(dev, "RX SSRAM parity error.\n");
> >  	if (eisr & EISR_TXBUFUFLO)
> > -		printk(KERN_ERR "%s: TX buffer underflow.\n", iface);
> > +		netdev_err(dev, "TX buffer underflow.\n");
> >  	if (eisr & EISR_TXMEMERR)
> > -		printk(KERN_ERR "%s: TX PCI error.\n", iface);
> > +		netdev_err(dev, "TX PCI error.\n");
> 
> All of these should probably be ratelimited() output.

good point, will change it.

Thanks,
Thomas.

-- 
SUSE Software Solutions Germany GmbH
HRB 247165 (AG München)
Geschäftsführer: Felix Imendörffer
