Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17FAB281505
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 16:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388030AbgJBOYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 10:24:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40364 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbgJBOYy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 10:24:54 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kOLzQ-00HE7x-N2; Fri, 02 Oct 2020 16:24:52 +0200
Date:   Fri, 2 Oct 2020 16:24:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v2 net-next 3/3] net: atlantic: implement media detect
 feature via phy tunables
Message-ID: <20201002142452.GD3996795@lunn.ch>
References: <20201002133923.1677-1-irusskikh@marvell.com>
 <20201002133923.1677-4-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002133923.1677-4-irusskikh@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	if (val > 0 && val != AQ_HW_MEDIA_DETECT_CNT) {
> +		netdev_err(self->ndev, "EDPD on this device could have only fixed value of %d\n",
> +			   AQ_HW_MEDIA_DETECT_CNT);
> +		return -EINVAL;
> +	}
> +
> +	/* msecs plays no role - configuration is always fixed in PHY */
> +	cfg->is_media_detect = val ? 1 : 0;
> +
> +	mutex_lock(&self->fwreq_mutex);
> +	err = self->aq_fw_ops->set_media_detect(self->aq_hw, cfg->is_media_detect);
> +	mutex_unlock(&self->fwreq_mutex);
> +
> +	return err;
> +}

> +static int aq_fw2x_set_media_detect(struct aq_hw_s *self, bool on)
> +{
> +	u32 enable;
> +	u32 offset;
> +
> +	if (self->fw_ver_actual < HW_ATL_FW_VER_MEDIA_CONTROL)
> +		return -EOPNOTSUPP;

So if the firmware is tool old, you return -EOPNOTSUPP. But it appears
cfg->is_media_detect has already been changed?

     Andrew
