Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68EED4BA3B4
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 15:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240826AbiBQOyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 09:54:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242211AbiBQOyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 09:54:23 -0500
X-Greylist: delayed 493 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 17 Feb 2022 06:54:05 PST
Received: from mail-41103.protonmail.ch (mail-41103.protonmail.ch [185.70.41.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88FDC2B2E06
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 06:54:05 -0800 (PST)
Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        by mail-41103.protonmail.ch (Postfix) with ESMTPS id 4JzyLR0W9Cz4xNN0
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 14:45:51 +0000 (UTC)
Authentication-Results: mail-41103.protonmail.ch;
        dkim=pass (2048-bit key) header.d=casan.se header.i=@casan.se header.b="KJsIbJWe"
Date:   Thu, 17 Feb 2022 14:45:38 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=casan.se;
        s=protonmail; t=1645109145;
        bh=uEhfQisbUYEO18g/ZzqSiEaXXOOBHNxHDNpNypmTATo=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID;
        b=KJsIbJWetMSCS9cA4MzbecHCMewpgFupqEax2ruCdyz2qhw2BY3W05zd7uhgl9pyF
         2aAFDf4je20Quxn33KrExGrtlxzUpNc7Jwnt+pu9RgIeP/3s8ePEIsLXgVLaaoXWqh
         Y10FsRZNNTjtDWTSJVMWGHUWpbfFuzm0TNzEQbFM1so9eP7nK7msn7jhDt0gXlyqh9
         Ov+LXymlZPN3a0NMDMQta0k7jipbAm8GukD10W9tTYDOzaJny/gcWMYB8PiGsc/Xa2
         aGJXuqFhR+3ZgbFagB30iP+0mjI2rBECncMJAvcn3/i4rK2hWKY9j1srSOxV75/2e6
         RGmNgpBUgqPbQ==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com
From:   Casper Andersson <casper@casan.se>
Cc:     netdev@vger.kernel.org
Reply-To: Casper Andersson <casper@casan.se>
Subject: [PATCH net-next] net: sparx5: Support offloading of bridge port flooding flags
Message-ID: <20220217144534.sqntzdjltzvxslqo@wse-c0155>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Though the SparX-5i can control IPv4/6 multicasts separately from non-IP
multicasts, these are all muxed onto the bridge's BR_MCAST_FLOOD flag.

Signed-off-by: Casper Andersson <casper@casan.se>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c b/dri=
vers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
index 649ca609884a..27a9eed38316 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
@@ -22,8 +22,15 @@ struct sparx5_switchdev_event_work {
 static void sparx5_port_attr_bridge_flags(struct sparx5_port *port,
 =09=09=09=09=09  struct switchdev_brport_flags flags)
 {
+=09int pgid;
+
 =09if (flags.mask & BR_MCAST_FLOOD)
-=09=09sparx5_pgid_update_mask(port, PGID_MC_FLOOD, true);
+=09=09for (pgid =3D PGID_MC_FLOOD; pgid <=3D PGID_IPV6_MC_CTRL; pgid++)
+=09=09=09sparx5_pgid_update_mask(port, pgid, !!(flags.val & BR_MCAST_FLOOD=
));
+=09if (flags.mask & BR_FLOOD)
+=09=09sparx5_pgid_update_mask(port, PGID_UC_FLOOD, !!(flags.val & BR_FLOOD=
));
+=09if (flags.mask & BR_BCAST_FLOOD)
+=09=09sparx5_pgid_update_mask(port, PGID_BCAST, !!(flags.val & BR_BCAST_FL=
OOD));
 }

 static void sparx5_attr_stp_state_set(struct sparx5_port *port,
--
2.30.2


