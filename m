Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38BDD556EDD
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 01:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235841AbiFVXMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 19:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236845AbiFVXMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 19:12:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F708419B6
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 16:12:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDB7261A4F
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 23:12:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1D3C34114;
        Wed, 22 Jun 2022 23:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655939551;
        bh=7tp8xO3fNgG38l+S7BcvlMXBpt1feFASiVhCA9POd+A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d6EYJosbjWhN869xh6RePzVCYR6MZP5ojQCP+dVU+wFr5gan/oUp0kiaXdrICF5Lw
         myFbPT8teXMWBA3Xb289ZSu5hFq9YonVGJ3L2VQhbpOGsWLdRO3m2fAu/1JXkvvG77
         XRf/BMTYv/gv8ucjbABHjpUnLVBRLvsLi4uzFmVs6gSpnodl8mij/FGbss6yA/j6AD
         9qDfqo5OBBaSdwHQgdsIQq0CsEQ8A4Noivv4uEfbnm9D8Tzk8qk9xMnVqOfmvm8dMR
         eY5wgcwW2oU5V6bjWrEDpzcvvqiBxDwZXCr5jmOF43QsgD/yVOQZKlp5wl3qqHkY0a
         pF6ixUnFnGlYg==
Date:   Wed, 22 Jun 2022 16:12:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [PATCH net-next] net: pcs: xpcs: depends on PHYLINK in Kconfig
Message-ID: <20220622161229.3a08de6b@kernel.org>
In-Reply-To: <cebed632d3337a40cedbf3da78ff1e1154b1ae3a.camel@redhat.com>
References: <6959a6a51582e8bc2343824d0cee56f1db246e23.1655797997.git.pabeni@redhat.com>
 <20220621125045.7e0a78c2@kernel.org>
 <YrMkEp6EWDvd3GT/@shell.armlinux.org.uk>
 <20220622083521.0de3ea5c@kernel.org>
 <cebed632d3337a40cedbf3da78ff1e1154b1ae3a.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Jun 2022 17:42:13 +0200 Paolo Abeni wrote:
> @Jakub: please let me know if you prefer to go ahead yourself, or me
> sending a v3 with 'depends PHYLINK' + the above (or any other option ;)

[resending, sorry, Russell let me know that my MUA broke the headers]

Well, IDK. You said "depends PHYLINK" which makes me feel like I
haven't convinced you at all :)  Unless you mean add the dependency
on the consumers not on PCS_XPCS itself, but that's awkward.

What I was saying is that "depends" in a symbol which is only
"select"ed by other symbols makes no sense. IIUC "select" does not
visit dependencies, so putting "depends" on an user-invisible symbol
(i.e. symbol without a prompt) achieves nothing.

So PCS_XPCS can have no "depends" if we hide it.

The way I see it - PHYLINK already selects MDIO_DEVICE. So we can drop
the MDIO business from PCS_XPCS, add "select PHYLINK", hide it by
removing the prompt, and we're good. Then again, I admit I have not
tested this at all so I could be speaking gibberish...

diff --git a/drivers/net/pcs/Kconfig b/drivers/net/pcs/Kconfig
index 22ba7b0b476d..f778e5155fae 100644
--- a/drivers/net/pcs/Kconfig
+++ b/drivers/net/pcs/Kconfig
@@ -6,8 +6,8 @@
 menu "PCS device drivers"
 
 config PCS_XPCS
-       tristate "Synopsys DesignWare XPCS controller"
-       depends on MDIO_DEVICE && MDIO_BUS
+       tristate
+       select PHYLINK
        help
          This module provides helper functions for Synopsys DesignWare XPCS
