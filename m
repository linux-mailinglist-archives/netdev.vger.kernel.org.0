Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A39E41C19F3
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 17:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729639AbgEAPoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 11:44:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36546 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728495AbgEAPoz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 11:44:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zq53wD1ebttWy9Fs+bAkUBp+KMkAbk1gvP4L0POpNiA=; b=g9Y63QfCt8YuvaP45/GWgzLNj8
        no//b6ULwxrn4pBY9MHOk89RSiunJY/l98hVSjVfsLNrIuLgM/KQfMzLn1fYX+lQW0qRLzMOvy1Ta
        lFnR3/T4p7PWi6B/VbYak39g5tqWm4oIXxzQB5PjCtHV+QNLsdO/I3HQoav+YkAlNQd4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jUXqK-000YMy-7n; Fri, 01 May 2020 17:44:48 +0200
Date:   Fri, 1 May 2020 17:44:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     robh+dt@kernel.org, f.fainelli@gmail.com,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        jianxin.pan@amlogic.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RFC v2 08/11] net: stmmac: dwmac-meson8b: add support for
 the RX delay configuration
Message-ID: <20200501154448.GH128733@lunn.ch>
References: <20200429201644.1144546-1-martin.blumenstingl@googlemail.com>
 <20200429201644.1144546-9-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429201644.1144546-9-martin.blumenstingl@googlemail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	if (rx_dly_config & PRG_ETH0_ADJ_ENABLE) {
> +		/* The timing adjustment logic is driven by a separate clock */
> +		ret = meson8b_devm_clk_prepare_enable(dwmac,
> +						      dwmac->timing_adj_clk);
> +		if (ret) {
> +			dev_err(dwmac->dev,
> +				"Failed to enable the timing-adjustment clock\n");
> +			return ret;
> +		}
> +	}

Hi Martin

It is a while since i used the clk API. I thought the get_optional()
call returned a NULL pointer if the clock does not exist.
clk_prepare_enable() passed a NULL pointer is a NOP, but it also does
not return an error. So if the clock does not exist, you won't get
this error, the code keeps going, configures the hardware, but it does
not work.

I think you need to check dwmac->timing_adj_clk != NULL here, and
error out if DT has properties which require it.

      Andrew
