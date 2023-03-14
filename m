Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD6BA6B86EA
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 01:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbjCNAan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 20:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbjCNAam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 20:30:42 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DC921285
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 17:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=YLX30jPErehfuhC+8rkRcXJPj5TNXfnEUCfGKVGqGF4=; b=ZkjNe9M1a9RZi0XsDIC6jebHFg
        vlqogmcS8Enw7nLPUaE+W9We/T9k1F9UEiJTF1RNixjELlBMcUF6Kw2sunMcAq/TQRlADxsJlUrDt
        D/n0L9EkV3prZQFhrHvgr/xGiXsiRXYl0dnsCqqti15T7GdXCZaVtLqbUj62fowLk/j8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pbsYl-007FAZ-Ka; Tue, 14 Mar 2023 01:30:35 +0100
Date:   Tue, 14 Mar 2023 01:30:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     netdev@vger.kernel.org, Clark Wang <xiaoning.wang@nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Wei Fang <wei.fang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>, kernel@pengutronix.de,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 2/9] net: fec: Don't return early on error in
 .remove()
Message-ID: <d16568e8-9ec8-4c4b-bbee-9d585c772c4b@lunn.ch>
References: <20230313103653.2753139-1-u.kleine-koenig@pengutronix.de>
 <20230313103653.2753139-3-u.kleine-koenig@pengutronix.de>
 <e84585f2-e3d9-4a87-bfd4-a9ba458553b9@lunn.ch>
 <20230313162141.vkhyz77u44wxq4vn@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313162141.vkhyz77u44wxq4vn@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > -	ret = pm_runtime_resume_and_get(&pdev->dev);
> > > -	if (ret < 0)
> > > -		return ret;
> > regulator_disable() probably does actually work because that is a
> > different hardware block unaffected by the suspend.
 
> fec_suspend() calls
> 
>         if (fep->reg_phy && !(fep->wol_flag & FEC_WOL_FLAG_ENABLE))
>                 regulator_disable(fep->reg_phy);

There are two different types of suspend here.

pm_runtime_resume_and_get() is about runtime suspend. It calls
fec_runtime_suspend() which just turns some clocks off/on.

fec_suspend() is for system sleep, where the whole system is put to
sleep, except what is needed to trigger a wake up, such as Wake on
LAN. The regulator is being used to power the PHY, so you obviously
don't want to turn the PHY off when doing WoL.

But if you are unloading the FEC, WoL is not going to work, so you
should turn the PHY off. And turning the PHY off should not have any
dependencies on first turning on FEC clocks in
pm_runtime_resume_and_get().

    Andrew
