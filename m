Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7CE4EE0DE
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 20:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236522AbiCaSrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 14:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234572AbiCaSrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 14:47:02 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E060F62A2D;
        Thu, 31 Mar 2022 11:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=l5Za89XufRVMoXWzTHqu1+JIk2bJtPxePB/E1tQlqeg=; b=fxH+ppUa9P02Ibmw/erIDWbMZw
        UCMgrKDDQz7tY5RsESoCgiwTkRIbqkVjU6SewdfM7PX2lB65upgzJjdFziEQRxntXo7gKFfzfRT8b
        hy2NxzCyCn2qh8vIjnMcWjn8WpdoQZiKsfJzf02qkyNeM5/JazA9mDuKQUb68zUgrylC2aauii08F
        p+urwvF378clcP77ZVrRDJeqEtZLMu4Z2fwTQopMfGPAXiHcZmYnr+R6QItvwaZu5u7BpaCtztEBO
        OGqQ8YgcveoiG/C0qMpouw6B9Rv3YGV8a2/xVSLeZ5VIL5D7o5Iycf7DssXBfr3H9jJAgUD99xJAT
        ImNRK6Tw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58070)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nZzmj-0005Ci-L4; Thu, 31 Mar 2022 19:44:41 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nZzmZ-0007rv-UA; Thu, 31 Mar 2022 19:44:31 +0100
Date:   Thu, 31 Mar 2022 19:44:31 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Chen-Yu Tsai <wens@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Chen-Yu Tsai <wens@csie.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: Fix unset max_speed difference between DT
 and non-DT platforms
Message-ID: <YkX2j7e4mPC0R2Xj@shell.armlinux.org.uk>
References: <20220331171827.12483-1-wens@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220331171827.12483-1-wens@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 01, 2022 at 01:18:27AM +0800, Chen-Yu Tsai wrote:
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

Sounds like it's got to complicated...

> In commit 92c3807b9ac3 ("net: stmmac: convert to phylink_get_linkmodes()")
> the conversion switched completely to checking for non-zero value as a
> valid value, which caused 1000base-T to stop getting advertised by
> default.
> 
> Instead of trying to fix all the checks, simply leave max_speed alone if
> DT property parsing fails.

And this kind of proves that point - if deleting code fixes it...

Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
