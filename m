Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F35FF5533A4
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 15:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbiFUNe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 09:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351916AbiFUNdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 09:33:09 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B1028983;
        Tue, 21 Jun 2022 06:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=G80LNemDmZomH/5dG561zVRY02eIMOerEfE83vdjZHg=; b=OnwqUjGZM/WkATzH2paqr7BPUu
        zQS/hPvFxad2qilfB71xD1PlP5LEqIgNC6vLSQaXAukL0/Ud5fw4RxkCCnNbCNPysOp6zW6q+bMiL
        DckLx6qqM0tOaJiw+kMWqZDcavgiHQ8UycMU94twN8oOLqaXgCofaayVC4TXC/uKUpktjgewuWH1Z
        KRfeovTzP8grfg5Fg5rib3Za2bdULIymDSzYt66z67jEU4sv6qhg3mVssMp13fW7ej0iqrLkrAIgB
        ORy4jdcg5WBumsobuT5TxkkFeTlT4fhY/JxCRfnIhfTv3ZArwqbhELlAcSdONImzIk9mivs7qq8Hx
        MMDfNe8g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:32964)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o3dx4-0002Qr-Dq; Tue, 21 Jun 2022 14:29:53 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o3dwv-00064M-6m; Tue, 21 Jun 2022 14:29:45 +0100
Date:   Tue, 21 Jun 2022 14:29:45 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Zheng Bin <zhengbin13@huawei.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        boon.leong.ong@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gaochao49@huawei.com
Subject: Re: [PATCH -next] net: pcs: pcs-xpcs: Fix build error when
 CONFIG_PCS_XPCS=y && CONFIG_PHYLINK=m
Message-ID: <YrHHyZNJXVme1JIe@shell.armlinux.org.uk>
References: <20220621131251.3357104-1-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220621131251.3357104-1-zhengbin13@huawei.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 21, 2022 at 09:12:51PM +0800, Zheng Bin wrote:
> If CONFIG_PCS_XPCS=y, CONFIG_PHYLINK=m, bulding fails:
> 
> drivers/net/pcs/pcs-xpcs.o: in function `xpcs_do_config':
> pcs-xpcs.c:(.text+0x64f): undefined reference to `phylink_mii_c22_pcs_encode_advertisement'
> drivers/net/pcs/pcs-xpcs.o: in function `xpcs_get_state':
> pcs-xpcs.c:(.text+0x10f8): undefined reference to `phylink_mii_c22_pcs_decode_state
> 
> Make PCS_XPCS depends on PHYLINK to fix this.
> 
> Fixes: b47aec885bcd ("net: pcs: xpcs: add CL37 1000BASE-X AN support")
> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>

Paolo Abeni has already sent a patch, which I think is addressing a
similar issue. Please see:

https://lore.kernel.org/r/6959a6a51582e8bc2343824d0cee56f1db246e23.1655797997.git.pabeni@redhat.com

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
