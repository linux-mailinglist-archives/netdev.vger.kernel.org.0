Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E924753E3
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 18:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388405AbfGYQZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 12:25:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37828 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387917AbfGYQZr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 12:25:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vF8pehf9WACOPFY8+j82oxEDoilhtJTQwFK4OkW1Z5I=; b=0LEQBu31w3joU/8JREYvfJGqAk
        +vGBh6vHRDU7DZpSMYXNxQy+UNTa/jn5BtPmkexJilQDj1X/hKtd0mH7uwQyxAoyatHsmfeseoG0a
        L6LMngGT8pnmDWCHvXs/O8kXEVYRisKJ9QaqyYeffrtJedEQVydNVuAH94kVErUA3NyM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hqgYp-0007a5-B7; Thu, 25 Jul 2019 18:25:43 +0200
Date:   Thu, 25 Jul 2019 18:25:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergej Benilov <sergej.benilov@googlemail.com>
Cc:     venza@brownhat.org, netdev@vger.kernel.org
Subject: Re: [PATCH] sis900: add support for ethtool --eeprom-dump
Message-ID: <20190725162543.GJ21952@lunn.ch>
References: <20190725161809.14650-1-sergej.benilov@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725161809.14650-1-sergej.benilov@googlemail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int sis900_read_eeprom(struct net_device *net_dev, u8 *buf)
> +{
> +	struct sis900_private *sis_priv = netdev_priv(net_dev);
> +	void __iomem *ioaddr = sis_priv->ioaddr;
> +	int wait, ret = -EAGAIN;
> +	u16 signature;
> +	u16 *ebuf = (u16 *)buf;
> +	int i;
> +
> +	if (sis_priv->chipset_rev == SIS96x_900_REV) {
> +		sw32(mear, EEREQ);
> +		for (wait = 0; wait < 2000; wait++) {
> +			if (sr32(mear) & EEGNT) {
> +				/* read 16 bits, and index by 16 bits */
> +				for (i = 0; i < sis_priv->eeprom_size / 2; i++)
> +					ebuf[i] = (u16)read_eeprom(ioaddr, i);
> +			ret = 0;
> +			break;
> +			}
> +		udelay(1);
> +		}
> +	sw32(mear, EEDONE);

The indentation looks all messed up here.

> +	} else {
> +		signature = (u16)read_eeprom(ioaddr, EEPROMSignature);
> +		if (signature != 0xffff && signature != 0x0000) {
> +			/* read 16 bits, and index by 16 bits */
> +			for (i = 0; i < sis_priv->eeprom_size / 2; i++)
> +				ebuf[i] = (u16)read_eeprom(ioaddr, i);
> +			ret = 0;
> +		}
> +	}
> +	return ret;
> +}
> +
> +#define SIS900_EEPROM_MAGIC	0xBABE
> +static int sis900_get_eeprom(struct net_device *dev, struct ethtool_eeprom *eeprom, u8 *data)
> +{
> +	struct sis900_private *sis_priv = netdev_priv(dev);
> +	u8 *eebuf;
> +	int res;
> +
> +	eebuf = kmalloc(sis_priv->eeprom_size, GFP_KERNEL);
> +	if (!eebuf)
> +		return -ENOMEM;
> +
> +	eeprom->magic = SIS900_EEPROM_MAGIC;
> +	spin_lock_irq(&sis_priv->lock);
> +	res = sis900_read_eeprom(dev, eebuf);
> +	spin_unlock_irq(&sis_priv->lock);
> +	if (!res)
> +		memcpy(data, eebuf + eeprom->offset, eeprom->len);
> +	kfree(eebuf);

Why do you not put the data directly into data and avoid this memory
allocation, and memcpy?

	    Andrew
