Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAD930EDD8
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 08:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234769AbhBDH4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 02:56:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:54360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234723AbhBDH4r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 02:56:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D931864F55;
        Thu,  4 Feb 2021 07:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612425366;
        bh=DSUZx40ENOPiuSW9/nMJGxTniUjgoz49uDMP6Q4Rxts=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LxS79Ss5DQ0dXhKXHao/98/eVwjHS09vED9xZfaHRDONWllLCXNqhv0rDLX/2Eivv
         6/MwSQ+7pMtdbxWPCj1h9gFhfXRlqTKhRwDN6PHKecUt7NEkO1EpCpesUf2mLSuOL3
         PaNYaLt/WdNlgFK8EQLgvV/xhte4mtMdMNYAyT63BE+qOZsJTTetBcttot+eY/tTcQ
         dCUvxJI6Q+UPkhZgeM7tYylrUiykhSICIzfvBejp+pDxYUKNKQdmVa0tFwbLLsshJf
         iQj+1ZC99yjjC6zg+6+9Vc8U/qP7o2C+qTkf6QjvCBs9lblHhHuywdwkgFXhunwxuM
         JMeX3Va5/kyDA==
Date:   Thu, 4 Feb 2021 13:26:01 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Steen Hegelund <steen.hegelund@microchip.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v13 2/4] phy: Add ethernet serdes configuration option
Message-ID: <20210204075601.GI3079@vkoul-mobl.Dlink>
References: <20210129130748.373831-1-steen.hegelund@microchip.com>
 <20210129130748.373831-3-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210129130748.373831-3-steen.hegelund@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29-01-21, 14:07, Steen Hegelund wrote:
> Provide a new ethernet phy configuration structure, that
> allow PHYs used for ethernet to be configured with
> speed, media type and clock information.

This lgtm, Kishon ?

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
> +
> +static inline int phy_set_speed(struct phy *phy, int speed)
> +{
> +	if (!phy)
> +		return 0;
> +	return -ENOSYS;
> +}
> +
>  static inline enum phy_mode phy_get_mode(struct phy *phy)
>  {
>  	return PHY_MODE_INVALID;
> -- 
> 2.30.0

-- 
~Vinod
