Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 507936B2497
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 13:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbjCIMzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 07:55:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbjCIMzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 07:55:08 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EDD57E7B2;
        Thu,  9 Mar 2023 04:55:05 -0800 (PST)
Received: from localhost.localdomain (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 226EC85D80;
        Thu,  9 Mar 2023 13:55:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1678366502;
        bh=Nc+BwLOgr63dxXtrojbXBp3xqZNS8g5qrEkJo497PJE=;
        h=From:To:Cc:Subject:Date:From;
        b=ACMGn5/OFSk2G6d7tF/DnSZYIzGKjnS429dVXcVwZzou7L4pYZX20bI+s56eZYYaW
         2YKIgO8VqfW4Q1qIUwYI1jgF8NjdhzgSulm/pd/XrzxxYfGp8o4PI6lDUklj7agpFY
         91cBR/ynFKHXC0KCACThdt9t/4vSK3J3pRooTWUlfPqkdmzwV06t8SwwXkbYtP9Sbv
         2aNbUpf0RluvRa097OekfMIpDBkE69AkXKbPUwclYAOaay7F6A0tBHOC2pOfpK+0SX
         FpCzeibzUwxoJLJksj73tB+avCulTzXKrIgme7KjFZCekcbiBul9iOh5bo3RBNgZeN
         t5ifr9q2tBekQ==
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukasz Majewski <lukma@denx.de>
Subject: [PATCH 0/7] dsa: marvell: Add support for mv88e6071 and 6020 switches
Date:   Thu,  9 Mar 2023 13:54:14 +0100
Message-Id: <20230309125421.3900962-1-lukma@denx.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set provides following changes:

- Provide support for mv88e6020 and mv88e6071 switch circuits (the
  "Link Street" family of products including added earlier to this
  driver mv88e6250 and mv88e6220).

- Add the max_frame size variable to specify the buffer size for the
  maximal frame size

- The above change required adjusting all supported devices in the
  mv88e6xxx driver, as the current value assignment is depending
  on the set of provided callbacks for each switch circuit - i.e.
  until now the value was not explicitly specified.

- As the driver for Marvell's mv88e6xxx switches was rather complicated
  the intermediate function (removed by the end of this patch set)
  has been introduced. It was supposed to both validate the provided
  values deduced from the code and leave a trace of the exact
  methodology used.

Lukasz Majewski (6):
  dsa: marvell: Provide per device information about max frame size
  net: dsa: mv88e6xxx: add support for MV88E6071 switch
  dsa: marvell: Define .set_max_frame_size() function for mv88e6250 SoC
    family
  dsa: marvell: Add helper function to validate the max_frame_size
    variable
  dsa: marvell: Correct value of max_frame_size variable after
    validation
  dsa: marvell: Modify get max MTU callback to use per switch provided
    value

Matthias Schiffer (1):
  net: dsa: mv88e6xxx: add support for MV88E6020 switch

 drivers/net/dsa/mv88e6xxx/chip.c | 83 ++++++++++++++++++++++++++++++--
 drivers/net/dsa/mv88e6xxx/chip.h |  8 +++
 drivers/net/dsa/mv88e6xxx/port.h |  2 +
 3 files changed, 88 insertions(+), 5 deletions(-)

-- 
2.20.1

