Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7F704C8BC3
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 13:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234577AbiCAMiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 07:38:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbiCAMiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 07:38:13 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9905D140E8;
        Tue,  1 Mar 2022 04:37:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OgWilR1GahRuy4nq1IiDO3LnXPsAbyIUMZ5wyCYKmFQ=; b=eNOjt+N1AIu4tQdxbvwkMNi+mF
        8SrJQbXMVHijCcnaCGGiUimdRum866ec8uACk05m4IdInEu3fNhuMnJe4s8jgBYxs37JRSHHBXytc
        cJ4DNeEKMTZrP3YYE84dJiebjbXctJKQyfX8aPwyqlaGRLshpMN4sAJ3sJOPo8/EuhtSvl2l+vNP0
        nOU2W0wZja3TuMM1HnzO+Xhpw1ZA2iLFQzg9CEN+t80/NH+Q8bKSSs6WYpFbPAdj0M1N6Me+Y+P1n
        XjgKqdhfF2TFYZf6//FWRHdXoVHXgx39+9boXTrCLuaTg6r6SGOCycYvqwQTUm98/4c/lZOZDM0tO
        FBkecvTg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57578)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nP1kn-0001Ge-6v; Tue, 01 Mar 2022 12:37:21 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nP1kk-00078x-CT; Tue, 01 Mar 2022 12:37:18 +0000
Date:   Tue, 1 Mar 2022 12:37:18 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     David Laight <David.Laight@aculab.com>
Cc:     'Christophe Leroy' <christophe.leroy@csgroup.eu>,
        'Segher Boessenkool' <segher@kernel.crashing.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: Remove branch in csum_shift()
Message-ID: <Yh4TfnHuTmCqWZDb@shell.armlinux.org.uk>
References: <efeeb0b9979b0377cd313311ad29cf0ac060ae4b.1644569106.git.christophe.leroy@csgroup.eu>
 <7f16910a8f63475dae012ef5135f41d1@AcuMS.aculab.com>
 <20220213091619.GY614@gate.crashing.org>
 <476aa649389345db92f86e9103a848be@AcuMS.aculab.com>
 <de560db6-d29a-8565-857b-b42ae35f80f8@csgroup.eu>
 <9cdb4a5243d342efb562bc61d0c1bfcb@AcuMS.aculab.com>
 <c616f9a6-c9db-d3a7-1b23-f827732566bb@csgroup.eu>
 <10309fa64833418a980a8d950d037357@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10309fa64833418a980a8d950d037357@AcuMS.aculab.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 01, 2022 at 11:41:06AM +0000, David Laight wrote:
> From: Christophe Leroy
> > Sent: 01 March 2022 11:15
> ...
> > Looks like ARM also does better code with the generic implementation as
> > it seems to have some looking like conditional instructions 'rorne' and
> > 'strne'.
> 
> In arm32 (and I think arm64) every instruction is conditional.

Almost every instruction in arm32. There are a number of unconditional
instructions that were introduced.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
