Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB890641815
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 18:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbiLCRYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 12:24:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiLCRYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 12:24:38 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B6B1E70B;
        Sat,  3 Dec 2022 09:24:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=b8jU26nVv5zOpuzDY4RwO7PBnJsJWgH0sc80AjiDjCg=; b=0Opbfyx0A7KcUTzMBxsQam5MR2
        l6MSrcSSRtyJaDFtsvuJcPz7EPzYJo8F4ynaXRbCsckseKpHhXtY4+iCjwqSTJenHcMa5yeXLC9sk
        nUEidgOVOL46zFwEyJgxDaCUWRgVII7sB5/A1M4lqWymyUKmAPx2EnMsVwJFa1NHXI4a3YFSALpt0
        kamqwpd3Mn/B3Xg2VIdd3wesfmfG8mrHhfIn+27CIwFDR+pX3P7Z16usnSlH/4VY5F1Bgixddfcno
        JLwkg5LnNx/9PQnWHj+gEDA85AnJz1IlZMBoUDNqtj6NQRH+Mo3hhpXpSi7YCWHLE33+2M4W9LZ8Q
        Z57YNhHg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35548)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p1WFe-0005Gi-11; Sat, 03 Dec 2022 17:24:34 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p1WFb-0005W0-Or; Sat, 03 Dec 2022 17:24:31 +0000
Date:   Sat, 3 Dec 2022 17:24:31 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     kernel test robot <lkp@intel.com>, devicetree@vger.kernel.org,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH net-next v2] net: sfp: clean up i2c-bus property parsing
Message-ID: <Y4uGT19d1Euz75Vd@shell.armlinux.org.uk>
References: <E1p1OIG-0098J4-EV@rmk-PC.armlinux.org.uk>
 <202212040026.WN9NQzqq-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202212040026.WN9NQzqq-lkp@intel.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 04, 2022 at 12:40:25AM +0800, kernel test robot wrote:
> Thank you for the patch! Perhaps something to improve:

Sigh... this is another stupidity.

> 73970055450eeb Russell King          2017-07-25  2701  	if (pdev->dev.of_node) {
> 73970055450eeb Russell King          2017-07-25 @2702  		struct device_node *node = pdev->dev.of_node;

"node" declared here...

> 259c8618b0099b Russell King          2017-12-14  2703  		const struct of_device_id *id;
> 73970055450eeb Russell King          2017-07-25  2704  
> 259c8618b0099b Russell King          2017-12-14  2705  		id = of_match_node(sfp_of_match, node);

... and clearly used here, so the code looks to be correct.

However, when CONFIG_OF is not set, of_match_node() does not make use
of this argument:

#define of_match_node(_matches, _node)  NULL

which results in otherwise correct code issuing a warning when
CONFIG_OF is disabled... and sure enough, your configuration has:

> # CONFIG_OF is not set

This illustrates just how bad an idea it is to use compiler macros for
this stuff - it actively hurts compile testing, because you have to
test every damn combination of configuration options to get proper
coverage, which is totally and utterly rediculous.

of_match_node() and ACPI_HANDLE_FWNODE() should *both* be inline
functions when the subsystem is disabled, so that incorrect arguments
can be detected, and warnings about unused variables such as the one
you're reporting here doesn't happen.

While the issue lies firmly in the realms of the DT (and ACPI) headers,
I will yet again respin this patch to sort this out - but really the
correct solution is to fix the bloody headers so compile coverage
actually works.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
