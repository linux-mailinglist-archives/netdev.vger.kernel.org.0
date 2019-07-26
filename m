Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE94D75C05
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 02:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfGZAU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 20:20:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41324 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726942AbfGZAU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 20:20:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4A92612650632;
        Thu, 25 Jul 2019 17:20:58 -0700 (PDT)
Date:   Thu, 25 Jul 2019 17:20:57 -0700 (PDT)
Message-Id: <20190725.172057.361131538899179966.davem@davemloft.net>
To:     navid.emamdoost@gmail.com
Cc:     emamd001@umn.edu, kjlu@umn.edu, smccaman@umn.edu,
        secalert@redhat.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mscc: ocelot: null check devm_kcalloc
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190725015609.24389-1-navid.emamdoost@gmail.com>
References: <20190725015609.24389-1-navid.emamdoost@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jul 2019 17:20:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>
Date: Wed, 24 Jul 2019 20:56:09 -0500

> devm_kcalloc may fail and return NULL. Added the null check.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> ---
>  drivers/net/ethernet/mscc/ocelot_board.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
> index 58bde1a9eacb..52377cfdc31a 100644
> --- a/drivers/net/ethernet/mscc/ocelot_board.c
> +++ b/drivers/net/ethernet/mscc/ocelot_board.c
> @@ -257,6 +257,8 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
>  
>  	ocelot->ports = devm_kcalloc(&pdev->dev, ocelot->num_phys_ports,
>  				     sizeof(struct ocelot_port *), GFP_KERNEL);
> +	if (!ocelot->ports)
> +		return -ENOMEM;
>  

At the very least this leaks a reference to 'ports'.  I didn't check what other
resources obtained by this function are leaked as well by this change, please
audit before resubmitting.
