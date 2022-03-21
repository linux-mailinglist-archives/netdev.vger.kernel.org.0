Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10FA24E2566
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 12:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346173AbiCULrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 07:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241385AbiCULrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 07:47:39 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2202A113D08;
        Mon, 21 Mar 2022 04:46:14 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 50BC922175;
        Mon, 21 Mar 2022 12:46:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1647863172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MSx72V2HVU0T6x8Ncw4K7usjjkuwRvg2WkOZN5WtPJ0=;
        b=CEBozyWuRUie8ZKxpYfIvNQHo0IhGpO9L+9zh48kIO4VJAztR87wLxiTpDDadvTIZXz+Gr
        5YYTfnJ/5ErPRtGO40ZsYJu6Syufl48HluQFtQ48ylI9KT6M4a+PCpy92syuSpsDY1+7Ut
        0U9KUaEQy0gxPZXGw2fgazL6kDpebn0=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 21 Mar 2022 12:46:12 +0100
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Clause 45 and Clause 22 PHYs on one MDIO bus
In-Reply-To: <240354b0a54b37e8b5764773711b8aa3@walle.cc>
References: <240354b0a54b37e8b5764773711b8aa3@walle.cc>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <cdb3d3f6ad35d4e26fd8abb23b2e96a3@walle.cc>
X-Sender: michael@walle.cc
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-03-21 12:21, schrieb Michael Walle:
> Hi,
> 
> I have a board with a c22 phy (microchip lan8814) and a c45 phy
> (intel/maxlinear gyp215) on one bus. If I understand it correctly, both
> accesses should be able to coexist on one bus. But the microchip 
> lan8814
> actually has a bug and gets confused by c45 accesses. For example it 
> will
> respond in the middle of another transaction with its own data if it
> decodes it as a read. That is something we can see on a logic analyzer.
> But we also see random register writes on the lan8814 (which you don't 
> see
> on the logic analyzer obviously). Fortunately, the GPY215 supports 
> indirect
> MMD access by the standard c22 registers. Thus as a workaround for the
> problem, we could have a c22 only mdio bus.
> 
> The SoC I'm using is the LAN9668, which uses the mdio-mscc-mdio driver.
> First problem there, it doesn't support C45 (yet) but also doesn't 
> check
> for MII_ADDR_C45 and happily reads/writes bogus registers.
> 
> I've looked at the mdio subsystem in linux, there is probe_capabilities
> (MDIOBUS_C45 and friends) but the mxl-gpy.c is using c45 accesses
> nevertheless. I'm not sure if this is a bug or not.
> 
> I was thinking of a fallback mechanism for the c45 read access like
> in read_mmd. And even if the mdio controller is c45 capable, a PHY
> might opt out. In my case, the lan8814.

Actually, it looks like mdiobus_c45_read() is really c45 only and only
used for PHYs which just support c45 and not c45-over-c22 (?). I was
mistaken by the heavy use of the function in phy_device.c. All the
methods in phy-c45.c use phy_*_mmd() functions. Thus it might only be
the mxl-gpy doing something fishy in its probe function. (And I'm
unsure about get_phy_c45_ids()).

Nevertheless, I'd still need the opt-out of any c45 access. Otherwise,
if someone will ever implement c45 support for the mdio-mscc-mdio
driver, I'll run in the erratic behavior.

-michael
