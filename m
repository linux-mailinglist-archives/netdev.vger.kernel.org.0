Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8F825FC587
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 14:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbiJLMmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 08:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiJLMmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 08:42:25 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB66FC894F;
        Wed, 12 Oct 2022 05:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ZDOHsKJ2O6yHB6mK3GypL2lDL6oF4YLtssKIorMpkUY=; b=tAqLQQXtGcqUKQQMcUwu8J+DSU
        B93WVo9Tk9gbUZ6kMdj96CQpCUS1Ch0PBf39+r8kZLeBETTJmgN3hiz1qswvSttsk1PYk3wlMnyJt
        +0uA5s6JUmiBDfgGJhZNmho2YqSK3DM1jZsj6dgjO2fgwfKgLzO80503Eq07DYTm/AOM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oib3w-001nlI-Co; Wed, 12 Oct 2022 14:42:16 +0200
Date:   Wed, 12 Oct 2022 14:42:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Dembicki <paweldembicki@gmail.com>,
        Lech Perczak <lech.perczak@gmail.com>
Subject: Re: [net PATCH 1/2] net: dsa: qca8k: fix inband mgmt for big-endian
 systems
Message-ID: <Y0a2KD9pVeoYkHkK@lunn.ch>
References: <20221010111459.18958-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221010111459.18958-1-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022 at 01:14:58PM +0200, Christian Marangi wrote:
> The header and the data of the skb for the inband mgmt requires
> to be in little-endian. This is problematic for big-endian system
> as the mgmt header is written in the cpu byte order.
> 
> Fix this by converting each value for the mgmt header and data to
> little-endian, and convert to cpu byte order the mgmt header and
> data sent by the switch.
> 
> Fixes: 5950c7c0a68c ("net: dsa: qca8k: add support for mgmt read/write in Ethernet packet")
> Tested-by: Pawel Dembicki <paweldembicki@gmail.com>
> Tested-by: Lech Perczak <lech.perczak@gmail.com>
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> Reviewed-by: Lech Perczak <lech.perczak@gmail.com>
> ---
>  drivers/net/dsa/qca/qca8k-8xxx.c | 63 ++++++++++++++++++++++++--------
>  include/linux/dsa/tag_qca.h      |  6 +--
>  2 files changed, 50 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
> index 5669c92c93f7..4bb9b7eac68b 100644
> --- a/drivers/net/dsa/qca/qca8k-8xxx.c
> +++ b/drivers/net/dsa/qca/qca8k-8xxx.c
> @@ -137,27 +137,42 @@ static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
>  	struct qca8k_mgmt_eth_data *mgmt_eth_data;
>  	struct qca8k_priv *priv = ds->priv;
>  	struct qca_mgmt_ethhdr *mgmt_ethhdr;
> +	u32 command;
>  	u8 len, cmd;
> +	int i;
>  
>  	mgmt_ethhdr = (struct qca_mgmt_ethhdr *)skb_mac_header(skb);
>  	mgmt_eth_data = &priv->mgmt_eth_data;
>  
> -	cmd = FIELD_GET(QCA_HDR_MGMT_CMD, mgmt_ethhdr->command);
> -	len = FIELD_GET(QCA_HDR_MGMT_LENGTH, mgmt_ethhdr->command);
> +	command = le32_to_cpu(mgmt_ethhdr->command);
> +	cmd = FIELD_GET(QCA_HDR_MGMT_CMD, command);
> +	len = FIELD_GET(QCA_HDR_MGMT_LENGTH, command);

Humm...

This might have the same alignment issue as the second patch. In fact,
because the Ethernet header is 14 bytes in size, it is often
deliberately out of alignment by 2 bytes, so that the IP header is
aligned. You should probably be using get_unaligned_le32() when
accessing members of mgmt_ethhdr.

	  Andrew
