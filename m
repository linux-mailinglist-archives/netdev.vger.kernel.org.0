Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AABB06BF328
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 21:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbjCQUy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 16:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbjCQUyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 16:54:54 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A164031BF6;
        Fri, 17 Mar 2023 13:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GblJOWssTpaedBbC2hZU06SgWqUxP/HpvCOjz07lRhY=; b=VBIPbh/oth2seArZofxY358BBZ
        z4F+BLrL053Cc/dmzQtEP2I70S02/erujrfH8zQe83jf/ZAJlOThApT/jIONucl0H1CsGedpD2n7A
        23pqYeZcwbmjt09GNYuokYDr9SzruypNImHTDAKuN+Y59T9TZnPncUOcuPeqEfGVfipW2hoKoPgtb
        0KpGCXHzw2PGQA4bydhKIV8MKxBI4Hpj3ELSz+8Sk+oXNz9mpuQdLxL/Bbngt6Catd3lRA7oCayS2
        VlQ8KoIPh7n2trgKI2yRb0qNwJBfYFA/TVKj2F8krF9cQcs6NFfCvsdFOZ0iOU/kxQcZT3Im/c2q+
        Y63ezDEw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:42172)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pdH5s-0003Sk-Ph; Fri, 17 Mar 2023 20:54:32 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pdH5n-0003mh-Rs; Fri, 17 Mar 2023 20:54:27 +0000
Date:   Fri, 17 Mar 2023 20:54:27 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>
Subject: Re: [PATCH net v2 0/2] Fix PHY handle no longer parsing
Message-ID: <ZBTTg78Zc+Vdyxi4@shell.armlinux.org.uk>
References: <20230314070208.3703963-1-michael.wei.hong.sit@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314070208.3703963-1-michael.wei.hong.sit@intel.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 03:02:06PM +0800, Michael Sit Wei Hong wrote:
> After the fixed link support was introduced, it is observed that PHY
> no longer attach to the MAC properly.

You are aware, I hope, that fixed-link and having a PHY are mutually
exclusive?

In other words, you can't use fixed-link to specify parameters for a
PHY.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
