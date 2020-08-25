Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F69251D46
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 18:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgHYQgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 12:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbgHYQgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 12:36:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192B7C061574;
        Tue, 25 Aug 2020 09:36:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 64AE2134A0E3F;
        Tue, 25 Aug 2020 09:19:18 -0700 (PDT)
Date:   Tue, 25 Aug 2020 09:36:03 -0700 (PDT)
Message-Id: <20200825.093603.2026695844604591106.davem@davemloft.net>
To:     m-karicheri2@ti.com
Cc:     kuba@kernel.org, grygorii.strashko@ti.com, nsekhar@ti.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net v3 PATCH] net: ethernet: ti: cpsw_new: fix error handling
 in cpsw_ndo_vlan_rx_kill_vid()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200824170100.21319-1-m-karicheri2@ti.com>
References: <20200824170100.21319-1-m-karicheri2@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Aug 2020 09:19:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Murali Karicheri <m-karicheri2@ti.com>
Date: Mon, 24 Aug 2020 13:01:00 -0400

> +	ret = cpsw_ale_del_vlan(cpsw->ale, vid, 0);
> +	if (ret)
> +		dev_err(priv->dev, "%s: failed %d: ret %d\n",
> +			__func__, __LINE__, ret);
> +	ret = cpsw_ale_del_ucast(cpsw->ale, priv->mac_addr,
> +				 HOST_PORT_NUM, ALE_VLAN, vid);
> +	if (ret)
> +		dev_err(priv->dev, "%s: failed %d: ret %d\n",
> +			__func__, __LINE__, ret);
> +	ret = cpsw_ale_del_mcast(cpsw->ale, priv->ndev->broadcast,
> +				 0, ALE_VLAN, vid);
> +	if (ret)
> +		dev_err(priv->dev, "%s: failed %d: ret %d\n",
> +			__func__, __LINE__, ret);
>  	cpsw_ale_flush_multicast(cpsw->ale, ALE_PORT_HOST, vid);

These error messages are extremely unhelpful.  You're calling three
different functions, yet emitting basically the same __func__ for
each of those cases.  No user can send you a useful bug report
immediately if they just have func and line.

Please get rid of the "__func__" and "__line__" stuff completely, it's
never advisable to ever use that in my opinion.  Instead, describe
which delete operation failed, optionally with the error return.

