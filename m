Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52D48671224
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 04:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjARDw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 22:52:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjARDwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 22:52:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A0B3539A2;
        Tue, 17 Jan 2023 19:52:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13B1B6160E;
        Wed, 18 Jan 2023 03:52:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD745C433EF;
        Wed, 18 Jan 2023 03:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674013943;
        bh=i1VadpNoM63eIKc7YafNwYDH8B99ORLDSioJAK/BE34=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HDk0iKijFpSBLtz3BzGz2gHS39W7dDBI6e1g87u3c76MWEiajL/rG53MwSrXRcGPo
         eBDoU3QWobNd1lSOjZLCkyatWD2jErwr4ymEu2P170FVF2RM+y5Y+arLXdgixLJBUj
         S5o/rmMbY17BRX55IBzNqREEz4rETV/4JP8YL16pxw191u6DYZjXNGT45Pbn0O5GnM
         66l/wT5WoGIiCHWU18Uv48dl5FOd/+6P2obICQyKhd9Oa/dyMBUm2JQk3lNzE8DBnE
         nR1CFo3hkWdiuIQTRnyWQ/TGUpr8bZanDFzfOtWkhRk7btRBvJZhLL7pNgZ3bcky3F
         gADgcuIFHDZ4Q==
Date:   Tue, 17 Jan 2023 19:52:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v3 net-next 12/12] net: mscc: ocelot: add MAC Merge
 layer support for VSC9959
Message-ID: <20230117195221.3e216f90@kernel.org>
In-Reply-To: <20230117085947.2176464-13-vladimir.oltean@nxp.com>
References: <20230117085947.2176464-1-vladimir.oltean@nxp.com>
        <20230117085947.2176464-13-vladimir.oltean@nxp.com>
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

On Tue, 17 Jan 2023 10:59:47 +0200 Vladimir Oltean wrote:
> Felix (VSC9959) has a DEV_GMII:MM_CONFIG block composed of 2 registers
> (ENABLE_CONFIG and VERIF_CONFIG). Because the MAC Merge statistics and
> pMAC statistics are already in the Ocelot switch lib even if just Felix
> supports them, I'm adding support for the whole MAC Merge layer in the
> common Ocelot library too.
> 
> There is an interrupt (shared with the PTP interrupt) which signals
> changes to the MM verification state. This is done because the
> preemptible traffic classes should be committed to hardware only once
> the verification procedure has declared the link partner of being
> capable of receiving preemptible frames.
> 
> We implement ethtool getters and setters for the MAC Merge layer state.
> The "TX enabled" and "verify status" are taken from the IRQ handler,
> using a mutex to ensure serialized access.

Doesn't build now.
