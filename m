Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01B844CC379
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 18:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233553AbiCCRQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 12:16:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbiCCRQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 12:16:01 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A145B3DE;
        Thu,  3 Mar 2022 09:15:15 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646327712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=QA9292ErVJBK3Dbl+AyvCtdfJtIr/aoQIN3k0viXtpQ=;
        b=v18fWMhrIMzCeoFgxsf70BbWn4cVKFGWxNEbyBR3CiiwMhqX6GIlHqTifHamPdb+cxOhOi
        JvBHjeRxT2vKKPdAnbVHCMOoqyx9WDCSRV5ycxYXXUi+Ghm8lqkU52ZUhN5hNsfDPlrWE9
        2PGGqXg4HQDsUmQw3hVsTRJA0Ur4QEdVcwwVismFCt9IyVqDLdJg2v5i04zR3KZfwycHbx
        zk7crLioyZ3Zlsx47Ua2FaKQ0fx8Ws4g51iwG49Zvb0W3mz4NbKGhbZmUZT2vQwrKChi09
        JWWSmq9a74oUhi1VAsndcMHSv3MLAs8SNtlfg3xLqVCrA6lNydt9ck0oERAQoA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646327712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=QA9292ErVJBK3Dbl+AyvCtdfJtIr/aoQIN3k0viXtpQ=;
        b=w/urUxUmHyvO2vZ0BDlhWhqntVfH+hl4j06fJsdYIzfNwdzkUVT+dDpfKb/fM0FjxGEqTi
        fs7bEubj+R6bWUCg==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        bridge@lists.linux-foundation.org, Chris Zankel <chris@zankel.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        linux-doc@vger.kernel.org, linux-xtensa@linux-xtensa.org,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Mike Travis <mike.travis@hpe.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Robin Holt <robinmholt@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Steve Wahl <steve.wahl@hpe.com>, UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 0/9] net: Convert user to netif_rx().
Date:   Thu,  3 Mar 2022 18:14:56 +0100
Message-Id: <20220303171505.1604775-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

This is the first batch of converting netif_rx_ni() caller to
netif_rx(). The change making this possible is net-next and
netif_rx_ni() is a wrapper around netif_rx(). This is a clean up in
order to remove netif_rx_ni().

Cc: Andrew Lunn <andrew@lunn.ch>
Cc: bridge@lists.linux-foundation.org
Cc: Chris Zankel <chris@zankel.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kurt Kanzenbach <kurt@linutronix.de>
Cc: linux-doc@vger.kernel.org
Cc: linux-xtensa@linux-xtensa.org
Cc: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Mike Travis <mike.travis@hpe.com>
Cc: Nikolay Aleksandrov <razor@blackwall.org>
Cc: Robin Holt <robinmholt@gmail.com>
Cc: Roopa Prabhu <roopa@nvidia.com>
Cc: Steve Wahl <steve.wahl@hpe.com>
Cc: UNGLinuxDriver@microchip.com
Cc: Vivien Didelot <vivien.didelot@gmail.com>
Cc: Vladimir Oltean <olteanv@gmail.com>
Sebastian


