Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7976AE633
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 17:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjCGQUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 11:20:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbjCGQTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 11:19:38 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20AC30D2
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 08:19:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ajJcOlWzx/VD/YVzxlqdpGWy4Ty21l5WTKrD64qnBUE=; b=ss5koH86A5fyLvKwygzr/Yh3ir
        jt5mPztVyk14RQl/Yp3gkJL29sViBmotS1nf7LWQVTsAon3/1JT2TALsO+CS+yXu5ZfMqslhBU792
        slTv1488OAE3vcJXe6Ywq1uK0gbsY9bILhCnEdsSxJ8t6j7nFJtxL4tfx/AjNJqXazGVH2UlQTXq5
        y9i/ZzKrEgqoUkNawA89atbqmmQvOQcPMg+WS/r1tOi5GGk+04/Hp3iNRbB2pu6gD6dcexkfLRdom
        chMtMw5DUwqSk2MczjZR1+m0Ro/EdW8OcWH1EnhkgO5YzPIEU3aBe6GwWY7XjOUzsVfMfeM4+tob6
        pWk07xEQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58336)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pZa1r-0000ma-2A; Tue, 07 Mar 2023 16:19:07 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pZa1m-0001fg-3S; Tue, 07 Mar 2023 16:19:02 +0000
Date:   Tue, 7 Mar 2023 16:19:02 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Daniel Golle <daniel@makrotopia.org>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 0/4] Various mtk_eth_soc cleanups
Message-ID: <ZAdj9qUXcHUsK7Gt@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here are a number of patches that do a bit of cleanup to mtk_eth_soc.

The first patch cleans up mtk_gmac0_rgmii_adjust(), which is the
troublesome function preventing the driver becoming a post-March2020
phylink driver. It doesn't solve that problem, merely makes the code
easier to follow by getting rid of repeated tenary operators.

The second patch moves the check for DDR2 memory to the initialisation
of phylink's supported_interfaces - if TRGMII is not possible for some
reason, we should not be erroring out in phylink MAC operations when
that can be determined prior to phylink creation.

The third patch removes checks from mtk_mac_config() that are done
when initialising supported_interfaces - phylink will not call
mtk_mac_config() with an interface that was not marked as supported,
so these checks are redundant.

The last patch removes the remaining vestiges of REVMII and RMII
support, which appears to be entirely unused.

These shouldn't conflict with Daniel's patch set, but if they do I
will rework as appropriate.

Thanks.

 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 81 ++++++++++++-----------------
 1 file changed, 33 insertions(+), 48 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
