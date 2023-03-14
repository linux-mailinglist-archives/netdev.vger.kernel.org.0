Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B29236B966E
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 14:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbjCNNiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 09:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbjCNNi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 09:38:29 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD82F30FA
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 06:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=k1; bh=Tsk4wHMeWOvTFQfbreaoPUX9miB
        BnSXXC9+icfM7WVE=; b=XJEpL3JliV7UzxDue4nodoey51u7PoDDDKrZD0gbx3V
        AizTC+OfdupQt7y5GvIs3V1OtttbzOWFC6MF51u4MHkO0bQ4dX02ea92gnQIxpG7
        RlUoV62RXRwbgwAaWSXnVGOx0XqgZwXMWP1uOvyE9Gl21YcBQIUY7pX52GgfRUpk
        =
Received: (qmail 3111535 invoked from network); 14 Mar 2023 14:14:55 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 14 Mar 2023 14:14:55 +0100
X-UD-Smtp-Session: l3s3148p1@PKN/A9z2is0ujnvb
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     netdev@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org, kernel@pengutronix.de,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 0/4] net: set 'mac_managed_pm' at probe time
Date:   Tue, 14 Mar 2023 14:14:38 +0100
Message-Id: <20230314131443.46342-1-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When suspending/resuming an interface which was not up, we saw mdiobus
related PM handling despite 'mac_managed_pm' being set for RAVB/SH_ETH.
Heiner kindly suggested the fix to set this flag at probe time, not at
init/open time. I implemented his suggestion and it works fine on these
two Renesas drivers. These are patches 1+2.

I then looked which other drivers could be affected by the same problem.
I could only identify two where I am quite sure. Because I don't have
any HW, I opted to at least add a FIXME and send this out as patches
3+4. Ideally, they will never need to go upstream because the relevant
people will see their patch and do something like I did for patches 1+2.

Looking forward to comments. Thanks and happy hacking!


Wolfram Sang (4):
  ravb: avoid PHY being resumed when interface is not up
  sh_eth: avoid PHY being resumed when interface is not up
  fec: add FIXME to move 'mac_managed_pm' to probe
  smsc911x: add FIXME to move 'mac_managed_pm' to probe

 drivers/net/ethernet/freescale/fec_main.c |  1 +
 drivers/net/ethernet/renesas/ravb_main.c  | 12 ++++++++++--
 drivers/net/ethernet/renesas/sh_eth.c     | 12 ++++++++++--
 drivers/net/ethernet/smsc/smsc911x.c      |  1 +
 4 files changed, 22 insertions(+), 4 deletions(-)

-- 
2.30.2

