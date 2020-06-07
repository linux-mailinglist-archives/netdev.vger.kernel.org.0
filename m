Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E49761F0CBE
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 18:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgFGQDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 12:03:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38688 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726643AbgFGQDE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Jun 2020 12:03:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pcK/CyVIe4/jFt3oswwPpTZAtyg8GPe7ijGGyVhZFwU=; b=sxzx5lfV1d2poe0WFc1ZS45OoH
        Ylrh2V96ba/V30yNbCVD5tt4gIOKxbw8NZw5CV6rWQuOpPVDG39S3CtjLDYU2LCdkNsfF0xp/RY2x
        raX7riscb4wVh68AKIVl9+CXtPHEnmjpv1XfLrtUcEThnCMpNYa63ajs6RHvFDSpAtkg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jhxl0-004LWr-I0; Sun, 07 Jun 2020 18:02:46 +0200
Date:   Sun, 7 Jun 2020 18:02:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Amit Cohen <amitc@mellanox.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        corbet@lwn.net, jiri@mellanox.com, idosch@mellanox.com,
        shuah@kernel.org, mkubecek@suse.cz, gustavo@embeddedor.com,
        cforno12@linux.vnet.ibm.com, f.fainelli@gmail.com,
        linux@rempel-privat.de, alexandru.ardelean@analog.com,
        ayal@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        liuhangbin@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH net-next 04/10] ethtool: Add link extended state
Message-ID: <20200607160246.GD1022955@lunn.ch>
References: <20200607145945.30559-1-amitc@mellanox.com>
 <20200607145945.30559-5-amitc@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200607145945.30559-5-amitc@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -108,6 +131,12 @@ static int linkstate_reply_size(const struct ethnl_req_info *req_base,
>  	if (data->sqi_max != -EOPNOTSUPP)
>  		len += nla_total_size(sizeof(u32));
>  
> +	if (data->ext_state_provided)
> +		len += sizeof(u8); /* LINKSTATE_EXT_STATE */
> +
> +	if (data->ethtool_ext_state_info.__ext_substate)
> +		len += sizeof(u8); /* LINKSTATE_EXT_SUBSTATE */
> +

This looks wrong. A u8 attribute takes up a lot more space than
sizeof(u8) because of the TLV overheads. That is what the
nla_total_size() is for.

		 Andrew
