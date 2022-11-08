Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1888620B09
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 09:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233754AbiKHIXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 03:23:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiKHIXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 03:23:51 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E07527B11
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 00:23:50 -0800 (PST)
Received: from localhost.localdomain (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 539C584DEB;
        Tue,  8 Nov 2022 09:23:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1667895827;
        bh=LqPi90TFj/btJkQ9KEUPwwTNS7Kv24Z04/ceO7ccwEQ=;
        h=From:To:Cc:Subject:Date:From;
        b=YJD0ysKD4uOW0MeWNWEW3KOXkMP6AvywAfF4K24EkZTuxCW1+5rKY/vlKZgd1sA8K
         TePilJKKYJIhPXG8crX+wU2wNuH5atxNexGr3bFHxkGrTSVtCVrdFsARKVEqY7o+5l
         EimFTWTTx4btz1imk9izF7j17oy+ZYiTyKAkIcNMRKFQWZh/dQ0Np1l6yNoSrMXzFX
         m7jLxQD9yZ1KToc35CyvvOW9GQM70CE7RHa9GfWitrc6SwM+U4hAajNEkYf7/qrdaQ
         jGQD4b1XbF3I0QpjLNOwMn4/Ji67Bml8Raqv65m4cvR2kmIxN7R18bXbipypTAmWTg
         gNns944IRj+Ag==
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Lukasz Majewski <lukma@denx.de>
Subject: [PATCH 0/9] net: dsa: Add support for mv88e6020 and mv88e6071
Date:   Tue,  8 Nov 2022 09:23:21 +0100
Message-Id: <20221108082330.2086671-1-lukma@denx.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series provides support for Marvell's mv88e6020 and mv 88e6071
switches and can be divided to two parts;

1. Code necessary to support aforementioned switches

2. Driver modification to support proper size of frames for mv88e6071

Lukasz Majewski (5):
  net: dsa: mv88e6xxx: Add support for MV88E6071 switch
  net: dsa: marvell: Provide per device information about max frame size
  net: dsa: mv88e6071: Define max frame size (2048 bytes)
  net: dsa: mv88e6071: Provide struct mv88e6xxx_ops
  net: dsa: mv88e6071: Set .set_max_frame_size callback

Matthias Schiffer (4):
  net: dsa: allow switch drivers to override default slave PHY addresses
  net: dsa: mv88e6xxx: account for PHY base address offset in dual chip
    mode
  net: dsa: mv88e6xxx: implement get_phy_address
  net: dsa: mv88e6xxx: add support for MV88E6020 switch

 drivers/net/dsa/mv88e6xxx/chip.c    | 102 +++++++++++++++++++++++++++-
 drivers/net/dsa/mv88e6xxx/chip.h    |   4 ++
 drivers/net/dsa/mv88e6xxx/global2.c |   2 +-
 drivers/net/dsa/mv88e6xxx/port.h    |   2 +
 drivers/net/dsa/mv88e6xxx/smi.c     |   4 ++
 include/net/dsa.h                   |   1 +
 net/dsa/slave.c                     |   9 ++-
 7 files changed, 119 insertions(+), 5 deletions(-)

-- 
2.37.2

