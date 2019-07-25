Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C808F75747
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 20:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfGYSw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 14:52:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37162 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbfGYSw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 14:52:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D7C4E1439869E;
        Thu, 25 Jul 2019 11:52:56 -0700 (PDT)
Date:   Thu, 25 Jul 2019 11:52:56 -0700 (PDT)
Message-Id: <20190725.115256.1232519801887604352.davem@davemloft.net>
To:     navid.emamdoost@gmail.com
Cc:     emamd001@umn.edu, kjlu@umn.edu, smccaman@umn.edu,
        secalert@redhat.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] stmmac_dt_phy: null check the allocation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190723222809.9752-1-navid.emamdoost@gmail.com>
References: <20190723222809.9752-1-navid.emamdoost@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jul 2019 11:52:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>
Date: Tue, 23 Jul 2019 17:28:09 -0500

> @@ -342,10 +342,13 @@ static int stmmac_dt_phy(struct plat_stmmacenet_data *plat,
>  		mdio = true;
>  	}
>  
> -	if (mdio)
> +	if (mdio) {
>  		plat->mdio_bus_data =
>  			devm_kzalloc(dev, sizeof(struct stmmac_mdio_bus_data),
>  				     GFP_KERNEL);
> +		if (!plat->mdio_bus_data)
> +			return -ENOMEM;

This leaks a reference to plat->mdio_node() which is acquired in the
for_each_child_of_node() loop right before the context here.

This is what I really fear about these automated patches, it is quite
often the case that acquired resources are subtly acquired in nearby
code and not released by the proposed "fix".

Therefore, either we end up with a regression, or as is the case here
a reviewer invests more time into double checking your patch than you
put into writing the patch in the first place.
