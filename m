Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0CFD62917B
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 06:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbiKOF11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 00:27:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbiKOF1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 00:27:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F47E1DF37;
        Mon, 14 Nov 2022 21:27:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC33E6153E;
        Tue, 15 Nov 2022 05:27:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B98DC433C1;
        Tue, 15 Nov 2022 05:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668490040;
        bh=zzu6O/zFTk5RGTsVCUeXcXFKvUuYcR2uq3r53gJiyqU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KighZU/1R+wzmmWGJdz2jgpfCMfgOr2MLLyTJwZCRuCMuMvzCUO51vroNvSsWzkfO
         6RgGDqKffO9JgZ5DcE72gUydodzxYTXaGL0s2rUeMrLLpJ2fslVcQAM/2+N3WeThdP
         tXZRfp02gHF9AXNEUKqSK2CAik2mbLRlQ9JeqSuvY3kLYIdleJTsYV2cm+lTWrszsR
         ILBZM6JUppAPWe2euwWaAQoBzu8ZKN3s1vx02ZUD5lwgSbpdPuWyWsqeB56SnCDcSU
         yTMIit8RIOKQFNku+fltLhxvQSM3VJfNUQnlul4mrUyKQTQDge3kxtbOPPppSAO4tO
         ZrCb0gncJ6d0A==
Date:   Mon, 14 Nov 2022 21:27:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Petr Machata <petrm@nvidia.com>,
        Hao Chen <chenhao288@hisilicon.com>,
        Amit Cohen <amcohen@nvidia.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>,
        linux-kernel@vger.kernel.org,
        Leon Romanovsky <leonro@mellanox.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH net-next v3] ethtool: doc: clarify what drivers can
 implement in their get_drvinfo()
Message-ID: <20221114212718.76bd6c8b@kernel.org>
In-Reply-To: <20221113083404.86983-1-mailhol.vincent@wanadoo.fr>
References: <20221111030838.1059-1-mailhol.vincent@wanadoo.fr>
        <20221113083404.86983-1-mailhol.vincent@wanadoo.fr>
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

On Sun, 13 Nov 2022 17:34:04 +0900 Vincent Mailhol wrote:
> - * Drivers should set at most @driver, @version, @fw_version and
> - * @bus_info in their get_drvinfo() implementation.  The ethtool
> - * core fills in the other fields using other driver operations.
> + * Drivers should set at most @fw_version and @erom_version in their
> + * get_drvinfo() implementation. The ethtool core fills in the other
> + * fields using other driver operations.

Can I still nit pick the working on v3? :)

Almost half of the fields are not filled in by other operations, 
so how about we cut deeper? Even @erom_version is only filled in by 
a single driver, and pretty much deprecated (devlink is much more
flexible for all FW version reporting and flashing).

How about:

 * Majority of the drivers should no longer implement this callback.
 * Most fields are correctly filled in by the core using system
 * information, or populated using other driver operations.
