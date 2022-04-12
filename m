Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E334C4FE1A3
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238555AbiDLNIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355614AbiDLNIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:08:02 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E9241095;
        Tue, 12 Apr 2022 05:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=TgrOMlNjlMLF32/qkXph3PKI7l+R09/gGWrd+m0ivac=; b=uvEyxmxVXhj34gY/BeBqihygSg
        12MslTZNsk/lo8hHaTyJ0BHxaGspUmaGfoJDxo1pkBscKkPvCYnTaiGVK7/D6tpEJNZGzuwhPYBBP
        Q6MZ6oPfcYVSkO1yXXHSKuNu5mOwnuWm5JOkidG13BvDeiUSrZRahGFeaUXdeBN2ngsQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1neG1O-00FS3b-0a; Tue, 12 Apr 2022 14:53:26 +0200
Date:   Tue, 12 Apr 2022 14:53:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: Fix return value check of
 wait_for_completion_timeout
Message-ID: <YlV2Rr+12Ikwa4yk@lunn.ch>
References: <20220412024541.17572-1-linmq006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412024541.17572-1-linmq006@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 12, 2022 at 02:45:40AM +0000, Miaoqian Lin wrote:
> wait_for_completion_timeout() returns unsigned long not int.
> It returns 0 if timed out, and positive if completed.
> The check for <= 0 is ambiguous and should be == 0 here
> indicating timeout which is the only error case.

Please fix your subject line to indicate which driver you are patching.

Please also read the netdev FAQ which will point out a few other
process issues.

> 
> Fixes: 2cd548566384 ("net: dsa: qca8k: add support for phy read/write with mgmt Ethernet")
> Fixes: 5950c7c0a68c ("net: dsa: qca8k: add support for mgmt read/write in Ethernet packet")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> ---
>  drivers/net/dsa/qca8k.c | 25 +++++++++++++------------
>  1 file changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index d3ed0a7f8077..bd8c238955a8 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -300,7 +300,7 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
>  	struct qca8k_mgmt_eth_data *mgmt_eth_data = &priv->mgmt_eth_data;
>  	struct sk_buff *skb;
>  	bool ack;
> -	int ret;
> +	unsigned long ret;

Please sort variables longest to shortest, reverse christmass tree.

>  
>  	skb = qca8k_alloc_mdio_header(MDIO_READ, reg, NULL,
>  				      QCA8K_ETHERNET_MDIO_PRIORITY, len);
> @@ -338,7 +338,7 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
>  
>  	mutex_unlock(&mgmt_eth_data->mutex);
>  
> -	if (ret <= 0)
> +	if (ret == 0)
>  		return -ETIMEDOUT;

Given this change, what happens if -ERESTARTSYS is returned?

Please consider the same question for all cases you change <= to ==.

       Andrew
