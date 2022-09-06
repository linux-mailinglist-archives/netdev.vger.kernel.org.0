Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACB785AEF5B
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 17:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbiIFPun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 11:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234565AbiIFPuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 11:50:12 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE0FB78;
        Tue,  6 Sep 2022 08:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=QaoYaOYiVqm1O98wufvIivoefKadxL6DCZZ1oXS1h+Y=; b=j6bQds7LneyID5LjmWKC0/2o0c
        ilQKte7uNHk1ZKBSrvzZgtybjN6EplxD3yaICEnNkkLJrCp+JW0AbJU1wyxbe1b+37T+HRaUN1fmo
        FSPQ3PMKv4VyipjpZJwVSdsVF/wRCeqTBFyZVNzn0nDhe5se7ncepxhDwuGrY6PviZoo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oVZm8-00FlBf-JH; Tue, 06 Sep 2022 16:42:04 +0200
Date:   Tue, 6 Sep 2022 16:42:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     wei.fang@nxp.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: fec: add pm runtime force suspend and
 resume support
Message-ID: <YxdcPJNgM+txE+8A@lunn.ch>
References: <20220906083923.3074354-1-wei.fang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906083923.3074354-1-wei.fang@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 06, 2022 at 04:39:23PM +0800, wei.fang@nxp.com wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> Force mii bus into runtime pm suspend state during device suspends,
> since phydev state is already PHY_HALTED, and there is no need to
> access mii bus during device suspend state. Then force mii bus into
> runtime pm resume state when device resumes.

Have you tested this with an Ethernet switch hanging off the MDIO bus?
It has a life cycle of its own, and i'm not sure it is guaranteed that
the switch is suspended before the FEC. That is why the MDIO
read/write functions have there own runtime PM calls, they can be used
when the interface itself is down.

     Andrew
