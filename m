Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA8E656134
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 09:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbiLZIoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 03:44:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiLZIoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 03:44:08 -0500
Received: from forwardcorp1c.mail.yandex.net (forwardcorp1c.mail.yandex.net [178.154.239.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5066A273;
        Mon, 26 Dec 2022 00:44:06 -0800 (PST)
Received: from iva8-3a65cceff156.qloud-c.yandex.net (iva8-3a65cceff156.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:2d80:0:640:3a65:ccef])
        by forwardcorp1c.mail.yandex.net (Yandex) with ESMTP id CC7785EE89;
        Mon, 26 Dec 2022 11:44:01 +0300 (MSK)
Received: from d-tatianin-nix.yandex-team.ru (unknown [2a02:6b8:b081:1::1:f])
        by iva8-3a65cceff156.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id uhJTeY0QhmI1-yzaOKiK0;
        Mon, 26 Dec 2022 11:44:00 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1672044240; bh=95WBhUqQuWLuJqbtsgIW1Evy4AsD29l5Ce6uiLn3sZY=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=b+z1SMM/pLTZppasvfgkwEsguRcV2BvzyY3RjyQ+1bluQSnwZ20Kn1lfu44drySja
         tVO6xkSz7Hd8XIOm2Xt1hyOFmiGpruz0e6WSiVjsoJkmj6qb8MMkY4eHEGdQaxQTXI
         PfzD9JGNOpX3agJeZ+e0VZ++Q3ii4z4gAv5FU/Dg=
Authentication-Results: iva8-3a65cceff156.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From:   Daniil Tatianin <d-tatianin@yandex-team.ru>
To:     netdev@vger.kernel.org
Cc:     Daniil Tatianin <d-tatianin@yandex-team.ru>,
        linux-kernel@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [RESEND PATCH net v1] drivers/net/bonding/bond_3ad: return when there's no aggregator
Date:   Mon, 26 Dec 2022 11:43:53 +0300
Message-Id: <20221226084353.1914921-1-d-tatianin@yandex-team.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Otherwise we would dereference a NULL aggregator pointer when calling
__set_agg_ports_ready on the line below.

Found by Linux Verification Center (linuxtesting.org) with the SVACE
static analysis tool.

Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
---
 drivers/net/bonding/bond_3ad.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index acb6ff0be5ff..320e5461853f 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -1520,6 +1520,7 @@ static void ad_port_selection_logic(struct port *port, bool *update_slave_arr)
 			slave_err(bond->dev, port->slave->dev,
 				  "Port %d did not find a suitable aggregator\n",
 				  port->actor_port_number);
+			return;
 		}
 	}
 	/* if all aggregator's ports are READY_N == TRUE, set ready=TRUE
-- 
2.25.1

