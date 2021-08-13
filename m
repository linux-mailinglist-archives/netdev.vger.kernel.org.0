Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F10343EBE6B
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 00:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235396AbhHMW6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 18:58:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49386 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235029AbhHMW6C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 18:58:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=FYuUdJcFQOnbiiBadjNTfXqj9uF9g7KISuzsDGYuIvY=; b=C085qsX/52ve+v3DUlpobQXO/P
        xQqpZwVxtMvm7cREVO5zkVU4jchLMtKkpNwVA1i1wYi2Sm4PW0/Jf/kNbMMbvmd42qQmONNay4cCu
        ubMgBINKx5U6Yhpv8H94DHq+ccliTuHltIfKJI9v5l2i5Qt3fW4Siny1Gh1imVLJy2p4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mEg7D-00HZox-WF; Sat, 14 Aug 2021 00:57:28 +0200
Date:   Sat, 14 Aug 2021 00:57:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux@rempel-privat.de,
        himadrispandya@gmail.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+a631ec9e717fb0423053@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] net: asix: fix uninit value in asix_mdio_read
Message-ID: <YRb419yLsAtDVShf@lunn.ch>
References: <YRbw1psAc8jQu4ob@lunn.ch>
 <20210813224219.11359-1-paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813224219.11359-1-paskripkin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
> index ac92bc52a85e..7019c25e591c 100644
> --- a/drivers/net/usb/asix_common.c
> +++ b/drivers/net/usb/asix_common.c
> @@ -468,18 +468,25 @@ int asix_mdio_read(struct net_device *netdev, int phy_id, int loc)
>  	struct usbnet *dev = netdev_priv(netdev);
>  	__le16 res;
>  	u8 smsr;
> -	int i = 0;
> +	int i;
>  	int ret;
>  
>  	mutex_lock(&dev->phy_mutex);
> -	do {
> +	for (i = 0; i < 30; ++i) {
>  		ret = asix_set_sw_mii(dev, 0);
>  		if (ret == -ENODEV || ret == -ETIMEDOUT)
>  			break;
>  		usleep_range(1000, 1100);
>  		ret = asix_read_cmd(dev, AX_CMD_STATMNGSTS_REG,
>  				    0, 0, 1, &smsr, 0);
> -	} while (!(smsr & AX_HOST_EN) && (i++ < 30) && (ret != -ENODEV));
> +		if (ret == -ENODEV)
> +			break;
> +		else if (ret < 0)
> +			continue;
> +		else if (smsr & AX_HOST_EN)
> +			break;
> +	}
> +

Yes, this looks good. And Jakub is correct, there are 3 other bits of
similar code you should look at.

     Andrew
