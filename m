Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9209F649BD2
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 11:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbiLLKPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 05:15:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbiLLKPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 05:15:49 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749F32A0
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 02:15:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:To:From:Date:Reply-To:Cc:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=KjYEboqh2pAo9Meo7R57/NrdKst5aXNH8NlRTXq5Ixc=; b=doNbY8qY5DtmKkHransE2chRc4
        ugRJ+1D/NJHTAdPR9lyT7m9f7XGzIka4IzzB7Ofvbd5CvLYJARjJJ7URQh2EmIuCy1sXlXYPiKfcl
        N2G7QAZYgk+ACG/0idF3p4zxeFli9GjRCPj4XerH4HIfTHCZBTUaEmdVYVZyaO0eqM735439z4a+9
        VuJ1ozGuOgvperiauJ934R+/XRxojqpEUSRVu4Cc+DpYiAfZKkD4TJvwB3mNgsJOjwL/2yQR1SO/u
        A24I9gM2FNnFXb5k4xFtUV0QC4uEnx3OrV4pF8qzhw2OCBRyvVtjFgbobxOORicpiLOcMyNG6SwSR
        di7PwnIw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35672)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p4fqa-0005Qi-BP; Mon, 12 Dec 2022 10:15:44 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p4fqY-0005Qo-Ji; Mon, 12 Dec 2022 10:15:42 +0000
Date:   Mon, 12 Dec 2022 10:15:42 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org
Subject: Redundant changes in "net: dsa: mt7530: add support for in-band link
 status"
Message-ID: <Y5b/Tm4GwPGzd9sR@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

While updating my tree, I notice that the above referenced commit
contains a redundant change, namely in mt753x_phylink_get_caps():

        config->mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
                                   MAC_10 | MAC_100 | MAC_1000FD;

+       if ((priv->id == ID_MT7531) && mt753x_is_mac_port(port))
+               config->mac_capabilities |= MAC_2500FD;
+

This shouldn't be necessary. mt753x_phylink_get_caps() goes on to
call the obviously named mt753x "mac_port_get_caps" method, which
for a MT7531 is mt7531_mac_port_get_caps().

mt7531_mac_port_get_caps() will already set MAC_2500FD for ports
5 and 6 where appropriate.

Please submit a patch to remove the above change if you agree that
it is already covered.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
