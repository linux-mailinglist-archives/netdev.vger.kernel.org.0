Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7F9248F48
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 22:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbgHRUAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 16:00:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59842 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726675AbgHRUAy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 16:00:54 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k87mu-009yS5-Hi; Tue, 18 Aug 2020 22:00:52 +0200
Date:   Tue, 18 Aug 2020 22:00:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Awogbemila <awogbemila@google.com>
Cc:     netdev@vger.kernel.org, Kuo Zhao <kuozhao@google.com>,
        Yangchun Fu <yangchun@google.com>
Subject: Re: [PATCH net-next 01/18] gve: Get and set Rx copybreak via ethtool
Message-ID: <20200818200052.GJ2330298@lunn.ch>
References: <20200818194417.2003932-1-awogbemila@google.com>
 <20200818194417.2003932-2-awogbemila@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818194417.2003932-2-awogbemila@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 12:44:00PM -0700, David Awogbemila wrote:
> From: Kuo Zhao <kuozhao@google.com>
> 
> This adds support for getting and setting the RX copybreak
> value via ethtool.
> 
> Reviewed-by: Yangchun Fu <yangchun@google.com>
> Signed-off-by: Kuo Zhao <kuozhao@google.com>
> Signed-off-by: David Awogbemila <awogbemila@google.com>
> ---
>  drivers/net/ethernet/google/gve/gve_ethtool.c | 34 +++++++++++++++++++
>  1 file changed, 34 insertions(+)
> 
> diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
> index d8fa816f4473..469d3332bcd6 100644
> --- a/drivers/net/ethernet/google/gve/gve_ethtool.c
> +++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
> @@ -230,6 +230,38 @@ static int gve_user_reset(struct net_device *netdev, u32 *flags)
>  	return -EOPNOTSUPP;
>  }


Hi David.

> +static int gve_get_tunable(struct net_device *netdev,
> +			   const struct ethtool_tunable *etuna, void *value)
> +{
> +	struct gve_priv *priv = netdev_priv(netdev);
> +
> +	switch (etuna->id) {
> +	case ETHTOOL_RX_COPYBREAK:
> +		*(u32 *)value = priv->rx_copybreak;
> +		return 0;
> +	default:
> +		return -EINVAL;

EOPNOTSUPP would be better. Other tunables are not invalid, they are
simply not supported by this driver.

> +	}
> +}
> +
> +static int gve_set_tunable(struct net_device *netdev,
> +			   const struct ethtool_tunable *etuna, const void *value)
> +{
> +	struct gve_priv *priv = netdev_priv(netdev);
> +	u32 len;
> +
> +	switch (etuna->id) {
> +	case ETHTOOL_RX_COPYBREAK:
> +		len = *(u32 *)value;
> +		if (len > PAGE_SIZE / 2)
> +			return -EINVAL;
> +		priv->rx_copybreak = len;
> +		return 0;
> +	default:
> +		return -EINVAL;

Same here.

     Andrew
