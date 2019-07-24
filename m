Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 671AD740EB
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 23:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729029AbfGXViL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 17:38:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52214 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbfGXViL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 17:38:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C55EF1543AEF2;
        Wed, 24 Jul 2019 14:38:10 -0700 (PDT)
Date:   Wed, 24 Jul 2019 14:38:10 -0700 (PDT)
Message-Id: <20190724.143810.1816867139082751607.davem@davemloft.net>
To:     asolokha@kb.kras.ru
Cc:     claudiu.manoil@nxp.com, ioana.ciornei@nxp.com,
        linux@armlinux.org.uk, andrew@lunn.ch, netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: phylink: don't start and stop SGMII PHYs in
 SFP modules twice
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190724133139.8356-1-asolokha@kb.kras.ru>
References: <20190724090139.GG1330@shell.armlinux.org.uk>
        <20190724133139.8356-1-asolokha@kb.kras.ru>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jul 2019 14:38:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arseny Solokha <asolokha@kb.kras.ru>
Date: Wed, 24 Jul 2019 20:31:39 +0700

> SFP modules connected using the SGMII interface have their own PHYs which
> are handled by the struct phylink's phydev field. On the other hand, for
> the modules connected using 1000Base-X interface that field is not set.
> 
> Since commit ce0aa27ff3f6 ("sfp: add sfp-bus to bridge between network
> devices and sfp cages") phylink_start() ends up setting the phydev field
> using the sfp-bus infrastructure, which eventually calls phy_start() on it,
> and then calling phy_start() again on the same phydev from phylink_start()
> itself. Similar call sequence holds for phylink_stop(), only in the reverse
> order. This results in WARNs during network interface bringup and shutdown
> when a copper SFP module is connected, as phy_start() and phy_stop() are
> called twice in a row for the same phy_device:
 ...
> SFP modules with the 1000Base-X interface are not affected.
> 
> Place explicit calls to phy_start() and phy_stop() before enabling or after
> disabling an attached SFP module, where phydev is not yet set (or is
> already unset), so they will be made only from the inside of sfp-bus, if
> needed.
> 
> Signed-off-by: Arseny Solokha <asolokha@kb.kras.ru>

Applied with appropriate Fixes: tag added and queued up for -stable.

Thanks.
