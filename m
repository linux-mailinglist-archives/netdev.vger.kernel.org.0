Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5818DEC98
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 00:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729491AbfD2WMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 18:12:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49200 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728105AbfD2WMS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 18:12:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2kYkuKi0eOi4EYkCSiWnO4OUux0YvrH2tW6GujbRqCs=; b=2hRLVDtny6Qt8FRmT6UY1Oof3n
        W5apgJ71EVRR40X57FKFYkcR1OIKXEkS9KJElQaivoDR7qLI/wVxh+dh3LqG2Qod3CF0yHRodRUZu
        wb8peKzgbFeRZyfjpKSKux5kho815tUrSunuH6Pjo3x8ENtAY9hk1l/qFdnkeYE4DiAo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hLEVI-0007Pi-8O; Tue, 30 Apr 2019 00:12:04 +0200
Date:   Tue, 30 Apr 2019 00:12:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Esben Haabendal <esben@geanix.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Yang Wei <yang.wei9@zte.com.cn>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/12] net: ll_temac: Support indirect_mutex share within
 TEMAC IP
Message-ID: <20190429221204.GN12333@lunn.ch>
References: <20190426073231.4008-1-esben@geanix.com>
 <20190429083422.4356-1-esben@geanix.com>
 <20190429083422.4356-8-esben@geanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190429083422.4356-8-esben@geanix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> For OF devices, the xlnx,compound parent of the temac node should be
> used to find siblings, and setup a shared indirect_mutex between them.
> I will leave this work to somebody else, as I don't have hardware to
> test that.  No regression is introduced by that, as before this commit
> using two Ethernet interfaces in same TEMAC block is simply broken.

Is that true?

> @@ -1092,7 +1092,16 @@ static int temac_probe(struct platform_device *pdev)
>  	lp->dev = &pdev->dev;
>  	lp->options = XTE_OPTION_DEFAULTS;
>  	spin_lock_init(&lp->rx_lock);
> -	mutex_init(&lp->indirect_mutex);
> +
> +	/* Setup mutex for synchronization of indirect register access */
> +	if (pdata) {
> +		if (!pdata->indirect_mutex) {
> +			dev_err(&pdev->dev,
> +				"indirect_mutex missing in platform_data\n");
> +			return -EINVAL;
> +		}
> +		lp->indirect_mutex = pdata->indirect_mutex;
> +	}

In the OF case, isn't lp->indirect_mutex now a NULL pointer, where as
before it was a valid mutex?

Or did i miss something somewhere?

   Andrew
