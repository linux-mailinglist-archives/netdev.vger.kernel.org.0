Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC7327B554
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 21:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbgI1TeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 15:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbgI1TeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 15:34:04 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F69BC061755;
        Mon, 28 Sep 2020 12:34:04 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9285B144E6D9C;
        Mon, 28 Sep 2020 12:17:15 -0700 (PDT)
Date:   Mon, 28 Sep 2020 12:34:02 -0700 (PDT)
Message-Id: <20200928.123402.281706664300059159.davem@davemloft.net>
To:     weifeng.voon@intel.com
Cc:     mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joabreu@synopsys.com,
        peppe.cavallaro@st.com, andrew@lunn.ch, alexandre.torgue@st.com,
        boon.leong.ong@intel.com, chen.yong.seow@intel.com,
        mgross@linux.intel.com, vee.khee.wong@intel.com
Subject: Re: [PATCH v1 net] net: stmmac: Modify configuration method of EEE
 timers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200928100241.7673-1-weifeng.voon@intel.com>
References: <20200928100241.7673-1-weifeng.voon@intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 28 Sep 2020 12:17:16 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>
Date: Mon, 28 Sep 2020 18:02:41 +0800

> @@ -90,11 +90,12 @@ static const u32 default_msg_level = (NETIF_MSG_DRV | NETIF_MSG_PROBE |
>  				      NETIF_MSG_LINK | NETIF_MSG_IFUP |
>  				      NETIF_MSG_IFDOWN | NETIF_MSG_TIMER);
>  
> -#define STMMAC_DEFAULT_LPI_TIMER	1000
> -static int eee_timer = STMMAC_DEFAULT_LPI_TIMER;
> -module_param(eee_timer, int, 0644);
> -MODULE_PARM_DESC(eee_timer, "LPI tx expiration time in msec");
> -#define STMMAC_LPI_T(x) (jiffies + msecs_to_jiffies(x))
> +#define STMMAC_DEFAULT_LPI_TIMER	1000000
> +#define STMMAC_LPI_T(x)	(jiffies + usecs_to_jiffies(x))
> +
> +static int tw_timer = STMMAC_DEFAULT_TWT_LS;
> +module_param(tw_timer, int, 0644);
> +MODULE_PARM_DESC(tw_timer, "LPI TW timer value in msec");

This is a great example of one of the many reasons why we disallow
module parameters in networking drivers.

This is a user facing value, and now you changed the name which breaks
things for anyone who was accessing this module parameter previously.

You have to find a way to specify this value using existing kernel
infrastructure such as ethtool or devlink, and not using a module
parameter.

So please get rid of this module parameter, and add a way to set this
value portably.
