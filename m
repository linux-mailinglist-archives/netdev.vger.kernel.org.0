Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A04E187457
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 10:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405953AbfHIIhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 04:37:37 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:34349 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405787AbfHIIhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 04:37:36 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 6E48FFF80C;
        Fri,  9 Aug 2019 08:37:33 +0000 (UTC)
Date:   Fri, 9 Aug 2019 10:32:50 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Matt Pelland <mpelland@starry.com>
Cc:     netdev@vger.kernel.org, maxime.chevallier@bootlin.com,
        antoine.tenart@bootlin.com
Subject: Re: [PATCH v2 net-next 2/2] net: mvpp2: support multiple comphy lanes
Message-ID: <20190809083250.GB3516@kwain>
References: <20190808230606.7900-1-mpelland@starry.com>
 <20190808230606.7900-3-mpelland@starry.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190808230606.7900-3-mpelland@starry.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Matt,

On Thu, Aug 08, 2019 at 07:06:06PM -0400, Matt Pelland wrote:
>  
>  static void mvpp2_port_enable(struct mvpp2_port *port)
> @@ -3389,7 +3412,9 @@ static void mvpp2_stop_dev(struct mvpp2_port *port)
>  
>  	if (port->phylink)
>  		phylink_stop(port->phylink);
> -	phy_power_off(port->comphy);
> +
> +	if (port->priv->hw_version == MVPP22)
> +		mvpp22_comphy_deinit(port);

You can drop the check on the version here, mvpp22_comphy_deinit will
return 0 if no comphy was described. (You added other calls to this
function without the check, which is fine).

> @@ -5037,20 +5062,18 @@ static int mvpp2_port_probe(struct platform_device *pdev,
>  			    struct fwnode_handle *port_fwnode,
>  			    struct mvpp2 *priv)
>  {
> -	struct phy *comphy = NULL;
> -	struct mvpp2_port *port;
> -	struct mvpp2_port_pcpu *port_pcpu;
> +	unsigned int ntxqs, nrxqs, ncomphys, nrequired_comphys, thread;
>  	struct device_node *port_node = to_of_node(port_fwnode);
> +	struct mvpp2_port_pcpu *port_pcpu;
>  	netdev_features_t features;
> -	struct net_device *dev;
>  	struct phylink *phylink;
> -	char *mac_from = "";
> -	unsigned int ntxqs, nrxqs, thread;
> +	struct mvpp2_port *port;
>  	unsigned long flags = 0;
> +	struct net_device *dev;
> +	int err, i, phy_mode;
> +	char *mac_from = "";
>  	bool has_tx_irqs;
>  	u32 id;
> -	int phy_mode;
> -	int err, i;
>  
>  	has_tx_irqs = mvpp2_port_has_irqs(priv, port_node, &flags);
>  	if (!has_tx_irqs && queue_mode == MVPP2_QDIST_MULTI_MODE) {
> @@ -5084,14 +5107,38 @@ static int mvpp2_port_probe(struct platform_device *pdev,
>  		goto err_free_netdev;
>  	}
>  
> +	port = netdev_priv(dev);
> +
>  	if (port_node) {
> -		comphy = devm_of_phy_get(&pdev->dev, port_node, NULL);
> -		if (IS_ERR(comphy)) {
> -			if (PTR_ERR(comphy) == -EPROBE_DEFER) {
> -				err = -EPROBE_DEFER;
> -				goto err_free_netdev;
> +		for (i = 0, ncomphys = 0; i < ARRAY_SIZE(port->comphys); i++) {
> +			port->comphys[i] = devm_of_phy_get_by_index(&pdev->dev,
> +								    port_node,
> +								    i);
> +			if (IS_ERR(port->comphys[i])) {
> +				err = PTR_ERR(port->comphys[i]);
> +				port->comphys[i] = NULL;
> +				if (err == -EPROBE_DEFER)
> +					goto err_free_netdev;
> +				err = 0;
> +				break;
>  			}
> -			comphy = NULL;
> +
> +			++ncomphys;
> +		}
> +
> +		if (phy_mode == PHY_INTERFACE_MODE_XAUI)
> +			nrequired_comphys = 4;
> +		else if (phy_mode == PHY_INTERFACE_MODE_RXAUI)
> +			nrequired_comphys = 2;
> +		else
> +			nrequired_comphys = 1;
> +
> +		if (ncomphys < nrequired_comphys) {
> +			dev_err(&pdev->dev,
> +				"not enough comphys to support %s\n",
> +				phy_modes(phy_mode));
> +			err = -EINVAL;
> +			goto err_free_netdev;

The comphy is optional and could not be described (some SoC do not have
a driver for their comphy, and some aren't described at all). In such
cases we do rely on the bootloader/firmware configuration. Also, I'm not
sure how that would work with dynamic reconfiguration of the mode if the
n# of lanes used changes (I'm not sure that is possible though).

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
