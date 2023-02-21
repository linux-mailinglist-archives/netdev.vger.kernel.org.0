Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 470D269DCDA
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 10:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233937AbjBUJZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 04:25:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233935AbjBUJZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 04:25:17 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292DA222ED;
        Tue, 21 Feb 2023 01:24:59 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 99E6BC0007;
        Tue, 21 Feb 2023 09:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1676971498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=sF6cTrmRbsTNZI9mfS1d6w4kuvwM4DluVhRpiXiPKYg=;
        b=JOJfyebbXafvS+9Jf24BLnzMwI6Vm+P8p48Cwb5cP9cbkReOmVz42FK5n2btKD4tGtKN+4
        3nRmRAnlBAg1K7vN8+9rVO79ZEfWku+WkRzc0qr4Ng5ORFmss2ewR7hyVFh69w6BmkbhiA
        gT4MoFiSZsBiOl3rbJao18x+YVmVxgn22lajMe5TcYWAzREyhWqlxZb6EDj5bT+hVBDtbS
        LaAk2SBNYFAioGDoMoV0AWKbchDwxnyDZZ2iYOwbqYFKbJeZZLkK27onxCYJWYkJTHcU+r
        EAFT2WefHXNZ38+fbP8MuMC65nMr8JRNXFcOHhqajPRtoYq4TLBsjMM/0GhIwg==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Arun Ramadoss <Arun.Ramadoss@microchip.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v4 0/3] net: dsa: rzn1-a5psw: add support for vlan and .port_bridge_flags
Date:   Tue, 21 Feb 2023 10:26:23 +0100
Message-Id: <20230221092626.57019-1-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While adding support for VLAN, bridge_vlan_unaware.sh and
bridge_vlan_aware.sh were executed and requires .port_bridge_flags
to disable flooding on some specific port. Thus, this series adds
both vlan support and .port_bridge_flags.

----
V4:
 - Fix missing CPU port bit in a5psw->bridged_ports
 - Use unsigned int for vlan_res_id parameters
 - Rename a5psw_get_vlan_res_entry() to a5psw_new_vlan_res_entry()
 - In a5psw_port_vlan_add(), return -ENOSPC when no VLAN entry is found
 - In a5psw_port_vlan_filtering(), compute "val" from "mask"

V3:
 - Target net-next tree and correct version...

V2:
 - Fixed a few formatting errors
 - Add .port_bridge_flags implementation

Clément Léger (3):
  net: dsa: rzn1-a5psw: use a5psw_reg_rmw() to modify flooding
    resolution
  net: dsa: rzn1-a5psw: add support for .port_bridge_flags
  net: dsa: rzn1-a5psw: add vlan support

 drivers/net/dsa/rzn1_a5psw.c | 223 ++++++++++++++++++++++++++++++++++-
 drivers/net/dsa/rzn1_a5psw.h |   8 +-
 2 files changed, 222 insertions(+), 9 deletions(-)

-- 
2.39.0

