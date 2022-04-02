Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1A934EFEB6
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 06:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353660AbiDBEnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Apr 2022 00:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238032AbiDBEnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Apr 2022 00:43:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2D21EFE3B;
        Fri,  1 Apr 2022 21:42:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5747D6091C;
        Sat,  2 Apr 2022 04:42:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211B8C340EC;
        Sat,  2 Apr 2022 04:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648874520;
        bh=AzLgAuzRNBRAOdspDj61I0XCgtewRY+rH2B0NSOl6VA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JA0eHd50KJdwsMRw7rUatj0KDIw390Mr/6jV9svpoQn1axyWHVDwFS6V8v8zGo103
         5PpISDOUEAxU15XZcBFKbInEtuhu8M6o99wUTRfjJvTTQt/ajYh2nkWDbPrzZxK67h
         1ipdXJzJADUvVNJKcGLdjkliUl1owXZPIjL9mTf42VfvkcfjybrdFnffa2vv3MEBJk
         Lwt7MhvRmLG4/fx+rT+RoUMUavewp810I+8hMATUs9sxT3QDnw/gX+UR0bLrNA92hr
         bNDEbVLcBiu/RrgEurXbXcJ4/zTsRxj55S64a02E1uk7QcySc2VgA3JqqPaEHrWddS
         S64LAPy1PBpuA==
Date:   Fri, 1 Apr 2022 21:41:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chen-Yu Tsai <wens@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, Chen-Yu Tsai <wens@csie.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH RESEND2] net: stmmac: Fix unset max_speed difference
 between DT and non-DT platforms
Message-ID: <20220401214158.7346bd62@kernel.org>
In-Reply-To: <20220331184832.16316-1-wens@kernel.org>
References: <20220331184832.16316-1-wens@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  1 Apr 2022 02:48:32 +0800 Chen-Yu Tsai wrote:
> From: Chen-Yu Tsai <wens@csie.org>
> 
> In commit 9cbadf094d9d ("net: stmmac: support max-speed device tree
> property"), when DT platforms don't set "max-speed", max_speed is set to
> -1; for non-DT platforms, it stays the default 0.
> 
> Prior to commit eeef2f6b9f6e ("net: stmmac: Start adding phylink support"),
> the check for a valid max_speed setting was to check if it was greater
> than zero. This commit got it right, but subsequent patches just checked
> for non-zero, which is incorrect for DT platforms.
> 
> In commit 92c3807b9ac3 ("net: stmmac: convert to phylink_get_linkmodes()")
> the conversion switched completely to checking for non-zero value as a
> valid value, which caused 1000base-T to stop getting advertised by
> default.
> 
> Instead of trying to fix all the checks, simply leave max_speed alone if
> DT property parsing fails.
> 
> Fixes: 9cbadf094d9d ("net: stmmac: support max-speed device tree property")
> Fixes: 92c3807b9ac3 ("net: stmmac: convert to phylink_get_linkmodes()")
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
> 
> Resend2: CC Srinivas at Linaro instead of ST. Collected Russell's ack.
> Resend: added Srinivas (author of first fixed commit) to CC list.
> 
> This was first noticed on ROC-RK3399-PC, and also observed on ROC-RK3328-CC.
> The fix was tested on ROC-RK3328-CC and Libre Computer ALL-H5-ALL-CC.

This patch got marked Changes Requested in pw, but I can't see why, 
so I went on a limb and applied it. LMK if that was a mistake,
otherwise its commit c21cabb0fd0b ("net: stmmac: Fix unset max_speed
difference between DT and non-DT platforms") in net.
