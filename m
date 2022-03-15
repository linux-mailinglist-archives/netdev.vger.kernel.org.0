Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A26874D9387
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 06:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239384AbiCOFJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 01:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233028AbiCOFJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 01:09:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92B3645E;
        Mon, 14 Mar 2022 22:07:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47B42B809D2;
        Tue, 15 Mar 2022 05:07:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B688EC340E8;
        Tue, 15 Mar 2022 05:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647320868;
        bh=rMie03k3BO34+o88YfxYoeUy5yYs6o8Z5WGNRtUX6zQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LgbWhMGnAqnil1zn+wUVOxqV+vQT2YuSWf9hCWbiQE8BqXfdYu99mVb/BSdgxc7Ix
         ig6vimVdeuhTIpExLx9DZ++1UdztPhREqVI9HvhjdDgJQazmcDOyc5Hpm17Jj5NP4F
         VGChJMVL3MxFyxqtQuwbx5hE0yTZ9CmNxImdyuPLV72pusqfW7oPlwtu6sm8h7kHe2
         kwNvfzFcJN1hXIvNP7cA+krgydwPMx9O07lbvtiwZgroBhFG5N1G0DqNJHOcxp5UEN
         gvyVO7RxrPnMmeyP2frlcgU0grAe3L62FKV79X9FKtpQdjPAmo/wEkFFMgsdanTqNb
         hrkjV3i3fnjeQ==
Date:   Mon, 14 Mar 2022 22:07:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next] net: sfp: add 2500base-X quirk for Lantech SFP
 module
Message-ID: <20220314220746.561b1da8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220312205014.4154907-1-michael@walle.cc>
References: <20220312205014.4154907-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 12 Mar 2022 21:50:14 +0100 Michael Walle wrote:
> The Lantech 8330-262D-E module is 2500base-X capable, but it reports the
> nominal bitrate as 2500MBd instead of 3125MBd. Add a quirk for the
> module.
> 
> The following in an EEPROM dump of such a SFP with the serial number
> redacted:
> 
> 00: 03 04 07 00 00 00 01 20 40 0c 05 01 19 00 00 00    ???...? @????...
> 10: 1e 0f 00 00 4c 61 6e 74 65 63 68 20 20 20 20 20    ??..Lantech
> 20: 20 20 20 20 00 00 00 00 38 33 33 30 2d 32 36 32        ....8330-262
> 30: 44 2d 45 20 20 20 20 20 56 31 2e 30 03 52 00 cb    D-E     V1.0?R.?
> 40: 00 1a 00 00 46 43 XX XX XX XX XX XX XX XX XX XX    .?..FCXXXXXXXXXX
> 50: 20 20 20 20 32 32 30 32 31 34 20 20 68 b0 01 98        220214  h???
> 60: 45 58 54 52 45 4d 45 4c 59 20 43 4f 4d 50 41 54    EXTREMELY COMPAT
> 70: 49 42 4c 45 20 20 20 20 20 20 20 20 20 20 20 20    IBLE

Any idea what the "Extremely Compatible" is referring to? :-D

> Signed-off-by: Michael Walle <michael@walle.cc>

A quirk like this seems safe to apply to net and 5.17, still.
Would you prefer that or net-next as marked?
