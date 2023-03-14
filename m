Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D62466B9BA5
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbjCNQfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbjCNQek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:34:40 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48CCDCC2B;
        Tue, 14 Mar 2023 09:34:19 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id C4036100006;
        Tue, 14 Mar 2023 16:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1678811657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=TF1M245wnKpVCzK6z/l3V4pcyU9Wbg1W8fUVHhSWBaU=;
        b=EmvzN/sMZIVfEvP3J43pltTDHqYXta3rIE5/iFL9CdqgGSV2VtWvSZygIYfNdt8PRwnVS5
        xtnKIj9RoSaT1xV5kMBWzOW/jchsgZwE1ppCl5KI7nXd1KqcCaca8q2RXHp28uFzqcMBQ5
        lKQypUlygCg1HGbUl5rVLVMxOCjOdwfykGzZSczVhQBz0ZKC0Ror0Z+HeBh6k1fQxNdt4o
        b8ZgeItIMfX6XXp1FhQNLtJw/BG6Kmor7xbovbC6mI8AhXQT962jmd8TFaIVUcnAe2mtFG
        JHAoM9THkHu/wTCzqAJgVxcAgD1KXm9IGXMJn/W8vQzZWL/r2C1kE6yRZpZcrg==
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
Subject: [PATCH RESEND net-next v4 0/3] net: dsa: rzn1-a5psw: add support for vlan and .port_bridge_flags
Date:   Tue, 14 Mar 2023 17:36:48 +0100
Message-Id: <20230314163651.242259-1-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
RESEND V4:
 - Resent due to net-next being closed

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

