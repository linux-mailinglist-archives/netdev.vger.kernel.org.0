Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF50D317471
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 00:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234023AbhBJXc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 18:32:57 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47912 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234006AbhBJXcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 18:32:45 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 65AFB4D25BDAF;
        Wed, 10 Feb 2021 15:32:04 -0800 (PST)
Date:   Wed, 10 Feb 2021 15:32:03 -0800 (PST)
Message-Id: <20210210.153203.2010046208603151217.davem@davemloft.net>
To:     steen.hegelund@microchip.com
Cc:     kishon@ti.com, vkoul@kernel.org, alexandre.belloni@bootlin.com,
        lars.povlsen@microchip.com, bjarni.jonasson@microchip.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew@lunn.ch
Subject: Re: [PATCH v14 2/4] phy: Add media type and speed serdes
 configuration interfaces
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210210085255.2006824-3-steen.hegelund@microchip.com>
References: <20210210085255.2006824-1-steen.hegelund@microchip.com>
        <20210210085255.2006824-3-steen.hegelund@microchip.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 10 Feb 2021 15:32:04 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Steen Hegelund <steen.hegelund@microchip.com>
Date: Wed, 10 Feb 2021 09:52:53 +0100

> Provide new phy configuration interfaces for media type and speed that
> allows allows e.g. PHYs used for ethernet to be configured with this
> information.
> 
> Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> ---
>  drivers/phy/phy-core.c  | 30 ++++++++++++++++++++++++++++++
>  include/linux/phy/phy.h | 26 ++++++++++++++++++++++++++
>  2 files changed, 56 insertions(+)
> 
> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
> index 71cb10826326..ccb575b13777 100644
> --- a/drivers/phy/phy-core.c
> +++ b/drivers/phy/phy-core.c
> @@ -373,6 +373,36 @@ int phy_set_mode_ext(struct phy *phy, enum phy_mode mode, int submode)
>  }
>  EXPORT_SYMBOL_GPL(phy_set_mode_ext);
>  
> +int phy_set_media(struct phy *phy, enum phy_media media)
> +{
> +	int ret;
> +
> +	if (!phy || !phy->ops->set_media)
> +		return 0;
> +
> +	mutex_lock(&phy->mutex);
> +	ret = phy->ops->set_media(phy, media);
> +	mutex_unlock(&phy->mutex);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(phy_set_media);
> +
> +int phy_set_speed(struct phy *phy, int speed)
> +{
> +	int ret;
> +
> +	if (!phy || !phy->ops->set_speed)
> +		return 0;
> +
> +	mutex_lock(&phy->mutex);
> +	ret = phy->ops->set_speed(phy, speed);
> +	mutex_unlock(&phy->mutex);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(phy_set_speed);
> +
>  int phy_reset(struct phy *phy)
>  {
>  	int ret;
> diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
> index e435bdb0bab3..e4fd69a1faa7 100644
> --- a/include/linux/phy/phy.h
> +++ b/include/linux/phy/phy.h
> @@ -44,6 +44,12 @@ enum phy_mode {
>  	PHY_MODE_DP
>  };
>  
> +enum phy_media {
> +	PHY_MEDIA_DEFAULT,
> +	PHY_MEDIA_SR,
> +	PHY_MEDIA_DAC,
> +};
> +
>  /**
>   * union phy_configure_opts - Opaque generic phy configuration
>   *
> @@ -64,6 +70,8 @@ union phy_configure_opts {
>   * @power_on: powering on the phy
>   * @power_off: powering off the phy
>   * @set_mode: set the mode of the phy
> + * @set_media: set the media type of the phy (optional)
> + * @set_speed: set the speed of the phy (optional)
>   * @reset: resetting the phy
>   * @calibrate: calibrate the phy
>   * @release: ops to be performed while the consumer relinquishes the PHY
> @@ -75,6 +83,8 @@ struct phy_ops {
>  	int	(*power_on)(struct phy *phy);
>  	int	(*power_off)(struct phy *phy);
>  	int	(*set_mode)(struct phy *phy, enum phy_mode mode, int submode);
> +	int	(*set_media)(struct phy *phy, enum phy_media media);
> +	int	(*set_speed)(struct phy *phy, int speed);
>  
>  	/**
>  	 * @configure:
> @@ -215,6 +225,8 @@ int phy_power_off(struct phy *phy);
>  int phy_set_mode_ext(struct phy *phy, enum phy_mode mode, int submode);
>  #define phy_set_mode(phy, mode) \
>  	phy_set_mode_ext(phy, mode, 0)
> +int phy_set_media(struct phy *phy, enum phy_media media);
> +int phy_set_speed(struct phy *phy, int speed);
>  int phy_configure(struct phy *phy, union phy_configure_opts *opts);
>  int phy_validate(struct phy *phy, enum phy_mode mode, int submode,
>  		 union phy_configure_opts *opts);
> @@ -344,6 +356,20 @@ static inline int phy_set_mode_ext(struct phy *phy, enum phy_mode mode,
>  #define phy_set_mode(phy, mode) \
>  	phy_set_mode_ext(phy, mode, 0)
>  
> +static inline int phy_set_media(struct phy *phy, enum phy_media media)
> +{
> +	if (!phy)
> +		return 0;
> +	return -ENOSYS;
> +}

Maybe ENODEV instead?
