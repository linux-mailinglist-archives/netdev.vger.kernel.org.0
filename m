Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56CE44EECF5
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 14:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239807AbiDAMQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 08:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233311AbiDAMQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 08:16:36 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0EE48324;
        Fri,  1 Apr 2022 05:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=1a08m7oCoTyT3vyebCtJrAAbyoaDY0BfUc5X7KZ+S6Y=; b=PgIb6SmNQZkBQNTjnLbSzEwvLj
        glBM954zE+h6fjwoY+Fjz3HlLAKNbUF3XgBISA2yQXEiBOr+W16eyEwr1b1NDtAecFSiagVZ0zlyh
        Ccabi4/XSwEnJeHEXgb9vePRH/2c6e40JU0QcOOZt2FBIprAplcqnjKKD1w0yL/qWLaU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1naGAn-00DfLD-5a; Fri, 01 Apr 2022 14:14:37 +0200
Date:   Fri, 1 Apr 2022 14:14:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "huangguangbin (A)" <huangguangbin2@huawei.com>,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com,
        chenhao288@hisilicon.com
Subject: Re: [PATCH] net: phy: genphy_loopback: fix loopback failed when
 speed is unknown
Message-ID: <YkbsraBQ5ynYG9wz@lunn.ch>
References: <20220331114819.14929-1-huangguangbin2@huawei.com>
 <YkWdTpCsO8JhiSaT@lunn.ch>
 <130bb780-0dc1-3819-8f6d-f2daf4d9ece9@huawei.com>
 <YkW6J9rM6O/cb/lv@lunn.ch>
 <20220401064006.GB4449@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220401064006.GB4449@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > O.K. So it should be set into 10M half duplex. But why does this cause
> > it not to loopback packets? Does the PHY you are using not actually
> > support 10 Half? Why does it need to be the same speed as when the
> > link was up? And why does it actually set LSTATUS indicating there is
> > link?
> > 
> > Is this a generic problem, all PHYs are like this, or is this specific
> > to the PHY you are using? Maybe this PHY needs its own loopback
> > function because it does something odd?
> 
> It looks for me like attempt to fix loopback test for setup without active
> link partner. Correct?

You should not need a link partner for loopback to work. This is local
loopback. The PHY is also saying it has link, if the LSTATUS bit is
set. So i don't see why previous speed is relevant hear. This seems to
me to be an issue for this particular PHY.

What i don't like about this patch is that it is not deterministic
what mode the PHY will end up in if speed is unknown. Without the
patch, it is 10Mbps, which is historically a sensible default.

If this PHY has never had link, what speed does it use? Does it still
work in that case?

   Andrew
