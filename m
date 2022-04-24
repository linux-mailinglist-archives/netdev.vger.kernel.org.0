Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29A8850D271
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 16:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238388AbiDXOzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 10:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbiDXOzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 10:55:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D000337BC8;
        Sun, 24 Apr 2022 07:52:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A60BB80E4A;
        Sun, 24 Apr 2022 14:52:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4BECC385A7;
        Sun, 24 Apr 2022 14:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650811955;
        bh=VrS0Ke+JASD9dwCpktBbdVYtkBgBLsMZ1lrYaYJS8p0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bViU/5daBiG3nNi+NMeZ6PRCZUGkw2A3WoWzVEJK6a120AeuckM3gQPdbIGTrnJ72
         HMcluBSRkIH4Vh5kgyuVKIEvE05JqSHfzSKnSD0GaD2taomlcPy1FqIlgob/5HHBWE
         UgA5CzdF5H8rrKeIA3/AhaCG2O5xG5p+GziL9KobCAR5598aZ8GuEDTJgv/978i33g
         cr/D9svcZB8eMXgZQdRgCoCouLjIvJzj6F5z3C/pEKWMo22dFTxVrWoOfXOF+Mc2/M
         qx3FxCXfdOrMngoppEedD4jcxgM1deqQMya+dwDgtwbQnksCMVM8z5lhYGH4dpYYoZ
         AVK7fRzZLVjIw==
Date:   Sun, 24 Apr 2022 16:52:28 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Nathan Rossi <nathan@nathanrossi.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] net: dsa: mv88e6xxx: Fix port_hidden_wait to account
 for port_base_addr
Message-ID: <20220424165228.4030aea6@thinkpad>
In-Reply-To: <20220424141759.315303-1-nathan@nathanrossi.com>
References: <20220424141759.315303-1-nathan@nathanrossi.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 24 Apr 2022 14:17:59 +0000
Nathan Rossi <nathan@nathanrossi.com> wrote:

> The other port_hidden functions rely on the port_read/port_write
> functions to access the hidden control port. These functions apply the
> offset for port_base_addr where applicable. Update port_hidden_wait to
> use the port_wait_bit so that port_base_addr offsets are accounted for
> when waiting for the busy bit to change.
> 
> Without the offset the port_hidden_wait function would timeout on
> devices that have a non-zero port_base_addr (e.g. MV88E6141), however
> devices that have a zero port_base_addr would operate correctly (e.g.
> MV88E6390).

So basically the code is accessing the wrong register for devices with
non-zero port_base_addr. This means that the patch should have a Fixes
tag with the commit that introduced this bug, so that it gets
backported to relevant stable versions.

Could you resend with Fixes tag?

Marek
