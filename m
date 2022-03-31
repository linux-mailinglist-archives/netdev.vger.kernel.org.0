Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 892704EE0F2
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 20:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236756AbiCaSrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 14:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236352AbiCaSrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 14:47:05 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5BAA18D9B4;
        Thu, 31 Mar 2022 11:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Xf4dx+kb6mltbt/ukOIdVaBYUv4mOnK0nMAdAcvT3t4=; b=r8b5T+EEyUL9WNCmLx5J5hC8n2
        OLPmiU/H5JiehkOmfyg8K1M5f5zuQ6d325rz3Z9ZvRpO/QoFxYOqe+nrQoTS1gtCyctthLA/rBZiC
        ZRrsdoSY4mAQzH73CsgM8HmDHfM8DNhO2JwC7kxN2J4wzKd6nLeN6Cx+gJKaA8jlL3jni5s79YDnc
        l1yWRemhS/PTbxZJDQ38Nbc4nER4NJKO4nIWoplseX51mkblN+arfisGpg2iRIEcv7NG+sYMdG4BV
        2m0XMX4jMwDyCE5c/Xjlc2sWzb1qAGWQK/F5g98SfbOhLUDBOnW5jmqB9jWoqFcOIEMjCp8s5DV3s
        MwYyF6Ww==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58072)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nZzn9-0005Ct-VE; Thu, 31 Mar 2022 19:45:07 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nZzn9-0007s2-1n; Thu, 31 Mar 2022 19:45:07 +0100
Date:   Thu, 31 Mar 2022 19:45:07 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Chen-Yu Tsai <wens@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Chen-Yu Tsai <wens@csie.org>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] net: stmmac: Fix unset max_speed difference
 between DT and non-DT platforms
Message-ID: <YkX2s8DtcSebBDcL@shell.armlinux.org.uk>
References: <20220331184145.14242-1-wens@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220331184145.14242-1-wens@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 01, 2022 at 02:41:45AM +0800, Chen-Yu Tsai wrote:
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

Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
