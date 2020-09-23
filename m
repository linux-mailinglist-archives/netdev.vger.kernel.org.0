Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C47C827622A
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 22:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgIWUbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 16:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgIWUbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 16:31:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FBCC0613CE;
        Wed, 23 Sep 2020 13:31:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B69C711D53F8B;
        Wed, 23 Sep 2020 13:15:00 -0700 (PDT)
Date:   Wed, 23 Sep 2020 13:31:47 -0700 (PDT)
Message-Id: <20200923.133147.842604978902817779.davem@davemloft.net>
To:     s.riedmueller@phytec.de
Cc:     fugang.duan@nxp.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        c.hemp@phytec.de
Subject: Re: [PATCH] net: fec: Keep device numbering consistent with
 datasheet
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200923142528.303730-1-s.riedmueller@phytec.de>
References: <20200923142528.303730-1-s.riedmueller@phytec.de>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 23 Sep 2020 13:15:01 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Riedmueller <s.riedmueller@phytec.de>
Date: Wed, 23 Sep 2020 16:25:28 +0200

> From: Christian Hemp <c.hemp@phytec.de>
> 
> Make use of device tree alias for device enumeration to keep the device
> order consistent with the naming in the datasheet.
> 
> Otherwise for the i.MX 6UL/ULL the ENET1 interface is enumerated as eth1
> and ENET2 as eth0.
> 
> Signed-off-by: Christian Hemp <c.hemp@phytec.de>
> Signed-off-by: Stefan Riedmueller <s.riedmueller@phytec.de>

Device naming and ordering for networking devices was never, ever,
guaranteed.

Use udev or similar.

> @@ -3691,6 +3692,10 @@ fec_probe(struct platform_device *pdev)
>  
>  	ndev->max_mtu = PKT_MAXBUF_SIZE - ETH_HLEN - ETH_FCS_LEN;
>  
> +	eth_id = of_alias_get_id(pdev->dev.of_node, "ethernet");
> +	if (eth_id >= 0)
> +		sprintf(ndev->name, "eth%d", eth_id);

You can't ever just write into ndev->name, what if another networking
device is already using that name?

This change is incorrect on many levels.
