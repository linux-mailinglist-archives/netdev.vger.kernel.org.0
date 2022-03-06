Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0624CEE08
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 22:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234316AbiCFV7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 16:59:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234302AbiCFV65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 16:58:57 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6BC1C11B;
        Sun,  6 Mar 2022 13:58:03 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646603881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=OLij3hLq/ByEiIvsKO2mUqNMbWd2cFRiFv/iL/CpBCk=;
        b=tUne71KCZTwV5KHN/PA2BeuDU0Ui2RmzmR06wo5VCgSnXvcNJ6gUdlowRejfyJNqosczI0
        XyIRewLv9JIHiQHH8tPt2M+F4beDGD/0Yt9G+nD/DvgMbBI64JFULurNIZzsA0PINVVvbJ
        1QmKMsvsr8OT4Dt1Kql7HOdKoTP+eJN1PnsOPhvPeyuU0o0fqW5DVr/vBOLYy2td0FE4iD
        mI6Bh7LRqEVP0JG44lJL9GazmWDjSATwFYGnODpUEoEwH3i8Qxyw9zG+Pj3ogW8w9lOUAq
        htbT4393p5kH+q1pUt6hS94uyx81KNWM5UWwCA2zec7l3KTSzI3/u1bWwA9cSw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646603881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=OLij3hLq/ByEiIvsKO2mUqNMbWd2cFRiFv/iL/CpBCk=;
        b=rkxcvxvK79CfwpOoWAKzxP921+aI4UP2669w0fns34DkINPs693vfhMMINY9U6iEsbZWfw
        PeHf6FpY2DQ8tJBQ==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Antonio Quartulli <a@unstable.cc>,
        b.a.t.m.a.n@lists.open-mesh.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Divya Koppera <Divya.Koppera@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Jon Maloy <jmaloy@redhat.com>, linux-bluetooth@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-staging@lists.linux.dev,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Remi Denis-Courmont <courmisch@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sven Eckelmann <sven@narfation.org>,
        Sven Schnelle <svens@linux.ibm.com>,
        tipc-discussion@lists.sourceforge.net,
        Vasily Gorbik <gor@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Ying Xue <ying.xue@windriver.com>
Subject: [PATCH net-next 00/10] net: Convert user to netif_rx(), part 3.
Date:   Sun,  6 Mar 2022 22:57:43 +0100
Message-Id: <20220306215753.3156276-1-bigeasy@linutronix.de>
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

This is the third and last batch of converting netif_rx_ni() caller to
netif_rx(). The change making this possible is net-next and
netif_rx_ni() is a wrapper around netif_rx(). This is a clean up in
order to remove netif_rx_ni().

The micrel phy driver is patched twice within this series: the first is
is to replace netif_rx_ni() and second to move netif_rx() outside of the
IRQ-off section. It is probably simpler to keep it within this series.

Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandra Winter <wintera@linux.ibm.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Antonio Quartulli <a@unstable.cc>
Cc: b.a.t.m.a.n@lists.open-mesh.org
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Divya Koppera <Divya.Koppera@microchip.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Cc: Jon Maloy <jmaloy@redhat.com>
Cc: linux-bluetooth@vger.kernel.org
Cc: linux-s390@vger.kernel.org
Cc: linux-staging@lists.linux.dev
Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Marek Lindner <mareklindner@neomailbox.ch>
Cc: Remi Denis-Courmont <courmisch@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Sven Eckelmann <sven@narfation.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: tipc-discussion@lists.sourceforge.net
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Wenjia Zhang <wenjia@linux.ibm.com>
Cc: Ying Xue <ying.xue@windriver.com>

Sebastian


