Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C32163CD77
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 03:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbiK3Cjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 21:39:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiK3Cjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 21:39:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E91286A74D
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 18:39:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A60B9B819D2
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 02:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0657AC433C1;
        Wed, 30 Nov 2022 02:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669775983;
        bh=UEbFQouLpFCPg1Q6yY6nVrh9wWd/PAcOpdPYFlhTfQ4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GBRWxPMN/lxxuuEcBPAlMjay/uD7ZS0OW/C9SOcR9HBDTBcb0OA1N3EZqi5JBZg1m
         /qr2ng00NyYP1qpzex58V8ZJND5QULudo0YL5I6ASGF4rO+iBda1L7CnPIv74+UKI6
         P6n6mHl1KrRAwUTzOjoDw3hNaZ2dBnYkSzmz7xpjad9gBOdMGkr6KpnjMHsN7PX2ir
         6seR3ReU/onBIV6KaaKMqDaWGiUkSQf/YuvrBZD/KBMWUdyFEZWpI8tcGnYSsPbgvA
         9IxZDxSl2WIhMe35SLHQX8rMEb0PuJMQgNceoW7r7fMnWCIqEjLgYdcLgXhbxQm+wM
         dr4soeuxWvVqw==
Date:   Tue, 29 Nov 2022 18:39:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Daniil Tatianin <d-tatianin@yandex-team.ru>,
        netdev@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>,
        yc-core@yandex-team.ru, lvc-project@linuxtesting.org
Subject: Re: [PATCH v2 3/3] net/ethtool/ioctl: split ethtool_get_phy_stats
 into multiple helpers
Message-ID: <20221129183938.496850f7@kicinski-fedora-PC1C0HJN>
In-Reply-To: <Y4ai4tCT48r/ktbO@lunn.ch>
References: <20221129103801.498149-1-d-tatianin@yandex-team.ru>
        <20221129103801.498149-4-d-tatianin@yandex-team.ru>
        <Y4ai4tCT48r/ktbO@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Nov 2022 01:25:06 +0100 Andrew Lunn wrote:
> On Tue, Nov 29, 2022 at 01:38:01PM +0300, Daniil Tatianin wrote:
> > So that it's easier to follow and make sense of the branching and
> > various conditions.
> > 
> > Stats retrieval has been split into two separate functions
> > ethtool_get_phy_stats_phydev & ethtool_get_phy_stats_ethtool.
> > The former attempts to retrieve the stats using phydev & phy_ops, while
> > the latter uses ethtool_ops.
> > 
> > Actual n_stats validation & array allocation has been moved into a new
> > ethtool_vzalloc_stats_array helper.
> > 
> > This also fixes a potential NULL dereference of
> > ops->get_ethtool_phy_stats where it was getting called in an else branch
> > unconditionally without making sure it was actually present.
> > 
> > Found by Linux Verification Center (linuxtesting.org) with the SVACE
> > static analysis tool.
> > 
> > Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>  
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

FWIW the patches did not hit the list, once again :/
