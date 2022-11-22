Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9568634298
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 18:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbiKVRh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 12:37:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232660AbiKVRh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 12:37:27 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124BCCE21
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 09:37:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=s4eVEJfa9e9D44eN3sQTfGKD7EQdMeOhGNK6gy8x7II=; b=WnZv7VnbtwXhVCZNaLciFFKJgg
        P0lm+rR8famTT9vdoS2xmi4nNyqQ1KSMivUmwZ3HN8gjQs+7wcD81L/rKbglGG6udYm0iL3ppgYKE
        JVSyKNHB10e3WkSwOM9Cg49lRs+mIcGLG0iskoeRHR/xti6U/X2YkCIyDw9/ctNwKqnk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oxXCz-0038sn-5c; Tue, 22 Nov 2022 18:37:21 +0100
Date:   Tue, 22 Nov 2022 18:37:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc:     netdev@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v2] net/ethtool/ioctl: ensure that we have phy ops before
 using them
Message-ID: <Y30I0d6Dd+s9Ak0W@lunn.ch>
References: <20221122072143.53841-1-d-tatianin@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122072143.53841-1-d-tatianin@yandex-team.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 10:21:43AM +0300, Daniil Tatianin wrote:
> ops->get_ethtool_phy_stats was getting called in an else branch
> of ethtool_get_phy_stats() unconditionally without making sure
> it was actually present.
> 
> Refactor the checks to avoid unnecessary nesting and make them more
> readable. Add an extra WARN_ON_ONCE(1) to emit a warning when a driver
> declares that it has phy stats without a way to retrieve them.

So i have two different suggestions here, take your pick and even
merge them together.

I wonder if we can simply this some more. If there are 0 stats we
already issue a WARN_ON_ONCE():

https://elixir.bootlin.com/linux/v6.1-rc6/source/net/ethtool/ioctl.c#L2096

We will then copy back to user space the ethtool_stats and zero
statistics and return 0. If that useful? Would it make more sense to
just return -EOPNOTSUPP after the WARN_ON_ONCE()?

That would be patch 1/X.

Patch 2/X would then remove the if (n_stats) code, but otherwise make
no changes. That keeps the patch simple to review.

Patch 3/X would then add the additional verification of
ops->get_ethtool_phy_stats(). But do it at the top of the function,
along with all the other verification, and return -EOPNOTSUPP.

Alternatively, given the complexity of the checking and the function
as a whole, i'm wondering if it make sense to actually pull this
function apart. Add a ethtool_get_phy_stats_phydev() and
ethtool_get_phy_stats_ethtool(), and have ethtool_get_phy_stats() do
the copy_from_user(), call one of the two helpers, and if they don't
return an error do the two copy_to_user().

       Andrew
