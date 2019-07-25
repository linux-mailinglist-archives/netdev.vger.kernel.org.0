Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F47774F9C
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 15:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbfGYNfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 09:35:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37190 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728133AbfGYNfJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 09:35:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MvtK+vxquVFvODP7Hp9oxRqZL1AwJOX5AE5bIw+ncSY=; b=QZsQzSNEvTN2EdmFN1X7GYolTE
        wyttvezrQMnYK7L22W5CqOorx2tQ70W1TTt+DKik3p371l75xwOHKeHamPUEULf+s/jy1T/C3qWt8
        o5F8GiYFWAbOAvCd2+wq/Emc5za7p7e1e0OTyXjpYGEBAXSIUSYyHen/oLfcUwj9NfGc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hqdti-00068y-TK; Thu, 25 Jul 2019 15:35:06 +0200
Date:   Thu, 25 Jul 2019 15:35:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v4 net-next 13/19] ionic: Add initial ethtool support
Message-ID: <20190725133506.GD21952@lunn.ch>
References: <20190722214023.9513-1-snelson@pensando.io>
 <20190722214023.9513-14-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190722214023.9513-14-snelson@pensando.io>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int ionic_get_module_eeprom(struct net_device *netdev,
> +				   struct ethtool_eeprom *ee,
> +				   u8 *data)
> +{
> +	struct lif *lif = netdev_priv(netdev);
> +	struct ionic_dev *idev = &lif->ionic->idev;
> +	struct xcvr_status *xcvr;
> +	u32 len;
> +
> +	/* The NIC keeps the module prom up-to-date in the DMA space
> +	 * so we can simply copy the module bytes into the data buffer.
> +	 */
> +	xcvr = &idev->port_info->status.xcvr;
> +	len = min_t(u32, sizeof(xcvr->sprom), ee->len);
> +	memcpy(data, xcvr->sprom, len);
> +
> +	return 0;
> +}

Is the firmware doing this DMA update atomically? The diagnostic
values are u16s. Is there any chance we do this memcpy at the same
time the DMA is active and we get a mix of old and new data?

Often in cases like this you do the copy twice and ensure you get the
same values each time. If not, keep repeating the copy until you do
get the same values twice.

     Andrew
