Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 840354CE765
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 23:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbiCEWON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 17:14:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232707AbiCEWOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 17:14:09 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA0B651E72;
        Sat,  5 Mar 2022 14:13:18 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646518395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=K6RsnwD/BCzH5WC8kzG/RcEEnIxeuBZkPWilYKAkaIA=;
        b=19SAR6XmxUBramFZyCy1np5zMmBB3Gw5a/tfCzzKpkbCigHriL+nnH5cgsgk/pe2IMWmO3
        QU8pqgK5jlQ34nP8ofDcByl3d0bNcmOl9fl5Pkay3kaMDBsaZdNGLGlMwnBH73D2hgJeSj
        s86UAJXgvzBCpKie+0oPVJf/h51lSPBKf4BjdQfXL4OCwIICEoDhb6tO9M/Eq/KUADzQaw
        x06b2X+fKTPlromrFZLilV573RI6/2PHFYy9x8Tr1yi7VyrpKUVs1RXomYc92DD2pkNhRP
        jrhXMQGSqpTSuihSBS3fLupM0XWwEelKOl6kWmzJL+BRWN74HzCG96iXwBfAxA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646518395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=K6RsnwD/BCzH5WC8kzG/RcEEnIxeuBZkPWilYKAkaIA=;
        b=0b628Q7I/sf6Ay3zX05/3px2i3BWkvu3PAZfEOkGogLsjLNBGytZf+tzG5fkg4GDbuAc+1
        Ahs7B8uSJWPVcVAQ==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Arend van Spriel <aspriel@gmail.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@kernel.org>,
        libertas-dev@lists.infradead.org, linux-can@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Maya Erez <merez@codeaurora.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        SHA-cyfmac-dev-list@infineon.com,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        wil6210@qti.qualcomm.com, Wolfgang Grandegger <wg@grandegger.com>,
        Wright Feng <wright.feng@infineon.com>,
        Xinming Hu <huxinming820@gmail.com>
Subject: [PATCH net-next 0/8] net: Convert user to netif_rx(), part 2.
Date:   Sat,  5 Mar 2022 23:12:44 +0100
Message-Id: <20220305221252.3063812-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the second batch of converting netif_rx_ni() caller to
netif_rx(). The change making this possible is net-next and
netif_rx_ni() is a wrapper around netif_rx(). This is a clean up in
order to remove netif_rx_ni().

The brcmfmac changes are slilghtly larger because the inirq parameter
can be removed.

Cc: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Arend van Spriel <aspriel@gmail.com>
Cc: brcm80211-dev-list.pdl@broadcom.com
Cc: Chi-hsien Lin <chi-hsien.lin@infineon.com>
Cc: Chung-hsien Hsu <chung-hsien.hsu@infineon.com>
Cc: Franky Lin <franky.lin@broadcom.com>
Cc: Ganapathi Bhat <ganapathi017@gmail.com>
Cc: Hante Meuleman <hante.meuleman@broadcom.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Jeremy Kerr <jk@codeconstruct.com.au>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: libertas-dev@lists.infradead.org
Cc: linux-can@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Matt Johnston <matt@codeconstruct.com.au>
Cc: Maya Erez <merez@codeaurora.org>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Radu Pirea <radu-nicolae.pirea@oss.nxp.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: SHA-cyfmac-dev-list@infineon.com
Cc: Sharvari Harisangam <sharvari.harisangam@nxp.com>
Cc: wil6210@qti.qualcomm.com
Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: Wright Feng <wright.feng@infineon.com>
Cc: Xinming Hu <huxinming820@gmail.com>


Sebastian

