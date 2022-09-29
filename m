Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 455755EF73B
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 16:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235550AbiI2OMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 10:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235596AbiI2OMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 10:12:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4BC1684F2
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 07:12:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACCBB61482
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 14:12:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF056C433C1;
        Thu, 29 Sep 2022 14:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664460731;
        bh=nVQQMfndFpNhOEf3IU2aC4m3m852txkEqCypF8B9bm8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Zixk6t5XcuXGy4+DNCm/9z4Z2RsSvGAaUA2DFUT9kJLL0s8aKBadoymg3rFrX5stD
         oIUSY/k6wqwUS6gYBTKQncEHPqNmbU9r+DVZLzd0kNCn96GoaxyW3nqH98QC+earx5
         QZhThEV/oCmdTnMme2ZYTq14qpR54YkZIO9oKfg8eJeB0LURtC9E3FCYSWXU6ec9Gt
         NWn1eImwm6TZ+R0WmfNgaOfQVoO+nYz7g4HFfBvqNa1xxBRGljVqCraa2MhDlb7e8r
         7svaYM4R3zZyC9gnS3RzGwEK4FY+xylZ/nKZfBaMpDQp6kGixPQcZ/b8A0TwXBZqC8
         jmIN4JZrcaf0w==
Date:   Thu, 29 Sep 2022 07:12:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jiri Pirko <jiri@resnulli.us>, Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Subject: Re: PHY firmware update method
Message-ID: <20220929071209.77b9d6ce@kernel.org>
In-Reply-To: <YzWPXcf8kXrd73PC@lunn.ch>
References: <bf53b9b3660f992d53fe8d68ea29124a@walle.cc>
        <YzQ96z73MneBIfvZ@lunn.ch>
        <YzVDZ4qrBnANEUpm@nanopsycho>
        <YzWPXcf8kXrd73PC@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Sep 2022 14:28:13 +0200 Andrew Lunn wrote:
> If we want to make the PHY a component of an existing devlink for a
> MAC, we somehow have to find that devlink instance. A PHY is probably
> a property of a port, so we can call netdev_to_devlink_port(), which
> gives us a way into devlink.
> 
> However, the majority of MAC drivers don't have a devlink
> instance. What do we do then? Have phylib create the devlink instance
> for the MAC driver? That seems very wrong.
> 
> Which is why i was thinking the PHY should have its own devlink
> instance.

Tricky stuff, how would you expose the topology of the system to 
the user? My initial direction would also be component. Although 
it may be weird if MAC has a way to flash "all" components in one go,
and that did not flash the PHY :S

Either way I don't think we can avoid MACs having a devlink instance
because there needs to be some form of topology formed.
