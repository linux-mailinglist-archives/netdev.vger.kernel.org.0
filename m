Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D307058FCEC
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 14:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235502AbiHKM5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 08:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234179AbiHKM5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 08:57:22 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43CB952454;
        Thu, 11 Aug 2022 05:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Y337MJSA/Q1fxg27bDPNlL67w+5ryxHouJMKKVdLkVs=; b=g0XMfQXUAoVD39WhOESUNwXRFc
        PgE9IfThQimRu1Yp7PFuvINko+VOiozYvpMIrQX9S8OIBVgdKYrAzYwDBBQsYMAMzji8swNUo/X2d
        tbDoK+8/sxFnn7cDI/syPDoKNvb9mPYE/LgrpSg6BM//Jk4TAdMjOTjoFWJbQWHX+1qU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oM7kI-00D1sL-C1; Thu, 11 Aug 2022 14:57:06 +0200
Date:   Thu, 11 Aug 2022 14:57:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ravi Gunasekaran <r-gunasekaran@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kishon@ti.com,
        vigneshr@ti.com
Subject: Re: [PATCH v2 net-next] net: ethernet: ti: davinci_mdio: Add
 workaround for errata i2329
Message-ID: <YvT8ovgHz2j7yOQP@lunn.ch>
References: <20220810111345.31200-1-r-gunasekaran@ti.com>
 <YvRNpAdG7/edUEc+@lunn.ch>
 <9d17ab9f-1679-4af1-f85c-a538cb330d7b@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d17ab9f-1679-4af1-f85c-a538cb330d7b@ti.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Devices may or may not be configured for runtime autosuspend, and perhaps
> may not even use runtime PM. pm_runtime_enabled() and the autosuspend
> configuration could be addressed by checking against
> dev->power.use_autosuspend flag. But if the runtime PM functions are added
> to the bit banging core, would it not restrict the usage of
> pm_runtime_put_*() variants for others?

My assumption is, any calls to pm_runtime_* functions will effectively
do nothing if the driver does not have support for it. I could be
wrong about this, and it jumps through a NULL pointer and explodes,
but that would be a bad design.

> There is atleast one device sh_eth, which is not configured for autosuspend
> but uses the bit bang core in sh_mdiobb_read() and invokes regular runtime
> PM functions.

And that is the point of moving it into the core. It would of just
worked for you.

If you don't feel comfortable with making this unconditional, please
put runtime pm enabled version of mdiobb_read/mdiobb_write() in the
core and swap sh_eth and any other drivers to using them.

       Andrew
