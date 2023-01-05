Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 616A565E71D
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 09:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbjAEIza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 03:55:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbjAEIzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 03:55:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844DC395EB;
        Thu,  5 Jan 2023 00:55:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7646561912;
        Thu,  5 Jan 2023 08:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5001CC433EF;
        Thu,  5 Jan 2023 08:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672908918;
        bh=qFhnm17Gb688TaduxHaHJISkIUd0KIcIGpXe2ATD8ys=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TchCyc1KrjVfN4RqhAaAo5PE2RtHafbaWMP0Abcfht9ZvhERBLFydm5aCn8ssDfCz
         8hmKxxSl7Pci66dNfgXNjg5ATm1Ro1JB1l/ava/Vr10YESaCbMHiioF4vBuvYBt4QG
         w2417kIjV3BkmX2h6lSqeXd8KbPwm5vk6ZFvkxXlAg0p4CchTw0kY8v2NiMdsBCbEq
         DI99lqwn+SXzLr8+ld+AVkeLnvfixyAQt3nQmx3t6aCVhggZHhXiL3LCJ4QgFgj68b
         58mfzOxBaJG9rCPLydsJ5s8/6IQihT+snwetyF+fR1n6SFmd0UNxV1oG32pB108q+J
         HOuGuBiBRLBTg==
Date:   Thu, 5 Jan 2023 10:55:14 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next 1/5] net/ethtool: add netlink interface for the
 PLCA RS
Message-ID: <Y7aQcgR4C9Lg/+yK@unreal>
References: <cover.1672840325.git.piergiorgio.beruto@gmail.com>
 <76d0a77273e4b4e7c1d22a897c4af9109a8edc51.1672840325.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76d0a77273e4b4e7c1d22a897c4af9109a8edc51.1672840325.git.piergiorgio.beruto@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 03:05:44PM +0100, Piergiorgio Beruto wrote:
> Add support for configuring the PLCA Reconciliation Sublayer on
> multi-drop PHYs that support IEEE802.3cg-2019 Clause 148 (e.g.,
> 10BASE-T1S). This patch adds the appropriate netlink interface
> to ethtool.
> 
> Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
> ---
>  Documentation/networking/ethtool-netlink.rst | 138 ++++++++++
>  MAINTAINERS                                  |   6 +
>  include/linux/ethtool.h                      |  12 +
>  include/linux/phy.h                          |  57 ++++
>  include/uapi/linux/ethtool_netlink.h         |  25 ++
>  net/ethtool/Makefile                         |   2 +-
>  net/ethtool/netlink.c                        |  29 ++
>  net/ethtool/netlink.h                        |   6 +
>  net/ethtool/plca.c                           | 276 +++++++++++++++++++
>  9 files changed, 550 insertions(+), 1 deletion(-)
>  create mode 100644 net/ethtool/plca.c

<...>

> --- /dev/null
> +++ b/net/ethtool/plca.c
> @@ -0,0 +1,276 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include <linux/phy.h>
> +#include <linux/ethtool_netlink.h>
> +
> +#include "netlink.h"
> +#include "common.h"
> +
> +struct plca_req_info {
> +	struct ethnl_req_info		base;
> +};
> +
> +struct plca_reply_data {
> +	struct ethnl_reply_data		base;
> +	struct phy_plca_cfg		plca_cfg;
> +	struct phy_plca_status		plca_st;
> +};
> +
> +// Helpers ------------------------------------------------------------------ //
> +
> +#define PLCA_REPDATA(__reply_base) \
> +	container_of(__reply_base, struct plca_reply_data, base)
> +
> +static inline void plca_update_sint(int *dst, const struct nlattr *attr,
> +				    bool *mod)

No inline function in *.c files.

> +{
> +	if (attr) {
> +		*dst = nla_get_u32(attr);
> +		*mod = true;
> +	}

Success oriented approach, please
if (!attr)
  return;

> +}
> +
> +// PLCA get configuration message ------------------------------------------- //
> +
> +const struct nla_policy ethnl_plca_get_cfg_policy[] = {
> +	[ETHTOOL_A_PLCA_HEADER]		=
> +		NLA_POLICY_NESTED(ethnl_header_policy),
> +};
> +
> +static int plca_get_cfg_prepare_data(const struct ethnl_req_info *req_base,
> +				     struct ethnl_reply_data *reply_base,
> +				     struct genl_info *info)
> +{
> +	struct plca_reply_data *data = PLCA_REPDATA(reply_base);
> +	struct net_device *dev = reply_base->dev;
> +	const struct ethtool_phy_ops *ops;
> +	int ret;
> +
> +	// check that the PHY device is available and connected
> +	if (!dev->phydev) {
> +		ret = -EOPNOTSUPP;
> +		goto out;
> +	}
> +
> +	// note: rtnl_lock is held already by ethnl_default_doit
> +	ops = ethtool_phy_ops;
> +	if (!ops || !ops->get_plca_cfg) {
> +		ret = -EOPNOTSUPP;
> +		goto out;
> +	}
> +
> +	ret = ethnl_ops_begin(dev);
> +	if (ret < 0)
> +		goto out;

I see that many places in the code used this ret > 0 check, but it looks
like the right check is if (ret).

Thanks
