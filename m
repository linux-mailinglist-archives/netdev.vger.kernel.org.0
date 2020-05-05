Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 422901C53A6
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 12:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbgEEKuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 06:50:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:50104 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725766AbgEEKup (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 06:50:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 541A0ACF2;
        Tue,  5 May 2020 10:50:46 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 9F35E602B9; Tue,  5 May 2020 12:50:43 +0200 (CEST)
Date:   Tue, 5 May 2020 12:50:43 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>, michael@walle.cc
Subject: Re: [PATCH net-next v2 07/10] net: ethtool: Add helpers for
 reporting test results
Message-ID: <20200505105043.GK8237@lion.mk-sys.cz>
References: <20200505001821.208534-1-andrew@lunn.ch>
 <20200505001821.208534-8-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505001821.208534-8-andrew@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 02:18:18AM +0200, Andrew Lunn wrote:
> The PHY drivers can use these helpers for reporting the results. The
> results get translated into netlink attributes which are added to the
> pre-allocated skbuf.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
[...]
> diff --git a/net/ethtool/cabletest.c b/net/ethtool/cabletest.c
> index 4c888db33ef0..f500454a54eb 100644
> --- a/net/ethtool/cabletest.c
> +++ b/net/ethtool/cabletest.c
> @@ -114,3 +114,50 @@ void ethnl_cable_test_finished(struct phy_device *phydev)
>  	ethnl_multicast(phydev->skb, phydev->attached_dev);
>  }
>  EXPORT_SYMBOL_GPL(ethnl_cable_test_finished);
> +
> +int ethnl_cable_test_result(struct phy_device *phydev, u8 pair, u16 result)

Is there a reason to use u16 for result when the attribute is NLA_U8?

> +{
> +	struct nlattr *nest;
> +	int ret = -EMSGSIZE;
> +
> +	nest = nla_nest_start(phydev->skb, ETHTOOL_A_CABLE_TEST_NTF_RESULT);
> +	if (!nest)
> +		return -EMSGSIZE;
> +
> +	if (nla_put_u8(phydev->skb, ETHTOOL_A_CABLE_RESULT_PAIR, pair))
> +		goto err;
> +	if (nla_put_u8(phydev->skb, ETHTOOL_A_CABLE_RESULT_CODE, result))
> +		goto err;
> +
> +	nla_nest_end(phydev->skb, nest);
> +	return 0;
> +
> +err:
> +	nla_nest_cancel(phydev->skb, nest);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(ethnl_cable_test_result);
> +
> +int ethnl_cable_test_fault_length(struct phy_device *phydev, u8 pair, u32 cm)
> +{
> +	struct nlattr *nest;
> +	int ret = -EMSGSIZE;
> +
> +	nest = nla_nest_start(phydev->skb,
> +			      ETHTOOL_A_CABLE_TEST_NTF_FAULT_LENGTH);
> +	if (!nest)
> +		return -EMSGSIZE;
> +
> +	if (nla_put_u8(phydev->skb, ETHTOOL_A_CABLE_FAULT_LENGTH_PAIR, pair))
> +		goto err;
> +	if (nla_put_u16(phydev->skb, ETHTOOL_A_CABLE_FAULT_LENGTH_CM, cm))
> +		goto err;

This should be nla_put_u32().

Michal

> +
> +	nla_nest_end(phydev->skb, nest);
> +	return 0;
> +
> +err:
> +	nla_nest_cancel(phydev->skb, nest);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(ethnl_cable_test_fault_length);
> -- 
> 2.26.2
> 
